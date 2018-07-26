From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH, RESEND] Avoid that SCSI device removal through sysfs
 triggers a deadlock
Date: Thu, 26 Jul 2018 06:35:27 -0700
Message-ID: <20180726133527.GU1934745@devbig577.frc2.facebook.com>
References: <20180725173828.2227-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180725173828.2227-1-bart.vanassche@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "Eric W . Biederman" <ebiederm@xmission.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

ISTR giving the same feedback before.

On Wed, Jul 25, 2018 at 10:38:28AM -0700, Bart Van Assche wrote:
> +struct remove_dev_work {
> +	struct callback_head	head;
> +	struct scsi_device	*sdev;
> +};
> +
> +static void delete_sdev(struct callback_head *head)
> +{
> +	struct remove_dev_work *work = container_of(head, typeof(*work), head);
> +	struct scsi_device *sdev = work->sdev;
> +
> +	scsi_remove_device(sdev);
> +	kfree(work);
> +	scsi_device_put(sdev);
> +}
> +
>  static ssize_t
>  sdev_store_delete(struct device *dev, struct device_attribute *attr,
>  		  const char *buf, size_t count)
>  {
> -	if (device_remove_file_self(dev, attr))
> -		scsi_remove_device(to_scsi_device(dev));
> -	return count;
> -};
> +	struct scsi_device *sdev = to_scsi_device(dev);
> +	struct remove_dev_work *work;
> +	int ret;
> +
> +	ret = scsi_device_get(sdev);
> +	if (ret < 0)
> +		goto out;
> +	ret = -ENOMEM;
> +	work = kmalloc(sizeof(*work), GFP_KERNEL);
> +	if (!work)
> +		goto put;
> +	work->head.func = delete_sdev;
> +	work->sdev = sdev;
> +	ret = task_work_add(current, &work->head, false);
> +	if (ret < 0)
> +		goto free;
> +	ret = count;
> +
> +out:
> +	return ret;
> +
> +free:
> +	kfree(work);
> +
> +put:
> +	scsi_device_put(sdev);
> +	goto out;
> +}

Making removal asynchronous this way sometimes causes issues because
whether the user sees the device released or not is racy.
kernfs/sysfs have mechanisms to deal with these cases - remove_self
and kernfs_break_active_protection().  Have you looked at those?

Thanks.

-- 
tejun
