From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: bios_param() incorrect for large disks on 32-bit arch for many SCSI drivers?
Date: Thu, 23 Dec 2004 16:30:37 -0500
Message-ID: <04Dec23.163037est.332311@cyborg.cybernetics.com>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyborg.cybernetics.com ([206.246.200.18]:65294 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S261304AbULWVdP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Dec 2004 16:33:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

In reviewing the LBD (large block devices) patch for lk 2.4
(http://www.gelato.unsw.edu.au/patches/lbd/), there are quite a number
of changes to SCSI driver bios_param() functions that look like:

- cylinders = capacity / (heads * sectors);
+ cylinders = (long) capacity / (heads * sectors);

I noticed that many of these changes have made it into the lk 2.6
series:

cd linux-2.6.10-rc3
find . -type f -name "*.c" | xargs grep "(.*long).*capacity" | grep -v
"long long"

This prints out numerous places where disk capacity is casted to long or
unsigned long, mostly in bios_param() functions of SCSI drivers.

Why are these casts used?  Disk capacity is of type sector_t (64-bit),
but on 32-bit platforms like i386, long and unsigned long are 32-bit.
These casts truncate the capacity of disks >= 2 TB on 32-bit platforms.
The only benefit that I can see is using 32/32 division rather than
64/32 division (something like this is mentioned at
http://www.gelato.unsw.edu.au/IA64wiki/LBDKernel), but the answer is
wrong, so what's the point?

Are these typecasts incorrect, or am I missing something?

Anthony J. Battersby
Cybernetics

