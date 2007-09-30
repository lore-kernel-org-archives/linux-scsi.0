From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC 0/16] gdth combined patchset & call for testers
Date: Sun, 30 Sep 2007 21:44:12 +0200
Message-ID: <46FFFC8C.6080804@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:20419 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751877AbXI3Tro (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Sep 2007 15:47:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Hi!

following is an attempted at unified patchset for the gdth driver.

They try to incorporate floating patches to gdth from:
Christoph Hellwig
Jeff Garzik
Matthew Wilcox
and Me Boaz Harrosh

They are done in the mindset of "likelihood of inducing breakage",
hence the need for testers. Christoph & Jeff please review for any
obvious easy-to-catch bugs.

Some short explanations:
[1/16] gdth: split out isa probing - Christoph Hellwig
[2/16] gdth: split out eisa probing - Christoph Hellwig
[3/16] gdth: split out pci probing - Christoph Hellwig
  These three are from Christoph and where ACKed by
  Jeff at the time.

[4/16] gdth: Remove 2.4.x support, in-kernel changelog - Jeff Garzik
  Same but partial work was done both by Christoph and Matthew.

[5/16] gdth: kill gdth_{read,write}[bwl] wrappers - Jeff Garzik
[6/16] Reorder scsi_host_template intitializers
[7/16] gdth: make some virt ctrlr code common
  These 3 are from Jeff's patchset 6 & 7 where the same patch

[8/16] gdth: Remove virt hosts - Christoph && Boaz
  Here we need an executive decision! The issue is as stated by Christoph:

    "The virt_ctr option allows to register a new scsi_host for each bus
    on the raid controller.  This non-default option makes no sense with
    the current scsi code and prevents cleaning up the host registration,
    so remove it."

  I agree. This is just exactly the same as done buy scsi-ml scans but only
  more resource consuming. Unless I'm totally missing something, perhaps it is
  just a leftover from old kernels.

  But if it is decided that this "virt_ctr" fixture is absolutely needed than
  I have a patch for re-enabling it at: "after the patchset", done in a different
  way. Because for now it prevents the cleanups I need.

  Also this patch can Just be merged with [7/16] but I wanted it separate in the 
  case we decide for "virt_ctr" fixture return.

[9/16] gdth: clean up host private data - Christoph && Boaz
  This is based on the same patch from Christoph, but taken one step
  farther, by just passing the ha pointer everywhere instead of hanum.
  Christoph please acknowledge your signed-of-by on this patch.

[10/16] gdth: gdth_get_status() return pointer to host not its index - Boaz
  This logically belongs to [9/16] but is separated for reviewing and bisect-ability
  As it is a sensitive matter.

[11/16] gdth: switch to modern scsi host registration - Christoph
  Christoph what is missing from here is the remove of the deprecated 
  pci_find_device() call. Can I Just use pci_get_device() of the same signature
  or do I need to call some other pci_ members after that?

[12/16] gdth: Remove gdth_ctr_tab[] - Boaz
  I took Christoph's cleanup one step farther and got read of the statically
  allocated gdth_ctr_tab[]. In it's place I use the new link-list introduced
  by the [11/16] patch.

[13/16] gdth: Make one abuse of scsi_cmnd less obvious - Matthew Wilcox
  This is the first patch sent by Matthew Wilcox, rebased to all above
  patches. Matthew, thanks, it saved me from a much uglier hack I had
  with regard to per-command-private-data.

[14/16] gdth: Setup proper per-command private data - Boaz
[15/16] gdth: Move members from SCp to gdth_cmndinfo, stage 2 - Boaz
  These two move me much closer to the agenda I had in all this,
  which is: "gdth diss-abuse of of scsi_cmnd IO members".
  With these patches I also conform to Matthew's second patch:
  "gdth: Stop abusing ->done for internal commands"

[16/16] gdth: !use_sg cleanup and use of scsi accessors
  And finally this one.


Boaz

