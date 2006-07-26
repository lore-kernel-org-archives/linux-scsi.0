From: Douglas Gilbert <dougg@torque.net>
Subject: Re: fibre channel sync cache question
Date: Tue, 25 Jul 2006 23:51:35 -0400
Message-ID: <44C6E6C7.8090606@torque.net>
References: <664A4EBB07F29743873A87CF62C26D70248ED4@NAMAIL4.ad.lsil.com> <1153867194.8932.66.camel@laptopd505.fenrus.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:13271 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1030377AbWGZDvx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jul 2006 23:51:53 -0400
In-Reply-To: <1153867194.8932.66.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Moore, Eric" <Eric.Moore@lsil.com>, James Smart <James.Smart@Emulex.Com>, linux-scsi@vger.kernel.org, Michael Reed <mdr@sgi.com>

Arjan van de Ven wrote:
> On Tue, 2006-07-25 at 16:28 -0600, Moore, Eric wrote:
>> -- Tuesday, July 25, 2006 4:22 PM, Michael Reed wrote: 
>>
>>> Using fibre channel disks, I've noticed that when the system 
>>> shuts down
>>> that the sd_driver issues a sync cache command to the device. 
>>>  I've also
>>> noticed that when the lldd is removed via rmmod that this 
>>> sync cache is
>>> not executed.  I would think that the sync cache would be desirable
>>> under this circumstance.
>>>
>> This is not handled from sg path as well.  Meaning if you
>> use sdparm, and enable the caching page WCE bit, then reboot,
>> there is no SYNC cache issued from above. 
>>
>> We handle this in fusion drivers due to short coming from above.
> 
> 
> Hi,
> 
> that sounds sooo like the wrong approach... wouldn't it be better to fix
> sg instead?

Uh? sg is just a pass through. As such it can subvert
policy decisions of the kernel. That isn't always a
bad thing :-)

The design flaw is any driver that tries to maintain a
state variable associated with a device (logical unit)
and can't cope with situations when it gets out of sync.
If you managed to neuter the pass through, how would you
cope with another initiator?

Doug Gilbert
