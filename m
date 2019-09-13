Return-Path: <SRS0=Er8N=XI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACCD7C4CEC5
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Sep 2019 13:05:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85AA1206BB
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Sep 2019 13:05:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="YCjfbV0j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388226AbfIMNFY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Sep 2019 09:05:24 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33672 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387533AbfIMNFY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Sep 2019 09:05:24 -0400
Received: by mail-pl1-f195.google.com with SMTP id t11so13221214plo.0
        for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2019 06:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nF4pPTdBa4lzcPkGV3lnV7l1njdYOU5p16G8/xw5G0k=;
        b=YCjfbV0jinqJF9DGqcZ8Gjn1AfQ5VF3cno2kYNUZ/ZrkjF3lhHTFx8YrbJjb70Aw2W
         FyT6Q9g0HCxWdvHlyYMzEnGIfheV46zUUF1zs94cf5WUy7dablfYOqHZ7uiGxpKml9Nn
         eCQBCAfOOjahJ+QpLTg2e3FagGIR80qZrgT38=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nF4pPTdBa4lzcPkGV3lnV7l1njdYOU5p16G8/xw5G0k=;
        b=cAs6aN1oNdlH7b0v1Lx8cLNXPHXtT6tc+jOqjiBAh5nrG8oifQruLdOq8ZAZOE6GSv
         9s/9WivwG1NuVammAp/haxy7yVPxcVvAUmGDmzhGiQxBIXLtxZqhnfhLWQE4vV7qxehg
         z6dh+mdxNSKqerTxA6nLop9WQgiy0b3GLcLPyOc+cNO+QgFH5F6QKIh/f3bSb72LPehz
         50NEHOjIypXr+qZjTqjvWlrUmn22hITUadKuMFczLRf2E/PGfmaIZBhIroyWZguNJft3
         mqMpM3cPFg7WOHz83anI7MQccz1dvSDOu65UxxvCyytmDmmWwKz4mqNnbQC+OyUUVIpR
         vamQ==
X-Gm-Message-State: APjAAAW3kEMkX7K9Y+4XtNdYPetbE3mDttVuxVe5UpCeBYdsh6KRpQha
        W5dgtYKEhM+62RYhq2heOAPWnA==
X-Google-Smtp-Source: APXvYqxgu2wkwL4+Lq4w7wa4OAsLlgOlJMJSzxhaSwEVhrQkZqil/yom0Nl8mh+ucZ6jGJk31hWeWQ==
X-Received: by 2002:a17:902:7596:: with SMTP id j22mr36513907pll.280.1568379923283;
        Fri, 13 Sep 2019 06:05:23 -0700 (PDT)
Received: from dhcp-10-123-20-15.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 69sm37208841pfb.145.2019.09.13.06.05.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 06:05:22 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, suganath-prabu.subramani@broadcom.com,
        sathya.prakash@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 10/13] mpt3sas: Use Component img header to get Package ver
Date:   Fri, 13 Sep 2019 09:04:47 -0400
Message-Id: <1568379890-18347-11-git-send-email-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568379890-18347-1-git-send-email-sreekanth.reddy@broadcom.com>
References: <1568379890-18347-1-git-send-email-sreekanth.reddy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The firmware image layout has been changed for
Aero controllers. All compatible HBA's has to get
Firmware Package version from Component Image
Header layout.

The Signature field in FW header is set to
0xEB000042 for products compatible with Component
Image Header.

For compatible Controllers, Driver fetches firmware
package version from ApplicationSpecific field of
Component Image Header.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 848f211..6eb0cef 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4240,10 +4240,12 @@ _base_display_OEMs_branding(struct MPT3SAS_ADAPTER *ioc)
 	static int
 _base_display_fwpkg_version(struct MPT3SAS_ADAPTER *ioc)
 {
-	Mpi2FWImageHeader_t *FWImgHdr;
+	Mpi2FWImageHeader_t *fw_img_hdr;
+	Mpi26ComponentImageHeader_t *cmp_img_hdr;
 	Mpi25FWUploadRequest_t *mpi_request;
 	Mpi2FWUploadReply_t mpi_reply;
 	int r = 0;
+	u32  package_version = 0;
 	void *fwpkg_data = NULL;
 	dma_addr_t fwpkg_data_dma;
 	u16 smid, ioc_status;
@@ -4300,14 +4302,26 @@ _base_display_fwpkg_version(struct MPT3SAS_ADAPTER *ioc)
 			ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 						MPI2_IOCSTATUS_MASK;
 			if (ioc_status == MPI2_IOCSTATUS_SUCCESS) {
-				FWImgHdr = (Mpi2FWImageHeader_t *)fwpkg_data;
-				if (FWImgHdr->PackageVersion.Word) {
-					ioc_info(ioc, "FW Package Version (%02d.%02d.%02d.%02d)\n",
-						 FWImgHdr->PackageVersion.Struct.Major,
-						 FWImgHdr->PackageVersion.Struct.Minor,
-						 FWImgHdr->PackageVersion.Struct.Unit,
-						 FWImgHdr->PackageVersion.Struct.Dev);
-				}
+				fw_img_hdr = (Mpi2FWImageHeader_t *)fwpkg_data;
+				if (le32_to_cpu(fw_img_hdr->Signature) ==
+				    MPI26_IMAGE_HEADER_SIGNATURE0_MPI26) {
+					cmp_img_hdr =
+					    (Mpi26ComponentImageHeader_t *)
+					    (fwpkg_data);
+					package_version =
+					    le32_to_cpu(
+					    cmp_img_hdr->ApplicationSpecific);
+				} else
+					package_version =
+					    le32_to_cpu(
+					    fw_img_hdr->PackageVersion.Word);
+				if (package_version)
+					ioc_info(ioc,
+					"FW Package Ver(%02d.%02d.%02d.%02d)\n",
+					((package_version) & 0xFF000000) >> 24,
+					((package_version) & 0x00FF0000) >> 16,
+					((package_version) & 0x0000FF00) >> 8,
+					(package_version) & 0x000000FF);
 			} else {
 				_debug_dump_mf(&mpi_reply,
 						sizeof(Mpi2FWUploadReply_t)/4);
-- 
1.8.3.1

