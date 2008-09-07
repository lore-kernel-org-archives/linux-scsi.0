From: matthieu castet <castet.matthieu@free.fr>
Subject: Re: [usb-storage] USB storage devices and SAT
Date: Sun, 07 Sep 2008 21:35:30 +0200
Message-ID: <48C42D02.7080809@free.fr>
References: <489656EC.5000602@torque.net> <Pine.LNX.4.44L0.0808041147580.3818-100000@iolanthe.rowland.org> <20080804174524.GL4322@one-eyed-alien.net> <48983F5D.6060903@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp5-g19.free.fr ([212.27.42.35]:49493 "EHLO smtp5-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754995AbYIGTfi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 7 Sep 2008 15:35:38 -0400
In-Reply-To: <48983F5D.6060903@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Douglas Gilbert <dougg@torque.net>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>

Hi,

Boaz Harrosh wrote:
> 
> There was a correct and simple patch proposed that fixes this problem
> the right way:
> http://marc.info/?l=linux-usb&m=121762869915609&w=2
> 
> Doug could you please test this patch to see if it fixes your device?
> 
> scsi-core already gives drivers complete control on what sense_size to
> fetch. It is a parameter to the scsi_eh_prep_cmnd() call. So no need
> for slave_configure(), default value, and all that loop.
> 
> Matthieu castet <castet.matthieu@free.fr> wrote ...
>> we have got report from 2 users that scsi sat (to do ata passthrough)  was not fully \
>> working with some usb bridge (maxtor and western digital). Everything works except \
>> the sense result was incomplete [1].
>>
>>
>> After some investigation, they need a sense size different of 18 (at least 22). [2]
>>
>> Because some devices can crash if the sense size is different of 18, in order to not \
>> break these devices a flag that is set either by unusual entries, either for spc3 or \
>> latter devices is used.
>>
>>
>> Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
> 
> Reviewed-by: Boaz Harrosh <bharrosh@panasas.com>
> 
What the status of that.

Should I try to resubmit that patch on linux-usb ?


>>
>>
>> [1]
>> http://thread.gmane.org/gmane.linux.utilities.smartmontools/5613
>>
>> [2]
>> http://thread.gmane.org/gmane.linux.utilities.smartmontools/5721
>> Index: linux-2.6/drivers/usb/storage/scsiglue.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/usb/storage/scsiglue.c	2008-08-02 00:07:24.000000000 +0200
>> +++ linux-2.6/drivers/usb/storage/scsiglue.c	2008-08-02 00:07:37.000000000 +0200
>> @@ -170,6 +170,10 @@
>>  		if (us->fflags & US_FL_CAPACITY_HEURISTICS)
>>  			sdev->guess_capacity = 1;
>>  
>> +		/* assume SPC3 or latter device support sense size different of 18 */
>> +		if (sdev->scsi_level > SCSI_SPC_2)
>> +			us->fflags |= US_FL_SANE_SENSE;
>> +
>>  		/* Some devices report a SCSI revision level above 2 but are
>>  		 * unable to handle the REPORT LUNS command (for which
>>  		 * support is mandatory at level 3).  Since we already have
>> Index: linux-2.6/drivers/usb/storage/transport.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/usb/storage/transport.c	2008-08-02 00:07:24.000000000 \
>>                 +0200
>> +++ linux-2.6/drivers/usb/storage/transport.c	2008-08-02 00:07:37.000000000 +0200
>> @@ -595,10 +595,15 @@
>>  	if (need_auto_sense) {
>>  		int temp_result;
>>  		struct scsi_eh_save ses;
>> +		int sense_size = US_SENSE_SIZE;
>> +
>> +		/* device support and need bigger sense buffer */
>> +		if (us->fflags & US_FL_SANE_SENSE)
>> +			sense_size = ~0;
>>  
>>  		US_DEBUGP("Issuing auto-REQUEST_SENSE\n");
>>  
>> -		scsi_eh_prep_cmnd(srb, &ses, NULL, 0, US_SENSE_SIZE);
>> +		scsi_eh_prep_cmnd(srb, &ses, NULL, 0, sense_size);
>>  
>>  		/* FIXME: we must do the protocol translation here */
>>  		if (us->subclass == US_SC_RBC || us->subclass == US_SC_SCSI ||
>> Index: linux-2.6/drivers/usb/storage/unusual_devs.h
>> ===================================================================
>> --- linux-2.6.orig/drivers/usb/storage/unusual_devs.h	2008-08-02 00:07:24.000000000 \
>>                 +0200
>> +++ linux-2.6/drivers/usb/storage/unusual_devs.h	2008-08-02 00:07:37.000000000 +0200
>> @@ -1791,6 +1791,18 @@
>>  		US_SC_DEVICE, US_PR_DEVICE, NULL,
>>  		US_FL_CAPACITY_HEURISTICS),
>>  
>> +UNUSUAL_DEV(  0x0d49, 0x7310, 0x0000, 0x9999,
>> +		"Maxtor",
>> +		"usb sata bridge",
>> +		US_SC_DEVICE, US_PR_DEVICE, NULL,
>> +		US_FL_SANE_SENSE ),
>> +
>> +UNUSUAL_DEV(  0x1058, 0x0704, 0x0000, 0x9999,
>> +		"Western Digital",
>> +		"External HDD",
>> +		US_SC_DEVICE, US_PR_DEVICE, NULL,
>> +		US_FL_SANE_SENSE ),
>> +
>>  /* Control/Bulk transport for all SubClass values */
>>  USUAL_DEV(US_SC_RBC, US_PR_CB, USB_US_TYPE_STOR),
>>  USUAL_DEV(US_SC_8020, US_PR_CB, USB_US_TYPE_STOR),
>> Index: linux-2.6/include/linux/usb_usual.h
>> ===================================================================
>> --- linux-2.6.orig/include/linux/usb_usual.h	2008-08-02 00:07:24.000000000 +0200
>> +++ linux-2.6/include/linux/usb_usual.h	2008-08-02 00:07:37.000000000 +0200
>> @@ -52,7 +52,9 @@
>>  	US_FLAG(MAX_SECTORS_MIN,0x00002000)			\
>>  		/* Sets max_sectors to arch min */		\
>>  	US_FLAG(BULK_IGNORE_TAG,0x00004000)			\
>> -		/* Ignore tag mismatch in bulk operations */
>> +		/* Ignore tag mismatch in bulk operations */	\
>> +	US_FLAG(SANE_SENSE,0x00008000)			\
>> +		/* Need a sense size different of 18 for some cmd (SAT) */
>>  
>>  
>>  #define US_FLAG(name, value)	US_FL_##name = value ,
>>
>>
> 
> I recommend this patch. It does exactly what's needed with minimum risk
> it is even maybe over protective, with the white list. Perhaps it should
> be turned to a black list instead. The old broken devices been an extincting
> exception.
> 
> Boaz
> 
> 
> 
> 

