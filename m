From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 3/5] scsi: megaraid_sas - throttle io if FW is busy
Date: Thu, 15 Feb 2007 18:10:50 -0600
Message-ID: <1171584651.3412.63.camel@mulgrave.il.steeleye.com>
References: <1170799864.10482.32.camel@dumbo>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1422802AbXBPALf@vger.kernel.org>
In-Reply-To: <1170799864.10482.32.camel@dumbo>
Sender: linux-kernel-owner@vger.kernel.org
To: Sumant Patro <sumantp@lsil.com>
Cc: akpm@osdl.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, neela.kolli@lsi.com, bo.yang@lsi.com, sumant.patro@lsi.com
List-Id: linux-scsi@vger.kernel.org

On Tue, 2007-02-06 at 14:11 -0800, Sumant Patro wrote:
> Checks added in megasas_queue_command to know if FW is able to process
> commands within timeout period. If number of retries is 2 or greater,
> the driver stops sending cmd to FW. IO is resumed if pending cmd count
> reduces to 16 or 5 seconds has elapsed from the time cmds were last sent
> to FW.
> 
> Signed-off-by: Sumant Patro <sumant.patro@lsi.com>
> ---
> 
>  drivers/scsi/megaraid/megaraid_sas.c |   27 +++++++++++++++++++++++++
>  drivers/scsi/megaraid/megaraid_sas.h |    3 ++
>  2 files changed, 30 insertions(+)
> 
> diff -uprN 2.6.new-p2/drivers/scsi/megaraid/megaraid_sas.c 2.6.new-p3/drivers/scsi/megaraid/megaraid_sas.c
> --- 2.6.new-p2/drivers/scsi/megaraid/megaraid_sas.c	2007-02-06 08:43:40.000000000 -0800
> +++ 2.6.new-p3/drivers/scsi/megaraid/megaraid_sas.c	2007-02-06 08:50:40.000000000 -0800
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
