From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: fix null pointer dereference in sd_revalidate_disk
Date: Mon, 08 Apr 2013 09:39:28 -0700
Message-ID: <1365439168.8689.10.camel@dabdike>
References: <1362663400-9517-1-git-send-email-oskar.andero@sonymobile.com>
	 <20130408114251.GK2481@caracas.corpusers.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130408114251.GK2481@caracas.corpusers.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Oskar Andero <oskar.andero@sonymobile.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Lekanovic, Radovan" <Radovan.Lekanovic@sonymobile.com>, "Itou, Syunsuke X" <Syunsuke.X.Itou@sonymobile.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2013-04-08 at 13:42 +0200, Oskar Andero wrote:
> On 14:36 Thu 07 Mar     , oskar.andero@sonymobile.com wrote:
> > From: "syunsuke.x.itou" <syunsuke.x.itou@sonymobile.com>
> > 
> > By repeatadly connecting/disconnecting a USB masstorage device
> > a null pointer dereference can be provoked. This is caused by
> > sd_revalidate_disk() assuming sdkp to be a valid pointer. This
> > patch adds a null pointer check.
> > 
> > Reviewed-by: Radovan Lekanovic <radovan.lekanovic@sonymobile.com>
> > Signed-off-by: syunsuke.x.itou <syunsuke.x.itou@sonymobile.com>
> > Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
> > ---
> >  drivers/scsi/sd.c |    7 ++++++-
> >  1 files changed, 6 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> > index 7992635..49849ce 100644
> > --- a/drivers/scsi/sd.c
> > +++ b/drivers/scsi/sd.c
> > @@ -1,6 +1,7 @@
> >  /*
> >   *      sd.c Copyright (C) 1992 Drew Eckhardt
> >   *           Copyright (C) 1993, 1994, 1995, 1999 Eric Youngdale
> > + *           Copyright (C) 2013 Sony Mobile Communications AB.
> >   *
> >   *      Linux scsi disk driver
> >   *              Initial versions: Drew Eckhardt
> > @@ -2653,10 +2654,14 @@ static int sd_try_extended_inquiry(struct scsi_device *sdp)
> >  static int sd_revalidate_disk(struct gendisk *disk)
> >  {
> >  	struct scsi_disk *sdkp = scsi_disk(disk);
> > -	struct scsi_device *sdp = sdkp->device;
> > +	struct scsi_device *sdp;
> >  	unsigned char *buffer;
> >  	unsigned flush = 0;
> >  
> > +	if (!sdkp)
> > +		return -ENODEV;
> > +	sdp = sdkp->device;
> > +
> >  	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp,
> >  				      "sd_revalidate_disk\n"));
> >  
> > -- 
> > 1.7.8.6
> > 
> 
> Ping. Any input on the patch above?

For us to give input, the original patch would have to have been sent to
linux-scsi ...

However, I think it's not correct because it fixes a symptom, not the
cause.  If sdkp can be null, that means something failed to get the
reference that's required.  What's the stack trace?

James
