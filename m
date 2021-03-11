Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C153EC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:15:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6900B64F88
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:15:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhCKUPR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 15:15:17 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:63181 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbhCKUPF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 15:15:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615493706; x=1647029706;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3I8hSmkZc0dJj3ouykY4nZ/d9LU7kmRKzLpSV7CIWKw=;
  b=kdd1wQ/o0RLnNT96ZugV5mQJSl7h3QUwVHpX+osDzwWjHDyfXuFygpXb
   Qh+765uC5REjmsKsXsf6J2JoztzepQqHozgMYZoYZzdj/ZCvW4cVTNJhT
   7G3cNDb75AASrz0pJ2I2iwee5KwFS8jD1Dp8XiyFiIJafeOJn0EC1Cdyp
   RQQJ93XrUkqRz1QZaWB5HH+xhswRkVXrsZ+4FXD9oFJ8FemIq6Cs0QjVk
   A++AnjnF4CewsUN62PSo9kzYiOTYF4zFvHStcGd+vXy/GhPCiTSfZ5OmF
   eKAkuO2eHAK3jvZu5qJtzmJVyO0pqdcUd2rV4nhenPptSW5PkseaXdMAv
   A==;
IronPort-SDR: MFNwNU65ihDRG30dpcdRyf88EERz0V2EBKsn2E7ozSK3sf0tVx6gNIXudlXc6C2Tx9h184Oi6n
 ZwTtptZ50X8vLXdVZDGbtsph8EkkQLdnqdhYNiz3CKg5eYidLYS0z1QeFSU9rXUf2ysGQzVizR
 LcD8hwBTe9B6rJ562Fv/+RG6rR6CjaHMlE04rDBS4LqaVbIjzQ23d4R+ksa1znov5NFFPQg9/Y
 zYDfeYIRNIknwKDnZvA1PglFJw1cN/KMN47FLlxLb0I16o4XtV/urJTzJwfT9g6Th5VmZFl2kZ
 oVo=
X-IronPort-AV: E=Sophos;i="5.81,241,1610434800"; 
   d="scan'208";a="112405931"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Mar 2021 13:15:06 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 11 Mar 2021 13:14:58 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 11 Mar 2021 13:14:58 -0700
Subject: [PATCH V5 01/31] smartpqi: use host wide tagspace
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 11 Mar 2021 14:14:57 -0600
Message-ID: <161549369787.25025.8975999483518581619.stgit@brunhilda>
In-Reply-To: <161549045434.25025.17473629602756431540.stgit@brunhilda>
References: <161549045434.25025.17473629602756431540.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Correct scsi-mid-layer sending more requests than
exposed host Q depth causing firmware ASSERT and lockup
issue by enabling host wide tags.

Note: this also results in better performance.

Suggested-by: Ming Lei <ming.lei@redhat.com>
Suggested-by: John Garry <john.garry@huawei.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index c53f456fbd09..61e3a5afaf07 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6599,6 +6599,7 @@ static int pqi_register_scsi(struct pqi_ctrl_info *ctrl_info)
 	shost->irq = pci_irq_vector(ctrl_info->pci_dev, 0);
 	shost->unique_id = shost->irq;
 	shost->nr_hw_queues = ctrl_info->num_queue_groups;
+	shost->host_tagset = 1;
 	shost->hostdata[0] = (unsigned long)ctrl_info;
 
 	rc = scsi_add_host(shost, &ctrl_info->pci_dev->dev);

