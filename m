From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 5/6] aha152x.c - Fix check_condition code-path
Date: Tue, 31 Jul 2007 10:08:27 -0700
Message-ID: <20070731100827.e2180ca6.rdunlap@xenotime.net>
References: <46ACE62F.4070108@panasas.com>
	<46ACEA0A.5040101@panasas.com>
	<20070730171331.5237bb94.rdunlap@xenotime.net>
	<46AEEBF7.3060808@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:36963 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752881AbXGaRC4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jul 2007 13:02:56 -0400
Received: from midway.site ([71.245.96.223]) by xenotime.net for <linux-scsi@vger.kernel.org>; Tue, 31 Jul 2007 10:02:52 -0700
In-Reply-To: <46AEEBF7.3060808@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, "=?ISO-8859-1?Q? J=FCrg?= =?ISO-8859-1?Q?en_E._Fischer ?=" <fischer@norbit.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 31 Jul 2007 10:59:51 +0300 Boaz Harrosh wrote:

> Randy Dunlap wrote:
> > 
> > Since you grok all of that (above), maybe you can help here:
> > 
> > With these 6 patches applied, I do the following:
> > 
> > 1.  insert PCMCIA aha152x card with SCSI drive attached (/dev/sdb4)
> > 2.  mount -t vfat /dev/sdb4 /mnt/disk
> > 3.  play with /mnt/disk
> > 4.  umount /mnt/disk
> > 
> > Now I would like to rmmod the aha152x_cs module, but its use count
> > is 2.  Even if I eject the card, its use count stays at 2.
> > Maybe the reset or check_condition patch doesn't clean up correctly,
> > or one of them isn't releasing a used resource ?
> > 
> > (this is 2.6.23-rc1 + your 6 patches + 1 acpi seq-file throttling fix.)
> > 
> 
> I had an hard look and a very careful line-by-line compare
> and I can't find anything obvious. Could you do a bisect.
> maybe it will give me a clue as to where to look. Also please
> Enable debug prints. Maybe the driver is stuck at some state 
> and does not exit.

Matthew's remove_host() patch didn't affect the use-count and
non-rmmod-ability, so I'll do a quick bisect now.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
