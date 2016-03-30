From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [RESEND PATCH v2 2/2] scsi: Add intermediate STARGET_REMOVE
 state to scsi_target_state
Date: Wed, 30 Mar 2016 12:25:06 -0400
Message-ID: <1459355106.30035.23.camel@localhost.localdomain>
References: <cover.1459249252.git.jthumshirn@suse.de>
	 <108843b606da2c793bd830af42d5907bf8776d13.1459249252.git.jthumshirn@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <108843b606da2c793bd830af42d5907bf8776d13.1459249252.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2016-03-30 at 09:09 +0200, Johannes Thumshirn wrote:
> Add intermediate STARGET_REMOVE state to scsi_target_state to avoid running
> into the BUG_ON() in scsi_target_reap().
> 
> This intermediate state is only valid in the path from scsi_remove_target() to
> scsi_target_destroy() indicating this target is going to be removed.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Fixes: 40998193560dab6c3ce8d25f4fa58a23e252ef38
> Cc: stable@vger.kernel.org
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> Reviewed-by: Ewan D. Milne <emilne@redhat.com>
> ---
> 
> Changes from v1:
> * The state transition from STARGET_CREATED to STARGET_DEL is legitimate,
>   so don't BUG() on it. Found by the 0-Day Bot.
> 
> 
>  drivers/scsi/scsi_scan.c   | 2 ++
>  drivers/scsi/scsi_sysfs.c  | 4 +++-
>  include/scsi/scsi_device.h | 1 +
>  3 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 6a82066..63b8bca 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -315,6 +315,8 @@ static void scsi_target_destroy(struct scsi_target *starget)
>  	struct Scsi_Host *shost = dev_to_shost(dev->parent);
>  	unsigned long flags;
>  
> +	BUG_ON(starget->state != STARGET_REMOVE &&
> +	       starget->state != STARGET_CREATED);
>  	starget->state = STARGET_DEL;
>  	transport_destroy_device(dev);
>  	spin_lock_irqsave(shost->host_lock, flags);
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 4f18a85..9e5f893 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1278,10 +1278,12 @@ void scsi_remove_target(struct device *dev)
>  restart:
>  	spin_lock_irqsave(shost->host_lock, flags);
>  	list_for_each_entry(starget, &shost->__targets, siblings) {
> -		if (starget->state == STARGET_DEL)
> +		if (starget->state == STARGET_DEL ||
> +		    starget->state == STARGET_REMOVE)
>  			continue;
>  		if (starget->dev.parent == dev || &starget->dev == dev) {
>  			kref_get(&starget->reap_ref);
> +			starget->state = STARGET_REMOVE;
>  			spin_unlock_irqrestore(shost->host_lock, flags);
>  			__scsi_remove_target(starget);
>  			scsi_target_reap(starget);
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index f63a167..2bffaa6 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -240,6 +240,7 @@ scmd_printk(const char *, const struct scsi_cmnd *, const char *, ...);
>  enum scsi_target_state {
>  	STARGET_CREATED = 1,
>  	STARGET_RUNNING,
> +	STARGET_REMOVE,
>  	STARGET_DEL,
>  };
>  

Reviewed-by: Ewan D. Milne <emilne@redhat.com>
