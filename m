Return-Path: <SRS0=4YdN=D5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FF94C2D0A3
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 03:00:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03AA82227F
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 03:00:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895245AbgJVDAJ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Oct 2020 23:00:09 -0400
Received: from smtp.h3c.com ([60.191.123.56]:52045 "EHLO h3cspam01-ex.h3c.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2895243AbgJVDAJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Oct 2020 23:00:09 -0400
Received: from DAG2EX05-BASE.srv.huawei-3com.com ([10.8.0.68])
        by h3cspam01-ex.h3c.com with ESMTPS id 09M2xguF086266
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 22 Oct 2020 10:59:42 +0800 (GMT-8)
        (envelope-from tian.xianting@h3c.com)
Received: from DAG2EX03-BASE.srv.huawei-3com.com (10.8.0.66) by
 DAG2EX05-BASE.srv.huawei-3com.com (10.8.0.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 22 Oct 2020 10:59:43 +0800
Received: from DAG2EX03-BASE.srv.huawei-3com.com ([fe80::5d18:e01c:bbbd:c074])
 by DAG2EX03-BASE.srv.huawei-3com.com ([fe80::5d18:e01c:bbbd:c074%7]) with
 mapi id 15.01.2106.002; Thu, 22 Oct 2020 10:59:43 +0800
From:   Tianxianting <tian.xianting@h3c.com>
To:     Finn Thain <fthain@telegraphics.com.au>
CC:     "kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>,
        "sumit.saxena@broadcom.com" <sumit.saxena@broadcom.com>,
        "shivasharan.srikanteshwara@broadcom.com" 
        <shivasharan.srikanteshwara@broadcom.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "megaraidlinux.pdl@broadcom.com" <megaraidlinux.pdl@broadcom.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: megaraid_sas: use spin_lock() in hard IRQ
Thread-Topic: [PATCH] scsi: megaraid_sas: use spin_lock() in hard IRQ
Thread-Index: AQHWp3ceROYVx1Vy20ukToM9T7xND6miYAoAgACPazA=
Date:   Thu, 22 Oct 2020 02:59:43 +0000
Message-ID: <9923f28dd2b34499a17c53e8fa33f1ca@h3c.com>
References: <20201021064502.35469-1-tian.xianting@h3c.com>
 <alpine.LNX.2.23.453.2010221312460.6@nippy.intranet>
In-Reply-To: <alpine.LNX.2.23.453.2010221312460.6@nippy.intranet>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.99.141.128]
x-sender-location: DAG2
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-DNSRBL: 
X-MAIL: h3cspam01-ex.h3c.com 09M2xguF086266
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thanks,
Do you mean Megasas raid can be used in m68k arch?

-----Original Message-----
From: Finn Thain [mailto:fthain@telegraphics.com.au] 
Sent: Thursday, October 22, 2020 10:25 AM
To: tianxianting (RD) <tian.xianting@h3c.com>
Cc: kashyap.desai@broadcom.com; sumit.saxena@broadcom.com; shivasharan.srikanteshwara@broadcom.com; jejb@linux.ibm.com; martin.petersen@oracle.com; megaraidlinux.pdl@broadcom.com; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: megaraid_sas: use spin_lock() in hard IRQ

On Wed, 21 Oct 2020, Xianting Tian wrote:

> Since we already in hard IRQ context when running megasas_isr(),

On m68k, hard irq context does not mean interrupts are disabled. Are there no other architectures in that category?

> so use spin_lock() is enough, which is faster than spin_lock_irqsave().
> 

Is that measurable?

> Signed-off-by: Xianting Tian <tian.xianting@h3c.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c 
> b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 2b7e7b5f3..bd186254d 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -3977,15 +3977,14 @@ static irqreturn_t megasas_isr(int irq, void 
> *devp)  {
>  	struct megasas_irq_context *irq_context = devp;
>  	struct megasas_instance *instance = irq_context->instance;
> -	unsigned long flags;
>  	irqreturn_t rc;
>  
>  	if (atomic_read(&instance->fw_reset_no_pci_access))
>  		return IRQ_HANDLED;
>  
> -	spin_lock_irqsave(&instance->hba_lock, flags);
> +	spin_lock(&instance->hba_lock);
>  	rc = megasas_deplete_reply_queue(instance, DID_OK);
> -	spin_unlock_irqrestore(&instance->hba_lock, flags);
> +	spin_unlock(&instance->hba_lock);
>  
>  	return rc;
>  }
> 
