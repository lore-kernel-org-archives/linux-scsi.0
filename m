From: Hannes Reinecke <hare@suse.de>
Subject: Flood of SCSI retries when a port is in transitioning
Date: Thu, 25 Aug 2011 15:36:07 +0200
Message-ID: <4E564FC7.10507@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53943 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab1HYNgJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Aug 2011 09:36:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Martin George <Martin.George@netapp.com>

Hi all,

our friends from NetApp discovered a SCSI retry flood when a remote=20
port is in ALUA 'transitioning' state.

The device will then return
Not ready/LUN Not Accessible - ALUA state transition
which will be evaluated in scsi_dh_alua.c:alua_check_sense()
as ADD_TO_MLQUEUE.
This will cause an immediate retry of the command and hence the=20
target will be pounded with a flood of retries.

I have now tried to alleviate this by returning 'NEEDS_RETRY',

--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -451,7 +451,7 @@ static int alua_check_sense(struct scsi_device=20
*sdev,
                         /*
                          * LUN Not Accessible - ALUA state transition
                          */
-                       return ADD_TO_MLQUEUE;
+                       return NEEDS_RETRY;
                 if (sense_hdr->asc =3D=3D 0x04 && sense_hdr->ascq =3D=3D=
 0x0b)
                         /*
                          * LUN Not Accessible -- Target port in=20
standby state

but then the command will be aborted after the retry count has been=20
exhausted. Which will then cause I/O errors. Also not good.
Is there a way of forcing a delayed retry, like BLKPREP_DEFER does?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
