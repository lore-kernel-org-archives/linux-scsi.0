From: Paul Wagland <paul@kungfoocoder.org>
Subject: megaraid /proc under kernel 2.6.2
Date: Sun, 15 Feb 2004 23:41:31 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076884890.2943.265.camel@morsel.kungfoocoder.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out2.xs4all.nl ([194.109.24.12]:29706 "EHLO
	smtp-out2.xs4all.nl") by vger.kernel.org with ESMTP id S265203AbUBOWlf
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Feb 2004 17:41:35 -0500
Received: from umlsmtp.wagland.net (kungfucoder.org [80.126.186.202])
	by smtp-out2.xs4all.nl (8.12.10/8.12.10) with ESMTP id i1FMfWZG001492
	for <linux-scsi@vger.kernel.org>; Sun, 15 Feb 2004 23:41:32 +0100 (CET)
Received: from 6-allhosts (unknown [10.87.98.191])
	by umlsmtp.wagland.net (Postfix) with ESMTP id E403858
	for <linux-scsi@vger.kernel.org>; Sun, 15 Feb 2004 23:41:31 +0100 (CET)
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI mailing list <linux-scsi@vger.kernel.org>

Hi all,

I was playing around with forward porting the 2.10.1 megaraid driver to
use the new megaraid layout as found in kernel 2.6.2. First I wanted to
make sure that the default kernel worked as previously, and then to make
sure that each of my layered patches kept the same behaviour.

However, the /proc/megaraid directory is no longer populated, and I am
not quite sure why.

In megaraid_init() we do a:

mega_proc_dir_entry = proc_mkdir("megaraid", &proc_root);

, which is good, since that throws a /proc/megaraid directory there for
us. So far, so good. mega_proc_dir_entry is a static pointer to a struct
proc_dir_entry. The module is now loaded, and we get to device scanning,
AFAIK, the new "hotplug-aware pci probing and scsi registration" code
put in by Christoph means that once the module is loaded, the hotplug
code is then responsible for generating the event to activate the
driver. This then calls megaraid_probe_one(). Now, this is where it
starts to get a little tricky. There are five different error conditions
that do not do a printk to notify of failure, I will send a patch
through to address this later, however at the moment I don't think that
the initialisation is failing, since I can use the drives attached to
the board. So, I am assuming that mega_create_proc_entry() is called.
The first thing that this does is to call (effectively)
proc_mkdir("hba0", mega_proc_dir_entry); The only way that this can fail
to create /proc/megaraid/hba0 (as far as I can see) is if
mega_proc_dir_entry is null. The only way that it can be null, is if
megaraid_probe_one() is called before megaraid_init(), since the
megaraid directory is created.

Either that or I have missed something....

But in any case something weird is going on. I have a three megaraid
partitions in use, one which is used for swap, one for /boot and one for
a device mapper PV, even though my system is running, and using all
three devices, the usage count on the megaraid driver is still 0, and I
can rmmod the module, although doing so brings up:

tidbit kernel: journal-601, buffer write failed

which is, I assume, reiserfs bitching about the fact that it's backing
device has just totally disappeared, and as soon as I try to do anything
that wants read access to the disk, that program will freeze, but that
is only to be expected. What is not expected is that I can remove a
device that is in use...

Does anyone know what is going on? I am investigating further, but I
thought that I would throw this out so that people might be able to tell
me where to look...

Cheers,
Paul

