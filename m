Return-Path: <SRS0=QSS4=3W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 686A2C3524B
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Feb 2020 10:47:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C537215A4
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Feb 2020 10:47:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="NEYYS0yS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgBBKrN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Feb 2020 05:47:13 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:8763 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbgBBKrM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Feb 2020 05:47:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1580640432; x=1612176432;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=J2CwgzRWIYLSpvNnhogUm4kTDIqaX6TbFTnNTEDWAng=;
  b=NEYYS0yStIFG5a8v3DypvNeG6ePOORRf6VN8X9BVSUSnESZd+SDvFXaH
   Aur+kvSWyxBUyQCJdq20y8Bv8B5EnPy+DZYzJ4ItfEb0cH0oNjVdD2oPO
   sNio0VaroaEaU2vt1Ru0m4n+lcC67/DGr61LkD2FHprOAwRx4nvh8PAUx
   EKY/mIm40z/cnq0x+buQM77eAS8lI2GnHozPqFFZ83dcsVvA8EYDvAieI
   4ZHcIyHJeeI0ZoCJro2pKEdXBDROUvsqxCt3nVohxlMacS96Qv/scdvHA
   seOTNlzMUBvtQaNFno/c/AQyWuUpOaQ6GMvt8mWDyCXiei8o4k44QI3KF
   Q==;
IronPort-SDR: 9N3CId4iBGeAfTN6iwOyIjBZiX41yMjDoShj0fJ+6RJ6kohTKT48IJYrjnE/JXVyIXOiO3tiHI
 xWfzJAtnE4ioa68pmgA2rCwbVoorWSM7aT2hSOuXxvYJMlSDyg3O9oGeWvkEIupRM5R9Jg6YNy
 O/qlL/D7Fncw+djM+FImWuR6mYu4Z13Q+zSONQCjeRR8yfrEE/nVCUSMp3oU2oI3yYFTY3Uads
 Q5cs0VGKIWyK4qOz8YnqrGekzwNYuyO09xx8fWCZlEuK/j6nNsxH87MSijMWtmv0nK00ad9cRe
 o5k=
X-IronPort-AV: E=Sophos;i="5.70,393,1574092800"; 
   d="scan'208";a="128925966"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 02 Feb 2020 18:47:12 +0800
IronPort-SDR: 5ERP2Q8gQ8NTzx1jJiz0l8330Zm6/PFHwxslNwbI39/dKqQM8D4Co0yOoe5JrpBpjCwWfmGdZ6
 r/bfvohnk8WMR897xWnlIYK7721WQnlA622gKmNdBS800Kt20IR8bfcF1ocm9RCLX/CVUEIHAr
 x8SO1wZI7tR3RF1ukuzaR2DKOZvPxEftRfveRI710pUvofb7fXgQGugftX1qeP4uENS0fGuKGT
 lRT+RE0OvYWWjgffPv7ilFpRENgf/EH6C4HK4I8CFHfils7XUHE7cEiHagmal3mv5gu5C3SOW+
 F/w9jwKdwNFannv9+jffV6lh
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2020 02:40:18 -0800
IronPort-SDR: v9StwYbNRIXVJgoMCNjN/p540DuYQ6dEPr2ehSkEdcAj6ExJ1+ZQA/W3ZrYMbpRS3MuBPASYn1
 zNIzwF5erou1zbSxrTDkaup0vZcHI7ATdFoTlYezsZ6GYdisKOznsWGOClUikzHS99yqGVDqye
 wiF+3jP/EJYzh7ej4bCBZMLpSMhQShpVMpP/1hkaSrNV8lC3I90FClpBOMYoZ4WHXEQvAlBLft
 iUMCPsnj/voD/RS+APLR+HM7FZaq0Oj0Y6ZmeCAzN26i+TOvpC9JP67CxHAX1fk4qr7g/9rtay
 ZjQ=
WDCIronportException: Internal
Received: from kfae419068.sdcorp.global.sandisk.com ([10.0.231.195])
  by uls-op-cesaip01.wdc.com with ESMTP; 02 Feb 2020 02:47:09 -0800
From:   Avi Shchislowski <avi.shchislowski@wdc.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Avi Shchislowski <avi.shchislowski@wdc.com>,
        Uri Yanai <uri.yanai@wdc.com>
Subject: [PATCH 2/5] scsi: ufs: export ufshcd_enable_ee
Date:   Sun,  2 Feb 2020 12:46:56 +0200
Message-Id: <1580640419-6703-3-git-send-email-avi.shchislowski@wdc.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1580640419-6703-1-git-send-email-avi.shchislowski@wdc.com>
References: <1580640419-6703-1-git-send-email-avi.shchislowski@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

export ufshcd_enable_ee so that other modules can use it. this will
come handy in the next patch where we will need it to enable thermal
support

Signed-off-by: Uri Yanai <uri.yanai@wdc.com>
Signed-off-by: Avi Shchislowski <avi.shchislowski@wdc.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 drivers/scsi/ufs/ufshcd.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 099d2de..f25b93c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4923,7 +4923,7 @@ static int ufshcd_disable_ee(struct ufs_hba *hba, u16 mask)
  *
  * Returns zero on success, non-zero error value on failure.
  */
-static int ufshcd_enable_ee(struct ufs_hba *hba, u16 mask)
+int ufshcd_enable_ee(struct ufs_hba *hba, u16 mask)
 {
 	int err = 0;
 	u32 val;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 28c0063..6d2a5fd 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -960,6 +960,8 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 			     u8 *desc_buff, int *buff_len,
 			     enum query_opcode desc_op);
 
+int ufshcd_enable_ee(struct ufs_hba *hba, u16 mask);
+
 /* Wrapper functions for safely calling variant operations */
 static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
 {
-- 
1.9.1

