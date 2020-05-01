Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4EC5C35280
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 21:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A528D208DB
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 21:43:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s/cOZvj0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgEAVn1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 17:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgEAVnZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2020 17:43:25 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79AB3C061A0E
        for <linux-scsi@vger.kernel.org>; Fri,  1 May 2020 14:43:23 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id d15so13200063wrx.3
        for <linux-scsi@vger.kernel.org>; Fri, 01 May 2020 14:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BpCqSnke1+1QEG3E8VLjxlAmomwwH06zG/XWaoTpefM=;
        b=s/cOZvj07tW4AzYsAWq6pg96iK3R42I581GwbGlixckxJ5etlb2YHKvBKPPamxMjrF
         ZcQ8/T1l50d0ASHDmt8lnJgDCRBoDuECNCQX3wb23iAQ/SQD17KjWPv6LK12p7h6/vh2
         SOPZ3mKsFmVnBx1Wtq8cA1bjg67gvdOSwbmM/y1Nl8Tjk/0e6F7705OTeuS/lQr8j2ye
         5/iY/K3Wy96s6cYjZysxfkVufwH12N5OIF3ikpL3NVmyj3eVyp6UG+WUhZ5+mevzeoR8
         UYyN55Q4EdcEee8sV49H5IqK5CDTxXebTpPaiE1EXwUaun+4Q8UtBhYbz7hIPBBhVt2a
         I3nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BpCqSnke1+1QEG3E8VLjxlAmomwwH06zG/XWaoTpefM=;
        b=DvE7WkVGGVoX8amlU9BnGvsBNpc2GEIOXB567BKJrtc4EX2ReN2ZORvepiCjiBb98U
         MWWjwTTSCZ8wDKN45zrxrpe5JB8STDvC9rgOxkfhqlx32EZcko2x/txKzMrXeId2RbtX
         W4SnLhGXnEnvMrE8pPOwnS/kTr81jeWlCTAn3dsbBvXwtbzBUUBE7xnH+5qGEzry4M1R
         E/sVbtHSFUwVhVnpY75rvCXd5Yi8t/cz6CM7yHOrRnWVZUqPrUqKTAQ6xt23bqhj6lf2
         Q+Pk1PnKC8OQgLCCo7KwcP1Kwl9xeQq5tEiiQaef30w9lPMM6UsDOO5cBYQoPwiTuHyq
         8L+Q==
X-Gm-Message-State: AGi0PuaTWpy2zFTDC9VesO6XMNWkI2hO2l+CQO6dKhBFx6ojFSlK8yQ3
        +3WG+3DiBKVzs0YRDJOJWtJF4agb
X-Google-Smtp-Source: APiQypLhF9bdm/Z6G4Y3j4S2RXR7BN8kPmaYm6F2cw/oG1NsQOIJ+p3sPrkJ+dScHeG5GbpgRrYmeg==
X-Received: by 2002:adf:f990:: with SMTP id f16mr5606293wrr.33.1588369401993;
        Fri, 01 May 2020 14:43:21 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t2sm1207734wmt.15.2020.05.01.14.43.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 May 2020 14:43:21 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 1/9] lpfc: Synchronize NVME transport and lpfc driver devloss_tmo
Date:   Fri,  1 May 2020 14:43:02 -0700
Message-Id: <20200501214310.91713-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200501214310.91713-1-jsmart2021@gmail.com>
References: <20200501214310.91713-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver is not passing it's devloss tmo to the nvme-fc transport when
registering the remote port. Thus devloss tmo for the nvme-fc remote port
will be set to the transport's default. This causes driver actions to be
out of sync with transport actions and out of sync with scsi actions for
perhaps the same remote port.

This is especially notable in the following scenario: while remote port
is attached, devloss is changed globally for lpfc remote ports via lpfc
sysfs parameter. lpfc ties this change in with nvme-fc transport. If the
device disconnects long enough for devloss to expire thus the existing
remote port is deleted, then the remote port is re-discovered, the newly
created remote port will end up set at the transport default, not lpfc's
value.

Fix by setting devloss tmo value when registering the remote port.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 12d2b2775773..43df08aeecf1 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2296,6 +2296,7 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 
 	rpinfo.port_name = wwn_to_u64(ndlp->nlp_portname.u.wwn);
 	rpinfo.node_name = wwn_to_u64(ndlp->nlp_nodename.u.wwn);
+	rpinfo.dev_loss_tmo = vport->cfg_devloss_tmo;
 
 	spin_lock_irq(&vport->phba->hbalock);
 	oldrport = lpfc_ndlp_get_nrport(ndlp);
-- 
2.26.1

