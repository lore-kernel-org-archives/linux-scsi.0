From: Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 03/14] input: utilize new device_add_cdev
 helper function
Date: Thu, 23 Feb 2017 00:37:03 -0800
Message-ID: <20170223083703.GF18639@dtor-ws>
References: <1487653253-11497-1-git-send-email-logang@deltatee.com>
 <1487653253-11497-4-git-send-email-logang@deltatee.com>
Reply-To: rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <rtc-linux+bncBDP6N55ZUYDRBM56XLCQKGQEX7KWXQY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Content-Disposition: inline
In-Reply-To: <1487653253-11497-4-git-send-email-logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Post: <https://groups.google.com/group/rtc-linux/post>, <mailto:rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:rtc-linux+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/rtc-linux
List-Subscribe: <https://groups.google.com/group/rtc-linux/subscribe>, <mailto:rtc-linux+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+712029733259+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/rtc-linux/subscribe>
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Sajjan Vikas C <vikas.cha.sajjan-ZPxbGqLxI0U@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Alexandre Courbot <gnurou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hartmut Knaack <knaac>
List-Id: linux-scsi@vger.kernel.org

On Mon, Feb 20, 2017 at 10:00:42PM -0700, Logan Gunthorpe wrote:
> Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
> ---

Please add some more verbage, otherwise

Acked-by: Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


>  drivers/input/evdev.c    | 3 +--
>  drivers/input/joydev.c   | 3 +--
>  drivers/input/mousedev.c | 3 +--
>  3 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> index e9ae3d5..a3407ea 100644
> --- a/drivers/input/evdev.c
> +++ b/drivers/input/evdev.c
> @@ -1416,8 +1416,7 @@ static int evdev_connect(struct input_handler *handler, struct input_dev *dev,
>  		goto err_free_evdev;
>  
>  	cdev_init(&evdev->cdev, &evdev_fops);
> -	evdev->cdev.kobj.parent = &evdev->dev.kobj;
> -	error = cdev_add(&evdev->cdev, evdev->dev.devt, 1);
> +	error = device_add_cdev(&evdev->dev, &evdev->cdev);
>  	if (error)
>  		goto err_unregister_handle;
>  
> diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
> index abd18f3..012e06f 100644
> --- a/drivers/input/joydev.c
> +++ b/drivers/input/joydev.c
> @@ -905,8 +905,7 @@ static int joydev_connect(struct input_handler *handler, struct input_dev *dev,
>  		goto err_free_joydev;
>  
>  	cdev_init(&joydev->cdev, &joydev_fops);
> -	joydev->cdev.kobj.parent = &joydev->dev.kobj;
> -	error = cdev_add(&joydev->cdev, joydev->dev.devt, 1);
> +	error = device_add_cdev(&joydev->dev, &joydev->cdev);
>  	if (error)
>  		goto err_unregister_handle;
>  
> diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
> index b604564..efd8666 100644
> --- a/drivers/input/mousedev.c
> +++ b/drivers/input/mousedev.c
> @@ -901,8 +901,7 @@ static struct mousedev *mousedev_create(struct input_dev *dev,
>  	}
>  
>  	cdev_init(&mousedev->cdev, &mousedev_fops);
> -	mousedev->cdev.kobj.parent = &mousedev->dev.kobj;
> -	error = cdev_add(&mousedev->cdev, mousedev->dev.devt, 1);
> +	error = device_add_cdev(&mousedev->dev, &mousedev->cdev);
>  	if (error)
>  		goto err_unregister_handle;
>  
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
