From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Unusual unusual device Sony-Ericsson W760i
Date: Wed, 22 Jul 2009 11:31:21 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0907221121450.2935-100000@iolanthe.rowland.org>
References: <4A670DD7.6050002@canonical.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:60363 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752669AbZGVPbV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jul 2009 11:31:21 -0400
In-Reply-To: <4A670DD7.6050002@canonical.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: Stefan Bader <stefan.bader@canonical.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

This is really a question for the SCSI people, not a USB matter.  
Therefore I am forwarding it to the linux-scsi list.

On Wed, 22 Jul 2009, Stefan Bader wrote:

> Summary: This phone provides two luns which represent the internal memory and
> the other an optional memory-stick. While the memory stick suffers "only" from
> the capacity bug, the internal memory seems to return the "no sense" errors
> even for sectors farther away from the end.
> 
> I am currently a bit lacking ideas how to proceed with that. Any ideas would be
> welcome.
> 
> More detail:
> 
> Kernel versions: 2.6.28 but also confirmed to be the same on a recent mainline
> kernel (2.6.31)
> 
> All the information has been gathered on this bug report and it is confirmed
> with two different phones of the same model.
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/400652
> 
> T:  Bus=02 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#= 11 Spd=12  MxCh= 0
> D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> P:  Vendor=0fce ProdID=e0c6 Rev= 0.00
> S:  Manufacturer=Sony Ericsson
> S:  Product=Memory Stick
> S:  SerialNumber=3570670227111290
> C:* #Ifs= 1 Cfg#= 2 Atr=80 MxPwr=500mA
> I:* If#= 0 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50 Driver=usb-storage
> E:  Ad=05(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> E:  Ad=85(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> 
> LUN#0 (internal memory) returns 0x1d51c(120093) when queried for capacity. The
> usbmon trace[1] however shows, that the read request of 8 sectors starting from
> 0x1d508(120072) fails with the known no-sense error and is repeated infinitely.
> 
> Preventing vol_id from checking for raid meta-data lets the device detection
> finish. Unfortunately calling fdisk causes the end of device area to be
> accessed and I forgot that those values are in /sys as well. But the size of
> 119992 sounds like there is some gap between the end of the defined partition
> and the end of the device.
> 
> This feels a bit like some sort of host protected area, if SCSI knows such a
> thing (I don't think so). In the end I am lacking a good clue how this device
> might be handled. SINGLE_LUN does not work as it is LUN#0 which behaves that
> way and people will want to access the internal storage anyways. All other
> quirk options seem to be not matching that case (beside of FIX_CAPACITY). So I
> would be thankful for any hint possible.
> 
> Please cc me on replies as I am not subscribed. Thanks
> 
> - Stefan
> 
> 
> [1] Usbmon output of bus 2 while plugging and unplugging the phone on an
> umpatched kernel: http://launchpadlibrarian.net/29196150/normal-usbmon-2u.txt

