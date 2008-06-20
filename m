From: "Vegard Nossum" <vegard.nossum-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before mounting root
Date: Fri, 20 Jun 2008 17:15:43 +0200
Message-ID: <19f34abd0806200815t49b59df9sd9567b52482eaee3@mail.gmail.com>
References: <20080619182310.GA30833@parisc-linux.org>
	 <Pine.LNX.4.44L0.0806191735570.2229-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.0806191735570.2229-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Content-Disposition: inline
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Matthew Wilcox <matthew-Ztpu424NOJ8@public.gmane.org>, Pekka J Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Stefan Richter <stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dsd-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org, mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vegardno-6miFZF/5cTBuMpJDpNschA@public.gmane.org, James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

On Thu, Jun 19, 2008 at 11:39 PM, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org> wrote:
> On Thu, 19 Jun 2008, Matthew Wilcox wrote:
>
>> This discussion seemed to die off ... did anything ever come of it?
>
> As I recall, it died because the whole notion was very poorly defined
> to begin with.  The idea was to stop waiting when all the SCSI buses
> had been scanned -- but there's no way to know when that occurs because
> new buses can be added at any time.

Can you please explain why this is?

We only want to scan buses that are present when the system is
started. If we reach the point where all USB ports/devices/whatever
have been enumerated, all SCSI buses scanned, and all partition tables
loaded, what more is there to wait for?

I can't understand that this is fundamentally a hardware problem. I
understand that there might be a problem with the patch that was
proposed a the beginning of the thread, but is this really a truly
unsolvable problem? Please correct me if I am wrong -- the problem
here is that Pekka's newly introduced nr_root_scans can drop to 0
before everything has been enumerated at least once. This is because
scsi_scan_host() forks a new thread which is what's actually doing the
scanning. Can't we just stick a begin_root_scan() before forking, and
drop it inside the thread, just like we do with the
usb_stor_scan_thread? If the thread is actually a loop, the first
iteration should be enough, right?

I'm grateful for any explanations that will help my poor head understand... :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
