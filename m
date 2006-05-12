From: Andrew Morton <akpm@osdl.org>
Subject: Re: git-acpi breakage, sym2
Date: Fri, 12 May 2006 04:25:04 -0700
Message-ID: <20060512042504.33b1ad20.akpm@osdl.org>
References: <20060511231005.0bce3384.akpm@osdl.org>
	<20060512112345.GM12272@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:40164 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751229AbWELL2F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 May 2006 07:28:05 -0400
In-Reply-To: <20060512112345.GM12272@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-acpi@vger.kernel.org, len.brown@intel.com, linux-scsi@vger.kernel.org, willy@debian.org

Matthew Wilcox <matthew@wil.cx> wrote:
>
> On Thu, May 11, 2006 at 11:10:05PM -0700, Andrew Morton wrote:
> > The above bug appears to trigger a scsi or sym2 bug.  With git-acpi.patch
> > present I get
> > 
> > sym0: <895> rev 0x2 at pci 0000:02:0c.0 irq 9
> > sym0: Symbios NVRAM, ID 7, Fast-40, SE, parity checking
> > sym0: SCSI BUS has been reset.
> > scsi0 : sym-2.2.3
> >  target0:0:0: Multiple LUNs disabled in NVRAM
> >  0:0:0:0: ABORT operation started.
> >  0:0:0:0: ABORT operation timed-out.
> >  0:0:0:0: DEVICE RESET operation started.
> >  0:0:0:0: DEVICE RESET operation timed-out.
> >  0:0:0:0: BUS RESET operation started.
> >  0:0:0:0: BUS RESET operation timed-out.
> >  0:0:0:0: HOST RESET operation started.
> > sym0: SCSI BUS has been reset.
> >  0:0:0:0: HOST RESET operation timed-out.
> >  0:0:0:0: scsi: Device offlined - not ready after error recovery
> >  0:0:1:0: ABORT operation started.
> >  0:0:1:0: ABORT operation timed-out.
> >  0:0:1:0: DEVICE RESET operation started.
> >  0:0:1:0: DEVICE RESET operation timed-out.
> >  0:0:1:0: BUS RESET operation started.
> >  0:0:1:0: BUS RESET operation timed-out.
> >  0:0:1:0: HOST RESET operation started.
> > sym0: SCSI BUS has been reset.
> >  0:0:1:0: HOST RESET operation timed-out.
> >  0:0:1:0: scsi: Device offlined - not ready after error recovery
> >  0:0:2:0: ABORT operation started.
> >  0:0:2:0: ABORT operation timed-out.
> >  0:0:2:0: DEVICE RESET operation started.
> >  0:0:2:0: DEVICE RESET operation timed-out.
> >  0:0:2:0: BUS RESET operation started.
> >  0:0:2:0: BUS RESET operation timed-out.
> >  0:0:2:0: HOST RESET operation started.
> > sym0: SCSI BUS has been reset.
> > 
> > ad infinitum.  How come?
> 
> Are you sure it's ad infinitum or just once for every device?

I have a single card talking to a single disk.  I whacked it after a couple
of minutes.

> Anyway, this looks like a fairly classic "sym2 isn't getting any
> interrupts" scenario.

It is - Len found that one.
