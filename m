From: Russ Garrett <russ@garrett.co.uk>
Subject: Re: Megaraid problems with >8GB RAM
Date: Thu, 28 Jul 2005 23:11:15 +0100
Message-ID: <42E95803.20809@garrett.co.uk>
References: <200507271444.j6REi9t19514@lonfs01.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta07-winn.ispmail.ntl.com ([81.103.221.47]:49606 "EHLO
	mta07-winn.ispmail.ntl.com") by vger.kernel.org with ESMTP
	id S261582AbVG1WK4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jul 2005 18:10:56 -0400
In-Reply-To: <200507271444.j6REi9t19514@lonfs01.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mark Hourihan <markh@lsil.com>, 'Saba Nesar' <saban@lsil.com>

Firstly many thanks to LSI who responded so promptly to an e-mail which 
wasn't even addressed to them :), we really appreciate the support.

I went back to the datacenter yesterday for another try, and managed to 
get both boxes booting with SuSe Pro 9.3 (instead of Debian). However, 
the amusing part is that they only sucessfully boot about 1/3rd of the 
time. The rest of the time it results in the "mailbox adapter did not 
initialize" error (after a timeout). Oddly enough, it seems to boot fine 
when it's "warm". Cold boots are less successful.
Very occasionally, it results in a kernel panic (hastily transcribed):

megaraid cmm: 2.20.2.5
megaraid: 2.20.4.5

Unable to handle kernel paging request at <addr> RIP: 
<addr>{:megaraid_mbox:megaraid_isr+298}
PGD 0
Oops: 0002 [1] SMP
CPU 1
Modules linked in: megaraid_mbox megaraid_mm amd74xx ide_core sd_mod 
scsi_mod
Pid: 0, comm: swapper Not tainted 2.6.11.4-21.7-smp
RIP: 0010:[<ffffffff88062eda>] 
<ffffffff88062eda>{:megaraid_mbox:megaraid_isr+298}
RSP: 0018:ffff810037d17e98 EFLAGS: 00010082
RAX: 0000000000000000 RBX: ffff8100101e5010 RCX: 0000000000002370
RDX: 0000000000000000 RSI: ffff81020a094000 RDI: ffff8100fbca0028

We've had to push one of these boxes into production very urgently, and 
it seems to be running fine under heavy load. So as long as it doesn't 
reboot, we're fine...

Our hardware spec:

- Tyan motherboard (spec unknown, I'll find it out if it helps), AMD 
chipset.
- Dual Opteron 2.2GHz
- 16GB RAM
- Megaraid 320-2 (1L37/G119)

Cheers,

Russ Garrett
russ@last.fm

-----Original Message-----
From: Russ Garrett [mailto:russ@garrett.co.uk] 
Sent: Tuesday, July 26, 2005 6:01 PM
To: linux-scsi@vger.kernel.org
Subject: Megaraid problems with >8GB RAM

When installing Linux on a pair of new dual-opteron servers (16GB of RAM 
and a MegaRAID 320-2), neither the megaraid v1, nor v2 drivers could 
talk to the actual MegaRAID hardware. The v1 driver simply caused the 
system to lock up, wheras the v2 driver produces the error "megaraid: 
maibox adapter did not initialize" after a while.

Googling for the error produced this slightly old result, which fits the 
problem perfectly: 
http://lists.suse.com/archive/suse-amd64/2004-Jun/0345.html

And indeed, passing the argument "mem=3000000k" to the kernel allows the 
card to be detected fine by the v2 driver. We have a lot of 8GB Opterons 
running Megaraid cards fine, but this is the first time we've bought 
16GB models. This is the first problem we've seen, so I'm guessing that 
the MegaRAID firmware has issues writing to RAM higher than somewhere 
between 8 and 16GB...

Should we be looking for a new RAID card or is there a way to fix this? 
Why has seemingly nobody else had this problem?

Thanks in advance,

Russ Garrett
russ@last.fm


