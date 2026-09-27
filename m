Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E7254707C
	for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2026 05:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790486831; cv=none; b=tHIRLaES9gwRdeZVoaFZWo+GeVJ6aBsY3UAOafcs2iYhsyPtvjSMNN960EKzERS43bf0F6mbbNjriCjINcwoixlGKOsHrMpD5GN5K0QrnzXYzbgpzHhqEBkuD2n4BoIq3DRHqyL3ZHlUwPpTKwd5vymNWgAVMCheHSeYSE3vMkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790486831; c=relaxed/simple;
	bh=nmjuZFO0BBFM5JvVGrYoomOd2fuI7TM3QkSgOhiuq0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=juuDsaRh7Kfz2mEqHOK+2Ba6UjExpoPaPWbqlMEJLvzlidLM8IyptaG0m100cF62YOIXehGTPfG9+XrH0U6tqy8ze5YQEH55L/MvxTAN0LUmU0WUiZueraLYAXkz3ENJEL6Jx3lEfMAq/mPrbViaCUw8XUK8m5BnskUvuJxj7kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TjBOE9ey; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TjBOE9ey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BAE21F00893;
	Sun, 27 Sep 2026 05:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790486829;
	bh=QhOtyp16dNvAdT5Q2z+76wjxjhZTGlHPBTMwV1uyT0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TjBOE9eynHc7yov00OlFwtEuq4R1toCmmuGZGmly8kUEzOLbT9bAFVwEWLdMdOBCm
	 2MmcfQtWSwNVV1/2wxhIHcqW1HrZiwHksknBknq7jGqKFf3mUnbJqOt+Cp9pFCX6X/
	 Vk/VxeAKg8wnxbmbTqHs5ItsG7WtL2I3XASXobWiWAuxJiAwzKtU8ryJnLwM1rpSsK
	 MVY569Hvs8ytHVrm3H+QcecVfH8t7NHewSjbNXWtQ0298s+DEC5rhussxTWVrb3/xb
	 FbtnGw56HQSEAGsTsRJazV5ig20KesOrbVgZWvvYPP9g2mH9EzrT3XTYiY3xF+H2pi
	 va7Xjr9duodkA==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v9 03/11] scsi: scsi_debug: Take the zone metadata lock before the data lock
Date: Sun, 27 Sep 2026 07:26:54 +0200
Message-ID: <20260927052650.567035-16-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260927052650.567035-13-cassel@kernel.org>
References: <20260927052650.567035-13-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2333; i=cassel@kernel.org; h=from:subject; bh=nmjuZFO0BBFM5JvVGrYoomOd2fuI7TM3QkSgOhiuq0s=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ2rFTYnrVNy6lIJNp+wgPmSbr1uUteap059XLKRN1/l 0W4LaJtO0pZGMS4GGTFFFl8f7jsL+52n3Jc8Y4NzBxWJpAhDFycAjCR2UwM/2tCbEREnxTnrf13 adeNuXb39zx+mGmz7sJNNrWlvbPy/low/BVZHfmqIe/+0R8L/hVznLi8VbJJ0PzHHPFlyZIWW9i C93EAAA==
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
index 8e45a57ae406..18aefe83b7b6 100644
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

