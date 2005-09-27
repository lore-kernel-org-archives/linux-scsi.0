From: Lukasz Kosewski <lkosewsk@gmail.com>
Subject: [PATCH 0/3] Add disk hotswap support to libata RESEND #5
Date: Mon, 26 Sep 2005 21:00:48 -0400
Message-ID: <355e5e5e0509261800271c39b7@mail.gmail.com>
Reply-To: Lukasz Kosewski <lkosewsk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello Jeff, all,

Once again I besiege you with what I hope is the last necessary fix to
my hotswap patches!

For those caught with their pants down, the purpose of these patches
is as follows:
patch1:  Mask out the correct hotswap interrupts on the Promise
SATAII150 line of controllers.
patch2:  Add a disk hotswap API to libata, a general purpose
infrastructure which all libata drivers can use to play with disk
swapping.
patch3:  A reference and working implementation of a driver using this
architecture with the sata_promise module.  Tested on SATA150 and
SATAII150 Tx4/Tx2 Plus controllers.

The differences between this patchset and previous ones:
- no longer memory leaking struct pdc_host_priv all over the place,
just in one (there are other leaks there too... I even added a comment
saying that this should be taken care of!).
- Slight difference in the order of instructions executed on disk
removal to ensure that we don't have instructions bottled up in the
ata workqueue waiting on a disk that's been removed.

These patches will apply against seemingly any incarnation of the
2.6.14-rc2 kernel, HOWEVER (BIG HOWEVER!) in my testing (with
2.6.14-rc2 and 2.6.14-rc2-git5), the original -rc2 release has
interesting problems that were rectified between 2.6.14-rc2-git5,
which would cause kernel panics on disk removal during heavy I/O
(thanks to Thomas Lustig for pointing out something was awry!).  So if
you plan on sending me "hey, it crashed!" messages, please use
2.6.15-git5 or later.

The remaining vestiges of issues that I see might be related to
swapping strange combinations of disks... I"ve tried to properly reset
flags and such to allow swapping and switching arbitrary disks, but I
only have a few disks and so only observed a few errors.  If you get
strange errors trying to go from some disk of type A to another disk
of type B (for instance, LBA48 to non-LBA48 drives, vice versa,
different capacities being picked up wrong, etc), let me know!

That's about it.  Thanks to Net Integration Technologies for giving me
the freedom to do this kind of work and do the initial submission
while working for them, and thanks to the testers; keep it coming!

Luke Kosewski
