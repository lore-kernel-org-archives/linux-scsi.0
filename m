From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] lpfc: Fix race on command completion
Date: Thu, 21 Jan 2016 16:21:35 +0100
Message-ID: <56A0F77F.1080707@suse.de>
References: <1452851303-89378-1-git-send-email-hare@suse.de>
 <569FB524.3090305@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55005 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758431AbcAUPVi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jan 2016 10:21:38 -0500
In-Reply-To: <569FB524.3090305@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, James Smart <james.smart@avagotech.com>
Cc: Dick Kennedy <dick.kennedy@avagotech.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 01/20/2016 05:26 PM, Tomas Henzl wrote:
> On 15.1.2016 10:48, Hannes Reinecke wrote:
>> Upon command completion the lpfc driver would call ->done()
>> on the scsi command before taking the host lock and
>> releasing the command internally.
>> This opens up a race window there this command might be re-used
>> after ->done(), leading to a double completion on the same command.
>=20
> I agree that a driver should clean up the command before calling
> ->done, but this driver uses a list based system where a command=20
> can't be reused only until it was returned to the list,
> so I don't understand how a 'done' before internal free could
> cause an issue other than a failed lpfc_get_scsi_buf in .queuecommand=
=2E
> Is your issue related to the abort_handler=20
> (maybe cmd->host_scribble =3D NULL; changes the abort handler flow)?
>=20
Yes, this was (originally) an issue with the abort handler. But it
seems to be gone with the upstream driver, so this patch should be
retracted.

Will be reposting if and when the issue resurfaces.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
