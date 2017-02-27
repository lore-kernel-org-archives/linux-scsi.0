From: Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v2 01/16] chardev: add helper function to
 register char devs with a struct device
Date: Mon, 27 Feb 2017 10:47:29 +0100
Message-ID: <20170227094729.pvhy5oicqngcq4rn@piout.net>
References: <1488091097-12328-1-git-send-email-logang@deltatee.com>
 <1488091097-12328-2-git-send-email-logang@deltatee.com>
Reply-To: rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <rtc-linux+bncBCKYNX7Y3IMBBN7LZ7CQKGQERLXIQLY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Content-Disposition: inline
In-Reply-To: <1488091097-12328-2-git-send-email-logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Post: <https://groups.google.com/group/rtc-linux/post>, <mailto:rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:rtc-linux+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/rtc-linux
List-Subscribe: <https://groups.google.com/group/rtc-linux/subscribe>, <mailto:rtc-linux+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+712029733259+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/rtc-linux/subscribe>
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Sajjan Vikas C <vikas.cha.sajjan-ZPxbGqLxI0U@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Alexandre Courbot <gnurou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hartmut
List-Id: linux-scsi@vger.kernel.org

On 25/02/2017 at 23:38:02 -0700, Logan Gunthorpe wrote:
> Credit for this patch goes is shared with Dan Williams [1]. I've
> taken things one step further to make the helper function more
> useful and clean up calling code.
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
> to register a char device along with its parent struct device.
> This creates a more regular API for tying a char device to its parent
> without the developer having to set members in the underlying kobject.
> 
> This patch introduce cdev_device_add and cdev_device_del which
> replaces a common pattern including setting the kobj parent, calling
> cdev_add and then calling device_add. It also introduces cdev_set_parent
> for the few cases that set the kobject parent without using device_add.
> 
> [1] https://lkml.org/lkml/2017/2/13/700
> [2] https://lkml.org/lkml/2017/2/10/370
> 
> Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>


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
