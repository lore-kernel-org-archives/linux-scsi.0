From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v3 06/16] tpm-chip: utilize new
 cdev_device_add helper function
Date: Tue, 7 Mar 2017 06:31:38 +0100
Message-ID: <20170307053138.GA7665@kroah.com>
References: <1488783873-2614-1-git-send-email-logang@deltatee.com>
 <1488783873-2614-7-git-send-email-logang@deltatee.com>
 <20170306210426.qeftgujergryutie@intel.com>
Reply-To: rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <rtc-linux+bncBCUJ7YGL3QFBBQ4L7HCQKGQEOBUHADQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Content-Disposition: inline
In-Reply-To: <20170306210426.qeftgujergryutie-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Post: <https://groups.google.com/group/rtc-linux/post>, <mailto:rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:rtc-linux+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/rtc-linux
List-Subscribe: <https://groups.google.com/group/rtc-linux/subscribe>, <mailto:rtc-linux+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+712029733259+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/rtc-linux/subscribe>
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Sajjan Vikas C <vikas.cha.sajjan-ZPxbGqLxI0U@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Alexandre Courbot <gnurou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hartmut Knaack <knaack.h-Mmb7MZpHnFY@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>Pe
List-Id: linux-scsi@vger.kernel.org

On Mon, Mar 06, 2017 at 11:04:26PM +0200, Jarkko Sakkinen wrote:
> On Mon, Mar 06, 2017 at 12:04:22AM -0700, Logan Gunthorpe wrote:
> > Replace the open coded registration of the cdev and dev with the
> > new device_add_cdev() helper. The helper replaces a common pattern by
> > taking the proper reference against the parent device and adding both
> > the cdev and the device.
> > 
> > Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
> > Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > ---
> >  drivers/char/tpm/tpm-chip.c | 19 +++----------------
> >  1 file changed, 3 insertions(+), 16 deletions(-)
> > 
> > diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> > index c406343..935f0e9 100644
> > --- a/drivers/char/tpm/tpm-chip.c
> > +++ b/drivers/char/tpm/tpm-chip.c
> > @@ -187,7 +187,6 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
> >  
> >  	cdev_init(&chip->cdev, &tpm_fops);
> >  	chip->cdev.owner = THIS_MODULE;
> > -	chip->cdev.kobj.parent = &chip->dev.kobj;
> >  
> >  	return chip;
> >  
> > @@ -230,27 +229,16 @@ static int tpm_add_char_device(struct tpm_chip *chip)
> >  {
> >  	int rc;
> >  
> > -	rc = cdev_add(&chip->cdev, chip->dev.devt, 1);
> > +	rc = cdev_device_add(&chip->cdev, &chip->dev);
> >  	if (rc) {
> >  		dev_err(&chip->dev,
> > -			"unable to cdev_add() %s, major %d, minor %d, err=%d\n",
> > +			"unable to cdev_device_add() %s, major %d, minor %d, err=%d\n",
> >  			dev_name(&chip->dev), MAJOR(chip->dev.devt),
> >  			MINOR(chip->dev.devt), rc);
> >  
> >  		return rc;
> >  	}
> >  
> > -	rc = device_add(&chip->dev);
> > -	if (rc) {
> > -		dev_err(&chip->dev,
> > -			"unable to device_register() %s, major %d, minor %d, err=%d\n",
> > -			dev_name(&chip->dev), MAJOR(chip->dev.devt),
> > -			MINOR(chip->dev.devt), rc);
> > -
> > -		cdev_del(&chip->cdev);
> > -		return rc;
> > -	}
> > -
> >  	/* Make the chip available. */
> >  	mutex_lock(&idr_lock);
> >  	idr_replace(&dev_nums_idr, chip, chip->dev_num);
> > @@ -261,8 +249,7 @@ static int tpm_add_char_device(struct tpm_chip *chip)
> >  
> >  static void tpm_del_char_device(struct tpm_chip *chip)
> >  {
> > -	cdev_del(&chip->cdev);
> > -	device_del(&chip->dev);
> > +	cdev_device_del(&chip->cdev, &chip->dev);
> >  
> >  	/* Make the chip unavailable. */
> >  	mutex_lock(&idr_lock);
> > -- 
> > 2.1.4
> > 
> 
> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> 
> I cannot test this at this point as security tree does not include
> the commit that is dependent on this. I'm also wondering if this
> commit is even going through my tree to upstream?

I can take it all at once through my tree.

thanks,

greg k-h

-- 
You received this message because you are subscribed to "rtc-linux".
Membership options at http://groups.google.com/group/rtc-linux .
Please read http://groups.google.com/group/rtc-linux/web/checklist
before submitting a driver.
--- 
You received this message because you are subscribed to the Google Groups "rtc-linux" group.
To unsubscribe from this group and stop receiving emails from it, send an email to rtc-linux+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit https://groups.google.com/d/optout.
