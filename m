From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [patch 2/8] mptfusion: streamline slave_alloc
Date: Fri, 19 Nov 2004 08:37:23 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C5468A7@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C4CE4D.AA5000F0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:27840 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261467AbUKSQMK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2004 11:12:10 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id iAJGATcq006782
	for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2004 08:10:29 -0800 (PST)
Received: from nacos172.ad.lsil.com (cos1.co.lsil.com [172.21.35.122])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id iAJGC6e7030456
	for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2004 08:12:07 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C4CE4D.AA5000F0
Content-Type: text/plain;
	charset="iso-8859-1"

This cleans up slave_xxx functions. 
This patch previously submitted by hch@.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


------_=_NextPart_000_01C4CE4D.AA5000F0
Content-Type: application/octet-stream;
	name="mptfusion-2.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="mptfusion-2.patch"

diff -uarN b/drivers/message/fusion/mptscsih.c =
a/drivers/message/fusion/mptscsih.c=0A=
--- b/drivers/message/fusion/mptscsih.c	2004-11-18 09:46:54.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptscsih.c	2004-11-18 10:39:56.000000000 =
-0700=0A=
@@ -1341,11 +1341,11 @@=0A=
 =0A=
 	hd =3D (MPT_SCSI_HOST *)host->hostdata;=0A=
 	if (hd !=3D NULL) {=0A=
-		int sz1, sz3, sztarget=3D0;=0A=
+		int sz1;=0A=
 =0A=
 		mptscsih_shutdown(&pdev->dev);=0A=
 =0A=
-		sz1 =3D sz3 =3D 0;=0A=
+		sz1=3D0;=0A=
 =0A=
 		if (hd->ScsiLookup !=3D NULL) {=0A=
 			sz1 =3D hd->ioc->req_depth * sizeof(void *);=0A=
@@ -1354,36 +1354,16 @@=0A=
 		}=0A=
 =0A=
 		if (hd->Targets !=3D NULL) {=0A=
-			int max, ii;=0A=
-=0A=
-			/*=0A=
-			 * Free any target structures that were allocated.=0A=
-			 */=0A=
-			if (hd->is_spi) {=0A=
-				max =3D MPT_MAX_SCSI_DEVICES;=0A=
-			} else {=0A=
-				max =3D MPT_MAX_FC_DEVICES<256 ? MPT_MAX_FC_DEVICES : 255;=0A=
-			}=0A=
-			for (ii=3D0; ii < max; ii++) {=0A=
-				if (hd->Targets[ii]) {=0A=
-					kfree(hd->Targets[ii]);=0A=
-					hd->Targets[ii] =3D NULL;=0A=
-					sztarget +=3D sizeof(VirtDevice);=0A=
-				}=0A=
-			}=0A=
-=0A=
 			/*=0A=
 			 * Free pointer array.=0A=
 			 */=0A=
-			sz3 =3D max * sizeof(void *);=0A=
 			kfree(hd->Targets);=0A=
 			hd->Targets =3D NULL;=0A=
 		}=0A=
 =0A=
 		dprintk((MYIOC_s_INFO_FMT =0A=
-		    "Free'd ScsiLookup (%d) Target (%d+%d) memory\n",=0A=
-		    hd->ioc->name, sz1, sz3, sztarget));=0A=
-		dprintk(("Free'd done and free Q (%d) memory\n", szQ));=0A=
+		    "Free'd ScsiLookup (%d) memory\n",=0A=
+		    hd->ioc->name, sz1));=0A=
 =0A=
 		/* NULL the Scsi_Host pointer=0A=
 		 */=0A=
@@ -2595,39 +2575,56 @@=0A=
 mptscsih_slave_alloc(struct scsi_device *device)=0A=
 {=0A=
 	struct Scsi_Host	*host =3D device->host;=0A=
-	MPT_SCSI_HOST		*hd;=0A=
+	MPT_SCSI_HOST		*hd =3D (MPT_SCSI_HOST *)host->hostdata;=0A=
 	VirtDevice		*vdev;=0A=
-=0A=
-	hd =3D (MPT_SCSI_HOST *)host->hostdata;=0A=
+	uint			target =3D device->id;=0A=
 =0A=
 	if (hd =3D=3D NULL)=0A=
 		return -ENODEV;=0A=
 =0A=
-	if ((vdev =3D hd->Targets[device->id]) =3D=3D NULL) {=0A=
-		if ((vdev =3D kmalloc(sizeof(VirtDevice), GFP_ATOMIC)) =3D=3D NULL) =
{=0A=
-			printk(MYIOC_s_ERR_FMT "slave_alloc kmalloc(%d) FAILED!\n",=0A=
-			hd->ioc->name, (int)sizeof(VirtDevice));=0A=
-			return -ENOMEM;=0A=
-		} else {=0A=
-			memset(vdev, 0, sizeof(VirtDevice));=0A=
-			vdev->tflags =3D MPT_TARGET_FLAGS_Q_YES;=0A=
-			vdev->ioc_id =3D hd->ioc->id;=0A=
-			vdev->target_id =3D device->id;=0A=
-			vdev->bus_id =3D device->channel;=0A=
-			vdev->raidVolume =3D 0;=0A=
-			hd->Targets[device->id] =3D vdev;=0A=
-			if (hd->is_spi) {=0A=
-				if (hd->ioc->spi_data.isRaid & (1 << device->id)) {=0A=
-					vdev->raidVolume =3D 1;=0A=
-					ddvtprintk((KERN_INFO=0A=
-					    "RAID Volume @ id %d\n", device->id));=0A=
-				}=0A=
-			} else {=0A=
-				vdev->tflags |=3D MPT_TARGET_FLAGS_VALID_INQUIRY;=0A=
-			}=0A=
+	if ((vdev =3D hd->Targets[target]) !=3D NULL)=0A=
+		goto out;=0A=
+=0A=
+	vdev =3D kmalloc(sizeof(VirtDevice), GFP_KERNEL);=0A=
+	if (!vdev) {=0A=
+		printk(MYIOC_s_ERR_FMT "slave_alloc kmalloc(%zd) FAILED!\n",=0A=
+				hd->ioc->name, sizeof(VirtDevice));=0A=
+		return -ENOMEM;=0A=
+	}=0A=
+=0A=
+	memset(vdev, 0, sizeof(VirtDevice));=0A=
+	vdev->tflags =3D MPT_TARGET_FLAGS_Q_YES;=0A=
+	vdev->ioc_id =3D hd->ioc->id;=0A=
+	vdev->target_id =3D device->id;=0A=
+	vdev->bus_id =3D device->channel;=0A=
+	vdev->raidVolume =3D 0;=0A=
+	hd->Targets[device->id] =3D vdev;=0A=
+	if (hd->is_spi) {=0A=
+		if (hd->ioc->spi_data.isRaid & (1 << device->id)) {=0A=
+			vdev->raidVolume =3D 1;=0A=
+			ddvtprintk((KERN_INFO=0A=
+			    "RAID Volume @ id %d\n", device->id));=0A=
 		}=0A=
+	} else {=0A=
+		vdev->tflags |=3D MPT_TARGET_FLAGS_VALID_INQUIRY;=0A=
 	}=0A=
+=0A=
+ out:=0A=
 	vdev->num_luns++;=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+static int mptscsih_is_raid_volume(MPT_SCSI_HOST *hd, uint id)=0A=
+{=0A=
+	int i;=0A=
+=0A=
+	if (!hd->ioc->spi_data.isRaid || !hd->ioc->spi_data.pIocPg3)=0A=
+		return 0;=0A=
+=0A=
+	for (i =3D 0; i < hd->ioc->spi_data.pIocPg3->NumPhysDisks; i++) {=0A=
+		if (id =3D=3D hd->ioc->spi_data.pIocPg3->PhysDisk[i].PhysDiskID)=0A=
+			return 1;=0A=
+	}=0A=
 =0A=
 	return 0;=0A=
 }=0A=
@@ -2640,59 +2637,37 @@=0A=
 mptscsih_slave_destroy(struct scsi_device *device)=0A=
 {=0A=
 	struct Scsi_Host	*host =3D device->host;=0A=
-	MPT_SCSI_HOST		*hd;=0A=
+	MPT_SCSI_HOST		*hd =3D (MPT_SCSI_HOST *)host->hostdata;=0A=
 	VirtDevice		*vdev;=0A=
-	int 			raid_volume=3D0;=0A=
-=0A=
-	hd =3D (MPT_SCSI_HOST *)host->hostdata;=0A=
+	uint			target =3D device->id;=0A=
+	uint			lun =3D device->lun;=0A=
 =0A=
 	if (hd =3D=3D NULL)=0A=
 		return;=0A=
 =0A=
-	mptscsih_search_running_cmds(hd, device->id, device->lun);=0A=
-=0A=
-	/* Free memory and reset all flags for this target=0A=
-	 */=0A=
-	if ((vdev =3D hd->Targets[device->id]) !=3D NULL) {=0A=
-		vdev->num_luns--;=0A=
-=0A=
-		if (vdev->luns[0] & (1 << device->lun))=0A=
-			vdev->luns[0] &=3D ~(1 << device->lun);=0A=
-=0A=
-		/* Free device structure only if number of luns is 0.=0A=
-		 */=0A=
-		if (vdev->num_luns =3D=3D 0) {=0A=
-			kfree(hd->Targets[device->id]);=0A=
-			hd->Targets[device->id] =3D NULL;=0A=
-=0A=
-			if (!hd->is_spi)=0A=
-				return;=0A=
+	mptscsih_search_running_cmds(hd, target, lun);=0A=
 =0A=
-			if((hd->ioc->spi_data.isRaid) && (hd->ioc->spi_data.pIocPg3)) {=0A=
-			int i;=0A=
-				for(i=3D0;i<hd->ioc->spi_data.pIocPg3->NumPhysDisks &&=0A=
-					raid_volume=3D=3D0;i++)=0A=
-=0A=
-					if(device->id =3D=3D=0A=
-					  hd->ioc->spi_data.pIocPg3->PhysDisk[i].PhysDiskID) {=0A=
-						raid_volume=3D1;=0A=
-						hd->ioc->spi_data.forceDv |=3D=0A=
-						  MPT_SCSICFG_RELOAD_IOC_PG3;=0A=
-					}=0A=
-			}=0A=
+	vdev =3D hd->Targets[target];=0A=
+	vdev->luns[0] &=3D ~(1 << lun);=0A=
+	if (--vdev->num_luns)=0A=
+		return;=0A=
 =0A=
-			if(!raid_volume){=0A=
-				hd->ioc->spi_data.dvStatus[device->id] =3D=0A=
+	kfree(hd->Targets[target]);=0A=
+	hd->Targets[target] =3D NULL;=0A=
+	=0A=
+	if (hd->is_spi) {=0A=
+		if (mptscsih_is_raid_volume(hd, target)) {=0A=
+			hd->ioc->spi_data.forceDv |=3D MPT_SCSICFG_RELOAD_IOC_PG3;=0A=
+		} else {=0A=
+			hd->ioc->spi_data.dvStatus[target] =3D=0A=
 				MPT_SCSICFG_NEGOTIATE;=0A=
 =0A=
-				if (hd->negoNvram =3D=3D 0)=0A=
-					hd->ioc->spi_data.dvStatus[device->id]=0A=
-					|=3D MPT_SCSICFG_DV_NOT_DONE;=0A=
+			if (!hd->negoNvram) {=0A=
+				hd->ioc->spi_data.dvStatus[target] |=3D=0A=
+					MPT_SCSICFG_DV_NOT_DONE;=0A=
 			}=0A=
 		}=0A=
 	}=0A=
-=0A=
-	return;=0A=
 }=0A=
 =0A=
 static void=0A=
@@ -2702,7 +2677,7 @@=0A=
 	int	max_depth;=0A=
 	int	tagged;=0A=
 =0A=
-	if ( hd->is_spi ) {=0A=
+	if (hd->is_spi) {=0A=
 		if (pTarget->tflags & MPT_TARGET_FLAGS_VALID_INQUIRY) {=0A=
 			if (!(pTarget->tflags & MPT_TARGET_FLAGS_Q_YES))=0A=
 				max_depth =3D 1;=0A=
@@ -2817,7 +2792,6 @@=0A=
 	return count;=0A=
 }=0A=
 =0A=
-=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
  *  Private routines...=0A=

------_=_NextPart_000_01C4CE4D.AA5000F0--
