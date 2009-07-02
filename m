From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: Re: [PATCH] cciss: Ignore stale commands after reboot
Date: Thu, 2 Jul 2009 19:58:57 +0000
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77886948B9516C@GVW0547EXC.americas.hpqcorp.net>
References: <20090702125030.d9967a7f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:35439 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbZGBT70 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jul 2009 15:59:26 -0400
In-Reply-To: <20090702125030.d9967a7f.akpm@linux-foundation.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

 

> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org] 
> Sent: Thursday, July 02, 2009 2:51 PM
> To: Miller, Mike (OS Dev)
> Subject: Fw: Re: [PATCH] cciss: Ignore stale commands after reboot
> 
> 
> oh, Jens already did it.
> 
> Begin forwarded message:
> 
> Date: Thu, 2 Jul 2009 21:00:49 +0200
> From: Jens Axboe <jens.axboe@oracle.com>
> To: Hannes Reinecke <hare@suse.de>
> Cc: scameron@beardog.cca.cpqcorp.net, 
> linux-kernel@vger.kernel.org, mikem@beardog.cca.cpqcorp.net
> Subject: Re: [PATCH] cciss: Ignore stale commands after reboot
> 
> 
> On Thu, Jul 02 2009, Hannes Reinecke wrote:
> > 
> > When doing an unexpected shutdown like kexec the cciss 
> firmware might 
> > still have some commands in flight, which it is trying to complete.
> > The driver is doing it's best on resetting the HBA, but 
> sadly there's 
> > a firmware issue causing the firmware _not_ to abort or drop old 
> > commands.
> > So the firmware will send us commands which we haven't 
> accounted for, 
> > causing the driver to panic.
> > 
> > With this patch we're just ignoring these commands as there 
> is nothing 
> > we could be doing with them anyway.
> 
> Looks good to me. Mike, Stephen?

Sorry I haven't seen this before. The beardog addresses are no longer valid. We moved into a dungeon and into a new domain. The good folks in IT have yet to assign another IP address/domain name or an MX record for the mail servers. I hope that by next week that will be corrected. Until then all Steve and I have to use is some form of OutHouse mail client.

Acked-by: Mike Miller <mike.miller@hp.com>

> 
> > 
> > Signed-off-by: Hannes Reinecke <hare@suse.de>
> > ---
> >  drivers/block/cciss.c     |   15 +++++++++++++--
> >  drivers/block/cciss_cmd.h |    1 +
> >  2 files changed, 14 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c index 
> > c7a527c..65a0655 100644
> > --- a/drivers/block/cciss.c
> > +++ b/drivers/block/cciss.c
> > @@ -226,8 +226,18 @@ static inline void addQ(struct 
> hlist_head *list, 
> > CommandList_struct *c)
> >  
> >  static inline void removeQ(CommandList_struct *c)  {
> > -	if (WARN_ON(hlist_unhashed(&c->list)))
> > +	/*
> > +	 * After kexec/dump some commands might still
> > +	 * be in flight, which the firmware will try
> > +	 * to complete. Resetting the firmware doesn't work
> > +	 * with old fw revisions, so we have to mark
> > +	 * them off as 'stale' to prevent the driver from
> > +	 * falling over.
> > +	 */
> > +	if (WARN_ON(hlist_unhashed(&c->list))) {
> > +		c->cmd_type = CMD_MSG_STALE;
> >  		return;
> > +	}
> >  
> >  	hlist_del_init(&c->list);
> >  }
> > @@ -4246,7 +4256,8 @@ static void fail_all_cmds(unsigned long ctlr)
> >  	while (!hlist_empty(&h->cmpQ)) {
> >  		c = hlist_entry(h->cmpQ.first, 
> CommandList_struct, list);
> >  		removeQ(c);
> > -		c->err_info->CommandStatus = CMD_HARDWARE_ERR;
> > +		if (c->cmd_type != CMD_MSG_STALE)
> > +			c->err_info->CommandStatus = CMD_HARDWARE_ERR;
> >  		if (c->cmd_type == CMD_RWREQ) {
> >  			complete_command(h, c, 0);
> >  		} else if (c->cmd_type == CMD_IOCTL_PEND) diff --git 
> > a/drivers/block/cciss_cmd.h b/drivers/block/cciss_cmd.h index 
> > cd665b0..dbaed1e 100644
> > --- a/drivers/block/cciss_cmd.h
> > +++ b/drivers/block/cciss_cmd.h
> > @@ -274,6 +274,7 @@ typedef struct _ErrorInfo_struct {
> >  #define CMD_SCSI	0x03
> >  #define CMD_MSG_DONE	0x04
> >  #define CMD_MSG_TIMEOUT 0x05
> > +#define CMD_MSG_STALE	0xff
> >  
> >  /* This structure needs to be divisible by 8 for new
> >   * indexing method.
> > --
> > 1.5.3.2
> > 
> 
> -- 
> Jens Axboe
> 
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 