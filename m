Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7676C4332E
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C40C264EEE
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355450AbhCDAct (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:32:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234429AbhCCOw2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 09:52:28 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8047AC0610D2
        for <linux-scsi@vger.kernel.org>; Wed,  3 Mar 2021 06:47:45 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id w7so5393063wmb.5
        for <linux-scsi@vger.kernel.org>; Wed, 03 Mar 2021 06:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U92/RQ3hpLZuYnPJtsOpX25Ju+xsfO8zWOU6k76xGHs=;
        b=rNsskH/w5bS8B3UXyXbYeb3x7TdttXqfSrFaKyJlnbBo1iMvOfaWCQkN4RiP4tsGty
         /7poK+nS0jVRPENWhBrjf0utc734Ad17uNRMG4/DmK3dNspWCkP/BFkegAQdcUG/LJmg
         cBCHzxDaohMBfzaR9MjbVuSF9T8ExP+jj22uuGWrg6VMUHMhvR9ExgZHk8XK2yeHlfEa
         /EVJ9pgupROEK05kfYBn67Z83PZFGEG52eJvDNc7bufAEFVgdnKIxR093iKcA1iOijPz
         AjGb3qxQh1oLKCevw2Duftgx+kDg1GePvYUqGHh9X2QDluwVFkkpN0xTYK71ex45kpSR
         QFrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U92/RQ3hpLZuYnPJtsOpX25Ju+xsfO8zWOU6k76xGHs=;
        b=H4o5vCAIVnQy6T59FpnvthatFVcZBIMqiRMJ4x4u7/ZstSn+iR+qblvuErMkEG0NKh
         gCRS+me21YjX71AxHzJl98H5Xc6K1172xkXlVgOd3DozfV8qdEnRGePOCsoJb0WoRrsc
         qi7L9MV1ZQCYa7M5RqGtwOQue3Myg7CIETljQgKfo7m3YojuIOn8YNqt1/2G4Jy7cEcA
         vGbs2sIs+bWoCiT3Ac+ehjaCn/ZfTUd1kZ0zOdwsXSDC10YkB36D1Ga1+L7hjMjo0aUp
         CDNoju7MvbsO7rxkRYJWamcJu1nWg4hISf47iinknt5F6uqs57kA3q0UBMB4hd1Sx0I7
         HfmQ==
X-Gm-Message-State: AOAM532J9VGwOptBhmEPbIU7uDHJBCUAqeBJCDlN0idf8/aCfrrs/3NK
        wFKJXkwbeCxHccR0jBy53wm8dQtFF0W0EA==
X-Google-Smtp-Source: ABdhPJyE6wgr9mNM1wEy0PMtTFZ9XEX7/Vl2VTHLplVq+KbhEEYuWhfAvSSaU02WJTkn1TEh6UY1Xw==
X-Received: by 2002:a05:600c:1550:: with SMTP id f16mr5448736wmg.97.1614782864204;
        Wed, 03 Mar 2021 06:47:44 -0800 (PST)
Received: from dell.default ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id a14sm36567233wrg.84.2021.03.03.06.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 06:47:43 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 26/30] scsi: libfc: fc_lport: Fix some possible copy/paste issues
Date:   Wed,  3 Mar 2021 14:46:27 +0000
Message-Id: <20210303144631.3175331-27-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303144631.3175331-1-lee.jones@linaro.org>
References: <20210303144631.3175331-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/libfc/fc_lport.c:710: warning: expecting prototype for fc_rport_enter_ready(). Prototype was for fc_lport_enter_ready() instead
 drivers/scsi/libfc/fc_lport.c:759: warning: expecting prototype for fc_lport_set_port_id(). Prototype was for fc_lport_set_local_id() instead
 drivers/scsi/libfc/fc_lport.c:1400: warning: expecting prototype for fc_rport_enter_dns(). Prototype was for fc_lport_enter_dns() instead
 drivers/scsi/libfc/fc_lport.c:1516: warning: expecting prototype for fc_rport_enter_fdmi(). Prototype was for fc_lport_enter_fdmi() instead
 drivers/scsi/libfc/fc_lport.c:1647: warning: expecting prototype for fc_rport_enter_logo(). Prototype was for fc_lport_enter_logo() instead
 drivers/scsi/libfc/fc_lport.c:1789: warning: expecting prototype for fc_rport_enter_flogi(). Prototype was for fc_lport_enter_flogi() instead

Cc: Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/libfc/fc_lport.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 22826544da7e7..78bd317f0553b 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -703,7 +703,7 @@ static void fc_lport_disc_callback(struct fc_lport *lport,
 }
 
 /**
- * fc_rport_enter_ready() - Enter the ready state and start discovery
+ * fc_lport_enter_ready() - Enter the ready state and start discovery
  * @lport: The local port that is ready
  */
 static void fc_lport_enter_ready(struct fc_lport *lport)
@@ -747,7 +747,7 @@ static void fc_lport_set_port_id(struct fc_lport *lport, u32 port_id,
 }
 
 /**
- * fc_lport_set_port_id() - set the local port Port ID for point-to-multipoint
+ * fc_lport_set_local_id() - set the local port Port ID for point-to-multipoint
  * @lport: The local port which will have its Port ID set.
  * @port_id: The new port ID.
  *
@@ -1393,7 +1393,7 @@ static struct fc_rport_operations fc_lport_rport_ops = {
 };
 
 /**
- * fc_rport_enter_dns() - Create a fc_rport for the name server
+ * fc_lport_enter_dns() - Create a fc_rport for the name server
  * @lport: The local port requesting a remote port for the name server
  */
 static void fc_lport_enter_dns(struct fc_lport *lport)
@@ -1509,7 +1509,7 @@ static void fc_lport_enter_ms(struct fc_lport *lport, enum fc_lport_state state)
 }
 
 /**
- * fc_rport_enter_fdmi() - Create a fc_rport for the management server
+ * fc_lport_enter_fdmi() - Create a fc_rport for the management server
  * @lport: The local port requesting a remote port for the management server
  */
 static void fc_lport_enter_fdmi(struct fc_lport *lport)
@@ -1640,7 +1640,7 @@ void fc_lport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
 EXPORT_SYMBOL(fc_lport_logo_resp);
 
 /**
- * fc_rport_enter_logo() - Logout of the fabric
+ * fc_lport_enter_logo() - Logout of the fabric
  * @lport: The local port to be logged out
  */
 static void fc_lport_enter_logo(struct fc_lport *lport)
@@ -1782,7 +1782,7 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 EXPORT_SYMBOL(fc_lport_flogi_resp);
 
 /**
- * fc_rport_enter_flogi() - Send a FLOGI request to the fabric manager
+ * fc_lport_enter_flogi() - Send a FLOGI request to the fabric manager
  * @lport: Fibre Channel local port to be logged in to the fabric
  */
 static void fc_lport_enter_flogi(struct fc_lport *lport)
-- 
2.27.0

