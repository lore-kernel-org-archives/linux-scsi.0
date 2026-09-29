Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757D03E5EC5
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 08:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790670369; cv=none; b=cK580kvkXaJxcxTZvO0L1yclUZIC2CwHNRr7nUzh/87CxNB2AZRxQ5fmV9+uqLhiJPyITY074Dm6RAwwyRauq1S1VqET/54yUcWtBonBUBXSgoUVh2Z0OBXamLMQgtb45xHWY7gH82rFo+7vxOoH7Y1KanzGlQ0J62wWZ2OCHfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790670369; c=relaxed/simple;
	bh=li0RPIr2uE2T+AaD++AItuCFLtznquCaLs4d3WwV0BY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FdqwekhtZk/3xjS3U0KmEPEqkyborqyzGiCLUc0t7MgxtEGGbHnLFny6IClyXZnOXFRoWejcYnObbhxCBJhMgyG2hGdwPUsUTba9Gp+BFTba9yaZZL4S3gd8gAtI1JOedP8CFEdHdT8UK0Q1UfaeaEJtgtlWjDLort0MEpx1oRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KboLjBJz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KboLjBJz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE471F0089A;
	Tue, 29 Sep 2026 08:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790670368;
	bh=Jy7OjMQYDG+fpamlFUeqjo9sCy5VTOwiod38mYAK8QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KboLjBJzz6fsh2MZzpOQRRycr7Z/KQH/fHBwvHvsGn4xvtFaulrIOGCA9oNTGIQYb
	 71KpGukT+yNN1vQAwUL1Pzslet3A7bpJRYFeHGW3UNE2rOPazC4iJ0FGeoGaPFh8tQ
	 KalZZQyKZc/AJtGdMdepuNjXj0GwPLgG02G/+ZysuVNfc5eNaEKbYmLM6NBdWI1RpX
	 L/cKvwNfgFlUQM7C1rjIP8sIQ6eFaDoO81lCb0IatDSGvPUKN1FAS1Ohr8oYaF4rqv
	 pESTobo3WDgiY/9oR7pjuD9Q3iV5X+t+Z0uzfoVg/JTNmB83v5RqZmqwoG7yEMABsn
	 5TIC3rtK0SpZg==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v11 04/13] scsi: scsi_debug: Take the zone metadata lock before the data lock
Date: Tue, 29 Sep 2026 10:25:01 +0200
Message-ID: <20260929082456.857423-19-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260929082456.857423-15-cassel@kernel.org>
References: <20260929082456.857423-15-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2333; i=cassel@kernel.org; h=from:subject; bh=li0RPIr2uE2T+AaD++AItuCFLtznquCaLs4d3WwV0BY=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ2l74xuL1X8s9ZMR31hOUvOT4e2lK1XrPT/nilyXPJo Ej7AgfOjlIWBjEuBlkxRRbfHy77i7vdpxxXvGMDM4eVCWQIAxenAEwkZBrDP3X37HXxG0osl9Y1 tE+aFP6GxXW6ri23qOmehi+ip7dv4GNkWBudzzXz5r29jW9VG0zNI9sPWafJ7znGc/HyJR/+2HB BFgA=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

resp_comp_write() takes the data lock and then the zone metadata lock,
while every other command that takes both takes the metadata lock first
and reaches the data lock through do_device_access(). A COMPARE AND
WRITE and any other write to the same store can therefore deadlock each
other.

Take the locks in the same order as everywhere else.

Correct the comment above map_region() while here: the provisioning map
is covered by the metadata lock rather than the data lock, which is why
resp_unmap() takes only the metadata lock.

Assisted-by: LLM
Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Tested with:

  modprobe scsi_debug sector_size=512 dev_size_mb=128 lbpu=1 lbpws=1

COMPARE AND WRITE completes, and a READ(16) of the block that it wrote
returns, so the reordered locks are still taken and released correctly.

The deadlock itself was not reproduced. This kernel is built without
lockdep, and the window needs a COMPARE AND WRITE and another write to
the same store to interleave between the two acquisitions. Found by
review.
---
 drivers/scsi/scsi_debug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index f7c71fcc53fd..7152496952da 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5575,8 +5575,8 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 			    "indicated=%u, IO sent=%d bytes\n", my_name,
 			    dnum * lb_size, ret);
 
-	sdeb_data_write_lock(sip);
 	sdeb_meta_write_lock(sip);
+	sdeb_data_write_lock(sip);
 	if (!comp_write_worker(sip, lba, num, arr, false)) {
 		mk_sense_buffer(scp, MISCOMPARE,
 				MISCOMPARE_DURING_VERIFY_OPERATION);
@@ -5584,12 +5584,12 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 		goto cleanup_unlock;
 	}
 
-	/* Cover sip->map_storep (which map_region()) sets with data lock */
+	/* Cover sip->map_storep (which map_region() sets) with the meta lock */
 	if (scsi_debug_lbp())
 		map_region(sip, lba, num);
 cleanup_unlock:
-	sdeb_meta_write_unlock(sip);
 	sdeb_data_write_unlock(sip);
+	sdeb_meta_write_unlock(sip);
 cleanup_free:
 	kfree(arr);
 	return retval;
-- 
2.55.0

