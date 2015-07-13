From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] mpt2sas: Refcount sas_device objects and fix unsafe
 list usage
Date: Sun, 12 Jul 2015 23:52:06 -0700
Message-ID: <20150713065206.GC31842@infradead.org>
References: <1433821856-2815280-1-git-send-email-calvinowens@fb.com>
 <1436675096-324527-1-git-send-email-calvinowens@fb.com>
 <1436675096-324527-2-git-send-email-calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1436675096-324527-2-git-send-email-calvinowens@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Calvin Owens <calvinowens@fb.com>
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, Jul 11, 2015 at 09:24:55PM -0700, Calvin Owens wrote:
> These objects can be referenced concurrently throughout the driver, we
> need a way to make sure threads can't delete them out from under each
> other. This patch adds the refcount, and refactors the code to use it.
> 
> Additionally, we cannot iterate over the sas_device_list without
> holding the lock, or we risk corrupting random memory if items are
> added or deleted as we iterate. This patch refactors _scsih_probe_sas()
> to use the sas_device_list in a safe way.
> 
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Bart Van Assche <bart.vanassche@sandisk.com>
> Signed-off-by: Calvin Owens <calvinowens@fb.com>
> ---
>  drivers/scsi/mpt2sas/mpt2sas_base.h      |  22 +-
>  drivers/scsi/mpt2sas/mpt2sas_scsih.c     | 434 ++++++++++++++++++++-----------
>  drivers/scsi/mpt2sas/mpt2sas_transport.c |  12 +-
>  3 files changed, 315 insertions(+), 153 deletions(-)
> 
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
> index caff8d1..78f41ac 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.h
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
> @@ -238,6 +238,7 @@
>   * @flags: MPT_TARGET_FLAGS_XXX flags
>   * @deleted: target flaged for deletion
>   * @tm_busy: target is busy with TM request.
> + * @sdev: The sas_device associated with this target
>   */
>  struct MPT2SAS_TARGET {
>  	struct scsi_target *starget;
> @@ -248,6 +249,7 @@ struct MPT2SAS_TARGET {
>  	u32	flags;
>  	u8	deleted;
>  	u8	tm_busy;
> +	struct _sas_device *sdev;
>  };
>  
>  
> @@ -376,8 +378,24 @@ struct _sas_device {
>  	u8	phy;
>  	u8	responding;
>  	u8	pfa_led_on;
> +	struct kref refcount;
>  };
>  
> +static inline void sas_device_get(struct _sas_device *s)
> +{
> +	kref_get(&s->refcount);
> +}
> +
> +static inline void sas_device_free(struct kref *r)
> +{
> +	kfree(container_of(r, struct _sas_device, refcount));
> +}
> +
> +static inline void sas_device_put(struct _sas_device *s)
> +{
> +	kref_put(&s->refcount, sas_device_free);
> +}
> +
>  /**
>   * struct _raid_device - raid volume link list
>   * @list: sas device list
> @@ -1095,7 +1113,9 @@ struct _sas_node *mpt2sas_scsih_expander_find_by_handle(struct MPT2SAS_ADAPTER *
>      u16 handle);
>  struct _sas_node *mpt2sas_scsih_expander_find_by_sas_address(struct MPT2SAS_ADAPTER
>      *ioc, u64 sas_address);
> -struct _sas_device *mpt2sas_scsih_sas_device_find_by_sas_address(
> +struct _sas_device *mpt2sas_get_sdev_by_addr(
> +    struct MPT2SAS_ADAPTER *ioc, u64 sas_address);
> +struct _sas_device *__mpt2sas_get_sdev_by_addr(
>      struct MPT2SAS_ADAPTER *ioc, u64 sas_address);
>  
>  void mpt2sas_port_enable_complete(struct MPT2SAS_ADAPTER *ioc);
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> index 3f26147..fad80ce 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> @@ -526,8 +526,43 @@ _scsih_determine_boot_device(struct MPT2SAS_ADAPTER *ioc,
>  	}
>  }
>  
> +struct _sas_device *
> +__mpt2sas_get_sdev_from_target(struct MPT2SAS_TARGET *tgt_priv)
> +{
> +	struct _sas_device *ret;
> +

Does this need a:

	assert_spin_locked(&ioc->sas_device_lock);

?

Otherwise this looks sensible to me.
