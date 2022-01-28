Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 447A8C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 22:22:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349121AbiA1WWB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:22:01 -0500
Received: from mail-pl1-f171.google.com ([209.85.214.171]:34754 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351056AbiA1WVa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 17:21:30 -0500
Received: by mail-pl1-f171.google.com with SMTP id h14so7479059plf.1
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2022 14:21:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1N1bD9uOZGT/r0qwm1wzZtUQC4ygWsDathu9sa6lxFE=;
        b=EY3pVjpdpr+QqxZ8kL2DVKpRd2duH5j4HvYoxUIBkfzVHEPVYtjWDJpuCL3j9og5Zi
         6YMEIsJfyiJKIO2cA0btmd6lbaXJjCLYmG6mCkLoGPSCXBESz1/uAwPe9wtCvx1D6MOq
         FZwp55XUWTDsFkX1sWrJkGyV8jG7YGouOtj85hIOtmuCQG3LuVm0Y/dRwez4lq5PSx7G
         T7dI4XctXfUNHQktzbGu/IaLOo+hcrMbQzQUZbImcGGBEBNPjU4rA7isKBTjzj6FNfKh
         StdvGi4Rz4E1zL+RXNctP7U+lovWgxwJK7giaBJfCEfK6vvsBHrsrphu6ISTtaWR6KG5
         vyyA==
X-Gm-Message-State: AOAM532EkV1BBaPMd54sw0tpIzDNhTEObUcJ4w87uuYo+DFHuBdOK9iu
        2a//zdR3gbywZ8REaoZHm9MK2QRM96YJvw==
X-Google-Smtp-Source: ABdhPJyb5twNqVgoZX5lAmmR5XnFRJyU41EMXiPc3obzaujoKaJDLan9PCdRS4l1gI7FkiqLRP/0hQ==
X-Received: by 2002:a17:902:c40e:: with SMTP id k14mr10704984plk.103.1643408489716;
        Fri, 28 Jan 2022 14:21:29 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id t2sm7787931pfg.207.2022.01.28.14.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:21:29 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 27/44] megaraid: Stop using the SCSI pointer
Date:   Fri, 28 Jan 2022 14:18:52 -0800
Message-Id: <20220128221909.8141-28-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128221909.8141-1-bvanassche@acm.org>
References: <20220128221909.8141-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
from struct scsi_cmnd.

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
