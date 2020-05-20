Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26504C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 04:07:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 019A520829
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 04:07:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbgETEHq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 May 2020 00:07:46 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:37535 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbgETEHq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 May 2020 00:07:46 -0400
Received: by mail-pj1-f67.google.com with SMTP id q9so660716pjm.2
        for <linux-scsi@vger.kernel.org>; Tue, 19 May 2020 21:07:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q8MXmrTQGOfL3pLGS4UlZZkKTUUAjXK/1FU5u8d7tgg=;
        b=FwLhEKQ0VcoS61HyksemXbQgRSwAdTuQRwspqfNUO1r/cCNKvwxyqzhr2ri96k3exW
         AzsN4egFwjiOZw0minx/izJZp/pZaw02VjnCmte8wu6plsCxn/ermnFJUu6zPbrNM9DH
         AANNhynyBQp/pend0e5gkO4v0KbgsMnVL6lqqKRb/bREJ5DGuBeZh7idggDxrCCPwvLA
         v8tILhJvvfAEBL1xxyVAB9ESjH4pLSX3fcx16vjpq0UI0+I1+2Rzwgvm5Hv0gHseXeF1
         n+di1JdEAP3CaieeoIYcgGWZ663f5qPYaUCIzx934Hhy5zCXmM4vibHzuvrkLr/GhJup
         /IoA==
X-Gm-Message-State: AOAM5310yQ/n1ZZ1vpErMs2lkxXjVAwVoyTZQLBOb+90ebgUT/ZgtHNw
        6dKfkBF9RJ4MO2DxYcGP9b8=
X-Google-Smtp-Source: ABdhPJyNTjN1ExyyF9GJTOrhVAwILbkNcerYNhhjyx6hR6nSxh3E6xGEX4ePR0Jg0aKrueySWYpGwA==
X-Received: by 2002:a17:90b:515:: with SMTP id r21mr3090297pjz.217.1589947665083;
        Tue, 19 May 2020 21:07:45 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d7:c003:ed4b:3e7f:b20f])
        by smtp.gmail.com with ESMTPSA id e15sm817324pfh.23.2020.05.19.21.07.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 21:07:44 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH] qla2xxx: Remove an unused function
Date:   Tue, 19 May 2020 21:07:38 -0700
Message-Id: <20200520040738.1017-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This was detected by building the qla2xxx driver with clang. See also
commit a9083016a531 ("[SCSI] qla2xxx: Add ISP82XX support").

Cc: Arun Easi <aeasi@marvell.com>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_nx.c | 41 -----------------------------------
 1 file changed, 41 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 21f968e4a584..0baf55b7e88f 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -380,47 +380,6 @@ qla82xx_pci_set_crbwindow_2M(struct qla_hw_data *ha, ulong off_in,
 	*off_out = (off_in & MASK(16)) + CRB_INDIRECT_2M + ha->nx_pcibase;
 }
 
-static inline unsigned long
-qla82xx_pci_set_crbwindow(struct qla_hw_data *ha, u64 off)
-{
-	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
-	/* See if we are currently pointing to the region we want to use next */
-	if ((off >= QLA82XX_CRB_PCIX_HOST) && (off < QLA82XX_CRB_DDR_NET)) {
-		/* No need to change window. PCIX and PCIEregs are in both
-		 * regs are in both windows.
-		 */
-		return off;
-	}
-
-	if ((off >= QLA82XX_CRB_PCIX_HOST) && (off < QLA82XX_CRB_PCIX_HOST2)) {
-		/* We are in first CRB window */
-		if (ha->curr_window != 0)
-			WARN_ON(1);
-		return off;
-	}
-
-	if ((off > QLA82XX_CRB_PCIX_HOST2) && (off < QLA82XX_CRB_MAX)) {
-		/* We are in second CRB window */
-		off = off - QLA82XX_CRB_PCIX_HOST2 + QLA82XX_CRB_PCIX_HOST;
-
-		if (ha->curr_window != 1)
-			return off;
-
-		/* We are in the QM or direct access
-		 * register region - do nothing
-		 */
-		if ((off >= QLA82XX_PCI_DIRECT_CRB) &&
-			(off < QLA82XX_PCI_CAMQM_MAX))
-			return off;
-	}
-	/* strange address given */
-	ql_dbg(ql_dbg_p3p, vha, 0xb001,
-	    "%s: Warning: unm_nic_pci_set_crbwindow "
-	    "called with an unknown address(%llx).\n",
-	    QLA2XXX_DRIVER_NAME, off);
-	return off;
-}
-
 static int
 qla82xx_pci_get_crb_addr_2M(struct qla_hw_data *ha, ulong off_in,
 			    void __iomem **off_out)
