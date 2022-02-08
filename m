Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB456C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 17:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384350AbiBHR0x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 12:26:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384335AbiBHR0c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 12:26:32 -0500
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD3BC06174F
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 09:26:32 -0800 (PST)
Received: by mail-pf1-f178.google.com with SMTP id d187so20031669pfa.10
        for <linux-scsi@vger.kernel.org>; Tue, 08 Feb 2022 09:26:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9IL9tHc14FmQi0+RjSHI3rLR/ceDBOB44oUv+jbPYsc=;
        b=hc94gQvLynWI2H/fzifTOE/HELAOC20FXZKnscR64EZ1zgxkYjjpR0lYB7G69sHmCy
         ZII7v/+KxYARx0tuLUjM+yvgOLbxJQQomep7/YPgFyjjkxr/2ECczpDEnzBJtsx/q7Wa
         PR+xtor60dn0Mee98k5ad4z4yp+O6DIxQLk2XPIs+ZXNix7EHGpuvj6aCyr5BTC0WDv3
         NKqXyt9/fFtDPFptvwYF7U3THnnrP6kGTHsJHcMaz49Gj1p138q18WViiysEf48hCZyh
         ygbAaML2iTGCqkn15OdxAAjVWHlUp4OgJHvtc7y6NCURE+0zYHON5AtwwFhWlC9armBi
         VV9Q==
X-Gm-Message-State: AOAM533I4jBP7LckL/RrKSmL+hm67QFJy8eI++CZG3zYGb9XDto1zbfB
        PJRTZCrrd4Vj9nNDTpuKlDevSBC0icvPd6on
X-Google-Smtp-Source: ABdhPJyhMNoaEz3xOZFi/q8+tuE8rNKDGj58McPwJLDfvX7WmdtKtPokzfacIAH/pUv34sCLgHxWNA==
X-Received: by 2002:a05:6a00:1914:: with SMTP id y20mr5172567pfi.41.1644341191514;
        Tue, 08 Feb 2022 09:26:31 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q1sm335116pfs.112.2022.02.08.09.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 09:26:30 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 27/44] megaraid: Stop using the SCSI pointer
Date:   Tue,  8 Feb 2022 09:24:57 -0800
Message-Id: <20220208172514.3481-28-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220208172514.3481-1-bvanassche@acm.org>
References: <20220208172514.3481-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
from struct scsi_cmnd.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/megaraid.c | 13 ++++---------
 drivers/scsi/megaraid.h | 15 ++++++++++++++-
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 2061e3fe9824..a5d8cee2d510 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -1644,16 +1644,10 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 static void
 mega_rundoneq (adapter_t *adapter)
 {
-	struct scsi_cmnd *cmd;
-	struct list_head *pos;
+	struct megaraid_cmd_priv *cmd_priv;
 
-	list_for_each(pos, &adapter->completed_list) {
-
-		struct scsi_pointer* spos = (struct scsi_pointer *)pos;
-
-		cmd = list_entry(spos, struct scsi_cmnd, SCp);
-		scsi_done(cmd);
-	}
+	list_for_each_entry(cmd_priv, &adapter->completed_list, entry)
+		scsi_done(megaraid_to_scsi_cmd(cmd_priv));
 
 	INIT_LIST_HEAD(&adapter->completed_list);
 }
@@ -4123,6 +4117,7 @@ static struct scsi_host_template megaraid_template = {
 	.eh_bus_reset_handler		= megaraid_reset,
 	.eh_host_reset_handler		= megaraid_reset,
 	.no_write_same			= 1,
+	.cmd_size			= sizeof(struct megaraid_cmd_priv),
 };
 
 static int
diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
index cce23a086fbe..be809ccb757e 100644
--- a/drivers/scsi/megaraid.h
+++ b/drivers/scsi/megaraid.h
@@ -4,6 +4,7 @@
 
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
+#include <scsi/scsi_cmnd.h>
 
 #define MEGARAID_VERSION	\
 	"v2.00.4 (Release Date: Thu Feb 9 08:51:30 EST 2006)\n"
@@ -756,8 +757,20 @@ struct private_bios_data {
 #define CACHED_IO		0
 #define DIRECT_IO		1
 
+struct megaraid_cmd_priv {
+	struct list_head entry;
+};
+
+#define SCSI_LIST(scp)							\
+	(&((struct megaraid_cmd_priv *)scsi_cmd_priv(scp))->entry)
+
+static inline struct scsi_cmnd *
+megaraid_to_scsi_cmd(struct megaraid_cmd_priv *cmd_priv)
+{
+	struct scsi_cmnd *cmd = (void *)cmd_priv;
 
-#define SCSI_LIST(scp) ((struct list_head *)(&(scp)->SCp))
+	return cmd - 1;
+}
 
 /*
  * Each controller's soft state
