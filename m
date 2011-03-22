From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [GIT PULL] First round of SCSI updates for 2.6.38 merge window
Date: Tue, 22 Mar 2011 00:27:42 -0400
Message-ID: <yq1fwqfu6dd.fsf@sermon.lab.mkp.net>
References: <1300392635.17266.5.camel@mulgrave.site>
	<AANLkTinvwKzYiy5M=Eoae_ViRQwVBF-TgedKspP0qagE@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:51608 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab1CVE2Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Mar 2011 00:28:25 -0400
In-Reply-To: <AANLkTinvwKzYiy5M=Eoae_ViRQwVBF-TgedKspP0qagE@mail.gmail.com>
	(Geert Uytterhoeven's message of "Sat, 19 Mar 2011 21:00:50 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: James Bottomley <James.Bottomley@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

>>>>> "Geert" =3D=3D Geert Uytterhoeven <geert@linux-m68k.org> writes:

Geert> drivers/scsi/sd.c: In function =E2=80=98sd_prep_fn=E2=80=99:
Geert> drivers/scsi/sd.c:544: warning: =E2=80=98ret=E2=80=99 may be use=
d uninitialized
Geert> in this function

Sorry about that.


sd: Fail discard requests when logical block provisioning has been disa=
bled

Ensure that we kill discard requests after logical block provisioning
has been disabled in sysfs.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3be5db5..7ff61d7 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -597,6 +597,7 @@ static int scsi_setup_discard_cmnd(struct scsi_devi=
ce *sdp, struct request *rq)
 		break;
=20
 	default:
+		ret =3D BLKPREP_KILL;
 		goto out;
 	}
=20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
