From: Michael Reed <mdr@sgi.com>
Subject: Re: fibre channel sync cache question
Date: Wed, 26 Jul 2006 13:20:25 -0500
Message-ID: <44C7B269.4070505@sgi.com>
References: <664A4EBB07F29743873A87CF62C26D70248ED4@NAMAIL4.ad.lsil.com> <1153867194.8932.66.camel@laptopd505.fenrus.org> <44C6E6C7.8090606@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:44481 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1751737AbWGZSUo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Jul 2006 14:20:44 -0400
In-Reply-To: <44C6E6C7.8090606@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Arjan van de Ven <arjan@infradead.org>, "Moore, Eric" <Eric.Moore@lsil.com>, James Smart <James.Smart@Emulex.Com>, linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> Arjan van de Ven wrote:
>> On Tue, 2006-07-25 at 16:28 -0600, Moore, Eric wrote:
>>> -- Tuesday, July 25, 2006 4:22 PM, Michael Reed wrote:
>>>> Using fibre channel disks, I've noticed that when the system shuts down
>>>> that the sd_driver issues a sync cache command to the device.  I've
>>>> also
>>>> noticed that when the lldd is removed via rmmod that this sync cache is
>>>> not executed.  I would think that the sync cache would be desirable
>>>> under this circumstance.
>>>>
>>> This is not handled from sg path as well.  Meaning if you
>>> use sdparm, and enable the caching page WCE bit, then reboot,
>>> there is no SYNC cache issued from above.
>>> We handle this in fusion drivers due to short coming from above.
>>
>>
>> Hi,
>>
>> that sounds sooo like the wrong approach... wouldn't it be better to fix
>> sg instead?
> 
> Uh? sg is just a pass through. As such it can subvert
> policy decisions of the kernel. That isn't always a
> bad thing :-)
> 
> The design flaw is any driver that tries to maintain a
> state variable associated with a device (logical unit)
> and can't cope with situations when it gets out of sync.
> If you managed to neuter the pass through, how would you
> cope with another initiator?

Perhaps the best policy for sd is to assume that WCE is enabled
and just issue the sync cache.

--

I'm wondering about the policy of issuing a sync cache.  There
are target removal paths which result in it not being issued.

So, the real question is: when a scsi target is removed, is it
policy that sync cache will be issued?

In fibre channel, here are two code paths in which sync cache
is not issued.

	- removal of LLDD (rmmod)
	- removal of target via sysfs device/delete

In a closer look at the target removal via sysfs device/delete,
I observe that portions of the sysfs fc_remote_ports/rport-*
remain in place.

Do we need to tie the device/delete to the transport?

Can of worms?  Close eyes, run screaming?

Mike


> 
> Doug Gilbert
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
