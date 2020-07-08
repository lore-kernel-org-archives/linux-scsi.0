Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AD54C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:02:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42E9820772
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:02:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="P7pECm1G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729089AbgGHMCp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729069AbgGHMCo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 08:02:44 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B455AC08E876
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 05:02:43 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id q15so2726218wmj.2
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2020 05:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DSQYT4u05u5XHMfy8CsexKzDa1uvZ/5gisr4AmMPcPk=;
        b=P7pECm1Gy1aRGbb++bMKhwPg0A2Y4d68UaMYFhuCKyV7BMX6/bLCcJJU1aOmkTCNnR
         ESXvFF0ZIUpyGUBlYp41i+v78s2zHN9JN7jTrQO8KRQt9mga3jI+XfLhqnrLMqCQ0Ql9
         xM+/0JCu3uYPvksvh9FzSn57QgfB9VHwcitInoNrmizP17t+sRXsyi7hr0pIaiz+CKRJ
         LdOaxKfUR9WU9i4gXuE2ygO0DsQsZxTXF1SoBYUkR3cBmKoi16XVhdpP5LgzttcngxtY
         sxcZlUl0YpiKu3mokih0XocFqx5/DZ9iKJTByM1jXxN6M+DiyYpuvQLDF4odHGcRnGNy
         7CEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DSQYT4u05u5XHMfy8CsexKzDa1uvZ/5gisr4AmMPcPk=;
        b=U4xWUE5Z/WuZt+q0RKyNgcqPFvuDeIRRbEba+YSWJaMV6tq/ICaJlkEhHZ4ugICP/y
         D4vVcbShcmz2Zlq5NxPfcb2yT4+63Qzq5RLr2+ppQEWLMAq7kJuDS6Io3AfBMz6i+FE2
         xQJTmtRef8i7pYzN3B5oJ09LLO3aCZzqWgZFJfhtY/oqFotKp+6nlMnMigEYKQ5+altU
         nKLeO02TeniRn+Q3ro0L9PH56F+PkDA5+xCTctM4duMyfTlwGcvuDb5jfyu+JZyo0heB
         nvDTz40Lx4EGbL11S7QbR3o7Zjod+sMZO8No7H04DgiDmtRO8Cc4WVQrdHwjor8cEQSP
         3OiQ==
X-Gm-Message-State: AOAM532xQQA1taamGZ/fvpjYlWxCbmIh35q113s6evgSCfsqjZmq4Q+e
        ByruaR8mbcIy728KxSinY6Eb5Q==
X-Google-Smtp-Source: ABdhPJz0/5Wm5G+Wa29qTxr1KGWCC4Ogqt6V8P6SjFAPiPZP9bxs2AwnCef6loyajt0KgPGKePrthg==
X-Received: by 2002:a05:600c:2c0d:: with SMTP id q13mr8769318wmg.81.1594209762080;
        Wed, 08 Jul 2020 05:02:42 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id m62sm3964997wmm.42.2020.07.08.05.02.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 05:02:41 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 12/30] scsi: libfc: fc_fcp: Provide missing and repair existing function documentation
Date:   Wed,  8 Jul 2020 13:02:03 +0100
Message-Id: <20200708120221.3386672-13-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200708120221.3386672-1-lee.jones@linaro.org>
References: <20200708120221.3386672-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Mostly due to descriptions not keeping up with API changes.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/libfc/fc_fcp.c:299: warning: Function parameter or member 'status_code' not described in 'fc_fcp_retry_cmd'
 drivers/scsi/libfc/fc_fcp.c:595: warning: Function parameter or member 'seq' not described in 'fc_fcp_send_data'
 drivers/scsi/libfc/fc_fcp.c:595: warning: Excess function parameter 'sp' description in 'fc_fcp_send_data'
 drivers/scsi/libfc/fc_fcp.c:1289: warning: Function parameter or member 't' not described in 'fc_lun_reset_send'
 drivers/scsi/libfc/fc_fcp.c:1289: warning: Excess function parameter 'data' description in 'fc_lun_reset_send'
 drivers/scsi/libfc/fc_fcp.c:1422: warning: Function parameter or member 't' not described in 'fc_fcp_timeout'
 drivers/scsi/libfc/fc_fcp.c:1422: warning: Excess function parameter 'data' description in 'fc_fcp_timeout'
 drivers/scsi/libfc/fc_fcp.c:1696: warning: Function parameter or member 'code' not described in 'fc_fcp_recovery'
 drivers/scsi/libfc/fc_fcp.c:1716: warning: Function parameter or member 'offset' not described in 'fc_fcp_srr'
 drivers/scsi/libfc/fc_fcp.c:1859: warning: Function parameter or member 'sc_cmd' not described in 'fc_queuecommand'
 drivers/scsi/libfc/fc_fcp.c:1859: warning: Excess function parameter 'cmd' description in 'fc_queuecommand'

Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/libfc/fc_fcp.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index bf2cc9656e191..d1ff2335f552b 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -289,6 +289,7 @@ static int fc_fcp_send_abort(struct fc_fcp_pkt *fsp)
 /**
  * fc_fcp_retry_cmd() - Retry a fcp_pkt
  * @fsp: The FCP packet to be retried
+ * @status_code: The FCP status code to set
  *
  * Sets the status code to be FC_ERROR and then calls
  * fc_fcp_complete_locked() which in turn calls fc_io_compl().
@@ -580,7 +581,7 @@ static void fc_fcp_recv_data(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 /**
  * fc_fcp_send_data() - Send SCSI data to a target
  * @fsp:      The FCP packet the data is on
- * @sp:	      The sequence the data is to be sent on
+ * @seq:      The sequence the data is to be sent on
  * @offset:   The starting offset for this data request
  * @seq_blen: The burst length for this data request
  *
@@ -1283,7 +1284,7 @@ static int fc_fcp_pkt_abort(struct fc_fcp_pkt *fsp)
 
 /**
  * fc_lun_reset_send() - Send LUN reset command
- * @data: The FCP packet that identifies the LUN to be reset
+ * @t: Timer context used to fectch the FSP packet
  */
 static void fc_lun_reset_send(struct timer_list *t)
 {
@@ -1409,7 +1410,7 @@ static void fc_fcp_cleanup(struct fc_lport *lport)
 
 /**
  * fc_fcp_timeout() - Handler for fcp_pkt timeouts
- * @data: The FCP packet that has timed out
+ * @t: Timer context used to fectch the FSP packet
  *
  * If REC is supported then just issue it and return. The REC exchange will
  * complete or time out and recovery can continue at that point. Otherwise,
@@ -1691,6 +1692,7 @@ static void fc_fcp_rec_error(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 /**
  * fc_fcp_recovery() - Handler for fcp_pkt recovery
  * @fsp: The FCP pkt that needs to be aborted
+ * @code: The FCP status code to set
  */
 static void fc_fcp_recovery(struct fc_fcp_pkt *fsp, u8 code)
 {
@@ -1709,6 +1711,7 @@ static void fc_fcp_recovery(struct fc_fcp_pkt *fsp, u8 code)
  * fc_fcp_srr() - Send a SRR request (Sequence Retransmission Request)
  * @fsp:   The FCP packet the SRR is to be sent on
  * @r_ctl: The R_CTL field for the SRR request
+ * @offset: The SRR relative offset
  * This is called after receiving status but insufficient data, or
  * when expecting status but the request has timed out.
  */
@@ -1851,7 +1854,7 @@ static inline int fc_fcp_lport_queue_ready(struct fc_lport *lport)
 /**
  * fc_queuecommand() - The queuecommand function of the SCSI template
  * @shost: The Scsi_Host that the command was issued to
- * @cmd:   The scsi_cmnd to be executed
+ * @sc_cmd:   The scsi_cmnd to be executed
  *
  * This is the i/o strategy routine, called by the SCSI layer.
  */
-- 
2.25.1

