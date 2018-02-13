From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Move the eh_deadline module parameter definition to the
 top of hosts.c
Date: Tue, 13 Feb 2018 07:43:42 +0100
Message-ID: <e8fd9778-c3fd-033e-1322-88f26cdb236f@suse.de>
References: <20180212184129.25919-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35743 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933366AbeBMGnr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Feb 2018 01:43:47 -0500
In-Reply-To: <20180212184129.25919-1-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org

On 02/12/2018 07:41 PM, Bart Van Assche wrote:
> The eh_deadline definition occurs in the middle of the code for
> releasing a host. Avoid splitting the host release code by moving
> the definition of the eh_deadline parameter to the top of the
> hosts.c source file.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/hosts.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 57bf43e34863..a0a7e4ff255c 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -42,6 +42,12 @@
>  #include "scsi_logging.h"
>  
>  
> +static int shost_eh_deadline = -1;
> +
> +module_param_named(eh_deadline, shost_eh_deadline, int, S_IRUGO|S_IWUSR);
> +MODULE_PARM_DESC(eh_deadline,
> +		 "SCSI EH timeout in seconds (should be between 0 and 2^31-1)");
> +
>  static DEFINE_IDA(host_index_ida);
>  
>  
> @@ -358,12 +364,6 @@ static void scsi_host_dev_release(struct device *dev)
>  	kfree(shost);
>  }
>  
> -static int shost_eh_deadline = -1;
> -
> -module_param_named(eh_deadline, shost_eh_deadline, int, S_IRUGO|S_IWUSR);
> -MODULE_PARM_DESC(eh_deadline,
> -		 "SCSI EH timeout in seconds (should be between 0 and 2^31-1)");
> -
>  static struct device_type scsi_host_type = {
>  	.name =		"scsi_host",
>  	.release =	scsi_host_dev_release,
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
