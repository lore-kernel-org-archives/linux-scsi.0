From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH for v4.3-rc] scsi_dh: fix use-after-free when removing
 scsi device
Date: Wed, 21 Oct 2015 00:36:34 +0000
Message-ID: <20151021003633.GA4595@xzibit.linux.bs1.fc.nec.co.jp>
References: <20151006043256.GA8193@xzibit.linux.bs1.fc.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([210.143.35.51]:36650 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbbJUAhz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Oct 2015 20:37:55 -0400
In-Reply-To: <20151006043256.GA8193@xzibit.linux.bs1.fc.nec.co.jp>
Content-Language: ja-JP
Content-ID: <888DEFC076B8DA419D222244217D5226@gisp.nec.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>

On 10/06/15 13:32, Junichi Nomura wrote:
> The commit 1bab0de0274f ("dm-mpath, scsi_dh: don't let dm detach device
> handlers") removed reference counting of attached scsi device handler.
> As a result, handler data is freed immediately via scsi_dh->detach()
> in the context of scsi_remove_device() where activation request can be
> still in flight.
> 
> This patch moves scsi_dh_handler_detach() to sdev releasing function,
> scsi_device_dev_release_usercontext(), at that point the device
> is already in quiesced state.
> 
> Fixes: 1bab0de0274f ("dm-mpath, scsi_dh: don't let dm detach device handlers")
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Acked-by: Christoph Hellwig <hch@lst.de>

Hello James,

could we get this regression fix before 4.3 is released?

Problem happens like this:

  dm-multipath                   sysadmin
  ------------------------------------------------------------------
  scsi_dh_activate()
    [start using handler data]
                                 echo 1 > /sys/block/sdX/device/delete
                                   scsi_remove_device()
                                     scsi_dh_remove_device()
                                       scsi_dh->detach()
                                         kfree(handler data)
    [still using freed handler data]
    [finish using handler data]

and can result in crash or data corruption.

> ---
>  drivers/scsi/scsi_dh.c    | 6 +++++-
>  drivers/scsi/scsi_priv.h  | 2 ++
>  drivers/scsi/scsi_sysfs.c | 2 ++
>  3 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
> index edb044a..19bf9db 100644
> --- a/drivers/scsi/scsi_dh.c
> +++ b/drivers/scsi/scsi_dh.c
> @@ -232,10 +232,14 @@ int scsi_dh_add_device(struct scsi_device *sdev)
>  	return err;
>  }
>  
> -void scsi_dh_remove_device(struct scsi_device *sdev)
> +void scsi_dh_release_device(struct scsi_device *sdev)
>  {
>  	if (sdev->handler)
>  		scsi_dh_handler_detach(sdev);
> +}
> +
> +void scsi_dh_remove_device(struct scsi_device *sdev)
> +{
>  	device_remove_file(&sdev->sdev_gendev, &scsi_dh_state_attr);
>  }
>  
> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> index 644bb73..4d01cdb 100644
> --- a/drivers/scsi/scsi_priv.h
> +++ b/drivers/scsi/scsi_priv.h
> @@ -173,9 +173,11 @@ extern struct async_domain scsi_sd_probe_domain;
>  /* scsi_dh.c */
>  #ifdef CONFIG_SCSI_DH
>  int scsi_dh_add_device(struct scsi_device *sdev);
> +void scsi_dh_release_device(struct scsi_device *sdev);
>  void scsi_dh_remove_device(struct scsi_device *sdev);
>  #else
>  static inline int scsi_dh_add_device(struct scsi_device *sdev) { return 0; }
> +static inline void scsi_dh_release_device(struct scsi_device *sdev) { }
>  static inline void scsi_dh_remove_device(struct scsi_device *sdev) { }
>  #endif
>  
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index b333389..dff8faf 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -399,6 +399,8 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
>  
>  	sdev = container_of(work, struct scsi_device, ew.work);
>  
> +	scsi_dh_release_device(sdev);
> +
>  	parent = sdev->sdev_gendev.parent;
>  
>  	spin_lock_irqsave(sdev->host->host_lock, flags);


-- 
Jun'ichi Nomura, NEC Corporation
