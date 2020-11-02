Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21475C55179
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 14:25:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA8F0206B7
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 14:25:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="c26/VTOQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbgKBOYK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 09:24:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgKBOYI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 09:24:08 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3A8C061A47
        for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2020 06:24:08 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id p19so1371428wmg.0
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2020 06:24:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wt3lPJzwtefGpxth/KkqzzH7BRhJIilxCKkHD5PPJbE=;
        b=c26/VTOQ58vAsDiS1Vsz3KlTbK0BTgeqF+Q5twhuB7TzHIvKWJfFdc9xEBJ4f01cWf
         KHIO9qPNW1uffiaMTqPO2cm3L+vj4FLm/W7I/CtbG1ahJkEokn7zYbkuOBczRx4x5CrS
         xfk3y04A0O5A/gKN5fGcFlzaj9BBIrCznuKk1yHcyM0Aq7xp6BeYMdasuTLluCbhi7if
         x3l9D8u/OSTdB6G/S9Wwxea7zXUajOc9SIvn/as2cgFQ1NY9NGOLWYGM398O85Ze1OnC
         vpkLuhvoADtDV3s2gGesqsblops16f51DVS6r/18uommFBCYOHzpvH6knaCchjjTInoH
         m4Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wt3lPJzwtefGpxth/KkqzzH7BRhJIilxCKkHD5PPJbE=;
        b=nJ/zQOlSxYikH5B8i/0gpvJOo3KlSHnY4Rx1PctfMS1P5wJDSKZEwrX/fKYHF34KqA
         rlVn0TLVfMUxIqp6rgAD45/OrWVC7uo5JUpnbAE8cm8oiRDj0PzODuJ5DfX1rWFi0Sgp
         BSGKbIh+jYZfaIrROxaR8ft6aECWAaJRatTwJfGKQ5KYIoAj3jb0bZaw9rjnNcGFxE6P
         thnen5mkFmkxtLhdRcv/3dymg6QdnQ0Wl+dPUocFGfZPLWdgrNUoJaX/isQbgVimWwD+
         CRSS8V9KCbVcIo1ualB6DvfBdC83tBP+WKCqAYvGIXKm1fq3O5jxr2Wu0rBdlP63M0Yt
         yi7Q==
X-Gm-Message-State: AOAM531JFAOhD2aGsC1+E893rInoUrClB0dqUGR5WPKOVOjuNCmoMAbj
        WbKdp9xEiLmsgXhwe2O8lsX1Cgkd6ZoekA==
X-Google-Smtp-Source: ABdhPJxdQFgpDB63CTFLtIuoJH4zQOZBwaIrU/WkK1h0ikmbxG2XFdjLlAUtx4tF+4YcpgjnxaL4dw==
X-Received: by 2002:a7b:ce05:: with SMTP id m5mr19074687wmc.16.1604327042997;
        Mon, 02 Nov 2020 06:24:02 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id f7sm23542501wrx.64.2020.11.02.06.24.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 06:24:02 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Hannes Reinecke <hare@suse.com>
Subject: [RESEND 01/19] scsi: aic7xxx: aic79xx_osm: Remove unused variable 'saved_scsiid'
Date:   Mon,  2 Nov 2020 14:23:41 +0000
Message-Id: <20201102142359.561122-2-lee.jones@linaro.org>
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

 drivers/scsi/aic7xxx/aic79xx_osm.c: In function ‘ahd_linux_queue_abort_cmd’:
 drivers/scsi/aic7xxx/aic79xx_osm.c:2143:9: warning: variable ‘saved_scsiid’ set but not used [-Wunused-but-set-variable]

Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aic7xxx/aic79xx_osm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index f32398939f74b..d413b1c5fdc54 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -2140,7 +2140,6 @@ ahd_linux_queue_abort_cmd(struct scsi_cmnd *cmd)
 	u_int  saved_scbptr;
 	u_int  active_scbptr;
 	u_int  last_phase;
-	u_int  saved_scsiid;
 	u_int  cdb_byte;
 	int    retval = SUCCESS;
 	int    was_paused;
@@ -2254,7 +2253,7 @@ ahd_linux_queue_abort_cmd(struct scsi_cmnd *cmd)
 	 * passed in command.  That command is currently active on the
 	 * bus or is in the disconnected state.
 	 */
-	saved_scsiid = ahd_inb(ahd, SAVED_SCSIID);
+	ahd_inb(ahd, SAVED_SCSIID);
 	if (last_phase != P_BUSFREE
 	    && SCB_GET_TAG(pending_scb) == active_scbptr) {
 
-- 
2.25.1

