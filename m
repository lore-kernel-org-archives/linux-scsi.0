From: Jiang Liu <jiang.liu@linux.intel.com>
Subject: Re: [PATCH] eata: Convert eata driver as normal PCI and platform
 device drivers
Date: Wed, 2 Mar 2016 11:20:22 +0800
Message-ID: <56D65BF6.1050905@linux.intel.com>
References: <1456801344-3318-1-git-send-email-jiang.liu@linux.intel.com>
 <20160301065247.GA6670@infradead.org> <56D5D0F4.4060301@internode.on.net>
 <56D60B5A.3080209@internode.on.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:56870 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbcCBDU1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2016 22:20:27 -0500
In-Reply-To: <56D60B5A.3080209@internode.on.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arthur Marsh <arthur.marsh@internode.on.net>, Christoph Hellwig <hch@infradead.org>
Cc: Dario Ballabio <ballabio_dario@emc.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, "Ballabio, Dario" <dario.ballabio@emc.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 2016/3/2 5:36, Arthur Marsh wrote:
> 
> 
> Arthur Marsh wrote on 02/03/16 03:57:
>>
>>
>> Christoph Hellwig wrote on 01/03/16 17:22:
>>> Hi Jiang.
>>>
>>> I'd love to see this patch in and abuse of the old PCI API gone.
>>>
>>> Did you resolve the problems Arthur saw with the previous iteratons
>>> of the patch?
>>>
>>
>> I applied Jiang Liu's patch of 1st March 2016 to a clean kernel
>> 4.5.0-rc6 source, removed my workaround of removing and re-adding the
>> eata module before mounting file-systems that are on disks attached to
>> the DPT SCSI card using the eata driver, and was able to kexec from the
>> new kernel successfully.
>>
>> Arthur.
> 
> I spoke too soon, without removing and re-inserting the eata module
> before any filesystems on disks attached to the DPT controller were
> mounted, I'd get the following messages, similar to ones previously
> reported:
> 
> sd 0:0:6:0: tag#0 abort, mbox 1.
> EATA0: abort, mbox 1 is in use.
> sd 0:0:6:0: tag#0 reset, enter.
> EATA0: reset, mbox 1 in reset.
> EATA0: reset, board reset done, enabling interrupts.
> EATA0: reset, interrupts disabled, loops 100415.
> EATA0, reset, mbox 1 locked, DID_RESET, done.
> EATA0: reset, exit, done.
> 
> 
> and so on, finally hanging after printing "kexec_core: Starting new
> kernel" (I have a photo of the messages if they're needed).
> 
> So I'm still using the new patch but have to continue to remove and
> reinsert eata at start-up before any attempts to mount disks attatched
> to the DPT SCSI controller.
Hi Authur,
	Thanks for testing. So current situation is that we have
a working driver for normal case, but still have issues during kexec.
Per my understanding, we need to implement a PCI device driver shutdown
callback to reset the RAID controller. I have once tried to implement
the shutdown callback, but it doesn't work. And I have no deep
understanding of the RAID controller and have no hardware for
experiment too, so have no idea about next step.
	Maybe one acceptable way is to merge this patch first, so
we get a basic working driver, and then ask help from expert to
solve the kexec issue.
Thanks!
Gerry

> 
> Arthur.
