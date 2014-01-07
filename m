From: walt <w41ter@gmail.com>
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst
Date: Tue, 07 Jan 2014 05:29:48 -0800
Message-ID: <52CC014C.5060604@gmail.com>
References: <20131218211219.461663463@linuxfoundation.org> <20131218211220.412278148@linuxfoundation.org> <52C32BB0.90600@gmail.com> <20140102191510.GA9621@xanatos> <52C6D9F1.9000709@gmail.com> <20140103195455.GA4193@xanatos> <52C729CE.9050307@gmail.com> <20140103232929.GD4193@xanatos> <20140107003157.GA7963@xanatos>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010204000407090401080305"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34531 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaAGN3x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jan 2014 08:29:53 -0500
In-Reply-To: <20140107003157.GA7963@xanatos>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, David Laight <david.laight@aculab.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------010204000407090401080305
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 01/06/2014 04:31 PM, Sarah Sharp wrote:
> On Fri, Jan 03, 2014 at 03:29:29PM -0800, Sarah Sharp wrote:

>>  With the dmesg, I can finally see what happened:
>>
>> [  188.703059] xhci_hcd 0000:03:00.0: Cancel URB ffff8800b7d2e0c0, dev 1, ep 0x2, starting at offset 0xbb7b9000
>> [  188.703072] xhci_hcd 0000:03:00.0: // Ding dong!
>> [  193.711022] xhci_hcd 0000:03:00.0: xHCI host not responding to stop endpoint command.
>> [  193.711029] xhci_hcd 0000:03:00.0: Assuming host is dying, halting host.
>> [  193.711046] xhci_hcd 0000:03:00.0: // Halt the HC
>> [  193.711060] xhci_hcd 0000:03:00.0: Killing URBs for slot ID 1, ep index 0
>> [  193.711066] xhci_hcd 0000:03:00.0: Killing URBs for slot ID 1, ep index 2
>> [  193.711078] xhci_hcd 0000:03:00.0: Killing URBs for slot ID 1, ep index 3
>> [  193.711096] xhci_hcd 0000:03:00.0: Calling usb_hc_died()
>> [  193.711103] xhci_hcd 0000:03:00.0: HC died; cleaning up
>> [  193.711116] xhci_hcd 0000:03:00.0: xHCI host controller is dead.
>>
>> It seems that the xHCI driver tried to stop the endpoint ring in order
>> to cancel a SCSI transfer, and the driver never got a response for that.
>>
>> The offset is rather suspicious (0xbb7b9000), and it probably means the
>> driver attempted to cancel a transfer that had been moved to the
>> beginning of the ring segment, with no-op TRBs before the link TRB.
>>
>> I suspect David's patch triggers a bug in the command cancellation code.
>> There's also the unlikely possibility that the no-op TRBs did indeed
>> cause the host to hang.  Either way, I'll have to look into it.
>>
>> I'll let you know when I have some diagnostic patches ready.
> 
> Hi Walt,
> 
> I have a couple of patches for you to test.

> Please only apply the first patch (which is diagnostic only), trigger
> your issue, and send me the resulting dmesg.  Then try applying the
> other two patches, and see if the issue goes away.  (I suspect it won't
> but I can't be sure.)

Thanks Sarah.  dmesg0 is from the diagnostic patch only.  dmesg1 has all
three patches applied.  Some of the messages in dmesg1 fell off the end of
the kernel buffer, so I may need to make the buffer larger next time but
I'll need a reminder of how to do it.

As you suspected, the patches didn't fix the problem, sorry.

I find that I can tell in advance whether the copy is going to succeed,
just by watching the light flicker on the usb3 drive.  When the flicker
is absolutely regular, with no variation whatever, I can tell in 10 or
15 seconds that the copy will fail.

At the same time the light on the main drive goes dark after 10 seconds,
implying that the usb3 drive stops receiving any data from the main drive
after 10 seconds, yet the light on the usb3 drive continues to flicker as
if writing data -- even after the cp officially fails.  The light on the
usb3 drive never stops flickering until I reboot the machine or unplug
the usb cable.


--------------010204000407090401080305
Content-Type: application/gzip;
 name="dmesg0.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dmesg0.gz"

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
--------------010204000407090401080305
Content-Type: application/gzip;
 name="dmesg1.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dmesg1.gz"

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
r5m7yFtb/weRWGP7hNQAAA==
--------------010204000407090401080305--
