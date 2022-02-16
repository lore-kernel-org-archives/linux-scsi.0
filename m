Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 220A7C43219
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 21:04:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234149AbiBPVEd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 16:04:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234182AbiBPVEI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 16:04:08 -0500
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BC72B0B2F
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:52 -0800 (PST)
Received: by mail-pj1-f46.google.com with SMTP id m7so3653453pjk.0
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n+ftz6rZifOckZ2d1iAwIpAJCAY8J0AJBDadpTM8K0k=;
        b=uwdMntU3GSZzuD/3TI5g2emepJsX5t45IIynkuKOLAZXQrn/E4DFRNOFjJn8M/WZMc
         iLVfI6BiR7pGTg6oGvW0tb+viFNpbxKCKa93GZQfjQ+ELO6ncmjIoUiruARTC6EleIie
         TsUEKEURGo2ru1sAJeGp+/2XXeshv1UICrHPdJ8rmKc1h6sUhHRMRh6Oai5xrUacMkF4
         2K3218znK5EDVc9bg/ahcWMizADKtyliBIbTnG7xbZ3l/bXQg9f4kqvDQSzEHU4Ck8yJ
         PtZeoF4bQd5gY9ncI8vUZ6fcsU33fdmTEIz4qmjdylwvvgBXndHbg8HCZX5BcP/XKO9h
         Md0Q==
X-Gm-Message-State: AOAM531Th8MbDbAKfatPtcuwt5kQ27l5SDhvw5Ls3/7zDHpdL2O204/D
        SMvocu4mwBKAa83CSrAJDObvP4H28+nWMu6Q
X-Google-Smtp-Source: ABdhPJwOyAewVuSZ6T5j69os+/yc9Yo3wzQdpIJpzQX5YI3FcLxh/4sdLmH/lzYUuxLEgUYLUs45dA==
X-Received: by 2002:a17:902:c9c3:b0:14f:e0b:2abe with SMTP id q3-20020a170902c9c300b0014f0e0b2abemr695730pld.114.1645045431749;
        Wed, 16 Feb 2022 13:03:51 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c8sm46591222pfv.57.2022.02.16.13.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 13:03:51 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 33/50] scsi: megaraid: Stop using the SCSI pointer
Date:   Wed, 16 Feb 2022 13:02:16 -0800
Message-Id: <20220216210233.28774-34-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220216210233.28774-1-bvanassche@acm.org>
References: <20220216210233.28774-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
from struct scsi_cmnd.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/megaraid.c | 13 ++++---------
 drivers/scsi/megaraid.h | 23 ++++++++++++++++++++++-
 2 files changed, 26 insertions(+), 10 deletions(-)

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
index cce23a086fbe..013fbfb911b9 100644
--- a/drivers/scsi/megaraid.h
+++ b/drivers/scsi/megaraid.h
@@ -4,6 +4,7 @@
 
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
+#include <scsi/scsi_cmnd.h>
 
 #define MEGARAID_VERSION	\
 	"v2.00.4 (Release Date: Thu Feb 9 08:51:30 EST 2006)\n"
@@ -756,8 +757,28 @@ struct private_bios_data {
 #define CACHED_IO		0
 #define DIRECT_IO		1
 
+struct megaraid_cmd_priv {
+	struct list_head entry;
+};
+
+#define SCSI_LIST(scp)							\
+	(&((struct megaraid_cmd_priv *)scsi_cmd_priv(scp))->entry)
+
+struct scsi_cmd_and_priv {
+	struct scsi_cmnd	 cmd;
+	struct megaraid_cmd_priv priv;
+};
+
+static inline struct scsi_cmnd *
+megaraid_to_scsi_cmd(struct megaraid_cmd_priv *cmd_priv)
+{
+	/* See also scsi_mq_setup_tags() */
+	BUILD_BUG_ON(sizeof(struct scsi_cmd_and_priv) !=
+		     sizeof(struct scsi_cmnd) +
+		     sizeof(struct megaraid_cmd_priv));
 
-#define SCSI_LIST(scp) ((struct list_head *)(&(scp)->SCp))
+	return &container_of(cmd_priv, struct scsi_cmd_and_priv, priv)->cmd;
+}
 
 /*
  * Each controller's soft state
