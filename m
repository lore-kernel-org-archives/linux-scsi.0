From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: work queue of scsi fc transports should be serialized
Date: Fri, 19 May 2017 22:32:44 +0000
Message-ID: <1495233163.2581.5.camel@sandisk.com>
References: <23B7B563BA4E9446B962B142C86EF24A088AE2FB@CNMAILEX03.lenovo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:46968 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750818AbdESWfu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 May 2017 18:35:50 -0400
In-Reply-To: <23B7B563BA4E9446B962B142C86EF24A088AE2FB@CNMAILEX03.lenovo.com>
Content-Language: en-US
Content-ID: <06AFFAA23DC05C4BAB3D66657902A44B@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "caods1@lenovo.com" <caods1@lenovo.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Fri, 2017-05-19 at 09:36 +0000, Dashi DS1 Cao wrote:
> It seems there is a race of multiple "fc_starget_delete" of the same rpor=
t,
> thus of the same SCSI host. The race leads to the race of scsi_remove_tar=
get
> and it cannot be prevented by the code snippet alone, even of the most re=
cent
> version:
>         spin_lock_irqsave(shost->host_lock, flags);
>         list_for_each_entry(starget, &shost->__targets, siblings) {
>                 if (starget->state =3D=3D STARGET_DEL ||
>                     starget->state =3D=3D STARGET_REMOVE)
>                         continue;
> If there is a possibility that the starget is under deletion(state =3D=3D
> STARGET_DEL), it should be possible that list_next_entry(starget, sibling=
s)
> could cause a read access violation.

Hello Dashi,

Something else must be going on. From scsi_remove_target():

restart:
	spin_lock_irqsave(shost->host_lock, flags);
	list_for_each_entry(starget, &shost->__targets, siblings) {
		if (starget->state =3D=3D STARGET_DEL ||
		=A0=A0=A0=A0starget->state =3D=3D STARGET_REMOVE)
			continue;
		if (starget->dev.parent =3D=3D dev || &starget->dev =3D=3D dev) {
			kref_get(&starget->reap_ref);
			starget->state =3D STARGET_REMOVE;
			spin_unlock_irqrestore(shost->host_lock, flags);
			__scsi_remove_target(starget);
			scsi_target_reap(starget);
			goto restart;
		}
	}
	spin_unlock_irqrestore(shost->host_lock, flags);

In other words, before scsi_remove_target() decides to call
__scsi_remove_target(), it changes the target state into STARGET_REMOVE
while holding the host lock. This means that scsi_remove_target() won't
call=A0__scsi_remove_target() twice and also that it won't invoke
list_next_entry(starget, siblings) after starget has been freed.

Bart.=
