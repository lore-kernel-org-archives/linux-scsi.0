From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [patch 0/4] aha152x.c - Cleanup, need help in testing and
 auditing
Date: Thu, 19 Jul 2007 10:49:30 -0700
Message-ID: <20070719104930.7ae87df8.rdunlap@xenotime.net>
References: <4695F76F.5000305@panasas.com>
	<20070712135750.2a4a4a54.rdunlap@xenotime.net>
	<469B38CC.50501@panasas.com>
	<20070717171607.ffc278eb.rdunlap@xenotime.net>
	<469DDD74.2060208@panasas.com>
	<20070718103320.4b6ad7b3.rdunlap@xenotime.net>
	<20070718145818.8eebbd66.rdunlap@xenotime.net>
	<20070718194335.e21a01e5.rdunlap@xenotime.net>
	<20070718200315.3adcd194.rdunlap@xenotime.net>
	<469F616D.1000909@panasas.com>
	<20070719083719.33d8994c.rdunlap@xenotime.net>
	<469F89FE.4080900@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:55644 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759797AbXGSRpE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jul 2007 13:45:04 -0400
Received: from midway.site ([71.117.236.25]) by xenotime.net for <linux-scsi@vger.kernel.org>; Thu, 19 Jul 2007 10:45:02 -0700
In-Reply-To: <469F89FE.4080900@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, Douglas Gilbert <dougg@torque.net>, scsi <linux-scsi@vger.kernel.org>, "=?ISO-8859-1?Q? J=FCrgen_E._Fischer ?=" <fischer@norbit.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Thu, 19 Jul 2007 18:57:50 +0300 Boaz Harrosh wrote:

> Randy Dunlap wrote:
> > 
> > Yes, this problem has been around forever AFAIK.  You didn't add
> > to it.
> Do we need to file a bug report in Bugzilla or something, so people have a 
> documentation of the work-around, until it is fixed?

Wouldn't hurt, I guess, but the SCSI people know about it.

> I think that for now I will wrap it up as it is. Could you send me the right
> BUG_ON() in place, with a printk pointing users to a solution? and I'll 
> redo all the patches.

I didn't add a BUG_ON(), so I don't have that patch.
(I just used a .slave_alloc function to force no high memory data
addresses, just like ppa.c does.)

You could just do a BUG_ON() just before there is an outsw()
or insw() to a NULL pointer, e.g., in datao_run:

		BUG_ON(CURRENT_SC->SCp.ptr);

or we could make building the driver depend on !HIGHMEM.

I prefer either of the !HIGHMEM or slave_alloc changes to adding
a BUG_ON().  However, the SCSI people likely won't want to use the
slave_alloc() change because then the driver may never get fixed.
(Of course, it hasn't got fixed with the BUG happening either.)

Anyway, I'll re-read Documentation/DMA*.txt to see if I can fix it.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
