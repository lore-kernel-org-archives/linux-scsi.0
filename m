Return-Path: <SRS0=qpW3=4I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51B24C34031
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 04:34:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33F9F24670
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 04:34:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgBTEew (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Feb 2020 23:34:52 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46459 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727476AbgBTEev (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Feb 2020 23:34:51 -0500
Received: by mail-pl1-f193.google.com with SMTP id y8so1016164pll.13
        for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2020 20:34:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bA448XM4j4t7KPtHcJFYyb+0pYGIOHGOZgEY7Y01aMI=;
        b=hwvk3eDsZZm6vpWTicz+Ig+ofgXpvpQDc3uj4Doq6n+ZNXV4SRN9e8J0ioxFSZiTmr
         PHqMLRVIxeeLFu+nuddflZv14t5JN2qWUaZRerZ5O47pnFddj3DfOCyGM2hIKh6nfcIe
         E8vABTZbHZG0AN5piGW/yobR0nbXD5fqFTeSBCMmdBRmDNJm91j5sMWAhyasAG5uboOx
         3CIiXexhz2ZxTAjwQVW0B//7N4aaacXO/1Mo4tIcqVwPjyj0SixE/e828M/eTPx7JARE
         RMfA4a2q+QBoFgGQxtOOB36FzCnXZhc0o1uhiktUNiOj9/r9KaSbACNPmhtFGSAGYysF
         F/6w==
X-Gm-Message-State: APjAAAUGYJFVoIYwH/ee+Cq3kfeZ1ZUcdeaNK3wMkvS9hVpVhOD3E5rU
        f75IqOMt8kQfwmHDp0SuJ90=
X-Google-Smtp-Source: APXvYqxHi7hKFbRX4dNLz+uH1zZXFrKuttCu+CpvtDnWrYTjGLda2roqgBQFDfeA88j3qgf5Cu/QPA==
X-Received: by 2002:a17:902:6b48:: with SMTP id g8mr19418825plt.149.1582173291135;
        Wed, 19 Feb 2020 20:34:51 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:29a7:b1bb:5b40:3d61])
        by smtp.gmail.com with ESMTPSA id b5sm1236263pfb.179.2020.02.19.20.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 20:34:50 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v3 2/5] qla2xxx: Suppress endianness complaints in qla2x00_configure_local_loop()
Date:   Wed, 19 Feb 2020 20:34:38 -0800
Message-Id: <20200220043441.20504-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200220043441.20504-1-bvanassche@acm.org>
References: <20200220043441.20504-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of changing endianness in-place, write the data in CPU endian format
in another buffer and copy that buffer back. This patch does not change any
functionality but silences some sparse endianness warnings.

Reviewed-by: Daniel Wagner <dwagner@suse.de>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_def.h  |  2 +-
 drivers/scsi/qla2xxx/qla_init.c | 11 +++++------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index c5a067f45005..b04d334933ef 100644
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
index 9e6b56527b25..880f2be062a9 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5060,7 +5060,7 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 	if (N2N_TOPO(ha)) {
 		if (test_and_clear_bit(N2N_LOGIN_NEEDED, &vha->dpc_flags)) {
 			/* borrowing */
-			u32 *bp, i, sz;
+			u32 *bp, sz;
 
 			memset(ha->init_cb, 0, ha->init_cb_size);
 			sz = min_t(int, sizeof(struct els_plogi_payload),
@@ -5068,13 +5068,12 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 			rval = qla24xx_get_port_login_templ(vha,
 			    ha->init_cb_dma, (void *)ha->init_cb, sz);
 			if (rval == QLA_SUCCESS) {
+				__be32 *q = &ha->plogi_els_payld.data[0];
+
 				bp = (uint32_t *)ha->init_cb;
-				for (i = 0; i < sz/4 ; i++, bp++)
-					*bp = cpu_to_be32(*bp);
+				cpu_to_be32_array(q, bp, sz / 4);
 
-				memcpy(&ha->plogi_els_payld.data,
-				    (void *)ha->init_cb,
-				    sizeof(ha->plogi_els_payld.data));
+				memcpy(bp, q, sizeof(ha->plogi_els_payld.data));
 			} else {
 				ql_dbg(ql_dbg_init, vha, 0x00d1,
 				    "PLOGI ELS param read fail.\n");
