From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Update lsscsi to cope with upcoming SCSI sysfs rework
Date: Tue, 18 Mar 2008 14:01:50 +0100
Message-ID: <47DFBD3E.8050502@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040103090409030604020907"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:43043 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534AbYCRNBv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Mar 2008 09:01:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>

This is a multi-part message in MIME format.
--------------040103090409030604020907
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi Doug,

I'm preparing a set of patches to update the SCSI midlayer to
play more nicely with the ongoing driver core rework.
Part of the patchset is to move every SCSI entity 
(ie hosts, targets, and devices) into the scsi bus.
So /sys/bus/scsi/devices will look like:

hare@yarrow:/tmp> ls /sys/bus/scsi/devices
2:0:4:0  host0  host1  host2  host3  host4  target2:0:4

Currently 'lsscsi' doesn't handle this properly; it needs
a simple fix to handle it properly. And as this fix doesn't
affect normal parsing we can as well apply it now :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)

--------------040103090409030604020907
Content-Type: text/plain;
 name="lsscsi-sysfs-update"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="lsscsi-sysfs-update"

--- lsscsi-0.19/lsscsi.c.orig	2008-03-18 13:26:59.733340500 +0100
+++ lsscsi-0.19/lsscsi.c	2008-03-18 13:33:54.647271000 +0100
@@ -1650,6 +1650,10 @@ static int sdev_scandir_select(const str
         if (strstr(s->d_name, "gen"))
                 return 0;
 /* Above no longer needed but leave for early lk 2.6 series */
+	if (!strncmp(s->d_name, "host", 4)) /* SCSI host */
+		return 0;
+	if (!strncmp(s->d_name, "target", 6)) /* SCSI target */
+		return 0;
         if (strchr(s->d_name, ':')) {
                 if (filter_active) {
                         struct addr_hctl s_hctl;

--------------040103090409030604020907--
