From: thomas schorpp <t.schorpp@gmx.de>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating SMART/ATA-Security
 in usb-storage driver
Date: Mon, 07 Nov 2005 18:54:58 +0100
Message-ID: <436F94F2.2080306@gmx.de>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF3F@WDSCEXBECL03.sc.wdc.com> <1131130707.3532.45.camel@mulgrave> <20051104203004.GF12384@one-eyed-alien.net> <1131137395.3532.57.camel@mulgrave> <20051105235522.GA21733@one-eyed-alien.net> <1131238146.9430.7.camel@mulgrave> <20051106215856.GA28452@one-eyed-alien.net> <436E8394.2010600@gmx.de> <20051106235213.GA479@us.ibm.com> <20051107170525.GB26509@one-eyed-alien.net> <20051107172421.GA15710@us.ibm.com>
Reply-To: t.schorpp@gmx.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20051107172421.GA15710@us.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Timothy Thelin <Timothy.Thelin@wdc.com>, usb-storage@lists.one-eyed-alien.net, linux-ide@vger.kernel.org, Linux SCSI list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> On Mon, Nov 07, 2005 at 09:05:25AM -0800, Matthew Dharm wrote:
> 
> 
>>Okay, what am I missing?
>>
>>Looking at that patch, it looks to me like if sg.c set a flag in the SCSI
>>command block then scsi_core.c could use that flag in the test to determine
>>if the LUN should be masked-in.
>>
>>HOWEVER, I keep hearing that the changes will be extensive.  What am I
>>missing?
> 
> 
> Not extensive AFAICT ... 
> 
> The scmd/cdb is not available until we call scsi_get_command() in the
> request function. So you would have to add a field into scsi_request, set
> it in sg (in both sg.c block/scsi_ioctl.c, test via sd and sg when you are
> done), and add the field in scsi_cmnd, and set scmd one in
> scsi_init_cmd_from_req().

i'll wait for maintainers decisions before touching code.

> 
> But as far as black listing, it does seem like a better solution in that
> user apps do not need special code.
> 
> Do the devices that require it (well so far) have useable vendor + model
> strings or usb id's?
> 
> -- Patrick Mansfield
> 
> 

most no name boxes use brigde manu id's although cypress claims on web 
this was not allowed (here the older A-brigde chip, model go-usb2):

Bus 004 Device 003: ID 04b4:6830 Cypress Semiconductor Corp. USB-2.0 IDE Adapter
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x04b4 Cypress Semiconductor Corp.
  idProduct          0x6830 USB-2.0 IDE Adapter
  bcdDevice            0.01
  iManufacturer          56 Cypress Semiconductor
  iProduct               78 USB2.0 Storage Device
  iSerial               100 DEF1092E5AC4
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           32
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xc0
      Self Powered
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     80 Bulk (Zip)
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x88  EP 8 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  bNumConfigurations      1
tom1:~# 
