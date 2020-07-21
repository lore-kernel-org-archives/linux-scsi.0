Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 708D2C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:43:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FEAE20792
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:43:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gRIBgAZp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730860AbgGUQn3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 12:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730766AbgGUQmp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 12:42:45 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061E6C0619DA
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:45 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id 88so11573220wrh.3
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jALF4UglhPiR50fx9RAXVg2wft4bVyZm/g/kx8/tohE=;
        b=gRIBgAZpckF5GdIJZ8nCRH7B943d8Kxu0QenVz+DMkfioH2Vcy3xZvMvTZgB7SnNL4
         p1HjT2n/YXsGDjWvdBmBMMr4Q4d9U0F7CkY0w4CQOk07oeCiNUMKrjBmssgU2QY9fqz8
         CIqOoOpiNSQDV5d1B3AM3RCRTKR33KNLXWaoNsll4814kXJWhbjwGYhLz/vpq3PHKBa0
         CszBN3DJ5NeUBsaVi2rmKDXBy6E4nU+SzjByHBNk8kF2leZUCd+hDNc9VPEOCxawxTYq
         hb6zoMKaW6z6BkW5qR+OGIW7qd0+DYB+Tj4D01Sz2YsgAAi7rc6frsSwqB5mwLmyHcCK
         Vtog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jALF4UglhPiR50fx9RAXVg2wft4bVyZm/g/kx8/tohE=;
        b=Hipo6K4Of25ahHSIcbVNWhW6ZGWjtprgvN8oYEzpUKMDPDY97XFq/Rw8nGsNqxdzkf
         pEZl10OpoPHI4s/LSpERPMkztnYyRwtf+i497w4yzY78OpRla0RzZlsynly1eY0oMAMp
         uURejRbuTV/DKhBmjYlvQKcfmYx9tikxkbhXXxP3J+oJb9yehYfSW7+rgdTdsVa2ov5L
         b0pp/nvo871LDd/e3eVshBQXQa469+0iPf9qnb8nEbqxAHRQH44C6S74shURI0spdKEF
         HAJeJ4O3MoBJ3uXqyiCD1UJ+uagMSlEIoVtifY/eDydsaRYnvt6niFsgWB0HcEYM1jid
         KAoA==
X-Gm-Message-State: AOAM532lkbaJOsekjDeJZcm1m19lgAS6XVIEcX5q+kiU4w2qT80zRNI1
        8NDrhIeGgmwt78l1f0u34dHq7Q==
X-Google-Smtp-Source: ABdhPJzGnBb8avkbmKQI7yITYi5wbbZFWR8Uj+zO3XEMt4FR9iFPvrNLrymm6EE2us09Dca4TF+6oQ==
X-Received: by 2002:adf:83c5:: with SMTP id 63mr1008654wre.321.1595349763722;
        Tue, 21 Jul 2020 09:42:43 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.94])
        by smtp.gmail.com with ESMTPSA id m4sm3933524wmi.48.2020.07.21.09.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 09:42:43 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        QLogic-Storage-Upstream@qlogic.com
Subject: [PATCH 33/40] scsi: qla4xxx: ql4_nx: Supply description for 'code'
Date:   Tue, 21 Jul 2020 17:41:41 +0100
Message-Id: <20200721164148.2617584-34-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721164148.2617584-1-lee.jones@linaro.org>
References: <20200721164148.2617584-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Demote other headers which are clearly not kerneldoc.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/qla4xxx/ql4_nx.c:983: warning: Function parameter or member 'ha' not described in 'qla4_82xx_pinit_from_rom'
 drivers/scsi/qla4xxx/ql4_nx.c:983: warning: Function parameter or member 'verbose' not described in 'qla4_82xx_pinit_from_rom'
 drivers/scsi/qla4xxx/ql4_nx.c:3225: warning: Function parameter or member 'code' not described in 'qla4_8xxx_uevent_emit'
 drivers/scsi/qla4xxx/ql4_nx.c:3697: warning: Function parameter or member 'ha' not described in 'qla4_82xx_read_optrom_data'
 drivers/scsi/qla4xxx/ql4_nx.c:3697: warning: Function parameter or member 'buf' not described in 'qla4_82xx_read_optrom_data'
 drivers/scsi/qla4xxx/ql4_nx.c:3697: warning: Function parameter or member 'offset' not described in 'qla4_82xx_read_optrom_data'
 drivers/scsi/qla4xxx/ql4_nx.c:3697: warning: Function parameter or member 'length' not described in 'qla4_82xx_read_optrom_data'

Cc: QLogic-Storage-Upstream@qlogic.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/qla4xxx/ql4_nx.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 85666fb5471b1..038e19b1e3c2d 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -974,10 +974,10 @@ qla4_82xx_rom_fast_read(struct scsi_qla_host *ha, int addr, int *valp)
 	return ret;
 }
 
-/**
+/*
  * This routine does CRB initialize sequence
  * to put the ISP into operational state
- **/
+ */
 static int
 qla4_82xx_pinit_from_rom(struct scsi_qla_host *ha, int verbose)
 {
@@ -3217,6 +3217,7 @@ static int qla4_8xxx_collect_md_data(struct scsi_qla_host *ha)
 /**
  * qla4_8xxx_uevent_emit - Send uevent when the firmware dump is ready.
  * @ha: pointer to adapter structure
+ * @code: uevent code to act upon
  **/
 static void qla4_8xxx_uevent_emit(struct scsi_qla_host *ha, u32 code)
 {
@@ -3685,9 +3686,9 @@ qla4_82xx_read_flash_data(struct scsi_qla_host *ha, uint32_t *dwptr,
 	return dwptr;
 }
 
-/**
+/*
  * Address and length are byte address
- **/
+ */
 static uint8_t *
 qla4_82xx_read_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
 		uint32_t offset, uint32_t length)
-- 
2.25.1

