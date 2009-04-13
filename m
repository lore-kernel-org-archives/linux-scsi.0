From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [Announce] sg3_utils-1.27 available
Date: Sun, 12 Apr 2009 22:53:09 -0400
Message-ID: <49E2A915.9070901@interlog.com>
References: <49E152F8.2020304@interlog.com> <alpine.LNX.2.01.0904111917520.7984@filesrv1.baby-dragons.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:50416 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbZDMCxR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Apr 2009 22:53:17 -0400
In-Reply-To: <alpine.LNX.2.01.0904111917520.7984@filesrv1.baby-dragons.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Mr. James W. Laferriere wrote:
>     Hello Doug ,  I thought sometime ago I'd mentioned the lack of 
> support for device name(actuall filename) expansion in these tools .
>     I am aware that a simple 'for do' loop would acomplish the same 
> thing but that requires writing a script/function in order to do 
> something that bash/ksh/.../??? has had available for quite sometime now .
>     Would you please entertain the request to add the ability to use 
> shell expansion of file expansion in the sg3 tools ?

Jim,
sginfo is particularly difficult due to its syntax:
    sginfo [OPTIONS] [DEVICE] [REPLACEMENT_PARAMETERS]

In the worst case it would be hard to distinguish
between an additional DEVICE and the replacement
parameters. As noted in its man page sginfo is a port
of Eric Youngdale's scsiinfo utility. I regard sginfo as
in legacy mode and suggest people use sdparm instead.

And sdparm does what you want, its syntax is:
    sdparm [OPTIONS] DEVICE [DEVICE...]
That was done in response to a request from you!

Currently all the utilities in sg3_utils only support
one device. In the sg3_utils/scripts directory are bash
script examples, some of which do want you want.
Even after cleaning up the option processing in sg3_utils
with getopt_long() it only takes a small flourish to
cause problems if multiple device names are allowed. For
example, sg_start can be used to spin down a disk with
either:
     sg_start --stop /dev/sdc
     sg_start 0 /dev/sdc
Now the second invocation becomes ambiguous if multiple
device names are allowed and there is a device name called
"0" in the current directory.

Some utilities are already dangerous, even when they look
safe. Allowing multiple file names compounds the danger.
For example, some SCSI commands are quite creative with
their use of zero. If multiple devices were allowed, do
not try this:
   sg_write_same --num=0 /dev/sd*


Doug Gilbert

