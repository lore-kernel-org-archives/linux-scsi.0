From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: Blacklist flags for SCSI target vs. SCSI LUN
Date: Wed, 22 Feb 2006 20:52:01 -0800
Message-ID: <06D63F45-3FD0-4871-BA3F-D5867A6D2FDA@ieee.org>
References: <Pine.LNX.4.44L0.0602221609580.9277-100000@iolanthe.rowland.org>
Mime-Version: 1.0 (Apple Message framework v746.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc11.comcast.net ([216.148.227.151]:53153 "EHLO
	rwcrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S1751032AbWBWEwG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2006 23:52:06 -0500
In-Reply-To: <Pine.LNX.4.44L0.0602221609580.9277-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

>> Working from comments, not yet grep, ...
>> ...
>> a) Mysteries: ... BLIST_NOSTARTONADD ... BLIST_BORKEN ...  
>> BLIST_KEY ... BLIST_NO_ULD_ATTACH ... BLIST_SELECT_NO_ATN ...
>> ...
>> b) Scsi Simplifications:
>>
>>>> 12 #define BLIST_NOTQ              0x020   /* Buggy Tagged  
>>>> Command  Queuing */
>>>> ...
>>
>> NOTQ is for all requests
>
> All requests to the LUN or to the target?

All requests to the target was my guess, though clicking thru  
BLIST_NOTQ might tell us more ...

> Are tagged requests for different LUNs on the same target handled  
> separately?

Suppose instead we ask, are requests for different Lba's on the same  
memory card handled separately?

We'd give the same answer: usually not, but in general it depends.   
Yes the device may choose to react arbitrarily to any bits that  
distinguish one request from another.

Only some devices accept multiple tagged requests simultaneously,  
only some devices have multiple Lun's, only some devices service  
different Lun's independently.  Combine all those only's, and we  
don't visit this corner often.  But on visiting this corner might we  
then find that a device handled tags differently for one Lun than for  
another?  Yes, we might, because "an address bit is an address bit is  
an address bit"

> ... could there be simultaneous outstanding requests having the  
> same tag value because they are for separate LUNs?

That answer varies by transport ... and varies by host for most  
transports?

Usually the host does the work of acquiring a distinct tag to  
construct each request and releasing the tag for reuse only after  
completing a request.  If the host acquires tags from a pool per  
device, then each incomplete request has a distinct tag.  If the host  
acquires tags from a pool per Lun, then each incomplete request of  
the Lun has a distinct tag, but requests of the device may collide.

The merely standard definition of BBB transport of Scsi in Usb, for  
example, runs only one request at a time thru the wire, so colliding  
tags hurt only the host, never the device.  Vendor-specific  
definitions then vary over whether the bits of the Lun do or do not  
extend the tag to avoid collision.

The T10.org Sam (Scsi Architectural Model) probably has opinions,  
while the other Scsi definitions are incomplete, in disagreement, or  
unstated.

Am I making much sense yet?  Does logic not force these answers on us?
