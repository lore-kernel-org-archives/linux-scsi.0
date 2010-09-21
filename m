From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH] sd name space exhaustion causes system hang
Date: Tue, 21 Sep 2010 12:16:08 -0500
Message-ID: <4C98E858.9040909@sgi.com>
References: <4C9789C6.7080601@sgi.com> <4C98CA74.7060500@suse.de> <4C98D632.8020000@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.179.29]:48802 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756272Ab0IURQJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2010 13:16:09 -0400
In-Reply-To: <4C98D632.8020000@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jeremy Higdon <jeremy@sgi.com>, Tony Ernst <tee@sgi.com>



On 09/21/2010 10:58 AM, Michael Reed wrote:
> 
> 
> On 09/21/2010 10:08 AM, Hannes Reinecke wrote:
>> Michael Reed wrote:
>>> Following a site power outage which re-enabled all the ports on my FC
>>> switches, my system subsequently booted with far too many luns!  I had
>>> let it run hoping it would make multi-user.  It didn't.  :(  It hung solid
>>> after exhausting the last sd device, sdzzz, and attempting to create sdaaaa
>>> and beyond.  I was unable to get a dump.
>>>
>>> Discovered using a 2.6.32.13 based system.
>>>
>>> Patch at the bottom corrects this by detecting when the last index is
>>> utilized and failing the sd probe of the device.  Patch applies to
>>> scsi-misc-2.6.
>>>
>> Hmm. Shouldn't we rather use dynamic majors once we're over
>> SD_MAJORS? We do have enough space in the 'index' field and the name
>> is generated dynamically anyway ...
> 
> A bit beyond the scope of what I was trying to correct.  And beyond my
> current knowledge of how things work.  If you'd care to guide me, or
> provide me a patch for testing....  I can probably get my config up to
> 30,000 or so luns.
> 
> Mike

Have we exhausted SD_MAJORS when SD_MAX_DISKS is exhausted?  I don't
think so.

        gd->major = sd_major((index & 0xf0) >> 4);
        gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
        gd->minors = SD_MINORS;

There appear to be 16 majors allocated.  SD_MINORS is also 16.  Minors
are used for partitions, right?  The number of sd devices assigned to a
major is the max number of minors / SD_MINORS.  It appears that a minor
number is 20 bits.  That corresponds to 1,048,576 minors per major.
Dividing by 16 minors per device leaves us with 65536 sd devices which
can be assigned to a major number.

As the sd namespace is currently limited to 18,xxx devices, I don't believe
we've filled all the sd major numbers which are allocated.  16 * 65536 =
1,048,576 possible sd devices.

If this is correct, I see no reason to convert the code to dynamic majors
as it's really quite doubtful that all possible sd devices will ever be
created on a system.

Mike


> 
>>
>> Cheers,
>>
>> Hannes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
