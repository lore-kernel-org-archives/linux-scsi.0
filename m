From: James.Smart@Emulex.Com
Subject: [Patch] Missing suspend state - Block to Offline
Date: Tue, 16 Nov 2004 16:38:15 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C02F275@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:42456 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261832AbUKPViV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Nov 2004 16:38:21 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id iAGLcGni012197
	for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2004 13:38:17 -0800 (PST)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

James,

The following got lost in the shuffle with the updated suspend patches. It allows a blocked->offline sdev state transition.

Your patch: http://marc.theaimsgroup.com/?l=linux-scsi&m=109884146519503&w=2
Original proposal: http://marc.theaimsgroup.com/?l=linux-scsi&m=109776477201239&w=2

-- James S

--- scsi_lib.c.2.6.10-rc2	2004-11-16 09:03:58.000000000 -0500
+++ scsi_lib.c.NEW	2004-11-16 16:24:49.565051816 -0500
@@ -1668,6 +1668,7 @@
 		case SDEV_CREATED:
 		case SDEV_RUNNING:
 		case SDEV_QUIESCE:
+		case SDEV_BLOCK:
 			break;
 		default:
 			goto illegal;
