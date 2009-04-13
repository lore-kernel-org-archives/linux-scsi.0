From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: [Announce] sg3_utils-1.27 available
Date: Sun, 12 Apr 2009 20:08:25 -0800 (AKDT)
Message-ID: <alpine.LNX.2.01.0904122005300.846@filesrv1.baby-dragons.com>
References: <49E152F8.2020304@interlog.com> <alpine.LNX.2.01.0904111917520.7984@filesrv1.baby-dragons.com> <49E2A915.9070901@interlog.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns3.baby-dragons.com ([204.91.156.41]:36663 "EHLO
	ns3.baby-dragons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbZDMEIa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2009 00:08:30 -0400
In-Reply-To: <49E2A915.9070901@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

 	Hello Doug ,

On Sun, 12 Apr 2009, Douglas Gilbert wrote:
> Mr. James W. Laferriere wrote:
>>     Hello Doug ,  I thought sometime ago I'd mentioned the lack of support 
>> for device name(actuall filename) expansion in these tools .
>>     I am aware that a simple 'for do' loop would acomplish the same thing 
>> but that requires writing a script/function in order to do something that 
>> bash/ksh/.../??? has had available for quite sometime now .
>>     Would you please entertain the request to add the ability to use shell 
>> expansion of file expansion in the sg3 tools ?
>
> Jim,
> sginfo is particularly difficult due to its syntax:
>   sginfo [OPTIONS] [DEVICE] [REPLACEMENT_PARAMETERS]
>
> In the worst case it would be hard to distinguish
> between an additional DEVICE and the replacement
> parameters. As noted in its man page sginfo is a port
> of Eric Youngdale's scsiinfo utility. I regard sginfo as
> in legacy mode and suggest people use sdparm instead.

 	Ok ,  I see the problem(s) .

> And sdparm does what you want, its syntax is:
>   sdparm [OPTIONS] DEVICE [DEVICE...]
> That was done in response to a request from you!

 	I thought we had discussed this sometime ago ,  Just getting early 
old'timers :) .  It helped me very much in a previous life .

> Currently all the utilities in sg3_utils only support
> one device. In the sg3_utils/scripts directory are bash
> script examples, some of which do want you want.
> Even after cleaning up the option processing in sg3_utils
> with getopt_long() it only takes a small flourish to
> cause problems if multiple device names are allowed. For
> example, sg_start can be used to spin down a disk with
> either:
>    sg_start --stop /dev/sdc
>    sg_start 0 /dev/sdc
> Now the second invocation becomes ambiguous if multiple
> device names are allowed and there is a device name called
> "0" in the current directory.
>
> Some utilities are already dangerous, even when they look
> safe. Allowing multiple file names compounds the danger.
> For example, some SCSI commands are quite creative with
> their use of zero. If multiple devices were allowed, do
> not try this:
>  sg_write_same --num=0 /dev/sd*

 	Same as above ,  I'm finally seeing the light .

> Doug Gilbert
 		Tnx ,  JimL
-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 2133    McCullam Ave |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99701 |   only  on  AXP |
+------------------------------------------------------------------+
