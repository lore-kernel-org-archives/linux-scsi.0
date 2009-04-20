From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH] dm mpath: Try recover from I/O failure by
 re-initializing the PG if device is running on one path
Date: Mon, 20 Apr 2009 11:05:00 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF466A0E4DA@cosmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
List-Id: linux-scsi@vger.kernel.org

This patch introduces the mechanism to recover from I/O failures by re-in=
itializing the path if the device is running on only one path.=20

Problem: Device mapper fails the path for every I/O error. It does not ca=
re about the type of error. There are certain errors which can be recover=
ed by re-initializing the path again. I have seen this problem during my =
testing on rdac device handler. I have observed I/O errors when there is =
a change in Lun ownership. When Lun ownership changes device will return =
back with check condition with sense 0x05/0x94/0x01(SK/ASC/ASCQ -meaning =
Lun ownership changed). Currently, device mapper fails the path for this =
error and eventually this will lead to I/O error. We don't want to see I/=
O error for this reason.=20

The patch will set the flag pg_init_required if the device is running on =
single path. The process_queued_ios will re-initialize path if required. =
I have tested this patch on LSI rdac handler.

Signed-off-by: Babu Moger <babu.moger@lsi.com>
---

--- linux-2.6.30-rc2/drivers/md/dm-mpath.c.orig	2009-04-17 16:49:33.00000=
0000 -0500
+++ linux-2.6.30-rc2/drivers/md/dm-mpath.c	2009-04-17 17:09:51.000000000 =
-0500
@@ -1152,6 +1152,15 @@ static int do_end_io(struct multipath *m
 		return error;
=20
 	spin_lock_irqsave(&m->lock, flags);
+	/*
+	 * If this is the only path left, then lets try to
+	 * re-initialize the PG one last time..
+	 */
+	if (m->nr_valid_paths =3D=3D 1 && m->hw_handler_name) {
+		m->pg_init_required =3D 1;
+		spin_unlock_irqrestore(&m->lock, flags);
+		goto requeue;
+	}
 	if (!m->nr_valid_paths) {
 		if (__must_push_back(m)) {
 			spin_unlock_irqrestore(&m->lock, flags);
