From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [0/16 ver2] gdth combined patchset & call for testers
Date: Tue, 02 Oct 2007 22:05:53 +0200
Message-ID: <4702A4A1.2080404@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:3183 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751664AbXJBUMK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 16:12:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <matthew@wil.cx>, linux-scsi <linux-scsi@vger.kerne>

Hi!

following is an attempted at unified patchset for the gdth driver.

They try to incorporate floating patches to gdth from:
Christoph Hellwig
Jeff Garzik
Matthew Wilcox
and Me Boaz Harrosh

They are done in the mindset of "likelihood of inducing breakage",
hence the need for testers. Christoph & Jeff please review for any
obvious easy-to-catch bugs. Also there was a massive code shifts
and rebasing I hope nothing was lost.

The differences from last set are:
- Matthews patches are first so they can go in. They
  are a bit modified so please take these and not the
  original. Mainly they restrain from cleanups

- Fix Christoph bug that was spotted by jeff of the misplaced
  #endif. Also when compiling with out CONFIG_{ISA,EISA,PCI}
  compiler would complain about unused params, functions and
  so on so fixed that.

- More Aggressive fix for gdth_interrupt() and friends
  Christoph pleeeeeeease review.

- Rebasing to all above. I hope I'll get the From:
  right this time

Some short explanations:
[01/16] gdth: Make one abuse of scsi_cmnd less obvious - Matthew Wilcox
[02/16] gdth: Stop abusing ->done for internal commands - Matthew Wilcox
  Patches from Matthew, but cleaned for future patchability.

[03/16] gdth: split out isa probing - Christoph Hellwig
[04/16] gdth: split out eisa probing - Christoph Hellwig
[05/16] gdth: split out pci probing - Christoph Hellwig
  These three are from Christoph and where ACKed by
  Jeff at the time. Revised by me for warning fixes when
  one of the buses ISA/EISA/PCI is not defined.

[06/16] gdth: Remove 2.4.x support, in-kernel changelog - Jeff Garzik
  Same but partial work was done both by Christoph and Matthew.

[07/16] gdth: kill gdth_{read,write}[bwl] wrappers - Jeff Garzik
[08/16] Reorder scsi_host_template intitializers
[09/16] gdth: Remove virt hosts - Christoph && Boaz
  Here we need an executive decision! The issue is as stated by Christoph:

    "The virt_ctr option allows to register a new scsi_host for each bus
    on the raid controller.  This non-default option makes no sense with
    the current scsi code and prevents cleaning up the host registration,
    so remove it."

  I agree. This is just exactly the same as done buy scsi-ml scans but only
  more resource consuming. Unless I'm totally missing something, perhaps it is
  just a leftover from old kernels.

[10/16] gdth: clean up host private data - Christoph && Boaz
  This is based on the same patch from Christoph, but taken one step
  farther, by just passing the ha pointer everywhere instead of hanum.

[11/16] gdth_interrupt gdth_get_status & gdth_wait fixes - Boaz
  This logically belongs to [9/16] but is separated for reviewing and 
  bisect-ability As it is a sensitive matter. 
  It is done aggressively this time around Please review!

[12/16] gdth: switch to modern scsi host registration - Christoph
  Christoph what is missing from here is the remove of the deprecated 
  pci_find_device() call. Can I Just use pci_get_device() of the same signature
  or do I need to call some other pci_ members after that?

[13/16] gdth: Remove gdth_ctr_tab[] - Boaz
  I took Christoph's cleanup one step farther and got read of the statically
  allocated gdth_ctr_tab[]. In it's place I use the new link-list introduced
  by the [11/16] patch.

[14/16] gdth: Setup proper per-command private data - Boaz
[15/16] gdth: Move members from SCp to gdth_cmndinfo, stage 2 - Boaz
  These two move me much closer to the agenda I had in all this,
  which is: "gdth diss-abuse of of scsi_cmnd IO members".
  With these patches I also conform to Matthew's second patch:
  "gdth: Stop abusing ->done for internal commands"

[16/16] gdth: !use_sg cleanup and use of scsi accessors
  And finally this one.

Boaz

