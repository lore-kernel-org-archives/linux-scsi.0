From: Christof Schmitt <christof.schmitt-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] scsi-ml: adds queue_depth ramp up code
Date: Tue, 20 Oct 2009 20:54:26 +0200
Message-ID: <20091020185426.GA5905@schmichrtp.de.ibm.com>
References: <20091016004700.22451.42962.stgit@vifc.jf.intel.com>
	<20091016230824.18916.84116.stgit@vifc.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091016230824.18916.84116.stgit-M4Lc0Xp98oKtqXYlAKuG4QC/G2K4zDHf@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: Vasu Dev <vasu.dev-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 16, 2009 at 04:08:24PM -0700, Vasu Dev wrote:
> -v3
>  Moves max_queue_depth initialization after slave_configure is
> called from after slave_alloc calling done. Also adjusted
> max_queue_depth check to skip ramp up if current queue_depth
> is >= max_queue_depth.
> 
> Signed-off-by: Vasu Dev <vasu.dev-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Looks good to me. I ran some tests on s390 and the queue depth counter
increased until hitting the defined maximum.

> @@ -779,6 +781,36 @@ static struct device_attribute sdev_attr_queue_depth_rw =
>  	       sdev_store_queue_depth_rw);
> 
>  static ssize_t
> +sdev_show_queue_ramp_up_period(struct device *dev,
> +			       struct device_attribute *attr,
> +			       char *buf)
> +{
> +	struct scsi_device *sdev;
> +	sdev = to_scsi_device(dev);
> +	return snprintf(buf, 20, "%lu\n", sdev->queue_ramp_up_period);
> +}
> +
> +static ssize_t
> +sdev_store_queue_ramp_up_period(struct device *dev,
> +				struct device_attribute *attr,
> +				const char *buf, size_t count)
> +{
> +	struct scsi_device *sdev = to_scsi_device(dev);
> +	unsigned long period;
> +
> +	if (strict_strtoul(buf, 10, &period))
> +		return -EINVAL;
> +
> +	sdev->queue_ramp_up_period = period;
> +	return period;
> +}

[...]
> +	unsigned long queue_ramp_up_period;	/* ramp up period in jiffies */
> +#define SCSI_DEFAULT_RAMP_UP_PERIOD	(120 * HZ)

Only a small inconvenience i guess: The sysfs attribute shows the
ramp-up-period in jiffies. On my system with HZ==100 the default is
12000 and i was wondering if this would be milliseconds or something
related. If HZ changes, the unit of the ramp-up-period also changes.

I would prefer having seconds or milliseconds in sysfs and only using
jiffies internally.

Thanks for doing this,

Christof
