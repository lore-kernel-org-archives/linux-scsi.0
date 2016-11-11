From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: [PATCH 5/5] megaraid_sas: add mmio barrier after register writes
Date: Fri, 11 Nov 2016 16:17:21 +0530
Message-ID: <8895199bc2e5184d07c997a814cde56c@mail.gmail.com>
References: <1478857492-4581-1-git-send-email-hare@suse.de> <1478857492-4581-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:38333 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750714AbcKKKrY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Nov 2016 05:47:24 -0500
Received: by mail-it0-f53.google.com with SMTP id q124so112273461itd.1
        for <linux-scsi@vger.kernel.org>; Fri, 11 Nov 2016 02:47:23 -0800 (PST)
In-Reply-To: <1478857492-4581-6-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

>-----Original Message-----
>From: Hannes Reinecke [mailto:hare@suse.de]
>Sent: Friday, November 11, 2016 3:15 PM
>To: Martin K. Petersen
>Cc: Christoph Hellwig; James Bottomley; Sumit Saxena; linux-
>scsi@vger.kernel.org; Hannes Reinecke; Hannes Reinecke
>Subject: [PATCH 5/5] megaraid_sas: add mmio barrier after register writes
>
>The megaraid_sas HBA only has a single register for I/O submission, which
will be
>hit pretty hard with scsi-mq. To ensure that the PCI writes have made it
across we
>need to add a mmio barrier after each write; otherwise I've been seeing
spurious
>command completions and I/O stalls.
>
>Signed-off-by: Hannes Reinecke <hare@suse.com>
Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>

>---
> drivers/scsi/megaraid/megaraid_sas_fusion.c | 1 +
> 1 file changed, 1 insertion(+)
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>index aba53c0..729a654 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>@@ -196,6 +196,7 @@ inline void megasas_return_cmd_fusion(struct
>megasas_instance *instance,
> 			le32_to_cpu(req_desc->u.low));
>
> 	writeq(req_data, &instance->reg_set->inbound_low_queue_port);
>+	mmiowb();
> #else
> 	unsigned long flags;
>
>--
>1.8.5.6
