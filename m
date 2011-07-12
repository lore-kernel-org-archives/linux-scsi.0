From: "Jiang, Dave" <dave.jiang@intel.com>
Subject: RE: rq_affinity doesn't seem to work?
Date: Tue, 12 Jul 2011 14:17:54 -0700
Message-ID: <D010E79907AF0D4E90B603DE907837D504CA6366F6@azsmsx504.amr.corp.intel.com>
References: <D010E79907AF0D4E90B603DE907837D504CA6365D6@azsmsx504.amr.corp.intel.com>
 <4E1CAEEB.8050506@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:43951 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932073Ab1GLVR5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2011 17:17:57 -0400
In-Reply-To: <4E1CAEEB.8050506@kernel.dk>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, "Foong, Annie" <annie.foong@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Nadolski, Edmund" <edmund.nadolski@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>

> -----Original Message-----
> From: Jens Axboe [mailto:axboe@kernel.dk]
> Sent: Tuesday, July 12, 2011 1:31 PM
> To: Jiang, Dave
> Cc: Williams, Dan J; Foong, Annie; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org; Nadolski, Edmund; Skirvin, Jeffrey D
> Subject: Re: rq_affinity doesn't seem to work?
> 
> On 2011-07-12 21:03, Jiang, Dave wrote:
> > Jens,
> > I'm doing some performance tuning for the Intel isci SAS controller
> > driver, and I noticed some interesting numbers with mpstat. Looking at
> > the numbers it seems that rq_affinity is not moving the request
> > completion to the request submission CPU. Using fio to saturate the
> > system with 512B I/Os, I noticed that all I/Os are bound to the CPUs
> > (CPUs 6 and 7) that service the hard irqs. I have put in a quick hack
> > in the driver so that it records the CPU during request construction
> > and then I try to steer the scsi->done() calls to the request CPUs.
> > With this simple hack, mpstat shows that the soft irq contexts are now
> > distributed. I observed significant performance increase. The iowait%
> > gone from 30s and 40s to low single digit approaching 0. Any ideas
> > what could be happening with the rq_affinity logic? I'm assuming
> > rq_affinity should behave the way my hacked solution is behaving. This
> > is running on an 8 core single CPU SandyBridge based system with
> > hyper-threading turned off. The two MSIX interrupts on the controller
> > are tied to CPU 6 and 7 respectively via /proc/irq/X/smp_affinity. I'm
> > running fio with 8 SAS disks and 8 threads.
> 
> It's probably the grouping, we need to do something about that. Does the
> below patch make it behave as you expect?

Yep that is it.

02:14:12 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest   %idle
02:14:17 PM  all   11.98    0.00   46.62    1.18    0.00   37.79    0.00    0.00    2.43
02:14:17 PM    0   15.43    0.00   55.31    0.00    0.00   29.26    0.00    0.00    0.00
02:14:17 PM    1   14.83    0.00   56.71    0.00    0.00   28.46    0.00    0.00    0.00
02:14:17 PM    2   14.80    0.00   56.00    0.00    0.00   29.20    0.00    0.00    0.00
02:14:17 PM    3   14.63    0.00   57.11    0.00    0.00   28.26    0.00    0.00    0.00
02:14:17 PM    4   14.80    0.00   57.60    0.00    0.00   27.60    0.00    0.00    0.00
02:14:17 PM    5   15.03    0.00   56.11    0.00    0.00   28.86    0.00    0.00    0.00
02:14:17 PM    6    3.79    0.00   20.16    5.99    0.00   59.68    0.00    0.00   10.38
02:14:17 PM    7    2.80    0.00   14.20    3.20    0.00   70.80    0.00    0.00    9.00
