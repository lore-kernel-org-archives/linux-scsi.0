Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FCA3590A9
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2026 20:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774988595; cv=none; b=X32IrARJAWEeU1Rpnx0FAgu6b7D407bNAo8koYKTtofNl1GT6JS+S3wnci3CjrCIPj/gfGnjHNNut/98QizA3obuw1siI/Szd4tngvjWS28iQicaElv4pQTx8wUm84sDmf5GEcOYKmVpxAJG0THNReFR9sdFynWw5Q5rwLaraKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774988595; c=relaxed/simple;
	bh=saT+/5DWY4yZcdZjnVC39+My3k+qHuFTIE2C1Q/Q++Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KPODvWOzc1Mvd9JqbTcFVFA8H6WjLQp5mpumJ5ykLZNiEjAvNmFrkTJ5yp618BZUPFTTAI3qGqv2qeOajHbFT5oDjbx6FyosHJtNDyGI39OELQe6cT15FVj+Sl/0851+6hDESYPyerKYKhotzH0L0dkhRkLZdp5ilONx2ctIsL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QQ5wFXNc; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QQ5wFXNc"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8a016799d2cso38522156d6.1
        for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2026 13:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774988593; x=1775593393; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=04Exlu3o2HeehVhNJ4vyP5GGhi8AWOiwn112dweg9HI=;
        b=QQ5wFXNcpGmv4yniCWFNr1AuGuxblDttu52EWQy8GXfrPqhB3cbq2GS5uUHiygaJ4B
         mpf9cwuiNQVwctP6SNmtJuZje1fvmi+YiC0mKDOVmMqhqEvWUAL4qKXa1WBV66jCouXL
         Ddvd3H/biBmfXI1Y+dCfBhi8kvNpLcfyucMyDb0Lbx6IyAlqGwxoCXep2o/dg98mFUmQ
         gKEQGann0mvomYeZNIkQ9H1hFHYcAzvfe6/1ZOqPLVn3czI5O/4RnfebiKxGDSC++c45
         Vo7m2m29h1WsPOf5fAyunmRuMxYygNVhVyVOiJ/ZXUb5xbkyPkLjK48EqKmLpg2Dy5Bc
         7fdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774988593; x=1775593393;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=04Exlu3o2HeehVhNJ4vyP5GGhi8AWOiwn112dweg9HI=;
        b=NHjoTHGCxvWE6AtU/BvjeyZDxJoHM/ze2wki9KBTillBUhlLn6xojuWQb/BfpGEMXG
         vwss/6GfPIjxdpb+nXLHvA2p1+FnqLy6BorbMJ5cKJFiKAS0LdIeyucPLOiUUGRwF4Xb
         nBX9CNQ4AK91cdUfVk8uQLweEpPXXzikYI8EsgLcwIrMf9u4zvsegqkoW18wUcvbQQ86
         9hi5WAfMVLT4rX1FW1yL7BSBP3N/xE6x0EV49e6BrT1YyaCmbfPx/GWJgwW/kxYMsREi
         nvv2MbphycV43aUBFBplhSguAVB73hSEQozaMBht5DzcJ8USN2zts4s1RbVnGfzhTwoB
         qqOA==
X-Gm-Message-State: AOJu0YxwcH9ywABh1Ek92ueFbil0lp6kN3seEfjxz6cpssTpH8Ks0krY
	Pz1mSPzgKuymUALnoeO4PUVezSrkXOCzJBd207fAT3UxPdz92ZGcO6LINRKgAg==
X-Gm-Gg: ATEYQzxoyz6K8uthEuFAbTp1WsXIOeQZaznVlgxyXeS9/roTuWHD/bMliQGLUEboBsk
	66K44U6AkYEE2Ic8Pqvn0sayZpmD3SQIvEUTawrHuUN7TuwFFxpFBBDcU6Oqp2ZC8AXp4BLdNq7
	7Zgu4C5+mj1of7UsJ8Qd568Jo/XtFlrHnV2lGBVz0qsMdnrTtNBg/HkzHiqRz/dkea8ZvAvWnx2
	y1lUMdXfUYmoDrdwmlrGGNdKPJ6ld9qgFmIKbUrsGHI8pJT6JD+pXV5H6cMfVrFIKwSTFSIV6TJ
	cOecOc5gOqn8sBHxYVOlpE6h1bwhT1yfFl2w2Z1WFVqeUsspIkfDMzv2VAjKtvQtWC0ZKfhrcBD
	YIz9ze6mp+3Qkc6AOrcxR3/Uh8TOTVbFH0RWsvCdVAvMZAYwOq0j44dHGBxPWsnJ3H2SruInMu/
	4FtY9Oz0y5umf5G4AGCkYY0gKNecG4hnN4JgNNO/+OC1iBQd9kJxLZWrT2jTO/Toub0lXyXYNtZ
	sMWlmOLmxGM8AJZsZxxH5IJpduG+BGHABmkjF9t9mI=
X-Received: by 2002:a05:6214:5184:b0:89c:cb57:6214 with SMTP id 6a1803df08f44-8a43ab47dccmr14485876d6.50.1774988592900;
        Tue, 31 Mar 2026 13:23:12 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89ecf865ccesm96685616d6.39.2026.03.31.13.23.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Mar 2026 13:23:12 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 07/10] lpfc: Check ASIC_ID register to aid diagnostics during failed fw updates
Date: Tue, 31 Mar 2026 13:59:25 -0700
Message-Id: <20260331205928.119833-8-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260331205928.119833-1-justintee8345@gmail.com>
References: <20260331205928.119833-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When WRITE_OBJECT mailbox command fails during firmware update, the
lpfc_log_write_firmware_error routine is used to log and parse commonly
found error codes.  Update this routine to also include ASIC_ID register
checks for notifying users of incompatible images.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hw4.h  | 20 ++++++++++++++++++--
 drivers/scsi/lpfc/lpfc_init.c | 19 ++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_sli4.h |  1 +
 3 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 0e11701b0881..f91bde4a6c38 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -100,7 +100,8 @@ struct lpfc_sli_intf {
 #define lpfc_sli_intf_sli_family_MASK		0x0000000F
 #define lpfc_sli_intf_sli_family_WORD		word0
 #define LPFC_SLI_INTF_FAMILY_BE2	0x0
-#define LPFC_SLI_INTF_FAMILY_BE3	0x1
+#define LPFC_SLI_INTF_ASIC_ID		0x1	/* Refer to ASIC_ID register */
+#define LPFC_SLI_INTF_FAMILY_BE3	0x3
 #define LPFC_SLI_INTF_FAMILY_LNCR_A0	0xa
 #define LPFC_SLI_INTF_FAMILY_LNCR_B0	0xb
 #define LPFC_SLI_INTF_FAMILY_G6		0xc
@@ -118,6 +119,17 @@ struct lpfc_sli_intf {
 #define LPFC_SLI_INTF_IF_TYPE_VIRT	1
 };
 
+struct lpfc_asic_id {
+	u32 word0;
+#define lpfc_asic_id_gen_num_SHIFT	8
+#define lpfc_asic_id_gen_num_MASK	0x000000FF
+#define lpfc_asic_id_gen_num_WORD	word0
+#define LPFC_SLI_INTF_FAMILY_G8		0x10
+#define lpfc_asic_id_rev_num_SHIFT	0
+#define lpfc_asic_id_rev_num_MASK	0x000000FF
+#define lpfc_asic_id_rev_num_WORD	word0
+};
+
 #define LPFC_SLI4_MBX_EMBED	true
 #define LPFC_SLI4_MBX_NEMBED	false
 
@@ -624,6 +636,10 @@ struct lpfc_register {
 
 #define LPFC_PORT_SEM_UE_RECOVERABLE    0xE000
 #define LPFC_PORT_SEM_MASK		0xF000
+
+/* The following are config space register offsets */
+#define LPFC_ASIC_ID_OFFSET		0x0308
+
 /* The following BAR0 Registers apply to SLI4 if_type 0 UCNAs. */
 #define LPFC_UERR_STATUS_HI		0x00A4
 #define LPFC_UERR_STATUS_LO		0x00A0
@@ -632,7 +648,6 @@ struct lpfc_register {
 
 /* The following BAR0 register sets are defined for if_type 0 and 2 UCNAs. */
 #define LPFC_SLI_INTF			0x0058
-#define LPFC_SLI_ASIC_VER		0x009C
 
 #define LPFC_CTL_PORT_SEM_OFFSET	0x400
 #define lpfc_port_smphr_perr_SHIFT	31
@@ -4965,6 +4980,7 @@ union lpfc_wqe128 {
 #define MAGIC_NUMBER_G6 0xFEAA0003
 #define MAGIC_NUMBER_G7 0xFEAA0005
 #define MAGIC_NUMBER_G7P 0xFEAA0020
+#define MAGIC_NUMBER_G8 0xFEAA0070
 
 struct lpfc_grp_hdr {
 	uint32_t size;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 8e5f00e6abe0..fd6b48e46a69 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11793,6 +11793,7 @@ lpfc_sli4_pci_mem_setup(struct lpfc_hba *phba)
 	unsigned long bar0map_len, bar1map_len, bar2map_len;
 	int error;
 	uint32_t if_type;
+	u8 sli_family;
 
 	if (!pdev)
 		return -ENODEV;
@@ -11823,6 +11824,14 @@ lpfc_sli4_pci_mem_setup(struct lpfc_hba *phba)
 		return -ENODEV;
 	}
 
+	/* Check if ASIC_ID register should be read */
+	sli_family = bf_get(lpfc_sli_intf_sli_family, &phba->sli4_hba.sli_intf);
+	if (sli_family == LPFC_SLI_INTF_ASIC_ID) {
+		if (pci_read_config_dword(pdev, LPFC_ASIC_ID_OFFSET,
+					  &phba->sli4_hba.asic_id.word0))
+			return -ENODEV;
+	}
+
 	if_type = bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf);
 	/*
 	 * Get the bus address of SLI4 device Bar regions and the
@@ -14480,6 +14489,12 @@ lpfc_log_write_firmware_error(struct lpfc_hba *phba, uint32_t offset,
 	u8 sli_family;
 
 	sli_family = bf_get(lpfc_sli_intf_sli_family, &phba->sli4_hba.sli_intf);
+
+	/* Refer to ASIC_ID register case */
+	if (sli_family == LPFC_SLI_INTF_ASIC_ID)
+		sli_family = bf_get(lpfc_asic_id_gen_num,
+				    &phba->sli4_hba.asic_id);
+
 	/* Three cases:  (1) FW was not supported on the detected adapter.
 	 * (2) FW update has been locked out administratively.
 	 * (3) Some other error during FW update.
@@ -14492,7 +14507,9 @@ lpfc_log_write_firmware_error(struct lpfc_hba *phba, uint32_t offset,
 	    (sli_family == LPFC_SLI_INTF_FAMILY_G7 &&
 	     magic_number != MAGIC_NUMBER_G7) ||
 	    (sli_family == LPFC_SLI_INTF_FAMILY_G7P &&
-	     magic_number != MAGIC_NUMBER_G7P)) {
+	     magic_number != MAGIC_NUMBER_G7P) ||
+	    (sli_family == LPFC_SLI_INTF_FAMILY_G8 &&
+	     magic_number != MAGIC_NUMBER_G8)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 				"3030 This firmware version is not supported on"
 				" this HBA model. Device:%x Magic:%x Type:%x "
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 0aa105cab125..036760702ecc 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -838,6 +838,7 @@ struct lpfc_sli4_hba {
 	uint32_t ue_to_sr;
 	uint32_t ue_to_rp;
 	struct lpfc_register sli_intf;
+	struct lpfc_register asic_id;
 	struct lpfc_pc_sli4_params pc_sli4_params;
 	struct lpfc_bbscn_params bbscn_params;
 	struct lpfc_hba_eq_hdl *hba_eq_hdl; /* HBA per-WQ handle */
-- 
2.38.0

