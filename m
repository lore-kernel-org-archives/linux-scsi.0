From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: TCQ depth of aic7xxx
Date: Wed, 16 Aug 2006 14:16:31 +0200
Message-ID: <1155730591.3023.31.camel@laptopd505.fenrus.org>
References: <3a1eedb70608160501l1637a01ai97faadbe6ea5620f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:47049 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751119AbWHPMQy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Aug 2006 08:16:54 -0400
In-Reply-To: <3a1eedb70608160501l1637a01ai97faadbe6ea5620f@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jassduec@gmail.com
Cc: linux-scsi@vger.kernel.org

On Wed, 2006-08-16 at 06:01 -0600, jassduec@gmail.com wrote:
> Hi All,
> 
> Is there a good reference on tuning the TCQ depth parameter of the
> module aic7xxx. I am using an adaptec's SCSI card and would like to
> tune the module parameters to get the best possible I/O rate. Any help
> in this regard would be highly appreciated.

Hi,

unless you have a raid array connected with multiple disks, keeping the
TCQ value low (say 3 or 4) is probably best. This low TCQ value (just
don't pick 1, since that introduces some latency) allows the kernel
elevator to do a lot more work, and both merge ios better as well as
taking care of fairness.... giving you a good mix of performance and
fairness. High TCQ values mean that the IO's leave the linux queue too
quickly (and just end up in the disks queue instead). Linux has more
options for optimization than the disk has (the disk is constrained by
both a relatively simple brain, and by various ordering and grouping
rules imposed by the scsi specification), so giving the kernel more
chance to optimize is going to be best.

Now if you have a raid array connected, the balance is different, since
"3 or 4" isn't going to be enough to keep all spindles in the raid array
busy; in that case I'd recommend a much higher value, especially if the
raid array has battery backed ram (which means write can be completed
instantaneously).

Greetings,
    Arjan van de Ven
-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com

