Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83437C4321A
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 09:47:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C1C064F10
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 09:47:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbhCRJq4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 05:46:56 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:58592 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229805AbhCRJqf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Mar 2021 05:46:35 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 876CA41360;
        Thu, 18 Mar 2021 09:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1616060792; x=1617875193; bh=K6inxgYh4U7Pbx7USRmQS5P/FwdaKkgelkR
        CHeHtt+g=; b=f+vsX3+gkQoaV8KbOkStX1iRNe4YNfGDJfMPS1XO0n1UOSmoqFZ
        2Z2FofZuc0R40/4dBH/dMF9ZJYxdjXfe5pP8mhgWgn6oVVK9hADmiIeoarhfApaj
        imGN14ENDvFr/BQP94N2IO18+LacqwZYy/sfXpJBKsjllyKn06AL0ZG0=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id sUGKAjMLtaFZ; Thu, 18 Mar 2021 12:46:32 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id E4A7E41390;
        Thu, 18 Mar 2021 12:44:20 +0300 (MSK)
Received: from yadro.com (10.199.0.137) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 18
 Mar 2021 12:44:19 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux@yadro.com>, <linux-scsi@vger.kernel.org>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH 1/2] target: Add the DUMMY flag to rd_mcp
Date:   Thu, 18 Mar 2021 12:42:24 +0300
Message-ID: <20210318094224.17524-2-k.shelekhin@yadro.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210318094224.17524-1-k.shelekhin@yadro.com>
References: <20210318094224.17524-1-k.shelekhin@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.137]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This commit adds the DUMMY flag to the rd_mcp backend that forces a
logical unit to report itself as not connected device of an unknown
type. Essentially this allows users to create devices identical to the
device for the virtual LUN 0, making it possible to explicitly create a
LUN 0 device and configure it's WWNs (e.g. vendor or product name).

Signed-off-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/target/target_core_rd.c | 27 +++++++++++++++++++++++----
 drivers/target/target_core_rd.h |  1 +
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index bf936bbeccfe..cdc5c3bc4b07 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -530,12 +530,13 @@ rd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 }
 
 enum {
-	Opt_rd_pages, Opt_rd_nullio, Opt_err
+	Opt_rd_pages, Opt_rd_nullio, Opt_rd_dummy, Opt_err
 };
 
 static match_table_t tokens = {
 	{Opt_rd_pages, "rd_pages=%d"},
 	{Opt_rd_nullio, "rd_nullio=%d"},
+	{Opt_rd_dummy, "rd_dummy=%d"},
 	{Opt_err, NULL}
 };
 
@@ -574,6 +575,14 @@ static ssize_t rd_set_configfs_dev_params(struct se_device *dev,
 			pr_debug("RAMDISK: Setting NULLIO flag: %d\n", arg);
 			rd_dev->rd_flags |= RDF_NULLIO;
 			break;
+		case Opt_rd_dummy:
+			match_int(args, &arg);
+			if (arg != 1)
+				break;
+
+			pr_debug("RAMDISK: Setting DUMMY flag: %d\n", arg);
+			rd_dev->rd_flags |= RDF_DUMMY;
+			break;
 		default:
 			break;
 		}
@@ -590,12 +599,22 @@ static ssize_t rd_show_configfs_dev_params(struct se_device *dev, char *b)
 	ssize_t bl = sprintf(b, "TCM RamDisk ID: %u  RamDisk Makeup: rd_mcp\n",
 			rd_dev->rd_dev_id);
 	bl += sprintf(b + bl, "        PAGES/PAGE_SIZE: %u*%lu"
-			"  SG_table_count: %u  nullio: %d\n", rd_dev->rd_page_count,
+			"  SG_table_count: %u  nullio: %d dummy: %d\n",
+			rd_dev->rd_page_count,
 			PAGE_SIZE, rd_dev->sg_table_count,
-			!!(rd_dev->rd_flags & RDF_NULLIO));
+			!!(rd_dev->rd_flags & RDF_NULLIO),
+			!!(rd_dev->rd_flags & RDF_DUMMY));
 	return bl;
 }
 
+static u32 rd_get_device_type(struct se_device *dev)
+{
+	if (RD_DEV(dev)->rd_flags & RDF_DUMMY)
+		return 0x3f; /* Unknown device type, not connected */
+	else
+		return TYPE_DISK;
+}
+
 static sector_t rd_get_blocks(struct se_device *dev)
 {
 	struct rd_dev *rd_dev = RD_DEV(dev);
@@ -647,7 +666,7 @@ static const struct target_backend_ops rd_mcp_ops = {
 	.parse_cdb		= rd_parse_cdb,
 	.set_configfs_dev_params = rd_set_configfs_dev_params,
 	.show_configfs_dev_params = rd_show_configfs_dev_params,
-	.get_device_type	= sbc_get_device_type,
+	.get_device_type	= rd_get_device_type,
 	.get_blocks		= rd_get_blocks,
 	.init_prot		= rd_init_prot,
 	.free_prot		= rd_free_prot,
diff --git a/drivers/target/target_core_rd.h b/drivers/target/target_core_rd.h
index 8b88f9b14c3f..9ffda5c4b584 100644
--- a/drivers/target/target_core_rd.h
+++ b/drivers/target/target_core_rd.h
@@ -28,6 +28,7 @@ struct rd_dev_sg_table {
 
 #define RDF_HAS_PAGE_COUNT	0x01
 #define RDF_NULLIO		0x02
+#define RDF_DUMMY		0x04
 
 struct rd_dev {
 	struct se_device dev;
-- 
2.30.2

