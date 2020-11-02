Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85986C00A89
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 14:24:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43276206F8
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 14:24:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aEg/7I9J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgKBOYa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 09:24:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbgKBOY0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 09:24:26 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A9BC061A04
        for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2020 06:24:25 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id c18so9577018wme.2
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2020 06:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CGRjtEO3+/S0NupDYXoJNbgD6kgyMEDCzJJaiz4KGno=;
        b=aEg/7I9JVkEj5+F34Ycnwr8AA9v9yZjDQ4T1GfibFzz4OGeHL9M3Gfy6i5dHhU9neG
         gHWAnNoojNEOSbHpGngHrJC0p/r51yJxRer+iH9WYFhQprO+5vhLL3V7mFoUIXdzBNwd
         bsO1xucdRzsJHreKpoRr+g9f0AxghFFyg66YXdCUQxrITWc8aHcCr+xUJCVokBbSP2dX
         y3F6vOaXyo414HVyCzUWLy1/q/DaBBTdR6LK551oexwpHtrUgIBSh8fDjXjUg20MVc+Y
         jPepNvjcTP4mDr+PlefAK4wbLKQ0xA+hs3la9df32Fe2pcQRgRwD1AQUemHaSf1ikDQJ
         +yTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CGRjtEO3+/S0NupDYXoJNbgD6kgyMEDCzJJaiz4KGno=;
        b=Yqwy/T643EWn/XDVlaFuTKIWn1mCydU1lgLcoXoYMNq7G7DIG7UGVphloIdz5QsQiy
         OWMcVL8CLbdibJurFcfyrT6SbN3fJEQl+msbq26yJhepCU33LM/kbR4uAB3Hb/kFUtaQ
         VO7fkLYw83iEfHntppwJuQzcoNx/0TBfOZl4c8DU/TyOL/WzrZq1eGGxAEmtW4EjKVBR
         0J47vwkPzsfsBUo/evv9+PDKxJLZs9yMKD0nB6CWAn7WEdrEraK2DhC+EHjk5YzjQjhs
         YePeD5VkKyZAonlgSS1xJKn0zMr5TtCbdJl09oJ2IcRJK2WJPG2TxtOo6qcFL7vUbiMd
         B4cg==
X-Gm-Message-State: AOAM533Lyi5HbQmdmLEm958DHHd593axjLUzQnSGUN/44BblBri8EvEY
        5yom+6Qyul/HfWhttO2GwpYbRg==
X-Google-Smtp-Source: ABdhPJxsN9QhTFE9yr+p1solJGq3VNKQojhXlqa+mRVHRStpLQk0qicFvWJOs/g2owmlppbzYXlgfg==
X-Received: by 2002:a1c:5401:: with SMTP id i1mr17922756wmb.124.1604327064401;
        Mon, 02 Nov 2020 06:24:24 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id f7sm23542501wrx.64.2020.11.02.06.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 06:24:23 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>
Subject: [RESEND 16/19] scsi: advansys: Relocate or remove unused variables
Date:   Mon,  2 Nov 2020 14:23:56 +0000
Message-Id: <20201102142359.561122-17-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102142359.561122-1-lee.jones@linaro.org>
References: <20201102142359.561122-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/advansys.c: In function ‘asc_prt_asc_board_eeprom’:
 drivers/scsi/advansys.c:2879:15: warning: variable ‘asc_dvc_varp’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/advansys.c: In function ‘asc_prt_driver_conf’:
 drivers/scsi/advansys.c:3174:6: warning: variable ‘chip_scsi_id’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/advansys.c: In function ‘AdvISR’:
 drivers/scsi/advansys.c:6114:9: warning: variable ‘target_bit’ set but not used [-Wunused-but-set-variable]

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/advansys.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index c2c7850ff7b42..79830e77afa97 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -2876,15 +2876,15 @@ static int asc_get_eeprom_string(ushort *serialnum, uchar *cp)
 static void asc_prt_asc_board_eeprom(struct seq_file *m, struct Scsi_Host *shost)
 {
 	struct asc_board *boardp = shost_priv(shost);
-	ASC_DVC_VAR *asc_dvc_varp;
 	ASCEEP_CONFIG *ep;
 	int i;
+	uchar serialstr[13];
 #ifdef CONFIG_ISA
+	ASC_DVC_VAR *asc_dvc_varp;
 	int isa_dma_speed[] = { 10, 8, 7, 6, 5, 4, 3, 2 };
-#endif /* CONFIG_ISA */
-	uchar serialstr[13];
 
 	asc_dvc_varp = &boardp->dvc_var.asc_dvc_var;
+#endif /* CONFIG_ISA */
 	ep = &boardp->eep_config.asc_eep;
 
 	seq_printf(m,
@@ -3171,7 +3171,6 @@ static void asc_prt_adv_board_eeprom(struct seq_file *m, struct Scsi_Host *shost
 static void asc_prt_driver_conf(struct seq_file *m, struct Scsi_Host *shost)
 {
 	struct asc_board *boardp = shost_priv(shost);
-	int chip_scsi_id;
 
 	seq_printf(m,
 		"\nLinux Driver Configuration and Information for AdvanSys SCSI Host %d:\n",
@@ -3197,12 +3196,6 @@ static void asc_prt_driver_conf(struct seq_file *m, struct Scsi_Host *shost)
 		   boardp->asc_n_io_port);
 
 	seq_printf(m, " io_port 0x%lx\n", shost->io_port);
-
-	if (ASC_NARROW_BOARD(boardp)) {
-		chip_scsi_id = boardp->dvc_cfg.asc_dvc_cfg.chip_scsi_id;
-	} else {
-		chip_scsi_id = boardp->dvc_var.adv_dvc_var.chip_scsi_id;
-	}
 }
 
 /*
@@ -6111,7 +6104,6 @@ static int AdvISR(ADV_DVC_VAR *asc_dvc)
 {
 	AdvPortAddr iop_base;
 	uchar int_stat;
-	ushort target_bit;
 	ADV_CARR_T *free_carrp;
 	__le32 irq_next_vpa;
 	ADV_SCSI_REQ_Q *scsiq;
@@ -6198,8 +6190,6 @@ static int AdvISR(ADV_DVC_VAR *asc_dvc)
 		asc_dvc->carr_freelist = free_carrp;
 		asc_dvc->carr_pending_cnt--;
 
-		target_bit = ADV_TID_TO_TIDMASK(scsiq->target_id);
-
 		/*
 		 * Clear request microcode control flag.
 		 */
-- 
2.25.1

