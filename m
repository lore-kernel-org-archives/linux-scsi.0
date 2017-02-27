From: Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v2 14/16] rtc: utilize new cdev_device_add
 helper function
Date: Mon, 27 Feb 2017 10:46:43 +0100
Message-ID: <20170227094643.pag5preyj2dueabd@piout.net>
References: <1488091097-12328-1-git-send-email-logang@deltatee.com>
 <1488091097-12328-15-git-send-email-logang@deltatee.com>
Reply-To: rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <rtc-linux+bncBCKYNX7Y3IMBBA7LZ7CQKGQEDQ3VPWQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Content-Disposition: inline
In-Reply-To: <1488091097-12328-15-git-send-email-logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Post: <https://groups.google.com/group/rtc-linux/post>, <mailto:rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:rtc-linux+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/rtc-linux
List-Subscribe: <https://groups.google.com/group/rtc-linux/subscribe>, <mailto:rtc-linux+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+712029733259+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/rtc-linux/subscribe>
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Sajjan Vikas C <vikas.cha.sajjan-ZPxbGqLxI0U@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Alexandre Courbot <gnurou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hartmut
List-Id: linux-scsi@vger.kernel.org

On 25/02/2017 at 23:38:15 -0700, Logan Gunthorpe wrote:
> Mostly straightforward, but we had to remove the rtc_dev_add/del_device
> functions as they split up the cdev_add and the device_add.
> 
> Doing this also revealed that there was likely another subtle bug:
> seeing cdev_add was done after device_register, the cdev probably
> was not ready before device_add when the uevent occurs. This would
> race with userspace, if it tried to use the device directly after
> the uevent. This is fixed just by using the new helper function.
> 
> Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Acked-by: Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>

> ---
>  drivers/rtc/class.c   | 14 ++++++++++----
>  drivers/rtc/rtc-dev.c | 17 -----------------
>  2 files changed, 10 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
> index 74fd974..5fb4398 100644
> --- a/drivers/rtc/class.c
> +++ b/drivers/rtc/class.c
> @@ -195,6 +195,8 @@ struct rtc_device *rtc_device_register(const char *name, struct device *dev,
>  		goto exit_ida;
>  	}
>  
> +	device_initialize(&rtc->dev);
> +
>  	rtc->id = id;
>  	rtc->ops = ops;
>  	rtc->owner = owner;
> @@ -233,14 +235,19 @@ struct rtc_device *rtc_device_register(const char *name, struct device *dev,
>  
>  	rtc_dev_prepare(rtc);
>  
> -	err = device_register(&rtc->dev);
> +	err = cdev_device_add(&rtc->char_dev, &rtc->dev);
>  	if (err) {
> +		dev_warn(&rtc->dev, "%s: failed to add char device %d:%d\n",
> +			 rtc->name, MAJOR(rtc->dev.devt), rtc->id);
> +
>  		/* This will free both memory and the ID */
>  		put_device(&rtc->dev);
>  		goto exit;
> +	} else {
> +		dev_dbg(&rtc->dev, "%s: dev (%d:%d)\n", rtc->name,
> +			MAJOR(rtc->dev.devt), rtc->id);
>  	}
>  
> -	rtc_dev_add_device(rtc);
>  	rtc_proc_add_device(rtc);
>  
>  	dev_info(dev, "rtc core: registered %s as %s\n",
> @@ -271,9 +278,8 @@ void rtc_device_unregister(struct rtc_device *rtc)
>  	 * Remove innards of this RTC, then disable it, before
>  	 * letting any rtc_class_open() users access it again
>  	 */
> -	rtc_dev_del_device(rtc);
>  	rtc_proc_del_device(rtc);
> -	device_del(&rtc->dev);
> +	cdev_device_del(&rtc->char_dev, &rtc->dev);
>  	rtc->ops = NULL;
>  	mutex_unlock(&rtc->ops_lock);
>  	put_device(&rtc->dev);
> diff --git a/drivers/rtc/rtc-dev.c b/drivers/rtc/rtc-dev.c
> index a6d9434..fdd071f 100644
> --- a/drivers/rtc/rtc-dev.c
> +++ b/drivers/rtc/rtc-dev.c
> @@ -477,23 +477,6 @@ void rtc_dev_prepare(struct rtc_device *rtc)
>  
>  	cdev_init(&rtc->char_dev, &rtc_dev_fops);
>  	rtc->char_dev.owner = rtc->owner;
> -	rtc->char_dev.kobj.parent = &rtc->dev.kobj;
> -}
> -
> -void rtc_dev_add_device(struct rtc_device *rtc)
> -{
> -	if (cdev_add(&rtc->char_dev, rtc->dev.devt, 1))
> -		dev_warn(&rtc->dev, "%s: failed to add char device %d:%d\n",
> -			rtc->name, MAJOR(rtc_devt), rtc->id);
> -	else
> -		dev_dbg(&rtc->dev, "%s: dev (%d:%d)\n", rtc->name,
> -			MAJOR(rtc_devt), rtc->id);
> -}
> -
> -void rtc_dev_del_device(struct rtc_device *rtc)
> -{
> -	if (rtc->dev.devt)
> -		cdev_del(&rtc->char_dev);
>  }
>  
>  void __init rtc_dev_init(void)
> -- 
> 2.1.4
> 

-- 
Alexandre Belloni, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

-- 
You received this message because you are subscribed to "rtc-linux".
Membership options at http://groups.google.com/group/rtc-linux .
Please read http://groups.google.com/group/rtc-linux/web/checklist
before submitting a driver.
--- 
You received this message because you are subscribed to the Google Groups "rtc-linux" group.
To unsubscribe from this group and stop receiving emails from it, send an email to rtc-linux+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit https://groups.google.com/d/optout.
