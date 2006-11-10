From: Anton Vorontsov <cbou@mail.ru>
Subject: Re: [linux-usb-devel] 2.6.19-rc5-mm1
Date: Fri, 10 Nov 2006 23:17:25 +0300
Message-ID: <20061110201725.GA7341@localhost>
References: <20061109192658.GA2560@inferi.kami.home> <Pine.LNX.4.44L0.0611091655080.2262-100000@iolanthe.rowland.org> <20061109145100.01d6ec46.akpm@osdl.org> <f56c1ba00611091539n1d1cbe99obdb1c5f608646c96@mail.gmail.com> <20061109161123.f9cea1e7.akpm@osdl.org>
Reply-To: cbou@mail.ru
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1946373AbWKJTPq@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20061109161123.f9cea1e7.akpm@osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: =?koi8-r?B?PT9JU08tODg1OS0xP1E/?= C=E9dric?= Augonnet <cedric.augonnet@gmail.com>, Alan Stern <stern@rowland.harvard.edu>, Benoit Boissinot <bboissin@gmail.com>, Mattia Dongili <malattia@linux.it>, USB development list <linux-usb-devel@lists.sourceforge.net>, Kernel development list <linux-kernel@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, kernel-discuss@handhelds.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Nov 09, 2006 at 04:11:23PM -0800, Andrew Morton wrote:
> On Fri, 10 Nov 2006 00:39:46 +0100
> "C__dric Augonnet" <cedric.augonnet@gmail.com> wrote:
> 
> > 2006/11/9, Andrew Morton <akpm@osdl.org>:
> > 
> > >
> > > hm.  Maybe it's the disk_sysfs_symlinks() changes.
> > >
> > > Could someone who can reproduce this please try this revert, on
> > > 2.6.19-rc2-mm2 through 2.6.19-rc5-mm1?
[...]
> > 
> > Hi,
> > 
> > This patch seems to be working : whereas i had the same oops as Mattia
> > each time I unplugged my USB external DD drive, now it does not happen
> > anymore.
> > Thank you very much for this one !
> > 
> 
> OK, thanks.  I dropped the patch.  So ide-cs will now start deadlocking
> again.

No, it will not. I'm really sorry, mainline was already fixed at
2.6.17-rc5 time by that commit:
http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=1a2acc9e9214699a99389e323e6686e9e0e2ca67

But for some reason handhelds.org kernel tree's block/genhd.c file was
unsynchronized with mainline. I've revealed that only after my patch was
removed and I've started to investigate SCSI oops issue triggered by my
patch.

Resume: mainline do not need my patch, handhelds.org's kernel should be
synchronized with mainline.

-- Anton (irc: bd2)
