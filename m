From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v2.5 3/6] scsi_debug: add multiple queue support
Date: Mon, 2 May 2016 11:35:03 -0400
Message-ID: <572773A7.8020000@interlog.com>
References: <1462070687-12689-1-git-send-email-dgilbert@interlog.com>
 <1462070687-12689-4-git-send-email-dgilbert@interlog.com>
 <57271169.8020204@suse.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:49206 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963AbcEBPfQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 May 2016 11:35:16 -0400
In-Reply-To: <57271169.8020204@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com, bart.vanassche@sandisk.com

On 2016-05-02 04:35 AM, Hannes Reinecke wrote:
> On 05/01/2016 04:44 AM, Douglas Gilbert wrote:
>> Add submit_queue parameter (minimum and default: 1; maximum:
>> nr_cpu_ids) that controls how many queues are built, each with
>> their own lock and in_use bit vector. Add statistics parameter
>> which is default on.
>>
>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>> ---
>>   drivers/scsi/scsi_debug.c | 680 +++++++++++++++++++++++++++++-----------------
>>   1 file changed, 426 insertions(+), 254 deletions(-)
>>
> Two general questions for this:
>
> - Why do you get rid of the embedded command payload?

I'm not sure what payload you a referring to. And this patch
only adds multiple queues, I can't see that it removes anything.

>    Where's the benefit of allocating the commands yourself?

The commands are either replied to "in thread" (e.g. when delay=0
or an error is detected), or queued on a hr timer or work item.
A pointer to the command is held in the queue (the same as before
this patch). The only allocations associated with commands are to
build data-in buffers for responses. (e.g. an INQUIRY command for
a VPD page).

> - Wouldn't it be better to move to a per-cpu structure per queue?
>    Each queue will be tacked to a CPU anyway, so you could be using
>    per-cpu structures. Otherwise you'll run into synchronization
>    issues, and any performance gain you might get from scsi-mq is
>    lost as you to synchronize on the lower level.

I offer this patch as being necessary, but probably not sufficient
for implementing full scsi "mq". The interface itself for
scsi/block mq does not seem to be documented and is possibly in a
state of flux.

 From testing this patch (e.g. by observing
"cat /proc/scsi/scsi_debug/<host_num>" while fio is running, the
CPU affinity is very good without any per-cpu magic ***. The
"misqueues" count (that is (cpu) miscues on queues) records the
number of times a timer or a workqueue gets its callback on a
different cpu, is extremely low, typically zero. I could get
non-zero numbers if I ran something else (e.g. a kernel build)
while fio was running, still the misqueues were well under 1% of
commands queued.

That said, I see very little performance improvement with
submit_queues=4 (the number of processors on my two test machines)
compared to submit_queues=1 which is effectively what the driver was
doing before this patch. So I'm open to suggestions, especially in
the form of code :-)


Also if we went for per-cpu structures should we worry about the
complex issue of a cpu being hot unplugged (or plugged back in)
while its queue was holding unfinished commands?

Doug Gilbert


*** you are probably correct that without the per-cpu "magic" lock
     contention is likely the cause of so little performance
     improvement in the multiple submit queues case.
     Also while testing with fio, submit_queues=<num_of_cpus>,
     'top -H' shows each fio thread at around 100%.


