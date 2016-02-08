From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: T10 adds locally assigned UUID designation descriptor
Date: Mon, 8 Feb 2016 15:04:14 -0500
Message-ID: <56B8F4BE.6050700@interlog.com>
References: <56B8D14D.7020502@interlog.com>
 <1454958000.2543.39.camel@HansenPartnership.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:33887 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219AbcBHUEU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Feb 2016 15:04:20 -0500
In-Reply-To: <1454958000.2543.39.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>
Cc: "Knight, Frederick" <Frederick.Knight@netapp.com>

On 16-02-08 02:00 PM, James Bottomley wrote:
> On Mon, 2016-02-08 at 12:33 -0500, Douglas Gilbert wrote:
>> Recently, in draft spc5r08, T10 added a locally assigned RFC 4122
>> UUID *** designation descriptor. That descriptor can now be
>> returned for VPD page 0x83 (device identification) amongst others.
>> It can be used anywhere SCSI needs a unique identifier expanding
>> the previous set of preferred identifiers: EUI, NAA and SCSI_name
>> (iSCSI).
>>
>> In the soon to be released sg3_utils version 1.42 the new UUID
>> designation descriptor is decoded including Hannes' --export
>> option found in sg_inq, for example:
>>
>> # sg_inq --export /dev/sg0
>>     ...
>>     SCSI_IDENT_LUN_UUID=11223344-5566-7788-aabb-ccddeeffffee
>>
>> Perhaps some udev work is needed to incorporate this new identifier.
>
> Hm, we're going to have to do this carefully.  With the move to GPT
> partitions, both the UUID= designator in fstab and the /dev/disk/by
> -uuid/ of udev means the GPT UUID.  In theory the design of the UUID
> space is to allow random selection without clashing, so we could just
> place the SCSI ones in here as well and perhaps there won't be a
> problem, but I'd like us to think about the consequences first.

The UUID proposal (16-005r1 from Fred Knight and "Dr. Hannes Reinecke")
was somewhat controversial with five T10 members voting against it. The
minutes state: "The members voting no stated concern that this proposal
may result in market confusion, and those members intend to develop
proposals to mitigate any confusion."

Locally assigned identifiers are not new: there already is an 8 byte
locally assigned NAA identifier (NAA=3). It is not much used, perhaps
the new locally assigned UUID (which is 16 bytes long) will find
more use. As for the 'sg_inq --export' naming, that seems to nail
down the context of the new UUID pretty well:
   SCSI_IDENT_[TARGET|PORT|LUN]_UUID
with the identifier itself in canonical UUID format. So there should
be no confusion there. And partitions are nested inside logical
units and SCSI does not define those (apart from on tapes).

Doug Gilbert


