From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 0/3] Split up mvsas submission into multiple commits
Date: Fri, 8 May 2009 16:35:37 -0400
Message-ID: <2a29d6a8d79b9723cfb1aaddfd0e1725c15dab6e.1241819334.jgarzik@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:49273 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207AbZEHWEj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 May 2009 18:04:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jasonchu@marvell.com, ayan@marvell.com, kewei@marvell.com

The following changes are stored on the 'mvsas-split' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git

The submission of Marvell's mvsas driver update was done in an opaque
way, that makes it difficult to see what kinds of changes were applied
to the driver:  drivers/scsi/mvsas.c is deleted, and a new driver with lots of
new code is created inside drivers/scsi/mvsas/

If James will permit, I would suggest REPLACING the scsi-misc-2.6.git commit
from Marvell, 2142d072d858912dfc17e173d8ba66eb60a31c6c, with the following
three commits I have created:

1) Move drivers/scsi/mvsas.c to drivers/scsi/mvsas/mv_sas.c

   _Zero_ code changes, just file movement.

   Driver compiles and works correctly.

2) Split up functions in mv_sas.c into component files
   mv_sas.[ch], mv_init.c, mv_64xx.[ch], mv_chips.h, mv_defs.h.

   _Zero_ functional code changes, just code movement.

   Driver compiles and works correctly.

3) Apply Marvell's changes.

   _Zero_ changes from Marvell's commit.  I did not attempt to fix any
   bugs or address other issues; I merely copied Marvell's submitted
   (and accepted) code on top of my new commit #1 and #2.

   Driver compiles and works correctly.

The goal of my changes here is to greatly ease the strain of reviewing
such a large submission of code.

I have not done an exhaustive comparison of intra-function code blocks; the
best I did was ensure that definitions and functions that existed before
Marvell's commit remained in the same order after Marvell's commit.

These changes were created on top of 

	commit 1bfe9caaff367601134c14fc428017419f628f7d
	Author: James Smart <James.Smart@Emulex.Com>
	Date:   Thu Mar 26 13:33:19 2009 -0400

	    [SCSI] FC Pass Thru support

I strongly recommend pulling the above branch, rather than applying the
patches presented, to preserve full git metadata in the face of a file move.

