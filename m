Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80CF7C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:01:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5883964FBB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbhCJUBT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 15:01:19 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:38341 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbhCJUAw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2021 15:00:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615406451; x=1646942451;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SPVMHQyvD/RxkBDzG/mhyRLVbX8Js/dUrFslxcfVMpY=;
  b=rvTp8XcfzbO3KYt7m2AckevKS9q7kC1QINRASU3nUnzXaVQA2KGIMzyy
   E1cUYW1pdF147canyKauhPcgam1yFpG3eSDjPuKYE/wsyGtrYAhwiXRqK
   L+oKNSRJ42MWZT/omIesAzlw9avkZ8cMW3qu9fjfAOB3uXe82T/cgK8rc
   yjKaR1Gb1VcNL3izImfj75ezPJjp1T/Q09ARkdx0A8qIIXBpEeZhLLuXZ
   lFsr3FEi4R5yLuXrJJtch0n4xYKfmWpGBlgHrkh+JlH6ZAlq/Gk3eBLUw
   MUo5dKH7TR1Z5OGckI/S8gt6OoC8KTM1G7UI9MxWa89h+/N24ufcT9zQR
   g==;
IronPort-SDR: l5VX5VLamF/Bknwp6hlvrV9ATIYTWuNjjpZF0Fe7wW3FZEC9IwYWZZHPiWUQag4JsETJpFRofp
 Jb9dcNosI/YTo9ssEQt3anc3wryTAXOoKB8JcklkXMplPGtqA0/L7LnIeLil+Fwbi/VtrdCkEr
 Ec6nhpvIbev24pe7qZewWTYC+C10MC6OKPE5dt/IE1O1CMYYie4+6HwSNNhVTbXjJUMNW9BlaA
 17/XdDGY8RAc6xOfpztiplRMgZL7Az+YVBSz1fFSrsbAmdTTZRB+0ytJ+rgH2EbfI+N+SlwRBQ
 dMI=
X-IronPort-AV: E=Sophos;i="5.81,238,1610434800"; 
   d="scan'208";a="106699374"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Mar 2021 13:00:51 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 10 Mar 2021 13:00:51 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 10 Mar 2021 13:00:50 -0700
Subject: [PATCH V4 01/31] smartpqi: use host wide tagspace
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Wed, 10 Mar 2021 14:00:50 -0600
Message-ID: <161540645071.19430.854884194228600277.stgit@brunhilda>
In-Reply-To: <161540568064.19430.11157730901022265360.stgit@brunhilda>
References: <161540568064.19430.11157730901022265360.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Correct scsi-mid-layer sending more requests than
exposed host Q depth causing firmware ASSERT and lockup
issue by enabling host wide tags and setting nr_hw_queues
to 1.

Note: this also results in better performance.

Suggested-by: Ming Lei <ming.lei@redhat.com>
Suggested-by: John Gary <john.gary@huawei.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index c53f456fbd09..c154e4578e55 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6598,7 +6598,8 @@ static int pqi_register_scsi(struct pqi_ctrl_info *ctrl_info)
 	shost->transportt = pqi_sas_transport_template;
 	shost->irq = pci_irq_vector(ctrl_info->pci_dev, 0);
 	shost->unique_id = shost->irq;
-	shost->nr_hw_queues = ctrl_info->num_queue_groups;
+	shost->nr_hw_queues = 1;
+	shost->host_tagset = 1;
 	shost->hostdata[0] = (unsigned long)ctrl_info;
 
 	rc = scsi_add_host(shost, &ctrl_info->pci_dev->dev);

