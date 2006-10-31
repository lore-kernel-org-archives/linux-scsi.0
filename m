From: linas@austin.ibm.com (Linas Vepstas)
Subject: Re: PCI error recovery for the Emulex LPFC
Date: Tue, 31 Oct 2006 11:19:02 -0600
Message-ID: <20061031171902.GP6360@austin.ibm.com>
References: <20061030222047.GN6360@austin.ibm.com> <454754CC.8040308@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37351 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1423482AbWJaRTI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Oct 2006 12:19:08 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e1.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k9VHJ7Su003964
	for <linux-scsi@vger.kernel.org>; Tue, 31 Oct 2006 12:19:07 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k9VHJ3er078322
	for <linux-scsi@vger.kernel.org>; Tue, 31 Oct 2006 10:19:03 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k9VHJ3rk000416
	for <linux-scsi@vger.kernel.org>; Tue, 31 Oct 2006 10:19:03 -0700
Content-Disposition: inline
In-Reply-To: <454754CC.8040308@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: linux-scsi@vger.kernel.org, rlary@us.ibm.com

On Tue, Oct 31, 2006 at 08:51:08AM -0500, James Smart wrote:
> Linas,
> 
> I don't know of anything in this area.
> I also need a deeper understand of what the error was, and how,
> that was injected. This play into it.

When the PCI slot is frozen, the PCI bridge will block all writes
to the device, and will return all 0xffffffff for reads. All DMA
will be prevented from going through. 

> Also, PCI error recovery is not a simple task. 

I've implemented it for the ipr and symbios SCSI controllers, 
and for the e100, e1000, ixgb and s2io ethernet cards.  If you 
revew the actual code, you will see its fairly tiny. Mostly
I've discovered that if the device driver has clean, clear-cut 
device-up/device-down routines, then recovery is straightforward.

FWIW, I've run some of the kernels & devices through 48-hour runs 
with thousands of errors injected and successfully recovered from.

> There are many
> aspects to the adapter messaging interface and the affects of the
> PCI error recovery scheme that has to be closely looked at. DMA
> errors can be very fatal, even if the PCI bus survives. In many
> cases, the only safe recovery is a hard adapter reset (with little
> to no interaction with the adapter to clean up). 

Currently, all of the device drivers I mention above perform the 
recovery with a hard reset. The generic API does not require this,
but this seems to be the simplest, most robust/reliable route.
I experimeted with non-hard-reset on the s2io, which I got "almost
working". I don't know that its worth the trouble.

Just to be clear, I'm refering to the infrastructure documented 
in Documentation/pci-error-recovery.txt

--linas

