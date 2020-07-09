Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C12D8C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:46:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CCEB2078B
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:46:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fxWsWdjx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728500AbgGIRqI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 13:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728467AbgGIRqH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 13:46:07 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F8CC08C5DC
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jul 2020 10:46:06 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id a6so3294597wrm.4
        for <linux-scsi@vger.kernel.org>; Thu, 09 Jul 2020 10:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RfY0NWdcaY2EP3FmoORbq4kbjZDAFhNLFjss0f92Lio=;
        b=fxWsWdjxXCwYott0gwgsFWwu5RCZefGZ1QnMRJoPwCA+hqDDEzcF8/6f0mKUo1F9/w
         9aSvsMy5bvmp0jd9N811D9npGUzRIswp5G7SK53qrJKSLF0UAM+V1q/xC913sG7b8Yp6
         XEYnpj0FfTzqoeimcjzOj2zh9hRAEABgNgSgdAn4mulh2p1JNXQAlg4ZDHDrTxNA4Q5x
         Tjm3aCwmNIijd/mgkXCE0JhiUrp+SIa/AY0vSeB9wxWve8maNPXTM5yogbCn06YxmZyM
         b5WR984aWLaXU/vO8p2D4knaliVQEuLcxMlDlwbf3EgbjlLXxMTPdIA4QuPU5TqPm1Ko
         yNoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RfY0NWdcaY2EP3FmoORbq4kbjZDAFhNLFjss0f92Lio=;
        b=pV3zRmzzMnHNdD2/irb28oeZO0D1tpQ9lZaun0/ogmJm+btLUNXJ0MnoijSYY0eb9g
         FPjzOVMyylrXpmlWEhn+372SLNpvYd3kB7xcoILTSbBBa3MxJkD6AxnAuoO6nsxmpz8h
         zXB1GcAhm41g9sY85UR2kPA9rLQaaZIibIeT65lsmcAD8b1J6/IEkIIpYR/XrP5+bTNR
         9bjQ3hhyqVSx9LsZaDhqJhpf79Cox5HvP5vHtBmXp1m295I0Ii51pVfUf5Qi0iYg+HjZ
         6YGWzs93KH2GcGa2KzlN5FnmDE9l7h2AmitHb26VhCsyC01NirHO48JzO/FkuMl5RWAA
         PSyA==
X-Gm-Message-State: AOAM532EkRqGu2tniFvfhnU3SDxwWNlQU2GbADP7rdHUxgV1mZ4Et1mP
        MX3xI60xTdwsLfqd3strGuQbDQ==
X-Google-Smtp-Source: ABdhPJwR342krb6Tv5vajpMLiUmBmrjHClb1EGfHyoLk4VJXH2Y+3dU+YeDhC04H4wAP3uP+NVgbfQ==
X-Received: by 2002:adf:e3c5:: with SMTP id k5mr64956020wrm.121.1594316765343;
        Thu, 09 Jul 2020 10:46:05 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id f15sm6063854wrx.91.2020.07.09.10.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 10:46:04 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [PATCH 06/24] scsi: aic94xx: aic94xx_seq: Document 'lseq' and repair asd_update_port_links() header
Date:   Thu,  9 Jul 2020 18:45:38 +0100
Message-Id: <20200709174556.7651-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200709174556.7651-1-lee.jones@linaro.org>
References: <20200709174556.7651-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aic94xx/aic94xx_seq.c:587: warning: Function parameter or member 'lseq' not described in 'asd_init_lseq_mip'
 drivers/scsi/aic94xx/aic94xx_seq.c:674: warning: Function parameter or member 'lseq' not described in 'asd_init_lseq_mdp'
 drivers/scsi/aic94xx/aic94xx_seq.c:958: warning: Function parameter or member 'lseq' not described in 'asd_init_lseq_cio'
 drivers/scsi/aic94xx/aic94xx_seq.c:1364: warning: Function parameter or member 'asd_ha' not described in 'asd_update_port_links'
 drivers/scsi/aic94xx/aic94xx_seq.c:1364: warning: Function parameter or member 'phy' not described in 'asd_update_port_links'
 drivers/scsi/aic94xx/aic94xx_seq.c:1364: warning: Excess function parameter 'sas_phy' description in 'asd_update_port_links'

Cc: Luben Tuikov <luben_tuikov@adaptec.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aic94xx/aic94xx_seq.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_seq.c b/drivers/scsi/aic94xx/aic94xx_seq.c
index 11853ec29d87a..c0f685c86851b 100644
--- a/drivers/scsi/aic94xx/aic94xx_seq.c
+++ b/drivers/scsi/aic94xx/aic94xx_seq.c
@@ -582,6 +582,7 @@ static void asd_init_cseq_scratch(struct asd_ha_struct *asd_ha)
 /**
  * asd_init_lseq_mip -- initialize LSEQ Mode independent pages 0-3
  * @asd_ha: pointer to host adapter structure
+ * @lseq:  link sequencer
  */
 static void asd_init_lseq_mip(struct asd_ha_struct *asd_ha, u8 lseq)
 {
@@ -669,6 +670,7 @@ static void asd_init_lseq_mip(struct asd_ha_struct *asd_ha, u8 lseq)
 /**
  * asd_init_lseq_mdp -- initialize LSEQ mode dependent pages.
  * @asd_ha: pointer to host adapter structure
+ * @lseq:  link sequencer
  */
 static void asd_init_lseq_mdp(struct asd_ha_struct *asd_ha,  int lseq)
 {
@@ -953,6 +955,7 @@ static void asd_init_cseq_cio(struct asd_ha_struct *asd_ha)
 /**
  * asd_init_lseq_cio -- initialize LmSEQ CIO registers
  * @asd_ha: pointer to host adapter structure
+ * @lseq:  link sequencer
  */
 static void asd_init_lseq_cio(struct asd_ha_struct *asd_ha, int lseq)
 {
@@ -1345,7 +1348,8 @@ int asd_start_seqs(struct asd_ha_struct *asd_ha)
 
 /**
  * asd_update_port_links -- update port_map_by_links and phy_is_up
- * @sas_phy: pointer to the phy which has been added to a port
+ * @asd_ha: pointer to host adapter structure
+ * @phy: pointer to the phy which has been added to a port
  *
  * 1) When a link reset has completed and we got BYTES DMAED with a
  * valid frame we call this function for that phy, to indicate that
-- 
2.25.1

