From: David Binderman <dcb314@hotmail.com>
Subject: RE: [PATCH] [RESEND] scsi_debug: fix sanity check in
 resp_rsup_opcodes
Date: Fri, 2 Jan 2015 18:09:39 +0000
Message-ID: <DUB128-W710787218653189237DB5E9C5D0@phx.gbl>
References: <54A6D410.8050904@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dub004-omc4s35.hotmail.com ([157.55.2.110]:58655 "EHLO
	DUB004-OMC4S35.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750777AbbABSJl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Jan 2015 13:09:41 -0500
In-Reply-To: <54A6D410.8050904@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "dgilbert@interlog.com" <dgilbert@interlog.com>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>
Cc: "Ewan D. Milne" <emilne@redhat.com>

Hello there,

----------------------------------------
> David Binderman pointed out in this post:
>
> http://marc.info/?l=3Dlinux-scsi&m=3D141924469523474&w=3D2
>
> a sanity check that was flawed. See attached fix. Should
> be applied to lk 3.19.0-rc2 and Christoph's branches.

Actually, there is another fault in the same source code file:

Checking drivers/scsi/scsi_debug.c...
[drivers/scsi/scsi_debug.c:3844] -> [drivers/scsi/scsi_debug.c:3846]: (=
warning) Possible null pointer dereference: cmnd - otherwise it is redu=
ndant to check it against null.

Source code is

=A0=A0=A0 struct scsi_device *sdp =3D cmnd->device;

=A0=A0=A0 if (NULL =3D=3D cmnd || NULL =3D=3D devip) {

Suggest postpone use of cmnd until *after* it has been sanity checked.

Regards

David Binderman
 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
