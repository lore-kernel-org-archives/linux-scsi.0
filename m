From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: SCSI Driver Regression and Missing Code Block?
Date: Wed, 22 Apr 2009 05:52:10 -0600
Message-ID: <20090422115210.GG1926@parisc-linux.org>
References: <9573387.7901240380756993.JavaMail.root@mail.paragon.co.nz> <7297889.7921240382112001.JavaMail.root@mail.paragon.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:52456 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbZDVLwM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2009 07:52:12 -0400
Content-Disposition: inline
In-Reply-To: <7297889.7921240382112001.JavaMail.root@mail.paragon.co.nz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dominic Driver <dominic.driver@paragon.co.nz>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Peter Jones <pjones@redhat.com>, linux-scsi@vger.kernel.org

On Wed, Apr 22, 2009 at 06:35:12PM +1200, Dominic Driver wrote:
> Hi Matthew,
> 
> A look at the Vanilla 2.6.27.19 Kernel reveals that the section of code
> from the Fedora release that I reinserted is NOT present. This must be
> a Fedora patch. From my point of view, it's a very useful addition to
> the IOCTL responses, is it something to consider for inclusion in the
> Vanilla kernels?

It certainly is.  Peter Jones posted the patch to linux-scsi on July
11th last year.  I think it simply got overlooked.  James, you objected
to an earlier version of this patch; any problems with this version?

It appears to have been in Fedora for about six months, so it presumably
doesn't cause much end-user related trouble.


>From e85e03d7f680b62bb8d4d037fdde6dd94c9582a3 Mon Sep 17 00:00:00 2001
From: Peter Jones <pjones@redhat.com>
Date: Wed, 8 Oct 2008 15:10:39 -0400
Subject: [PATCH] make sr_mod report more accurate drive status after closing the door.

So, what's happening here is that the drive is reporting a sense of
2/4/1 ("logical unit is becoming ready") from sr_test_unit_ready(), and
then we ask for the media event notification before checking that result
at all.  The check_media_event_descriptor() call isn't getting a check
condition, but it's also reporting that the tray is closed and that
there's no media.  In actuality it doesn't yet know if there's media or
not, but there's no way to express that in the media event status field.

My current thought is that if it told us the device isn't yet ready, we
should return that immediately, since there's nothing that'll tell us
any more data than that reliably.
---
 drivers/scsi/sr_ioctl.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index ae87d08..7ee51ff 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -309,6 +309,11 @@ int sr_drive_status(struct cdrom_device_info *cdi, int slot)
 	if (0 == sr_test_unit_ready(cd->device, &sshdr))
 		return CDS_DISC_OK;
 
+	/* SK/ASC/ASCQ of 2/4/1 means "unit is becoming ready" */
+	if (scsi_sense_valid(&sshdr) && sshdr.sense_key == NOT_READY
+			&& sshdr.asc == 0x04 && sshdr.ascq == 0x01)
+		return CDS_DRIVE_NOT_READY;
+
 	if (!cdrom_get_media_event(cdi, &med)) {
 		if (med.media_present)
 			return CDS_DISC_OK;
-- 
1.6.0.1


-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
