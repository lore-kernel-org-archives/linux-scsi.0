From: Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 04/16] input: utilize new cdev_device_add
 helper function
Date: Tue, 28 Feb 2017 10:27:34 -0800
Message-ID: <20170228182734.GC20776@dtor-ws>
References: <1488091097-12328-1-git-send-email-logang@deltatee.com>
 <1488091097-12328-5-git-send-email-logang@deltatee.com>
Reply-To: rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <rtc-linux+bncBDP6N55ZUYDRBGUC27CQKGQES5LLKCA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Content-Disposition: inline
In-Reply-To: <1488091097-12328-5-git-send-email-logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Post: <https://groups.google.com/group/rtc-linux/post>, <mailto:rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:rtc-linux+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/rtc-linux
List-Subscribe: <https://groups.google.com/group/rtc-linux/subscribe>, <mailto:rtc-linux+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+712029733259+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/rtc-linux/subscribe>
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Sajjan Vikas C <vikas.cha.sajjan-ZPxbGqLxI0U@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Alexandre Courbot <gnurou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hartmut Knaack <knaack.h-Mmb7MZpHnFY@public.gmane.org>, Lars-Peter Clausen <lars@>
List-Id: linux-scsi@vger.kernel.org

On Sat, Feb 25, 2017 at 11:38:05PM -0700, Logan Gunthorpe wrote:
> Replace the open coded registration of the cdev and dev with the
> new device_add_cdev() helper in evdev, joydev and mousedev. The helper
> replaces a common pattern by taking the proper reference against the
> parent device and adding both the cdev and the device.
> 
> Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>

Acked-by: Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

> ---
>  drivers/input/evdev.c    | 11 ++---------
>  drivers/input/joydev.c   | 11 ++---------
>  drivers/input/mousedev.c | 11 ++---------
>  3 files changed, 6 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> index e9ae3d5..9255714 100644
> --- a/drivers/input/evdev.c
> +++ b/drivers/input/evdev.c
> @@ -1354,8 +1354,6 @@ static void evdev_cleanup(struct evdev *evdev)
>  	evdev_mark_dead(evdev);
>  	evdev_hangup(evdev);
>  
> -	cdev_del(&evdev->cdev);
> -
>  	/* evdev is marked dead so no one else accesses evdev->open */
>  	if (evdev->open) {
>  		input_flush_device(handle, NULL);
> @@ -1416,12 +1414,8 @@ static int evdev_connect(struct input_handler *handler, struct input_dev *dev,
>  		goto err_free_evdev;
>  
>  	cdev_init(&evdev->cdev, &evdev_fops);
> -	evdev->cdev.kobj.parent = &evdev->dev.kobj;
> -	error = cdev_add(&evdev->cdev, evdev->dev.devt, 1);
> -	if (error)
> -		goto err_unregister_handle;
>  
> -	error = device_add(&evdev->dev);
> +	error = cdev_device_add(&evdev->cdev, &evdev->dev);
>  	if (error)
>  		goto err_cleanup_evdev;
>  
> @@ -1429,7 +1423,6 @@ static int evdev_connect(struct input_handler *handler, struct input_dev *dev,
>  
>   err_cleanup_evdev:
>  	evdev_cleanup(evdev);
> - err_unregister_handle:
>  	input_unregister_handle(&evdev->handle);
>   err_free_evdev:
>  	put_device(&evdev->dev);
> @@ -1442,7 +1435,7 @@ static void evdev_disconnect(struct input_handle *handle)
>  {
>  	struct evdev *evdev = handle->private;
>  
> -	device_del(&evdev->dev);
> +	cdev_device_del(&evdev->cdev, &evdev->dev);
>  	evdev_cleanup(evdev);
>  	input_free_minor(MINOR(evdev->dev.devt));
>  	input_unregister_handle(handle);
> diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
> index abd18f3..e38b84f 100644
> --- a/drivers/input/joydev.c
> +++ b/drivers/input/joydev.c
> @@ -729,8 +729,6 @@ static void joydev_cleanup(struct joydev *joydev)
>  	joydev_mark_dead(joydev);
>  	joydev_hangup(joydev);
>  
> -	cdev_del(&joydev->cdev);
> -
>  	/* joydev is marked dead so no one else accesses joydev->open */
>  	if (joydev->open)
>  		input_close_device(handle);
> @@ -905,12 +903,8 @@ static int joydev_connect(struct input_handler *handler, struct input_dev *dev,
>  		goto err_free_joydev;
>  
>  	cdev_init(&joydev->cdev, &joydev_fops);
> -	joydev->cdev.kobj.parent = &joydev->dev.kobj;
> -	error = cdev_add(&joydev->cdev, joydev->dev.devt, 1);
> -	if (error)
> -		goto err_unregister_handle;
>  
> -	error = device_add(&joydev->dev);
> +	error = cdev_device_add(&joydev->cdev, &joydev->dev);
>  	if (error)
>  		goto err_cleanup_joydev;
>  
> @@ -918,7 +912,6 @@ static int joydev_connect(struct input_handler *handler, struct input_dev *dev,
>  
>   err_cleanup_joydev:
>  	joydev_cleanup(joydev);
> - err_unregister_handle:
>  	input_unregister_handle(&joydev->handle);
>   err_free_joydev:
>  	put_device(&joydev->dev);
> @@ -931,7 +924,7 @@ static void joydev_disconnect(struct input_handle *handle)
>  {
>  	struct joydev *joydev = handle->private;
>  
> -	device_del(&joydev->dev);
> +	cdev_device_del(&joydev->cdev, &joydev->dev);
>  	joydev_cleanup(joydev);
>  	input_free_minor(MINOR(joydev->dev.devt));
>  	input_unregister_handle(handle);
> diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
> index b604564..0e0ff84 100644
> --- a/drivers/input/mousedev.c
> +++ b/drivers/input/mousedev.c
> @@ -812,8 +812,6 @@ static void mousedev_cleanup(struct mousedev *mousedev)
>  	mousedev_mark_dead(mousedev);
>  	mousedev_hangup(mousedev);
>  
> -	cdev_del(&mousedev->cdev);
> -
>  	/* mousedev is marked dead so no one else accesses mousedev->open */
>  	if (mousedev->open)
>  		input_close_device(handle);
> @@ -901,12 +899,8 @@ static struct mousedev *mousedev_create(struct input_dev *dev,
>  	}
>  
>  	cdev_init(&mousedev->cdev, &mousedev_fops);
> -	mousedev->cdev.kobj.parent = &mousedev->dev.kobj;
> -	error = cdev_add(&mousedev->cdev, mousedev->dev.devt, 1);
> -	if (error)
> -		goto err_unregister_handle;
>  
> -	error = device_add(&mousedev->dev);
> +	error = cdev_device_add(&mousedev->cdev, &mousedev->dev);
>  	if (error)
>  		goto err_cleanup_mousedev;
>  
> @@ -914,7 +908,6 @@ static struct mousedev *mousedev_create(struct input_dev *dev,
>  
>   err_cleanup_mousedev:
>  	mousedev_cleanup(mousedev);
> - err_unregister_handle:
>  	if (!mixdev)
>  		input_unregister_handle(&mousedev->handle);
>   err_free_mousedev:
> @@ -927,7 +920,7 @@ static struct mousedev *mousedev_create(struct input_dev *dev,
>  
>  static void mousedev_destroy(struct mousedev *mousedev)
>  {
> -	device_del(&mousedev->dev);
> +	cdev_device_del(&mousedev->cdev, &mousedev->dev);
>  	mousedev_cleanup(mousedev);
>  	input_free_minor(MINOR(mousedev->dev.devt));
>  	if (mousedev != mousedev_mix)
> -- 
> 2.1.4
> 

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
