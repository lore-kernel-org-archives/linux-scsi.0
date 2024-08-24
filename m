Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE37154C07;
	Sat, 24 Aug 2024 09:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724491929; cv=none; b=MrFV/z+9a2EKj8jowrOj7dTvjpq7yMFuV7xai2Y3ohpGk8mfSIpWbGPkpy2jDXXGfZu8a1Cuoq2nuLd7FsWImpdS+2T4QZwitxK7UiZqwdjCfGFm+fJ9tx9R9ycxAz1XJ0X7ZBwQ1RWRJtbiz2ZnvcDjPcaVYVp6ajGrDupR3tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724491929; c=relaxed/simple;
	bh=Pj2luHvGlqBcDKojBjrHzyQeu8NZG68U/HgycL/DRCY=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=LatytIV88NtWj79pT6oo0Ix2lQSebPBGnroiTmfTuDUrZAMRmh4QxBfr8i4Vzmv4ggNQ+B5v/1z1Baur61sEZOOIIDG69dJ50gNW+to2q7pn4v3GPXGCUv3vFJPvUFB4e+4W0EG3HE6Fx77+ZwW7IPEgmRQqJzbobe7Q1MGg2CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=SPNCNhJC; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=SPNCNhJC; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="SPNCNhJC";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="SPNCNhJC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1724491925;
	bh=Pj2luHvGlqBcDKojBjrHzyQeu8NZG68U/HgycL/DRCY=;
	h=Message-ID:Subject:From:To:Date:From;
	b=SPNCNhJCIY5QN9fuMqTMzJv/CWYWjrM5gmte19oYsOPyP61/fzzKebN0KGYB914ZF
	 7Txsw5yZ+kRncINeG+PeLNj59Q5Mn88WH5zu+WpCMj89A+MVGssN663nBEZt4l1eBC
	 BDIwFeJuOYOVVjy4Ja8NUQ3PJW0mxw1ez58i1Zpk=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id A01711286700;
	Sat, 24 Aug 2024 05:32:05 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id jIxEa7uVgfaL; Sat, 24 Aug 2024 05:32:05 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1724491925;
	bh=Pj2luHvGlqBcDKojBjrHzyQeu8NZG68U/HgycL/DRCY=;
	h=Message-ID:Subject:From:To:Date:From;
	b=SPNCNhJCIY5QN9fuMqTMzJv/CWYWjrM5gmte19oYsOPyP61/fzzKebN0KGYB914ZF
	 7Txsw5yZ+kRncINeG+PeLNj59Q5Mn88WH5zu+WpCMj89A+MVGssN663nBEZt4l1eBC
	 BDIwFeJuOYOVVjy4Ja8NUQ3PJW0mxw1ez58i1Zpk=
Received: from [IPv6:2a00:23c8:1007:7701:19d1:8255:2991:876d] (unknown [IPv6:2a00:23c8:1007:7701:19d1:8255:2991:876d])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 39110128650C;
	Sat, 24 Aug 2024 05:32:03 -0400 (EDT)
Message-ID: <2e030c4ab1abd1a0d0b03bae6667be5ef0d9e817.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 6.11-rc4
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Sat, 24 Aug 2024 10:31:59 +0100
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The important core fix is another tweak to our discard discovery
issues.  The off by 512 in logical block count seems bad, but in fact
the inline was only ever used in debug prints, which is why no-one
noticed.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Chaotian Jing (1):
      scsi: core: Fix the return value of scsi_logical_block_count()

Manivannan Sadhasivam (2):
      scsi: ufs: qcom: Add UFSHCD_QUIRK_BROKEN_LSDBS_CAP for SM8550 SoC
      scsi: ufs: core: Add a quirk for handling broken LSDBS field in controller capabilities register

Martin K. Petersen (1):
      scsi: sd: Do not attempt to configure discard unless LBPME is set

Simon Horman (1):
      scsi: MAINTAINERS: Add header files to SCSI SUBSYSTEM

Yihang Li (1):
      scsi: MAINTAINERS: Update HiSilicon SAS controller driver maintainer

And the diffstat:

 MAINTAINERS                 | 3 ++-
 drivers/scsi/sd.c           | 3 +++
 drivers/ufs/core/ufshcd.c   | 6 +++++-
 drivers/ufs/host/ufs-qcom.c | 6 +++++-
 include/scsi/scsi_cmnd.h    | 2 +-
 include/ufs/ufshcd.h        | 8 ++++++++
 6 files changed, 24 insertions(+), 4 deletions(-)

With full diff below.

James

---

diff --git a/MAINTAINERS b/MAINTAINERS
index 42decde38320..9a33ab69abab 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10173,7 +10173,7 @@ F:	Documentation/devicetree/bindings/infiniband/hisilicon-hns-roce.txt
 F:	drivers/infiniband/hw/hns/
 
 HISILICON SAS Controller
-M:	Xiang Chen <chenxiang66@hisilicon.com>
+M:	Yihang Li <liyihang9@huawei.com>
 S:	Supported
 W:	http://www.hisilicon.com
 F:	Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
@@ -20351,6 +20351,7 @@ F:	Documentation/devicetree/bindings/scsi/
 F:	drivers/scsi/
 F:	drivers/ufs/
 F:	include/scsi/
+F:	include/uapi/scsi/
 
 SCSI TAPE DRIVER
 M:	Kai Mäkisara <Kai.Makisara@kolumbus.fi>
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 699f4f9674d9..dad3991397cf 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3308,6 +3308,9 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 
 static unsigned int sd_discard_mode(struct scsi_disk *sdkp)
 {
+	if (!sdkp->lbpme)
+		return SD_LBP_FULL;
+
 	if (!sdkp->lbpvpd) {
 		/* LBP VPD page not provided */
 		if (sdkp->max_unmap_blocks)
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0b3d0c8e0dda..a6f818cdef0e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2426,7 +2426,11 @@ static inline int ufshcd_hba_capabilities(struct ufs_hba *hba)
 	 * 0h: legacy single doorbell support is available
 	 * 1h: indicate that legacy single doorbell support has been removed
 	 */
-	hba->lsdb_sup = !FIELD_GET(MASK_LSDB_SUPPORT, hba->capabilities);
+	if (!(hba->quirks & UFSHCD_QUIRK_BROKEN_LSDBS_CAP))
+		hba->lsdb_sup = !FIELD_GET(MASK_LSDB_SUPPORT, hba->capabilities);
+	else
+		hba->lsdb_sup = true;
+
 	if (!hba->mcq_sup)
 		return 0;
 
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 810e637047d0..c87fdc849c62 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -857,6 +857,9 @@ static void ufs_qcom_advertise_quirks(struct ufs_hba *hba)
 
 	if (host->hw_ver.major > 0x3)
 		hba->quirks |= UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH;
+
+	if (of_device_is_compatible(hba->dev->of_node, "qcom,sm8550-ufshc"))
+		hba->quirks |= UFSHCD_QUIRK_BROKEN_LSDBS_CAP;
 }
 
 static void ufs_qcom_set_phy_gear(struct ufs_qcom_host *host)
@@ -1847,7 +1850,8 @@ static void ufs_qcom_remove(struct platform_device *pdev)
 }
 
 static const struct of_device_id ufs_qcom_of_match[] __maybe_unused = {
-	{ .compatible = "qcom,ufshc"},
+	{ .compatible = "qcom,ufshc" },
+	{ .compatible = "qcom,sm8550-ufshc" },
 	{},
 };
 MODULE_DEVICE_TABLE(of, ufs_qcom_of_match);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 45c40d200154..8ecfb94049db 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -234,7 +234,7 @@ static inline sector_t scsi_get_lba(struct scsi_cmnd *scmd)
 
 static inline unsigned int scsi_logical_block_count(struct scsi_cmnd *scmd)
 {
-	unsigned int shift = ilog2(scmd->device->sector_size) - SECTOR_SHIFT;
+	unsigned int shift = ilog2(scmd->device->sector_size);
 
 	return blk_rq_bytes(scsi_cmd_to_rq(scmd)) >> shift;
 }
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index cac0cdb9a916..0fd2aebac728 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -676,6 +676,14 @@ enum ufshcd_quirks {
 	 * the standard best practice for managing keys).
 	 */
 	UFSHCD_QUIRK_KEYS_IN_PRDT			= 1 << 24,
+
+	/*
+	 * This quirk indicates that the controller reports the value 1 (not
+	 * supported) in the Legacy Single DoorBell Support (LSDBS) bit of the
+	 * Controller Capabilities register although it supports the legacy
+	 * single doorbell mode.
+	 */
+	UFSHCD_QUIRK_BROKEN_LSDBS_CAP			= 1 << 25,
 };
 
 enum ufshcd_caps {

