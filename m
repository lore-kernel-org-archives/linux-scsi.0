From: Guenter Roeck <guenter.roeck@ericsson.com>
Subject: Re: [PATCH 2/8] hwmon: convert idr to ida and use ida_simple
	interface.
Date: Thu, 28 Jul 2011 17:19:07 -0700
Message-ID: <20110729001907.GA4496@ericsson.com>
References: <1311352886-4047-1-git-send-email-jic23@cam.ac.uk>
	<1311352886-4047-3-git-send-email-jic23@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dri-devel-bounces+sf-dri-devel=m.gmane.org@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <1311352886-4047-3-git-send-email-jic23@cam.ac.uk>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/dri-devel>,
	<mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/dri-devel>,
	<mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Sender: dri-devel-bounces+sf-dri-devel=m.gmane.org@lists.freedesktop.org
Errors-To: dri-devel-bounces+sf-dri-devel=m.gmane.org@lists.freedesktop.org
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "johnpol@2ka.mipt.ru" <johnpol@2ka.mipt.ru>, "thellstrom@vmware.com" <thellstrom@vmware.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "JBottomley@parallels.com" <JBottomley@parallels.com>, "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>, "bharrosh@panasas.com" <bharrosh@panasas.com>, "airlied@redhat.com" <airlied@redhat.com>, "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>, "naota@elisp.net" <naota@elisp.net>, "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>, "namhyung@gmail.com" <namhyung@gmail.com>, "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>, "khali@linux-fr.org" <khali@linux-fr.org>, "osd-dev@open-osd.org" <osd-dev@open-osd.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, a.zummo
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 22, 2011 at 12:41:11PM -0400, Jonathan Cameron wrote:
> hwmon was using an idr with a NULL pointer, so convert to an
> ida which then allows use of Rusty's ida_simple_get.
> 
> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>

Looks ok to me.

Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>

> ---
>  drivers/hwmon/hwmon.c |   32 ++++++++------------------------
>  1 files changed, 8 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
> index a61e781..6460487 100644
> --- a/drivers/hwmon/hwmon.c
> +++ b/drivers/hwmon/hwmon.c
> @@ -27,8 +27,7 @@
>  
>  static struct class *hwmon_class;
>  
> -static DEFINE_IDR(hwmon_idr);
> -static DEFINE_SPINLOCK(idr_lock);
> +static DEFINE_IDA(hwmon_ida);
>  
>  /**
>   * hwmon_device_register - register w/ hwmon
> @@ -42,30 +41,17 @@ static DEFINE_SPINLOCK(idr_lock);
>  struct device *hwmon_device_register(struct device *dev)
>  {
>  	struct device *hwdev;
> -	int id, err;
> -
> -again:
> -	if (unlikely(idr_pre_get(&hwmon_idr, GFP_KERNEL) == 0))
> -		return ERR_PTR(-ENOMEM);
> -
> -	spin_lock(&idr_lock);
> -	err = idr_get_new(&hwmon_idr, NULL, &id);
> -	spin_unlock(&idr_lock);
> +	int id;
>  
> -	if (unlikely(err == -EAGAIN))
> -		goto again;
> -	else if (unlikely(err))
> -		return ERR_PTR(err);
> +	id = ida_simple_get(&hwmon_ida, 0, 0, GFP_KERNEL);
> +	if (id < 0)
> +		return ERR_PTR(id);
>  
> -	id = id & MAX_ID_MASK;
>  	hwdev = device_create(hwmon_class, dev, MKDEV(0, 0), NULL,
>  			      HWMON_ID_FORMAT, id);
>  
> -	if (IS_ERR(hwdev)) {
> -		spin_lock(&idr_lock);
> -		idr_remove(&hwmon_idr, id);
> -		spin_unlock(&idr_lock);
> -	}
> +	if (IS_ERR(hwdev))
> +		ida_simple_remove(&hwmon_ida, id);
>  
>  	return hwdev;
>  }
> @@ -81,9 +67,7 @@ void hwmon_device_unregister(struct device *dev)
>  
>  	if (likely(sscanf(dev_name(dev), HWMON_ID_FORMAT, &id) == 1)) {
>  		device_unregister(dev);
> -		spin_lock(&idr_lock);
> -		idr_remove(&hwmon_idr, id);
> -		spin_unlock(&idr_lock);
> +		ida_simple_remove(&hwmon_ida, id);
>  	} else
>  		dev_dbg(dev->parent,
>  			"hwmon_device_unregister() failed: bad class ID!\n");
> -- 
> 1.7.3.4
> 
