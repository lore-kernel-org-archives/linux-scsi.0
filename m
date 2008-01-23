From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 2.6.23.14] SCSI : scsi_device_lookup/scsi_device_lookup_by_target
 return NULL for an existent scsi_device
Date: Wed, 23 Jan 2008 09:09:43 -0500
Message-ID: <47974AA7.8030300@emulex.com>
References: <622408.27957.qm@web53704.mail.re2.yahoo.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:35029 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbYAWOJq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jan 2008 09:09:46 -0500
In-Reply-To: <622408.27957.qm@web53704.mail.re2.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nagendra Tomar <tomer_iisc@yahoo.com>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


This sounds like a return to the old behavior, where sdevs in SDEV_DEL
were ignored. However, it too had lots of bad effects. We'd have to go
back to the threads over the last 2 years that justified resurrecting
the sdev. Start looking at threads like :
http://marc.info/?l=linux-scsi&m=115555788730468&w=2
http://marc.info/?l=linux-scsi&m=116837744314913&w=2
http://marc.info/?l=linux-scsi&m=117139230702785&w=2
http://marc.info/?l=linux-scsi&m=117991046126294&w=2
Also, there's multiple parts to this - the sdev struct, and the sysfs objects
and thus namespace associated with the struct, etc.

So, in my mind, if this reverts to ignoring sdevs in SDEV_DEL, and creates
a duplicate sdev in SDEV_RUNNING, then it's the wrong patch.  What should
be considered is where did the resurrection of the sdev go wrong.  I
remember that Hannes did some updates
http://marc.info/?l=linux-scsi&m=118215727101887&w=2
but I don't believe these ever got merged upstream. Perhaps that's a good
place to start.

-- james s


Nagendra Tomar wrote:
> __scsi_device_lookup and __scsi_device_lookup_by_target do not 
> check for the sdev_state and hence return scsi_devices with 
> sdev_state set to SDEV_DEL also. It has the following side effects.
> 
> We can have two scsi_devices with the same HBTL queued in 
> the scsi_host->__devices/scsi_target->devices list, one
> in the SDEV_DEL state and the other in, say SDEV_RUNNING state. 
>     If the one in the SDEV_DEL state is before the one in SDEV_RUNNING 
> state, (which will almost always be the case) the scsi_device_lookup and 
> scsi_device_lookup_by_target will never find the totally legitimate
> scsi_device (the one in the SDEV_RUNNING state).
> 
> This is because __scsi_device_lookup/__scsi_device_lookup_by_target 
> always returns the first one in the list (which in our case is the 
> one with the SDEV_DEL state) and the scsi_device_get() which is called by 
> scsi_device_lookup/scsi_device_lookup_by_target will return -ENXIO 
> for this scsi_device, resulting in scsi_device_lookup and 
> scsi_device_lookup_by_target to return NULL.
> 
>         So we _cannot_ lookup a perfectly valid device present in the
> list of scsi_devices. 
> 
>         The right thing to do is to not have __scsi_device_lookup
> and __scsi_device_lookup_by_target match a device if the scsi_device
> state is SDEV_DEL. This will also make these functions similar in 
> behaviour to their scsi_device_lookup/scsi_device_lookup_by_target
> counterparts, as the comments in the code suggest.
> 
>         One way by which we can have two scsi_devices in the list is 
> as follows.        
>         Suppose a scsi_device has some outstanding command(s) when 
> scsi_remove_device is called for it. Due to the extra ref being held
> by the command in flight, the __scsi_remove_device->put_device call 
> will not actually free the scsi_device and it will remain in the 
> scsi_device list albeit in the SDEV_DEL state. Now if we do a 
> scsi_add_device for the same HBTL, a new device with the same HBTL
> (this one in SDEV_RUNNING state) gets added to the scsi_device list. 
>         
>         Infact if we call scsi_add_device one more time, it happily 
> goes ahead and tries to add it once more, as 
> scsi_probe_and_add_lun->scsi_device_lookup_by_target does not return
> the already existing device. This will though result in the kobject 
> EEXIST warning dump.
> 
>         The patch below solves the problem described here by not
> returning scsi_devices in SDEV_DEL state, thus allowing scsi_device
> in SDEV_RUNNING state (if any) to be correctly returned, instead.
> 
> 
> Thanx,
> Tomar
> 
> 
> Signed-off-by: Nagendra Singh Tomar <nagendra_tomar@adaptec.com>
> ---
> 
> --- linux-2.6.23.14/drivers/scsi/scsi.c.orig	2008-01-23 18:06:02.000000000 +0530
> +++ linux-2.6.23.14/drivers/scsi/scsi.c	2008-01-23 19:17:35.000000000 +0530
> @@ -951,7 +951,7 @@ struct scsi_device *__scsi_device_lookup
>  	struct scsi_device *sdev;
>  
>  	list_for_each_entry(sdev, &starget->devices, same_target_siblings) {
> -		if (sdev->lun ==lun)
> +		if (sdev->lun == lun && sdev->sdev_state != SDEV_DEL)
>  			return sdev;
>  	}
>  
> @@ -1008,7 +1008,7 @@ struct scsi_device *__scsi_device_lookup
>  
>  	list_for_each_entry(sdev, &shost->__devices, siblings) {
>  		if (sdev->channel == channel && sdev->id == id &&
> -				sdev->lun ==lun)
> +			sdev->lun == lun && sdev->sdev_state != SDEV_DEL)
>  			return sdev;
>  	}
> 
> 
> 
>       ___________________________________________________________
> Support the World Aids Awareness campaign this month with Yahoo! For Good http://uk.promotions.yahoo.com/forgood/
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
