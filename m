Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9E9EC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 30 May 2022 23:15:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbiE3XP5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 May 2022 19:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241288AbiE3XPo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 May 2022 19:15:44 -0400
Received: from bee.birch.relay.mailchannels.net (bee.birch.relay.mailchannels.net [23.83.209.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E5D71DB9
        for <linux-scsi@vger.kernel.org>; Mon, 30 May 2022 16:15:43 -0700 (PDT)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 101D3761D04;
        Mon, 30 May 2022 23:15:43 +0000 (UTC)
Received: from pdx1-sub0-mail-a312.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 856A9761C0A;
        Mon, 30 May 2022 23:15:42 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1653952542; a=rsa-sha256;
        cv=none;
        b=04vckKGduvQIZmCpOrEAOJVREFQyMCkwEK+sJ166BQfWWSpUpkxJ7KmRB1r5QvOnEbCEkR
        uBlF++AHXT/Dzircz08sHzLgrqm74Igqn8iVh3cq97QnRx6wPN+Mb9gqaGN5Z1JxWcZ5xw
        sbuH3gEHoxW7YOIuPL1IuAQCSp+oQ8+S2M0GV/DJ8C6Kg6J3/fTkTmzKGBQCh6gDscaByT
        ysNgQ9BNOVjm3ijF6fAJgDs6TJpuTxr0JyXDW00hPMHxu2lkJNX7gREQ8+siSvIkPeZ9Rw
        rLdSqIPJyNNFUvEGOWR3jSHhlBxys/Km8WouGGhL+bnI3apIAlNrVeMqpYenXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1653952542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:dkim-signature;
        bh=BfMMaISwkYzSVqBGFVh9TD0h12Q2tQqtKfbcv93VqnQ=;
        b=+NSZIYXDHRtxBkggdMZTRwy17Tpvl3Y0SCl8clpYfkrk+0zGnrT3bKC1WzfXNPZ0LVRHKN
        shTr5/A3iAqFoR2n/BfpO1H6CddMwxIfjit6gbWLLRHjg/Q3tUa0r4k7CpTcr9L6gXSZ9t
        XDmx/k4kI1mXlrwqsnObXNdYVY+CFKJIstd96R3Sd8/oodH+qv/0EMvXQTV5XCnp6/MH9U
        Ba2uBEAqnnILAcufBNLEo6q7XspryHENK2kLnEmKZJmSjcRPFJWaCno8U/XHYvCvaqo9w6
        wNTJzFTQpLg0ZDWfodg1cVPpaS4XcrUdpxCK5nbWf/toiiWyywPdzWTEvsllKQ==
ARC-Authentication-Results: i=1;
        rspamd-54ff499d4f-fpjqt;
        auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Ruddy-Broad: 6d1dfe923a560f99_1653952542872_107488069
X-MC-Loop-Signature: 1653952542872:926491730
X-MC-Ingress-Time: 1653952542872
Received: from pdx1-sub0-mail-a312.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.106.158.163 (trex/6.7.1);
        Mon, 30 May 2022 23:15:42 +0000
Received: from localhost.localdomain (unknown [104.36.31.105])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dave@stgolabs.net)
        by pdx1-sub0-mail-a312.dreamhost.com (Postfix) with ESMTPSA id 4LBrqd5c5sz2g;
        Mon, 30 May 2022 16:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
        s=dreamhost; t=1653952542;
        bh=BfMMaISwkYzSVqBGFVh9TD0h12Q2tQqtKfbcv93VqnQ=;
        h=From:To:Cc:Subject:Date:Content-Transfer-Encoding;
        b=pN2vWdMrav6gFnlvXfOp51xO/gClC7puAmCyzUiieY9f4Wi8v/9Ii79JtdVpu1XuV
         w5QBYzzku7CViPA+MpcC5so5s20tRHNrt+NUrFQ/ktdWs1e+4Dryw/3j6QFIeN8PQC
         hBqPhnMTnC86qVzS20RPjMPxOV2+eMzDKa2lf4L+M9Bw/m9AgvuANTiiePYSIf9cem
         RdVcwZCa8esx5xYefmUJH6mFwOlsKww+Jm5n34oUV0fKMesmXdPli59Qi1zPgrWsQS
         L9e3679IJ1b/N/ODAx7jMKCos76OOulBCKDKaJrplLY8+dX5rJSL14Bi+y3m82hm/D
         aDs3LnT1+ovrg==
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, ejb@linux.ibm.com,
        bigeasy@linutronix.de, tglx@linutronix.de, dave@stgolabs.net,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 10/10] scsi/lpfc: Remove bogus references to discovery tasklet
Date:   Mon, 30 May 2022 16:15:12 -0700
Message-Id: <20220530231512.9729-11-dave@stgolabs.net>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220530231512.9729-1-dave@stgolabs.net>
References: <20220530231512.9729-1-dave@stgolabs.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is done as thread. Also remove an unused member of the
lpfc_vport structure.

Cc: James Smart <james.smart@broadcom.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
---
 drivers/scsi/lpfc/lpfc.h      | 2 --
 drivers/scsi/lpfc/lpfc_disc.h | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index da9070cdad91..05da8ccb0933 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -645,8 +645,6 @@ struct lpfc_vport {
 	struct lpfc_name fc_nodename;	/* fc nodename */
 	struct lpfc_name fc_portname;	/* fc portname */
 
-	struct lpfc_work_evt disc_timeout_evt;
-
 	struct timer_list fc_disctmo;	/* Discovery rescue timer */
 	uint8_t fc_ns_retry;	/* retries for fabric nameserver */
 	uint32_t fc_prli_sent;	/* cntr for outstanding PRLIs */
diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index 37a4b79010bf..40f458ee1aec 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -44,7 +44,7 @@ enum lpfc_work_type {
 	LPFC_EVT_RECOVER_PORT
 };
 
-/* structure used to queue event to the discovery tasklet */
+/* structure used to queue event to the discovery thread */
 struct lpfc_work_evt {
 	struct list_head      evt_listp;
 	void                 *evt_arg1;
-- 
2.36.1

