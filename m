From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [usb-storage] BUG: SCSI: usb storage SDHC card doesn't work in
 2.6.27-rc1
Date: Sun, 03 Aug 2008 13:56:42 +0200
Message-ID: <48959CFA.6080500@torque.net>
References: <656254.26203.qm@web83208.mail.mud.yahoo.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elrond2.infotech.no ([82.134.31.41]:52439 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772AbYHCL46 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Aug 2008 07:56:58 -0400
In-Reply-To: <656254.26203.qm@web83208.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Frost <artusemrys@yahoo.com>
Cc: Matthew Frost <artusemrys@sbcglobal.net>, Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Dharm <mdharm-kernel@one-eyed-alien.net>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

Matthew Frost wrote:
> --- Matthew Frost <artusemrys@sbcglobal.net> wrote:
> 
>> Alan Stern wrote:
>>>> The patches to fix this that I have tried do not apply
>>>> cleanly to lk 2.6.26 (and break during compile if forced:
>>>> "us->fflags" is not defined).
>>>>
>>>> Is there a lk 2.6.26 patch available?
>>> Sorry about that; my patches are against the USB development tree and
>>> I tend to forget to redo them against the vanilla kernel.  Below is a
>>> patch against 2.6.26.  Or you can just edit the original patch and
>>> change the occurrences of "fflags" to "flags".
>>>
>>> Alan Stern
>>>
>>>
>>> Index: 2.6.26/drivers/usb/storage/transport.c
>>> ===================================================================
>>> --- 2.6.26.orig/drivers/usb/storage/transport.c
>>> +++ 2.6.26/drivers/usb/storage/transport.c
>>> @@ -1034,8 +1034,21 @@ int usb_stor_Bulk_transport(struct scsi_
>>>  
>>>  	/* try to compute the actual residue, based on how much data
>>>  	 * was really transferred and what the device tells us */
>>> -	if (residue) {
>>> -		if (!(us->flags & US_FL_IGNORE_RESIDUE)) {
>>> +	if (residue && !(us->flags & US_FL_IGNORE_RESIDUE)) {
>>> +
>>> +		/* Heuristically detect devices that generate bogus residues
>>> +		 * by seeing what happens with INQUIRY and READ CAPACITY
>>> +		 * commands.
>>> +		 */
>>> +		if (bcs->Status == US_BULK_STAT_OK &&
>>> +				scsi_get_resid(srb) == 0 &&
>>> +					((srb->cmnd[0] == INQUIRY &&
>>> +						transfer_length == 36) ||
>>> +					(srb->cmnd[0] == READ_CAPACITY &&
>>> +						transfer_length == 8))) {
>>> +			us->flags |= US_FL_IGNORE_RESIDUE;
>>> +
>>> +		} else {
>>>  			residue = min(residue, transfer_length);
>>>  			scsi_set_resid(srb, max(scsi_get_resid(srb),
>>>  			                                       (int) residue));
>>>
>>>
>> Thanks!  I've been trying to fix it manually, and it wouldn't work.  Trying
>> this version now.  Let's see if this fixes my problem.
>>
>> Matt Frost

The above patch made my USB key:
   Alcor Micro Corp. Transcend JetFlash 110 USB 2.0 Flash Drive (2GB)
usable in a pretty clean lk 2.6.26 .

Thanks
Doug Gilbert



