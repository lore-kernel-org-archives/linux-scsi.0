Return-Path: <SRS0=3hcu=W6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B19DFC3A5A2
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Sep 2019 16:37:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F30A204EC
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Sep 2019 16:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567528675;
	bh=FL0R0ieMlAqeFeTgj/WE4/2JzRGpRQvBCF/ziATjPCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=FHafIkD2PjHthse7XBMrM5mWRjSctzBE9Yj6XgaU+5hfpIqfdSjy7UcDNCmB7E2vS
	 8fNSiFP8IsknhLDx4V9p11J7cOrwyOOLF4br3ewahw+jR5PpvFG1i7zo4HR5Z0i/Pc
	 LH9Qhf+lHZmHiIuoI6B0OMNo7Bu/T4XoOEv4fUXY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730791AbfICQhy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Sep 2019 12:37:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730629AbfICQ00 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 3 Sep 2019 12:26:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17E5D238CE;
        Tue,  3 Sep 2019 16:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527985;
        bh=FL0R0ieMlAqeFeTgj/WE4/2JzRGpRQvBCF/ziATjPCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S+Xomodswd4lGFkf38Ki6LFPNFajUWNXPUyOZjrUnWvwy8DVDNs3MVYOmB9ceHE1b
         zKHSnnoDYxvtN6uHD92x82RnXQl2bsoSa0YuAlBMR4fK4OwqouEu78/ZhQ/oFpGFjs
         45x2GkcUQys1YBziSNze9wydujV29FGkZ0oDYfcA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 040/167] scsi: megaraid_sas: Fix combined reply queue mode detection
Date:   Tue,  3 Sep 2019 12:23:12 -0400
Message-Id: <20190903162519.7136-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

[ Upstream commit e29c322133472628c6de85efb99ccd3b3df5571e ]

For Invader series, if FW supports more than 8 MSI-x vectors, driver needs
to enable combined reply queue mode. For Ventura series, driver enables
combined reply queue mode in case of more than 16 MSI-x vectors.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 806ceabcabc3f..b6fc7c6337610 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5325,12 +5325,29 @@ static int megasas_init_fw(struct megasas_instance *instance)
 				instance->msix_vectors = (scratch_pad_2
 					& MR_MAX_REPLY_QUEUES_OFFSET) + 1;
 				fw_msix_count = instance->msix_vectors;
-			} else { /* Invader series supports more than 8 MSI-x vectors*/
+			} else {
 				instance->msix_vectors = ((scratch_pad_2
 					& MR_MAX_REPLY_QUEUES_EXT_OFFSET)
 					>> MR_MAX_REPLY_QUEUES_EXT_OFFSET_SHIFT) + 1;
-				if (instance->msix_vectors > 16)
-					instance->msix_combined = true;
+
+				/*
+				 * For Invader series, > 8 MSI-x vectors
+				 * supported by FW/HW implies combined
+				 * reply queue mode is enabled.
+				 * For Ventura series, > 16 MSI-x vectors
+				 * supported by FW/HW implies combined
+				 * reply queue mode is enabled.
+				 */
+				switch (instance->adapter_type) {
+				case INVADER_SERIES:
+					if (instance->msix_vectors > 8)
+						instance->msix_combined = true;
+					break;
+				case VENTURA_SERIES:
+					if (instance->msix_vectors > 16)
+						instance->msix_combined = true;
+					break;
+				}
 
 				if (rdpq_enable)
 					instance->is_rdpq = (scratch_pad_2 & MR_RDPQ_MODE_OFFSET) ?
-- 
2.20.1

