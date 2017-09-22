From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: usb/storage/uas: slab-out-of-bounds in uas_probe
Date: Fri, 22 Sep 2017 10:58:36 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1709221055260.1873-100000@iolanthe.rowland.org>
References: <20170922080927.GA12795@kroah.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170922080927.GA12795@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrey Konovalov <andreyknvl@google.com>, Oliver Neukum <oneukum@suse.com>, USB list <linux-usb@vger.kernel.org>, linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, LKML <linux-kernel@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Kostya Serebryany <kcc@google.com>, syzkaller <syzkaller@googlegroups.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 22 Sep 2017, Greg Kroah-Hartman wrote:

> On Fri, Sep 22, 2017 at 09:58:15AM +0200, Greg Kroah-Hartman wrote:
> > On Thu, Sep 21, 2017 at 03:04:05PM -0400, Alan Stern wrote:
> > > On Thu, 21 Sep 2017, Andrey Konovalov wrote:
> > > 
> > > > On Thu, Sep 21, 2017 at 6:10 PM, Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > > On Thu, Sep 21, 2017 at 05:39:05PM +0200, Andrey Konovalov wrote:
> > > > >> Hi!
> > > > >>
> > > > >> I've got the following report while fuzzing the kernel with syzkaller.
> > > > >>
> > > > >> On commit ebb2c2437d8008d46796902ff390653822af6cc4 (Sep 18).
> > > > >>
> > > > >> The issue occurs when we iterate over interface altsettings, but I
> > > > >> don't see the driver doing anything wrong. I might be missing
> > > > >> something, or this might be an issue in USB core altsettings parsing.
> > > > >
> > > > >
> > > > > Any chance you happen to have the descriptors that you were feeding into
> > > > > the kernel at this crash?  That might help in figuring out what "went
> > > > > wrong".
> > > > 
> > > > Here's the data that I feed into dummy_udc:
> > > > 
> > > > 00 00 00 00 09 02 12 00 01 34 05 80 07 09 04 6e
> > > > 09 00 08 06 62 00 12 01 05 00 cb f7 71 83 04 00
> > > > 05 00 ab f6 07 81 08 01
> > > > 
> > > > Also attaching a C reproducer (requires dummy_hcd and gadgetfs) and my .config.
> > > 
> > > Why do your reproducers use an mmap'ed array for their data instead of 
> > > a plain old statically allocated array?
> > > 
> > > Anyway, this turns out to be a genuine (and subtle!) bug in the uas
> > > driver.  The uas_find_uas_alt_setting() routine in uas-detect.h returns
> > > a bAlternateSetting value, but then the uas_use_uas_driver() routine
> > > uses this value as an index to the altsetting array -- which it isn't.  
> > > 
> > > Normally this doesn't cause any problems because the the entries in the
> > > array have bAlternateSetting values 0, 1, etc., so the value is equal
> > > to the index.  But in your fuzzed case, that wasn't true.
> > > 
> > > The patch below fixes this bug, by returning a pointer to the 
> > > alt-setting entry instead of either the value or the index.  Pointers 
> > > are less subject to misinterpretation.
> > 
> > Ugh, messy, nice catch and fix, I'll go queue it up now, thanks for
> > resolving this.
> 
> Oops, no, you didn't send this as a "real" patch yet, I'll wait :)

I was waiting for Andrey to verify that the problem was really gone.  
I'll submit it officially later today.

On Fri, 22 Sep 2017, Felipe Balbi wrote:

> > Felipe, any objection for me taking this, and the other gadget driver
> > fixes that Alan just sent out, directly in my tree?
>
> none whatsoever, for all of them:

There's still more to come.  I've got four patches for dummy-hcd just 
about ready to send.  :-)

Alan Stern
