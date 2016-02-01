From: Kashyap Desai <kashyap.desai@avagotech.com>
Subject: RE: megaraid_sas: add an i/o barrier
Date: Mon, 1 Feb 2016 10:15:17 +0530
Message-ID: <5955d77ec60a460d09e5480cf7928177@mail.gmail.com>
References: <56ABA2C5.6060603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:33877 "EHLO
	mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbcBAEpU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Jan 2016 23:45:20 -0500
Received: by mail-lf0-f53.google.com with SMTP id j78so18546575lfb.1
        for <linux-scsi@vger.kernel.org>; Sun, 31 Jan 2016 20:45:19 -0800 (PST)
In-Reply-To: <56ABA2C5.6060603@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org
Cc: Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>

> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com]
> Sent: Friday, January 29, 2016 11:05 PM
> To: 'linux-scsi@vger.kernel.org'
> Cc: Sumit.Saxena@avagotech.com; Desai, Kashyap; Uday Lingala
> Subject: megaraid_sas: add an i/o barrier
>
> A barrier should be added to ensure proper ordering of memory mapped
> writes.
>
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index d9d0029fb1..98a848bdfd 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -204,6 +204,7 @@ megasas_fire_cmd_fusion(struct
> megasas_instance *instance,
>  		&instance->reg_set->inbound_low_queue_port);
>  	writel(le32_to_cpu(req_desc->u.high),
>  		&instance->reg_set->inbound_high_queue_port);
> +	mmiowb();
>  	spin_unlock_irqrestore(&instance->hba_lock, flags);  #endif  }

Tomas-

We may need similar changes around below Functions as well, because there is
no associated readX or mmiowb() call.
megasas_fire_cmd_xscale()
megasas_fire_cmd_ppc()
megasas_fire_cmd_skinny()
megasas_fire_cmd_gen2()

Also,  wrireq() routine in same function megasas_fire_cmd_fusion() need i/o
barrier.

> --
> 2.4.3
