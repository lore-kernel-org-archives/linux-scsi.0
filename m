From: Andrew Buehler <abuehler.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: USB regression (and other failures) in 2.6.2[45]* - mostly resolved
Date: Tue, 19 Feb 2008 15:35:45 -0500
Message-ID: <47BB3DA1.8040001@gmail.com>
References: <Pine.LNX.4.44L0.0802162210110.13745-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.0802162210110.13745-100000-pYrvlCTfrz9XsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Oliver Pinter <oliver.pntr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kernel development list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 2/16/2008 10:35 PM, Alan Stern wrote:

> On Sat, 16 Feb 2008, Andrew Buehler wrote:

>> Until this thread, I was not even aware that ACPI was related to
>> USB; I had largely conflated it with a similar acronym which I
>> think is related to power management and which I can suddenly not
>> even find in my kernel config. I will, however, look into
>> linux-acpi.
> 
> ACPI isn't directly related to USB; rather it has to do with
> transferring information between the OS and the
> BIOS/vendor-specific-hardware. Power management is example where such
> a transfer is needed. In your case, the relevant information is
> which IRQ is connected to which motherboard device. If you don't have
> ACPI enabled in your configuration, then perhaps that's the problem
> -- try enabling it.

Apparently it was the problem; enabling ACPI has fixed not only the USB
problem but also the network problem (somewhat miraculously, since I'm
quite certain that I had ACPI enabled in a 2.6.23.x kernel where the
network did not work despite an apparently matching driver).

I feel somewhat foolish for having reported a regression over what turns
out to have been a simple misconfiguration, but I still do think it's
somewhat misleading at best for something so potentially important to
completely non-power-related things to be buried under the heading of
power management... I would suggest moving it somewhere else in the
config and the dependencies, except that I have neither a suggestion for
a possible place nor any idea of how much actual work that would
involve.



With those two problems out of the way, what is left is the hard-drive
issue, and that is also halfway fixed by enabling ACPI. Specifically, it
is "fixed" in that the kernel sees the hard drive and I can mount it,
but it is not fixed in that the program we need to use in this
environment does not see the drive.

I have a config from a boot disc running 2.6.5 (that's not a typo) under
which the program in question *does* see the drive, but there are
massive differences between that config and the one I am using now, and
narrowing the critical difference down is likely to be somewhat
difficult - particularly since some of the "differences" are merely
renamed config symbols (i.e. the CONFIG_SCSI_SATA_*->CONFIG_SATA_*
switchover), and I have limited ability to tell which without intensive
investigation. Are there any established techniques for simplifying this
kind of comparison?

-- 
    Andrew Buehler
