From: Jonas Schwertfeger <jschwertfeger@gmail.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Tue, 11 May 2010 08:54:52 +0200
Message-ID: <4BE8FF3C.2030406@gmail.com>
References: <Pine.LNX.4.44L0.1005071055200.1804-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48932 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933045Ab0EKGy5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 May 2010 02:54:57 -0400
In-Reply-To: <Pine.LNX.4.44L0.1005071055200.1804-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Mark Lord <mlord@pobox.com>, Dinh.Nguyen@freescale.com, Sergei Shtylyov <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>, Douglas Gilbert <dgilbert@interlog.com>

On 05/07/2010 05:03 PM, Alan Stern wrote:
> Hmm.  I'm not sure I believe this data.  For a while (starting with
> 2.6.33) the usbmon implementation didn't work right with EHCI -- it
> looked in the transfer buffer before the DMA-unmapping was done, so on
> a system with>= 4 GB of memory it wouldn't always see the data.  The
> fix for this was merged only within the last week or so.
>
> Can you repeat the USB-2.0 test but this time doing "rmmod ehci-hcd"
> beforehand?

I could not remove that module (I assume it is compiled into the kernel) 
so I limited the memory the kernel can see to 1GB.  You were right, now 
there is actually useful data in the trace.  Here it is:

ffff88001bb82840 685088867 S Bo:1:003:2 -115 31 = 55534243 c9000000 
00020000 80001085 082e0000 00010000 00000000 40ec00
ffff88001bb82840 685088982 C Bo:1:003:2 0 31 >
ffff88001bbc3d80 685089045 S Bi:1:003:1 -115 512 <
ffff88001bbc3d80 685094708 C Bi:1:003:1 0 512 = 4000ff3f 37c81000 
00000000 3f000000 00000000 32534d35 394a5a30 30313237
ffff88001bb82840 685094763 S Bi:1:003:1 -115 13 <
ffff88001bb82840 685094814 C Bi:1:003:1 0 13 = 55534253 c9000000 00000000 00
ffff88001bb82840 685095024 S Bo:1:003:2 -115 31 = 55534243 ca000000 
00020000 80001085 082e0000 00010000 00000000 40a100
ffff88001bb82840 685095207 C Bo:1:003:2 0 31 >
ffff88001bbc3d80 685095260 S Bi:1:003:1 -115 512 <
ffff88001bbc3d80 685095457 C Bi:1:003:1 -32 0
ffff88001bb82840 685095509 S Co:1:003:0 s 02 01 0000 0081 0000 0
ffff88001bb82840 685095561 C Co:1:003:0 0 0
ffff88001bb82840 685095614 S Bi:1:003:1 -115 13 <
ffff88001bb82840 685095699 C Bi:1:003:1 0 13 = 55534253 ca000000 00020000 01
ffff88001bb82840 685095768 S Bo:1:003:2 -115 31 = 55534243 cb000000 
60000000 80000603 00000060 00000000 00000000 000000
ffff88001bb82840 685095817 C Bo:1:003:2 0 31 >
ffff88001bbc3d80 685095885 S Bi:1:003:1 -115 96 <
ffff88001bbc3d80 685096082 C Bi:1:003:1 0 96 = 720b0000 0000000e 
090c0004 00010000 00000000 40510000 00000000 00000000
ffff88001bb82840 685096136 S Bi:1:003:1 -115 13 <
ffff88001bb82840 685096207 C Bi:1:003:1 0 13 = 55534253 cb000000 00000000 00
ffff88001bb82840 685097822 S Bo:1:003:2 -115 31 = 55534243 cc000000 
00100000 80000a28 00000000 00000008 00000000 000000
ffff88001bb82840 685097947 C Bo:1:003:2 0 31 >
ffff880010e52a80 685098002 S Bi:1:003:1 -115 4096 <
ffff880010e52a80 685106944 C Bi:1:003:1 0 4096 = fab80010 8ed0bc00 
b0b80000 8ed88ec0 fbbe007c bf0006b9 0002f3a4 ea210600
ffff88001bb82840 685106999 S Bi:1:003:1 -115 13 <
ffff88001bb82840 685107075 C Bi:1:003:1 0 13 = 55534253 cc000000 00000000 00

-Jonas
