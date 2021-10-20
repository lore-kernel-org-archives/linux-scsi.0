Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 696EBC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:41:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5119561372
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:41:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbhJTVnr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 17:43:47 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:41864 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbhJTVnr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Oct 2021 17:43:47 -0400
Received: by mail-pl1-f181.google.com with SMTP id e10so12170594plh.8
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 14:41:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Oav/RezsIHYfvqCfEFGaER/UQeyBEj7IbHUjsNTPizw=;
        b=bBaro/IJD0Rs3gWlBR3Ueus/fZ9PWTyZrDg0LVBNnjTcQ4RuS++tbjuRnUFNHvcqLx
         8Uscs3i/Be6QzQeHcnX2V4+TlngSSQ7j41nM/HJqxYvRAF1aZoN2LdpTN3pMvcJf0zpv
         fLqpXAyfgORQ+rkbJjW7WWeMuUG2njJWpIxQ0Ps4pQY5+0nDC11XEzooMNcMtS9vMQGP
         BYviIS4DuUkPL3xwIJ9mv9BPOPDuGjmqTXLk/7lWdgXMYdUjWd4tjC2L+N5Ibd0qU5Do
         Q3UqhKXc2GjquMGmzQVVyu2mnpuz6qwlgPKWT2LKp6X+kIGsu2xn4viQJS212SbkzzdR
         kmww==
X-Gm-Message-State: AOAM530ZBIU4hRpKo709KwOKIHmvdf40vmd9TRWr1yA6sEXkU3gUkhys
        zBtaMreG4qCDiVkIwu758jw=
X-Google-Smtp-Source: ABdhPJyXuOH6hQXrB+G2NDYsi1lL53st9Y8Oi2lMjEu0Zicf2wzav1+5RN7f2SjScAEhL4zEji/t6g==
X-Received: by 2002:a17:90b:193:: with SMTP id t19mr1742199pjs.95.1634766092069;
        Wed, 20 Oct 2021 14:41:32 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:200d:62ea:db33:9047])
        by smtp.gmail.com with ESMTPSA id 21sm6707694pjg.57.2021.10.20.14.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 14:41:31 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Caleb Connolly <caleb@connolly.tech>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH v2 10/10] scsi: ufs: Micro-optimize ufshcd_map_sg()
Date:   Wed, 20 Oct 2021 14:40:24 -0700
Message-Id: <20211020214024.2007615-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211020214024.2007615-1-bvanassche@acm.org>
References: <20211020214024.2007615-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace two cpu_to_le32() calls by a single cpu_to_le64() call.

Additionally, issue a warning if the length of an scatter gather list
element exceeds what is allowed by the UFSHCI specification.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 19 +++++++++++++------
 drivers/scsi/ufs/ufshci.h |  6 ++----
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index dde4d3f607f2..04cb67995750 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2379,12 +2379,19 @@ static int ufshcd_map_sg(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		prd_table = lrbp->ucd_prdt_ptr;
 
 		scsi_for_each_sg(cmd, sg, sg_segments, i) {
-			prd_table[i].size  =
-				cpu_to_le32(((u32) sg_dma_len(sg))-1);
-			prd_table[i].base_addr =
-				cpu_to_le32(lower_32_bits(sg->dma_address));
-			prd_table[i].upper_addr =
-				cpu_to_le32(upper_32_bits(sg->dma_address));
+			const unsigned int len = sg_dma_len(sg);
+
+			/*
+			 * From the UFSHCI spec: "Data Byte Count (DBC): A '0'
+			 * based value that indicates the length, in bytes, of
+			 * the data block. A maximum of length of 256KB may
+			 * exist for any entry. Bits 1:0 of this field shall be
+			 * 11b to indicate Dword granularity. A value of '3'
+			 * indicates 4 bytes, '7' indicates 8 bytes, etc."
+			 */
+			WARN_ONCE(len > 256 * 1024, "len = %#x\n", len);
+			prd_table[i].size = cpu_to_le32(len - 1);
+			prd_table[i].addr = cpu_to_le64(sg->dma_address);
 			prd_table[i].reserved = 0;
 		}
 	} else {
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index f66cf9e477cb..6a295c88d850 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -415,14 +415,12 @@ enum {
 
 /**
  * struct ufshcd_sg_entry - UFSHCI PRD Entry
- * @base_addr: Lower 32bit physical address DW-0
- * @upper_addr: Upper 32bit physical address DW-1
+ * @addr: Physical address; DW-0 and DW-1.
  * @reserved: Reserved for future use DW-2
  * @size: size of physical segment DW-3
  */
 struct ufshcd_sg_entry {
-	__le32    base_addr;
-	__le32    upper_addr;
+	__le64    addr;
 	__le32    reserved;
 	__le32    size;
 };
