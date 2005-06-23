From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH] - mptfusion - adding back the spin locks in eh handlers
Date: Thu, 23 Jun 2005 12:20:08 -0600
Message-ID: <200506231220.08036.Eric.Moore@lsil.com>
Reply-To: Eric.Moore@lsil.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:28599 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262636AbVFWSSx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Jun 2005 14:18:53 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>

The eh handlers are called with host_lock acquired, and interrupts disa=
bled.
However fusion waits for completion of task managment request.  With th=
ese spin locks=20
removed, the driver is going to hang within the sleep calls.   Someone =
recently posted=20
a patch to remove them(don=B4t know who),  and can be found in James Bo=
ttomely scsi-misc branch. =20

Please apply.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


diff -uarN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion=
/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2005-06-23 11:18:44.000000000 -=
0600
+++ a/drivers/message/fusion/mptscsih.c	2005-05-10 14:27:13.000000000 -=
0600
@@ -1707,6 +1707,7 @@
 	MPT_FRAME_HDR	*mf;
 	u32		 ctx2abort;
 	int		 scpnt_idx;
+	spinlock_t	*host_lock =3D SCpnt->device->host->host_lock;
=20
 	/* If we can't locate our host adapter structure, return FAILED statu=
s.
 	 */
@@ -1754,6 +1755,7 @@
=20
 	hd->abortSCpnt =3D SCpnt;
=20
+	spin_unlock_irq(host_lock);
 	if (mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_ABORT_TASK,
 		SCpnt->device->channel, SCpnt->device->id, SCpnt->device->lun,
 		ctx2abort, 2 /* 2 second timeout */)
@@ -1770,6 +1772,8 @@
 		hd->tmPending =3D 0;
 		hd->tmState =3D TM_STATE_NONE;
=20
+		spin_lock_irq(host_lock);
+
 		/* Unmap the DMA buffers, if any. */
 		if (SCpnt->use_sg) {
 			pci_unmap_sg(ioc->pcidev, (struct scatterlist *) SCpnt->request_buf=
fer,
@@ -1785,6 +1789,7 @@
 		mpt_free_msg_frame(ioc, mf);
 		return FAILED;
 	}
+	spin_lock_irq(host_lock);
 	return SUCCESS;
 }
=20
@@ -1801,6 +1806,7 @@
 mptscsih_dev_reset(struct scsi_cmnd * SCpnt)
 {
 	MPT_SCSI_HOST	*hd;
+	spinlock_t	*host_lock =3D SCpnt->device->host->host_lock;
=20
 	/* If we can't locate our host adapter structure, return FAILED statu=
s.
 	 */
@@ -1817,6 +1823,7 @@
 	printk(KERN_WARNING MYNAM ": %s: >> Attempting target reset! (sc=3D%p=
)\n",
 	       hd->ioc->name, SCpnt);
=20
+	spin_unlock_irq(host_lock);
 	if (mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
 		SCpnt->device->channel, SCpnt->device->id,
 		0, 0, 5 /* 5 second timeout */)
@@ -1828,10 +1835,12 @@
 		 		hd->ioc->name, SCpnt);
 		hd->tmPending =3D 0;
 		hd->tmState =3D TM_STATE_NONE;
+		spin_lock_irq(host_lock);
 		return FAILED;
 	}
-
+	spin_lock_irq(host_lock);
 	return SUCCESS;
+
 }
=20
 /*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D*/
@@ -1865,6 +1874,7 @@
 		hd->timeouts++;
=20
 	/* We are now ready to execute the task management request. */
+	spin_unlock_irq(host_lock);
 	if (mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,
 		SCpnt->device->channel, 0, 0, 0, 5 /* 5 second timeout */)
 	    < 0){
@@ -1880,7 +1890,7 @@
 		spin_lock_irq(host_lock);
 		return FAILED;
 	}
-
+	spin_lock_irq(host_lock);
 	return SUCCESS;
 }
=20
@@ -1899,6 +1909,7 @@
 {
 	MPT_SCSI_HOST *  hd;
 	int              status =3D SUCCESS;
+	spinlock_t	*host_lock =3D SCpnt->device->host->host_lock;
=20
 	/*  If we can't locate the host to reset, then we failed. */
 	if ((hd =3D (MPT_SCSI_HOST *) SCpnt->device->host->hostdata) =3D=3D N=
ULL){
@@ -1914,6 +1925,7 @@
 	/*  If our attempts to reset the host failed, then return a failed
 	 *  status.  The host will be taken off line by the SCSI mid-layer.
 	 */
+	spin_unlock_irq(host_lock);
 	if (mpt_HardResetHandler(hd->ioc, CAN_SLEEP) < 0){
 		status =3D FAILED;
 	} else {
@@ -1923,6 +1935,8 @@
 		hd->tmPending =3D 0;
 		hd->tmState =3D TM_STATE_NONE;
 	}
+	spin_lock_irq(host_lock);
+
=20
 	dtmprintk( ( KERN_WARNING MYNAM ": mptscsih_host_reset: "
 		     "Status =3D %s\n",
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
