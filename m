From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: PROBLEM: kernel crashes on RAID1 drive error
Date: Thu, 21 Oct 2004 10:01:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4177C13C.10007@steeleye.com>
References: <8FA83ADB-22E4-11D9-AC9C-0003934F6348@aol.com> <20041021084514.GY10531@suse.de> <4177BF22.7060208@steeleye.com> <20041021135557.GN10531@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:62983 "EHLO
	fenric.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265331AbUJUOBl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 10:01:41 -0400
In-Reply-To: <20041021135557.GN10531@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Mark Rustad <MRustad@aol.com>, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org

Jens Axboe wrote:
> On Thu, Oct 21 2004, Paul Clements wrote:
> 
>>Jens Axboe wrote:
>>
>>>On Wed, Oct 20 2004, Mark Rustad wrote:
>>>
>>>
>>>>Folks,
>>>>
>>>>I have been having trouble with kernel crashes resulting from RAID1 
>>>>component device failures. I have been testing the robustness of an 
>>>>embedded system and have been using a drive that is known to fail after 
>>>>a time under load. When this device returns a media error, I always 
>>>>wind up with either a kernel hang or reboot. In this environment, each 
>>>>drive has four partitions, each of which is part of a RAID1 with its 
>>>>partner on the other device. Swap is on md2 so even it should be 
>>>>robust.
>>>>
>>>>I have gotten this result with the SuSE standard i386 smp kernels 
>>>>2.6.5-7.97 and 2.6.5-7.108. I also get these failures with the 
>>>>kernel.org kernels 2.6.8.1, 2.6.9-rc4 and 2.6.9.
>>>>
>>>>The hardware setup is a two cpu Nacona with an Adaptec 7902 SCSI 
>>>>controller with two Seagate drives on a SAF-TE bus. I run three or four 
>>>>dd commands copying /dev/md0 to /dev/null to provide the activity that 
>>>>stimulates the failure.
>>>>
>>>>I suspect that something is going wrong in the retry of the failed I/O 
>>>>operations, but I'm really not familiar with any of this area of the 
>>>>kernel at all.
>>>>
>>>>In one failure, I get the following messages from kernel 2.6.9:
>>>>
>>>>raid1: Disk failure on sdb1, disabling device.
>>>>raid1: sdb1: rescheduling sector 176
>>>>raid1: sda1: redirecting sector 176 to another mirror
>>>>raid1: sdb1: rescheduling sector 184
>>>>raid1: sda1: redirecting sector 184 to another mirror
>>>>Incorrect number of segments after building list
>>>>counted 2, received 1
>>>>req nr_sec 0, cur_nr_sec 7
>>>
>>>
>>>This should be fixed by this patch, can you test it?
>>
>>There may well be two problems here, but the original problem you're 
>>seeing (infinite read retries, and failures) is due to a bug in raid1. 
>>Basically the bio handling on read error retry was not quite right. Neil 
>>Brown just posted the patch to correct this a couple of days ago:
>>
>>http://marc.theaimsgroup.com/?l=linux-raid&m=109824318202358&w=2
>>
>>Please try that. (If you need a patch that applies to SUSE 2.6.5, I also 
>>have a version of the patch which should apply to that).
> 
> 
> Is 2.6.9 not uptodate wrt those raid1 patches?!

Unfortunately, no. This latest problem (the one he's reporting) is not 
fixed in mainline. I discovered the problem a month or so ago while 
testing with SLES 9. I posted a patch and Neil expanded on it (to 
include raid10, which is now in mainline, and also suffers from the same 
problem). Neil just posted the patch two days ago to linux-raid, so I 
expect it's in -mm now.

>>Please be aware that there are several other bugs in the SUSE 2.6.5-7.97 
>>kernel in md and raid1 (basically it's a matter of that kernel being 
>>somewhat behind mainline, where most of these bugs are now fixed). I've 
>>sent several patches to SUSE to fix these issues, that hopefully will 
>>get into their SP1 release that should be forthcoming soon...
> 
> 
> -97 is the release kernel, -111 is the current update kernel. And it has
> those raid1 issues fixed already, at least the ones that are known. The
> scsi segment issue is not, however.

Thanks. Good to know that. -111 is currently available to customers? We 
may recommend that our customers use that, rather than patching -97 
ourselves.

--
Paul


