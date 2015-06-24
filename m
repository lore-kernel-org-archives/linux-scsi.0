From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/2] advansys: Do not byteswap sense_len on big endian
Date: Wed, 24 Jun 2015 10:29:48 +0200
Message-ID: <1435134589-16601-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xavier.telenet-ops.be ([195.130.132.52]:43412 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbbFXI3x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jun 2015 04:29:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>

On big endian (e.g. m68k):

    drivers/scsi/advansys.c: In function =E2=80=98adv_build_req=E2=80=99=
:
    drivers/scsi/advansys.c:7806: warning: large integer implicitly tru=
ncated to unsigned type

Indeed, adv_scsi_req_q.sense_len is uchar, not __le32, and must never b=
e
byteswapped.

=46ixes: 811ddc057aac7228 ("advansys: use DMA-API for mapping sense buf=
fer")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/advansys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 4305178e4e0147ba..1c1cd657c380c2e0 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -7803,7 +7803,7 @@ adv_build_req(struct asc_board *boardp, struct sc=
si_cmnd *scp,
 		return ASC_BUSY;
 	}
 	scsiqp->sense_addr =3D cpu_to_le32(sense_addr);
-	scsiqp->sense_len =3D cpu_to_le32(SCSI_SENSE_BUFFERSIZE);
+	scsiqp->sense_len =3D SCSI_SENSE_BUFFERSIZE;
=20
 	/* Build ADV_SCSI_REQ_Q */
=20
--=20
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
