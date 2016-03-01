From: Arthur Marsh <arthur.marsh@internode.on.net>
Subject: Re: [PATCH] eata: Convert eata driver as normal PCI and platform
 device drivers
Date: Wed, 2 Mar 2016 08:06:26 +1030
Message-ID: <56D60B5A.3080209@internode.on.net>
References: <1456801344-3318-1-git-send-email-jiang.liu@linux.intel.com>
 <20160301065247.GA6670@infradead.org> <56D5D0F4.4060301@internode.on.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56D5D0F4.4060301@internode.on.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Jiang Liu <jiang.liu@linux.intel.com>
Cc: Dario Ballabio <ballabio_dario@emc.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, "Ballabio, Dario" <dario.ballabio@emc.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



Arthur Marsh wrote on 02/03/16 03:57:
>
>
> Christoph Hellwig wrote on 01/03/16 17:22:
>> Hi Jiang.
>>
>> I'd love to see this patch in and abuse of the old PCI API gone.
>>
>> Did you resolve the problems Arthur saw with the previous iteratons
>> of the patch?
>>
>
> I applied Jiang Liu's patch of 1st March 2016 to a clean kernel
> 4.5.0-rc6 source, removed my workaround of removing and re-adding the
> eata module before mounting file-systems that are on disks attached to
> the DPT SCSI card using the eata driver, and was able to kexec from the
> new kernel successfully.
>
> Arthur.

I spoke too soon, without removing and re-inserting the eata module 
before any filesystems on disks attached to the DPT controller were 
mounted, I'd get the following messages, similar to ones previously 
reported:

sd 0:0:6:0: tag#0 abort, mbox 1.
EATA0: abort, mbox 1 is in use.
sd 0:0:6:0: tag#0 reset, enter.
EATA0: reset, mbox 1 in reset.
EATA0: reset, board reset done, enabling interrupts.
EATA0: reset, interrupts disabled, loops 100415.
EATA0, reset, mbox 1 locked, DID_RESET, done.
EATA0: reset, exit, done.


and so on, finally hanging after printing "kexec_core: Starting new 
kernel" (I have a photo of the messages if they're needed).

So I'm still using the new patch but have to continue to remove and 
reinsert eata at start-up before any attempts to mount disks attatched 
to the DPT SCSI controller.

Arthur.
