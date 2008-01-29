From: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [BUG] 2.6.24-git usb reset problems
Date: Tue, 29 Jan 2008 16:06:33 +0200
Message-ID: <479F32E9.10609@panasas.com>
References: <20080128204935.GI15220@kernel.dk> <20080128212114.GA15586@kroah.com> <479F18D3.9030709@panasas.com> <20080129135443.GU15220@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20080129135443.GU15220-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 29 2008 at 15:54 +0200, Jens Axboe <jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, Jan 29 2008, Boaz Harrosh wrote:
>> Greg KH wrote:
>>> On Mon, Jan 28, 2008 at 09:49:35PM +0100, Jens Axboe wrote:
>>>> Hi,
>>>>
>>>> Running latest -git (head 91525300baf162e83e923b09ca286f9205e21522) and
>>>> connecting my cf usb storage device yields and endless stream of:
>>>>
>>>> Initializing USB Mass Storage driver...
>>>> scsi6 : SCSI emulation for USB Mass Storage devices
>>>> usb-storage: device found at 2
>>>> usb-storage: waiting for device to settle before scanning
>>>> usbcore: registered new interface driver usb-storage
>>>> USB Mass Storage support registered.
>>>> scsi 6:0:0:0: Direct-Access     Generic  STORAGE DEVICE   0125 PQ: 0
>>>> ANSI: 0
>>>> sd 6:0:0:0: [sdb] 4001760 512-byte hardware sectors (2049 MB)
>>>> sd 6:0:0:0: [sdb] Write Protect is off
>>>> sd 6:0:0:0: [sdb] Mode Sense: 02 00 00 00
>>>> sd 6:0:0:0: [sdb] Assuming drive cache: write through
>>>> sd 6:0:0:0: [sdb] 4001760 512-byte hardware sectors (2049 MB)
>>>> sd 6:0:0:0: [sdb] Write Protect is off
>>>> sd 6:0:0:0: [sdb] Mode Sense: 02 00 00 00
>>>> sd 6:0:0:0: [sdb] Assuming drive cache: write through
>>>>  sdb: sdb1
>>>> sd 6:0:0:0: [sdb] Attached SCSI removable disk
>>>> sd 6:0:0:0: Attached scsi generic sg1 type 0
>>>> scsi 6:0:0:1: Direct-Access     Generic  STORAGE DEVICE   0125 PQ: 0
>>>> ANSI: 0
>>>> usb 5-1: reset high speed USB device using ehci_hcd and address 2
>>>> usb 5-1: reset high speed USB device using ehci_hcd and address 2
>>>> usb 5-1: reset high speed USB device using ehci_hcd and address 2
>>>> usb 5-1: reset high speed USB device using ehci_hcd and address 2
>>>> usb 5-1: reset high speed USB device using ehci_hcd and address 2
>>>> usb 5-1: reset high speed USB device using ehci_hcd and address 2
>>>> usb 5-1: reset high speed USB device using ehci_hcd and address 2
>>>> [...]
>>>>
>>>> until I disconnect it. The device doesn't work. Worked fine in 2.6.24.
>>>> I'm attaching boot messages and my .config.
>>> That's a bit wierd, as we haven't added any USB patches to the -git tree
>>> yet after 2.6.24 :)
>>>
>>> Could this be caused by some scsi changes perhaps?
>>>
>>> thanks,
>>>
>>> greg k-h
>>> -
>> Yes it is ;)
>>
>> Jens could you test the patch below? if it works I'll submit a proper
>> patch. Please forgive me for the bug.
> 
> No difference, still just a lot of resets.
> 
Where you able to figure out which usb storage transport is used?

in drivers/usb/storage/usb.c you have get_protocol() and get_transport()
functions. I'm not sure if these get stored in sysfs perhaps. This will
pinpoint better where to look. Let me research a bit. 

Thanks for testing
Boaz
