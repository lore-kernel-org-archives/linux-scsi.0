From: George Cherian <gcherian@caviumnetworks.com>
Subject: Re: JMS56x not working reliably with uas driver
Date: Wed, 21 Dec 2016 18:17:49 +0530
Message-ID: <585A79F5.7080701@caviumnetworks.com>
References: <585A69E6.6040009@caviumnetworks.com>
 <1482320547.7638.7.camel@suse.com> <585A7073.3060904@caviumnetworks.com>
 <931b00cf-e273-6d07-8a99-71916376af67@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0069.outbound.protection.outlook.com ([104.47.34.69]:8992
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751292AbcLUMsO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Dec 2016 07:48:14 -0500
In-Reply-To: <931b00cf-e273-6d07-8a99-71916376af67@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>, Oliver Neukum <oneukum@suse.com>
Cc: stern@rowland.harvard.edu, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, "Cherian, George" <George.Cherian@cavium.com>



On 12/21/2016 05:50 PM, Hans de Goede wrote:
> Hi,
>
> On 21-12-16 13:07, George Cherian wrote:
>>
>>
>> On 12/21/2016 05:12 PM, Oliver Neukum wrote:
>>> On Wed, 2016-12-21 at 17:09 +0530, George Cherian wrote:
>>>> Hi Oliver,
>>>>
>>>> I was working with this JMicron device and using the uas driver.
>>>> I am seeing the following 2 issues.
>>>>
>>>> 1) On connect I see the following messages.
>>>
>>> Thanks. Do you want to submit it to Greg?
>>> The patch is fine.
>> Yes please!!!
>>
>>>
>>>> 2) On disconnect I am seeing the following issue
>>>>
>>>>    scsi host4: uas_post_reset: alloc streams error -19 after reset
>>>>    sd 4:0:0:0: [sdb] Synchronizing SCSI cache
>>>>
>>>> This is more fatal because after these messages the USB port becomes
>>>> unusable. Even an lsusb invocation hangs for ever.
>>>
>>> Ouch. That points to a logic error. We should not reset if
>>> a device is gone.
>>> Could you send dmesg of such a case?
>> here is the dmesg!!
>> [  203.475382] usb 4-1.3: new SuperSpeed USB device number 3 using
>> xhci_hcd
>> [  203.496172] usb 4-1.3: New USB device found, idVendor=152d,
>> idProduct=9561
>> [  203.503037] usb 4-1.3: New USB device strings: Mfr=1, Product=2,
>> SerialNumber=5
>> [  203.510352] usb 4-1.3: Product: JMS56x Series
>> [  203.514698] usb 4-1.3: Manufacturer: JMicron
>> [  203.518966] usb 4-1.3: SerialNumber: 00000000000000000000
>> [  203.594383] usbcore: registered new interface driver usb-storage
>> [  203.612425] scsi host4: uas
>> [  203.615418] usbcore: registered new interface driver uas
>> [  203.620979] scsi 4:0:0:0: Direct-Access     ST4000NM 0033-9ZM170
>> 0001 PQ: 0 ANSI: 6
>> [  203.630240] sd 4:0:0:0: Attached scsi generic sg1 type 0
>> [  203.630382] sd 4:0:0:0: [sdb] 7814037168 512-byte logical blocks:
>> (4.00 TB/3.63 TiB)
>> [  203.631338] sd 4:0:0:0: [sdb] Write Protect is off
>> [  203.631342] sd 4:0:0:0: [sdb] Mode Sense: 67 00 10 08
>> [  203.631734] sd 4:0:0:0: [sdb] Write cache: enabled, read cache:
>> enabled, supports DPO and FUA
>> [  203.631899] xhci_hcd 0000:00:11.0: ERROR Transfer event for
>> disabled endpoint or incorrect stream ring
>> [  203.631904] xhci_hcd 0000:00:11.0: @0000001f610a1c10 00000000
>> 00000000 1b000000 03078001 state 14 ep_info 9403
>> [  203.631906] xhci_hcd 0000:00:11.0: No epring
>> [  203.674546]  sdb: sdb1
>> [  203.676639] sd 4:0:0:0: [sdb] Attached SCSI disk
>> [  213.222913] scsi host4: uas_post_reset: alloc streams error -19
>> after reset
>> [  213.230548] sd 4:0:0:0: [sdb] Synchronizing SCSI cache
>>
>> Above is the dmesg without the unusual_uas patch applied.
>> Do you need me to enable any specific dev_dbg and then the dmesg output?
>
> Can you get us a dmesg with the unusual_uas patch applied? Usually once
> things go foobar because
> of issue-ing a command which the device does not understand, more things
> typically come down
> as both the device and the host may be in an undefined state then.

Here is the lsusb -t
============================================================================
lsusb -t
/:  Bus 04.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/1p, 5000M
     |__ Port 1: Dev 2, If 0, Class=Hub, Driver=hub/4p, 5000M
         |__ Port 3: Dev 4, If 0, Class=Mass Storage, Driver=uas, 5000M
/:  Bus 03.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/1p, 480M
     |__ Port 1: Dev 2, If 0, Class=Hub, Driver=hub/4p, 480M
/:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/1p, 5000M
/:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/1p, 480M

lsusb
Bus 003 Device 002: ID 0bda:5401 Realtek Semiconductor Corp. RTL 8153 
USB 3.0 hub with gigabit ethernet
Bus 004 Device 002: ID 0bda:0401 Realtek Semiconductor Corp.
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 004 Device 004: ID 152d:9561 JMicron Technology Corp. / JMicron USA 
Technology Corp.
lsusb -v
Bus 004 Device 004: ID 152d:9561 JMicron Technology Corp. / JMicron USA 
Technology Corp.
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               3.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0         9
   idVendor           0x152d JMicron Technology Corp. / JMicron USA 
Technology Corp.
   idProduct          0x9561
   bcdDevice            0.01
   iManufacturer           1 JMicron
   iProduct                2 JMS56x Series
   iSerial                 5 00000000000000000000
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength          121
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          4 USB Mass Storage
     bmAttributes         0xc0
       Self Powered
     MaxPower                2mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           2
       bInterfaceClass         8 Mass Storage
       bInterfaceSubClass      6 SCSI
       bInterfaceProtocol     80 Bulk-Only
       iInterface              6 MSC Bulk-Only Transfer
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0400  1x 1024 bytes
         bInterval               0
         bMaxBurst              15
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x02  EP 2 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0400  1x 1024 bytes
         bInterval               0
         bMaxBurst              15
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       1
       bNumEndpoints           4
       bInterfaceClass         8 Mass Storage
       bInterfaceSubClass      6 SCSI
       bInterfaceProtocol     98
       iInterface             10 MSC BOT/UAS Transfer
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x01  EP 1 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0400  1x 1024 bytes
         bInterval               0
         bMaxBurst               0
         Command pipe (0x01)
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0400  1x 1024 bytes
         bInterval               0
         bMaxBurst               0
         MaxStreams             32
         Status pipe (0x02)
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0400  1x 1024 bytes
         bInterval               0
         bMaxBurst              15
         MaxStreams             32
         Data-in pipe (0x03)
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x04  EP 4 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0400  1x 1024 bytes
         bInterval               0
         bMaxBurst              15
         MaxStreams             32
         Data-out pipe (0x04)
Binary Object Store Descriptor:
   bLength                 5
   bDescriptorType        15
   wTotalLength           22
   bNumDeviceCaps          2
   USB 2.0 Extension Device Capability:
     bLength                 7
     bDescriptorType        16
     bDevCapabilityType      2
     bmAttributes   0x00000002
       Link Power Management (LPM) Supported
   SuperSpeed USB Device Capability:
     bLength                10
     bDescriptorType        16
     bDevCapabilityType      3
     bmAttributes         0x00
     wSpeedsSupported   0x000e
       Device can operate at Full Speed (12Mbps)
       Device can operate at High Speed (480Mbps)
       Device can operate at SuperSpeed (5Gbps)
     bFunctionalitySupport   1
       Lowest fully-functional device speed is Full Speed (12Mbps)
     bU1DevExitLat          10 micro seconds
     bU2DevExitLat          32 micro seconds
Device Status:     0x0001
   Self Powered
=======================================================================
Connect and disconnect dmesg without uas and usb_storage

[   56.205374] usb 4-1.3: new SuperSpeed USB device number 3 using xhci_hcd
[   56.226152] usb 4-1.3: New USB device found, idVendor=152d, 
idProduct=9561
[   56.233017] usb 4-1.3: New USB device strings: Mfr=1, Product=2, 
SerialNumber=5
[   56.240332] usb 4-1.3: Product: JMS56x Series
[   56.244677] usb 4-1.3: Manufacturer: JMicron
[   56.248945] usb 4-1.3: SerialNumber: 00000000000000000000
[  337.530073] usb 4-1.3: USB disconnect, device number 3

=======================================================================
Here is the dmesg output with the unusual_uas patch applied
[  832.995364] usb 4-1.3: new SuperSpeed USB device number 5 using xhci_hcd
[  833.016186] usb 4-1.3: New USB device found, idVendor=152d, 
idProduct=9561
[  833.023051] usb 4-1.3: New USB device strings: Mfr=1, Product=2, 
SerialNumber=5
[  833.030365] usb 4-1.3: Product: JMS56x Series
[  833.034710] usb 4-1.3: Manufacturer: JMicron
[  833.038977] usb 4-1.3: SerialNumber: 00000000000000000000
[  833.045767] scsi host5: uas
[  833.049191] scsi 5:0:0:0: Direct-Access     ST4000NM 0033-9ZM170 
  0001 PQ: 0 ANSI: 6
[  833.058454] sd 5:0:0:0: Attached scsi generic sg1 type 0
[  833.063792] sd 5:0:0:0: [sdb] 7814037168 512-byte logical blocks: 
(4.00 TB/3.63 TiB)
[  833.072483] sd 5:0:0:0: [sdb] Write Protect is off
[  833.077277] sd 5:0:0:0: [sdb] Mode Sense: 67 00 10 08
[  833.077678] sd 5:0:0:0: [sdb] Write cache: enabled, read cache: 
enabled, supports DPO and FUA
[  833.144571]  sdb: sdb1
[  833.149095] sd 5:0:0:0: [sdb] Attached SCSI disk
[  843.149653] scsi host5: uas_post_reset: alloc streams error -19 after 
reset
[  843.157268] sd 5:0:0:0: [sdb] Synchronizing SCSI cache

========================================================================

>
> Regards,
>
> Hans
