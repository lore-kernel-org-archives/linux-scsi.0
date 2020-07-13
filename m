Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44F20C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:48:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2377620720
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:48:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OY9mL1RC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbgGMHsB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 03:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729334AbgGMHrL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 03:47:11 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0A8C061794
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:47:11 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id q15so12318464wmj.2
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KFOnaZnxegDwLsJeWEMPqv4RGP3pzEUK9a4hgTT6mu8=;
        b=OY9mL1RCUfiNwlK7Y8LLoK+AzG927nw81f3Z4PqcWbGl3vSJOucO49vTdu8eGhYXAl
         w11NKIhj/+05DjP3pU/AWZq9hcBlj2iLJ0iSTbqGhdUktM+Vj1xLk5a3PvFeb1nwhDCl
         fsrQXk2S0T4I5s9VtOZsPAP926q3LKfnEbI1jnv3qx8AVtlmWgClMnsXa+/JfBUrMgco
         pkjIqv4DSe/jwVUWdO/svjzb7A4Np+nDuFcikxV3+5oFt+aQ7YIuPvKX6L9WBu3aSwhD
         uYjuLCzI6U3kEKHCIkcMiSYiCw9rJ/c7tswAPwBOLDa7XRCAjFF3qbOzeTZtoENoe30S
         g+MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KFOnaZnxegDwLsJeWEMPqv4RGP3pzEUK9a4hgTT6mu8=;
        b=r7xP3XxAoT3vreeuakeOhuJpVzI9XtjML0HT4505MguZXnSOKDa9Rc1ja2MjxIRiuW
         voAVaSmdAJ6DuKaMtvbxZK+j3HnXV1kpukr2OcEJozmD88ep/G0IvQHrVXuaxFXz7mSt
         HXiYzHIGFigbkMO2AGe5QJkIus1Nz5/h2RLePSK1Z/DB/Sh5g93IzFiPhZ4zQE5fzgN5
         7wpzowvMiSE5gaQE89Dkiwbn1r3Wcb8+HdIkZQgJDqrxReRbgwm9/q14mZRA1i7yRYP6
         HOaYVQVjlyqr74+0gye1C9g9NY15Q6T6qzhsmEeXdbVqMrcCGHz8jWYXcxe9DCBivYds
         hwEQ==
X-Gm-Message-State: AOAM533ylavyIvWeIqBenZlppNgDQ05r3hJCbOZL28VMgTAW8NSc9c2n
        B/iy3jY49mwZ0Y1aZHrT2x0BCw==
X-Google-Smtp-Source: ABdhPJwRuM1r9uL6bIMWY8lKVERcxzLzcL+9/u+h5G0jkwKYSf7ROchiqv2H6ETBhcueyyrOt5j41w==
X-Received: by 2002:a7b:c013:: with SMTP id c19mr17249605wmb.158.1594626430342;
        Mon, 13 Jul 2020 00:47:10 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id k11sm25142488wrd.23.2020.07.13.00.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 00:47:09 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Hannes Reinecke <hare@suse.com>,
        "Daniel M. Eischen" <deischen@iworks.InterWorks.org>,
        Doug Ledford <dledford@redhat.com>
Subject: [PATCH v2 21/29] scsi: aic7xxx: aic7xxx_osm: Fix 'amount_xferred' set but not used issue
Date:   Mon, 13 Jul 2020 08:46:37 +0100
Message-Id: <20200713074645.126138-22-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713074645.126138-1-lee.jones@linaro.org>
References: <20200713074645.126138-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

'amount_xferred' is used, but only in certain circumstances.  Place
the same stipulations on the defining/allocating of 'amount_xferred'
as is placed when using it.

We've been careful not to change any of the ordering semantics here.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aic7xxx/aic7xxx_osm.c: In function ‘ahc_done’:
 drivers/scsi/aic7xxx/aic7xxx_osm.c:1725:12: warning: variable ‘amount_xferred’ set but not used [-Wunused-but-set-variable]
 1725 | uint32_t amount_xferred;
 | ^~~~~~~~~~~~~~

Cc: Hannes Reinecke <hare@suse.com>
Cc: "Daniel M. Eischen" <deischen@iworks.InterWorks.org>
Cc: Doug Ledford <dledford@redhat.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aic7xxx/aic7xxx_osm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index ed437c16de881..e7ccb8b80fc19 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1711,10 +1711,12 @@ ahc_done(struct ahc_softc *ahc, struct scb *scb)
 	 */
 	cmd->sense_buffer[0] = 0;
 	if (ahc_get_transaction_status(scb) == CAM_REQ_INPROG) {
+#ifdef AHC_REPORT_UNDERFLOWS
 		uint32_t amount_xferred;
 
 		amount_xferred =
 		    ahc_get_transfer_length(scb) - ahc_get_residual(scb);
+#endif
 		if ((scb->flags & SCB_TRANSMISSION_ERROR) != 0) {
 #ifdef AHC_DEBUG
 			if ((ahc_debug & AHC_SHOW_MISC) != 0) {
-- 
2.25.1

