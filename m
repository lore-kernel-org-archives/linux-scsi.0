From: Alexander Strakh <strakh@ispras.ru>
Subject: BUG null dereference in drivers/message/fusion/mptscsih.c
Date: Mon, 14 Dec 2009 21:02:32 +0000
Message-ID: <200912142102.32774.strakh@ispras.ru>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.ispras.ru ([83.149.198.201]:46608 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757968AbZLNQ47 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Dec 2009 11:56:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <Eric.Moore@lsi.com>, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org

	KERNEL_VERSION: 2.6.32
	SUBJECT: null dereference in function mptscsih_qcmd
	DESCRIBE:
	In ./drivers/ata/sata_mv.c in function mptscsih_qcmd 

Null dereference in line 1371 of vdevice (vdevice->vtarget->id).
We assume that it may be null, because we check it in line 1361 in the if 
statement. (if vdevice is null we goto to the else part in line 1366)

1300 int
1301 mptscsih_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
1302 {
...
1361         if (vdevice
1362             && (vdevice->vtarget->tflags & MPT_TARGET_FLAGS_Q_YES)
1363             && (SCpnt->device->tagged_supported)) {
1364                 scsictl = scsidir | MPI_SCSIIO_CONTROL_SIMPLEQ;
1365         } else {
1366                 scsictl = scsidir | MPI_SCSIIO_CONTROL_UNTAGGED;
1367         }
1368
1369         /* Use the above information to set up the message frame
1370          */
1371         pScsiReq->TargetID = (u8) vdevice->vtarget->id;
1372         pScsiReq->Bus = vdevice->vtarget->channel;
...
}

Found by Linux Device Drivers Verification Project (Svace Detector)
