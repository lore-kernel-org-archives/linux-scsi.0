From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH 0/8] PM: Asynchronous suspen and resume
Date: Sun, 24 Jan 2010 00:33:34 +0100
Message-ID: <201001240033.34253.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
Sender: linux-acpi-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Linux PCI <linux-pci@vger.kernel.org>, pm list <linux-pm@lists.linux-foundation.org>, linux-usb@vger.kernel.org, Greg KH <gregkh@suse.de>, Jesse Barnes <jbarnes@virtuousgeek.org>, James Bottomley <James.Bottomley@suse.de>, Linux SCSI <linux-scsi@vger.kernel.org>, Arjan van de Ven <arjan@infradead.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>, Nigel Cunningham <ncunningham@crca.org.au>
List-Id: linux-scsi@vger.kernel.org

Hi,

This has been discussed to some extent, but without the last three patches that
actually enable the feature for the PCI, USB and SCSI subsystems.

First, the motivation.  At least on some machines (well, let's face it, most
likely on all of them) resume (from suspend to RAM) takes more time than
booting the kernel, which is not really surprising given that it's done
completely synchronously, even on systems with many CPUs, and which sucks
(especially in the case of hibernation, where devices are "suspended" three
times and "resumed" two times in each cycle).  Testing shows that with the
patches below applied the suspend time can be reduced by half and the resume
time even more (on one of my test systems it takes ~4 s without the patches
and ~1 s with them, which is a huge gain).

Second, why at the core level.  In short, this is the most straightforward way
to take dependencies between devices, following from the structure of the
device tree, into account.  Namely, a device can only be suspended if all
of its children have been suspended and it can only be resumed after its
parent.  Moreover, devices are resumed in the order in which they have been
registered (and are suspended in the reverse order), which is reflected by the
ordering of the list of devices used by the PM core, dpm_list.  Generally
speaking, it's not really advisable to change the ordering of this list
arbitrarily, because that may lead into problems with some devices and only
the PM core knows what the "right" ordering actually is.

So, the idea is to execute the entire suspend and resume callbacks of devices
in parallel with the main suspend/resume thread and possibly in parallel with
each other, but do that only for the devices known to take substantial amounts
of time to suspend or resume and for the devices that depend on them this
way or another (ie. that are their parents or children, or parents of their
parents and so on).  [It generally wouldn't make sense to suspend and resume
a device asynchronously if at least one of its children or its parent were
suspended and resumed synchronously, because in that case the main
suspend/resume thread would have to wait for the "asynchronous" devices'
callbacks to return before handling their "synchronous relatives".]

Now, testing shows that the slowest to suspend or resume are PCI, USB and SCSI
devices, so it makes sense to make them suspend and resume asynchronously,
which is done by the last three patches.  The dangerous part is that for things
to be efficient we need to make the whole subtrees of the device tree suspend
and resume asynchronously and it can only be verified by testing if things work
or break.  So far, I haven't seen any breakage resulting from this patchset on
any of my test machines, even though I have only a few of them.  That's why the
third patch leaves the switch blocking this feature in the "enabled" position.
Still, if it turns out that these changes introduce any problems on the other
people's machines, the default can be easily changed to "disabled".

Finally, the patches.

[1/8] - Nothing really interesting, modifies debug printk()s to show the parent
        name in addition to the information about the device being handled at
        the moment.  This is quite useful if one wants to learn about the device
        tree structure from the logs.

[2/8] - The actual implementation of the asynchronous suspend/resume at the
        PM core level.  However, it doesn't change the functionality as long as
        no devices have power.async_suspend set.

[3/8] - Adds the sysfs switch to disable/enable the asychronous suspend/resume
        at the high level.  It's /sys/power/pm_async and it's equal to 1 by
        default, which means "enabled".

[4/8] - Adds switches to disable/enable the asychronous suspend/resume for
        individual devices.  This really is regaded as a debugging feature,
        so it's enabled by means of a separate .config option.

[5/8] - Optimisation reducing resume time even more.  Actually, on some systems
        it's necessary to get _any_ resume speedup, but then it can be _huge_.

[6/8] - Set power.async_suspend for PCI devices.

[7/8] - Set power.async_suspend for USB devices.

[8/8] - Set power.async_suspend for SCSI devices.

Patches [2/8] - [5/8] have already been discussed in detail, [6/8] - [8/8] are
new (well, the PCI patch was discussed too, but then I didn't have the testing
data showing that PCI devices can be the slowest ones to suspend or resume
in some configurations).

Hopefully, I didn't get anything wrong this time, but if I did, please let me know.

The patches are available from the async branch of the suspend-2.6 tree at
git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git

Thanks,
Rafael

