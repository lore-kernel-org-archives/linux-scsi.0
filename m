From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] scsi_debug: Convert to use root_device_register() and
 root_device_unregister()
Date: Mon, 6 Sep 2010 17:12:18 -0700
Message-ID: <20100907001218.GA20882@core.coreip.homeip.net>
References: <1283812340-21132-1-git-send-email-nab@linux-iscsi.org>
 <20100906234119.GA20589@core.coreip.homeip.net>
 <1283816354.556.251.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54923 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab0IGAMW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2010 20:12:22 -0400
Content-Disposition: inline
In-Reply-To: <1283816354.556.251.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Douglas Gilbert <dgilbert@interlog.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Greg KH <greg@kroah.com>

On Mon, Sep 06, 2010 at 04:39:14PM -0700, Nicholas A. Bellinger wrote:
> On Mon, 2010-09-06 at 16:41 -0700, Dmitry Torokhov wrote:
> > On Mon, Sep 06, 2010 at 03:32:20PM -0700, Nicholas A. Bellinger wrote:
> > >  static int __init scsi_debug_init(void)
> > >  {
> > >  	unsigned long sz;
> > >  	int host_to_add;
> > >  	int k;
> > > -	int ret;
> > > +	int ret = 0;
> > >  
> > 
> > Please do not initialize error condition with success; when adding
> > additional initialization it makes easy to miss assigning proper return
> > value (as you seem to have) and return success in case of failure.
> 
> The reason this was added because my gcc (Debian 4.3.2-1.1) 4.3.2
> complained about this being possibily uninitialized..
> 

And rightly so - you did not assign a value to it when handling
root_device_register() failure. Compiler warnings are generally there
for a reason, not just a nuisance that should be shut off without a
second thought.

-- 
Dmitry
