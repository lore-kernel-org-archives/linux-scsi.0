Return-Path: <SRS0=QSh0=Z7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10DEFC2D0BE
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 18:02:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E713F207FF
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 18:02:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbfLISCh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 13:02:37 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:42263 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbfLISCg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 13:02:36 -0500
Received: by mail-pj1-f65.google.com with SMTP id o11so6211295pjp.9
        for <linux-scsi@vger.kernel.org>; Mon, 09 Dec 2019 10:02:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cSOAkyliOAzGchHtYGSoc3Z7HAJUmcRYNXH9NjqWYvc=;
        b=PSvsTrYpnBTtgSOz9rHRC+bpuF8NRu6Vy/AXIKqLoXGf4IQh1/25NOJ+bTYDLx4gna
         T7x3OzoWkwPu42guYWfgczTguRytPpTNjKveRCOx4Ba8LGOYdXLOVoW8c9lirQk82op0
         /h9Hw0O/MwovRyZxx+kkgLZzYB5BrYCj8IigVUMkIrtBO3kyxPQYj/gkRT6DVgWh06Bp
         /QfXwKIKhl8FQXgYT83qOwYCdCTTP8ZsVTdPIzz68isjvFxm+JGfPf+ZRj/W8DImdopX
         FVcs7Pf5aLW4jQkkmxxAW9ElhxboogZ29w1HQJiTQMETTxUI8KUhF2yJ/HHqpOmaUsKR
         zhlA==
X-Gm-Message-State: APjAAAUY/fL+9Dz0TMh7RRQGUZH1FWcy9KKQ5f3Ta/CnJBWYIE3WTZuv
        TheoQdwPsiyBg+Xw41LcfNyk+uNb
X-Google-Smtp-Source: APXvYqxba0hhRli5aDjnOAuOXy5KT8kiI8oBGNU+Od8fjNIEfN8YoCU4Cnck5ZZh0w4JpNMLMGbDlA==
X-Received: by 2002:a17:90a:6346:: with SMTP id v6mr265675pjs.51.1575914555890;
        Mon, 09 Dec 2019 10:02:35 -0800 (PST)
Received: from bvanassche-glaptop.roam.corp.google.com ([216.9.110.7])
        by smtp.gmail.com with ESMTPSA id f13sm132393pfa.57.2019.12.09.10.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 10:02:35 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH 4/4] qla2xxx: Micro-optimize qla2x00_configure_local_loop()
Date:   Mon,  9 Dec 2019 10:02:23 -0800
Message-Id: <20191209180223.194959-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
In-Reply-To: <20191209180223.194959-1-bvanassche@acm.org>
References: <20191209180223.194959-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of changing endianness in-place and copying the data in two steps,
do this in one step. This patch makes is a preparation step for fixing the
endianness warnings reported by 'sparse' for the qla2xxx driver.

Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_def.h  | 2 +-
 drivers/scsi/qla2xxx/qla_init.c | 9 ++++-----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index ab7424318ee8..cf23f10d27fe 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -414,7 +414,7 @@ struct els_logo_payload {
 struct els_plogi_payload {
 	uint8_t opcode;
 	uint8_t rsvd[3];
-	uint8_t data[112];
+	__be32	data[112 / 4];
 };
 
 struct ct_arg {
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 6c28f38f8021..ddd8bf7997a8 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5047,13 +5047,12 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 			rval = qla24xx_get_port_login_templ(vha,
 			    ha->init_cb_dma, (void *)ha->init_cb, sz);
 			if (rval == QLA_SUCCESS) {
+				__be32 *q = &ha->plogi_els_payld.data[0];
+
 				bp = (uint32_t *)ha->init_cb;
-				for (i = 0; i < sz/4 ; i++, bp++)
-					*bp = cpu_to_be32(*bp);
+				for (i = 0; i < sz/4 ; i++, bp++, q++)
+					*q = cpu_to_be32(*bp);
 
-				memcpy(&ha->plogi_els_payld.data,
-				    (void *)ha->init_cb,
-				    sizeof(ha->plogi_els_payld.data));
 				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 			} else {
 				ql_dbg(ql_dbg_init, vha, 0x00d1,
