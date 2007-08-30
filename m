From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Add ACCUSYS RAID driver for Linux i386/x86-64
Date: Wed, 29 Aug 2007 23:58:18 -0700
Message-ID: <20070829235818.c656b188.akpm@linux-foundation.org>
References: <10BD353233FA5448B2E9C3C9005057584471D7@exchange2.accusys.com.tw>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756046AbXH3G6l@vger.kernel.org>
In-Reply-To: <10BD353233FA5448B2E9C3C9005057584471D7@exchange2.accusys.com.tw>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Chan =?UTF-8?B?6Km55a625piM?= <peter_chan@accusys.com.tw>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Accusys_JeffChang <jeffchang@accusys.com.tw>, "Accusys_Y.T.Huang" <ythuang@accusys.com.tw>, Accusys_Preng <preng@rd.accusys.com.tw>, thwu@accusys.com.tw, James Bottomley <James.Bottomley@steeleye.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 30 Aug 2007 13:45:06 +0800 Peter Chan =E8=A9=B9=E5=AE=B6=E6=98=8C=
 <peter_chan@accusys.com.tw> wrote:

> Dear Morton
>=20
> ACCUSYS Inc dedicated to design PCI-e RAID HBA, hence we would like t=
o provide our driver bundle in kernel 2.6 for user.

Thank you!

> Could you kindly take a look attached file if it looks like Linux Dri=
ver?

It looks a bit like a Linux driver ;)  More on this below.

> If you need the RAID card to verify please let me know.

I personally am unlikely to make the time to test a specific HBA driver=
=2E=20
But perhaps James or one of the other scsi developers (or any developer=
 at
all) might like to volunteer to help out with testing, in which case ye=
s,
please do send out a card or two.


=46irst up, please become familar with the way in which we handle code =
patches.
I'd suggest that you subscribe to the linux-kernel or linux-scsi mailin=
g
lists for a while, watch how other people prepare and present their pat=
ches.

Download, install and become familiar with quilt
(http://savannah.nongnu.org/projects/quilt) and use that to prepare pat=
ches.
quilt can also be used to email patches which might prove useful: new
kernel developers frequently have trouble with wordwrapping, tab-to-spa=
ce
conversion and other ways in which mail clients corrupt patches.

Once you have quilt up and running you should convert this driver into =
a
single patch against Linus's latest kernel.  At this time, that is
2.6.23-rc4.

That patch should include the appropriate changes to drivers/scsi/Kconf=
ig
and drivers/scsi/Makefile to wire this driver up to the kernel
configuration and build system.  (You may choose to create a separate
directory drivers/scsi/acs_ame/ for this driver).


Once we reach this stage, we have a patch which others can apply, test =
and
review.  Review will be the first step.


Your driver isn't ready for review yet.  There are a number of minor bu=
t
often-repeated problems which will require extensive changes to correct=
=2E

They're silly little things and they won't change the operation of the =
driver
at all, but it is best to get the driver looking and feeling like a typ=
ical
driver before we ask reviewers to start taking a serious look at the co=
de.

- No c++-style comments, please.  Replace all // with /* .. */

- there's some commented-out and obviously dead code.  Things like

//#include <asm/semaphore.h>  //void sema_init=20
                            //DECLARE_MUTEX(name)
                            //DECLARE_MUTEX_LOCKED(name)
//#include <linux/rwsem.h>    // read /write semaphore
// Why lock_kernel

//    #include <linux/smp_lock.h>
//    lock_kernel();
//#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,60)
////    daemonize();
//#else
//    daemonize("arcmsr kernel thread");
//#endif
//     unlock_kernel();

//Use unsigned long as a pointer=20
// cause of size(unsigend long) always equal to pointer size under all =
linux compatible platform

  just delete all that, please.

- CHAR_DEV and EVENTSWITCH_ON should probably become CONFIG variables
  (set in drivers/scsi/Kconfig)

- try to keep the code fitting nicely in an 80-column display

- Identifiers like RequestNode and RemapPCIMem should be renamed
  request_node and remap_pci_mem if at all possible.  We use underscore=
s to
  separate "words" within an identifier, not capital letters.

- Once you have a cleaned up patch, please pass that patch through
  scripts/checkpatch.pl.

  I just turned acs_ame.c, acs_ame.h and ame.h into a patch and fed it
  through checkpatch.pl.  Please see the result at
  http://userweb.kernel.org/~akpm/x.txt.

  (For those who are curious, the patch is at
  http://userweb.kernel.org/~akpm/a.patch)

  We have about 4,000 warnings there ;) Actually, a huge number of thos=
e
  warnings are incorrect (trailing whitespace).  checkpatch is still un=
der
  development a bit.

  But still, there are a lot of things in the checkpatch output which c=
an
  and should be fixed up.


All together I expect that after one or maybe two days work, you will h=
ave
a driver patch which is ready to be applied to the kernel and is ready =
to
be reviewed by kernel and scsi experts.

At that stage we will be able to get into more substantial details such=
 as
the use of the scsi APIs, the DMA APIs, locking, commenting, design, et=
c.=20
I'd expect that further changes will be made to the driver as a result =
of
that discussion, but they will improve the code.


When sending new versions of the patch, please send them to

Andrew Morton <akpm@linux-foundation.org>
James Bottomley <James.Bottomley@steeleye.com>
linux-scsi@vger.kernel.org
linux-kernel@vger.kernel.org

The way this driver will enter the 2.6 kernel is from you, into James's
scsi-misc git tree and then from James's scsi-misc tree into Linus's gi=
t
tree.  It is possible that I'll take a copy into my -mm tree for some e=
arly
testing but it is unlikely that I would send a scsi patch directly into
Linus - James does that.


Thanks.
