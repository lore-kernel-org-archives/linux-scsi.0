From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 5/6] aha152x.c - Fix check_condition code-path
Date: Tue, 31 Jul 2007 10:59:51 +0300
Message-ID: <46AEEBF7.3060808@panasas.com>
References: <46ACE62F.4070108@panasas.com>	<46ACEA0A.5040101@panasas.com> <20070730171331.5237bb94.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:27828 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750833AbXGaIAI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jul 2007 04:00:08 -0400
In-Reply-To: <20070730171331.5237bb94.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, =?ISO-8859-1?Q?=22J=FC?= =?ISO-8859-1?Q?rgen_E=2E_Fischer=22?= <fischer@norbit.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>

Randy Dunlap wrote:
> 
> Since you grok all of that (above), maybe you can help here:
> 
> With these 6 patches applied, I do the following:
> 
> 1.  insert PCMCIA aha152x card with SCSI drive attached (/dev/sdb4)
> 2.  mount -t vfat /dev/sdb4 /mnt/disk
> 3.  play with /mnt/disk
> 4.  umount /mnt/disk
> 
> Now I would like to rmmod the aha152x_cs module, but its use count
> is 2.  Even if I eject the card, its use count stays at 2.
> Maybe the reset or check_condition patch doesn't clean up correctly,
> or one of them isn't releasing a used resource ?
> 
> (this is 2.6.23-rc1 + your 6 patches + 1 acpi seq-file throttling fix.)
> 

I had an hard look and a very careful line-by-line compare
and I can't find anything obvious. Could you do a bisect.
maybe it will give me a clue as to where to look. Also please
Enable debug prints. Maybe the driver is stuck at some state 
and does not exit.

Thanks
Boaz



