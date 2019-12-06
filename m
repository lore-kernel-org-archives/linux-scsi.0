Return-Path: <SRS0=vR/u=Z4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B140FC43603
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Dec 2019 02:32:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 870CE2075C
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Dec 2019 02:32:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="J4+5j2tX";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="av8IuSlc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbfLFCcF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Dec 2019 21:32:05 -0500
Received: from a27-11.smtp-out.us-west-2.amazonses.com ([54.240.27.11]:55848
        "EHLO a27-11.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726160AbfLFCcF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Dec 2019 21:32:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1575599524;
        h=From:To:Cc:Subject:Date:Message-Id;
        bh=dbpQ33z0+MU9P4fX+5DhPUfJ1DnpVxYrmcfpMV8MJaI=;
        b=J4+5j2tXiA8fSOxzRwBXkhxhFSPJ7hFwa2L2jF63lKosOWWgoCCJMwHZj8dYHbd4
        zSBRbhcxOQpMcXQ4iK2wF2m+Ht2uGSW3FxtvzHWFDNbqyPMrdaDsSV5uDRL9m0TjFPH
        WHv/DhkjTY/gdEtdsa+HjEK3g6UKfniV1HZY1lok=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1575599524;
        h=From:To:Cc:Subject:Date:Message-Id:Feedback-ID;
        bh=dbpQ33z0+MU9P4fX+5DhPUfJ1DnpVxYrmcfpMV8MJaI=;
        b=av8IuSlcY46Zd9obFJpbpiy/vBakrI94qBLC/sy6rVV/9wDGeLqYl78Ax630M4bP
        hJh7shrH7j32Quc3XwvSIzbdd+HFhmS0GkSYXRosO3bCmcblcLwssTkaekz/8h4gb7b
        6XvNruGFtB6BJlZVdXxXdBDRxaPHSGMT8+Nocap0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 921A8C4479F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] scsi: ufs: Export query request interfaces
Date:   Fri, 6 Dec 2019 02:32:04 +0000
Message-ID: <0101016ed90ccaa9-28e4056b-b182-4739-80e0-c9f1dff0f257-000000@us-west-2.amazonses.com>
X-Mailer: git-send-email 1.9.1
X-SES-Outgoing: 2019.12.06-54.240.27.11
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Vendor drivers may need to send query requests in proprietary
implementations. Hence, export the query request interfaces
so that vendor drivers can use them.

Signed-off-by: Can Guo <cang@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c449b68..0d1667d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2737,7 +2737,7 @@ static inline void ufshcd_init_query(struct ufs_hba *hba,
 	(*request)->upiu_req.selector = selector;
 }
 
-static int ufshcd_query_flag_retry(struct ufs_hba *hba,
+int ufshcd_query_flag_retry(struct ufs_hba *hba,
 	enum query_opcode opcode, enum flag_idn idn, bool *flag_res)
 {
 	int ret;
@@ -2759,6 +2759,7 @@ static int ufshcd_query_flag_retry(struct ufs_hba *hba,
 			__func__, opcode, idn, ret, retries);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(ufshcd_query_flag_retry);
 
 /**
  * ufshcd_query_flag() - API function for sending flag query requests
@@ -2826,6 +2827,7 @@ int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 	ufshcd_release(hba);
 	return err;
 }
+EXPORT_SYMBOL_GPL(ufshcd_query_flag);
 
 /**
  * ufshcd_query_attr - API function for sending attribute requests
@@ -2890,6 +2892,7 @@ int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 	ufshcd_release(hba);
 	return err;
 }
+EXPORT_SYMBOL_GPL(ufshcd_query_attr);
 
 /**
  * ufshcd_query_attr_retry() - API function for sending query
@@ -2904,7 +2907,7 @@ int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
  *
  * Returns 0 for success, non-zero in case of failure
 */
-static int ufshcd_query_attr_retry(struct ufs_hba *hba,
+int ufshcd_query_attr_retry(struct ufs_hba *hba,
 	enum query_opcode opcode, enum attr_idn idn, u8 index, u8 selector,
 	u32 *attr_val)
 {
@@ -2927,6 +2930,7 @@ static int ufshcd_query_attr_retry(struct ufs_hba *hba,
 			__func__, idn, ret, QUERY_REQ_RETRIES);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(ufshcd_query_attr_retry);
 
 static int __ufshcd_query_descriptor(struct ufs_hba *hba,
 			enum query_opcode opcode, enum desc_idn idn, u8 index,
@@ -3024,6 +3028,7 @@ int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(ufshcd_query_descriptor_retry);
 
 /**
  * ufshcd_read_desc_length - read the specified descriptor length from header
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index e0fe247..a1d27e6 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -923,8 +923,13 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 			   u8 param_size);
 int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 		      enum attr_idn idn, u8 index, u8 selector, u32 *attr_val);
+int ufshcd_query_attr_retry(struct ufs_hba *hba, enum query_opcode opcode,
+			    enum attr_idn idn, u8 index, u8 selector,
+			    u32 *attr_val);
 int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 	enum flag_idn idn, bool *flag_res);
+int ufshcd_query_flag_retry(struct ufs_hba *hba, enum query_opcode opcode,
+			    enum flag_idn idn, bool *flag_res);
 
 #define SD_ASCII_STD true
 #define SD_RAW false
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

