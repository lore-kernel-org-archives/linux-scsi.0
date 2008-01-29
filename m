From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [BUG] 2.6.24-git usb reset problems
Date: Tue, 29 Jan 2008 16:13:06 +0200
Message-ID: <479F3472.5000103@panasas.com>
References: <20080128204935.GI15220@kernel.dk> <20080128212114.GA15586@kroah.com> <479F18D3.9030709@panasas.com> <20080129135443.GU15220@kernel.dk> <479F32E9.10609@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1764757AbYA2OO5@vger.kernel.org>
In-Reply-To: <479F32E9.10609@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Greg KH <greg@kroah.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 29 2008 at 16:06 +0200, Boaz Harrosh <bharrosh@panasas.com> wrote:
> On Tue, Jan 29 2008 at 15:54 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
>> On Tue, Jan 29 2008, Boaz Harrosh wrote:
>>> Greg KH wrote:
>>>> On Mon, Jan 28, 2008 at 09:49:35PM +0100, Jens Axboe wrote:
>>>>> Hi,
>>>>>
>>>>> Running latest -git (head 91525300baf162e83e923b09ca286f9205e21522) and
>>>>> connecting my cf usb storage device yields and endless stream of:
>>>>>
>>>>> Initializing USB Mass Storage driver...
>>>>> scsi6 : SCSI emulation for USB Mass Storage devices
>>>>> usb-storage: device found at 2
>>>>> usb-storage: waiting for device to settle before scanning
>>>>> usbcore: registered new interface driver usb-storage
>>>>> USB Mass Storage support registered.
>>>>> scsi 6:0:0:0: Direct-Access     Generic  STORAGE DEVICE   0125 PQ: 0
>>>>> ANSI: 0
>>>>> sd 6:0:0:0: [sdb] 4001760 512-byte hardware sectors (2049 MB)
>>>>> sd 6:0:0:0: [sdb] Write Protect is off
>>>>> sd 6:0:0:0: [sdb] Mode Sense: 02 00 00 00
>>>>> sd 6:0:0:0: [sdb] Assuming drive cache: write through
>>>>> sd 6:0:0:0: [sdb] 4001760 512-byte hardware sectors (2049 MB)
>>>>> sd 6:0:0:0: [sdb] Write Protect is off
>>>>> sd 6:0:0:0: [sdb] Mode Sense: 02 00 00 00
>>>>> sd 6:0:0:0: [sdb] Assuming drive cache: write through
>>>>>  sdb: sdb1
>>>>> sd 6:0:0:0: [sdb] Attached SCSI removable disk
>>>>> sd 6:0:0:0: Attached scsi generic sg1 type 0
>>>>> scsi 6:0:0:1: Direct-Access     Generic  STORAGE DEVICE   0125 PQ: 0
>>>>> ANSI: 0
>>>>> usb 5-1: reset high speed USB device using ehci_hcd and address 2
>>>>> usb 5-1: reset high speed USB device using ehci_hcd and address 2
>>>>> usb 5-1: reset high speed USB device using ehci_hcd and address 2
>>>>> usb 5-1: reset high speed USB device using ehci_hcd and address 2
>>>>> usb 5-1: reset high speed USB device using ehci_hcd and address 2
>>>>> usb 5-1: reset high speed USB device using ehci_hcd and address 2
>>>>> usb 5-1: reset high speed USB device using ehci_hcd and address 2
>>>>> [...]
>>>>>
>>>>> until I disconnect it. The device doesn't work. Worked fine in 2.6.24.
>>>>> I'm attaching boot messages and my .config.
>>>> That's a bit wierd, as we haven't added any USB patches to the -git tree
>>>> yet after 2.6.24 :)
>>>>
>>>> Could this be caused by some scsi changes perhaps?
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>> -
>>> Yes it is ;)
>>>
>>> Jens could you test the patch below? if it works I'll submit a proper
>>> patch. Please forgive me for the bug.
>> No difference, still just a lot of resets.
>>
> Where you able to figure out which usb storage transport is used?
> 
> in drivers/usb/storage/usb.c you have get_protocol() and get_transport()
> functions. I'm not sure if these get stored in sysfs perhaps. This will
> pinpoint better where to look. Let me research a bit. 
> 
>From inspection of code it should be in /proc/scsi somewhere look for:
	SPRINTF("     Protocol: %s\n", us->protocol_name);
	SPRINTF("    Transport: %s\n", us->transport_name);

(it's proc_info() in drivers/usb/storage/scsiglue.c)

Thanks
Boaz
