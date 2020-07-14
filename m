Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 490E6C433E5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 21:14:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22D092067D
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 21:14:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BZ+Y8AQ2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgGNVOV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 17:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbgGNVOV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2020 17:14:21 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D61DC061755
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2020 14:14:21 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z13so227638wrw.5
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2020 14:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iwiT9c4LDOVCcAvxNOxfc0Jd80MIawIXX0zc+oc7oWQ=;
        b=BZ+Y8AQ2QjAHb1K8Sn4cRMwWNhkV4n+/kotccRvx1Is7rU1TLTV21OWTIpKxwPXqqW
         uKeOdDb0G8iG3PJXUrQzgU1YVA1vMQNYkbU0e3Wwo3oGvCWgzq3oFOM9hJIcB0Op9990
         QSUvp8zpp4UvegOKTOnBmvI5Wbm2E9bn8bcftL/ZRs2aDkLfCJnZg6flaUL+hY8L9BOn
         FphUrTSMSchwSjZA1WSz2APShDq67kKyBYdMwNSTeMgTediFAEhHTCU6NkWpaOTeGTgD
         eGgNvOGl5ptP0TshYKL4sFirmEStyFPzb1NcgBz+acNsgVApDagJk0I2jzA63pldWmTU
         BF5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iwiT9c4LDOVCcAvxNOxfc0Jd80MIawIXX0zc+oc7oWQ=;
        b=uDnO3mdhBFRfawNf6Yq7ngiZSMYaEUPJatzNadCxw8WqUiXOz0cnoyBZngmr3SzhZA
         HJj5P5VB7Bp1WK1UpApX+GqLa+BsXiAqFAE5ijfINnAqeMXtI54TdIJcz88XNBt04dFX
         xyKad/yPt7MbX/3NqiGY+fFKf9h/eXmPtdzNJCjq42urAnOHeYS0In+V8DeTRU9l5ueG
         6EG79Hiu4IK79Ac/3PVthNPomkXmIvz/HVMxG2zWEPpnmZaannJA4mJ7SA5cnKO4ZTfa
         yVT5Li2MK9cmdMGDbXOSEsvslCHLKYqEq0Q3ZfTTJxgCcMvcndBKqnrSKSBs5TokWxOP
         kRwQ==
X-Gm-Message-State: AOAM53283cX1zLnGtS+aWIdcE27Ay0qMpfbkgtiWckqiO7ftovEiDYnQ
        DUE6yOidhXwiB6PBsPfISewtyj9D
X-Google-Smtp-Source: ABdhPJwPncDeHeFSOLqk4ykP8NQT/G8YV3xtZ4W9eTMSsERp1SBR+zKsw5dWtgyJw1EG8PvCJEGjpg==
X-Received: by 2002:a5d:40c9:: with SMTP id b9mr7640486wrq.425.1594761259531;
        Tue, 14 Jul 2020 14:14:19 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v5sm76692wmh.12.2020.07.14.14.14.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 14:14:18 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Martin George <Martin.George@netapp.com>
Subject: [PATCH] lpfc: nvme remote port devloss_tmo from lldd
Date:   Tue, 14 Jul 2020 14:14:12 -0700
Message-Id: <20200714211412.11773-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Nvme-fc allows the driver to specify a default devloss_tmo value when
registering the remote port. The lpfc driver is currently not doing so
although it is implementing a driver internal node loss value of 30s
which also is used on the scsi fc remote port. As no devloss_tmo is set,
the nvme-fc transport defaults to 60s. So there's competing timers.

Additionally, due to the competing timers, its possible the nvme rport
is removed but the scsi rport remains. Its possible that the scsi fc
rport, which was registered for the nvme port even if it doesn't utilize
the scsi protocol, had been tuned to not match either the 60s (nvme-fc
default) or 30s (lldd default), it gets out of whack. The lldd will
defer to the scsi fc rport as long as the scsi fc rport has not had its
devloss_tmo expire.

Correct the situation by specifying a default devloss_tmo to the nvme-fc
transport when registering the rport.  Take the value from the scsi
fc rport if it exists, otherwise use the driver default.

Signed-off-by: James Smart <jsmart2021@gmail.com>
Tested-by: Martin George <Martin.George@netapp.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index fdfca02704dc..793388fff332 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2423,6 +2423,7 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	struct nvme_fc_remote_port *remote_port;
 	struct nvme_fc_port_info rpinfo;
 	struct lpfc_nodelist *prev_ndlp = NULL;
+	struct fc_rport *srport = ndlp->rport;
 
 	lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_NVME_DISC,
 			 "6006 Register NVME PORT. DID x%06x nlptype x%x\n",
@@ -2452,6 +2453,10 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 
 	rpinfo.port_name = wwn_to_u64(ndlp->nlp_portname.u.wwn);
 	rpinfo.node_name = wwn_to_u64(ndlp->nlp_nodename.u.wwn);
+	if (srport)
+		rpinfo.dev_loss_tmo = srport->dev_loss_tmo;
+	else
+		rpinfo.dev_loss_tmo = vport->cfg_devloss_tmo;
 
 	spin_lock_irq(&vport->phba->hbalock);
 	oldrport = lpfc_ndlp_get_nrport(ndlp);
-- 
2.26.2

