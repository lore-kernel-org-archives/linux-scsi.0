From: James Bottomley <James.Bottomley@suse.de>
Subject: [PATCH 0/2] convert libsas to the libata new eh
Date: Sun, 23 Jan 2011 09:41:00 -0600
Message-ID: <1295797260.3007.118.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:58160 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab1AWPlK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Jan 2011 10:41:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>
Cc: Brian King <brking@linux.vnet.ibm.com>, Robert Jennings <rcj@linux.vnet.ibm.com>

The bad news is that this is a pretty horrific conversion.  Because of
the amount of control the new eh wants (and the slew of monolithic
assumptions it makes), the entire error handler routine has to be sliced
apart and sewn back together to make it callable as part of an existing
error handler (rather than trying to do everything on its own).

The even worse news is that unless you have an existing strategy
handler, you can't make use of this.  That means that ipr is
unconvertable in its current form.  Given the two really nasty options:
give ipr its own error handler via its own transport class, or attach
ipr to libsas and let it do the work, I'd choose the latter.
Unfortunately, my power box with IPR has been non-functional for a year
(and all pleas to IBM to fix it have so far gone unanswered), so I can't
really do this myself.

Once we carve up libata, it's still a rather complex call sequence for
libsas because of libata's annoying insistance on calling the error
handler at the drop of a hat.  The principle differentiator used is the
fact that if a SCSI command no longer has an associated SAS task, (i.e.
libsas thinks it's complete) it must be destined for libata.  This works
correctly in all the ATAPI sense processing instances I've tested.
Finally, we still have to call port recovery.  Currently, it's
impossible to tell which port libata thinks is in error (libata knows
because it has one host per port, but libsas doesn't), so the final
solution is just to call port recovery for every SATA/STP attached port.

I've tested all of this with mvsas over expander attached ATA devices
using STP (aic94xx seems to have developed some handling fault for STP,
which I'll look into next).

James

---

James Bottomley (2):
  libata: separate error handler into usable components
  libsas: convert to libata new error handler

 drivers/ata/libata-eh.c             |   53 ++++++++++++++++++----
 drivers/scsi/libsas/sas_ata.c       |   87 ++++++++++++++++++++++++++++++++--
 drivers/scsi/libsas/sas_scsi_host.c |   14 +++++-
 include/linux/libata.h              |    2 +
 include/scsi/sas_ata.h              |   22 +++++++++
 5 files changed, 161 insertions(+), 17 deletions(-)


