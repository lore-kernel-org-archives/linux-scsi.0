Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65242C433E1
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:46:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B8C420836
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:46:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oeuXKq7H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbgGIRqd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 13:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728698AbgGIRqb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 13:46:31 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F03ADC08C5DC
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jul 2020 10:46:27 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id o2so2759563wmh.2
        for <linux-scsi@vger.kernel.org>; Thu, 09 Jul 2020 10:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fm6ETESXIB5CrW3r789w0mlqtcsT6pJud5uFiJPthig=;
        b=oeuXKq7HqPRnLj58gfRQ92ze1bM1Z3F9QjlMoXsNrjDPb5+LgZjLmHMGMg9nlXeSSL
         AQGJCce4MIKurfddPFWOI/N/XA6ap7w4N1SwjBbDxlW02uNnVolEOoAMvlU56F/tBFQX
         5tahbBo0hpUw2O55vC147HvoBSwOXZ81MtUjMbWCWCc/wHZs6uaviinNlAWipv0W6ZSA
         1TVTKnneRLOojR2tkRBYWO9vLojr+ajMw3IS90LOwy8fkYpy/ULuIX/68/P8yjqV3I66
         KenUeJR74DsbeUMWcDEZJSEgNl9Sb3EXYEJBXg53i7cLvkcZJ6mrqEnUJ5ZXcBnUm45V
         OOvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fm6ETESXIB5CrW3r789w0mlqtcsT6pJud5uFiJPthig=;
        b=U203ipIE5B/kfMzV0Ocv+oxcELfc8hlcMyFKCfVEaPN/RTVrnxk04E62l6sycr+Zrs
         YEhF3VTytlkOY8Tbo+ay5qcrs8TFkPOzU+Zk76LKHiwWZCcrS7YllppSS/OKqQVvo3D7
         adrXojHdcvzHRDB3r9I9vYuQj3rvo7oSGEfo26h3lbhd3wv4DOlo0cPPYELGzTpKDkMJ
         NwrLPVd1CjYQLzK5IEalkDX9JDMki1jrnOa+HACpPo5dIk54ZXppeV0SBWTdew+KdjUd
         PpDyfqOtaVTUiMS+Qkh8rLPNNYvTPCLGnnXmUCK7WcMc/nr64TQ42vWtNgKaJIp4Uy1Z
         0Lpg==
X-Gm-Message-State: AOAM533oQujmaEEnHQC2VamRe1pHVrzLW+/dExeGX87fgmXBYYErevR2
        Jp5Fe8jBJalk0szoaDStfJ0TiA==
X-Google-Smtp-Source: ABdhPJwygWu8lbFdwwJ4gwEoQEio21Iuq/YTLu1tXqfO8ctAmIZoVF901pwyTr5oWZIGC+9znNEkzA==
X-Received: by 2002:a7b:c8c2:: with SMTP id f2mr1057654wml.57.1594316786678;
        Thu, 09 Jul 2020 10:46:26 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id f15sm6063854wrx.91.2020.07.09.10.46.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 10:46:25 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 24/24] scsi: aic7xxx: aic79xx_osm: Remove set but unused variabes 'saved_scsiid' and 'saved_modes'
Date:   Thu,  9 Jul 2020 18:45:56 +0100
Message-Id: <20200709174556.7651-25-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200709174556.7651-1-lee.jones@linaro.org>
References: <20200709174556.7651-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Haven't been used since 2006.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aic7xxx/aic79xx_osm.c: In function ‘ahd_linux_queue_abort_cmd’:
 drivers/scsi/aic7xxx/aic79xx_osm.c:2155:17: warning: variable ‘saved_modes’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/aic7xxx/aic79xx_osm.c:2148:9: warning: variable ‘saved_scsiid’ set but not used [-Wunused-but-set-variable]

Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aic7xxx/aic79xx_osm.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 3782a20d58885..b0c6701f64a83 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -2141,14 +2141,12 @@ ahd_linux_queue_abort_cmd(struct scsi_cmnd *cmd)
 	u_int  saved_scbptr;
 	u_int  active_scbptr;
 	u_int  last_phase;
-	u_int  saved_scsiid;
 	u_int  cdb_byte;
 	int    retval;
 	int    was_paused;
 	int    paused;
 	int    wait;
 	int    disconnected;
-	ahd_mode_state saved_modes;
 	unsigned long flags;
 
 	pending_scb = NULL;
@@ -2239,7 +2237,7 @@ ahd_linux_queue_abort_cmd(struct scsi_cmnd *cmd)
 		goto done;
 	}
 
-	saved_modes = ahd_save_modes(ahd);
+	ahd_save_modes(ahd);
 	ahd_set_modes(ahd, AHD_MODE_SCSI, AHD_MODE_SCSI);
 	last_phase = ahd_inb(ahd, LASTPHASE);
 	saved_scbptr = ahd_get_scbptr(ahd);
@@ -2257,7 +2255,7 @@ ahd_linux_queue_abort_cmd(struct scsi_cmnd *cmd)
 	 * passed in command.  That command is currently active on the
 	 * bus or is in the disconnected state.
 	 */
-	saved_scsiid = ahd_inb(ahd, SAVED_SCSIID);
+	ahd_inb(ahd, SAVED_SCSIID);
 	if (last_phase != P_BUSFREE
 	    && SCB_GET_TAG(pending_scb) == active_scbptr) {
 
-- 
2.25.1

