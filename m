From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] Ensure that the SCSI error handler gets woken up
Date: Thu, 23 Nov 2017 09:18:02 +0100
Message-ID: <20171123081802.GA20705@lst.de>
References: <20171123010505.9603-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171123010505.9603-1-bart.vanassche@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>, Stuart Hayes <stuart.w.hayes@gmail.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 5e89049e9b4e..f7f014c755d7 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -61,9 +61,10 @@ static int scsi_eh_try_stu(struct scsi_cmnd *scmd);
>  static int scsi_try_to_abort_cmd(struct scsi_host_template *,
>  				 struct scsi_cmnd *);
>  
> -/* called with shost->host_lock held */
>  void scsi_eh_wakeup(struct Scsi_Host *shost)
>  {
> +	lockdep_assert_held(shost->host_lock);
> +
>  	if (atomic_read(&shost->host_busy) == shost->host_failed) {
>  		trace_scsi_eh_wakeup(shost);
>  		wake_up_process(shost->ehandler);

Can you split this comment to assert change into a separate patch, please?

Except for that this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
