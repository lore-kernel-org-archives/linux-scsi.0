From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: [linux-iscsi-devel] Re: PATCH [3/5]  qla2xxx: TCQ fixes
Date: Tue, 13 Jul 2004 14:01:10 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40F44D96.6020209@us.ibm.com>
References: <20040712140558.GA6961@praka.san.rr.com>	<1089668486.1799.62.camel@mulgrave>	  <40F32AAE.5070508@us.ibm.com> <1089728842.2055.11.camel@mulgrave> 	<40F43242.1060703@us.ibm.com> <1089750044.1798.156.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:38540 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S265802AbUGMVC3
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jul 2004 17:02:29 -0400
In-Reply-To: <1089750044.1798.156.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-iscsi-devel@lists.sourceforge.net, Krishna Murthy <krmurthy@cisco.com>

James Bottomley wrote:
> On Tue, 2004-07-13 at 14:04, Mike Christie wrote:
> 
>>Unfortunately not, but it could be done. The iSCSI requirement is only 
>>that every iSCSI task has a tag which has the gaurantee of it being 
>>unique across a session, so if the host value was unique across all 
>>request_queues then it would still be safe to use.
> 
> 
> Yes, I know...I've been over this several times with iscsi people.  The
> basic point, I think, is that the driver could be so much tidier if
> session state were stored in the host, and there were a direct
> host<->end point correspondence.  You're certainly going to damage
> scalability with a single host because of the way we use the host lock
> to count per-host outstanding commands.

I will put that on my todo list then.

> 
>>The problem is that we need a tag for every iscsi task, so this includes 
>>untagged commands and logins (before there is a device/request_queue). 
>>Should we just keep it in the driver, or could the request queue have 
>>functions pointers so someone could override the block layer tag 
>>fucntions? What I am also thinking is that instead of passing the block 
>>layer request_queue (with the queue always allocating and setting the 
>>map) as an argument, it might be possible to make the tag functions 
>>some-new-map-structure based.
> 
> 
> That's the tag model.  Once TCQ is turned on, all tasks must be tagged,
> even in SPI.
> 
> I don't quite understand why you need to override the block tag
> functions, or why you want to operate without a request queue.  Even for
> device probing in SCSI, we allocate a request queue, send the INQUIRY,
> find there's nothing there and destroy the queue again.
> 
> The whole of SCSI is designed to operate with request structures backing
> tasks; if you have to worry about this not being true, you'll generate a
> maze of special cases in the driver.

An excess of those already exist in the driver today :) :(

Maybe our driver initialization is the problem or maybe I am trying to do
too much. Here's how driver init is performed today in 2.6:

1. userspace does discovery, then passes this info down through an ioctl.
2. driver then uses this info to establish an iSCSI session. To accomplish this
we must do a login which requires a task tag. However, at this point there has not
been a request queue allocated and scsi-ml is not yet scanning.
3. session is established, so we scan away.

I think we could wait to establish a session, until a scan is actually initiated,
so we could do
1. from above.
2. initiate a scan.
3. in our slave_alloc if a session has not yet been established we could do this
there.

> 
>>Bascially, the host could allocate this map and it could be initialized 
>>to have start_tag/end_tag functions that are possibly transport specific 
>>(iSCSI has some magic tag values, but I do not know about spi or fc). 
>>this way if it needed to allocate tags before a queue is present (for 
>>logins for iscsi's case) then it could do so (this also means the tag 
>>must have some new structure becuase for normal populate_msg usage the 
>>msg is dependant on request properties). Then when blk_init_queue is 
>>finally called it can inherit the existing map structure with its 
>>function pointers.
> 
> 
> Tell me more about the magic tags.  We don't have a way to single them
> out currently, but that could be easily added by just marking them
> occupied in the bitmap.


For some operations the tag value can be 0xffffffff. This is just a reserved
value for special cases. For example if we send a NOP-out and set a valid tag
then this means we want a NOP-in back (a ping), but if the tag was set to
0xffffffff other side affects will result.


-- 
Mike Christie
mikenc@us.ibm.com

