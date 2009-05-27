From: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: [RFC][PATCH] [SCSI]: scsi_transport_iscsi.c return -EOVERFLOW for
 Too many iscsi targets
Date: Wed, 27 May 2009 10:44:39 +0530
Message-ID: <1243401279.3118.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:39082 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196AbZE0FXU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 May 2009 01:23:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>, Mike Christie <mic>

setting err as -EOVERFLOW for Too many iscsi targets.

Also fixes compiler warning for gcc < 4.3.3 :

  CC      drivers/scsi/scsi_transport_iscsi.o
drivers/scsi/scsi_transport_iscsi.c: In function =E2=80=98iscsi_add_ses=
sion=E2=80=99:
drivers/scsi/scsi_transport_iscsi.c:678: warning: =E2=80=98err=E2=80=99=
 may be used uninitialized in this function

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/scsi/scsi_transport_iscsi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_tr=
ansport_iscsi.c
index 0947954..fdcda7f 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -693,6 +693,7 @@ int iscsi_add_session(struct iscsi_cls_session *ses=
sion, unsigned int target_id)
 						 "Too many iscsi targets. Max "
 						 "number of targets is %d.\n",
 						 ISCSI_MAX_TARGET - 1);
+			err =3D -EOVERFLOW;
 			goto release_host;
 		}
 	}
--=20
1.6.0.6



--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
