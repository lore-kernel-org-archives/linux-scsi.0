From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Who do we point to?
Date: Wed, 27 Aug 2008 22:17:15 +0400
Message-ID: <48B59A2B.7040207@vlnb.net>
References: <200808201911.m7KJBTik015082@wind.enjellic.com>	 <48AD5C14.6050508@vlnb.net> <1219329139.3265.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1219329139.3265.17.camel@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: greg@enjellic.com, scst-devel@lists.sourceforge.net, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, linuxraid@amcc.com, neilb@suse.de, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Thu, 2008-08-21 at 16:14 +0400, Vladislav Bolkhovitin wrote:
>> MOANING MODE ON
>>
>> Testing SCST and target drivers I often have to deal with various 
>> failures and with how initiators recover from them. And,
>> unfortunately, 
>> my observations on Linux aren't very encouraging. See, for instance, 
>> http://marc.info/?l=linux-scsi&m=119557128825721&w=2 thread.
>> Receiving 
>> from the target TASK ABORTED status isn't really a failure, it's
>> rather 
>> a corner case behavior, but it leads to immediate file system errors
>> on 
>> initiator and then after remount ext3 journal replay doesn't
>> completely 
>> repair it, only manual e2fsck helps. Even mounting with barrier=1 
>> doesn't improve anything. Target can't be blamed for the failure, 
>> because it stayed online, all its cache fully healthy and no commands 
>> were lost. Hence, apparently, the journaling code in ext3 isn't as 
>> reliable in face of storage corner cases as it's thought. I haven't 
>> tried that test since I reported it, but recently I've seen the
>> similar 
>> ext3 failures on 2.6.26 in other tests, so I guess the problem(s)
>> still 
>> there.
>>
>> A software SCSI target, like SCST, is beautiful to test things like 
>> that, because it allows easily simulate any possible corner case and 
>> storage failure. Unfortunately, I don't work on file systems level
>> and 
>> can't participate in all that great testing and fixing effort. I can 
>> only help with setup and assistance in failures simulations.
>>
>> MOANING MODE OFF
> 
> Well, since I can see your just so anxious to stop moaning and get
> coding, let me help you.
> 
> Firstly, from a standards point of view, TASK_ABORTED means that the
> target is telling us this particular command was killed by another
> initiator (seeing this also requires the TAS bit to be set in the
> control mode page, so you can easily fix your current problem by
> unsetting it).  This makes TASK_ABORTED an incredibly rare status
> condition (hence the problems below).
> 
> The way the kernel currently handles it is to return SUCCESS (around
> line 1411 in scsi_error.c).  This return actually propagates an I/O
> error all the way up the stack.  If the filesystem is the consumer, then
> how it handles the error depends on what you have the errors= switch set
> to.  If you've got it set to a safety condition like remount-ro or
> panic, then the fs should be recoverable on reboot (or unmount recheck).
> If you have it set to something unsafe like continue, then yes, you're
> asking for trouble and fs corruption ... but it's hardly the OSs fault,
> you told it you didn't want to operate safely.

Yes, we already agreed in the referenced thread that there are 2 
separate and completely unrelated problems were discovered here:

1. Handling of TASK_ABORTED status is different from handling "Commands
cleared by another initiator" Unit Attention.

2. The file system layer after receiving an I/O error handles something 
not too well. I use default mount and format options, so "errors" was 
"remount-ro", but recovery on reboot wasn't sufficient.

We in the SCSI layer can fix (1), but only FS people can fix (2).

> So, given what TASK_ABORT means, it looks to me like the handling should
> go through the maybe_retry path.  I'd say that's about a three line
> patch ... and since you have the test bed, you can even try it out.

OK, I'll prepare it.

> James
> 
> 
> 

