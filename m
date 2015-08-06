From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 3/4] cxlflash: Superpipe support
Date: Thu, 06 Aug 2015 16:35:02 -0500
Message-ID: <55C3D306.3090800@linux.vnet.ibm.com>
References: <1438576417-32974-1-git-send-email-mrochs@linux.vnet.ibm.com> <55C3C78D.7070900@linux.vnet.ibm.com>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:52803 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199AbbHFVeb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2015 17:34:31 -0400
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <manoj@linux.vnet.ibm.com>;
	Thu, 6 Aug 2015 15:34:30 -0600
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id B16B83E40048
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2015 15:34:26 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t76LYQMt55312608
	for <linux-scsi@vger.kernel.org>; Thu, 6 Aug 2015 14:34:26 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t76LYOQs023790
	for <linux-scsi@vger.kernel.org>; Thu, 6 Aug 2015 15:34:26 -0600
In-Reply-To: <55C3C78D.7070900@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, wenxiong@linux.vnet.ibm.com
Cc: hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com

Brian: Thanks for your review. See comments inline, below.

- Manoj Kumar

On 8/6/2015 3:46 PM, Brian King wrote:
>>    * cxlflash_queuecommand() - sends a mid-layer request
>>    * @host:	SCSI host associated with device.
>>    * @scp:	SCSI command to send.
>> @@ -512,6 +535,13 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
>>   			     get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
>>   			     get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
>>
>> +	/* Fail all read/write commands when in operating superpipe mode */
>> +	if (scp->device->hostdata && is_scsi_read_write(scp)) {
>> +		pr_debug_ratelimited("%s: LUN being used in superpipe mode. "
>> +				     "Operation not allowed!\n", __func__);
>> +		goto error;
>> +	}
>
> Not sure I like this. A couple of concerns:
>
> 1. Any process that comes along and issues a read to the device will result in I/O errors getting logged
>     by the layers above you. The general expectation is that if reads or writes are failing on a block device,
>     then something is wrong and the user should know about it. A user innocently running "fdisk -l", for example,
>     to list all disk partitions on the system, would see errors getting logged for every disk configured for
>     superpipe mode.
> 2. How will users know that devices are in superpipe mode? The only indication is the driver specific sysfs attribute
>     that no existing tooling will be checking. GUI tools to do disk partitioning and such will see these devices
>     and present them to the user with the expectation that something can be done with them.
> 3. If this is a multipath device, you'll have a dm device sitting on top of this and potentially have multipathd doing health
>     checking periodically and these devices will show up in multipath -ll output.
>
> It seems to me like the cleanest option would be, when switching into superpipe mode, for the user code doing
> this to unbind the sd driver from the relevant scsi device. This will prevent any reads or writes from being
> issued to the LUN from the block layer, since there will no longer be any way to do this. It will also prevent
> these devices from showing up in GUIs and menus where we don't want them to.
>
> So, I'd say, kill this snooping of the op code and failing I/O in superpipe mode, and solve this in userspace.

The intent of this snooping and failing I/O was to prevent an accidental 
over-write of the LUN in superpipe mode by some other user unaware of 
our sysfs attribute. This was an additional precautionary measure to 
unbinding the sd driver from the relevant scsi device. We can fall back 
on to that primary mechanism.


>> +	gli->max_lba = swab64(*((u64 *)&cmd_buf[0]));
>> +	gli->blk_len = swab32(*((u32 *)&cmd_buf[8]));
>
> This doesn't look right. How does this work on big endian? I think you want to be using
> be64_to_cpu and be32_to_cpu here.
>

Good catch. Will rectify in the v4 patch.

