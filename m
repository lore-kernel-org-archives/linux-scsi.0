From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] fix rescan warning
Date: Tue, 18 Mar 2003 11:18:42 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E7673F2.2000409@torque.net>
References: <20030317165301.B29420@lst.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> The prototype for scsi_rescan_device was missing and once added it's
> caller doesn't compile anymore because it expects a return value..
> 
> 
> --- 1.67/drivers/scsi/scsi.h	Sat Mar 15 01:35:26 2003
> +++ edited/drivers/scsi/scsi.h	Mon Mar 17 16:04:49 2003
> @@ -442,6 +442,7 @@
>  extern int scsi_retry_command(Scsi_Cmnd *);
>  extern int scsi_attach_device(struct scsi_device *);
>  extern void scsi_detach_device(struct scsi_device *);
> +extern void scsi_rescan_device(struct scsi_device *);
>  extern int scsi_get_device_flags(unsigned char *vendor, unsigned char *model);
>  
>  /*
> --- 1.8/drivers/scsi/scsi_sysfs.c	Tue Mar  4 10:15:42 2003
> +++ edited/drivers/scsi/scsi_sysfs.c	Mon Mar 17 16:30:31 2003
> @@ -275,12 +275,8 @@
>  static ssize_t
>  store_rescan_field (struct device *dev, const char *buf, size_t count) 
>  {
> -	int ret = ENODEV;
> -	struct scsi_device *sdev;
> -	sdev = to_scsi_device(dev);
> -	if (sdev)
> -		ret = scsi_rescan_device(sdev);
> -	return ret;
> +	scsi_rescan_device(to_scsi_device(dev));
> +	return 0;
>  }
>  
>  static DEVICE_ATTR(rescan, S_IRUGO | S_IWUSR, show_rescan_field, store_rescan_field)
> -

Christoph,
How does this work from a users point of view?
Something like:
   # cd /sys/bus/scsi/devices/2:0:0:0
   # echo "anything_I_like" > rescan

A sysfs store() is meant to return the number of
bytes consumed. In that case shouldn't the last
active line of the patch be "return count;".

How does rescan help us? ...
  - a device at the same toplogical address changing its
    INQUIRY or READ CAPACITY response
  - attempt a offline to online transition
  - if the device could be no longer there so it
    would be equivalent to
      "echo 'scsi remove-single-device h c t l' > /proc/scsi/scsi
    in that case.


When we get "real" scsi_host nodes in sysfs (i.e. with an
instance (not a pointer) of struct device in struct scsi_host)
then perhaps we can put a "scan" node in there to perform
a bus (re-)scan.

Doug Gilbert




