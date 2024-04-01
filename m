Received: from ns2.wdyn.eu (ns2.wdyn.eu [5.252.227.236])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0F741171A;
	Mon,  1 Apr 2024 10:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.252.227.236
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711965811; cv=none; b=VnybXX7NbR4sd4Wl5IM2iLUlXkiwf06TIJWwMd/biSVobnfBPvlkljaI+5jO9E8WaA8K9qwHJGnVS6ZZwGbBF+juAv8G6ovYihEBUeisEI8NNVKkp5C4xz3yPEJRyFTa6BJoazUecbw0gha3skzC1BYgPnptR9Xn3+YLfP0pCNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711965811; c=relaxed/simple;
	bh=YIceQqgjbT2hYX+XMuDAks+pSm299AXzqKHWNQ7zWIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=McKrWlJxOamKl81mIRIuUdlRbQhAgR8tRb/rhI9rU+st/7BoCyAJxtO5jLUSYfH6WKu82Z9//tZ1B5mJeSKVanvPBhoOOsmO9UjMWTM0hLSBvns/AXUFEG2e53WvUXmFu8gdCSQtB/r6eYSGPTB90/7PQmPwG3BYXvHRA00eVGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wetzel-home.de; spf=pass smtp.mailfrom=wetzel-home.de; dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b=HyZ3+wUO; arc=none smtp.client-ip=5.252.227.236
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wetzel-home.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wetzel-home.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="HyZ3+wUO"
From: Alexander Wetzel <Alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
	s=wetzel-home; t=1711965805;
	bh=YIceQqgjbT2hYX+XMuDAks+pSm299AXzqKHWNQ7zWIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HyZ3+wUOE1J8aCCaD2RmFIWApWdPzjqOEMBAEc9NQpg0xbCCRzxPnyraO1vba5uSz
	 oYoOUxWNLVog0Nlu8vrSfuNxgqpHHCkLtu8hzWUGixhiWFRev2gHKMzQN8IwhmejcP
	 fimgcIjmwBCQehD9o9Dq9XQDsHTO9P/Ot9EXJMek=
To: dgilbert@interlog.com
Cc: gregkh@linuxfoundation.org,
	sachinp@linux.ibm.com,
	Alexander@wetzel-home.de,
	bvanassche@acm.org,
	linux-scsi@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	martin.petersen@oracle.com,
	stable@vger.kernel.org
Subject: [PATCH v2] scsi: sg: Avoid race in error handling & drop bogus warn
Date: Mon,  1 Apr 2024 12:03:17 +0200
Message-ID: <20240401100317.5395-1-Alexander@wetzel-home.de>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <81266270-42F4-48F9-9139-8F0C3F0A6553@linux.ibm.com>
References: <81266270-42F4-48F9-9139-8F0C3F0A6553@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 27f58c04a8f4 ("scsi: sg: Avoid sg device teardown race")
introduced an incorrect WARN_ON_ONCE() and missed a sequence where
sg_device_destroy() was used after scsi_device_put().

sg_device_destroy() is accessing the parent scsi_device request_queue which
will already be set to NULL when the preceding call to scsi_device_put()
removed the last reference to the parent scsi_device.

Drop the incorrect WARN_ON_ONCE() - allowing more than one concurrent
access to the sg device - and make sure sg_device_destroy() is not used
after scsi_device_put() in the error handling.

Link: https://lore.kernel.org/all/5375B275-D137-4D5F-BE25-6AF8ACAE41EF@linux.ibm.com
Fixes: 27f58c04a8f4 ("scsi: sg: Avoid sg device teardown race")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Wetzel <Alexander@wetzel-home.de>
---

Changes compared to V1: fixed commit message

The WARN_ON_ONCE() was kind of stupid to add:
We get add reference for each sg_open(). So opening a second session and
then closing either one will trigger the warning... Nothing to warn
about here.

Alexander
---
 drivers/scsi/sg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 386981c6976a..833c9277419b 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -372,8 +372,9 @@ sg_open(struct inode *inode, struct file *filp)
 error_out:
 	scsi_autopm_put_device(sdp->device);
 sdp_put:
+	kref_put(&sdp->d_ref, sg_device_destroy);
 	scsi_device_put(sdp->device);
-	goto sg_put;
+	return retval;
 }
 
 /* Release resources associated with a successful sg_open()
@@ -2233,7 +2234,6 @@ sg_remove_sfp_usercontext(struct work_struct *work)
 			"sg_remove_sfp: sfp=0x%p\n", sfp));
 	kfree(sfp);
 
-	WARN_ON_ONCE(kref_read(&sdp->d_ref) != 1);
 	kref_put(&sdp->d_ref, sg_device_destroy);
 	scsi_device_put(device);
 	module_put(THIS_MODULE);
-- 
2.44.0

