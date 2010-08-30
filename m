From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
Date: Tue, 31 Aug 2010 00:34:32 +0400
Message-ID: <4C7C15D8.1060000@vlnb.net>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <4C6540C5.8070108@vlnb.net> <4C6546E0.7070208@kernel.org> <4C6C34E0.3050601@vlnb.net> <4C6CFEAA.1060004@kernel.org> <4C7B7FC3.1050701@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4C7B7FC3.1050701@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Tejun Heo <tj@kernel.org>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, jack@suse.cz, rwheeler@redhat.com
List-Id: linux-scsi@vger.kernel.org

Hannes Reinecke, on 08/30/2010 01:54 PM wrote:
>> As I've wrote multiple times, I'm pretty skeptical it will bring much.
>> Ordered tag mandates draining inside the device just like the original
>> barrier implementation.  Sure, it's done at a lower layer and command
>> issue latencies will be reduced thanks to that but ordered-by-waiting
>> doesn't require _any_ draining at all.  The whole pipeline can be kept
>> full all the time.  I'm often wrong tho, so please feel free to go
>> ahead and prove me wrong.  :-)
>>
> Actually, I thought about ordered tag writes, too.
> But eventually I had to give up on this for a simple reason:
> Ordered tag controls the ordering on the SCSI _TARGET_. But for a
> meaningful implementation we need to control the ordering all the way
> down from ->queuecommand(). Which means we have three areas we need
> to cover here:
> - driver (ie between ->queuecommand() and passing it off to the firmware)
> - firmware
> - fabric
>
> Sadly, the latter two are really hard to influence. And, what's more,
> with the new/modern CNAs with multiple queues and possible multiple
> routes to the target it becomes impossible to guarantee ordering.
> So using ordered tags for FibreChannel is not going to work, which
> makes implementing it a bit of a pointless exercise for me.

The situation is, actually, much better than you think. An SCSI 
transport should provide an in-order delivery of commands. In some 
transports it is required (e.g. iSCSI), in some - optional (e.g. FC). 
For FC "an application client may determine if a device server supports 
the precise delivery function by using the MODE SENSE and MODE SELECT 
commands to examine and set the enable precise delivery checking (EPDC) 
bit in the Fibre Channel Logical Unit Control page" (Fibre Channel 
Protocol for SCSI (FCP)). You can find more details in FCP section 
"Precise delivery of SCSI commands".

Regarding multiple queues, in case of a multipath access to a device 
SCSI requires either each path be a separate I_T nexus, where order of 
commands is maintained, or a transport required to maintain in-order 
commands delivery among multiple paths in a single I_T nexus (session) 
as it is done in iSCSI's MC/S and, most likely, wide SAS ports.

So, everything is in the specs. We only need to use it properly. How it 
can be done on the drivers level as well as how errors recovery can be 
done using ACA and UA_INTLCK facilities I wrote few weeks ago in the 
"[RFC] relaxed barrier semantics" thread.

Vlad
