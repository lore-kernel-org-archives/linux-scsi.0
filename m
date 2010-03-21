From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15565] SCSI Generic queueing completes commands in reverse
 order
Date: Sun, 21 Mar 2010 11:46:31 GMT
Message-ID: <201003211146.o2LBkV8G015009@demeter.kernel.org>
References: <bug-15565-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33480 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab0CULqb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Mar 2010 07:46:31 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2LBkVdE015011
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 21 Mar 2010 11:46:31 GMT
In-Reply-To: <bug-15565-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=15565





--- Comment #10 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2010-03-21 11:46:27 ---
Reply-To: bharrosh@panasas.com

On 03/19/2010 10:57 PM, Michael Reed wrote:
> 
> 
> Vladislav Bolkhovitin wrote:
>> Douglas Gilbert, on 03/18/2010 10:30 PM wrote:
>>>>> Hi Boaz,
>>>>>
>>>>>  > I have fixed that for bsg long ago. There is a flag
>>>>>  > that you put:
>>>>>  >     sg.flags = BSG_FLAG_Q_AT_TAIL;
>>>>>  > Which will do the by order, queue at tail. Zero was kept compatible
>>>>>  > to sg meaning "queue at head" i.e. jump the line.
>>>>>  > 
>>>>>  > It could be added to sg as well if needed
>>>>>
>>>>> I think that would be a huge improvement for disk drives.
>>>>>
>>>>> Isn't BSG driven with a blocking ioctl?  Maybe I'm using old docs, but
>>>>> from the HOWTO's I've read, I was under the impression it would issue
>>>>> one SCSI command at a time and block until it completed.  Queueing
>>>>> would effectively only be possible then with multiple threads, right?
>>>>>
>>>> There is a way to do write with multiple ios at once and then
>>>> do reads to get return status. (I have untested code that does
>>>> that but never needed it so badly as to finish it. But I know
>>>> of other people that did it)
>>>>
>>>> bsg does not have all these mmap/shared buffers options like
>>>> sg does, though. Hell not even AIOs.
>>>>
>>>>> Since sg allows multiple (only 16 right now) ios to be queued
>>>>> nonblocking to a block device from a single threaded process,
>>>>> an SG_FLAG_Q_AT_TAIL flag would seem particularly relevant.
>>>>>
>>>> Yes. Currently the queue of 16 does nothing because in effect the
>>>> Kernel will completely drain the Q on each "Q_AT_HEAD". So the Q
>>>> does nothing for IO with current sg.
>>>>
>>>>> Nonblocking behavior is the primary reason why I am using sg... it
>>>>> seems really inefficient and complex to use dozens of threads and ipc
>>>>> just to try to submit a queue of ios to the kernel and hence a device.
>>>>>
>>>> There are surely other ways to do AIO, no?
>>>> (The A in AIO stands for Asynchronous)
>>>>
>>>>> If bsg actually allowed tasks to be queued nonblocking like sg, I'd
>>>>> switch in a heart beat since having two filesystem names for the same
>>>>> device introduces locking problems, name translation complexity, and
>>>>> confusion in general for administrators.
>>>>>
>>>> Well bsg has it's own naming translation. You do not use /dev/sdX1. You
>>>> need to open the bsg char-device corresponding the particular scsi-device
>>> What might be useful is to tell the sd driver not to hook
>>> a particular logical unit with peripheral device type 0
>>> (i.e. a disk). Perhaps this could be done via the LU
>>> UUID. That way udev (?) would be less tempted to send
>>> crap commands to the device at random times.
>>>
>>> After that you only have to worry about the device node
>>> duality between bsg and sg :-)
>>> They are pretty well behaved, only sending commands when
>>> they are asked to.
>>>
>>>
>>> Adding a SG_FLAG_Q_AT_TAIL flag to sg seems like a
>>> good idea.
>>
>> Great so see the problem confirmed and it's going to move! I and other 
>> people have been asking this for 3 (or 4?) years and have had a silence 
>> in reply. It hasn't even been confirmed, so I'd prepare a patch.
>>
>> Eventually, this should be fixed.
>>
>> Vlad
> 
> 
> We're looking at supporting a non-disk scsi device which can effectively
> process a queue depth of nine in parallel.  Having our application access
> the hardware via the "sg" device is our first choice on how to proceed.
> 
> My reading of this thread indicates that the 9 parallel commands we'll
> issue will be effectively single threaded by the kernel due to their
> being queued at the head of the queue.
> 
> I'd like to encourage the implementation of SG_FLAG_Q_AT_TAIL for
> sg devices.
> 

Why not use bsg, then?

> Mike

Boaz

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
