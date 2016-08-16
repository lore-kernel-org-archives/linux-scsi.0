From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] be2iscsi: Use a more current logging style
Date: Tue, 16 Aug 2016 03:27:05 -0700
Message-ID: <1471343225.4075.153.camel@perches.com>
References: <1471191843.4075.39.camel@perches.com>
	 <e49903a4248d8f49e129ce795dd06fc4f2cd6331.1471200669.git.joe@perches.com>
	 <b1256e4c70a33774e86263277a72c3a2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b1256e4c70a33774e86263277a72c3a2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>, Christophe JAILLET <christophe.jaillet@wanadoo.fr>, Jayamohan Kallickal <jayamohan.kallickal@avagotech.com>, Ketan Mukadam <ketan.mukadam@avagotech.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2016-08-16 at 11:32 +0530, Jitendra Bhivare wrote:
> Thanks Joe for taking this up. It has been pending for long time from our
> side.

Thanks, not a problem, it took ~10 minutes.

There was a bit of an issue about your reply though.

First there was ~50 k of quoted stuff without any content

> [ hundreds and hundreds of quoted lines ]

and then this happened:

> > diff --git a/drivers/scsi/be2iscsi/be_main.h
> b/drivers/scsi/be2iscsi/be_main.h
> > 
> > index aa9c682..7cce6e3 100644
> > --- a/drivers/scsi/be2iscsi/be_main.h
> > +++ b/drivers/scsi/be2iscsi/be_main.h
> > @@ -1081,15 +1081,19 @@ struct hwi_context_memory {
> >  #define BEISCSI_LOG_CONFIG	0x0020	/* CONFIG Code Path */
> >  #define BEISCSI_LOG_ISCSI	0x0040	/* SCSI/iSCSI Protocol related
> Logs */
> > 
> > 
> > -#define __beiscsi_log(phba, level, fmt, ...)				\
> > -	shost_printk(level, phba->shost, fmt, ##__VA_ARGS__)
> > -
> > -#define beiscsi_log(phba, level, mask, prefix, fmt, ...)		\
> > +#define beiscsi_printk(level, phba, mask, fmt, ...)			\
> >  do {									\
> > -	uint32_t log_value = phba->attr_log_enable;			\
> > -	if (((mask) & log_value) || (level[1] <= '3'))			\
> > -		__beiscsi_log(phba, level, prefix "_%d: " fmt,		\
> > -			      __LINE__, ##__VA_ARGS__);			\
> > +	if ((mask) & (phba)->attr_log_enable)				\
> > +		shost_printk(level, phba->shost,			\
> [JB] PCI dev_printk would be more useful with SCSI host_no included by
> default in the message.

This is a good note that seems simple enough, but I almost
missed this.

Given the reply at the top and the _very_ long uncommented
quoted block, I just about assumed it was a useless block
quote that you didn't bother to trim.

Please make it easier to find your replies and notes by
deleting irrelevant quoted stuff.

Also, I think I misread the code.

The original code is <= '3' i.e.: show all KERN_ERR.
That is not correct in the new code.

I don't know the code well and don't have a test bed with
the hardware.

Is it possible for a beiscsi_<level> message to be called
before phba->pcidev is set to a valid value in
beiscsi_hba_alloc?   It appears the code is careful to
only use dev_<level> logging calls before probe.
