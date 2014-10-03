From: Ewan Milne <emilne@redhat.com>
Subject: RE: [PATCH 04/24] scsi: introduce sdev_prefix_printk()
Date: Fri, 03 Oct 2014 12:31:20 -0400
Message-ID: <1412353880.5241.136.camel@localhost.localdomain>
References: <1412144580-72880-1-git-send-email-hare@suse.de>
	 <1412144580-72880-5-git-send-email-hare@suse.de>
	 <94D0CD8314A33A4D9D801C0FE68B402958CCAB53@G4W3202.americas.hpqcorp.net>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753845AbaJCQbu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Oct 2014 12:31:50 -0400
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958CCAB53@G4W3202.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 2014-10-02 at 18:37 +0000, Elliott, Robert (Server Storage)
wrote:
> > -----Original Message-----
> > From: Hannes Reinecke [mailto:hare@suse.de]
> ...
> > diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> > index 4c3ab83..c01dc89 100644
> > --- a/drivers/scsi/sd.h
> > +++ b/drivers/scsi/sd.h
> > @@ -103,9 +103,10 @@ static inline struct scsi_disk *scsi_disk(struct gendisk
> > *disk)
> > 
> >  #define sd_printk(prefix, sdsk, fmt, a...)				\
> >          (sdsk)->disk ?							\
> > -	sdev_printk(prefix, (sdsk)->device, "[%s] " fmt,		\
> > -		    (sdsk)->disk->disk_name, ##a) :			\
> > -	sdev_printk(prefix, (sdsk)->device, fmt, ##a)
> > +	      sdev_prefix_printk(prefix, (sdsk)->device,		\
> > +				 (sdsk)->disk->disk_name, fmt, ##a) :	\
> > +	      sdev_prefix_printk(prefix, (sdsk)->device,		\
> > +				 NULL, fmt, ##a)
> > 
> >  #define sd_first_printk(prefix, sdsk, fmt, a...)			\
> >  	do {								\
> ...
> > diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> > index 27ecee7..0b18a09 100644
> > --- a/include/scsi/scsi_device.h
> > +++ b/include/scsi/scsi_device.h
> > @@ -244,6 +244,15 @@ struct scsi_dh_data {
> >  #define sdev_dbg(sdev, fmt, a...) \
> >  	dev_dbg(&(sdev)->sdev_gendev, fmt, ##a)
> > 
> > +/*
> > + * like scmd_printk, but the device name is passed in
> > + * as a string pointer
> > + */
> > +#define sdev_prefix_printk(l, sdev, p, fmt, a...)			\
> > +	(p) ?								\
> > +	sdev_printk(l, sdev, "[%s] " fmt, p, ##a) :			\
> > +	sdev_printk(l, sdev, fmt, ##a)
> > +
> >  #define scmd_printk(prefix, scmd, fmt, a...)				\
> >          (scmd)->request->rq_disk ?					\
> >  	sdev_printk(prefix, (scmd)->device, "[%s] " fmt,		\
> > --
> > 1.8.5.2
> 
> This triggers lots of compiler warnings with gcc 4.4.7 like:
> 
> drivers/scsi/sd.c: In function 'sd_open':
> drivers/scsi/sd.c:1179: warning: reading through null pointer (argument 4)
> drivers/scsi/sd.c:1179: warning: format '%s' expects type 'char *', but argument 4 has type 'void *'
> 
> 
> That is from:
>         SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_open\n"));
> 
> Since:
> #define NULL ((void *)0)
> 
> gcc probably doesn't realize the (p)? prevents the NULL (a void *) 
> from being passed to sdev_printk.
> 
> Passing "" rather than NULL eliminates the compiler warnings.

It eliminates the warnings, but unfortunately we then get log messages
that look like:

Oct  3 11:30:08 rhel-storage-01 kernel: sd 10:0:0:0: [sde] (null)FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE

                                                           ^^^^^^

Changing it to (char *)NULL, like this:

#define sd_printk(prefix, sdsk, fmt, a...)                              \
        (sdsk)->disk ?                                                  \
              sdev_prefix_printk(prefix, (sdsk)->device,                \
                                 (sdsk)->disk->disk_name, fmt, ##a) :   \
              sdev_prefix_printk(prefix, (sdsk)->device,                \
                                 (char *)NULL, fmt, ##a)

doesn't work either.  The compiler gives an error:

drivers/scsi/sd.c: In function 'sd_open':
drivers/scsi/sd.c:1158:2: error: reading through null pointer (argument 4) [-Werror=format=]
  SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_open\n"));
  ^

-Ewan

> 
> There should probably be a () around p in the sdev_printk call, too.
> 
> 
> ---
> Rob Elliott    HP Server Storage
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


