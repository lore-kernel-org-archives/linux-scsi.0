From: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: [PATCH -tip][SCSI] scsi: scsi_transport_iscsi.c initialize the
 variable before it get used
Date: Tue, 26 May 2009 20:49:21 +0530
Message-ID: <1243351161.31783.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:34390 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbZEZPTs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 May 2009 11:19:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vge>

I am watching this problem from long time in -tip.

Subject: [PATCH] scsi: scsi_transport_iscsi.c initialize the variable b=
efore it get used

In some cases, err will be used uninitialized.

Also fixed compilation warning :

 CC      drivers/scsi/scsi_transport_iscsi.o
drivers/scsi/scsi_transport_iscsi.c: In function =E2=80=98iscsi_add_ses=
sion=E2=80=99:
drivers/scsi/scsi_transport_iscsi.c:678: warning: =E2=80=98err=E2=80=99=
 may be used uninitialized in this function

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/scsi/scsi_transport_iscsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_tr=
ansport_iscsi.c
index 0947954..e78cde2 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -675,7 +675,7 @@ int iscsi_add_session(struct iscsi_cls_session *ses=
sion, unsigned int target_id)
 	struct iscsi_cls_host *ihost;
 	unsigned long flags;
 	unsigned int id =3D target_id;
-	int err;
+	int err =3D 0;
=20
 	ihost =3D shost->shost_data;
 	session->sid =3D atomic_add_return(1, &iscsi_session_nr);
--=20
1.6.0.6



--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
