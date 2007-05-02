From: Vivek Goyal <vgoyal@in.ibm.com>
Subject: Re: [PATCH] aacraid: fails to initialize after a  kexec operation
Date: Wed, 2 May 2007 09:51:15 +0530
Message-ID: <20070502042115.GB4858@in.ibm.com>
References: <20070430095334.GA17186@in.ibm.com> <AE4F746F2AECFC4DA4AADD66A1DFEF018FDB38@otce2k301.adaptec.com>
Reply-To: vgoyal@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:53116 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbXEBEVV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 May 2007 00:21:21 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l424LL4E028273
	for <linux-scsi@vger.kernel.org>; Wed, 2 May 2007 00:21:21 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l424LL6E164786
	for <linux-scsi@vger.kernel.org>; Tue, 1 May 2007 22:21:21 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l424LKhK030378
	for <linux-scsi@vger.kernel.org>; Tue, 1 May 2007 22:21:20 -0600
Content-Disposition: inline
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF018FDB38@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Kexec Mailing List <kexec@lists.infradead.org>, Judith Lebzelter <judith@linux-foundation.org>, linux-scsi@vger.kernel.org, "Darrick J. Wong" <djwong@us.ibm.com>

On Mon, Apr 30, 2007 at 10:11:03AM -0400, Salyzyn, Mark wrote:
> Foreign arrays are arrays configured on another adapter then moved over
> to the current host adapter. I do not know why this may be the case in
> your situation, but it had the smell of behaving like a foreign array
> and thus my suggestion. We use commit=1 for all situations where the
> importation of an array is not considered an error and there is no BIOS
> to intervene prior to driver load. Typically we advise to set this flag
> in embedded systems, or in non-Intel based architectures. Normally on
> Intel based systems you get a query from the card's BIOS as you boot
> that queries the user (to answer yes) to accept the array configuration
> should it be detected as foreign.
> 
> I see some problems with declaring aacraid.commit=1 for kdump, you are
> changing the storage system conditions and the fact you have a foreign
> array may have been the cause of the primary kernel's failure. You are
> rubbing out a factor in the system's failure? I would also hate to store
> a kernel dump over an array one does not know the status or origin of.
> 

Hi Mark,

How does one find from BIOS if array is local or foreign? In this machine
I have not done any migration. I have not even configured the array. I think
I am using default factory settings. If I get into the controller BIOS and
query arrays, it shows me one array of type Volume.

So if an adapter is managing both local and foreign arrays, it would online
local one upon reset but offline foreign one. So we can continue to save
dump?

By the way, when you say that foreign arrays are configured on another
adapter and then moved to current host adapter. Once the movement is
complete (I am assuming it will happen in first kernel) then what's the
issue with saving dump on foreign array. I think if applications are 
actively using the disks behind foreign array, then it should not be
unreliable to save dump on those disks?


> If there is a clean shutdown, and there are no outstanding commands from
> the OS (including the ioctl, so make sure the management software
> commands are shut down), I do not see a reason to reset the adapter.
> 

In case of normal kexec (not kdump) clean shutdown takes place. All 
filesystems are unmounted, processes stopped and from kernel we call
device_shutdown() which should shutdown the device no pending interrupt.
I am wondering why it does not happen in case of aacraid and we end up
restarting adapter even in case of clean shutdown using kexec.

> I agree, the irqpoll is troublesome! Could something else in the kexec
> kernel be catching the interrupts and dropping them on the floor? Are
> there any other devices sharing that same interrupt line that may be
> holding the interrupt asserted? /proc/irq/*, /proc/interrupts? By
> routing, I did not make it clear, but there is more than just the PCI
> hardware in control of the path of an Interrupt from the controller
> hardware to the interrupt service routine ... this may not be a pure
> issue with PCI configuration being corrupted.
> 

I will look more into it.

Thanks
Vivek
