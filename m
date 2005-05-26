From: "open_iscsi" <ESQuicksall_open_iscsi@Comcast.net>
Subject: Re: [PATCH RFC 2/2] implement transport scan callout for iscsi
Date: Wed, 25 May 2005 21:38:27 -0400
Message-ID: <003b01c56193$9e003e30$03031eac@ivivity.com>
References: <42936441.0b798bab.39a4.ffff9774SMTPIN_ADDED@mx.googlegroups.com> <42939610.3070104@cs.wisc.edu> <1116976678.7710.34.camel@mulgrave> <000b01c560c0$42c59700$03031eac@ivivity.com> <1116982816.7710.58.camel@mulgrave>  <4294972D.4030807@adaptec.com> <1117044247.5210.15.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="Windows-1252";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sccrmhc11.comcast.net ([204.127.202.55]:58251 "EHLO
	sccrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S261661AbVEZBi3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2005 21:38:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: open-iscsi@googlegroups.com, Mike Christie <michaelc@cs.wisc.edu>, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>

> c) The feature set it provides to Linux is identical to the feature set
> that dm-multipath provides.

There is a subtle difference and that has to do with sequencing the 
commands. If you have ORDERED commands and they arrive at the target out of 
order then they must be re-ordered at the target before presenting it to the 
SCSI layer. HOQ is in this arena too.

If the Queue Algorithm Modifier in the Control Mode Page is set to 0, then 
you also have to reorder the commands. The iSCSI target's reordering takes 
care of this too.

I'm sure you already know this, but if you get an abort task set at the MP 
layer, you will have to issue it on all paths for the simulated nexus. iSCSI 
MC/S takes care of this too. There may be some ordering rules here too but I 
can't remember.

There may be other reasons that I don't know which also require sequencing 
and the future may also have some requirements.

Eddy

----- Original Message ----- 
From: "James Bottomley" <James.Bottomley@SteelEye.com>
To: "Luben Tuikov" <luben_tuikov@adaptec.com>
Cc: "open_iscsi" <ESQuicksall_open_iscsi@Comcast.net>; 
<open-iscsi@googlegroups.com>; "Mike Christie" <michaelc@cs.wisc.edu>; 
"'SCSI Mailing List'" <linux-scsi@vger.kernel.org>
Sent: Wednesday, May 25, 2005 2:04 PM
Subject: Re: [PATCH RFC 2/2] implement transport scan callout for iscsi


>
> On Wed, 2005-05-25 at 11:18 -0400, Luben Tuikov wrote:
>> MC/S in iSCSI can be seen as a "wide port" in SAS.
>>
>> That is, commands are ordered, nexus is the same, going to the same port,
>> etc, etc, etc.  MC/S, has nothing to do with multipathing, which sits 
>> above
>> the nexus level.  With MC/S the nexus is the same.
>
> When I use the term "multi-pathing" I mean multiple virtual paths may be
> traversed to get a command from an application to a target device.
> Under that definition, dm-multipath, MC/S and even network bonding are
> all examples of multi-pathing.
>
> The visibility of the coding is what I have an issue with.  bonding
> could be inherited invisibly from the network but MC/S has to be
> explicitly coded in the software initiator whereas dm-multipath is done
> above the driver: one code base for all multi-path implementations.
>
>> MC/S is a good thing.
>
> a) It's optional, so you can't rely on it.
> b) it requires explicit coding in the driver which is a big negative
> since you can't leverage our existing multi-path code (i.e. more bug
> prone)
> c) The feature set it provides to Linux is identical to the feature set
> that dm-multipath provides.
>
> It's pointless to add support for an optional feature that provides no
> additional benefit (and its detrimental when the only addition is a
> potential negative impact to the code quality).
>
> James
>
> 

