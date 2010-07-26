From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Mon, 26 Jul 2010 16:22:39 +0400
Message-ID: <4C4D7E0F.1000602@vlnb.net>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>	<yq1iq64kv9f.fsf@sermon.lab.mkp.net>	<1275318102.2823.47.camel@mulgrave.site>	<4C03D5FD.3000202@panasas.com>	<20100601103041.GA15922@schmichrtp.mainz.de.ibm.com>	<1275398876.21962.6.camel@mulgrave.site>	<4C078FE2.9000804@vlnb.net>	<AANLkTinnrsFZ=nkX4QpG2eKOk05uNe5HpV-pP3kd7OF=@mail.gmail.com>	<4C49EA91.3060908@vlnb.net> <AANLkTi=OhopP4qud6EVffrNU3jLrA2KzRca=a4T9GhHx@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=OhopP4qud6EVffrNU3jLrA2KzRca=a4T9GhHx@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Gennadiy Nerubayev <parakie@gmail.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Christof Schmitt <christof.schmitt@de.ibm.com>, Boaz Harrosh <bharrosh@panasas.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Gennadiy Nerubayev, on 07/24/2010 12:51 AM wrote:
>>>> The real life problem we can see in an active-active DRBD-setup. In this
>>>> configuration 2 nodes act as a single SCST-powered SCSI device and they both
>>>> run DRBD to keep their backstorage in-sync. The initiator uses them as a
>>>> single multipath device in an active-active round-robin load-balancing
>>>> configuration, i.e. sends requests to both nodes in parallel, then DRBD
>>>> takes care to replicate the requests to the other node.
>>>>
>>>> The problem is that sometimes DRBD complies about concurrent local
>>>> writes, like:
>>>>
>>>> kernel: drbd0: scsi_tgt0[12503] Concurrent local write detected! [DISCARD
>>>> L] new: 144072784s +8192; pending: 144072784s +8192
>>>>
>>>> This message means that DRBD detected that both nodes received
>>>> overlapping writes on the same block(s) and DRBD can't figure out which one
>>>> to store. This is possible only if the initiator sent the second write
>>>> request before the first one completed.
>>>>
>>>> The topic of the discussion could well explain the cause of that. But,
>>>> unfortunately, people who reported it forgot to note which OS they run on
>>>> the initiator, i.e. I can't say for sure it's Linux.
>>>
>>> Sorry for the late chime in, but here's some more information of
>>> potential interest as I've previously inquired about this to the drbd
>>> mailing list:
>>>
>>> 1. It only happens when using blockio mode in IET or SCST. Fileio,
>>> nv_cache, and write_through do not generate the warnings.
>>
>> Some explanations for those who not familiar with the terminology:
>>
>>   - "Fileio" means Linux IO stack on the target receives IO via
>> vfs_readv()/vfs_writev()
>>
>>   - "NV_CACHE" means all the cache synchronization requests
>> (SYNCHRONIZE_CACHE, FUA) from the initiator are ignored
>>
>>   - "WRITE_THROUGH" means write through, i.e. the corresponding backend file
>> for the device open with O_SYNC flag.
>>
>>> 2. It happens on active/passive drbd clusters (on the active node
>>> obviously), NOT active/active. In fact, I've found that doing round
>>> robin on active/active is a Bad Idea (tm) even with a clustered
>>> filesystem, until at least the target software is able to synchronize
>>> the command state of either node.
>>> 3. Linux and ESX initiators can generate the warning, but I've so far
>>> only been able to reliably reproduce it using a Windows initiator and
>>> sqlio or iometer benchmarks. I'll be trying again using iometer when I
>>> have the time.
>>> 4. It only happens using a random write io workload (any block size),
>>> with initiator threads>1, OR initiator queue depth>1. The higher
>>> either of those is, the more spammy the warnings become.
>>> 5. The transport does not matter (reproduced with iSCSI and SRP)
>>> 6. If DRBD is disconnected (primary/unknown), the warnings are not
>>> generated. As soon as it's reconnected (primary/secondary), the
>>> warnings will reappear.
>>
>> It would be great if you prove or disprove our suspicions that Linux can
>> produce several write requests for the same blocks simultaneously. To be
>> sure we need:
>>
>> 1. The initiator is Linux. Windows and ESX are not needed for this
>> particular case.
>>
>> 2. If you are able to reproduce it, we will need full description of which
>> application used on the initiator to generate the load and in which mode.
>>
>> Target and DRBD configuration doesn't matter, you can use any.
>
> I just tried, and this particular DRBD warning is not reproducible
> with io (iometer) coming from a Linux initiator (2.6.30.10) The same
> iometer parameters were used as on windows, and both the base device
> as well as filesystem (ext3) were tested, both negative. I'll try a
> few more tests, but it seems that this is a nonissue with a Linux
> initiator.

OK, but to be completely sure, can you check also with other load 
generators, than IOmeter, please? IOmeter on Linux is a lot less 
effective than on Windows, because it uses sync IO, while we need big 
multi-IO load to trigger the problem we are discussing, if it exists. 
Plus, to catch it we need an FS on the initiator side, not using raw 
devices. So, something like fio over files on FS or diskbench should be 
more appropriate. Please don't use direct IO to avoid the bug Dave 
Chinner pointed us out.

Also, you mentioned above about that Linux can generate the warning. Can 
you recall on which configuration, including the kernel version, the 
load application and its configuration, you have seen it?

Thanks,
Vlad
