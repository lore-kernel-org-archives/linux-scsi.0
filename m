From: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [BUG] 2.6.24-git usb reset problems
Date: Tue, 29 Jan 2008 21:09:59 +0200
Message-ID: <479F7A07.8080204@panasas.com>
References: <20080128204935.GI15220@kernel.dk> <479F32E9.10609@panasas.com> <20080129141108.GV15220@kernel.dk> <200801291531.39825.oliver@neukum.org> <20080129143109.GW15220@kernel.dk> <20080129183910.GI15220@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20080129183910.GI15220-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Oliver Neukum <oliver-GvhC2dPhHPQdnm+yROfE0A@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 29 2008 at 20:39 +0200, Jens Axboe <jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, Jan 29 2008, Jens Axboe wrote:
>> On Tue, Jan 29 2008, Oliver Neukum wrote:
>>> Am Dienstag, 29. Januar 2008 15:11:08 schrieb Jens Axboe:
>>>> On Tue, Jan 29 2008, Boaz Harrosh wrote:
>>>>> On Tue, Jan 29 2008 at 15:54 +0200, Jens Axboe <jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>>>>>> On Tue, Jan 29 2008, Boaz Harrosh wrote:
>>>>>>> Greg KH wrote:
>>>  
>>>>>> No difference, still just a lot of resets.
>>>>>>
>>>>> Where you able to figure out which usb storage transport is used?
>>>>>
>>>>> in drivers/usb/storage/usb.c you have get_protocol() and get_transport()
>>>>> functions. I'm not sure if these get stored in sysfs perhaps. This will
>>>>> pinpoint better where to look. Let me research a bit. 
>>>> Did the quick'n easy and dumped it. Protocol is 'Transparent SCSI' and
>>>> transport is 'Bulk'
>>> You can recompile your kernel with CONFIG_USB_DEBUG and CONFIG_STORAGE_DEBUG
>>> That should tell the reason for the resets.
>> Sure, I'll do that. Will post the results tonight.
> 
> OK, fresh boot with CONFIG_USB_DEBUG and CONFIG_STORAGE_DEBUG. Plugged
> in the device, waited 10 seconds or so and pulled it out. These are the
> messages.
> 
> It all looks good until the MODE_SENSE command, where it only transfers
> 4 of 192 bytes.
> 
<snip>
> usb-storage: Command MODE_SENSE (6 bytes)
> usb-storage:  1a 00 3f 00 c0 00
> usb-storage: Bulk Command S 0x43425355 T 0x4 L 192 F 128 Trg 0 LUN 0 CL 6
> usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
> usb-storage: Status code 0; transferred 31/31
> usb-storage: -- transfer complete
> usb-storage: Bulk command transfer result=0
> usb-storage: usb_stor_bulk_transfer_sglist: xfer 192 bytes, 1 entries
> usb-storage: Status code -121; transferred 4/192
> usb-storage: -- short read transfer
> usb-storage: Bulk data transfer result 0x1
> usb-storage: Attempting to get CSW...
<snip>

I get something similar but better:
usb-storage: Command MODE_SENSE (6 bytes)
usb-storage:  1a 00 3f 00 c0 00
usb-storage: Bulk Command S 0x43425355 T 0x6 L 192 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 192 bytes, 1 entries
usb-storage: Status code -121; transferred 36/192
usb-storage: -- short read transfer
usb-storage: Bulk data transfer result 0x1
usb-storage: Attempting to get CSW...

So I get 36 bytes, then code goes on into one reset, and every thing is then
fine.

Could you put us out of our mesery and revert that patch:
[SCSI] usb: transport - convert to accessors and !use_sg code path removal
(6d416e6173394defda5933e419e805b696681b7e)

to make sure this is it. I hate to do this to you, but I cannot reproduce the
failure down here. If it works please send a log with the debugs on perhaps
we can compare.

You will need to configure out the CONFIG_USB_STORAG_* they will not compile
you should have only have CONFIG_USB_STORAGE & CONFIG_USB_STORAGE_DEBUG. it should
support your HW.


Thanks Jens
Boaz
