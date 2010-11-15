From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Mon, 15 Nov 2010 13:14:30 -0800
Message-ID: <20101115211430.GA19071@core.coreip.homeip.net>
References: <20101109002829.GA22633@kroah.com>
 <4CD9A9B8.70708@vlnb.net>
 <4CDA6CD4.3010308@panasas.com>
 <4CDAFE6E.7050200@vlnb.net>
 <4CDBBE80.40908@panasas.com>
 <4CDC56F9.9040601@vlnb.net>
 <20101112012315.GE17097@core.coreip.homeip.net>
 <4CDEC8D2.8080101@vlnb.net>
 <20101115070436.GC14442@core.coreip.homeip.net>
 <4CE19A08.8050606@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63695 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758519Ab0KOVOr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Nov 2010 16:14:47 -0500
Content-Disposition: inline
In-Reply-To: <4CE19A08.8050606@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>, Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>

On Mon, Nov 15, 2010 at 11:37:28PM +0300, Vladislav Bolkhovitin wrote:
> Dmitry Torokhov, on 11/15/2010 10:04 AM wrote:
> 
> >> This is because SYSFS doesn't hold references for the corresponding
> >> kobjects for every open file handle. It holds references only when
> >> show() and store() functions called. So, everything is under control and
> >> a malicious user can do nothing to hold a reference forever.
> > 
> > Right, Tejun plugged this particular (and very annoying) attributes
> > behavior
> 
> This behavior isn't annoying, it's GREAT, because it allows to use SYSFS
> simply and reliably.

Right, I mean that _before_ Tejun plugged that hole the behavior _was_
annoying.

> 
> >, but that does not mean that this is the only way kobject's
> > reference might be pinned.
> 
> Could you be more specific and point out on exact ways for that? From my
> quite deep SYSFS source code study I see such cases should not exist.

While I do not know offhand I am sure there are such scenarios. Isn't
there any way for the users that you are waiting on descend back into
your module that is waiting for kobject removal and get stuck on some
resource?

Even if it isn't possible now the scheme is quite fragile. Kobjects are
refcounted so work with them appropriately (rely on refcount, do not
wait, etc).

-- 
Dmitry
