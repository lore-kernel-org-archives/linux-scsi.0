From: Paul Menzel <pmenzel+linux-scsi@molgen.mpg.de>
Subject: Re: aacraid: Regression in 4.14.56 with *genirq/affinity: assign
 vectors to all possible CPUs*
Date: Sat, 11 Aug 2018 10:14:18 +0200
Message-ID: <f5c57bf7-b8c1-a560-d13a-d74e0f27adbb@molgen.mpg.de>
References: <06ee23fe-ec9e-d67b-b533-d5151be74a11@molgen.mpg.de>
 <20180810133628.GA4131@kroah.com>
 <29b5f3ce-2c23-bf5e-fe50-29bedd4833e1@molgen.mpg.de>
 <20180810155511.GA17092@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180810155511.GA17092@kroah.com>
Content-Language: de-DE
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, it+linux-scsi@molgen.mpg.de, Adaptec OEM Raid Solutions <aacraid@microsemi.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Dear Greg,


Am 10.08.2018 um 17:55 schrieb Greg Kroah-Hartman:
> On Fri, Aug 10, 2018 at 04:11:23PM +0200, Paul Menzel wrote:

>> On 08/10/18 15:36, Greg Kroah-Hartman wrote:
>>> On Fri, Aug 10, 2018 at 03:21:52PM +0200, Paul Menzel wrote:
>>>> Dear Greg,
>>>>
>>>>
>>>> Commit ef86f3a7 (genirq/affinity: assign vectors to all possible CPUs) added
>>>> for Linux 4.14.56 causes the aacraid module to not detect the attached devices
>>>> anymore on a Dell PowerEdge R720 with two six core 24x E5-2630 @ 2.30GHz.
>>>>
>>>> ```
>>>> $ dmesg | grep raid
>>>> [    0.269768] raid6: sse2x1   gen()  7179 MB/s
>>>> [    0.290069] raid6: sse2x1   xor()  5636 MB/s
>>>> [    0.311068] raid6: sse2x2   gen()  9160 MB/s
>>>> [    0.332076] raid6: sse2x2   xor()  6375 MB/s
>>>> [    0.353075] raid6: sse2x4   gen() 11164 MB/s
>>>> [    0.374064] raid6: sse2x4   xor()  7429 MB/s
>>>> [    0.379001] raid6: using algorithm sse2x4 gen() 11164 MB/s
>>>> [    0.386001] raid6: .... xor() 7429 MB/s, rmw enabled
>>>> [    0.391008] raid6: using ssse3x2 recovery algorithm
>>>> [    3.559682] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
>>>> [    3.570061] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
>>>> [   10.725767] Adaptec aacraid driver 1.2.1[50834]-custom
>>>> [   10.731724] aacraid 0000:04:00.0: can't disable ASPM; OS doesn't have ASPM control
>>>> [   10.743295] aacraid: Comm Interface type3 enabled
>>>> $ lspci -nn | grep Adaptec
>>>> 04:00.0 Serial Attached SCSI controller [0107]: Adaptec Series 8 12G SAS/PCIe 3 [9005:028d] (rev 01)
>>>> 42:00.0 Serial Attached SCSI controller [0107]: Adaptec Smart Storage PQI 12G SAS/PCIe 3 [9005:028f] (rev 01)
>>>> ```
>>>>
>>>> But, it still works with a Dell PowerEdge R715 with two eight core AMD
>>>> Opteron 6136, the card below.
>>>>
>>>> ```
>>>> $ lspci -nn | grep Adaptec
>>>> 22:00.0 Serial Attached SCSI controller [0107]: Adaptec Series 8 12G SAS/PCIe 3 [9005:028d] (rev 01)
>>>> ```
>>>>
>>>> Reverting the commit fixes the issue.
>>>>
>>>> commit ef86f3a72adb8a7931f67335560740a7ad696d1d
>>>> Author: Christoph Hellwig <hch@lst.de>
>>>> Date:   Fri Jan 12 10:53:05 2018 +0800
>>>>
>>>>      genirq/affinity: assign vectors to all possible CPUs
>>>>      
>>>>      commit 84676c1f21e8ff54befe985f4f14dc1edc10046b upstream.
>>>>      
>>>>      Currently we assign managed interrupt vectors to all present CPUs.  This
>>>>      works fine for systems were we only online/offline CPUs.  But in case of
>>>>      systems that support physical CPU hotplug (or the virtualized version of
>>>>      it) this means the additional CPUs covered for in the ACPI tables or on
>>>>      the command line are not catered for.  To fix this we'd either need to
>>>>      introduce new hotplug CPU states just for this case, or we can start
>>>>      assining vectors to possible but not present CPUs.
>>>>      
>>>>      Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
>>>>      Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
>>>>      Tested-by: Stefan Haberland <sth@linux.vnet.ibm.com>
>>>>      Fixes: 4b855ad37194 ("blk-mq: Create hctx for each present CPU")
>>>>      Cc: linux-kernel@vger.kernel.org
>>>>      Cc: Thomas Gleixner <tglx@linutronix.de>
>>>>      Signed-off-by: Christoph Hellwig <hch@lst.de>
>>>>      Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>      Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>>
>>>> The problem doesn’t happen with Linux 4.17.11, so there are commits in
>>>> Linux master fixing this. Unfortunately, my attempts to find out failed.
>>>>
>>>> I was able to cherry-pick the three commits below on top of 4.14.62,
>>>> but the problem persists.
>>>>
>>>> 6aba81b5a2f5 genirq/affinity: Don't return with empty affinity masks on error
>>>> 355d7ecdea35 scsi: hpsa: fix selection of reply queue
>>>> e944e9615741 scsi: virtio_scsi: fix IO hang caused by automatic irq vector affinity
>>>>
>>>> Trying to cherry-pick the commits below, referencing the commit
>>>> in question, gave conflicts.
>>>>
>>>> 1. adbe552349f2 scsi: megaraid_sas: fix selection of reply queue
>>>> 2. d3056812e7df genirq/affinity: Spread irq vectors among present CPUs as far as possible
>>>>
>>>> To avoid further trial and error with the server with a slow firmware,
>>>> do you know what commits should fix the issue?
>>>
>>> Look at the email on the stable mailing list:
>>> 	Subject: Re: Fix for 84676c1f (b5b6e8c8) missing in 4.14.y
>>> it should help you out here.
>>
>> Ah, I didn’t see that [1] yet. Also I can’t find the original message, and a
>> way to reply to that thread. Therefore, here is my reply.
>>
>>> Can you try the patches listed there?
>>
>> I tried some of these already without success.
>>
>> b5b6e8c8d3b4 scsi: virtio_scsi: fix IO hang caused by automatic irq vector affinity
>> 2f31115e940c scsi: core: introduce force_blk_mq
>> adbe552349f2 scsi: megaraid_sas: fix selection of reply queue
>>
>> The commit above is already in v4.14.56.
>>
>> 8b834bff1b73 scsi: hpsa: fix selection of reply queue
>>
>> The problem persists.
>>
>> The problem also persists with the state below.
>>
>> 3528f73a4e5d scsi: core: introduce force_blk_mq
>> 16dc4d8215f3 scsi: hpsa: fix selection of reply queue
>> f0a7ab12232d scsi: virtio_scsi: fix IO hang caused by automatic irq vector affinity
>> 6aba81b5a2f5 genirq/affinity: Don't return with empty affinity masks on error
>> 1aa1166eface (tag: v4.14.62, stable/linux-4.14.y) Linux 4.14.62
>>
>> So, some more commits are necessary.
> 
> Or I revert the original patch here, and the follow-on ones that were
> added to "fix" this issue.  I think that might be the better thing
> overall here, right?  Have you tried that?

Yes, reverting the commit fixed the issue for us. If Christoph or Ming 
do not have another suggestion for a commit, that would be the way to go.


Kind regards,

Paul
