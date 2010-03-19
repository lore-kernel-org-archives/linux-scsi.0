From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Bug 15565] SCSI Generic queueing completes commands in reverse
 order
Date: Fri, 19 Mar 2010 22:41:33 +0300
Message-ID: <4BA3D36D.3090108@vlnb.net>
References: <bug-15565-11613@http.bugzilla.kernel.org/> <201003181721.o2IHLAFg009271@demeter.kernel.org> <4BA26ABC.3000908@panasas.com> <4BA27F4B.5080807@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:57047 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab0CSTlH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Mar 2010 15:41:07 -0400
In-Reply-To: <4BA27F4B.5080807@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: Boaz Harrosh <bharrosh@panasas.com>, bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

Douglas Gilbert, on 03/18/2010 10:30 PM wrote:
>>> Hi Boaz,
>>>
>>>  > I have fixed that for bsg long ago. There is a flag
>>>  > that you put:
>>>  >     sg.flags = BSG_FLAG_Q_AT_TAIL;
>>>  > Which will do the by order, queue at tail. Zero was kept compatible
>>>  > to sg meaning "queue at head" i.e. jump the line.
>>>  > 
>>>  > It could be added to sg as well if needed
>>>
>>> I think that would be a huge improvement for disk drives.
>>>
>>> Isn't BSG driven with a blocking ioctl?  Maybe I'm using old docs, but
>>> from the HOWTO's I've read, I was under the impression it would issue
>>> one SCSI command at a time and block until it completed.  Queueing
>>> would effectively only be possible then with multiple threads, right?
>>>
>> There is a way to do write with multiple ios at once and then
>> do reads to get return status. (I have untested code that does
>> that but never needed it so badly as to finish it. But I know
>> of other people that did it)
>>
>> bsg does not have all these mmap/shared buffers options like
>> sg does, though. Hell not even AIOs.
>>
>>> Since sg allows multiple (only 16 right now) ios to be queued
>>> nonblocking to a block device from a single threaded process,
>>> an SG_FLAG_Q_AT_TAIL flag would seem particularly relevant.
>>>
>> Yes. Currently the queue of 16 does nothing because in effect the
>> Kernel will completely drain the Q on each "Q_AT_HEAD". So the Q
>> does nothing for IO with current sg.
>>
>>> Nonblocking behavior is the primary reason why I am using sg... it
>>> seems really inefficient and complex to use dozens of threads and ipc
>>> just to try to submit a queue of ios to the kernel and hence a device.
>>>
>> There are surely other ways to do AIO, no?
>> (The A in AIO stands for Asynchronous)
>>
>>> If bsg actually allowed tasks to be queued nonblocking like sg, I'd
>>> switch in a heart beat since having two filesystem names for the same
>>> device introduces locking problems, name translation complexity, and
>>> confusion in general for administrators.
>>>
>> Well bsg has it's own naming translation. You do not use /dev/sdX1. You
>> need to open the bsg char-device corresponding the particular scsi-device
> 
> What might be useful is to tell the sd driver not to hook
> a particular logical unit with peripheral device type 0
> (i.e. a disk). Perhaps this could be done via the LU
> UUID. That way udev (?) would be less tempted to send
> crap commands to the device at random times.
> 
> After that you only have to worry about the device node
> duality between bsg and sg :-)
> They are pretty well behaved, only sending commands when
> they are asked to.
> 
> 
> Adding a SG_FLAG_Q_AT_TAIL flag to sg seems like a
> good idea.

Great so see the problem confirmed and it's going to move! I and other 
people have been asking this for 3 (or 4?) years and have had a silence 
in reply. It hasn't even been confirmed, so I'd prepare a patch.

Eventually, this should be fixed.

Vlad

