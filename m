From: Arthur Marsh <arthur.marsh@internode.on.net>
Subject: Re: [PATCH] eata: Convert eata driver as normal PCI and platform
 device drivers
Date: Wed, 2 Mar 2016 17:22:26 +1030
Message-ID: <56D68DAA.5000206@internode.on.net>
References: <1456801344-3318-1-git-send-email-jiang.liu@linux.intel.com>
 <20160301065247.GA6670@infradead.org> <56D5D0F4.4060301@internode.on.net>
 <56D60B5A.3080209@internode.on.net> <56D65BF6.1050905@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56D65BF6.1050905@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiang Liu <jiang.liu@linux.intel.com>, Christoph Hellwig <hch@infradead.org>
Cc: Dario Ballabio <ballabio_dario@emc.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, "Ballabio, Dario" <dario.ballabio@emc.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



Jiang Liu wrote on 02/03/16 13:50:

>> I spoke too soon, without removing and re-inserting the eata module
>> before any filesystems on disks attached to the DPT controller were
>> mounted, I'd get the following messages, similar to ones previously
>> reported:
>>
>> sd 0:0:6:0: tag#0 abort, mbox 1.
>> EATA0: abort, mbox 1 is in use.
>> sd 0:0:6:0: tag#0 reset, enter.
>> EATA0: reset, mbox 1 in reset.
>> EATA0: reset, board reset done, enabling interrupts.
>> EATA0: reset, interrupts disabled, loops 100415.
>> EATA0, reset, mbox 1 locked, DID_RESET, done.
>> EATA0: reset, exit, done.
>>
>>
>> and so on, finally hanging after printing "kexec_core: Starting new
>> kernel" (I have a photo of the messages if they're needed).
>>
>> So I'm still using the new patch but have to continue to remove and
>> reinsert eata at start-up before any attempts to mount disks attatched
>> to the DPT SCSI controller.
> Hi Authur,
> 	Thanks for testing. So current situation is that we have
> a working driver for normal case, but still have issues during kexec.
> Per my understanding, we need to implement a PCI device driver shutdown
> callback to reset the RAID controller. I have once tried to implement
> the shutdown callback, but it doesn't work. And I have no deep
> understanding of the RAID controller and have no hardware for
> experiment too, so have no idea about next step.
> 	Maybe one acceptable way is to merge this patch first, so
> we get a basic working driver, and then ask help from expert to
> solve the kexec issue.
> Thanks!
> Gerry

My controller is a DPT2044W, it does not provide any hardware RAID 
capabilities.

I'm not sure where responsibility lies in driver development but I'm 
still using the DPT2044W controller which worked on the 4.2.0 kernels 
and earlier and this problem has been around for nearly 5 months now.

I can do builds and tests of any patches that people can provide, but am 
not a C programmer, much less a Linux driver developer.

Regards,

Arthur.
