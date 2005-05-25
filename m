From: "open_iscsi" <ESQuicksall_open_iscsi@Comcast.net>
Subject: Re: [PATCH RFC 2/2] implement transport scan callout for iscsi
Date: Tue, 24 May 2005 21:28:18 -0400
Message-ID: <001101c560c9$0870f280$03031eac@ivivity.com>
References: <42936441.0b798bab.39a4.ffff9774SMTPIN_ADDED@mx.googlegroups.com> <42939610.3070104@cs.wisc.edu> <1116976678.7710.34.camel@mulgrave> <000b01c560c0$42c59700$03031eac@ivivity.com> <1116982816.7710.58.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="Windows-1252";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc13.comcast.net ([204.127.198.39]:419 "EHLO
	rwcrmhc13.comcast.net") by vger.kernel.org with ESMTP
	id S262227AbVEYB2U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 21:28:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: open-iscsi@googlegroups.com, Mike Christie <michaelc@cs.wisc.edu>, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>

But it is not multi-pathing. Multi-pathing belongs at a higher layer.

Yes, you could make multi-pathing perform a similar action but being at a 
higher layer, it means more operations to achieve the same thing. Also, 
multi-pathing is better suited for failover than multi-connections.

There is another point here ... an HBA will probably use multi-connections 
irrespective of what higher layers want.

Regarding the numbers, we get 400,000 IOPS with our hardware solution using 
multiple connections and multiple micro-engines. I have not tried 
multi-pathing but I can tell you that I had to count clocks to get that 
number and found that even a few extra clocks could mean a lot. So since 
multi-pathing takes a lot of extra clocks, then I think there is a benefit. 
However with a software solution the extra clocks for the multi-pathing may 
not be significant.

I would think that you would want to let the lower layers do their best to 
get the best thruput and leave the failover logic to the upper layers.

Eddy

----- Original Message ----- 
From: "James Bottomley" <James.Bottomley@SteelEye.com>
To: "open_iscsi" <ESQuicksall_open_iscsi@Comcast.net>
Cc: <open-iscsi@googlegroups.com>; "Mike Christie" <michaelc@cs.wisc.edu>; 
"'SCSI Mailing List'" <linux-scsi@vger.kernel.org>
Sent: Tuesday, May 24, 2005 9:00 PM
Subject: Re: [PATCH RFC 2/2] implement transport scan callout for iscsi


> On Tue, 2005-05-24 at 20:25 -0400, open_iscsi wrote:
>> The MC/S feature of iSCSI is not multi-pathing. Multi-pathing would be 
>> the
>> use of multiple sessions to reach the same target. Generally the two
>> sessions would use the same InitiatorName+ISID but use different Target
>> Portal Groups at the target. In SCSI terms, it is the same initiator
>> accessing different SCSI ports.
>
> Well, yes, every driver vendor with a multi-path solution in-driver that
> made a single presentation to the mid-layer has argued that one...
>
> The bottom line is that implementation must be in-driver.  So every
> driver doing it this way has to have their own separate multi-path
> implementation.  Whether you call it FC/AL or MC/S (or any of the other
> buzz acronyms) it's still a driver implementation of pathing.
>
>> MC/S can be used to improve band width of a session without using
>> multi-pathing and it belongs in the driver because it is hidden from the
>> upper layers. Think of it like parallel wires, each carrying separate 
>> (but
>> sequenced) commands in parallel.
>
> So far, no-one has been able to produce any figures to show that MC/S is
> significantly better than symmetric active dm-multipath to an iSCSI
> target, but if you have them, please publish them.
>
> Hiding something from the upper layers which the upper layers could do
> equally well themselves is what's considered wrong: it adds code bloat
> with no tangible benefit.
>
> James
>
> 

