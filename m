From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] st: unblock concurrent access in st_open()
Date: Wed, 15 Aug 2012 16:24:49 +0200
Message-ID: <1345040689-29362-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52926 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753495Ab2HOOYv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Aug 2012 10:24:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>, =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>, Lee Duncan <lduncan@suse.com>

st_open() is taking a global mutex 'st_mutex' to protect
against concurrent calls to st_open(). However, as
st_open() might take quite some time before returning,
_any_ open to _any_ st device will be blocked during
that time.

Seeing that all critical sections are already protected
by individual spinlocks 'st_mutex' doesn't serve any
purpose and can be removed, unblocking concurrent
accesses.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>
Cc: Kai M=C3=A4kisara <Kai.Makisara@kolumbus.fi>
Cc: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/st.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index e41998c..c6c172e 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -74,7 +74,6 @@ static const char *verstr =3D "20101219";
 #include "st_options.h"
 #include "st.h"
=20
-static DEFINE_MUTEX(st_mutex);
 static int buffer_kbs;
 static int max_sg_segs;
 static int try_direct_io =3D TRY_DIRECT_IO;
@@ -1188,7 +1187,6 @@ static int st_open(struct inode *inode, struct fi=
le *filp)
 	int dev =3D TAPE_NR(inode);
 	char *name;
=20
-	mutex_lock(&st_mutex);
 	/*
 	 * We really want to do nonseekable_open(inode, filp); here, but some
 	 * versions of tar incorrectly call lseek on tapes and bail out if th=
at
@@ -1197,7 +1195,6 @@ static int st_open(struct inode *inode, struct fi=
le *filp)
 	filp->f_mode &=3D ~(FMODE_PREAD | FMODE_PWRITE);
=20
 	if (!(STp =3D scsi_tape_get(dev))) {
-		mutex_unlock(&st_mutex);
 		return -ENXIO;
 	}
=20
@@ -1208,7 +1205,6 @@ static int st_open(struct inode *inode, struct fi=
le *filp)
 	if (STp->in_use) {
 		write_unlock(&st_dev_arr_lock);
 		scsi_tape_put(STp);
-		mutex_unlock(&st_mutex);
 		DEB( printk(ST_DEB_MSG "%s: Device already in use.\n", name); )
 		return (-EBUSY);
 	}
@@ -1262,16 +1258,16 @@ static int st_open(struct inode *inode, struct =
file *filp)
 			retval =3D (-EIO);
 		goto err_out;
 	}
-	mutex_unlock(&st_mutex);
 	return 0;
=20
  err_out:
 	normalize_buffer(STp->buffer);
+	write_lock(&st_dev_arr_lock);
 	STp->in_use =3D 0;
+	write_unlock(&st_dev_arr_lock);
 	scsi_tape_put(STp);
 	if (resumed)
 		scsi_autopm_put_device(STp->device);
-	mutex_unlock(&st_mutex);
 	return retval;
=20
 }
--=20
1.7.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
