Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BB8CC433EB
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:44:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56B5820720
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:44:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kOVThYqS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730674AbgGUQm1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 12:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730648AbgGUQmY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 12:42:24 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 475D5C0619DB
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:24 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id s10so21794757wrw.12
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+BNT6pR3iXdTuvzrvWJoNW4LL9aAGyArixYAAs3SVfo=;
        b=kOVThYqS4yrsztYfQMK4WkDJ+dRESJUdyY2fVVUcmFahGQBcT964S08WxQn1SNR/W5
         MYuQrl4Z0rI+RPW4zyjR4kP1eXNO139CgGBwkhVgZqelTlSMaV3g2YJvxXgGswC8WSLC
         9u1rpWJy0FpdAx7GHuHY0XeEv7K+wjNzLr7TaGUajXyluWH0K0yR0I9VXJZYfq/ON6k6
         4PuxeOQrdHYcryiqB/UiHKXp5SI45Q41KKr8MxhyDaw1PmNGZncSLvJQrKvwklFBUN5j
         RDv/JxwhSAvn/JComyExGNzqIkA/AHQbY3pQrVbC8Q4qn1EV7zR+ewi2FahcQ8acL5Qx
         QqMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+BNT6pR3iXdTuvzrvWJoNW4LL9aAGyArixYAAs3SVfo=;
        b=buimAwt2UEQstr7Xx1CAG9fUBQ/U1T2LZzaBdblsJDBWPrHWWR39TaOlUL4oEL9lOg
         p6vy1NrK0f9TzlxknToJJ6Hc44tWzwwarP3FIsv0iw7f7H8cM1vqQ5wka3nt4FchKf/F
         7UjyNUXaSWQ/0pQt6OdO3tJosv9MDosQnAKa5pJy0++g2jyi6g5w8qT0+WwxC9MocnLi
         xiw6cUPnAZ2Q9UV42KrNGbDXVWCjuTe5FZbUuCpPLNx8JuqA6OBKrI2N23N9q/JPbfaO
         B+tIw4PdY+yUQoPqlJ2p8nCqOOvJPMsV7waWCRvbERPLYYPMnpMgvN8X2apHlUJC6jqW
         N1+A==
X-Gm-Message-State: AOAM531ho5DAE1R9rQ4d5wSQkBJt4XdvOrkB372wN5cM3Hmx7Y0XrRu0
        OZdUrlOX2IDQfBRPhtnhTSZ8ag==
X-Google-Smtp-Source: ABdhPJxW4wIYZae30lJ/B/5lcB8ro2G9uBJInQe10hYgvhmCBO2KX138JkDYVQscjAh2tF3Ti7yx+g==
X-Received: by 2002:adf:9e8b:: with SMTP id a11mr4950997wrf.309.1595349743028;
        Tue, 21 Jul 2020 09:42:23 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.94])
        by smtp.gmail.com with ESMTPSA id m4sm3933524wmi.48.2020.07.21.09.42.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 09:42:22 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 18/40] scsi: pm8001: pm8001_hwi: Remove a bunch of set but unused variables
Date:   Tue, 21 Jul 2020 17:41:26 +0100
Message-Id: <20200721164148.2617584-19-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721164148.2617584-1-lee.jones@linaro.org>
References: <20200721164148.2617584-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/qla4xxx/ql4_os.c: In function ‘qla4xxx_eh_cmd_timed_out’:
 drivers/scsi/qla4xxx/ql4_os.c:1865:24: warning: variable ‘sess’ set but not used [-Wunused-but-set-variable]
 1865 | struct iscsi_session *sess;
 | ^~~~
 drivers/scsi/qla4xxx/ql4_os.c: In function ‘qla4xxx_session_create’:
 drivers/scsi/qla4xxx/ql4_os.c:3079:19: warning: variable ‘dst_addr’ set but not used [-Wunused-but-set-variable]
 3079 | struct sockaddr *dst_addr;
 | ^~~~~~~~
 drivers/scsi/qla4xxx/ql4_os.c: In function ‘qla4_8xxx_iospace_config’:
 drivers/scsi/qla4xxx/ql4_os.c:5512:44: warning: variable ‘db_len’ set but not used [-Wunused-but-set-variable]
 5512 | unsigned long mem_base, mem_len, db_base, db_len;
 | ^~~~~~
 drivers/scsi/qla4xxx/ql4_os.c:5512:35: warning: variable ‘db_base’ set but not used [-Wunused-but-set-variable]
 5512 | unsigned long mem_base, mem_len, db_base, db_len;
 | ^~~~~~~
 drivers/scsi/qla4xxx/ql4_os.c: In function ‘qla4xxx_get_param_ddb’:
 drivers/scsi/qla4xxx/ql4_os.c:6269:24: warning: variable ‘ha’ set but not used [-Wunused-but-set-variable]
 6269 | struct scsi_qla_host *ha;
 | ^~

Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/pm8001/pm8001_hwi.c |  6 +++---
 drivers/scsi/qla4xxx/ql4_os.c    | 11 +----------
 2 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 6323016e1304e..e9a939230b152 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4645,8 +4645,8 @@ int pm8001_chip_dereg_dev_req(struct pm8001_hba_info *pm8001_ha,
 /**
  * pm8001_chip_phy_ctl_req - support the local phy operation
  * @pm8001_ha: our hba card information.
- * @phy_id: the phy id which we wanted to operate
- * @phy_op:
+ * @phyId: the phy id which we wanted to operate
+ * @phy_op: the phy operation to request
  */
 static int pm8001_chip_phy_ctl_req(struct pm8001_hba_info *pm8001_ha,
 	u32 phyId, u32 phy_op)
@@ -4682,7 +4682,7 @@ static u32 pm8001_chip_is_our_interrupt(struct pm8001_hba_info *pm8001_ha)
 /**
  * pm8001_chip_isr - PM8001 isr handler.
  * @pm8001_ha: our hba card information.
- * @stat: stat.
+ * @vec: IRQ number
  */
 static irqreturn_t
 pm8001_chip_isr(struct pm8001_hba_info *pm8001_ha, u8 vec)
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 97fa290cf295f..27064c602dc70 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1862,12 +1862,10 @@ static void qla4xxx_conn_get_stats(struct iscsi_cls_conn *cls_conn,
 static enum blk_eh_timer_return qla4xxx_eh_cmd_timed_out(struct scsi_cmnd *sc)
 {
 	struct iscsi_cls_session *session;
-	struct iscsi_session *sess;
 	unsigned long flags;
 	enum blk_eh_timer_return ret = BLK_EH_DONE;
 
 	session = starget_to_session(scsi_target(sc->device));
-	sess = session->dd_data;
 
 	spin_lock_irqsave(&session->lock, flags);
 	if (session->state == ISCSI_SESSION_FAILED)
@@ -3076,7 +3074,6 @@ qla4xxx_session_create(struct iscsi_endpoint *ep,
 	struct ddb_entry *ddb_entry;
 	uint16_t ddb_index;
 	struct iscsi_session *sess;
-	struct sockaddr *dst_addr;
 	int ret;
 
 	if (!ep) {
@@ -3085,7 +3082,6 @@ qla4xxx_session_create(struct iscsi_endpoint *ep,
 	}
 
 	qla_ep = ep->dd_data;
-	dst_addr = (struct sockaddr *)&qla_ep->dst_addr;
 	ha = to_qla_host(qla_ep->host);
 	DEBUG2(ql4_printk(KERN_INFO, ha, "%s: host: %ld\n", __func__,
 			  ha->host_no));
@@ -5509,7 +5505,7 @@ static void qla4xxx_free_adapter(struct scsi_qla_host *ha)
 int qla4_8xxx_iospace_config(struct scsi_qla_host *ha)
 {
 	int status = 0;
-	unsigned long mem_base, mem_len, db_base, db_len;
+	unsigned long mem_base, mem_len;
 	struct pci_dev *pdev = ha->pdev;
 
 	status = pci_request_regions(pdev, DRIVER_NAME);
@@ -5553,9 +5549,6 @@ int qla4_8xxx_iospace_config(struct scsi_qla_host *ha)
 				    ((uint8_t *)ha->nx_pcibase);
 	}
 
-	db_base = pci_resource_start(pdev, 4);  /* doorbell is on bar 4 */
-	db_len = pci_resource_len(pdev, 4);
-
 	return 0;
 iospace_error_exit:
 	return -ENOMEM;
@@ -6266,14 +6259,12 @@ static int qla4xxx_setup_boot_info(struct scsi_qla_host *ha)
 static void qla4xxx_get_param_ddb(struct ddb_entry *ddb_entry,
 				  struct ql4_tuple_ddb *tddb)
 {
-	struct scsi_qla_host *ha;
 	struct iscsi_cls_session *cls_sess;
 	struct iscsi_cls_conn *cls_conn;
 	struct iscsi_session *sess;
 	struct iscsi_conn *conn;
 
 	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
-	ha = ddb_entry->ha;
 	cls_sess = ddb_entry->sess;
 	sess = cls_sess->dd_data;
 	cls_conn = ddb_entry->conn;
-- 
2.25.1

