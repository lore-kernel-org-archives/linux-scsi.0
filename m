From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Fri, 22 Oct 2010 11:54:37 -0700
Message-ID: <20101022185437.GA9103@kroah.com>
References: <20101009212047.GB27180@kroah.com>
 <4CB36592.6060909@vlnb.net>
 <20101011213235.GA11489@kroah.com>
 <4CB4AEB9.30501@vlnb.net>
 <20101012190345.GA25737@kroah.com>
 <4CB75E81.7000208@vlnb.net>
 <20101014200413.GA30831@kroah.com>
 <4CC1CA4D.1090609@vlnb.net>
 <20101022175624.GA13640@kroah.com>
 <4CC1DAA2.7030602@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:33891 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759175Ab0JVSzw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Oct 2010 14:55:52 -0400
Content-Disposition: inline
In-Reply-To: <4CC1DAA2.7030602@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>, Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>

On Fri, Oct 22, 2010 at 10:40:34PM +0400, Vladislav Bolkhovitin wrote:
> Greg KH, on 10/22/2010 09:56 PM wrote:
> > On Fri, Oct 22, 2010 at 09:30:53PM +0400, Vladislav Bolkhovitin wrote:
> >> +	unsigned int tgt_kobj_initialized:1;
> > 
> > It's the middle of the merge window, and I'm about to go on vacation, so
> > I didn't read this patch after this line.
> > 
> > It's obvious that this patch is wrong, you shouldn't need to worry about
> > this.  And even if you did, you don't need this flag.
> > 
> > Why are you trying to do something that no one else needs?  Why make
> > things harder than they have to be.
> 
> I tried to explain that to you in http://lkml.org/lkml/2010/10/14/291
> and mentioned there the need to create this flag to track
> half-initialized kobjects. You agreed
> (http://lkml.org/lkml/2010/10/14/299) that don't return half-initialized
> objects is a regular kernel practice, but then requested to strictly
> bound the larger object freeing to its kobject release(), which means
> that all SYSFS creating functions now have to return half-initialized
> SYSFS hierarchy in case of any error. Hence the flag to track it.

I agreed that you needed to do something about it, not that this is the
correct way to do it.

Think for a second as to why your code path looks different from EVERY
other kobject user in the kernel.  Perhaps it is incorrect?  You don't
need all this completion mess, in fact, it's wrong.

Just do what everyone else does please, as that is the simpler, and
correct, way to do it.

Oh, and why are you using a kobject at all anyway?  Shouldn't you be
using a 'struct device'?

Anyway, I don't have time for this anymore for the next 2 weeks, good
luck.

greg k-h
