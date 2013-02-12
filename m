From: Daniel <daniel@makrotopia.org>
Subject: Fwd: Re: New USB storage device, not detected by Ubuntu 12.10 (kernel
 3.5.0-17-generic)
Date: Tue, 12 Feb 2013 02:40:49 +0200
Message-ID: <51198F91.1040501@makrotopia.org>
References: <CAA6KcBAvZ2xwE9UGK-mqwe+9vJkq=bb5V3+pMaP=TUisL7+GiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([178.33.44.196]:42390 "EHLO
	fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932808Ab3BLBLE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Feb 2013 20:11:04 -0500
Received: from authenticated sender
	by fudo.makrotopia.org with esmtpsa (TLSv1:CAMELLIA256-SHA:256)
	 (Exim 4.77)
	(envelope-from <daniel@makrotopia.org>)
	id 1U53qD-0002gg-Fc
	for linux-scsi@vger.kernel.org; Tue, 12 Feb 2013 01:36:06 +0100
In-Reply-To: <CAA6KcBAvZ2xwE9UGK-mqwe+9vJkq=bb5V3+pMaP=TUisL7+GiA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi linux-scsi people,

the problem described (and worked around) during the conversation below seems to
be related to your realm.
I apologize if this is redundant and for not taking my own time to suggest a
patch for it. However, as it affects users, I still wanted to get it out of my
backlog and at least mention it here.

Cheers

Daniel

-------- Original Message --------
Subject: Re: New USB storage device, not detected by Ubuntu 12.10 (kernel
3.5.0-17-generic)
Date: Sun, 27 Jan 2013 13:22:42 -0800
From: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
To: Daniel <daniel@makrotopia.org>

I don't know.  You would need to ask the linux-scsi mailing lists.

Matt

On Sun, Jan 27, 2013 at 3:48 AM, Daniel <daniel@makrotopia.org> wrote:
> Hi Matt,
>
> the delay_use parameter to usb-storage doesn't solve the problem. It seems
> like the delay has to be added to scsi_mod via scsi_inq_timeout=25 for this
> harddrive to be detected properly (and this obviously needs to be set
> already in the initramfs when scsi_mod is initially loaded).
> Is there any way scsi_inq_timeout can be raised on a per device/vendor
> basis?
>
> Thank you for your support!
>
>
> Cheers
>
>
> Daniel
>
>
>
> On 27.01.2013 02:33, Matthew Dharm wrote:
>>
>> In that case, this is an easy fix.  There is already a parameter for this.
>>
>> When you load the usb-storage module, add the "delay_use=5" parameter
>> -- that will add a 5-second delay before scanning for the device.
>>
>> Through much of 2.6.x, the default for this parameter was 5 seconds.
>> Later is was changed to 1 second (I guess people didn't like to wait).
>>  Try playing around with the value to find something you like, and
>> then you can configure that to be the default via modprobe.conf
>>
>> Matt
>>
>> On Sat, Jan 26, 2013 at 10:22 AM, Daniel <daniel@makrotopia.org> wrote:
>>>
>>> Hi again,
>>>
>>> I just figured out that calling
>>> echo  "scsi add-single-device 8 0 0 0" > /proc/scsi/scsi
>>> (with 8 being the usb-storage controller for that device)
>>> makes it work if called a few seconds after adding the device.
>>> Probably the waiting time before probing is not high enough and a quirk
>>> for that
>>> device needs to be added.
>>>
>>> Cheers
>>>
>>>
>>> Daniel
>>>
>>> On 01/26/2013 07:54 PM, Matthew Dharm wrote:
>>>>
>>>> Is this a kernel you compiled yourself?
>>>>
>>>> Did you compile in the SCSI disk modules?
>>>>
>>>> Are you saying that /proc/scsi/scsi is empty?
>>>>
>>>> You may have to compile with USB Storage Verbose Debug enabled and
>>>> capture a log from that...
>>>>
>>>> Matt
>>>>
>>>> On Sat, Jan 26, 2013 at 9:41 AM, Daniel <daniel@makrotopia.org> wrote:
>>>>>
>>>>> Hi Matt,
>>>>>
>>>>> thank you for getting back to me after just a few minutes! You are
>>>>> doing an
>>>>> amazing job!
>>>>> So this is a Transcend StoreJet 1TB external 2.5" HDD connected via
>>>>> USB.
>>>>> I meanwhile also tried it on another machine which runs kernel
>>>>> 3.8.0rc1, the
>>>>> result is the same.
>>>>> It shows up as a usb-sata-bridge and usb-storage seems to detect it.
>>>>> However, no connected SCSI device shows up in /proc/scsi/scsi .
>>>>> If you need any more information or if I can assist in any way (I'm
>>>>> familiar
>>>>> with compiling the kernel form source)
>>>>>
>>>>> Thank you much!
>>>>>
>>>>>
>>>>> Daniel
>>>>>
>>>>>
>>>>> from lsusb -v
>>>>> Bus 002 Device 004: ID 152d:2329 JMicron Technology Corp. / JMicron USA
>>>>> Technology Corp. JM20329 SATA Bridge
>>>>> Device Descriptor:
>>>>>   bLength                18
>>>>>   bDescriptorType         1
>>>>>   bcdUSB               2.00
>>>>>   bDeviceClass            0 (Defined at Interface level)
>>>>>   bDeviceSubClass         0
>>>>>   bDeviceProtocol         0
>>>>>   bMaxPacketSize0        64
>>>>>   idVendor           0x152d JMicron Technology Corp. / JMicron USA
>>>>> Technology Corp.
>>>>>   idProduct          0x2329 JM20329 SATA Bridge
>>>>>   bcdDevice            0.00
>>>>>   iManufacturer           1
>>>>>   iProduct               11
>>>>>   iSerial                 5
>>>>>   bNumConfigurations      1
>>>>>   Configuration Descriptor:
>>>>>     bLength                 9
>>>>>     bDescriptorType         2
>>>>>     wTotalLength           32
>>>>>     bNumInterfaces          1
>>>>>     bConfigurationValue     1
>>>>>     iConfiguration          4
>>>>>     bmAttributes         0xc0
>>>>>       Self Powered
>>>>>     MaxPower                2mA
>>>>>     Interface Descriptor:
>>>>>       bLength                 9
>>>>>       bDescriptorType         4
>>>>>       bInterfaceNumber        0
>>>>>       bAlternateSetting       0
>>>>>       bNumEndpoints           2
>>>>>       bInterfaceClass         8 Mass Storage
>>>>>       bInterfaceSubClass      6 SCSI
>>>>>       bInterfaceProtocol     80 Bulk-Only
>>>>>       iInterface              6
>>>>>       Endpoint Descriptor:
>>>>>         bLength                 7
>>>>>         bDescriptorType         5
>>>>>         bEndpointAddress     0x81  EP 1 IN
>>>>>         bmAttributes            2
>>>>>           Transfer Type            Bulk
>>>>>           Synch Type               None
>>>>>           Usage Type               Data
>>>>>         wMaxPacketSize     0x0200  1x 512 bytes
>>>>>         bInterval               0
>>>>>       Endpoint Descriptor:
>>>>>         bLength                 7
>>>>>         bDescriptorType         5
>>>>>         bEndpointAddress     0x02  EP 2 OUT
>>>>>         bmAttributes            2
>>>>>           Transfer Type            Bulk
>>>>>           Synch Type               None
>>>>>           Usage Type               Data
>>>>>         wMaxPacketSize     0x0200  1x 512 bytes
>>>>>         bInterval               0
>>>>>
>>>>>
>>>>> from kernel log:
>>>>> [   91.313769] usb 2-1.5: USB disconnect, device number 3
>>>>> [  101.030552] usb 2-1.5: new high-speed USB device number 4 using
>>>>> ehci_hcd
>>>>> [  101.123500] usb 2-1.5: New USB device found, idVendor=152d,
>>>>> idProduct=2329
>>>>> [  101.123506] usb 2-1.5: New USB device strings: Mfr=1, Product=11,
>>>>> SerialNumber=5
>>>>> [  101.123509] usb 2-1.5: Product: StoreJet Transcend
>>>>> [  101.123512] usb 2-1.5: Manufacturer: JMicron
>>>>> [  101.123515] usb 2-1.5: SerialNumber: WD5WX51A61H8060
>>>>> [  101.124331] scsi5 : usb-storage 2-1.5:1.0
>>>>>
>>>>>
>>>>>
>>>>> On 26.01.2013 17:14, Matthew Dharm wrote:
>>>>>>
>>>>>>
>>>>>> Please provide lsusb output showing the device attached.
>>>>>>
>>>>>> I'm assuming that you're sending this e-mail because you don't think
>>>>>> the device is working properly. Can you describe what this device is,
>>>>>> and what you think should happen when it is attached, and what
>>>>>> actually happens when it is attached?
>>>>>>
>>>>>> Matt
>>>>>>
>>>>>> On Sat, Jan 26, 2013 at 8:42 AM, Daniel <daniel@makrotopia.org> wrote:
>>>>>>>
>>>>>>>
>>>>>>> Please add this device to usb-storage
>>>>>>> [ 1078.279850] usb 2-1.5: >new high-speed USB device number 6 using
>>>>>>> ehci_hcd
>>>>>>> [ 1078.372757] usb 2-1.5: >New USB device found, idVendor=152d,
>>>>>>> idProduct=2329
>>>>>>> [ 1078.372768] usb 2-1.5: >New USB device strings: Mfr=1, Product=11,
>>>>>>> SerialNumber=5
>>>>>>> [ 1078.372775] usb 2-1.5: >Product: StoreJet Transcend
>>>>>>> [ 1078.372782] usb 2-1.5: >Manufacturer: JMicron
>>>>>>> [ 1078.372788] usb 2-1.5: >SerialNumber: WD5WX51A61H8060
>>>>>>>
>>>>>>>
>>>>>>> Cheers
>>>>>>>
>>>>>>>
>>>>>>> Daniel
>>>>>
>>>>>
>>>>>
>>>>
>>>>
>>>>
>>>
>
