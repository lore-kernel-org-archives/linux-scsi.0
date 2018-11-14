From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 4/5] scsi: libsas: Drop SAS_DPRINTK() and revise logs
 levels
Date: Wed, 14 Nov 2018 06:53:56 -0800
Message-ID: <132ba0c903b36d85db30cfebf58fe1f4c3a7c05b.camel@perches.com>
References: <1542203269-174932-1-git-send-email-john.garry@huawei.com>
         <1542203269-174932-5-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1542203269-174932-5-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: hare@suse.com, yanaijie@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2018-11-14 at 21:47 +0800, John Garry wrote:
> Like sas_printk() did previously, SAS_DPRINTK() offers little value now
> that libsas logs already have the "sas" prefix through pr_fmt(fmt). So it
> can be dropped.
> 
> However, after reviewing some logs in libsas, it is noticed that debug
> level is too low in many instances.
> 
> So this change drops SAS_DPRINTK() and revises some logs to a more
> appropriate level. However many stay at debug level, although some
> are significantly promoted.
[]
> All the pre-existing checkpatch errors for spanning messages across
> multiple lines are untouched.

I think coalescing would be useful.

Where there are already embedded "sas: "
prefixes, those should be removed too.

You could verify this by using

	$ strings drivers/scsi/libsas/*.o | grep "^[0-7]"

> @@ -186,10 +186,10 @@ int sas_notify_lldd_dev_found(struct domain_device *dev)
>  
>  	res = i->dft->lldd_dev_found(dev);
>  	if (res) {
> -		printk("sas: driver on pcidev %s cannot handle "
> -		       "device %llx, error:%d\n",
> -		       dev_name(sas_ha->dev),
> -		       SAS_ADDR(dev->sas_addr), res);
> +		pr_warn("sas: driver on pcidev %s cannot handle "
> +			"device %llx, error:%d\n",
> +			dev_name(sas_ha->dev),
> +			SAS_ADDR(dev->sas_addr), res);

e.g.: this now emits "sas: sas: driver etc..."
