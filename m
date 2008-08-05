From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [usb-storage] USB storage devices and SAT
Date: Tue, 05 Aug 2008 18:57:10 +0300
Message-ID: <48987856.9030804@panasas.com>
References: <Pine.LNX.4.44L0.0808051047130.2518-100000@iolanthe.rowland.org> <489872F7.8050703@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:8652 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756068AbYHEP5e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Aug 2008 11:57:34 -0400
In-Reply-To: <489872F7.8050703@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Alan Stern <stern@rowland.harvard.edu>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Matthieu castet <castet.matthieu@free.fr>

Douglas Gilbert wrote:
> Alan Stern wrote:
>> On Tue, 5 Aug 2008, Boaz Harrosh wrote:
>>
>>> There was a correct and simple patch proposed that fixes this problem
>>> the right way:
>>> http://marc.info/?l=linux-usb&m=121762869915609&w=2
>>>
>>> Doug could you please test this patch to see if it fixes your device?
>>>
>>> scsi-core already gives drivers complete control on what sense_size to
>>> fetch. It is a parameter to the scsi_eh_prep_cmnd() call. So no need
>>> for slave_configure(), default value, and all that loop.
>>>> http://thread.gmane.org/gmane.linux.utilities.smartmontools/5721
>>>> Index: linux-2.6/drivers/usb/storage/scsiglue.c
<snip>
>> This looks highly suspicious at best.  Shouldn't sense_size be set to a
>> real value, like 22 or 255?
> 
> The "correct" maximum value (SPC-3 and draft SPC-4) is 252.
> Since SPC-3 the recommended maximum length for the basic
> SCSI commands that have a 1 byte allocation length field was
> altered from 255 to 252. This is to be a little friendlier
> to transports that move data in 4 byte units across their
> transport. Guessing a bit here but SATA, SAS and FCP fall
> into that group of transports.

252 + 8 bytes header for REQUEST_SENSE command. So total
260 buffer size. (Last I look)

> At some stage the allocation field length of an INQUIRY
> command was changed from 1 to 2 bytes. So to pick up
> VPD pages on older devices an INQUIRY's maximum allocation
> length of 252 may be prudent. For example, choosing a value
> of 260 (0x104) may give a surprising result if the device
> only expects a 1 byte allocation length field.
> 

INQUIRY and VPD pages are different. From what I remember Vendor
VPD pages where always be16 length field.

You and the scsi code keep talking about "1 byte allocation length field". 
But the standard talks about be16 values. For me they are not the same.
 
>>> I recommend this patch. It does exactly what's needed with minimum risk
>>> it is even maybe over protective, with the white list. Perhaps it should
>>> be turned to a black list instead. The old broken devices been an extincting
>>> exception.
>> Changing it to a blacklist would be bad -- in fact it would be a 
>> regression, because all the deficient devices which used to work would 
>> stop working until they were identified and added to the blacklist.
>>
>> Apart from the one nit above, I agree that this patch looks sensible.
> 
> Boaz,
> I didn't test the above patch (as I don't have the external
> USB devices that need it) but a gentleman who did, tells me
> that he used a very similar patch and it solved his problem.
> 

Do you know if he used the white-list or if his device returned
SPC-3 compliance. The reason I ask is because all the devices I have
here from usb sticks to external boxes and converters all work with
96 bytes sense but all report spc-2

> Doug Gilbert
> 

Thanks
Boaz
