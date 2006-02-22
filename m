From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: Blacklist flags for SCSI target vs. SCSI LUN
Date: Tue, 21 Feb 2006 21:24:23 -0800
Message-ID: <046011E8-9BAF-465F-A90B-45569AB5477A@ieee.org>
References: <Pine.LNX.4.44L0.0602201445371.28136-100000@netrider.rowland.org>
Mime-Version: 1.0 (Apple Message framework v746.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sccrmhc13.comcast.net ([204.127.200.83]:1248 "EHLO
	sccrmhc13.comcast.net") by vger.kernel.org with ESMTP
	id S932085AbWBVFYc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2006 00:24:32 -0500
In-Reply-To: <Pine.LNX.4.44L0.0602201445371.28136-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Alan,

> If you look in the Linux source file include/scsi/scsi_devinfo.h,  
> you'll
> see a bunch of blacklist flags for coping with various sorts of device
> behaviors ...

http://lxr.linux.no/source/include/scsi/scsi_devinfo.h
shows we had named 22 device-side distortions of Scsi already by  
2.6.11 ... fun, thank you.

> ... In the past these flags have been stored per-LUN, but it's  
> obvious that some of them should apply to entire targets.  For  
> example, any flag that influences how LUN detection should be  
> performed is like this.
>
> I'd like to straighten this out, but I don't know which items  
> should be per-target and which should be per-LUN.  For that matter,  
> blacklist entries are accessed based on Vendor and Product  
> identification strings from INQUIRY data -- and I don't even know  
> whether different LUNs in the same target are allowed to supply  
> different Vendor/Product strings.

Yes we the host must decide how to count Lun's before we can address  
the first Lun we've counted ... but to connect arbitrarily I think we  
must distinguish the device from all its Lun's, and every Lun from  
one another.

If our goal is to stop revving this code frequently, I think we must  
change to store more bits, not less.  Yes we can exploit common  
patterns to allocate less bits in all normal cases, but we have no  
foundation for saying we'll never need the rarely useful bits.

I argue as follows ...

I think of the Scsi device as if it were a Usb hub, upstream from a  
set of ports that connect with slots that connect with memory cards.   
The hub services some requests itself, passes others transparently  
thru to a port or onto a slot, translates and more arbitrarily  
distributes others.

Now let's suppose we see the hub service all the Scsi op x12 Inquiry  
requests received while negotiating how many ports existed at first.   
That doesn't tell us anything about who will service the next Scsi op  
x12 request.  We're faced with all the same maybe's: maybe the hub,  
maybe a port, maybe a slot, maybe a card, maybe a combination.

Get it?

The device, distinguished from all its Lun's, is the hub.  Each Lun  
is a port.  Some hubs promise all their Lun's will always be there  
(e.g., Usb Get Max Lun), some don't (e.g., dynamic sparse Lun's in  
Scsi 3).  Some slots promise that their memory cards will always be  
there (e.g., via Scsi Rmb 0), some slots don't (e.g., via Scsi Rmb 1).

Another view with the same answer is to notice that, inside the  
device, each Scsi request carries a wide address.  For example, in  
BBB Scsi, the address bits look something like: { deviceAddress :  
selectedConfiguration : selectedInterface :  
interfaceAlternateSetting : selectedPipe : Lun }.  For the device,  
the bits of the Lun are first class address bits: an address bit is  
an address bit is an address bit.  We the host have no reason to  
believe that we'll see common Scsi behaviour when we hold some bits  
constant and not others.

So far so good?

In parallel now, I'll follow up with some concrete examples.
