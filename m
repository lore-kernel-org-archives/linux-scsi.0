From: Adrian Bunk <bunk@kernel.org>
Subject: Value of __*{init,exit} anotations?
Date: Thu, 31 Jan 2008 00:32:19 +0200
Message-ID: <20080130223219.GT29368@does.not.exist>
References: <20080130200336.GN29368@does.not.exist> <1201726817.3292.84.camel@localhost.localdomain> <20080130212011.GA26621@uranus.ravnborg.org> <1201729295.3292.94.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp5.pp.htv.fi ([213.243.153.39]:45349 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436AbYA3Wbo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jan 2008 17:31:44 -0500
Content-Disposition: inline
In-Reply-To: <1201729295.3292.94.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, davem@davemloft.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, "Maciej W. Rozycki" <macro@linux-mips.org>

On Wed, Jan 30, 2008 at 03:41:35PM -0600, James Bottomley wrote:
> On Wed, 2008-01-30 at 22:20 +0100, Sam Ravnborg wrote:
> > On Wed, Jan 30, 2008 at 03:00:16PM -0600, James Bottomley wrote:
>...
> > > __init is possibly justifiable with a few hundred k savings on boot.
> > > __devinit and the rest are surely killable on the grounds they provide
> > > little benefit for all the pain they cause.
> > For the embedded people a few kb here and there is worth it.
> > 
> > > all __exit seems to do is set us up for unreferenced pointers in
> > > discarded sections, so could we kill that too?
> > Again - savings when we build-in the drivers.
> > And without the checks we see 'funny' linker errors on the architectues
> > that can continue to add the .exit.text in /DISCARD/
> 
> Perhaps you have different figures, but my standard kernel linking ones
> tell me that the discard sections only save tens of k (not hundreds that
> the init ones save), so I really do think they have no real benefit and
> land us huge problems of pointer references into discarded sections.
> 
> I don't deny we can invest large amounts of work to fix our current
> issues and build large scriptable checks to ensure we keep it fixed ...
> I'm just asking if, at the end of the day, it's really worth it.

Some people consider it worth it for their memory restricted systems
and would like to drive the annotations even further. [1]

My experience while fixing section bugs during the last years is that 
the __dev{init,exit}* are actually the main question since they are both 
the majority of annotations and the ones that bring benefits only 
in a case that has become very exotic (CONFIG_HOTPLUG=n).

All the other annotations either both bring value for everyone
(plain __init* and __exit*) or are nothing normal drivers would
use (__cpu* and _mem*).

People at linux-arch (Cc'ed) might be better at explaining how often 
CONFIG_HOTPLUG gets used in real-life systems and how big the savings 
are there.

That might be a good basis for deciding whether it's worth it.

> James

cu
Adrian

[1] http://lkml.org/lkml/2007/10/12/297

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

