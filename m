From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: [RFC] exposing the sdev_target in sysfs
Date: Fri, 03 Sep 2004 21:48:01 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41394901.3050804@us.ibm.com>
References: <1094254851.1712.28.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:3732 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266679AbUIDEtI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Sep 2004 00:49:08 -0400
In-Reply-To: <1094254851.1712.28.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> The aim of this patch is to give us somewhere to hang the per target
> timer that emulex needs.
> 
> However, it will break the current sysfs layout.  devices will now
> appear something like this:
> 
> lrwxrwxrwx  1 root root 0 Sep  3 18:31
> /sys/class/scsi_device/0:0:5:0/device ->
> ../../../devices/parisc8/parisc8:0/pci0000:00/0000:00:13.0/host0/target0:0:5/0:0:5:0
> 
> (note the extra target0:0:5 in there).
> 
> which may break some of the user land tools (although you're all using
> the scsi class interface to access your devices, aren't you? in which
> case you won't notice any problems).
> 
> Comments welcome.
> 
> James

Hi James,

One tiny problem below.

> +int scsi_sysfs_target_initialize(struct scsi_device *sdev)
> +{
> +	struct scsi_target *starget = NULL;
> +	struct scsi_device *sdev_sibling;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(sdev->host->host_lock, flags);
> +	/*
> +	 * Search for an existing target for this sdev.
> +	 */
> +	list_for_each_entry(sdev_sibling, &sdev->same_target_siblings,
> +			    same_target_siblings) {
> +		if (sdev_sibling->sdev_gendev.parent != NULL) {
> +			starget = scsi_target(sdev_sibling);
> +			break;
> +		}
> +	}
> +	if (!starget) {
> +		struct device *dev;
> +		int error;
> +
> +		starget = kmalloc(sizeof(*starget), GFP_ATOMIC);
> +		if (!starget) {
> +			printk(KERN_ERR "%s: allocation failure\n", __FUNCTION__);
> +			spin_unlock_irqrestore(sdev->host->host_lock,
> +					       flags);
> +			return -ENOMEM;
> +		}
> +		memset(starget, 0, sizeof(*starget));
> +		dev = &starget->dev;
> +		device_initialize(dev);
> +		dev->parent = &sdev->host->shost_gendev;
> +		dev->bus = &scsi_bus_type;
> +		dev->release = scsi_target_dev_release;
> +		sprintf(dev->bus_id, "target%d:%d:%d",
> +			sdev->host->host_no, sdev->channel, sdev->id);
> +		if ((error = device_add(dev))) {

device_add calls kobject_add which can sleep.

> +			spin_unlock_irqrestore(sdev->host->host_lock, flags);
> +			printk(KERN_ERR "Target device_add failed\n");
> +			return error;
> +		}
> +	}
> +	get_device(&starget->dev);
> +	sdev->sdev_gendev.parent = &starget->dev;
> +	spin_unlock_irqrestore(sdev->host->host_lock, flags);
>  	return 0;
>  }
>  
> 
