Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF43AC4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 22:34:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354129AbiBKWeY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 17:34:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345288AbiBKWeW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 17:34:22 -0500
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72DFD57
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:34:12 -0800 (PST)
Received: by mail-pj1-f54.google.com with SMTP id q11-20020a17090a304b00b001b94d25eaecso5603085pjl.4
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:34:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n+ftz6rZifOckZ2d1iAwIpAJCAY8J0AJBDadpTM8K0k=;
        b=R2faCWfH3nvAuzz+dGocfvV038DM3+KpJ0bZ7e0Z3USGFhnq8N1+ehSkE1rGevRglA
         VfULGXjV+DRSJ9gOCcaHdh0jtJ+UWeo2G7u82n6r43v9su8990tld+fRfFy4v9eLKz1s
         VdM3ub/WaUtXQEU23Rvjz6MhdOwF7H+mgLL8iADLKa8P2CH4oy3KYFII4EI/aKQ8lCS8
         XlD4cuHJHGBfRD+iSmbnszb/yNA45Eb09Ef5EqRSgOo+hZCj43OHD+44hGr946zLtoPL
         tJHjXmbU6HTRKkXJFJlZhHI8Iss3gtPCF10eIQFdExUR33PuGQmP0kFanXrlj9NpVkzU
         Ceqg==
X-Gm-Message-State: AOAM531YSSPyHNAi4sK1WlPY7Hnqh/NxhxPjVzS4L62HrQOv4PTU5eca
        t4jjbj5rO8K6h9OAj1aFShU=
X-Google-Smtp-Source: ABdhPJwHozS+6aSE/zE7ATFsjtOlOE8md/DuIqqfEJfJnoo5ykaqvsYF5QZD4H5O4+YP2fYmGNavAw==
X-Received: by 2002:a17:902:cec4:: with SMTP id d4mr3447803plg.158.1644618852096;
        Fri, 11 Feb 2022 14:34:12 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id n13sm6296733pjq.13.2022.02.11.14.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 14:34:11 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 31/48] scsi: megaraid: Stop using the SCSI pointer
Date:   Fri, 11 Feb 2022 14:32:30 -0800
Message-Id: <20220211223247.14369-32-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220211223247.14369-1-bvanassche@acm.org>
References: <20220211223247.14369-1-bvanassche@acm.org>
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
