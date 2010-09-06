From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] scsi_debug: Convert to use root_device_register() and
	root_device_unregister()
Date: Mon, 06 Sep 2010 16:39:14 -0700
Message-ID: <1283816354.556.251.camel@haakon2.linux-iscsi.org>
References: <1283812340-21132-1-git-send-email-nab@linux-iscsi.org>
	 <20100906234119.GA20589@core.coreip.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp102.sbc.mail.ac4.yahoo.com ([76.13.13.241]:29169 "HELO
	smtp102.sbc.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752482Ab0IFXnQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2010 19:43:16 -0400
In-Reply-To: <20100906234119.GA20589@core.coreip.homeip.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Douglas Gilbert <dgilbert@interlog.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Greg KH <greg@kroah.com>

On Mon, 2010-09-06 at 16:41 -0700, Dmitry Torokhov wrote:
> On Mon, Sep 06, 2010 at 03:32:20PM -0700, Nicholas A. Bellinger wrote:
> >  static int __init scsi_debug_init(void)
> >  {
> >  	unsigned long sz;
> >  	int host_to_add;
> >  	int k;
> > -	int ret;
> > +	int ret = 0;
> >  
> 
> Please do not initialize error condition with success; when adding
> additional initialization it makes easy to miss assigning proper return
> value (as you seem to have) and return success in case of failure.

The reason this was added because my gcc (Debian 4.3.2-1.1) 4.3.2
complained about this being possibily uninitialized..

> 
> >  	switch (scsi_debug_sector_size) {
> >  	case  512:
> > @@ -3352,10 +3343,9 @@ static int __init scsi_debug_init(void)
> >  			map_region(0, 2);
> >  	}
> >  
> > -	ret = device_register(&pseudo_primary);
> > -	if (ret < 0) {
> > -		printk(KERN_WARNING "scsi_debug: device_register error: %d\n",
> > -			ret);
> > +	pseudo_primary = root_device_register("pseudo_0");
> > +	if (!(pseudo_primary)) {
> 
> root_device_register() returns ERR_PTR-encoded error codes, you should
> do:
> 
> 	if (IS_ERR(pseudo_primary)) {
> 		printk(KERN_WARNING "scsi_debug: root_device_register() error\n");
> 		ret = PTR_ERR(pseudo_primary);
> 		goto free_vm;
> 	}
> 
> Same goes for your other patch.

<nod> Updating that now.

Thanks,

--nab


