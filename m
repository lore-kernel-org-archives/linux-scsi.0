From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [LSF/MM TOPIC] linux servers as a storage server - what's missing?
Date: Wed, 18 Jan 2012 12:51:41 -0500
Message-ID: <4F1706AD.3080405@redhat.com>
References: <4EF2026F.2090506@redhat.com> <CAL1RGDVvSbOjvCFWDSYLm4xRvKftM5OhwEf9pMGrJhjJHxzsaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932252Ab2ARRyD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jan 2012 12:54:03 -0500
In-Reply-To: <CAL1RGDVvSbOjvCFWDSYLm4xRvKftM5OhwEf9pMGrJhjJHxzsaA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>
Cc: linux-fsdevel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 01/18/2012 12:00 PM, Roland Dreier wrote:
> On Wed, Dec 21, 2011 at 7:59 AM, Ric Wheeler<rwheeler@redhat.com>  wrote:
>> One common thing that I see a lot of these days is an increasing number of
>> platforms that are built on our stack as storage servers. Ranging from the
>> common linux based storage/NAS devices up to various distributed systems.
>>   Almost all of them use our common stack - software RAID, LVM, XFS/ext4 and
>> samba.
>>
>> At last year's SNIA developers conference, it was clear that Microsoft is
>> putting a lot of effort into enhancing windows 8 server as a storage server
>> with both support for a pNFS server and of course SMB. I think that linux
>> (+samba) is ahead of the windows based storage appliances today, but they
>> are putting together a very aggressive list of features.
>>
>> I think that it would be useful and interesting to take a slot at this
>> year's LSF to see how we are doing in this space. How large do we need to
>> scale for an appliance?  What kind of work is needed (support for the copy
>> offload system call? better support for out of band notifications like those
>> used in "thinly provisioned" SCSI devices? management API's? Ease of use CLI
>> work? SMB2.2 support?).
>>
>> The goal would be to see what technical gaps we have that need more active
>> development in, not just a wish list :)
> I see a technical gap in the robustness of our basic SCSI/block stack.  In a
> pretty standard low to midrange setup, ie standard server with a couple of SAS
> HBAs connected to an external SAS JBOD, it's quite easy to run into problems
> like oopses or other issues that kill the whole system, even from faults that
> should affect only part of the system.  For example losing one path to the JBOD,
> or losing one drive, or having a SCSI reservation conflict can lead to the whole
> system crashing.
>
> Which is not good for an HA storage server built on redundant hardware.
>
>   - R.

Why would you crash is you have device mapper multipath configured to handle 
path fail over? We have tons of enterprise customers that use that...

On the broader topic of error handling and so on, I do agree that is always an 
area of concern (how many times to retry, how long time outs need to be, when to 
panic/reboot or propagate up an error code)

ric

