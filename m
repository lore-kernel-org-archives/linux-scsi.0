From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: [PATCH] scsi_device refcounting and list lockdown
Date: Mon, 27 Oct 2003 16:01:01 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031027160101.76d5291b.rddunlap@osdl.org>
References: <20031027155713.GA28140@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:41964 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263785AbTJ1AD1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Oct 2003 19:03:27 -0500
In-Reply-To: <20031027155713.GA28140@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

On Mon, 27 Oct 2003 16:57:13 +0100 Christoph Hellwig <hch@lst.de> wrote:

| --- 1.129/drivers/scsi/scsi.c	Sat Oct 18 01:14:06 2003
| +++ edited/drivers/scsi/scsi.c	Mon Oct 27 12:01:49 2003
| @@ -883,49 +883,124 @@
|  	return depth;
|  }
|  
| +/**
| + * scsi_device_get  -  get an addition reference to a scsi_device
| + * @sdev:	device to get a reference to
| + *
| + * Gets a reference to the scsi_device and increments the use count
| + * of the underlying LLDD module.  You must hold host_lock of the
| + * parent Scsi_Host or already have a reference when calling this.
| + */
|  int scsi_device_get(struct scsi_device *sdev)
|  {
| -	struct class *class = class_get(&sdev_class);
| -
| -	if (!class)
| -		goto out;
|  	if (test_bit(SDEV_DEL, &sdev->sdev_state))
| -		goto out;
| -	if (!try_module_get(sdev->host->hostt->module))
| -		goto out;
| +		return -ENXIO;
|  	if (!get_device(&sdev->sdev_gendev))
| -		goto out_put_module;
| -	atomic_inc(&sdev->access_count);
| -	class_put(&sdev_class);
| +		return -ENXIO;
| +	if (!try_module_get(sdev->host->hostt->module)) {
| +		put_device(&sdev->sdev_gendev);
| +		return -ENXIO;
| +	}
|  	return 0;
| +}
| +EXPORT_SYMBOL(scsi_device_get);
|  
| - out_put_module:
| +/**
| + * scsi_device_put  -  release a reference to a scsi_device
| + * @sdev:	device to release a reference on.
| + *
| + * Release a reference to the scsi_device and decrements the use count
| + * of the underlying LLDD module.  The device is freed once the last
| + * user vanishes.
| + */
| +void scsi_device_put(struct scsi_device *sdev)
| +{
|  	module_put(sdev->host->hostt->module);
| - out:
| -	class_put(&sdev_class);
| -	return -ENXIO;
| +	put_device(&sdev->sdev_gendev);
|  }
| +EXPORT_SYMBOL(scsi_device_put);


Hi,

Even before this patch (which isn't merged AFAIK), are
scsi_device_get() and scsi_device_put() intended to be used
by SCSI LLDD's for scsi_device reference counts?

I'm trying to determine what needs to be done to fix aha152x.c,
where it creates a struct scsi_cmnd and then inits as follows,
with my example patch:


description:	busfree_run() allocates a cmnd and references
		cmnd->device->... without setting cmd->device
product_versions: Linux 2.6.0-test9
patch_name:	aha152x-device-ptr.patch
author:		Randy.Dunlap <rddunlap@osdl.org>
patch_version:	2003-10-27.10:54:42

diffstat:=
 drivers/scsi/aha152x.c |    1 +
 1 files changed, 1 insertion(+)

diff -Naurp ./drivers/scsi/aha152x.c~aha152xfix ./drivers/scsi/aha152x.c
--- ./drivers/scsi/aha152x.c~aha152xfix	2003-10-25 11:42:50.000000000 -0700
+++ ./drivers/scsi/aha152x.c	2003-10-27 10:54:09.000000000 -0800
@@ -2018,6 +2018,7 @@ static void busfree_run(struct Scsi_Host
 					cmnd->cmnd[4]         = sizeof(ptr->sense_buffer);
 					cmnd->cmnd[5]         = 0;
 					cmnd->cmd_len	      = 6;
+					cmnd->device          = ptr->device;
 					cmnd->device->host    = ptr->device->host;
 					cmnd->device->id      = ptr->device->id;
 					cmnd->device->lun     = ptr->device->lun;




Thanks,
--
~Randy
