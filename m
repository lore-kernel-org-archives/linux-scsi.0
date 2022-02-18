Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58CADC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 19:53:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238063AbiBRTx0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Feb 2022 14:53:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238598AbiBRTxP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2022 14:53:15 -0500
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A99294126
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:52:42 -0800 (PST)
Received: by mail-pg1-f169.google.com with SMTP id h125so8750214pgc.3
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:52:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n+ftz6rZifOckZ2d1iAwIpAJCAY8J0AJBDadpTM8K0k=;
        b=BHvTaF5BCfwJrj/v4fhJDvSzQBUkoAm+bMKxyXBph9O0BRtKmsSxDzOpexbYy/JgWc
         QaOhFfen3c9pqG5TtE8Uj1HmAlqFuLKr3o4Ijq+B9iC3Vkc/d/NH3ySR9gQ/DuAgGpx4
         O8Rt/36RFPemwk7NPYagqcgA5xr8nkDYo3tFfKMNnAPLFZH/zX21Aqlw3nQQfdAvIwlR
         ppb6TCgLXGsL8GQAnVcj7Vy+2cCjFX3nHfi/ro2Q700W0r91UGBPNcIJQLlrlCHoeSuU
         MAbxKqNxgkaV4G6e5aH+aJL884WuCdeHzDmTp5G5cPu0bMmf9bgUp3HomrDin7HpmW9z
         lliQ==
X-Gm-Message-State: AOAM532y9e5Fdg6TC4DXAzOPBwrY378yVF9F7KUAVRUn2e3n+fjN/6/u
        3qIUTYKuNrdShnSsdFIBgkmlI6T0Vm/R5A==
X-Google-Smtp-Source: ABdhPJwKk4yG1FxlgCCinEx9O46laW/NsAdOn9gM8z9qDTRpZI44qVRWU39dMwf4HY9j5lfM1iFeFg==
X-Received: by 2002:a05:6a00:43:b0:4ca:a64b:434d with SMTP id i3-20020a056a00004300b004caa64b434dmr9104823pfk.32.1645213962331;
        Fri, 18 Feb 2022 11:52:42 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id e15sm3930523pfv.104.2022.02.18.11.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 11:52:37 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 32/49] scsi: megaraid: Stop using the SCSI pointer
Date:   Fri, 18 Feb 2022 11:51:00 -0800
Message-Id: <20220218195117.25689-33-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218195117.25689-1-bvanassche@acm.org>
References: <20220218195117.25689-1-bvanassche@acm.org>
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
