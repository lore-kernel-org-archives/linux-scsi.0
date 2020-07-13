Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11A01C433E7
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:48:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3F5420674
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:48:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SJei8jhM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729191AbgGMHsf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 03:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729168AbgGMHrC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 03:47:02 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084F4C061755
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:47:02 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id w3so12163784wmi.4
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CxDzqoFVC+eH/Z/VxqcqDjW5aD0vS9apzC9wNF1PfnY=;
        b=SJei8jhMPX5u+3OwNxsx2Sz6J0YGJYGYBMz4UNkLPtPT39JBGfcii0JuGg413Kr9xi
         Ld9CIdHeOBenQCqZfrRDk4bXmhrFg1aUGnWCt6011Db6ubOQTyrRoJpTOKO6MzwbA4gH
         9SRBz1MJj/6P2cKaspw/Zu6ExyjvqvDPwwQglxRpfDXuGSfMtIx9mEgnqQhvvAzdqopq
         Oa9UqTEoCaWYw/jBkVEtwmGVzD3GdxEXtkKLAw0SpTshPCYjeXAaSMSQcAWtzAc8rWsm
         vlf2EW2WUWg67XdpoF/2I7SuId411TxCl5aePiSNL+iJab4SMyVYaSsNBOVQ9zlC/ytl
         Oy5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CxDzqoFVC+eH/Z/VxqcqDjW5aD0vS9apzC9wNF1PfnY=;
        b=e8vSd9GzolyiLmArBOzcMnt8O3GeJAehC3d4IWRv7HiGo8cUaJIwiZ2CaisyyhfR+a
         smzSbEXlfZSuS46m7FxbkbQ7Ka26IzhU2KPKzSijGqnIhl+wU6JL8bHpHXgROxEhNtyg
         E/aZqNGcLj89SCIsu0LcXXa+YvX7B8XC6pTyJgZoPDb9TMoUNYenaSaxTXr1juu7PI3N
         gmert7hsu2JTJmH68GevWOIa4nOzI1dX8fPaLrtacGYv0c5on8LLtJYA3Cq2NE3k6K3x
         OVc5X/D9wlU2D8M3Ec1CQvVxYN/FmXAvrZ4fPoBXjNWzHNpkjU+mVaPUvE95pDLmoxFv
         1ZKA==
X-Gm-Message-State: AOAM533aNzfbV7Zix59LzBbdkwPr205OitAS0s8yfAMR4JMIZqrMw5cp
        6OqCl+RTEORtT8g/OLRVqtEAsZb6MSk=
X-Google-Smtp-Source: ABdhPJzXsnLYbqJS6IKYId6XdC3JiCUylpFXGpytdNE97lch2pF7e/nebsAaW18cWUDeiiT1kRaZXw==
X-Received: by 2002:a1c:4d11:: with SMTP id o17mr17318233wmh.134.1594626420749;
        Mon, 13 Jul 2020 00:47:00 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id k11sm25142488wrd.23.2020.07.13.00.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 00:47:00 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v2 12/29] scsi: libfc: fc_fcp: Provide missing and repair existing function documentation
Date:   Mon, 13 Jul 2020 08:46:28 +0100
Message-Id: <20200713074645.126138-13-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713074645.126138-1-lee.jones@linaro.org>
References: <20200713074645.126138-1-lee.jones@linaro.org>
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
index bf2cc9656e191..e11d4f002bd49 100644
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
+ * @t: Timer context used to fetch the FSP packet
  */
 static void fc_lun_reset_send(struct timer_list *t)
 {
@@ -1409,7 +1410,7 @@ static void fc_fcp_cleanup(struct fc_lport *lport)
 
 /**
  * fc_fcp_timeout() - Handler for fcp_pkt timeouts
- * @data: The FCP packet that has timed out
+ * @t: Timer context used to fetch the FSP packet
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

