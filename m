From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] hptiop: backout ioctl mess
Date: Wed, 02 Aug 2006 23:29:01 -0400
Message-ID: <44D16D7D.7090705@torque.net>
References: <20060730171336.GA31646@lst.de>	 <08ce01c6b44c$82b8ef70$1200a8c0@gmm> <1154559337.2861.2.camel@laptopd505.fenrus.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:58327 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932163AbWHCD3a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Aug 2006 23:29:30 -0400
In-Reply-To: <1154559337.2861.2.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: HighPoint Linux Team <linux@highpoint-tech.com>, linux-scsi@vger.kernel.org, jejb@steeleye.com, Christoph Hellwig <hch@lst.de>

Arjan van de Ven wrote:
> On Mon, 2006-07-31 at 10:53 +0800, HighPoint Linux Team wrote:
>> Christoph Hellwig wrote:
>>> The hptiop just got merged with a horrible amount of really bad ioctl
>>> code that is against the standards for new scsi drivers.  This patch
>>> backs it out (and fixes a small bug where scsi_add_host is called to
>>> early).  We can re-add proper APIs once we agree on them.
>> What is the standard implemetation of private ioctls for scsi drivers?
>> Thanks.
> 
> Hi,
> 
> the real answer is: try really hard to use generic ioctls for your
> functionality. 

Now there is an idea :-) Pick a vendor specific opcode
like 0xff (and maybe have a module parameter to override
it to something else) and then use the SG_IO ioctl to
send "highpoint" specific SCSI commands that provide
the same functionality within the LLD that Christoph
just stripped out.

One problem with this approach is interacting with the
LLD in the absence of any (real) SCSI devices. It shouldn't be
too hard to trick the mid level into believing there are
SCSI devices connected (see the scsi_debug driver). May
I suggest a LUN slightly above the WLUN range (e.g.
49409+10). The fake device could then be created with:
# cd /sys/class/scsi_host/host0
# echo "- - 49419" > scan

The fake device would need to respond to an INQUIRY and a few
other simple SCSI commands to keep the mid-level happy.
May I also suggest the "processor" peripheral device type
which stops other ULDs getting involved. Then you can talk
to the LLD via a sg device node.

What exactly do you need private ioctls for?
> It's quite possible that there is a generic way to do the same thing
> already, or something that can easily be extended to do what you need...

Is the above generic enough?

Doug Gilbert

