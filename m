Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C3F201278
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 07:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790320672; cv=none; b=XuZ3cVytzQAE33Ov4FtxDVqI2wbgLqeSDI5taYnN+OWEN9pmOE6jbg1WQfURBMCHQDuJp5rdzya5NHCY5X39myoAPZ5RN9JrTNGTjm8caOY5FiZhA1YTHi0h0wIC2WudHmwPMisC9zfImHBMfwfF2dCXluLmvBPVwnj+/nvrShI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790320672; c=relaxed/simple;
	bh=nmjuZFO0BBFM5JvVGrYoomOd2fuI7TM3QkSgOhiuq0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i3cRJcMVwJzGg0yYr6w276V/qQEb6VMDRy2OEV4Si67KQYZhDfwhyWn9hNYVP2r09fa8SSuJ0Y6nbwI3JxydlX7zZ20qeeQ0hKiqSjMbanhpF4FHP1OHFqAv5GjCVBtY5ZrvBCEDTGv9SYY2/S7HK3mg+fYgWaIoCcAmlv1UH3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jjyYLr+Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jjyYLr+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A691F00893;
	Fri, 25 Sep 2026 07:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790320671;
	bh=QhOtyp16dNvAdT5Q2z+76wjxjhZTGlHPBTMwV1uyT0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jjyYLr+YUJDsKfuNJHHJ64+6rRRiu7PQ2jJPwKewuUni2JUSR0MdZYRwYrj40Ul8t
	 thoRw0k/iAx8NPyJwLtk2sZ2i+8fpzvQThnLR8REw47WZf4kDRsOMUkW0vKLKp01vc
	 Q49nYp0CLH3bxkEVECB97SjbqI7T0HIYzrQmovlGnbgWr4EEVMDRpN9GXw1BvSuAct
	 Bz4YIB5f49JgzCaFxSGDA/b2lblQ0909B3qs6F1qUVWUSoHtUfYku5WXPrBRyCBsPN
	 GgLDn81tCaIOkP3ysZ/syUw2CFs6UfRyhYzgt0uRQpyDzmo/16zLGaELYtThg/Iaju
	 /KTFqv5dOsrVg==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v7 03/11] scsi: scsi_debug: Take the zone metadata lock before the data lock
Date: Fri, 25 Sep 2026 09:17:30 +0200
Message-ID: <20260925071726.140915-16-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260925071726.140915-13-cassel@kernel.org>
References: <20260925071726.140915-13-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2333; i=cassel@kernel.org; h=from:subject; bh=nmjuZFO0BBFM5JvVGrYoomOd2fuI7TM3QkSgOhiuq0s=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLK2KQhtz9qm5VQkEm0/4QHzJN363CUvtc6cejllou6/y yLcFtG2HaUsDGJcDLJiiiy+P1z2F3e7TzmueMcGZg4rE8gQBi5OAZhIpCAjw6fVWwTqt156f1Mi 7/6rt1e3LEzqTMmdvsxzPhvDVuOfPd2MDF+Ffnsn3ti77PnfpWv3mDzeLtOh6iURt7yt7M5xzSU 2hTwA
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

