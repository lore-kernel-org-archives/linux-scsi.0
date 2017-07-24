From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH 14/47] scsi: Use Scsi_Host as argument for
 eh_host_reset_handler
Date: Mon, 24 Jul 2017 18:55:05 +0200
Message-ID: <7a7c361d-8d3a-6c76-1831-c86abd6177aa@linux.vnet.ibm.com>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
 <1498638793-44672-15-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37833 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753582AbdGXQzO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Jul 2017 12:55:14 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6OGrlNu055818
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2017 12:55:13 -0400
Received: from e06smtp14.uk.ibm.com (e06smtp14.uk.ibm.com [195.75.94.110])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bwh96agsv-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2017 12:55:12 -0400
Received: from localhost
        by e06smtp14.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
        Mon, 24 Jul 2017 17:55:10 +0100
In-Reply-To: <1498638793-44672-15-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org


On 06/28/2017 10:32 AM, Hannes Reinecke wrote:
> Issuing a host reset should not rely on any commands.
> So use Scsi_Host as argument for eh_host_reset_handler.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   Documentation/scsi/scsi_eh.txt                  |  2 +-
>   Documentation/scsi/scsi_mid_low_api.txt         |  4 +--

>   drivers/s390/scsi/zfcp_scsi.c                   |  3 +-

>   drivers/scsi/scsi_debug.c                       | 16 +++++-----
>   drivers/scsi/scsi_error.c                       |  2 +-

>   include/scsi/scsi_host.h                        |  2 +-
>   81 files changed, 290 insertions(+), 380 deletions(-)
> 
> diff --git a/Documentation/scsi/scsi_eh.txt b/Documentation/scsi/scsi_eh.txt
> index 11e447b..78cd6b9 100644
> --- a/Documentation/scsi/scsi_eh.txt
> +++ b/Documentation/scsi/scsi_eh.txt
> @@ -208,7 +208,7 @@ considered to fail always.
>   int (* eh_abort_handler)(struct scsi_cmnd *);
>   int (* eh_device_reset_handler)(struct scsi_cmnd *);
>   int (* eh_bus_reset_handler)(struct scsi_cmnd *);
> -int (* eh_host_reset_handler)(struct scsi_cmnd *);
> +int (* eh_host_reset_handler)(struct Scsi_Host *);
> 
>    Higher-severity actions are taken only when lower-severity actions
>   cannot recover some of failed scmds.  Also, note that failure of the
> diff --git a/Documentation/scsi/scsi_mid_low_api.txt b/Documentation/scsi/scsi_mid_low_api.txt
> index 6338400..ad517d5 100644
> --- a/Documentation/scsi/scsi_mid_low_api.txt
> +++ b/Documentation/scsi/scsi_mid_low_api.txt
> @@ -891,7 +891,7 @@ Details:
> 
>   /**
>    *      eh_host_reset_handler - reset host (host bus adapter)
> - *      @scp: SCSI host that contains this device should be reset
> + *      @shost: SCSI host that should be reset
>    *
>    *      Returns SUCCESS if command aborted else FAILED
>    *
> @@ -908,7 +908,7 @@ Details:
>    *
>    *      Optionally defined in: LLD
>    **/
> -     int eh_host_reset_handler(struct scsi_cmnd * scp)
> +     int eh_host_reset_handler(struct Scsi_Host * shost)
> 
> 
>   /**



> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
> index 3d18659..d7d4a63 100644
> --- a/drivers/s390/scsi/zfcp_scsi.c
> +++ b/drivers/s390/scsi/zfcp_scsi.c
> @@ -309,9 +309,8 @@ static int zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
>   	return zfcp_task_mgmt_function(scpnt, FCP_TMF_TGT_RESET);
>   }
> 
> -static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
> +static int zfcp_scsi_eh_host_reset_handler(struct Scsi_Host *host)
>   {
> -	struct Scsi_Host *host = scpnt->device->host;
>   	struct zfcp_adapter *adapter = (struct zfcp_adapter *)host->hostdata[0];
>   	int ret = 0;
>   	unsigned long flags;



> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index dc095a2..ebf525b 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -3878,27 +3878,27 @@ static int scsi_debug_bus_reset(struct scsi_cmnd * SCpnt)
>   	return SUCCESS;
>   }
> 
> -static int scsi_debug_host_reset(struct scsi_cmnd * SCpnt)
> +static int scsi_debug_host_reset(struct Scsi_Host * shost)
>   {
>   	struct sdebug_host_info * sdbg_host;
>   	struct sdebug_dev_info *devip;
>   	int k = 0;
> 
>   	++num_host_resets;
> -	if ((SCpnt->device) && (SDEBUG_OPT_ALL_NOISE & sdebug_opts))
> -		sdev_printk(KERN_INFO, SCpnt->device, "%s\n", __func__);
> -        spin_lock(&sdebug_host_list_lock);
> -        list_for_each_entry(sdbg_host, &sdebug_host_list, host_list) {
> +	if (SDEBUG_OPT_ALL_NOISE & sdebug_opts)
> +		shost_printk(KERN_INFO, shost, "%s\n", __func__);
> +	spin_lock(&sdebug_host_list_lock);
> +	list_for_each_entry(sdbg_host, &sdebug_host_list, host_list) {
>   		list_for_each_entry(devip, &sdbg_host->dev_info_list,
>   				    dev_list) {
>   			set_bit(SDEBUG_UA_BUS_RESET, devip->uas_bm);
>   			++k;
>   		}
> -        }
> -        spin_unlock(&sdebug_host_list_lock);
> +	}
> +	spin_unlock(&sdebug_host_list_lock);
>   	stop_all_queued();
>   	if (SDEBUG_OPT_RESET_NOISE & sdebug_opts)
> -		sdev_printk(KERN_INFO, SCpnt->device,
> +		shost_printk(KERN_INFO, shost,
>   			    "%s: %d device(s) found\n", __func__, k);
>   	return SUCCESS;
>   }

Mechanically, the change looks good.

However, is it correct that it's been looping over all its shosts and 
doing something even for those that do not match SCpnt or now shost?
I thought it should only reset on the scope but it seems to call 
stop_all_queued(void) which might reset all shosts?
But then again the loop seems about unit attentions so the loop may be 
correct.
Anyway, this is not related to your change.

The other quoted parts incl. zfcp look good to me.

> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index ac31964..808167f 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -745,7 +745,7 @@ static int scsi_try_host_reset(struct scsi_cmnd *scmd)
>   	if (!hostt->eh_host_reset_handler)
>   		return FAILED;
> 
> -	rtn = hostt->eh_host_reset_handler(scmd);
> +	rtn = hostt->eh_host_reset_handler(host);
> 
>   	if (rtn == SUCCESS) {
>   		if (!hostt->skip_settle_delay)



> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index afb0481..b85f8a5 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -148,7 +148,7 @@ struct scsi_host_template {
>   	int (* eh_device_reset_handler)(struct scsi_cmnd *);
>   	int (* eh_target_reset_handler)(struct scsi_cmnd *);
>   	int (* eh_bus_reset_handler)(struct scsi_cmnd *);
> -	int (* eh_host_reset_handler)(struct scsi_cmnd *);
> +	int (* eh_host_reset_handler)(struct Scsi_Host *);
> 
>   	/*
>   	 * Before the mid layer attempts to scan for a new device where none
> 

-- 
Mit freundlichen Grüßen / Kind regards
Steffen Maier

Linux on z Systems Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
