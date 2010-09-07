From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v2] scsi_debug: Convert to use root_device_register()
	and root_device_unregister()
Date: Mon, 06 Sep 2010 17:20:53 -0700
Message-ID: <1283818853.556.253.camel@haakon2.linux-iscsi.org>
References: <1283817551-23380-1-git-send-email-nab@linux-iscsi.org>
	 <20100907001342.GB20882@core.coreip.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp103.sbc.mail.ac4.yahoo.com ([76.13.13.242]:24499 "HELO
	smtp103.sbc.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752929Ab0IGAbe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2010 20:31:34 -0400
In-Reply-To: <20100907001342.GB20882@core.coreip.homeip.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Douglas Gilbert <dgilbert@interlog.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Greg KH <greg@kroah.com>

On Mon, 2010-09-06 at 17:13 -0700, Dmitry Torokhov wrote:
> On Mon, Sep 06, 2010 at 04:59:11PM -0700, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Hi Dough and Co,
> > 
> > This patch updates the scsi_debug virtual LLD to use root_device_register()
> > and root_device_unregister() from include/linux/device.h instead of device_register()
> > and device_unregister() respectively within scsi_debug_init() and scsi_debug_exit()
> > This simply involved converting the static struct device pseudo_primary into a
> > pointer that is setup by the call to root_device_register().
> > 
> > This patch also contains the correct IS_ERR() conditional check of
> > root_device_register() from within scsi_debug_init().
> > 
> > Thanks to Richard Sharpe and Dmitry Torokhov for their help with this item.
> > 
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/scsi/scsi_debug.c |   27 +++++++++------------------
> >  1 files changed, 9 insertions(+), 18 deletions(-)
> > 
> > diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> > index b02bdc6..86d483e 100644
> > --- a/drivers/scsi/scsi_debug.c
> > +++ b/drivers/scsi/scsi_debug.c
> > @@ -3207,23 +3207,14 @@ static void do_remove_driverfs_files(void)
> >  	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_add_host);
> >  }
> >  
> > -static void pseudo_0_release(struct device *dev)
> > -{
> > -	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
> > -		printk(KERN_INFO "scsi_debug: pseudo_0_release() called\n");
> > -}
> > -
> > -static struct device pseudo_primary = {
> > -	.init_name	= "pseudo_0",
> > -	.release	= pseudo_0_release,
> > -};
> > +struct device *pseudo_primary;
> >  
> >  static int __init scsi_debug_init(void)
> >  {
> >  	unsigned long sz;
> >  	int host_to_add;
> >  	int k;
> > -	int ret;
> > +	int ret = 0;
> 
> Please drop this chunk, it is not needed and is dangerous WRT future
> changes to the file as I explained earlier.

As you wish..

Best,

--nab

