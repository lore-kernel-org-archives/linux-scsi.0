From: Martin Peschke <mp3@de.ibm.com>
Subject: [Patch] zfcp: fix compiler warning caused by poking inside new
	semaphore (linux-next)
Date: Thu, 17 Apr 2008 00:08:03 +0200
Message-ID: <1208383683.4163.14.camel@kitka.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:50614 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbYDPWIF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Apr 2008 18:08:05 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate4.de.ibm.com (8.13.8/8.13.8) with ESMTP id m3GM84Sq047020
	for <linux-scsi@vger.kernel.org>; Wed, 16 Apr 2008 22:08:04 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3GM84sr4124920
	for <linux-scsi@vger.kernel.org>; Thu, 17 Apr 2008 00:08:04 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3GM83mk022507
	for <linux-scsi@vger.kernel.org>; Thu, 17 Apr 2008 00:08:04 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linux-Scsi <linux-scsi@vger.kernel.org>, heiko.carstens@de.ibm.com, schmichr@de.ibm.com

=46rom: Martin Peschke <mp3@de.ibm.com>

as seen in linux-next tree:

drivers/s390/scsi/zfcp_dbf.c: In function =E2=80=98zfcp_rec_dbf_event_t=
hread=E2=80=99:
drivers/s390/scsi/zfcp_dbf.c:697: warning: passing argument 1 of =E2=80=
=98atomic_read=E2=80=99
 from incompatible pointer type

Caused by recent git commit 348447e85749120ad600a5c8e23b6bb7058b931d

We are not supposed to poke inside semaphore.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c |    2 --
 drivers/s390/scsi/zfcp_dbf.h |    1 -
 2 files changed, 3 deletions(-)

--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -623,7 +623,6 @@ static int zfcp_rec_dbf_view_format(debu
 	zfcp_dbf_out(&p, "id", "%d", r->id2);
 	switch (r->id) {
 	case ZFCP_REC_DBF_ID_THREAD:
-		zfcp_dbf_out(&p, "sema", "%d", r->u.thread.sema);
 		zfcp_dbf_out(&p, "total", "%d", r->u.thread.total);
 		zfcp_dbf_out(&p, "ready", "%d", r->u.thread.ready);
 		zfcp_dbf_out(&p, "running", "%d", r->u.thread.running);
@@ -694,7 +693,6 @@ void zfcp_rec_dbf_event_thread(u8 id2, s
 	memset(r, 0, sizeof(*r));
 	r->id =3D ZFCP_REC_DBF_ID_THREAD;
 	r->id2 =3D id2;
-	r->u.thread.sema =3D atomic_read(&adapter->erp_ready_sem.count);
 	r->u.thread.total =3D total;
 	r->u.thread.ready =3D ready;
 	r->u.thread.running =3D running;
--- a/drivers/s390/scsi/zfcp_dbf.h
+++ b/drivers/s390/scsi/zfcp_dbf.h
@@ -35,7 +35,6 @@ struct zfcp_dbf_dump {
 } __attribute__ ((packed));
=20
 struct zfcp_rec_dbf_record_thread {
-	u32 sema;
 	u32 total;
 	u32 ready;
 	u32 running;


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
