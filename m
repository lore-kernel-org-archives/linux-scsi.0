From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: Blacklist flags for SCSI target vs. SCSI LUN
Date: Tue, 21 Feb 2006 21:43:12 -0800
Message-ID: <4AC284B3-8587-4B44-AA79-A222C77643E0@ieee.org>
References: <Pine.LNX.4.44L0.0602201445371.28136-100000@netrider.rowland.org> <046011E8-9BAF-465F-A90B-45569AB5477A@ieee.org>
Mime-Version: 1.0 (Apple Message framework v746.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sccrmhc12.comcast.net ([204.127.200.82]:33235 "EHLO
	sccrmhc12.comcast.net") by vger.kernel.org with ESMTP
	id S1751338AbWBVFnQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2006 00:43:16 -0500
In-Reply-To: <046011E8-9BAF-465F-A90B-45569AB5477A@ieee.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

>> http://lxr.linux.no/source/include/scsi/scsi_devinfo.h
>>
>> ... Yes we the host must decide how to count Lun's before we can  
>> address the first Lun we've counted ... but to connect arbitrarily  
>> I think we must distinguish the device from all its Lun's, and  
>> every Lun from one another.

Let's focus a moment on:

15 #define BLIST_ISROM             0x100   /* Treat as (removable) CD- 
ROM */

And let's drill down further to discuss only Scsi thru Usb devices,  
not Scsi generally.

The relevant theory published at T10.org and Usb.org includes:

/// http://t10.org/scsi-3.htm [paraphrased]

Scsi Peripheral Device Type = Pdt = mask x1F of byte 0 of data in of  
Scsi op x12 Inquiry.

Pdt in x 0E 07 04 00 = like Hdd of T10 tradition
Pdt = x05 = like Dvd/Cd of Sff tradition
Pdt = x01= like Tape of T10 tradition

/// Usb.org usbmassbulk_10.pdf

3.2 Get Max LUN (class-specific request)

The device may implement several logical units that share common  
device characteristics
...
The Get Max LUN device request is used to determine the number of  
logical units supported by the device. Logical Unit Numbers on the  
device shall be numbered contiguously starting from LUN 0 to a  
maximum LUN of 15 (Fh).

///

That "common device characteristics" English from Usb.org is trying  
to say that all Lun's hold in common a single Pdt code.  That is, the  
host should only have to store the Pdt once per device, not once per  
Lun.

Exactly the kind of simplification we're hoping to find, yes?

Trouble is, back in the horrifyingly real world, suppose I combine a  
3.5" Fdd slot with a 5" Dvd slot and connect via BBB Scsi-thru-Usb.   
To split the Scsi requests between Fdd and Dvd, I've then got to feed  
a mux with one or more bits from the list: { deviceAddress :  
selectedConfiguration : selectedInterface :  
interfaceAlternateSetting : selectedPipe : Lun }.

Q: Which are the cheapest bits for me to connect to my mux?

A: The Lun bits, by far.

Those connect from the Cbw parse - often changing nothing but  
firmware, rather than also the (long lead time) controller hardware.   
Usb is more theory than practice in letting me vary  
{ selectedConfiguration : selectedInterface :  
interfaceAlternateSetting : selectedPipe }.  Variations in  
{ deviceAddress } get me into expensive custom hub hardware, kicking  
me out of commodity mass storage.  Of all the address bits, only the  
Lun bits are cheap.

So by claiming that Scsi alone counts as my "common device  
characteristics", without bothering to hold my Pdt in common across  
the Lun's, I save money, on every device manufactured.  And my  
Windows market device works in Windows, when last I checked with a  
simulation like drivers/usb/gadget/file_storage.c.

Rumour, be it truth or slander, tells me Ppc Mac's take the stricter  
view, and see only my first Lun.  Ouch, that's a cost.  But is that  
cost greater than what I saved?  Maybe not, depending on how I'm  
going to market my device.

Bottom line, to talk to that Windows market device, Linux has to  
store as many per-Lun bits as Windows does.

Get it?
