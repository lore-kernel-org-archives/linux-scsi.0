Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53FE5C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 23:34:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbiDLXgy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbiDLXct (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 19:32:49 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F48C5597
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:21 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id bo5so292313pfb.4
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dMcgvsaJy476aoGknEpQcY1yWCbBcZwV5vLzyc/E0jI=;
        b=Xq5l8IvBf0CZ6lleEjfExwon9IF209ubudXonpeKvujXV6PSy8un3A0Of4Mws6zJXL
         IIm22AyjrB0FcjiakKr5u+ntuRhQWf4JYv1KJME/fX9TxHVFq/w7RsbVNMl5NwYp/mE5
         mVk8Jp4ez32phUKJHwWUIiiClLVkmpobJD7e/uMQpuaFqLAdWWRi3kZFfsxaaGW2zVFk
         dxKXqhVuM2poTsXvujmTZMQRoap8kay1exYyUoYwTbkfNbGDxiehp7IDOZA48QXxp33H
         zCIrfXhKdoJdPLZ8JBL+us7LDRut7dgjEh0ve2cxtI0AhVuVGhNT//IUZtFjaujhkqpm
         CzZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dMcgvsaJy476aoGknEpQcY1yWCbBcZwV5vLzyc/E0jI=;
        b=siPis0w1YWhOYyBZiHuitucAuRp9ggtsnEysr7wER6UPQbL5vY+uBPCnfBtsIq5eqD
         WTJYB+64l6TDpRhnVCM4TtPdzg4CQUIP+NH6l3ENH7MazzASsWEXDEHVtoaRXdMWc+wK
         nJXtaMTHNDISgwQWlqZUaN2KcvueIVlKoyJTL1Jg/FmKPmm2Ui0CwcyuJieoJiAqYbg2
         KTMr70Td0UNi7BpV8SeEoF6jG8El56rJ+2owh0RZEXY5bqG8exavtJ2VtGyax2d2SoyC
         ZiC5YsiqTnoeXC53+cXWPjGBXl7qyPbleiVw220CzUuTowQIZpy2S8YGAaBIAj29+M0X
         SIPw==
X-Gm-Message-State: AOAM532xwZV/CnQ0MFDbqKTAzEaucp957iKgxQka7iAgBwPfjpKPCEyh
        oF3fGS5IWz/urJx616vyijzmykzuGq8=
X-Google-Smtp-Source: ABdhPJzqubXIS2sVMqUc1SmuqA5GgEk3poaE1irXsc0/gedFYOXghQo1KjeWVYYaNHeujHdKA7KUug==
X-Received: by 2002:a65:6955:0:b0:380:64fd:a2dd with SMTP id w21-20020a656955000000b0038064fda2ddmr31750274pgq.383.1649802020581;
        Tue, 12 Apr 2022 15:20:20 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a000b8f00b004fa9dbf27desm40429824pfj.55.2022.04.12.15.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 15:20:20 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 07/26] lpfc: Clear fabric topology flag before initiating a new FLOGI
Date:   Tue, 12 Apr 2022 15:19:49 -0700
Message-Id: <20220412222008.126521-8-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220412222008.126521-1-jsmart2021@gmail.com>
References: <20220412222008.126521-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Previous topologies may no longer be in fabric mode, so clear FC_FABRIC in
fc_flag for every new FLOGI.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 65e884a416a5..863251322715 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1530,6 +1530,8 @@ lpfc_initial_flogi(struct lpfc_vport *vport)
 		lpfc_enqueue_node(vport, ndlp);
 	}
 
+	/* Reset the Fabric flag, topology change may have happened */
+	vport->fc_flag &= ~FC_FABRIC;
 	if (lpfc_issue_els_flogi(vport, ndlp, 0)) {
 		/* This decrement of reference count to node shall kick off
 		 * the release of the node.
-- 
2.26.2

