Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15357C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 23:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbiDLXhD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbiDLXcx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 19:32:53 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BECC55AC
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:24 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 32so16371994pgl.4
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kCeFR0DmMyBTfxzSFY7bapfffPNjkhfG6SO3YcE1Mnw=;
        b=KmFj2DFk5vHARJzCHjBmg+JVJBDQcoY2vQCTpitZoXfKKU2tTVShp33zOh6+lyV4Km
         hYSF86pd/YhDgNK/4iMfsVNyUQl9SjhpzmE7lykyBpNMu45b5WRyNC6IBpRIMY0DmOvh
         w0BMRs6I49UYlnAojEsZ5OXCwrEZrOs+VEefh39kpHdkpal+m9JPdUPaE/g0DzJUjHbQ
         L7jbRfPcUpCUBfABHhUmITryzdBFUqJRU5nXFCyg0vVwt1c9sVkTIzm4+9wYbANAVWt/
         l//h6enDwSdpplTzvDg5fjBau2OwEj7S6FBzknHrY3UQdcARbxp0WkcowBq64P5jbqtm
         j7kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kCeFR0DmMyBTfxzSFY7bapfffPNjkhfG6SO3YcE1Mnw=;
        b=F9csDO/0NKpji8ZCOr8pI2eVKZARKLAUChEVeKnok+6ew4YdpHQdSt1WQo2iHE+RcJ
         Wt3GZdi7Mni713QifMvflJAXZXMghcdoHhDZDeCPK0yXKycnezg4s6DNGSkEM3LBuK5K
         ChofGngdumUL7ogPyXI0/BgLR0zxMMjgpo+Suf3MBPe+oX0zSKNW6aeIiMReeFr3r0lK
         FfetUcILr0Q1LUxDKV6y0IPbT3n4tTGlIcjt5Val2vlGjqsFLxytZc39t2WjjaVAsYg/
         kdvJ+9GoTOW6I1rjjqxaFwtoPafCyPx6s3xdL1Auc2F6zD1ZT/+QGxSP289Wt0OfBmm6
         Gk3g==
X-Gm-Message-State: AOAM533PDzLISBjQR1QeZF8Uf79wQL43heqlfJ1xlPT3EfLtxHZc2xrD
        pndS+juZNK9sIorvnKJKV2F+pDVcooU=
X-Google-Smtp-Source: ABdhPJywN2p/E66Uz77oV9R292fTJonLftC9GGne9eKwLsbClbulNQuevszE38mFgEhPdA+/kVGXsg==
X-Received: by 2002:a05:6a00:10c7:b0:4fd:9ee6:4130 with SMTP id d7-20020a056a0010c700b004fd9ee64130mr40833644pfu.84.1649802024230;
        Tue, 12 Apr 2022 15:20:24 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a000b8f00b004fa9dbf27desm40429824pfj.55.2022.04.12.15.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 15:20:24 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 12/26] lpfc: Remove unnecessary NULL pointer assignment for ELS_RDF path
Date:   Tue, 12 Apr 2022 15:19:54 -0700
Message-Id: <20220412222008.126521-13-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220412222008.126521-1-jsmart2021@gmail.com>
References: <20220412222008.126521-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The command IOCB ndlp pointer is overwritten in lpfc_issue_els_rdf,
and the original ndlp pointer is stored ahead of time.

This null ptr assignment can be safely removed.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 54456ddc6a90..3bcc0243bf42 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3387,7 +3387,6 @@ lpfc_cmpl_els_disc_cmd(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				lpfc_issue_els_edc(vport, cmdiocb->retry);
 				break;
 			case ELS_CMD_RDF:
-				cmdiocb->context1 = NULL; /* save ndlp refcnt */
 				lpfc_issue_els_rdf(vport, cmdiocb->retry);
 				break;
 			}
-- 
2.26.2

