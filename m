From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: usb/storage/uas: slab-out-of-bounds in uas_probe
Date: Fri, 22 Sep 2017 09:58:15 +0200
Message-ID: <20170922075815.GC7482@kroah.com>
References: <CAAeHK+yVXYJrVKW++kE+cXp=TMoDRCzPVd7G1X4YCueMbJF4HA@mail.gmail.com>
 <Pine.LNX.4.44L0.1709211456370.1294-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1709211456370.1294-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrey Konovalov <andreyknvl@google.com>, Oliver Neukum <oneukum@suse.com>, USB list <linux-usb@vger.kernel.org>, linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, LKML <linux-kernel@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Kostya Serebryany <kcc@google.com>, syzkaller <syzkaller@googlegroups.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 21, 2017 at 03:04:05PM -0400, Alan Stern wrote:
> On Thu, 21 Sep 2017, Andrey Konovalov wrote:
> 
> > On Thu, Sep 21, 2017 at 6:10 PM, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > > On Thu, Sep 21, 2017 at 05:39:05PM +0200, Andrey Konovalov wrote:
> > >> Hi!
> > >>
> > >> I've got the following report while fuzzing the kernel with syzkaller.
> > >>
> > >> On commit ebb2c2437d8008d46796902ff390653822af6cc4 (Sep 18).
> > >>
> > >> The issue occurs when we iterate over interface altsettings, but I
> > >> don't see the driver doing anything wrong. I might be missing
> > >> something, or this might be an issue in USB core altsettings parsing.
> > >
> > >
> > > Any chance you happen to have the descriptors that you were feeding into
> > > the kernel at this crash?  That might help in figuring out what "went
> > > wrong".
> > 
> > Here's the data that I feed into dummy_udc:
> > 
> > 00 00 00 00 09 02 12 00 01 34 05 80 07 09 04 6e
> > 09 00 08 06 62 00 12 01 05 00 cb f7 71 83 04 00
> > 05 00 ab f6 07 81 08 01
> > 
> > Also attaching a C reproducer (requires dummy_hcd and gadgetfs) and my .config.
> 
> Why do your reproducers use an mmap'ed array for their data instead of 
> a plain old statically allocated array?
> 
> Anyway, this turns out to be a genuine (and subtle!) bug in the uas
> driver.  The uas_find_uas_alt_setting() routine in uas-detect.h returns
> a bAlternateSetting value, but then the uas_use_uas_driver() routine
> uses this value as an index to the altsetting array -- which it isn't.  
> 
> Normally this doesn't cause any problems because the the entries in the
> array have bAlternateSetting values 0, 1, etc., so the value is equal
> to the index.  But in your fuzzed case, that wasn't true.
> 
> The patch below fixes this bug, by returning a pointer to the 
> alt-setting entry instead of either the value or the index.  Pointers 
> are less subject to misinterpretation.

Ugh, messy, nice catch and fix, I'll go queue it up now, thanks for
resolving this.

greg k-h
