From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH] mpt2sas : missing initialization of scsih_cmds is
 included
Date: Tue, 8 Dec 2009 00:19:35 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C1C93CDE413@inbmail01.lsi.com>
References: <20091117074622.GA20953@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:59052 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758119AbZLGStl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Dec 2009 13:49:41 -0500
In-Reply-To: <20091117074622.GA20953@lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

James,

This patch is fix in mpt2sas 03.100.03.00 included in 2.6.33.
Can you please include this patch in 2.6.33?

- Kashyap

> -----Original Message-----
> From: Kashyap, Desai [mailto:kashyap.desai@lsi.com]
> Sent: Tuesday, November 17, 2009 1:17 PM
> To: linux-scsi@vger.kernel.org
> Cc: James.Bottomley@HansenPartnership.com; Moore, Eric; Prakash, Sathya
> Subject: [PATCH] mpt2sas : missing initialization of scsih_cmds is
> included
> 
> 
> Internal command scsih_cmds init is included in mpt2sas_base_attach.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
> ---
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c
> b/drivers/scsi/mpt2sas/mpt2sas_base.c
> index 6422e25..89d0240 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> @@ -3583,6 +3583,11 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
>  	ioc->transport_cmds.status = MPT2_CMD_NOT_USED;
>  	mutex_init(&ioc->transport_cmds.mutex);
> 
> +	/* scsih internal command bits */
> +	ioc->scsih_cmds.reply = kzalloc(ioc->reply_sz, GFP_KERNEL);
> +	ioc->scsih_cmds.status = MPT2_CMD_NOT_USED;
> +	mutex_init(&ioc->scsih_cmds.mutex);
> +
>  	/* task management internal command bits */
>  	ioc->tm_cmds.reply = kzalloc(ioc->reply_sz, GFP_KERNEL);
>  	ioc->tm_cmds.status = MPT2_CMD_NOT_USED;
