From: Vasiliy Kulikov <segooon@gmail.com>
Subject: Re: [PATCH 10/14] scsi: osd: fix device_register() error handling
Date: Sun, 19 Sep 2010 18:39:50 +0400
Message-ID: <20100919143948.GA4866__23390.903013251$1284907233$gmane$org@albatros>
References: <1284900907-24621-1-git-send-email-segooon@gmail.com>
 <20100919142653.GF6236@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47711 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab0ISOjz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Sep 2010 10:39:55 -0400
Content-Disposition: inline
In-Reply-To: <20100919142653.GF6236@bicker>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>, kernel-janitors@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@panasas.com>, "James E.J. Bottomley" <James.Bottomley@su>

On Sun, Sep 19, 2010 at 16:26 +0200, Dan Carpenter wrote:
> On Sun, Sep 19, 2010 at 04:55:07PM +0400, Vasiliy Kulikov wrote:
> > If device_register() fails then call put_device().
> > See comment to device_register.
> > 
> > Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> > ---
...
> 
> Hm...  So if device_register() fails then we should always call
> device_put()?  It seems like a lot of existing code does that but I
> hadn't realized until now that that is how it works.

Yes, almost ALL code using device_register() is buggy :-(

> Why can't the device_put() just be added inside the device_register() so
> the unwinding works automatically?

Because some code already calls device_put().  Also it is documented like
not putting the device.  However, I'm in doubt why it is written this way.

> Also if someone add some more stuff to the end of this function, will
> the device_unregister() followed by a device_put() cause problems if we
> unwind like this?

Yes, device_register() gets one reference, you should put in in both cases -
when device_register() failed and when it succeeded, but only one time.
device_unregister() puts it, so it is "double putting".

> +err_free_something:
> +	kfree(foo);
> +	device_unregister(&oud->class_dev);
> > +err_put_device:
> > +	put_device(&oud->class_dev);
> >  err_put_cdev:
> >  	cdev_del(&oud->cdev);
> >  err_put_disk:
> 
> If that's the case then the put_device() should be called infront of the
> goto.

As it is the last call that may fail, it is redundant.  Or you mean for future,
if someone adds more code after device_register()?

 
Thanks,
-- 
Vasiliy
