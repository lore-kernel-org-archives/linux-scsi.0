From: Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 01/14] chardev: add helper function to
 register char devs with a struct device
Date: Mon, 20 Feb 2017 21:35:22 -0800
Message-ID: <20170221053522.GA1466@dtor-ws>
References: <1487653253-11497-1-git-send-email-logang@deltatee.com>
 <1487653253-11497-2-git-send-email-logang@deltatee.com>
Reply-To: rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <rtc-linux+bncBDP6N55ZUYDRBHVDV7CQKGQEU327AYQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Content-Disposition: inline
In-Reply-To: <1487653253-11497-2-git-send-email-logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Post: <https://groups.google.com/group/rtc-linux/post>, <mailto:rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:rtc-linux+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/rtc-linux
List-Subscribe: <https://groups.google.com/group/rtc-linux/subscribe>, <mailto:rtc-linux+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+712029733259+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/rtc-linux/subscribe>
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Sajjan Vikas C <vikas.cha.sajjan-ZPxbGqLxI0U@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Alexandre Courbot <gnurou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hartmut Knaack <knaac>
List-Id: linux-scsi@vger.kernel.org

On Mon, Feb 20, 2017 at 10:00:40PM -0700, Logan Gunthorpe wrote:
> Credit for this patch goes entirely to Dan Williams [1]. I've just
> fleshed out the comments and created the patch, but the premise
> remains exactly the same.
> 
> There's a common pattern in the kernel whereby a struct cdev is placed
> in a structure along side a struct device which manages the life-cycle
> of both. In the naive approach, the reference counting is broken and
> the struct device can free everything before the chardev code
> is entirely released.
> 
> Many developers have solved this problem by linking the internal kobjs
> in this fashion:
> 
> cdev.kobj.parent = &parent_dev.kobj;
> 
> The cdev code explicitly gets and puts a reference to it's kobj parent.
> So this seems like it was intended to be used this way. Dmitrty Torokhov
> first put this in place in 2012 with this commit:
> 
> 2f0157f char_dev: pin parent kobject
> 
> and the first instance of the fix was then done in the input subsystem
> in the following commit:
> 
> 4a215aa Input: fix use-after-free introduced with dynamic minor changes
> 
> Subsequently over the years, however, this issue seems to have tripped
> up multiple developers independently. For example, see these commits:
> 
> 0d5b7da iio: Prevent race between IIO chardev opening and IIO device
> (by Lars-Peter Clausen in 2013)
> 
> ba0ef85 tpm: Fix initialization of the cdev
> (by Jason Gunthorpe in 2015)
> 
> 5b28dde [media] media: fix use-after-free in cdev_put() when app exits
> after driver unbind
> (by Shauh Khan in 2016)
> 
> This technique is similarly done in at least 15 places within the kernel
> and probably should have been done so in another, at least, 5 places.
> The kobj line also looks very suspect in that one would not expect
> drivers to have to mess with kobject internals in this way.
> Even highly experienced kernel developers can be surprised by this
> code, as seen in [2].
> 
> To help alleviate this situation, and hopefully prevent future
> wasted effort on this problem, this patch introduces a helper function
> to register a char device with its parent struct device. This creates
> a more regular API for tying a char device to its parent without the
> developer having to set members in the underlying kobject.
> 
> In [1], Dan notes he took inspiration for the form of the API
> device_add_disk.
> 
> [1] https://lkml.org/lkml/2017/2/13/700
> [2] https://lkml.org/lkml/2017/2/10/370
> 
> Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
> ---
>  fs/char_dev.c        | 24 ++++++++++++++++++++++++
>  include/linux/cdev.h |  1 +
>  2 files changed, 25 insertions(+)
> 
> diff --git a/fs/char_dev.c b/fs/char_dev.c
> index 44a240c..1f9246c 100644
> --- a/fs/char_dev.c
> +++ b/fs/char_dev.c
> @@ -471,6 +471,29 @@ int cdev_add(struct cdev *p, dev_t dev, unsigned count)
>  	return 0;
>  }
>  
> +/**
> + * device_add_cdev() - add a char device to the system with a parent
> + *	struct device
> + * @parent: the device structure of the parent
> + * @cdev: the cdev structure for the device
> + * @count: the number of consecutive minor numbers corresponding to this
> + *
> + * device_add_cdev() adds the char device represented by @p to the system,
> + * just as cdev_add does. The dev_t for the char device will be taken from
> + * the struct device which needs to be initialized first. This helper
> + * function correctly takes a reference to the parent device so the parent
> + * will not get released until all references to the cdev are released.
> + * (Thus, cdev_del should be called before device_unregister.) This

My only objection is to this statement. There is absolutely nothing that
prevents from calling device_unregister() first and cdev_del() later.
Refcounting will sort it all out.

> + * function should be used whenever the struct cdev and the struct device
> + * are members of the same structure whose lifetime is managed by the
> + * struct device.
> + */
> +int device_add_cdev(struct device *parent, struct cdev *cdev)
> +{
> +	cdev->kobj.parent = &parent->kobj;
> +	return cdev_add(cdev, parent->devt, 1);
> +}
> +
>  static void cdev_unmap(dev_t dev, unsigned count)
>  {
>  	kobj_unmap(cdev_map, dev, count);
> @@ -570,5 +593,6 @@ EXPORT_SYMBOL(cdev_init);
>  EXPORT_SYMBOL(cdev_alloc);
>  EXPORT_SYMBOL(cdev_del);
>  EXPORT_SYMBOL(cdev_add);
> +EXPORT_SYMBOL(device_add_cdev);
>  EXPORT_SYMBOL(__register_chrdev);
>  EXPORT_SYMBOL(__unregister_chrdev);
> diff --git a/include/linux/cdev.h b/include/linux/cdev.h
> index f876361..9edbc37 100644
> --- a/include/linux/cdev.h
> +++ b/include/linux/cdev.h
> @@ -25,6 +25,7 @@ struct cdev *cdev_alloc(void);
>  void cdev_put(struct cdev *p);
>  
>  int cdev_add(struct cdev *, dev_t, unsigned);
> +int device_add_cdev(struct device *parent, struct cdev *cdev);
>  
>  void cdev_del(struct cdev *);
>  

Thanks.

-- 
Dmitry

-- 
You received this message because you are subscribed to "rtc-linux".
Membership options at http://groups.google.com/group/rtc-linux .
Please read http://groups.google.com/group/rtc-linux/web/checklist
before submitting a driver.
--- 
You received this message because you are subscribed to the Google Groups "rtc-linux" group.
To unsubscribe from this group and stop receiving emails from it, send an email to rtc-linux+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit https://groups.google.com/d/optout.
