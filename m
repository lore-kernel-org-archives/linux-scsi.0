From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [usb-storage] USB storage devices and SAT
Date: Tue, 05 Aug 2008 18:10:10 +0300
Message-ID: <48986D52.7030109@panasas.com>
References: <Pine.LNX.4.44L0.0808051047130.2518-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:12276 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756411AbYHEPK4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Aug 2008 11:10:56 -0400
In-Reply-To: <Pine.LNX.4.44L0.0808051047130.2518-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Douglas Gilbert <dougg@torque.net>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Matthieu castet <castet.matthieu@free.fr>

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
> 

No this is the regular way to signal from a driver that we support
whatever the scsi-ml or application decided. So ~0 means, effectively,
scsi's default which is 96. But can change in future with no changes
to drivers.
(BTW ~0 is used everywhere in Kernel but here)

Don't just hard code what ever you want. the maximum sense_size mandated
by scsi standard is 260. The current midlayer uses 96 every where. If
the driver has specific needs, like 18 with broken devices, do so but please
don't hard code to arbitrary value.

> 
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
> 
> Alan Stern
> 

Thanks
Boaz
