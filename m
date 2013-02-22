From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Read I/O starvation with writeback RAID controller
Date: Fri, 22 Feb 2013 21:35:12 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1302222133130.25382@nerf07.vanv.qr>
References: <5124EDF4.4010309@zoner.cz>  <1361393295.3667.21.camel@haakon2.linux-iscsi.org>  <51260869.20105@zoner.cz> <1361484084.3667.73.camel@haakon2.linux-iscsi.org> <5127C6C4.2060505@zoner.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <5127C6C4.2060505@zoner.cz>
Sender: target-devel-owner@vger.kernel.org
To: Martin Svec <martin.svec@zoner.cz>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Friday 2013-02-22 20:28, Martin Svec wrote:
>
> Yes, I've already tried the ROW scheduler. It helped for some low iodepths
> depending on quantum settings but generally didn't solve the problem. I think
> the key issue is that none of the schedulers can throttle I/O according to e.g.
> average request roundtrip time. Shaohua Li is right here:
> https://lkml.org/lkml/2012/12/11/598 -- as long as there's free room in
> device's queue they blindly dispatch requests to it.
>
> Which is exactly what I see in deadline scheduler fifo queues: There're no read
> requests to be scheduled between writes because all readers are starving. So
> the scheduler keeps dispatching writes using all the remaining capacity of
> device queue. Which in turn worses the read starvation. Bigger queue depth and
> bigger writeback cache means higher chance for read starvation even from a
> single writer.

Sounds just like the bufferbloat problem in networking.
Waiting for codel for the block layer  :)
