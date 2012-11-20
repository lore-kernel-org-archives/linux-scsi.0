From: Hannes Reinecke <hare@suse.de>
Subject: be_main.c:273 always evaluates to 'false'
Date: Tue, 20 Nov 2012 14:57:42 +0100
Message-ID: <50AB8C56.7040604@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51065 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263Ab2KTN5n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Nov 2012 08:57:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kallickal <Jayamohan.Kallickal@Emulex.Com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi Jayamohan,

drivers/scsi/be2iscsi/be_main.c:273 has this statement:

if (abrt_task->sc->device->lun !=3D abrt_task->sc->device->lun)
	continue;

which is pointless at best, and actually harmful at worst as it=20
probably should compare with the scmd as passed to

beiscsi_eh_device_reset(struct scsi_cmnd *sc)

You might want to fix it up.

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
