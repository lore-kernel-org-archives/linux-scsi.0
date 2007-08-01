From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 5/6] aha152x.c - Fix check_condition code-path
Date: Wed, 1 Aug 2007 09:34:22 -0700
Message-ID: <20070801093422.f986597d.rdunlap@xenotime.net>
References: <46ACE62F.4070108@panasas.com>
	<46ACEA0A.5040101@panasas.com>
	<20070730171331.5237bb94.rdunlap@xenotime.net>
	<46AEEBF7.3060808@panasas.com>
	<20070731114021.488735ec.rdunlap@xenotime.net>
	<1185976274.3468.70.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:38471 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750943AbXHAQ2r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Aug 2007 12:28:47 -0400
Received: from midway.site ([71.245.96.223]) by xenotime.net for <linux-scsi@vger.kernel.org>; Wed, 1 Aug 2007 09:28:42 -0700
In-Reply-To: <1185976274.3468.70.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, "=?ISO-8859-1?Q? _J=FCrgen_E._Fisc?= =?ISO-8859-1?Q?her_ ?=" <fischer@norbit.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 01 Aug 2007 08:51:14 -0500 James Bottomley wrote:

> On Tue, 2007-07-31 at 11:40 -0700, Randy Dunlap wrote:
> > On Tue, 31 Jul 2007 10:59:51 +0300 Boaz Harrosh wrote:
> > 
> > > Randy Dunlap wrote:
> > > > 
> > > > Since you grok all of that (above), maybe you can help here:
> > > > 
> > > > With these 6 patches applied, I do the following:
> > > > 
> > > > 1.  insert PCMCIA aha152x card with SCSI drive attached (/dev/sdb4)
> > > > 2.  mount -t vfat /dev/sdb4 /mnt/disk
> > > > 3.  play with /mnt/disk
> > > > 4.  umount /mnt/disk
> > > > 
> > > > Now I would like to rmmod the aha152x_cs module, but its use count
> > > > is 2.  Even if I eject the card, its use count stays at 2.
> > > > Maybe the reset or check_condition patch doesn't clean up correctly,
> > > > or one of them isn't releasing a used resource ?
> > > > 
> > > > (this is 2.6.23-rc1 + your 6 patches + 1 acpi seq-file throttling fix.)
> > > > 
> > > 
> > > I had an hard look and a very careful line-by-line compare
> > > and I can't find anything obvious. Could you do a bisect.
> > > maybe it will give me a clue as to where to look. Also please
> > > Enable debug prints. Maybe the driver is stuck at some state 
> > > and does not exit.
> > 
> > The good news is that this problem has nothing to do with this
> > patch series.  The bad news is that this problem is there anyway.
> 
> So on a functionality basis you're prepared to ack this patch set on the
> basis of empirical testing on the grounds that the bug predates them?

Yes.  Acked-and-tested-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
