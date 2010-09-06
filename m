From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC 22/22] tcm_loop: Add multi-fabric Linux/SCSI LLD fabric
	module
Date: Sun, 05 Sep 2010 22:21:20 -0700
Message-ID: <1283750480.556.196.camel@haakon2.linux-iscsi.org>
References: <1283160203-6981-1-git-send-email-nab@linux-iscsi.org>
	 <20100905203006.GD18411@core.coreip.homeip.net>
	 <1283723479.556.135.camel@haakon2.linux-iscsi.org>
	 <20100906050816.GD17212@core.coreip.homeip.net>
	 <20100906051703.GA2891@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:38435 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750858Ab0IFFZS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2010 01:25:18 -0400
In-Reply-To: <20100906051703.GA2891@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <gregkh@suse.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>

On Sun, 2010-09-05 at 22:17 -0700, Greg KH wrote:
> On Sun, Sep 05, 2010 at 10:08:16PM -0700, Dmitry Torokhov wrote:
> > On Sun, Sep 05, 2010 at 02:51:19PM -0700, Nicholas A. Bellinger wrote:
> > > On Sun, 2010-09-05 at 13:30 -0700, Dmitry Torokhov wrote:
> > > > On Mon, Aug 30, 2010 at 02:23:23AM -0700, Nicholas A. Bellinger wrote:
> > > > > +
> > > > > +static void tcm_loop_primary_release(struct device *dev)
> > > > > +{
> > > > > +	return;
> > > > > +}
> > > > > +
> > > > > +static struct device tcm_loop_primary = {
> > > > > +	.init_name		= "tcm_loop_0",
> > > > > +	.release		= tcm_loop_primary_release,
> > > > > +};
> > > > > +
> > > > 
> > > > No, you can not have statically allocated devices and dummy release
> > > > functions.
> > > > 
> > > 
> > > Last time I checked this is still what mainline
> > > drivers/scsi/scsi_debug.c is doing for struct device pseudo_primary:
> > > 
> > > static void pseudo_0_release(struct device *dev)
> > > {
> > >         if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
> > >                 printk(KERN_INFO "scsi_debug: pseudo_0_release() called\n");
> > > }
> > > 
> > > static struct device pseudo_primary = {
> > >         .init_name      = "pseudo_0",
> > >         .release        = pseudo_0_release,
> > > };
> > > 
> > > so for these type of things in TCM_Loop I tend to follow what scsi_debug does,
> > >  so I don't exactly see a issue here atm.  Anybody else have comments..?
> > 
> > The kobject embedded in the device structure is refcounted and it's
> > lifetime may be different from lifetime of your module. If somebody
> > happen to hold reference to the driver while your module is being
> > unloaded bad things will happen.
> > 
> > I am sure Greg has something on this topic ready for cut-and-paste.
> 
> Documentation/kobject.txt :)

I still don't get it..?  Does this mean that scsi_debug and TCM_Loop are
currently broken wrt to this item or not..?

Best,

--nab


