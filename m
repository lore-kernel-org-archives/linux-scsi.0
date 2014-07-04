From: Hannes Reinecke <hare@suse.de>
Subject: virtio_scsi LUN usage
Date: Fri, 04 Jul 2014 16:29:00 +0200
Message-ID: <53B6BA2C.80103@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56351 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbaGDO3C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Jul 2014 10:29:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi Paolo,

virtio_scsi has this:

static void virtio_scsi_init_hdr(struct virtio_scsi_cmd_req *cmd,
				 struct scsi_cmnd *sc)
{
	cmd->lun[0] =3D 1;
	cmd->lun[1] =3D sc->device->id;
	cmd->lun[2] =3D (sc->device->lun >> 8) | 0x40;
	cmd->lun[3] =3D sc->device->lun & 0xff;
	cmd->tag =3D (unsigned long)sc;
	cmd->task_attr =3D VIRTIO_SCSI_S_SIMPLE;
	cmd->prio =3D 0;
	cmd->crn =3D 0;
}

As you might've seen I'm currently working on updating the SCSI=20
stack to use 64-bit LUNs.
So while virtio scsi is in principle capable of using 64-bit LUNs,=20
this peculiar usage makes it impossible to actually _use_ 64-bit LUNs.
Can't we get rid of this encoding and let the backend provide is=20
with correct numbers?

It should work if we were just to implement a REPORT_LUN intercept,=20
which sets the correct top two bytes in the command ... with that we=20
should be getting only the LUNs for a particular target, and could=20
then just use the provided LUN numbers as-is.

Long term I would prefer to have another 'target' field (preferably=20
also 64bit wide), which could be used to specify the target=20
directly. But that would require a spec change and feature flags=20
yadda yadda...

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
