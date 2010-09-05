From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC 22/22] tcm_loop: Add multi-fabric Linux/SCSI LLD fabric
	module
Date: Sun, 05 Sep 2010 14:51:19 -0700
Message-ID: <1283723479.556.135.camel@haakon2.linux-iscsi.org>
References: <1283160203-6981-1-git-send-email-nab@linux-iscsi.org>
	 <20100905203006.GD18411@core.coreip.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100905203006.GD18411@core.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2010-09-05 at 13:30 -0700, Dmitry Torokhov wrote:
> On Mon, Aug 30, 2010 at 02:23:23AM -0700, Nicholas A. Bellinger wrote:
> > +
> > +static void tcm_loop_primary_release(struct device *dev)
> > +{
> > +	return;
> > +}
> > +
> > +static struct device tcm_loop_primary = {
> > +	.init_name		= "tcm_loop_0",
> > +	.release		= tcm_loop_primary_release,
> > +};
> > +
> 
> No, you can not have statically allocated devices and dummy release
> functions.
> 

Last time I checked this is still what mainline
drivers/scsi/scsi_debug.c is doing for struct device pseudo_primary:

static void pseudo_0_release(struct device *dev)
{
        if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
                printk(KERN_INFO "scsi_debug: pseudo_0_release() called\n");
}

static struct device pseudo_primary = {
        .init_name      = "pseudo_0",
        .release        = pseudo_0_release,
};

so for these type of things in TCM_Loop I tend to follow what scsi_debug does,
 so I don't exactly see a issue here atm.  Anybody else have comments..?

Best,

--nab
