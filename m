From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: RE: bios_param() incorrect for large disks on 32-bit arch for many SCSI drivers?
Date: Mon, 27 Dec 2004 11:56:31 -0500
Message-ID: <04Dec27.115632est.332704@cyborg.cybernetics.com>
References: <04Dec23.163037est.332311@cyborg.cybernetics.com>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host02.cybernetics.com ([206.246.200.18]:7433 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S261929AbUL0RIV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Dec 2004 12:08:21 -0500
In-Reply-To: <04Dec23.163037est.332311@cyborg.cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> - cylinders = capacity / (heads * sectors);
> + cylinders = (long) capacity / (heads * sectors);

> Why are these casts used?  Disk capacity is of type sector_t (64-bit),
> but on 32-bit platforms like i386, long and unsigned long are 32-bit.
> These casts truncate the capacity of disks >= 2 TB on 32-bit
> platforms.
> The only benefit that I can see is using 32/32 division rather than
> 64/32 division (something like this is mentioned at
> http://www.gelato.unsw.edu.au/IA64wiki/LBDKernel), but the answer is
> wrong, so what's the point?

OK, so the partial answer is that 64/32 division in the kernel requires
use of a special macro (sector_div which uses do_div from asm/div64.h),
so one cannot simply remove the casts or else the build will have
unresolved symbols from gcc.  The correct solution is  something like:

- cylinders = (long) capacity / (heads * sectors);
+ sector_t cyl = capacity;
+ u32 hs = heads * sectors;
+ sector_div(cyl, hs);
+ cylinders = cyl;

I am not sure why it was not done this way to begin with.  Does anyone
think that these should be fixed, or does it not matter?

Anthony J. Battersby
Cybernetics

