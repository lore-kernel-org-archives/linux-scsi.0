From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: ips.c broken since 2.6.23 on x86_64?
Date: Sun, 17 Feb 2008 15:09:06 +0200
Message-ID: <47B831F2.90201@panasas.com>
References: <20080215011636.GA21124@tpepper-t42p.dolavim.us>	<20080216010954M.tomof@acm.org>	<20080215225057.GA3172@tpepper-t42p.dolavim.us> <20080216094127E.tomof@acm.org> <47B82DFB.8010206@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:50737 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbYBQNJx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Feb 2008 08:09:53 -0500
In-Reply-To: <47B82DFB.8010206@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: lnxninja@linux.vnet.ibm.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, Mark_Salyzyn@adaptec.com

On Sun, Feb 17 2008 at 14:52 +0200, Boaz Harrosh <bharrosh@panasas.com> wrote:
> On Sat, Feb 16 2008 at 2:41 +0200, FUJITA Tomonori <tomof@acm.org> wrote:
>> On Fri, 15 Feb 2008 14:50:57 -0800
>> Tim Pepper <lnxninja@linux.vnet.ibm.com> wrote:
>>
>>> On Sat 16 Feb at 01:09:43 +0900 tomof@acm.org said:
>>>> The first one is just reverting the data buffer accessors
>>>> conversion. It would be nice if we could just revert it but we
>>>> can't. These changes are necessary to compile the driver against post
>>>> 2.6.24.
>>> Fujita-san,
>>>
>>> Unfortunately (and not too surprisingly given what we've tried so far) with
>>> only the first of your series reverted the driver is working fine for me
>>> again.
>> Do you mean that you applied only the following two patches against
>> 2.6.24, and then it doesn't work?
>>
>> 0001-ips-revert-the-changes-for-the-data-buffer-accessor.patch
>> 0002-ips-kill-the-map_single-path-in-ips_scmd_buf_write.patch
>>
>> If so, the second patch is broken. Did you saw BUG_ON message (I added
>> some BUG_ON to the patch)?
>>
>>
>>> I saw (eg: replies to http://lkml.org/lkml/2007/5/11/132) some possibly
>>> similar sounding issues with other drivers.  Could there be some memory
>>> uninitialised?  I did try changing all the ips.c kmalloc's to kzalloc's,
>>> but that didn't help.  Also that thread ties into pci gart.  The machines
>>> we've been using are liable to getting pci calgary although given my
>>> .config has:
>>>     CONFIG_GART_IOMMU=y
>>>     CONFIG_CALGARY_IOMMU=y
>>>     # CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT is not set
>>> and that when booting this mainline I don't see any Calgary related
>>> messages like I get from eg: Ubuntu's 2.6.22-14-server...I'm probably not
>>> actually running the calgary iommu code in these repros.
>> Yes, probabaly, your machine doesn't use any IOMMU hardware
>> (nommu_map_sg function was in your crash log).
>>
>>
>>> Anyway, I greatly appreciate your efforts so far in trying to find what
>>> could be wrong here!
>> Really sorry about the troubles and thanks for testing.
>> -
> Tomo hi
> It looks like the same bug we had with USB's isd200 and protocol.c. An overflow
> of a data buffer bigger then then the sglist. There 2 it was in the INQUIRY command.
> 
> You just need to also check for sg != NULL in the for() loop.
> 
> Tim Please test below patch. It's ontop of 2.6.24 but should also apply to
> 2.6.25-rcx
> 
> Boaz
> -- 
> From ec20bea25c9fe2400378b19c128b15fef3c7cbb6 Mon Sep 17 00:00:00 2001
> From: Boaz Harrosh <bharrosh@panasas.com>
> Date: Sun, 17 Feb 2008 14:50:25 +0200
> Subject: [PATCH] ips: Avoid overflow in writing scsi command data
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
>  drivers/scsi/ips.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
> index 5c5a9b2..1d12253 100644
> --- a/drivers/scsi/ips.c
> +++ b/drivers/scsi/ips.c
> @@ -3517,7 +3517,7 @@ ips_scmd_buf_write(struct scsi_cmnd *scmd, void *data, unsigned int count)

Disregard that patch it is totally wrong. That's not it. Sorry

Boaz

