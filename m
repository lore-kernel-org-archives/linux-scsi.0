From: "Ed Lin" <ed.lin@promise.com>
Subject: Re: [PATCH 5/8] stex: update device id info
Date: Mon, 4 Dec 2006 10:10:37 -0800
Message-ID: <NONAMEBtbS8oLhWTjvu00001502@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:32407 "EHLO
	nonameb.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936893AbWLDSKM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Dec 2006 13:10:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff <jeff@garzik.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "james.Bottomley" <james.Bottomley@SteelEye.com>, promise_linux <promise_linux@promise.com>


>-----Original Message-----
>From: Jeff Garzik [mailto:jeff@garzik.org] 
>Sent: Friday, December 01, 2006 9:10 PM
>To: Ed Lin
>Cc: linux-scsi; James.Bottomley; Promise_Linux
>Subject: Re: [PATCH 5/8] stex: update device id info
>
>
>Ed Lin wrote:
>> Update pci device id and Kconfig help information.
>> 
>> Signed-off-by: Ed Lin <ed.lin@promise.com>
>
>NAK.  At the very least, this patch description needs enhancing, but 
>more likely we need another PCI ID entry or two.
>
>
>> ---
>> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig index 
>> 1301d52..fb55373 100644
>> --- a/drivers/scsi/Kconfig
>> +++ b/drivers/scsi/Kconfig
>> @@ -968,8 +968,16 @@ config SCSI_STEX
>>  	tristate "Promise SuperTrak EX Series support"
>>  	depends on PCI && SCSI
>>  	---help---
>> -	  This driver supports Promise SuperTrak EX8350/8300/16350/16300
>> -	  Storage controllers.
>> +	  This driver supports Promise SuperTrak EX series storage
>controllers.
>> +	  These include SuperTrak EX8350, EX8300, EX16350, EX16300,
>EX12350,
>> +	  EX4350, EX24350; SuperTrak EX4650, EX4650o, EX8650EL, EX8650,
>EX8654;
>> +	  and VSC7250 series.
>
>I would strongly suggest eliminating the "These include ...." sentence. 
>  Otherwise, you will be forced by marketing department to patch the 
>driver every time a new board appears.
>
>
>> -	{ 0x1725, 0x7250, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_vsc },
>[...]
>> +	/* st_vsc */
>> +	{ 0x105a, 0x7250, 0x105a, 0x1000, 0, 0, st_vsc0 },
>> +	{ 0x105a, 0x7250, 0x105a, 0x2500, 0, 0, st_vsc0 },
>> +	{ 0x105a, 0x7250, 0x105a, 0x2510, 0, 0, st_vsc0 },
>> +	{ 0x105a, 0x7250, 0x105a, 0x2520, 0, 0, st_vsc0 },
>> +	{ 0x105a, 0x7250, 0x105a, 0x2530, 0, 0, st_vsc0 },
>> +	{ 0x105a, 0x7250, 0x105a, 0x1001, 0, 0, st_vsc1 },
>> +	{ 0x105a, 0x7250, 0x105a, 0x2501, 0, 0, st_vsc1 },
>> +	{ 0x105a, 0x7250, 0x105a, 0x2511, 0, 0, st_vsc1 },
>> +	{ 0x105a, 0x7250, 0x105a, 0x2521, 0, 0, st_vsc1 },
>> +	{ 0x105a, 0x7250, 0x105a, 0x2531, 0, 0, st_vsc1 },
>
>Normal this sort of change -- not providing a generic PCI_ANY_ID entries
>
>for the sub-device and sub-vendor IDs -- is a bad idea.
>
>This means that the VSC-related section of the pci_device_id table will 
>be very maintenance intensive over time.  It also means that new or 
>unknown compatible devices will not automatically be picked up by the 
>driver.
>
>It may be preferable even to do
>
>	 0x105a, 0x7250, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_vsc0
>
>and then in the PCI init routine, add code that looks something like
>
>	if ((ent->driver_data == st_vsc0) && (test for newer rev1))
>		driver_data = st_vsc1;
>	else
>		driver_data = st_vsc0;
>
Thanks for comment.

If a new device would use a new device id then the driver has to be
patched anyway (e.g. EX24350 uses 0xe350 as device id).  If a series
uses a single device id and different subdevice ids then we could use
PCI_ANY_ID for subdevice id. But I just want to make it clear to the
user what devices this driver actually supports.  "SuperTrak EX
series" or "stex" is ok, but this is becoming more or less a general
name, and I am afraid it may not be sufficient or accurate to describe
all the devices.

I will re-work and re-post the patches.

= = = = = = = = = = = = = = = = = = = =
			
Ed Lin



