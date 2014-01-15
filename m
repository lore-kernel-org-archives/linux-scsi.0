From: Daniel Mack <zonque@gmail.com>
Subject: Re: Suspend issues with a LaCie USB hard disk connected
Date: Wed, 15 Jan 2014 18:29:28 +0100
Message-ID: <52D6C578.5050701@gmail.com>
References: <Pine.LNX.4.44L0.1401151215420.1587-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:56346 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbaAOR3c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2014 12:29:32 -0500
In-Reply-To: <Pine.LNX.4.44L0.1401151215420.1587-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Oliver Neukum <oliver@neukum.org>, Aaron Lu <aaron.lu@intel.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, Sven Neumann <s.neumann@raumfeld.com>

Hi Alan,

On 01/15/2014 06:19 PM, Alan Stern wrote:
> On Wed, 15 Jan 2014, Daniel Mack wrote:
> 
>> Hi,
>>
>> Sorry for the long, primarily holiday-related delay on this.
>>
>> On 12/18/2013 09:46 PM, Alan Stern wrote:
>>> On Wed, 18 Dec 2013, Daniel Mack wrote:
>>>> I'm facing an issue putting an embedded system to sleep while a Lacie
>>>> external USB hard disk is connected. Relevant kernel messages that occur
>>>> at the attempt are:
>>>>
>>>> [   13.834731] PM: Sending message for entering DeepSleep mode
>>>> [   13.846575] sd 0:0:0:0: [sda] Synchronizing SCSI cache
>>>> [   13.858818] sd 0:0:0:0: [sda]
>>>> [   13.862432] Result: hostbyte=0x00 driverbyte=0x08
>>>> [   13.867349] sd 0:0:0:0: [sda]
>>>> [   13.870626] Sense Key : 0x5 [current]
>>>> [   13.874602] sd 0:0:0:0: [sda]
>>>> [   13.877879] ASC=0x20 ASCQ=0x0
>>>> [   13.885053] dpm_run_callback(): scsi_bus_suspend+0x0/0x20 returns -5
>>>> [   13.901130] PM: Device 0:0:0:0 failed to suspend async: error -5
>>>> [   13.907507] PM: Some devices failed to suspend, or early wake event
>>>> detected
>>>>
>>>> What happens is that in sd_sync_cache(), scsi_execute_req_flags()
>>>> returns 0x08000002, so driver_byte(res) evaluates to DRIVER_SENSE and
>>>> host_byte(res) is DID_OK, which is an unhandled case that leads to -EIO
>>>> eventually.
>>>>
>>>> I have admittedly not much clue about the SCSI layer, so I wonder what
>>>> would be the best way to fix this. Should DID_OK just be handled as
>>>> non-error condition in the switch? Should the suspend call chain ignore
>>>> such errors from sd_sync_cache()?
>>>>
>>>> I'm open to suggestions and happy to test patches.
>>>
>>> The Sense Key and ASC values indicate that the drive did not understand
>>> the SYNCHRONIZE CACHE command.  A usbmon trace would verify this; see
>>> the instructions in Documentation/usb/usbmon.txt.
>>>
>>> Assuming that really is what happened, we have to decide how to handle 
>>> the situation.
>>
>> Ok, this is the usbmon trace that I captured when the system goes to
>> suspend with the USB storage media connected but unmounted:
>>
>> cebe5e00 3629314504 S Bo:1:003:2 -115 31 = 55534243 10000000 00000000
>> 00000a35 00000000 00000000 00000000 000000
>> cebe5e00 3629315214 C Bo:1:003:2 0 31 >
>> cebe5e00 3629315413 S Bi:1:003:1 -115 13 <
>> cebe5e00 3629315492 C Bi:1:003:1 0 13 = 55534253 10000000 00000000 01
> 
> That's the SYNCHRONIZE CACHE command, with an error return status.
> 
>> cebe5e00 3629315571 S Bo:1:003:2 -115 31 = 55534243 11000000 12000000
>> 80000603 00000012 00000000 00000000 000000
>> cebe5e00 3629315606 C Bo:1:003:2 0 31 >
>> cecd4580 3629315681 S Bi:1:003:1 -115 18 <
>> cecd4580 3629315744 C Bi:1:003:1 0 18 = 70000500 0000000a 00000000
>> 20000000 0000
>> cebe5e00 3629315772 S Bi:1:003:1 -115 13 <
>> cebe5e00 3629315817 C Bi:1:003:1 0 13 = 55534253 11000000 00000000 00
> 
> And that's the sense data, confirming SK=5 and ASC=20.  This means the 
> drive doesn't understand the command.

Ok.

> There's more stuff later on in the usbmon trace that I don't 
> understand.  But if everything else works okay, it won't matter.

The host controller tried to reset the port and the device, whatever
that results in. You're right, that is unrelated.

> I don't think that is the right thing to do.  Try this patch instead.

[...]

> Index: usb-3.13/drivers/scsi/sd.c
> ===================================================================
> --- usb-3.13.orig/drivers/scsi/sd.c
> +++ usb-3.13/drivers/scsi/sd.c
> @@ -1463,8 +1463,8 @@ static int sd_sync_cache(struct scsi_dis
>  			sd_print_sense_hdr(sdkp, &sshdr);
>  		/* we need to evaluate the error return  */
>  		if (scsi_sense_valid(&sshdr) &&
> -			/* 0x3a is medium not present */
> -			sshdr.asc == 0x3a)
> +			(sshdr.asc == 0x3a ||	/* medium not present */
> +			 sshdr.asc == 0x20))	/* invalid command */
>  				/* this is no error here */
>  				return 0;
>  

That seems to work equally well for me, thanks!

Feel free to add when submitting:

  Reported-by: Sven Neumann <s.neumann@raumfeld.com>
  Tested-by: Daniel Mack <zonque@gmail.com>


Thanks for your help!
Daniel
