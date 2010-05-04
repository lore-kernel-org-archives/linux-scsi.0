From: Hannes Reinecke <hare@suse.de>
Subject: Re: SYNCHRONIZE_CACHE command is not retried
Date: Tue, 04 May 2010 15:07:26 +0200
Message-ID: <4BE01C0E.6010501@suse.de>
References: <4BE011AF.7010509@suse.de> <201005041453.11308.bernd.schubert@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39224 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab0EDNH1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 May 2010 09:07:27 -0400
In-Reply-To: <201005041453.11308.bernd.schubert@fastmail.fm>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Bernd Schubert wrote:
> On Tuesday 04 May 2010, Hannes Reinecke wrote:
>> Hi all,
>>
>> I'm facing an issue here where the 'SYNCHRONIZE CACHE' command is no=
t
>>  retried:
>=20
>=20
> Interesting that suddenly several people run into it, when I already =
noticed=20
> long ago. Hmm, you work for Suse, maybe you now got the ticket I have=
 asked=20
> our customer about to open for their SLES system? ;)
>=20
> Recent discussion is here:
> http://kerneltrap.org/mailarchive/linux-scsi/2010/4/19/6884638
>=20
> Sorry, I didn't have time yet to update the patch there.
>=20
Well, yes, and no.

Your patch focussed primarily about the SYNC CACHE command as sent
from eg. sd_suspendI()
There it's quite easy as I just have to intercept the return
values and everything's dandy.

sd_prepare_flush(), OTOH, just prepares the command and hopes
the lower levels will to the right thing.
Which, apparently, they don't.
And setting 'retries' or 'timeout' wouldn't help here at all,
as we're never evaluating the number of retries;=20

scsi_check_sense() returns 'SUCCESS', causing
scsi_decide_disposition() to never evaluate ->retries.
Then (eventually) scsi_io_completion() is called,
which logs an error:

	if (blk_pc_request(req)) { /* SG_IO ioctl from block level */
		req->errors =3D result;
		if (result) {
			if (sense_valid && req->sense) {
				/*
				 * SG_IO wants current and deferred errors
				 */
				int len =3D 8 + cmd->sense_buffer[7];

				if (len > SCSI_SENSE_BUFFERSIZE)
					len =3D SCSI_SENSE_BUFFERSIZE;
				memcpy(req->sense, cmd->sense_buffer,  len);
				req->sense_len =3D len;
			}
			if (!sense_deferred)
				error =3D -EIO;


which will end up in the block layer causing the abort.
At least, that's my interpretation.

So by just using eg 'REQ_TYPE_SPECIAL' we would avoid
this trap and indeed retry the command here:

	if (sense_valid && !sense_deferred) {
		switch (sshdr.sense_key) {
		case UNIT_ATTENTION:
			if (cmd->device->removable) {
				/* Detected disc change.  Set a bit
				 * and quietly refuse further access.
				 */
				cmd->device->changed =3D 1;
				scsi_end_request(cmd, -EIO, this_count, 1);
				return;
			} else {
				/* Must have been a power glitch, or a
				 * bus reset.  Could not have been a
				 * media change, so we just retry the
				 * request and see what happens.
				 */
				scsi_requeue_command(q, cmd);
				return;
			}
			break;

given that using REQ_TYPE_SPECIAL is infact correct here.

Let's see what the powers that be say to this reasoning.

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
