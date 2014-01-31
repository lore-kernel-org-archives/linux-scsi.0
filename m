From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] st: Do not rewind for SG_IO
Date: Fri, 31 Jan 2014 09:46:14 +0100
Message-ID: <1391157974-17512-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36125 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961AbaAaIqS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Jan 2014 03:46:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Kay Sievers <kay@vrfy.org>, Kai Makisara <kai.makisara@kolumbus.fi>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Plain 'st' devices are defined to do a rewind on close.
This causes quite some issues when trying to read the
VPD pages to figure out the WWN of the device.
Especially for udev this means we either have to use
another (non-rewinding) device node for this
(and thereby introducing race conditions) or not
generating a persistent device node at all
(and breaking multi-tape setups).

This patch make the tape always non-rewinding
when SG_IO is used, thus allowing udev to get
a proper device id for tapes.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/st.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index dc4826c..da18ce5 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3645,6 +3645,9 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 		case SCSI_IOCTL_GET_IDLUN:
 		case SCSI_IOCTL_GET_BUS_NUMBER:
 			break;
+		case SG_IO:
+			STp->rew_at_close = 0;
+			/* Fallthrough */
 		default:
 			if ((cmd_in == SG_IO ||
 			     cmd_in == SCSI_IOCTL_SEND_COMMAND ||
-- 
1.7.12.4

