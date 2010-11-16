From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Tue, 16 Nov 2010 16:13:16 +0300
Message-ID: <4CE2836C.5090206@vlnb.net>
References: <20101109002829.GA22633@kroah.com> <4CD9A9B8.70708@vlnb.net> <4CDA6CD4.3010308@panasas.com> <4CDAFE6E.7050200@vlnb.net> <4CDBBE80.40908@panasas.com> <4CDC56F9.9040601@vlnb.net> <20101112012315.GE17097@core.coreip.homeip.net> <4CDEC8D2.8080101@vlnb.net> <20101115070436.GC14442@core.coreip.homeip.net> <4CE19A08.8050606@vlnb.net> <20101115211430.GA19071@core.coreip.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101115211430.GA19071@core.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>, Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Dmitry Torokhov, on 11/16/2010 12:14 AM wrote:
>> Could you be more specific and point out on exact ways for that? From my
>> quite deep SYSFS source code study I see such cases should not exist.
> 
> While I do not know offhand I am sure there are such scenarios. Isn't
> there any way for the users that you are waiting on descend back into
> your module that is waiting for kobject removal and get stuck on some
> resource?

No, I don't see any, because SYSFS implements atomic "all or nothing"
behavior on destroy, which is pretty bulletproof.

> Even if it isn't possible now the scheme is quite fragile. Kobjects are
> refcounted so work with them appropriately (rely on refcount, do not
> wait, etc).

The same is true for other SCST objects. For instance, a target can't be
destroyed until there are commands from it being processed. So, kobjects
are only one of the objects we wait for all their ref counters reach
zero, hence addition of kobjects to SCST objects changed nothing in this
area.

Vlad
