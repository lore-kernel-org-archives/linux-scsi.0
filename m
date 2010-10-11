From: Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: [PATCH] [resend] sr: fix sr_drive_status handling when
 initialization required
Date: Mon, 11 Oct 2010 11:02:00 -0500
Message-ID: <20101011160200.GC5431@linux.vnet.ibm.com>
References: <20100917151957.GA20570@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:38220 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961Ab0JKQCN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Oct 2010 12:02:13 -0400
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by e37.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o9BG007f015416
	for <linux-scsi@vger.kernel.org>; Mon, 11 Oct 2010 10:00:00 -0600
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o9BG21QA133286
	for <linux-scsi@vger.kernel.org>; Mon, 11 Oct 2010 10:02:02 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o9BG5psP025635
	for <linux-scsi@vger.kernel.org>; Mon, 11 Oct 2010 10:05:51 -0600
Content-Disposition: inline
In-Reply-To: <20100917151957.GA20570@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

An sr device that reports sense data with SK/ASC/ASCQ of 2/4/2 (Not ready,
Logical unit not ready, Initializing command required) will be handled
in sr_drive_status as (2/4/!1) and assumed to be a 'format in progress'
which returns CDS_DISC_OK.  The drive will not be made ready in this case.

Prior to 210ba1d1724f5c4ed87a2ab1a21ca861a915f734 sr_drive_status would
have returned CDS_TRAY_OPEN and this results in an START_STOP_UNIT to
close the tray, which resolves the initialization requirement.

This patch adds handling for SK/ASC/ASCQ of 2/4/2 where it will return
CDS_TRAY_OPEN as a means of triggering a START_STOP_UNIT.

This issue is seen on the IBM POWER platform when using a file-backed,
virtual optical device.  The device does not support media queries
through the Get Event Status Notification command which could otherwise
trigger a START_STOP_UNIT call to close an open tray.

Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>

---
 drivers/scsi/sr_ioctl.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: b/drivers/scsi/sr_ioctl.c
===================================================================
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -325,6 +325,15 @@ int sr_drive_status(struct cdrom_device_
 	}
 
 	/*
+	 * SK/ASC/ASCQ of 2/4/2 means "initialization required"
+	 * Using CD_TRAY_OPEN results in an START_STOP_UNIT to close
+	 * the tray, which resolves the initialization requirement.
+	 */
+	if (scsi_sense_valid(&sshdr) && sshdr.sense_key == NOT_READY
+			&& sshdr.asc == 0x04 && sshdr.ascq == 0x02)
+		return CDS_TRAY_OPEN;
+
+	/*
 	 * 0x04 is format in progress .. but there must be a disc present!
 	 */
 	if (sshdr.sense_key == NOT_READY && sshdr.asc == 0x04)
