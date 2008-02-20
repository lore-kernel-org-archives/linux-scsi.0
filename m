From: Andrew Buehler <abuehler.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: USB regression (and other failures) in 2.6.2[45]* - mostly resolved
Date: Wed, 20 Feb 2008 12:06:09 -0500
Message-ID: <47BC5E01.1050902@gmail.com>
References: <Pine.LNX.4.44L0.0802201048410.4828-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.0802201048410.4828-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Oliver Pinter <oliver.pntr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kernel development list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

(I suspect that some of the existing CC:s can now be dropped, and others
might need to be added if indeed this is worth discussing on kernel
lists at all, but I don't know what the protocol on that is so I have
left all of them in for the moment.)

On 2/20/2008 10:50 AM, Alan Stern wrote:

> On Tue, 19 Feb 2008, Andrew Buehler wrote:
> 
>> With those two problems out of the way, what is left is the
>> hard-drive issue, and that is also halfway fixed by enabling ACPI.
>> Specifically, it is "fixed" in that the kernel sees the hard drive
>> and I can mount it, but it is not fixed in that the program we need
>> to use in this environment does not see the drive.
> 
> What do you mean by "does not see the drive"?

Its detect-hardware-and-report mode shows a HD size of 0 (which is what
it has showed in cases where the kernel has not detected the drive), its
detect-partitions-and-report mode shows no partitions and no devices
which can have partitions, and attempting to actually use it to pull
down a drive image (it's a disk-imaging program) causes it to hang at
the point where it would begin to write.

Hmm. One thing which just sprang to mind, in the stab-in-the-dark
category: in 2.6.24.2, launching the program on some machines gave
warnings along the lines of "this program is using a deprecated ioctl,
please convert it to SG_IO" (which I naturally cannot do since it's
closed and I don't have the source), but IIRC in the 2.5.25-rc2-based
disc with ACPI enabled no such message appears. If the reason that there
are no longer such messages is that the ioctl in question has now been
removed, that might explain why the program does not see the drive.

I have suspected that I might eventually need to port the old interface
forwards to be able to continue to use this program, but I did not
expect it to happen this soon...

>> I have a config from a boot disc running 2.6.5 (that's not a typo)
>> under which the program in question *does* see the drive, but there
>> are massive differences between that config and the one I am using
>> now, and narrowing the critical difference down is likely to be
>> somewhat difficult - particularly since some of the "differences"
>> are merely renamed config symbols (i.e. the
>> CONFIG_SCSI_SATA_*->CONFIG_SATA_* switchover), and I have limited
>> ability to tell which without intensive investigation. Are there
>> any established techniques for simplifying this kind of comparison?
> 
> The only established technique is to run various kernels intermediate
> between the one that works and the one that fails.

I'm not sure I expressed myself clearly. I do not think the problem is
with the different kernels. I think the problem is with the different
configurations. I am asking if there are any established techniques for
comparing differences between config files from widely different
kernels.

Or, if you're suggesting running various kernels with configs which are
hybrids of the config which works and the current one which does not: in
order to do that I have to be able to tell what the actual differences
are, and at minimum the renamed symbols (not all of which I expect to be
able to identify at a glance) would make that quite difficult to do, so
I remain with the same problem and the same question.

-- 
    Andrew Buehler
