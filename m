Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E93EC001DB
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Aug 2023 19:43:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjHDTm7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Aug 2023 15:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjHDTm6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2023 15:42:58 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 060431BF
        for <linux-scsi@vger.kernel.org>; Fri,  4 Aug 2023 12:42:58 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id af79cd13be357-767e87b7199so28952385a.1
        for <linux-scsi@vger.kernel.org>; Fri, 04 Aug 2023 12:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691178177; x=1691782977;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ua39BKrn2eqXFmpMhs5eoV/5H3DtnoAUyBaV+ozwKog=;
        b=L2LIRrb3OSCuU25zDre81GbLLNvdjpKuoM8fpWEgzGvUR88BRoccmE4xS1WvJy+5/s
         AWkOBICm+835z4M1ZWUDV872ee+GPIQpm5wTYox21UDfn+lVtkCNdF1YpVzbII5GoKCN
         8iswP0BeTJGEoGRUSA3A8aR3iOpdmHWQiS3TrIbfHIPhkAybpCLpJO9RbLibCzKcb28X
         7XdaSejDLwP21JC0doCZpYA0NlCrLAcnC+atNWH8WcNqPz4HqSjTmP38L44r4jq5wXcj
         2KKi7o9HwkN4yPQ2yDnWK7gB3gHLX120CkvRW3UZghHAZp0TIMqwQSn87l+em7K1I55h
         bDOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691178177; x=1691782977;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ua39BKrn2eqXFmpMhs5eoV/5H3DtnoAUyBaV+ozwKog=;
        b=NmpnrECJgLtkSAPr2WQKZa6VqzISA0jwgN6ZwwPY9dlv5tT5CeKheggHUzJRyryDn0
         4OY6jE/7mtKu26XfQH1GVIPfXiGk2nuXDn7P7r6NWCBDBnsxSG08CUqZv8brjuav/wi0
         0uXcMPYMArHTz9gXPRr81AN0z/yhx8Fa+yz/RQc8aI9zBxTbBiRhqB8FwbaXERYMII5g
         9iDoaeGvl7HVe52WIKFlHcl/2s5KltyKKRzf3/zd3uybSpYm7uqS7yDv4UTwojCGD5nj
         PH6tudhE/Jdq3OdtuWQusFZIEY1stEn4s0jUvmgUXObxUXC4StjQm+sYqXC+d8zs98tD
         Alnw==
X-Gm-Message-State: AOJu0YxqsL70kf8IYuDLaiuVaedX0BE/IBh+72S9h4tEYelXvGv0nBAa
        1ujzu/xtDiyeLa2bPJSOaKTXCjbMR5w=
X-Google-Smtp-Source: AGHT+IEwAW7y7euVHBVpqbr9nKSQ8tFIYSWao/+Um/8Gy3e0SYVFAdgu6Hw009QFW90MUNjeWSUL7Q==
X-Received: by 2002:a05:620a:372a:b0:76c:e76b:4192 with SMTP id de42-20020a05620a372a00b0076ce76b4192mr5040958qkb.0.1691178176905;
        Fri, 04 Aug 2023 12:42:56 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c3-20020a05620a11a300b0076ce061f44dsm865943qkk.25.2023.08.04.12.42.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Aug 2023 12:42:56 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 1/1] lpfc: Modify when a node should be put in device recovery mode during RSCN
Date:   Fri,  4 Aug 2023 12:55:46 -0700
Message-Id: <20230804195546.157839-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Only nodes whose state is at least past a PLOGI issue and strictly less
than a PRLI issue should be put into device recovery mode upon RSCN
receipt.  Previously, the allowance of LOGO and PRLI completion states did
not make sense because those nodes should be allowed to flow through and
marked as NPort dissappeared as is normally done.  A follow up RSCN
GID_FT would recover those nodes in such cases.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 388a481c8118..467c255bbe4c 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5782,7 +5782,7 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 				return NULL;
 
 			if (ndlp->nlp_state > NLP_STE_UNUSED_NODE &&
-			    ndlp->nlp_state < NLP_STE_NPR_NODE) {
+			    ndlp->nlp_state < NLP_STE_PRLI_ISSUE) {
 				lpfc_disc_state_machine(vport, ndlp, NULL,
 							NLP_EVT_DEVICE_RECOVERY);
 			}
-- 
2.38.0

