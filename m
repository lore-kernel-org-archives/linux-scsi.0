Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 833CEC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:46:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F7FC64E42
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:46:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbhBKXq3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:46:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbhBKXqQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 18:46:16 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351E4C061797
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:44:59 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id 18so4729038pfz.3
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:44:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aAwqMkxR5jmbdpZ/kt3Y60rTc3/iCtg+1m9eehVwyYc=;
        b=YT5yYoJTXf8vRZ9SjeRYpw0l6akpDHeRTiSYDUq5FZ/gBOzw5M/ZsSNhAeR1UFIhtx
         3VL34emz+JPME4kcrM7g3/pHNrxAxH4RkyEnqvYxuQTjTRDEJfSfOjPrOThPGwfnCiGe
         endveGDmRrX55RQI5PRZcLnk6FVZqi6LXsbB1O4K6xh6KlH1oo1jTaR/cOJ7x0WnFczo
         30xAA9mg2SqBMgZ/LSuQu6ySEkY8SqvFCGhD7T+rDPWDwIaYfQYBiD1x/JFisG+OcbBI
         +UNHpbugTmFXnjoAGFDwYnXvUJDZX4D0NPdPOjTnvXFUEn85HgDZAH/1ljvVQQUaspOd
         vB2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aAwqMkxR5jmbdpZ/kt3Y60rTc3/iCtg+1m9eehVwyYc=;
        b=JX1z9WpZyKMxvBpSMeeL3pU6CSQKeOKI14DX0nz/yxd+f8ToGpx67Vi3g17OXBHksT
         R3cFXn9lLMiwfHlOx6erLhUFN27flbbB4P2GuWNBbIi9+ekq6wBweHPaXPrm0wdO52mo
         Ml0aIE1paT5qRykedNCWOIfqxgx7UlqO18bMWtp4IHD6FsxSL5CXAfPS2thl6ZhiiCao
         cSw2pyxcI9fDbRHisRBUI9afSt//ouLYDu+1BeSiayMkrGT+bE45bMlviAP0fd91M2rJ
         MXpI7LupS1Z2pH7etD61M8JH8uw3xKEjAKvinu230hhgzoef6uUUgpQFtOqfRl/lX+mg
         BZ/w==
X-Gm-Message-State: AOAM530lD3WZ/jbwI0+vIhLz9ASZlmPIoBCxfTbku26JuMC9tnu8FQjd
        mosJDvgaZMiPQl+QnvTF3OyrZRXIwiw=
X-Google-Smtp-Source: ABdhPJxkDEfxIq9MsD0tvoXizlqeC5o6pr2HJYLG80/aGkf7zLLg2RjZOP1ZqthhU8fvk6tSKOraiQ==
X-Received: by 2002:a62:35c6:0:b029:1ba:e795:d20e with SMTP id c189-20020a6235c60000b02901bae795d20emr398791pfa.37.1613087098628;
        Thu, 11 Feb 2021 15:44:58 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i67sm6808035pfe.19.2021.02.11.15.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 15:44:58 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 11/22] lpfc: Fix status returned in lpfc_els_retry() error exit path
Date:   Thu, 11 Feb 2021 15:44:32 -0800
Message-Id: <20210211234443.3107-12-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210211234443.3107-1-jsmart2021@gmail.com>
References: <20210211234443.3107-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An unlikely error exit path from lpfc_els_retry() returns incorrect
status to a caller, erroneously indicating that a retry has been
successfully issued or scheduled.

Change error exit path to indicate no retry.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index ee362e6c0d62..a359d0ddd6e8 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3822,7 +3822,7 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		did = irsp->un.elsreq64.remoteID;
 		ndlp = lpfc_findnode_did(vport, did);
 		if (!ndlp && (cmd != ELS_CMD_PLOGI))
-			return 1;
+			return 0;
 	}
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
-- 
2.26.2

