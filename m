From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH 0/17]: New SCSI target framework (SCST) with dev handlers
 and 2 target drivers
Date: Wed, 15 Sep 2010 22:07:44 +0400
Message-ID: <4C910B70.8060305@vlnb.net>
References: <4C8F886E.2080407@vlnb.net> <20100915055649.GB22219@core.coreip.homeip.net> <4C90DDB1.9020003@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C90DDB1.9020003@vlnb.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Vladislav Bolkhovitin, on 09/15/2010 06:52 PM wrote:
> It, definitely,
> isn't a piece of beauty, but it's simple and works, so, I believe, good enough. User space,
> anyway, is supposes to hide all the complexities of the direct SYSFS manipulations under
> higher level management tools like scstadmin.

There's one more point I forgot to note why having the separate SYSFS
management thread is good: it naturally serializes all SYSFS management
operations, so allows to simplify locking in target drivers and dev
handlers. For instance, it allows in add_target() callback don't bother
if del_target() or another add_target() for the same target name called
simultaneously.

Thanks,
Vlad
