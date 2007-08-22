From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: isd200.c Has fatal bugs and is probably not used any more
Date: Wed, 22 Aug 2007 12:18:53 +0300
Message-ID: <46CBFF7D.2090904@panasas.com>
References: <46CB37B2.404@panasas.com> <29728.1187727861@bebe.enoyolf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:2805 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751159AbXHVJUO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Aug 2007 05:20:14 -0400
In-Reply-To: <29728.1187727861@bebe.enoyolf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Maxey <dwm@enoyolf.org>
Cc: =?ISO-8859-1?Q?Bj=F6rn_Stenberg?= <bjorn@haxx.se>, support@in-system.com, James Bottomley <James.Bottomley@SteelEye.com>, Greg Kroah-Hartman <gregkh@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>

Doug Maxey wrote:
> On Tue, 21 Aug 2007 22:06:26 +0300, Boaz Harrosh wrote:
>> Hi!
>>
>> the driver drivers/usb/storage/isd200.c has code like:
>>
>> static int isd200_action( struct us_data *us, int action,
>>               void* pointer, int value )
>>
>> ...
>>
>>     case ACTION_READ_STATUS:
>>         US_DEBUGP("   isd200_action(READ_STATUS)\n");
>>         ata.generic.ActionSelect = ACTION_SELECT_0|ACTION_SELECT_2;
>>         ata.generic.RegisterSelect =
>>           REG_CYLINDER_LOW | REG_CYLINDER_HIGH |
>>           REG_STATUS | REG_ERROR;
>>         srb->sc_data_direction = DMA_FROM_DEVICE;
>>         srb->request_buffer = pointer;
>>         srb->request_bufflen = value;
>>         break;
>> ...
>>
>> Now what the hell is that hijacked scsi_cmnd and who said
>> that the srb->use_sg is Zero. If this is a regular queued
>> scsi_cmnd, this can easily crash. And at best a memory leak.
>>
>> The last git recorded real change to this driver was it's insertion
>> into git by Linus.
>>
>> Is this an indication that this driver is no longer used and
>> can be removed?
> 
> All IBM bladecenters have the HW this driver supports.  And it does
> mostly work.  This particular frag requires USB_DEBUG enabled, correct?
> 

OK Thanks, Do you know if there is an active maintainer for this driver?
Else I will need someone that can test patches for me.

Boaz

