From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: git-acpi breakage, sym2
Date: Fri, 12 May 2006 05:23:45 -0600
Message-ID: <20060512112345.GM12272@parisc-linux.org>
References: <20060511231005.0bce3384.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060511231005.0bce3384.akpm@osdl.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-acpi@vger.kernel.org, "Brown, Len" <len.brown@intel.com>, linux-scsi@vger.kernel.org, Matthew Wilcox <willy@debian.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, May 11, 2006 at 11:10:05PM -0700, Andrew Morton wrote:
> The above bug appears to trigger a scsi or sym2 bug.  With git-acpi.patch
> present I get
> 
> sym0: <895> rev 0x2 at pci 0000:02:0c.0 irq 9
> sym0: Symbios NVRAM, ID 7, Fast-40, SE, parity checking
> sym0: SCSI BUS has been reset.
> scsi0 : sym-2.2.3
>  target0:0:0: Multiple LUNs disabled in NVRAM
>  0:0:0:0: ABORT operation started.
>  0:0:0:0: ABORT operation timed-out.
>  0:0:0:0: DEVICE RESET operation started.
>  0:0:0:0: DEVICE RESET operation timed-out.
>  0:0:0:0: BUS RESET operation started.
>  0:0:0:0: BUS RESET operation timed-out.
>  0:0:0:0: HOST RESET operation started.
> sym0: SCSI BUS has been reset.
>  0:0:0:0: HOST RESET operation timed-out.
>  0:0:0:0: scsi: Device offlined - not ready after error recovery
>  0:0:1:0: ABORT operation started.
>  0:0:1:0: ABORT operation timed-out.
>  0:0:1:0: DEVICE RESET operation started.
>  0:0:1:0: DEVICE RESET operation timed-out.
>  0:0:1:0: BUS RESET operation started.
>  0:0:1:0: BUS RESET operation timed-out.
>  0:0:1:0: HOST RESET operation started.
> sym0: SCSI BUS has been reset.
>  0:0:1:0: HOST RESET operation timed-out.
>  0:0:1:0: scsi: Device offlined - not ready after error recovery
>  0:0:2:0: ABORT operation started.
>  0:0:2:0: ABORT operation timed-out.
>  0:0:2:0: DEVICE RESET operation started.
>  0:0:2:0: DEVICE RESET operation timed-out.
>  0:0:2:0: BUS RESET operation started.
>  0:0:2:0: BUS RESET operation timed-out.
>  0:0:2:0: HOST RESET operation started.
> sym0: SCSI BUS has been reset.
> 
> ad infinitum.  How come?

Are you sure it's ad infinitum or just once for every device?
Anyway, this looks like a fairly classic "sym2 isn't getting any
interrupts" scenario.

