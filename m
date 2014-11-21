From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] SCSI: fix regression in scsi_send_eh_cmnd()
Date: Fri, 21 Nov 2014 16:57:00 +0100
Message-ID: <546F60CC.10703@suse.de>
References: <Pine.LNX.4.44L0.1411211040110.4139-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56849 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758442AbaKUP5D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2014 10:57:03 -0500
In-Reply-To: <Pine.LNX.4.44L0.1411211040110.4139-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: =?UTF-8?B?0JDQvdC00YDQtdC5INCQ0LvQsNC00YzQtdCy?= <aladjev.andrew@gmail.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On 11/21/2014 04:44 PM, Alan Stern wrote:
> Commit ac61d1955934 (scsi: set correct completion code in
> scsi_send_eh_cmnd()) introduced a bug.  It changed the stored return
> value from a queuecommand call, but it didn't take into account that
> the return value was used again later on.  This patch fixes the bug b=
y
> changing the later usage.
>=20
> There is a big comment in the middle of scsi_send_eh_cmnd() which
> does a good job of explaining how the routine works.  But it mentions
> a "rtn =3D FAILURE" value that doesn't exist in the code.  This patch
> adjusts the code to match the comment (I assume the comment is right
> and the code is wrong).
>=20
> This fixes Bugzilla #88341.
>=20
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> Reported-by: =D0=90=D0=BD=D0=B4=D1=80=D0=B5=D0=B9 =D0=90=D0=BB=D0=B0=D0=
=B4=D1=8C=D0=B5=D0=B2 <aladjev.andrew@gmail.com>
> Tested-by: =D0=90=D0=BD=D0=B4=D1=80=D0=B5=D0=B9 =D0=90=D0=BB=D0=B0=D0=
=B4=D1=8C=D0=B5=D0=B2 <aladjev.andrew@gmail.com>
> Fixes: ac61d19559349e205dad7b5122b281419aa74a82
> CC: Hannes Reinecke <hare@suse.de>
> CC: <stable@vger.kernel.org>
>=20
That is correct.

Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 21284 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
