From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 0/17]: New SCSI target framework (SCST) with dev handlers
 and 2 target drivers
Date: Tue, 14 Sep 2010 22:56:49 -0700
Message-ID: <20100915055649.GB22219@core.coreip.homeip.net>
References: <4C8F886E.2080407@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C8F886E.2080407@vlnb.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Hi Vladislav,

On Tue, Sep 14, 2010 at 06:36:30PM +0400, Vladislav Bolkhovitin wrote:
> Hi All,
> 
> Please review this second iteration of the patch set of the new
> (although, perhaps, the oldest) SCSI target framework for Linux SCST
> with a set of dev handlers and 2 target drivers: for local access
> (scst_local) and for Infiniband SRP (srpt).
> 

I am afraid that the way the code was split into the patches will hinder
the review process. Normally every patch consists of a usable on its
own piece of code (or a logically compete change). This way the unit of
work (coding, testing or reviewing) is clearly defined and easier to
comprehend.

Your patch series, unfortunately, splits Makefile and Kconfig changes
separately from the drivers (which will cause build breakages should it
be applied as is and someone needs to bisect), introduces header files
in their entirety even when some of the data there is not needed till
much later, uses facilities (for example sysfs bindings) that have not
been introduced yet... I am afraid you'd have to rework the splitting
process.

Also patch descriptions should be improved:

"This patch contains SYSFS interface implementation"

- what are you trying to solve?
- main points?
- why offloading of actions to a separate thread?

This should be in the patch description.

BTW, why are you using an exclusive thread instead of exclusive
workqueue for this?

Also, kobject_del() + kobject_put() == kobject_unregister().

And too many "naked returns", I believe common style is to only have
return for non-void functions.

Thanks.

-- 
Dmitry
