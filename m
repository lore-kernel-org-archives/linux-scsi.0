Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10CB7C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:47:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBE0E207DD
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:47:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="V8V9ImnR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728824AbgGIRr3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 13:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728505AbgGIRqJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 13:46:09 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E401DC08E6DC
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jul 2020 10:46:08 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id f7so3317458wrw.1
        for <linux-scsi@vger.kernel.org>; Thu, 09 Jul 2020 10:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kZ+k2VRrvfDu4ASYD2+0hveDy1rv8dVhxsnPb7NP+X0=;
        b=V8V9ImnR8xB5UICcA8klK0T3O2TMEGcxT3IeNsvPi2SesI8NXMjPkjfKTzlDixJeCA
         TQUqVu9VgmdWB+IBVVm0GRFDpp3C7Gk64FNmT42cb45zFIF6tGGGrHhXyzp6hbmv9o+R
         u8TYWFy6Cr7KgZDkvlKEz8xv7m2tev+Z26lCnfQh3hnc1EebHn1tpGWwp34hZ4n9rDgo
         kIVsqIXv64xReH0F7tfZIN+biNjWMFRe5z+Ri70+RxymufKT/jhglyDIQQEkuPVjzlAo
         tBASIAPgtFIRXkLj84Eq/CYZEOVlPaD1UXcI1xLsL+/1SRFCDJaiM0te7MPC2S/VM+u7
         7w9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kZ+k2VRrvfDu4ASYD2+0hveDy1rv8dVhxsnPb7NP+X0=;
        b=dCpTqEuIFVqnT6jD3OUdqZEXd0JY/ZdTdewfqm9OKP8tSCaKnTu2PDaOewF13x2gsH
         rzahB8iR/gi6H2fZSI/q1XhGFeVeq65zPygfxNenGyynB7qoauo0acnUAGoIxddHf/IF
         plG3pRPHH9r7E6tq505kOzr2+nc5146c8Ksyn9C4h9eXhGTb42fzC91oy/CuErGpTwFZ
         phn4ivXA4EZRFmZ9X9P8GT1dtvL66deH0KwgnPYZ/bjpXX7LAnhKvbIMCyQBz9ivz79C
         6svoHWqXaAd3MYIdH6SEyybTzuWM+LItzJR4N8Ijy+mZZUh3azL9URK8ZWfKQtv6heDg
         ouiQ==
X-Gm-Message-State: AOAM530FX2p9zd3IUjhYoMdTw5s5Q6x6nLYl4ajluA+VJSSwAwVC23V7
        klV6ret1WZjzq+U0oQfG0sg/Rw==
X-Google-Smtp-Source: ABdhPJy+miydl2tuFxxupMnPPutDp0xHv0OR8pXKzQnBcY7vuhjlJBfhS9/bSR6axO66wkFsLF6fLQ==
X-Received: by 2002:adf:c44d:: with SMTP id a13mr66244554wrg.205.1594316767535;
        Thu, 09 Jul 2020 10:46:07 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id f15sm6063854wrx.91.2020.07.09.10.46.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 10:46:07 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [PATCH 08/24] scsi: aic94xx: aic94xx_scb: Fix a couple of formatting and bitrot issues
Date:   Thu,  9 Jul 2020 18:45:40 +0100
Message-Id: <20200709174556.7651-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200709174556.7651-1-lee.jones@linaro.org>
References: <20200709174556.7651-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Kerneldoc format should be '@.*: ', else the checker gets confused.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aic94xx/aic94xx_scb.c:137: warning: Function parameter or member 'phy' not described in 'asd_get_attached_sas_addr'
 drivers/scsi/aic94xx/aic94xx_scb.c:137: warning: Function parameter or member 'sas_addr' not described in 'asd_get_attached_sas_addr'
 drivers/scsi/aic94xx/aic94xx_scb.c:860: warning: Function parameter or member 't' not described in 'asd_ascb_timedout'
 drivers/scsi/aic94xx/aic94xx_scb.c:860: warning: Excess function parameter 'data' description in 'asd_ascb_timedout'

Cc: Luben Tuikov <luben_tuikov@adaptec.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aic94xx/aic94xx_scb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_scb.c b/drivers/scsi/aic94xx/aic94xx_scb.c
index 4a80ec08f0c96..c264b4b56970b 100644
--- a/drivers/scsi/aic94xx/aic94xx_scb.c
+++ b/drivers/scsi/aic94xx/aic94xx_scb.c
@@ -123,8 +123,8 @@ static unsigned ord_phy(struct asd_ha_struct *asd_ha, struct asd_phy *phy)
 
 /**
  * asd_get_attached_sas_addr -- extract/generate attached SAS address
- * phy: pointer to asd_phy
- * sas_addr: pointer to buffer where the SAS address is to be written
+ * @phy: pointer to asd_phy
+ * @sas_addr: pointer to buffer where the SAS address is to be written
  *
  * This function extracts the SAS address from an IDENTIFY frame
  * received.  If OOB is SATA, then a SAS address is generated from the
@@ -847,7 +847,7 @@ void asd_build_initiate_link_adm_task(struct asd_ascb *ascb, int phy_id,
 
 /**
  * asd_ascb_timedout -- called when a pending SCB's timer has expired
- * @data: unsigned long, a pointer to the ascb in question
+ * @t: Timer context used to fetch the SCB
  *
  * This is the default timeout function which does the most necessary.
  * Upper layers can implement their own timeout function, say to free
-- 
2.25.1

