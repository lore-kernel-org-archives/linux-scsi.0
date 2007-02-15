From: "Patro, Sumant" <Sumant.Patro@lsi.com>
Subject: RE: [PATCH 3/6] scsi: megaraid_sas - throttle io if FW is busy
Date: Thu, 15 Feb 2007 16:44:00 -0700
Message-ID: <0631C836DBF79F42B5A60C8C8D4E822992131B@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:51838 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932842AbXBOXoS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Feb 2007 18:44:18 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: James.Bottomley@SteelEye.com, akpm@osdl.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Kolli, Neela" <Neela.Kolli@lsi.com>, "Yang, Bo" <Bo.Yang@lsi.com>

Yes I can make it boolean. 
Will change it in a future patch submission.

Thanks,
Sumant

-----Original Message-----
From: Richard Knutsson [mailto:ricknu-0@student.ltu.se] 
Sent: Thursday, February 15, 2007 12:10 AM
To: Patro, Sumant
Cc: James.Bottomley@SteelEye.com; akpm@osdl.org;
linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Kolli, Neela;
Yang, Bo; Patro, Sumant
Subject: Re: [PATCH 3/6] scsi: megaraid_sas - throttle io if FW is busy

Sumant Patro wrote:
> Checks added in megasas_queue_command to know if FW is able to process

> commands within the timeout period. If number of retries is 2 or more,

> the driver stops sending cmd to FW. IO is resumed when pending cmd 
> count reduces to 16 or 10 seconds has elapsed from the time cmds were 
> last sent to FW.
>
> Signed-off-by: Sumant Patro <sumant.patro@lsi.com>
> ---
>
>  drivers/scsi/megaraid/megaraid_sas.c |   27 +++++++++++++++++++++++++
>  drivers/scsi/megaraid/megaraid_sas.h |    3 ++
>  2 files changed, 30 insertions(+)
>
>   
[snip]
> diff -uprN linux-feb13-new-p2/drivers/scsi/megaraid/megaraid_sas.h
linux-feb13-new-p3/drivers/scsi/megaraid/megaraid_sas.h
> --- linux-feb13-new-p2/drivers/scsi/megaraid/megaraid_sas.h
2007-02-13 07:22:40.000000000 -0800
> +++ linux-feb13-new-p3/drivers/scsi/megaraid/megaraid_sas.h
2007-02-13 11:37:09.000000000 -0800
> @@ -1102,6 +1102,9 @@ struct megasas_instance {
>  	atomic_t fw_outstanding;
>  	u32 hw_crit_error;
>  
> +	u8 is_busy;
>   
Why not "bool is_busy:8;"? It obviously is a boolean. I would also think
false/true would be more descriptive then 0/1.

Richard Knutsson

