From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: [PATCH] SCSI tape driver fix for 2.5.51
Date: Tue, 10 Dec 2002 22:48:35 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200212102048.gBAKmZmn000833@kai.makisara.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kai.makisara.local ([62.248.241.214])
          by fep19-app.kolumbus.fi with ESMTP
          id <20021210205001.ICUK3999.fep19-app.kolumbus.fi@kai.makisara.local>
          for <linux-scsi@vger.kernel.org>; Tue, 10 Dec 2002 22:50:01 +0200
Received: from kai.makisara.local (localhost [127.0.0.1])
	by kai.makisara.local (8.12.3/8.12.3/SuSE Linux 0.6) with ESMTP id gBAKmZjK000834
	for <linux-scsi@vger.kernel.org>; Tue, 10 Dec 2002 22:48:35 +0200
Received: (from makisara@localhost)
	by kai.makisara.local (8.12.3/8.12.3/Submit) id gBAKmZmn000833
	for linux-scsi@vger.kernel.org; Tue, 10 Dec 2002 22:48:35 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The SCSI tape driver in 2.5.51 does not find any devices. The
following patch fixes this (and adds a missing unlocking call).

     Kai

--- linux-2.5/drivers/scsi/st.c	2002-12-10 17:33:47.000000000 +0200
+++ linux-2.5-km1/drivers/scsi/st.c	2002-12-10 18:24:01.000000000 +0200
@@ -991,8 +991,10 @@
 		return (-EBUSY);
 	}
 
-	if(!scsi_device_get(STp->device))
+	if(scsi_device_get(STp->device)) {
+		write_unlock(&st_dev_arr_lock);
 		return (-ENXIO);
+	}
 	STp->in_use = 1;
 	write_unlock(&st_dev_arr_lock);
 	STp->rew_at_close = STp->autorew_dev = (minor(inode->i_rdev) & 0x80) == 0;
