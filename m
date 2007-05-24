From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 02/25] drivers/scsi/advansys.c: cleanups
Date: Thu, 24 May 2007 10:48:59 +0100
Message-ID: <20070524094859.GA28305@infradead.org>
References: <200705232141.l4NLfZ1x001158@shell0.pdx.osdl.net> <1179962491.5569.62.camel@mulgrave.il.steeleye.com> <20070523163359.3c71f44e.akpm@linux-foundation.org> <1179969727.5569.69.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:35297 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490AbXEXJtD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 May 2007 05:49:03 -0400
Content-Disposition: inline
In-Reply-To: <1179969727.5569.69.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, bunk@stusta.de

On Wed, May 23, 2007 at 08:22:07PM -0500, James Bottomley wrote:
> On Wed, 2007-05-23 at 16:33 -0700, Andrew Morton wrote:
> > On Wed, 23 May 2007 18:21:31 -0500
> > James Bottomley <James.Bottomley@SteelEye.com> wrote:
> > 
> > > On Wed, 2007-05-23 at 14:41 -0700, akpm@linux-foundation.org wrote:
> > > > From: Adrian Bunk <bunk@stusta.de>
> > > > 
> > > > - remove the unneeded advansys.h
> > > > - remove the unused advansys_setup()
> > > 
> > > This isn't quite right, though, is it?  advansys_setup() should be used.
> > > 
> > > It looks like there was a bogus conversion away from init/main.c which
> > > left the function dangling.  Isn't the correct thing to do to wire it up
> > > in advansys_detect() which is where it should have been in the first
> > > place.
> > > 
> > 
> > Even going back to linux-2.4.2 I can find no caller to advansys_setup(). 
> > Or was its call buried in the magical template macros?
> 
> If I remember rightly, the bootsetups[] array was a 2.0 thing it became
> kernel_param in 2.1.75.  It was gone by 2.4.0, so this removal thing
> must have been in the 2.3 timeframe.
> 
> Still ... it can be put back .. it looks basically sound.

I don't think we should put it back, obviously no ones has missed
it for te last 10 years.  If we really want boot paramaters for
advansys it should be using module_param, not a 10 year old legacy
interface.
