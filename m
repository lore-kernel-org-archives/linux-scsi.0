From: Hannes Reinecke <hare@suse.de>
Subject: [RFC] [PATCH] scsi_eh_abort_cmds on failed devices
Date: Tue, 16 Dec 2008 11:43:44 +0100
Message-ID: <49478660.2050701@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43289 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbYLPKnq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Dec 2008 05:43:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi all,

I keep on stumbling across this in scsi_eh_abort_cmds():

		rtn =3D scsi_try_to_abort_cmd(scmd);
		if (rtn =3D=3D SUCCESS) {
			scmd->eh_eflags &=3D ~SCSI_EH_CANCEL_CMD;
			if (!scsi_device_online(scmd->device) ||
			    !scsi_eh_tur(scmd)) {
				scsi_eh_finish_cmd(scmd, done_q);
			}

Now scsi_device_online() translates to:

static inline int scsi_device_online(struct scsi_device *sdev)
{
	return sdev->sdev_state !=3D SDEV_OFFLINE;
}

Assume that the device has already vanished at this point
(ie sdev_state would be SDEV_DEL) we would be happily sending
a TUR command to a deleted device, right?
And as scsi_eh_tur command is using the ->queuecommand callback
directly, any normal checks for the sdev_state do not apply here.

Isn't something like this in order here?

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f394649..6e2305d 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -778,6 +778,9 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd=
, unsigne
d char *cmnd,
        struct scsi_eh_save ses;
        int rtn;
=20
+       if (sdev->sdev_state =3D=3D SDEV_CANCEL || sdev->sdev_state =3D=
=3D SDEV_DEL)
+               return FAILED;
+
        scsi_eh_prep_cmnd(scmd, &ses, cmnd, cmnd_size, sense_bytes);
        shost->eh_action =3D &done;
=20
Thanks for any feedback.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
