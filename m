From: Adrian Sandu <dexter@d3xt3r01.tk>
Subject: Re: [usb-storage] Re: usb3 fails to write when using usb3 hub in usb3 port
Date: Wed, 26 Sep 2012 20:16:46 +0300
Message-ID: <CAEG-z2_q4k+wf9=cFP+BwLpCOjg497HiQ4X703ZaJ44tGn4wpQ@mail.gmail.com>
References: <20120925211910.GH32108@xanatos> <Pine.LNX.4.44L0.1209261042270.1727-100000@iolanthe.rowland.org>
 <CAEG-z28iDWikxzJo+JwL_XAMDN067Ru--pKpq=EeUCzXjwWpyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57211 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757554Ab2IZRRI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Sep 2012 13:17:08 -0400
Received: by padhz1 with SMTP id hz1so616901pad.19
        for <linux-scsi@vger.kernel.org>; Wed, 26 Sep 2012 10:17:07 -0700 (PDT)
In-Reply-To: <CAEG-z28iDWikxzJo+JwL_XAMDN067Ru--pKpq=EeUCzXjwWpyg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, linux-scsi@vger.kernel.org

2012-09-26T20:13:09.700606+03:00 d3xt3r01 kernel: [ 2466.455403] usb
3-1.1: reset SuperSpeed USB device number 14 using xhci_hcd
2012-09-26T20:13:09.713629+03:00 d3xt3r01 kernel: [ 2466.468373]
xhci_hcd 0000:04:00.0: xHCI xhci_drop_endpoint called with disabled ep
ffff88011aea1300
2012-09-26T20:13:09.713667+03:00 d3xt3r01 kernel: [ 2466.468384]
xhci_hcd 0000:04:00.0: xHCI xhci_drop_endpoint called with disabled ep
ffff88011aea1340
2012-09-26T20:13:44.480669+03:00 d3xt3r01 kernel: [ 2501.235365] hub
3-1:1.0: Cannot enable port 1.  Maybe the USB cable is bad?
2012-09-26T20:13:45.005111+03:00 d3xt3r01 kernel: [ 2501.759279] sd
18:0:0:0: Device offlined - not ready after error recovery
2012-09-26T20:13:45.005118+03:00 d3xt3r01 kernel: [ 2501.759300] sd
18:0:0:0: [sdb] Unhandled error code
2012-09-26T20:13:45.005125+03:00 d3xt3r01 kernel: [ 2501.759305] sd
18:0:0:0: [sdb]  Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK
2012-09-26T20:13:45.005133+03:00 d3xt3r01 kernel: [ 2501.759312] sd
18:0:0:0: [sdb] CDB: Read(10): 28 00 00 03 2c 00 00 00 f0 00
2012-09-26T20:13:45.005139+03:00 d3xt3r01 kernel: [ 2501.759328]
end_request: I/O error, dev sdb, sector 207872
2012-09-26T20:13:45.005146+03:00 d3xt3r01 kernel: [ 2501.759334]
quiet_error: 23 callbacks suppressed
2012-09-26T20:13:45.005151+03:00 d3xt3r01 kernel: [ 2501.759339]
Buffer I/O error on device sdb, logical block 25984
2012-09-26T20:13:45.005157+03:00 d3xt3r01 kernel: [ 2501.759351]
Buffer I/O error on device sdb, logical block 25985
2012-09-26T20:13:45.005163+03:00 d3xt3r01 kernel: [ 2501.759357]
Buffer I/O error on device sdb, logical block 25986
2012-09-26T20:13:45.005169+03:00 d3xt3r01 kernel: [ 2501.759363]
Buffer I/O error on device sdb, logical block 25987
The result of a simple d3xt3r01 ~ # hdparm -tT /dev/sdb

/dev/sdb:
 Timing cached reads:   1494 MB in  2.00 seconds = 747.20 MB/sec
 Timing buffered disk reads: read(2097152) returned 1572864 bytes
BLKFLSBUF failed: No such device

It didn't fail the first time though .. I just executed the same
command twice ..
Assuming that 3u is the good thing to cat ..
http://d3xt3r01.tk/~dexter/usbmon/1348679651_3u ..
( given the output in /sys/kernel/debug/usb/devices )

Hope this helps more to identify the issue ..

2012-09-26T20:13:45.005175+03:00 d3xt3r01 kernel: [ 2501.759369]
Buffer I/O error on device sdb, logical block 25988
2012-09-26T20:13:45.005182+03:00 d3xt3r01 kernel: [ 2501.759375]
Buffer I/O error on device sdb, logical block 25989
2012-09-26T20:13:45.005188+03:00 d3xt3r01 kernel: [ 2501.759382]
Buffer I/O error on device sdb, logical block 25990
2012-09-26T20:13:45.005194+03:00 d3xt3r01 kernel: [ 2501.759393] sd
18:0:0:0: rejecting I/O to offline device
2012-09-26T20:13:45.005200+03:00 d3xt3r01 kernel: [ 2501.759407] sd
18:0:0:0: [sdb] killing request
2012-09-26T20:13:45.005207+03:00 d3xt3r01 kernel: [ 2501.759415]
Buffer I/O error on device sdb, logical block 25991
2012-09-26T20:13:45.005213+03:00 d3xt3r01 kernel: [ 2501.759426]
Buffer I/O error on device sdb, logical block 25992
2012-09-26T20:13:45.005220+03:00 d3xt3r01 kernel: [ 2501.759432]
Buffer I/O error on device sdb, logical block 25993
2012-09-26T20:13:45.005227+03:00 d3xt3r01 kernel: [ 2501.759440] sd
18:0:0:0: rejecting I/O to offline device
2012-09-26T20:13:45.005233+03:00 d3xt3r01 kernel: [ 2501.759494] sd
18:0:0:0: rejecting I/O to offline device
2012-09-26T20:13:45.005240+03:00 d3xt3r01 kernel: [ 2501.759505] sd
18:0:0:0: rejecting I/O to offline device
2012-09-26T20:13:45.005246+03:00 d3xt3r01 kernel: [ 2501.759624] sd
18:0:0:0: [sdb] Unhandled error code
2012-09-26T20:13:45.005252+03:00 d3xt3r01 kernel: [ 2501.759630] sd
18:0:0:0: [sdb]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
2012-09-26T20:13:45.005259+03:00 d3xt3r01 kernel: [ 2501.759637] sd
18:0:0:0: [sdb] CDB: Read(10): 28 00 00 03 2c f0 00 00 10 00
2012-09-26T20:13:45.005267+03:00 d3xt3r01 kernel: [ 2501.759654]
end_request: I/O error, dev sdb, sector 208112
2012-09-26T20:13:45.020696+03:00 d3xt3r01 kernel: [ 2501.775198] usb
3-1.1: USB disconnect, device number 14


On Wed, Sep 26, 2012 at 7:59 PM, Adrian Sandu <dexter@d3xt3r01.tk> wrote:
> On Wed, Sep 26, 2012 at 5:50 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
>> On Tue, 25 Sep 2012, Sarah Sharp wrote:
>>
>>> Alan, I'm wondering if the xHCI ring expansion is causing issues with
>>> USB hard drives under xHCI.  Testing with a Buffalo USB 3.0 hard drive
>>> with an NEC uPD720200 xHCI host, I see that the usb-storage and SCSI
>>> initialization produces I/O errors on random sectors in 3.4.0, 3.4.6,
>>> and 3.5.0.  I can't get those errors to be reproduced in 3.3.1.
>>>
>>> The xHCI ring expansion was added in 3.4, and we changed the xHCI's
>>> sg_tablesize:
>>>
>>> int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
>>> {
>>> ...
>>>         /* Accept arbitrarily long scatter-gather lists */
>>>         hcd->self.sg_tablesize = ~0;
>>>
>>> The usb-storage driver sets the tablesize thus:
>>>
>>> static unsigned int usb_stor_sg_tablesize(struct usb_interface *intf)
>>> {
>>>         struct usb_device *usb_dev = interface_to_usbdev(intf);
>>>
>>>         if (usb_dev->bus->sg_tablesize) {
>>>                 return usb_dev->bus->sg_tablesize;
>>>         }
>>>         return SG_ALL;
>>> }
>>>
>>> I notice that SG_ALL is set to SCSI_MAX_SG_SEGMENTS, which is only 128.
>>> Should we be passing an arbitrarily large number to the SCSI core?
>>
>> Yes, there's no reason not to.  The block layer will make sure that
>> each individual request has a sufficiently small number of segments.
>>
>>> There's some wording in include/scsi/scsi.h about also limiting the
>>> number of chained sgs to 2048.  I'm wondering if we're hitting some bugs
>>> in the SCSI layer because we're setting the sg_tablesize so high.
>>
>> I doubt it.  Anyway, this stuff is handled by the block layer now, not
>> the SCSI layer.  If you look through drivers/scsi, you'll see that
>> SG_ALL is used only in various SCSI interface drivers, not in the core.
>>
>>> Alternately, we could be hitting bugs in the USB 3.0 firmware when we
>>> attempt to issue a read or write that's too big.  The read on Adrian's
>>> hard drive failed on a bigger read request (122880 bytes).  It would be
>>> interesting to see if it works fine if the xHCI sg_tablesize is limited.
>>> I'm going to try that with my own drive on 3.5.4 and see if it helps.
>>
>> There were examples in the earlier usbmon traces where 122880-byte
>> reads succeeded, for whatever that's worth...
>>
>> I doubt very much that you are anywhere close to hitting that limit.
>> If a 120-KB transfer has more than 128 SG segments then on average each
>> segment would be under 1024 bytes, a lot smaller than a page, which
>> seems unlikely.  I don't think I've ever seen a transfer needing more
>> than about 8 segments.
>>
>> Alan Stern
>>
> Ok, back to vanilla 3.4.11, disabled CONFIG_USB_XHCI_HCD_DEBUGGING ..
>
> I still see
>
> 2012-09-26T19:52:16.661604+03:00 d3xt3r01 kernel: [ 1213.416759] usb
> 3-2.4: reset SuperSpeed USB device number 11 using xhci_hcd
> 2012-09-26T19:52:16.674632+03:00 d3xt3r01 kernel: [ 1213.429351]
> xhci_hcd 0000:04:00.0: xHCI xhci_drop_endpoint called with disabled ep
> ffff88011d3c6980
> 2012-09-26T19:52:16.674665+03:00 d3xt3r01 kernel: [ 1213.429363]
> xhci_hcd 0000:04:00.0: xHCI xhci_drop_endpoint called with disabled ep
> ffff88011d3c69c0
> T:  Bus=03 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#=  8 Spd=5000 MxCh= 4
> D:  Ver= 3.00 Cls=09(hub  ) Sub=00 Prot=03 MxPS= 9 #Cfgs=  1
> P:  Vendor=2109 ProdID=0810 Rev= 3.74
> S:  Manufacturer=VIA Labs, Inc.
> S:  Product=4-Port USB 3.0 Hub
> C:* #Ifs= 1 Cfg#= 1 Atr=c0 MxPwr=  2mA
> I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
> E:  Ad=81(I) Atr=13(Int.) MxPS=   2 Ivl=4096ms
>
> T:  Bus=02 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#=  4 Spd=480  MxCh= 4
> D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=01 MxPS=64 #Cfgs=  1
> P:  Vendor=2109 ProdID=3431 Rev= 2.74
> S:  Product=USB2.0 Hub
> C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=100mA
> I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
> E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=256ms
>
> T:  Bus=03 Lev=02 Prnt=08 Port=00 Cnt=01 Dev#=  9 Spd=5000 MxCh= 0
> D:  Ver= 3.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 9 #Cfgs=  1
> P:  Vendor=1058 ProdID=1140 Rev=10.03
> S:  Manufacturer=Western Digital
> S:  Product=My Book 1140
> S:  SerialNumber=5743415A4144303235323133
> C:* #Ifs= 1 Cfg#= 1 Atr=c0 MxPwr=  2mA
> I:* If#= 0 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50 Driver=usb-storage
> E:  Ad=81(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
> E:  Ad=02(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
>
> T:  Bus=03 Lev=02 Prnt=08 Port=03 Cnt=04 Dev#= 11 Spd=5000 MxCh= 0
> D:  Ver= 3.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 9 #Cfgs=  1
> P:  Vendor=1058 ProdID=1140 Rev=10.03
> S:  Manufacturer=Western Digital
> S:  Product=My Book 1140
> S:  SerialNumber=574D415A4135343330323937
> C:* #Ifs= 1 Cfg#= 1 Atr=c0 MxPwr=  2mA
> I:* If#= 0 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50 Driver=usb-storage
> E:  Ad=81(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
> E:  Ad=02(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
>
> So I need to cat 3u .. right ? Available at
> http://d3xt3r01.tk/~dexter/usbmon/1348678668_3u
> After the copy .. I see
>
> 2012-09-26T19:52:51.477641+03:00 d3xt3r01 kernel: [ 1248.232213] hub
> 3-2:1.0: Cannot enable port 4.  Maybe the USB cable is bad?
> 2012-09-26T19:52:52.003074+03:00 d3xt3r01 kernel: [ 1248.757636] sd
> 16:0:0:0: Device offlined - not ready after error recovery
> 2012-09-26T19:52:52.003081+03:00 d3xt3r01 kernel: [ 1248.757652] sd
> 16:0:0:0: [sdd] Unhandled error code
> 2012-09-26T19:52:52.003088+03:00 d3xt3r01 kernel: [ 1248.757656] sd
> 16:0:0:0: [sdd]  Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK
> 2012-09-26T19:52:52.003095+03:00 d3xt3r01 kernel: [ 1248.757663] sd
> 16:0:0:0: [sdd] CDB: Read(10): 28 00 17 ab ab e0 00 00 f0 00
> 2012-09-26T19:52:52.003101+03:00 d3xt3r01 kernel: [ 1248.757680]
> end_request: I/O error, dev sdd, sector 397126624
> 2012-09-26T19:52:52.003107+03:00 d3xt3r01 kernel: [ 1248.757721] sd
> 16:0:0:0: rejecting I/O to offline device
> 2012-09-26T19:52:52.003112+03:00 d3xt3r01 kernel: [ 1248.757730] sd
> 16:0:0:0: [sdd] killing request
> 2012-09-26T19:52:52.003118+03:00 d3xt3r01 kernel: [ 1248.757750] sd
> 16:0:0:0: rejecting I/O to offline device
> 2012-09-26T19:52:52.003125+03:00 d3xt3r01 kernel: [ 1248.757769] sd
> 16:0:0:0: rejecting I/O to offline device
> 2012-09-26T19:52:52.003131+03:00 d3xt3r01 kernel: [ 1248.757788] sd
> 16:0:0:0: rejecting I/O to offline device
> 2012-09-26T19:52:52.003138+03:00 d3xt3r01 kernel: [ 1248.757814] sd
> 16:0:0:0: [sdd] Unhandled error code
> 2012-09-26T19:52:52.003145+03:00 d3xt3r01 kernel: [ 1248.757821] sd
> 16:0:0:0: [sdd]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> 2012-09-26T19:52:52.003152+03:00 d3xt3r01 kernel: [ 1248.757829] sd
> 16:0:0:0: [sdd] CDB: Read(10): 28 00 17 ab ac d0 00 00 10 00
> 2012-09-26T19:52:52.003159+03:00 d3xt3r01 kernel: [ 1248.757849]
> end_request: I/O error, dev sdd, sector 397126864
> 2012-09-26T19:52:52.018669+03:00 d3xt3r01 kernel: [ 1248.773433] usb
> 3-2.4: USB disconnect, device number 11
>
> While trying to copy ( using mc ) from /dev/sdb1 ( mounted /media/sdd1
> ) to /dev/sdd1 ( mounted /media/sde1 ) .. Sorry for the confusion ..
> because I don't know which ones will get in what order I use uuids in
> fstab ..
