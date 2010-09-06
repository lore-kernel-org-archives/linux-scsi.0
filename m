From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [RFC 22/22] tcm_loop: Add multi-fabric Linux/SCSI LLD fabric
 module
Date: Mon, 6 Sep 2010 12:44:46 -0700
Message-ID: <20100906194446.GA31384@core.coreip.homeip.net>
References: <1283160203-6981-1-git-send-email-nab@linux-iscsi.org>
 <20100905203006.GD18411@core.coreip.homeip.net>
 <1283723479.556.135.camel@haakon2.linux-iscsi.org>
 <20100906050816.GD17212@core.coreip.homeip.net>
 <20100906051703.GA2891@suse.de>
 <1283750480.556.196.camel@haakon2.linux-iscsi.org>
 <20100906053845.GG17212@core.coreip.homeip.net>
 <1283752861.556.200.camel@haakon2.linux-iscsi.org>
 <20100906062625.GI17212@core.coreip.homeip.net>
 <AANLkTimhHt78GFbxxjy1tosmebMVg-vKCNoJuqVa+iLH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:52190 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab0IFTow (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2010 15:44:52 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTimhHt78GFbxxjy1tosmebMVg-vKCNoJuqVa+iLH@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Richard Sharpe <realrichardsharpe@gmail.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Greg KH <gregkh@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>

On Mon, Sep 06, 2010 at 07:48:20AM -0700, Richard Sharpe wrote:
> On Sun, Sep 5, 2010 at 11:26 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> >
> > I think what you need is root_device_create() which will allocate a
> > device structure and assign ->release() that is implemented outside of
> > your module. This way your module may be unloaded even if there are
> > outstanding references to tcm_loop_primary device.
> 
> I am embarrassed to admit that scst_local (or whatever its new name
> will be) probably has the same fault, as it too was based on
> scsi_debug ...
> 
> However, I did a search of the 2.6.24.1 source tree and could not find
> any instances of root_device_create() being called nor defined. I just
> double and triple checked the spelling.
> 
> Ahhh, I see why. A slightly different search suggests that it is
> root_device_register(const char *name).
> 
> From include/linux/device.h:
> 
> static inline struct device *root_device_register(const char *name)
> {
> 	return __root_device_register(name, THIS_MODULE);
> }
> 
> Was that the one you were thinking of?
> 

Yes, that is the one. I'll blame Greg for inconsistent naming that
caused this error :) - we usually have xxx_register() for objects that
we already have on hand and xxx_create() (as in device_create) when we
want the object to be allocated for us.

Thanks.

-- 
Dmitry
