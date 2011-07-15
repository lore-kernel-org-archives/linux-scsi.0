From: ersatz splatt <ersatzsplatt@gmail.com>
Subject: Re: rq_affinity doesn't seem to work?
Date: Fri, 15 Jul 2011 16:43:44 -0700
Message-ID: <CAHQAjVGK97KU0dB700WSTS1bH0YkW1_MCVaAtjR9aFQRJTcsbA@mail.gmail.com>
References: <D010E79907AF0D4E90B603DE907837D504CA6365D6@azsmsx504.amr.corp.intel.com>
	<4E1CAEEB.8050506@kernel.dk>
	<20110713171011.GA11864@parisc-linux.org>
	<CAL1RGDUDbEG4ypr0GJLLi_0PTjZK0HshMVwTs=aY+=hhFdjK5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44694 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab1GOXnq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jul 2011 19:43:46 -0400
In-Reply-To: <CAL1RGDUDbEG4ypr0GJLLi_0PTjZK0HshMVwTs=aY+=hhFdjK5g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Jens Axboe <axboe@kernel.dk>, "Jiang, Dave" <dave.jiang@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Foong, Annie" <annie.foong@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Nadolski, Edmund" <edmund.nadolski@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>

On Thu, Jul 14, 2011 at 10:02 AM, Roland Dreier <roland@purestorage.com=
> wrote:

> The problem as we've seen it is that on a dual-socket Westmere (Xeon
> 56xx) system, we have two sockets with 6 cores (12 threads) each, all
> sharing L3 cache, and so we end up with all block softirqs on only 2
> out of 24 threads, which is not enough to handle all the IOPS that
> fast storage can provide.

I have a dual socket system with Tylersburg chipset (approximately
Westmere I gather).
With two Xeon X5660 packages I get this when running with more iops
potential than the system can handle:

02:15:00 PM CPU  %usr  %nice %sys %iowait  %irq  %soft  %steal  %guest =
%idle
02:15:02 PM  all    2.76    0.00   30.40   28.28    0.00   13.74
0.00    0.00   24.81
02:15:02 PM    0    0.00    0.00    0.00    0.00    0.00  100.00
0.00    0.00    0.00
02:15:02 PM    1    0.00    0.00    0.50    0.00    0.00    0.00
0.00    0.00   99.50
02:15:02 PM    2    3.02    0.00   36.68   52.26    0.00    8.04
0.00    0.00    0.00
02:15:02 PM    3    2.50    0.00   36.00   54.50    0.00    7.00
0.00    0.00    0.00
02:15:02 PM    4    5.47    0.00   64.18   18.91    0.00   11.44
0.00    0.00    0.00
02:15:02 PM    5    3.02    0.00   37.69   53.27    0.00    6.03
0.00    0.00    0.00
02:15:02 PM    6    0.00    0.00    0.50    0.00    0.00   91.54
0.00    0.00    7.96
02:15:02 PM    7    0.00    0.00    0.00    0.00    0.00    0.00
0.00    0.00  100.00
02:15:02 PM    8    3.00    0.00   35.50   55.00    0.00    6.50
0.00    0.00    0.00
02:15:02 PM    9    3.02    0.00   39.70   50.25    0.00    7.04
0.00    0.00    0.00
02:15:02 PM   10    3.50    0.00   36.50   53.00    0.00    7.00
0.00    0.00    0.00
02:15:02 PM   11    6.53    0.00   70.85    9.05    0.00   13.57
0.00    0.00    0.00
02:15:02 PM   12    0.00    0.00    0.57    0.00    0.00    0.00
0.00    0.00   99.43
02:15:02 PM   13    3.00    0.00    0.00    0.00    0.00    0.00
0.00    0.00   97.00
02:15:02 PM   14    2.50    0.00   36.50   54.00    0.00    7.00
0.00    0.00    0.00
02:15:02 PM   15    3.52    0.00   36.18   53.77    0.00    6.53
0.00    0.00    0.00
02:15:02 PM   16    5.00    0.00   64.00   21.00    0.00   10.00
0.00    0.00    0.00
02:15:02 PM   17    3.02    0.00   37.19   52.76    0.00    7.04
0.00    0.00    0.00
02:15:02 PM   18    0.00    0.00    0.00    0.00    0.00    0.00
0.00    0.00  100.00
02:15:02 PM   19    0.00    0.00    1.01    0.00    0.00    0.00
0.00    0.00   98.99
02:15:02 PM   20    3.48    0.00   38.31   52.24    0.00    5.97
0.00    0.00    0.00
02:15:02 PM   21    5.50    0.00   63.00   18.50    0.00   13.00
0.00    0.00    0.00
02:15:02 PM   22    2.50    0.00   35.00   54.50    0.00    8.00
0.00    0.00    0.00
02:15:02 PM   23    5.03    0.00   58.79   23.62    0.00   12.56
0.00    0.00    0.00

By "more IOPS potential than the system can handle", I mean that with
about a quarter of the targets I get the same figure.  The HBA is
known to handle more than twice the IOPS I'm seeing.

I'm using 16 targets with fio driving one target with each core you
see sys activity on.  You can see that two additional cores are
getting weighed down -- 0 and 6.  Is that indicative of the
bottleneck?

These results are without using any of the patches suggested in this
e-mail thread.  I'll have to try and see if they help.

What is the top number of IOPS I should hope for with this system and
the Linux kernel?
Dave Jiang (or anyone else) -- can you share the max IOPS that you are =
seeing?


> It's not clear to me what the right answer or tradeoffs are here. =A0=
It
> might make sense to use only one hyperthread per core for block
> softirqs. =A0As I understand the Westmere cache topology, there's not
> really an obvious intermediate step -- all the cores in a package
> share the L3, and then each core has its own L2.
>
> Limiting softirqs to 10% of a core seems a bit low, since we seem to
> be able to use more than 100% of a core handling block softirqs, and
> anyway magic numbers like that seem to always be wrong sometimes.
> Perhaps we could use the queue length on the destination CPU as a
> proxy for how busy ksoftirq is?
>
> =A0- R.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
