From: Luben Tuikov <tluben@rogers.com>
Subject: Re: [PATCH] make the SCSI mid-layer obey the device online flag
Date: Sat, 07 Jun 2003 01:20:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EE17615.7050706@rogers.com>
References: <1054742495.1674.18.camel@mulgrave>	<20030604165146.GA1426@beaverton.ibm.com>	<1054754103.2360.8.camel@mulgrave> <20030606073603.A13259@infradead.org>	<3EE0B316.4060207@rogers.com> <1054913984.1778.31.camel@mulgrave>	<3EE0B8D8.4020909@rogers.com> <20030606215152.B3240@infradead.org> 	<3EE12371.90403@rogers.com> <1054943015.1777.67.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep04-mail.bloor.is.net.cable.rogers.com ([66.185.86.74]:59930
	"EHLO fep04-mail.bloor.is.net.cable.rogers.com") by vger.kernel.org
	with ESMTP id S262578AbTFGFGr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Jun 2003 01:06:47 -0400
In-Reply-To: <1054943015.1777.67.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mike Anderson <andmike@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>

James Bottomley wrote:
> On Fri, 2003-06-06 at 19:27, Luben Tuikov wrote:
> 
>>*If* eh is to be done in SCSI Core you just cannot avoid it --
>>this is *the whole point* which James had in mind to allow
>>to send cmnds if !online. (see prev msgs on this thread)
> 
> 
> Actually, I didn't.  Error handling has its own separate entry into
> ->queuecommand() (scsi_send_eh_cmnd()), so it wouldn't be affected by my
> changes.
> 
> My purpose is quite simple: Any normal block actions (read/write from
> mounted fs, or CD burning via SG_IO) would be errored.  Any special
> commands (from ioctls, direct commands or stack generated) would not be
> affected.
> 
> i.e.
> 
> REQ_CMD	errors
> REQ_BLOCK_PC errors
> REQ_SPECIAL is allowed

So you're saying: online <--> all allowed,
!online <--> only REQ_SPECIAL allowed.

I doubt this will work.  (But we can try it - hey, what the heck!)

The reason is that it adds another layer of
implementation on the upper layers which is
non-existant.

ULDD *do NOT* have eh capabilities, which is where your
"ejecting the cartridge" and "unlocking the door"
commands fall (ULDD eh - non-existant in Linux).

BTW, above I was talking about user space eh of SCSI Devices,
or more appropriately upper layer device drivers (ULDD, sd, st, etc)
error handling -- i.e. of their own type of devices.
Now if this kind of eh is to be done/generated in SCSI Core
then you cannot avoid it.

(I wasn't talking of the *transport* eh.)

BTW, on another note, it is also my desire that SCSI Core should
not know anything about upper level device drivers, and has always
been.  I'd also like to see SCSI Core shrink, rather than get bigger.

-- 
Luben



