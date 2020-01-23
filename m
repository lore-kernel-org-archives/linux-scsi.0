Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADC7BC33CB6
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 04:23:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8859924676
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 04:23:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgAWEX6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jan 2020 23:23:58 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:50179 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbgAWEX5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jan 2020 23:23:57 -0500
Received: by mail-pj1-f67.google.com with SMTP id r67so594709pjb.0
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jan 2020 20:23:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vP7CMCpbNU0C3WEyj/Qz7lS3jQEUgPukezd7sfuo0ds=;
        b=GeCnQdyDH6FmYQpBW2ZtcSEvUw2uhzDX0qJWE6Ogm7FixycIEzuHZoj4NTAZ54vn5x
         yg/PJQEAt01YXpIKiUDX4WsKq6bNIP/pZ7fA0cf/DdWcQ5gP2VMTLxrH1azfY8TIGZ8G
         iTjsQzLGiJwY/RfjzIn5XBysD67K3jeB7rf791lYMYuBnQ/IXGvgSce5feFDtw400qI5
         mfMbfq6TT/H77Ihc6npnI5LwaI8+aXaUrRVyRJELR1n/NsOR6LlylAhIDOu4ZQBeP4KZ
         e+gx2IXE5Rc3esF/2nlyDsOTmoudHgzWTQXrwPngnLg/jP7Uys4O27yy+XaffwUFPoF5
         DkXg==
X-Gm-Message-State: APjAAAVjSN3rkibzV6QAvUV+Km4vpdDoIDwpazfUm0P7m3Vt5kpcvdIE
        L47JO8IVMZWeNNLvo7W/QWI=
X-Google-Smtp-Source: APXvYqwkMH/PE6l3jeec1R15tMNJShIm6c8MbyXvKNvqveLUutgVlJGFUvTJUSNtcSKQs4ZPv72WgA==
X-Received: by 2002:a17:902:a5c3:: with SMTP id t3mr14786101plq.145.1579753437093;
        Wed, 22 Jan 2020 20:23:57 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:d957:4568:237a:bc62])
        by smtp.gmail.com with ESMTPSA id p16sm492879pfq.184.2020.01.22.20.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 20:23:56 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v2 3/6] qla2xxx: Suppress endianness complaints in qla2x00_configure_local_loop()
Date:   Wed, 22 Jan 2020 20:23:42 -0800
Message-Id: <20200123042345.23886-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200123042345.23886-1-bvanassche@acm.org>
References: <20200123042345.23886-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of changing endianness in-place, write the data in CPU endian format
in another buffer and copy that buffer back. This patch does not change any
functionality but silences some sparse endianness warnings.

Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Daniel Wagner <dwagner@suse.de>
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
