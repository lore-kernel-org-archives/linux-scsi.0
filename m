Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA8BBC433F1
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:48:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A89F720720
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:48:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HXt1mOIj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729606AbgGMHsi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 03:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729149AbgGMHrB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 03:47:01 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C83CC08C5DD
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:47:00 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id f7so14681742wrw.1
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4xycoRjRF0CV8HBHzFk7ghiKnd/ULnjTxGfEHVQaX5o=;
        b=HXt1mOIjwGBzI6I/6a+Fct/YpIy3RLHUBFMeuwcxoNNOnaaKj/+phRNTr0aubBAXjp
         3fBSMZehlJV33UdN+RCRw3no7wzd/9jrPxa50QQWYbDW8mTl1FgEObVrt8li3yTo3yZ0
         7Og5PAVWB3x/mRnGUbtC01iSAHA8s9tcTya/R9u0+NWaarKJiXw1RxTAlfQga501Aggf
         9eMG2L6kca8UoxkQuD/pRKkT0eYZVw1wEyG3Rj4i2ErNNlYqeXx6Z5iCBlTr1XEiInxd
         w6vth0Vu+E8PFcHv32IRjxcZvYCC6bGsglMG1hxGfhyAAMQS8tTP/Np2O1f7pLxqYbNL
         xk8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4xycoRjRF0CV8HBHzFk7ghiKnd/ULnjTxGfEHVQaX5o=;
        b=b3aRoH6SoIBxzvmHLuqXVEA1XnBJWp04QYYvU9biLFdumFulPUJ4iwHJT6AZz6M8pY
         JGyvohXVUdrcJhXQ8zSqK1eiA+Ygpty3yBO53dgaH1bKFQYz9GA6lWohS0eiL4RdjiLi
         z0wDxziSRX6p0+9Jc50MNcM6SisLQr/5KH1/cetVZIE1ooBXhAUk8vYQNUrgtaduICmw
         2cpUJrQyBDhLadtZUVLbl06wdcMrKfczZ2iG8t6Ne6FCK1v3OlvTtKCs2/5dCQsScThL
         WjOIJWPsT+lqbA0LKPQjqV3MEPspTXIP0kdg/L2C8AA0HLsArbQz4+GwjN0Y02LStX+x
         3Umg==
X-Gm-Message-State: AOAM530Q61v18BMsof4Gc/9WmKSMX0Nxyho2ZRPWKGYvnpn63nrkDOAh
        4ONoTtH0CJAMFXR1zeSOKPCqAA==
X-Google-Smtp-Source: ABdhPJxmZ/AQaXVcB3088GpUy8IfIcOB19Rj+ZSqQoYi0+002qxojV+kO/fpzG/XGCf2iFmmAMJSxQ==
X-Received: by 2002:a5d:634e:: with SMTP id b14mr83653473wrw.423.1594626419345;
        Mon, 13 Jul 2020 00:46:59 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id k11sm25142488wrd.23.2020.07.13.00.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 00:46:58 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v2 11/29] scsi: libfc: fc_rport: Fix a couple of misdocumented function parameters
Date:   Mon, 13 Jul 2020 08:46:27 +0100
Message-Id: <20200713074645.126138-12-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713074645.126138-1-lee.jones@linaro.org>
References: <20200713074645.126138-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/libfc/fc_rport.c:129: warning: Function parameter or member 'port_id' not described in 'fc_rport_create'
 drivers/scsi/libfc/fc_rport.c:129: warning: Excess function parameter 'ids' description in 'fc_rport_create'
 drivers/scsi/libfc/fc_rport.c:1452: warning: Function parameter or member 'rdata_arg' not described in 'fc_rport_logo_resp'
 drivers/scsi/libfc/fc_rport.c:1452: warning: Excess function parameter 'lport_arg' description in 'fc_rport_logo_resp'

Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/libfc/fc_rport.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 278d15ff1c5ae..18663a82865f9 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -121,7 +121,7 @@ EXPORT_SYMBOL(fc_rport_lookup);
 /**
  * fc_rport_create() - Create a new remote port
  * @lport: The local port this remote port will be associated with
- * @ids:   The identifiers for the new remote port
+ * @port_id:   The identifiers for the new remote port
  *
  * The remote port will start in the INIT state.
  */
@@ -1445,7 +1445,7 @@ static void fc_rport_recv_rtv_req(struct fc_rport_priv *rdata,
  * fc_rport_logo_resp() - Handler for logout (LOGO) responses
  * @sp:	       The sequence the LOGO was on
  * @fp:	       The LOGO response frame
- * @lport_arg: The local port
+ * @rdata_arg: The remote port
  */
 static void fc_rport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
 			       void *rdata_arg)
-- 
2.25.1

