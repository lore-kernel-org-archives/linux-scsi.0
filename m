From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [usb-storage] USB storage devices and SAT
Date: Tue, 05 Aug 2008 17:34:15 +0200
Message-ID: <489872F7.8050703@torque.net>
References: <Pine.LNX.4.44L0.0808051047130.2518-100000@iolanthe.rowland.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elrond2.infotech.no ([82.134.31.41]:57183 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738AbYHEPe2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Aug 2008 11:34:28 -0400
In-Reply-To: <Pine.LNX.4.44L0.0808051047130.2518-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Boaz Harrosh <bharrosh@panasas.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Matthieu castet <castet.matthieu@free.fr>

Alan Stern wrote:
> On Tue, 5 Aug 2008, Boaz Harrosh wrote:
> 
>> There was a correct and simple patch proposed that fixes this problem
>> the right way:
>> http://marc.info/?l=linux-usb&m=121762869915609&w=2
>>
>> Doug could you please test this patch to see if it fixes your device?
>>
>> scsi-core already gives drivers complete control on what sense_size to
>> fetch. It is a parameter to the scsi_eh_prep_cmnd() call. So no need
>> for slave_configure(), default value, and all that loop.
> 
>>> http://thread.gmane.org/gmane.linux.utilities.smartmontools/5721
>>> Index: linux-2.6/drivers/usb/storage/scsiglue.c
>>> ===================================================================
>>> --- linux-2.6.orig/drivers/usb/storage/scsiglue.c	2008-08-02 00:07:24.000000000 +0200
>>> +++ linux-2.6/drivers/usb/storage/scsiglue.c	2008-08-02 00:07:37.000000000 +0200
>>> @@ -170,6 +170,10 @@
>>>  		if (us->fflags & US_FL_CAPACITY_HEURISTICS)
>>>  			sdev->guess_capacity = 1;
>>>  
>>> +		/* assume SPC3 or latter device support sense size different of 18 */
>>> +		if (sdev->scsi_level > SCSI_SPC_2)
>>> +			us->fflags |= US_FL_SANE_SENSE;
>>> +
>>>  		/* Some devices report a SCSI revision level above 2 but are
>>>  		 * unable to handle the REPORT LUNS command (for which
>>>  		 * support is mandatory at level 3).  Since we already have
>>> Index: linux-2.6/drivers/usb/storage/transport.c
>>> ===================================================================
>>> --- linux-2.6.orig/drivers/usb/storage/transport.c	2008-08-02 00:07:24.000000000 \
>>>                 +0200
>>> +++ linux-2.6/drivers/usb/storage/transport.c	2008-08-02 00:07:37.000000000 +0200
>>> @@ -595,10 +595,15 @@
>>>  	if (need_auto_sense) {
>>>  		int temp_result;
>>>  		struct scsi_eh_save ses;
>>> +		int sense_size = US_SENSE_SIZE;
>>> +
>>> +		/* device support and need bigger sense buffer */
>>> +		if (us->fflags & US_FL_SANE_SENSE)
>>> +			sense_size = ~0;
> 
> This looks highly suspicious at best.  Shouldn't sense_size be set to a
> real value, like 22 or 255?

The "correct" maximum value (SPC-3 and draft SPC-4) is 252.
Since SPC-3 the recommended maximum length for the basic
SCSI commands that have a 1 byte allocation length field was
altered from 255 to 252. This is to be a little friendlier
to transports that move data in 4 byte units across their
transport. Guessing a bit here but SATA, SAS and FCP fall
into that group of transports.

At some stage the allocation field length of an INQUIRY
command was changed from 1 to 2 bytes. So to pick up
VPD pages on older devices an INQUIRY's maximum allocation
length of 252 may be prudent. For example, choosing a value
of 260 (0x104) may give a surprising result if the device
only expects a 1 byte allocation length field.

>> I recommend this patch. It does exactly what's needed with minimum risk
>> it is even maybe over protective, with the white list. Perhaps it should
>> be turned to a black list instead. The old broken devices been an extincting
>> exception.
> 
> Changing it to a blacklist would be bad -- in fact it would be a 
> regression, because all the deficient devices which used to work would 
> stop working until they were identified and added to the blacklist.
> 
> Apart from the one nit above, I agree that this patch looks sensible.

Boaz,
I didn't test the above patch (as I don't have the external
USB devices that need it) but a gentleman who did, tells me
that he used a very similar patch and it solved his problem.

Doug Gilbert

