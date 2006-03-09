From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Linux SCSI Error Question with SG Driver
Date: Thu, 09 Mar 2006 09:23:14 -0500
Message-ID: <44103A52.3090509@torque.net>
References: <Pine.LNX.4.64.0603090706370.15616@p34>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([205.233.218.70]:26053 "EHLO
	canuck.infradead.org") by vger.kernel.org with ESMTP
	id S1750974AbWCIOZV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Mar 2006 09:25:21 -0500
In-Reply-To: <Pine.LNX.4.64.0603090706370.15616@p34>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Justin Piszcz wrote:
> I have a tape library connected to a Linux box here and every once and a
> while I see these in dmesg:
> 
> sg_low_free: bad mem_src=0, buff=0xdb6a8000, rqSz=32768
> sg_low_free: bad mem_src=0, buff=0xdb6b0000, rqSz=28672
> sg_low_free: bad mem_src=0, buff=0xdb738000, rqSz=32768
> sg_low_free: bad mem_src=0, buff=0xdb718000, rqSz=28672
> sg_low_free: bad mem_src=0, buff=0xdb680000, rqSz=32768
> sg_low_free: bad mem_src=0, buff=0xdb678000, rqSz=28672
> sg_low_free: bad mem_src=0, buff=0xdb670000, rqSz=32768
> sg_low_free: bad mem_src=0, buff=0xdb668000, rqSz=28672
> sg_low_free: bad mem_src=0, buff=0xdb660000, rqSz=32768
> sg_low_free: bad mem_src=0, buff=0xdb658000, rqSz=28672
> sg_low_free: bad mem_src=0, buff=0xdb650000, rqSz=32768
> sg_low_free: bad mem_src=0, buff=0xdb648000, rqSz=28672
> 
> Does anyone know what they refer to?

Justin,
That looks like the sg driver in the lk 2.4 series.
When it comes to free up some memory in sg_low_free()
it checks where the memory was sourced from. A
mem_src of 0 is not defined hence the error message.

Hard to say why this happens as the buff addresses
and rqSz values look reasonable.

Doug Gilbert

