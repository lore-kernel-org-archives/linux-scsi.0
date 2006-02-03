From: =?iso-8859-1?b?RW1tYW51ZWwgRnVzdMOp?= <emmanuel.fuste@laposte.net>
Subject: Re: Overlapped command error handling
Date: Fri,  3 Feb 2006 12:00:56 +0100
Message-ID: <IU3YLK$E15AB4569608A69C14DE4D1626511B56@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx.laposte.net ([81.255.54.11]:12036 "EHLO mx.laposte.net")
	by vger.kernel.org with ESMTP id S932245AbWBCLBk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Feb 2006 06:01:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>

Hello,

Now compiling, results this evening.
The patch for aic7xxx :

---
linux-source-2.6.15-orig/drivers/scsi/aic7xxx/aic7xxx_osm.c
2006-02-03 10:56:04.000000000 +0100
+++ linux-source-2.6.15/drivers/scsi/aic7xxx/aic7xxx_osm.c  =20
  2006-02-03 11:00:41.000000000 +0100
@@ -1327,13 +1327,7 @@ ahc_platform_set_tags(struct ahc_softc *
                scsi_activate_tcq(sdev, dev->openings +
dev->active);
                break;
        default:
-               /*
-                * We allow the OS to queue 2 untagged
transactions to
-                * us at any time even though we can only
execute them
-                * serially on the controller/device.  This should
-                * remove some latency.
-                */
-               scsi_deactivate_tcq(sdev, 2);
+               scsi_deactivate_tcq(sdev, 1);
                break;
        }
 }

---

Acc=E9dez au courrier =E9lectronique de La Poste : www.laposte.net ;=20
3615 LAPOSTENET (0,34 =80/mn) ; t=E9l : 08 92 68 13 50 (0,34=80/mn)



-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
