From: "Patro, Sumant" <Sumant.Patro@lsi.com>
Subject: RE: [PATCH 3/5] scsi: megaraid_sas - throttle io if FW is busy
Date: Thu, 15 Feb 2007 19:53:48 -0700
Message-ID: <0631C836DBF79F42B5A60C8C8D4E8229921362@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:56379 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932913AbXBPCyJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Feb 2007 21:54:09 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: akpm@osdl.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Kolli, Neela" <Neela.Kolli@lsi.com>, "Yang, Bo" <Bo.Yang@lsi.com>

Hello James,

	I re-submitted the patch yesterday with the "space" issue fixed
(adhering to coding guideline).

	I will check for alternative to calculate the time driver have
been sending host busy to OS. Will check with time_before() as you have
suggested.

	Throttling from megasas_generic_reset() handler did not help.
megaraid does not have feature to abort cmds. So, in the generic reset
routine, the driver just waits for cmd completion by FW. These timed-out
cmds gets retried by mid-layer with "retries" incremented by 1.
Eventually we see retries equals max_allowed followed by SCSI error with
"DRIVER_TIMEOUT".
	
	By throttling from the megasas_queue_command we do not hit the
issue. In our test with this code, retries did not exceed 2. 
	
Regards,

Sumant 

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
Sent: Thursday, February 15, 2007 4:11 PM
To: Patro, Sumant
Cc: akpm@osdl.org; linux-scsi@vger.kernel.org;
linux-kernel@vger.kernel.org; Kolli, Neela; Yang, Bo; Patro, Sumant
Subject: Re: [PATCH 3/5] scsi: megaraid_sas - throttle io if FW is busy

On Tue, 2007-02-06 at 14:11 -0800, Sumant Patro wrote:
> Checks added in megasas_queue_command to know if FW is able to process

> commands within timeout period. If number of retries is 2 or greater, 
> the driver stops sending cmd to FW. IO is resumed if pending cmd count

> reduces to 16 or 5 seconds has elapsed from the time cmds were last 
> sent to FW.
> 
> Signed-off-by: Sumant Patro <sumant.patro@lsi.com>
> ---
> 
>  drivers/scsi/megaraid/megaraid_sas.c |   27 +++++++++++++++++++++++++
>  drivers/scsi/megaraid/megaraid_sas.h |    3 ++
>  2 files changed, 30 insertions(+)
> 
> diff -uprN 2.6.new-p2/drivers/scsi/megaraid/megaraid_sas.c
2.6.new-p3/drivers/scsi/megaraid/megaraid_sas.c
> --- 2.6.new-p2/drivers/scsi/megaraid/megaraid_sas.c	2007-02-06
08:43:40.000000000 -0800
> +++ 2.6.new-p3/drivers/scsi/megaraid/megaraid_sas.c	2007-02-06
08:50:40.000000000 -0800
> @@ -839,6 +839,7 @@ megasas_queue_command(struct scsi_cmnd *
>  	u32 frame_count;
>  	struct megasas_cmd *cmd;
>  	struct megasas_instance *instance;
> +	unsigned long sec;
>  
>  	instance = (struct megasas_instance *)
>  	    scmd->device->host->hostdata;
> @@ -856,6 +857,23 @@ megasas_queue_command(struct scsi_cmnd *
>  		goto out_done;
>  	}
>  
> +	/* Check if we can process cmds */
> +	if(instance->is_busy){
            ^                  ^
       space needed per linux coding style (and the rest of the file

> +		sec = (jiffies - instance->last_time) / HZ;

please don't do this.  You want to be using time_before() and
jiffies_to_msecs().  The space problems apply to the rest of the code

> +		if(sec<5)
> +			return SCSI_MLQUEUE_HOST_BUSY;
> +		else{
> +			instance->is_busy=0;
> +			instance->last_time=0;
> +		}
> +	}
> +
> +	if(scmd->retries>1){

I really don't think this is a good indicator of your firmware
necessarily having problems; I really think you might want to look at
other indicators ... jiffies_at_alloc might be better, or even
throttling from the abort handler, which must have been called before
you get to here if the command is actually timing out.

Timeout and abort has it's own throttle anyway, since we quiesce the
host before beginning error recovery ... are you sure this scheme
actually solves anything for your device?

James


