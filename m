From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: usb hdd problems with 2.6.27.2
Date: Mon, 27 Oct 2008 10:24:14 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0810271007030.4059-100000@iolanthe.rowland.org>
References: <20081027112803.GA4398@bit.office.eurotux.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20081027112803.GA4398-oEplIgxCSygGFt9iVWuREaMaJEuR8uiQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Luciano Rocha <luciano-YWehAnL2kLNBDgjK7y7TUQ@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, Linux-Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 27 Oct 2008, Luciano Rocha wrote:

> On Sat, Oct 25, 2008 at 03:50:07PM -0400, Alan Stern wrote:
> > On Sat, 25 Oct 2008, Rafael J. Wysocki wrote:
> > 
> > > [Adding CCs]
> > > 
> > > On Wednesday, 22 of October 2008, Luciano Rocha wrote:
> > > > 
> > > > Hello,
> > > > 
> > > > An external HDD, usb-encased, works fine under 2.6.26.5, but under
> > > > 2.6.27.2 I get hundreds of errors per second, of 'No Sense [current]'.
> > 
> > You can use usbmon to capture the details of what happens when you plug
> > in the drive.  Instructions are in the kernel source file
> > Documentation/usb/usbmon.txt.
> > 
> 
> Now in 2.6.27.4, same problem. The usb traffic is:

This looks exactly like the "infinite retry" problem I warned about 
earlier.  Here are the important parts of the log.  For people who 
don't know how to interpret these messages, the CDB starts in the 16th 
byte of the 31-byte messages.  For example, the first command here 
starts with 0x25 and so it is READ CAPACITY:

> f21e7cc0 3570408174 S Bo:1:008:1 -115 31 = 55534243 06000000 08000000 80000a25 00000000 00000000 00000000 000000
> f21e7cc0 3570408264 C Bo:1:008:1 0 31 >
> f21e72c0 3570408280 S Bi:1:008:2 -115 8 <
> f21e72c0 3570408389 C Bi:1:008:2 0 8 = 2e9390b0 00000200
> f21e7cc0 3570408400 S Bi:1:008:2 -115 13 <
> f21e7cc0 3570408513 C Bi:1:008:2 0 13 = 55534253 06000000 00000000 00

The response is 0x2e9390b0.  In typical broken fashion, that is 
undoubtedly the total number of sectors rather than the highest sector 
number.

Later on the system tries to read the contents of what it thinks is the 
last sector:

> f21e7cc0 3570515635 S Bo:1:008:1 -115 31 = 55534243 0c000000 00020000 80000a28 002e9390 b0000001 00000000 000000
> f21e7cc0 3570515762 C Bo:1:008:1 0 31 >
> f21e76c0 3570515776 S Bi:1:008:2 -115 512 <
> f21e76c0 3570516261 C Bi:1:008:2 -32 0
> f21e7cc0 3570516281 S Co:1:008:0 s 02 01 0000 0082 0000 0
> f21e7cc0 3570516387 C Co:1:008:0 0 0
> f21e7cc0 3570516399 S Bi:1:008:2 -115 13 <
> f21e7cc0 3570516511 C Bi:1:008:2 0 13 = 55534253 0c000000 00020000 01

There's no data in the response, and the 01 on the line above 
indicates Check Condition status.

> f21e7cc0 3570516524 S Bo:1:008:1 -115 31 = 55534243 0d000000 12000000 80000603 00000012 00000000 00000000 000000
> f21e7cc0 3570516636 C Bo:1:008:1 0 31 >
> f21e76c0 3570516649 S Bi:1:008:2 -115 18 <
> f21e76c0 3570516762 C Bi:1:008:2 0 18 = 70000000 0000000a 00000000 00000000 0000
> f21e7cc0 3570516779 S Bi:1:008:2 -115 13 <
> f21e7cc0 3570516886 C Bi:1:008:2 0 13 = 55534253 0d000000 00000000 00

The automatically-generated REQUEST SENSE gets the 18-byte response you 
see above.  It is entirely empty (No Sense).

The remainder of the trace shows the same command being repeated over 
and over again, with the same result each time.

> f21e7cc0 3570516936 S Bo:1:008:1 -115 31 = 55534243 0e000000 00020000 80000a28 002e9390 b0000001 00000000 000000
> f21e7cc0 3570517012 C Bo:1:008:1 0 31 >
> f21e76c0 3570517031 S Bi:1:008:2 -115 512 <
> f21e76c0 3570517511 C Bi:1:008:2 -32 0
> f21e7cc0 3570517533 S Co:1:008:0 s 02 01 0000 0082 0000 0
> f21e7cc0 3570517637 C Co:1:008:0 0 0
> f21e7cc0 3570517648 S Bi:1:008:2 -115 13 <
> f21e7cc0 3570517762 C Bi:1:008:2 0 13 = 55534253 0e000000 00020000 01
> f21e7cc0 3570517775 S Bo:1:008:1 -115 31 = 55534243 0f000000 12000000 80000603 00000012 00000000 00000000 000000
> f21e7cc0 3570517886 C Bo:1:008:1 0 31 >
> f21e76c0 3570517897 S Bi:1:008:2 -115 18 <
> f21e76c0 3570518011 C Bi:1:008:2 0 18 = 70000000 0000000a 00000000 00000000 0000
> f21e7cc0 3570518027 S Bi:1:008:2 -115 13 <
> f21e7cc0 3570518136 C Bi:1:008:2 0 13 = 55534253 0f000000 00000000 00
etc...

There's a patch which might help resolve this problem:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=8bfa24727087d7252f9ecfb5fea2dfc92d797fbd

It is already present in 2.6.28-rc1, so it's worth a try.  If it does
fix things, let me know so I can submit it for a future 2.6.27.stable
release.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
