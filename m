From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: Re: [PATCH 3/6] scsi: megaraid_sas - throttle io if FW is busy
Date: Thu, 15 Feb 2007 09:09:42 +0100
Message-ID: <45D41546.3070907@student.ltu.se>
References: <1171486194.4188.21.camel@dumbo>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gepetto.dc.ltu.se ([130.240.42.40]:62265 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965043AbXBOIJy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Feb 2007 03:09:54 -0500
In-Reply-To: <1171486194.4188.21.camel@dumbo>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumant Patro <sumantp@lsil.com>
Cc: James.Bottomley@SteelEye.com, akpm@osdl.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, neela.kolli@lsi.com, bo.yang@lsi.com, sumant.patro@lsi.com

Sumant Patro wrote:
> Checks added in megasas_queue_command to know if FW is able to process
> commands within the timeout period. If number of retries is 2 or more,
> the driver stops sending cmd to FW. IO is resumed when pending cmd count 
> reduces to 16 or 10 seconds has elapsed from the time cmds were last 
> sent to FW.
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
> diff -uprN linux-feb13-new-p2/drivers/scsi/megaraid/megaraid_sas.h linux-feb13-new-p3/drivers/scsi/megaraid/megaraid_sas.h
> --- linux-feb13-new-p2/drivers/scsi/megaraid/megaraid_sas.h	2007-02-13 07:22:40.000000000 -0800
> +++ linux-feb13-new-p3/drivers/scsi/megaraid/megaraid_sas.h	2007-02-13 11:37:09.000000000 -0800
> @@ -1102,6 +1102,9 @@ struct megasas_instance {
>  	atomic_t fw_outstanding;
>  	u32 hw_crit_error;
>  
> +	u8 is_busy;
>   
Why not "bool is_busy:8;"? It obviously is a boolean. I would also think 
false/true would be more descriptive then 0/1.

Richard Knutsson

