From: "Gurumurthy, Anil" <Anil.Gurumurthy@cavium.com>
Subject: RE: [PATCH 8/9] scsi: bfa: Use zeroing allocator rather than
 allocator/memset
Date: Tue, 2 Jan 2018 05:40:58 +0000
Message-ID: <SN1PR0701MB2031AC80AD59C82DA462F5638E190@SN1PR0701MB2031.namprd07.prod.outlook.com>
References: <1514647712-6332-1-git-send-email-himanshujha199640@gmail.com>
 <1514647712-6332-9-git-send-email-himanshujha199640@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0067.outbound.protection.outlook.com ([104.47.36.67]:8844
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751109AbeABFlE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 2 Jan 2018 00:41:04 -0500
In-Reply-To: <1514647712-6332-9-git-send-email-himanshujha199640@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Jha <himanshujha199640@gmail.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "aacraid@adaptec.com" <aacraid@adaptec.com>
Cc: "Kalluru, Sudarsana" <Sudarsana.Kalluru@cavium.com>, Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@cavium.com>, "satishkh@cisco.com" <satishkh@cisco.com>, "sebaddel@cisco.com" <sebaddel@cisco.com>, "kartilak@cisco.com" <kartilak@cisco.com>Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@cavium.com>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>



-----Original Message-----
From: Himanshu Jha [mailto:himanshujha199640@gmail.com]=20
Sent: 30 December 2017 20:59
To: jejb@linux.vnet.ibm.com; martin.petersen@oracle.com; aacraid@adaptec.co=
m
Cc: Gurumurthy, Anil <Anil.Gurumurthy@cavium.com>; Kalluru, Sudarsana <Suda=
rsana.Kalluru@cavium.com>; Dept-Eng QLogic Storage Upstream <QLogic-Storage=
-Upstream@cavium.com>; satishkh@cisco.com; sebaddel@cisco.com; kartilak@cis=
co.com; Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@cavium.co=
m>; Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>; linux-scsi@vge=
r.kernel.org; linux-kernel@vger.kernel.org; Himanshu Jha <himanshujha199640=
@gmail.com>
Subject: [PATCH 8/9] scsi: bfa: Use zeroing allocator rather than allocator=
/memset

Use vzalloc instead of vmalloc followed by memset 0.

Generated-by: scripts/coccinelle/api/alloc/kzalloc-simple.cocci

Suggested-by: Luis R. Rodriguez <mcgrof@kernel.org>
Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
---
 drivers/scsi/bfa/bfad.c         | 3 +--
 drivers/scsi/bfa/bfad_debugfs.c | 8 ++------
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c index bac18f=
6..bd7e6a6f 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -610,13 +610,12 @@ bfad_hal_mem_alloc(struct bfad_s *bfad)
 	/* Iterate through the KVA meminfo queue */
 	list_for_each(km_qe, &kva_info->qe) {
 		kva_elem =3D (struct bfa_mem_kva_s *) km_qe;
-		kva_elem->kva =3D vmalloc(kva_elem->mem_len);
+		kva_elem->kva =3D vzalloc(kva_elem->mem_len);
 		if (kva_elem->kva =3D=3D NULL) {
 			bfad_hal_mem_release(bfad);
 			rc =3D BFA_STATUS_ENOMEM;
 			goto ext;
 		}
-		memset(kva_elem->kva, 0, kva_elem->mem_len);
 	}
=20
 	/* Iterate through the DMA meminfo queue */ diff --git a/drivers/scsi/bfa=
/bfad_debugfs.c b/drivers/scsi/bfa/bfad_debugfs.c index 05f5239..349cfe7 10=
0644
--- a/drivers/scsi/bfa/bfad_debugfs.c
+++ b/drivers/scsi/bfa/bfad_debugfs.c
@@ -81,7 +81,7 @@ bfad_debugfs_open_fwtrc(struct inode *inode, struct file =
*file)
=20
 	fw_debug->buffer_len =3D sizeof(struct bfa_trc_mod_s);
=20
-	fw_debug->debug_buffer =3D vmalloc(fw_debug->buffer_len);
+	fw_debug->debug_buffer =3D vzalloc(fw_debug->buffer_len);
 	if (!fw_debug->debug_buffer) {
 		kfree(fw_debug);
 		printk(KERN_INFO "bfad[%d]: Failed to allocate fwtrc buffer\n", @@ -89,8=
 +89,6 @@ bfad_debugfs_open_fwtrc(struct inode *inode, struct file *file)
 		return -ENOMEM;
 	}
=20
-	memset(fw_debug->debug_buffer, 0, fw_debug->buffer_len);
-
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 	rc =3D bfa_ioc_debug_fwtrc(&bfad->bfa.ioc,
 			fw_debug->debug_buffer,
@@ -125,7 +123,7 @@ bfad_debugfs_open_fwsave(struct inode *inode, struct fi=
le *file)
=20
 	fw_debug->buffer_len =3D sizeof(struct bfa_trc_mod_s);
=20
-	fw_debug->debug_buffer =3D vmalloc(fw_debug->buffer_len);
+	fw_debug->debug_buffer =3D vzalloc(fw_debug->buffer_len);
 	if (!fw_debug->debug_buffer) {
 		kfree(fw_debug);
 		printk(KERN_INFO "bfad[%d]: Failed to allocate fwsave buffer\n", @@ -133=
,8 +131,6 @@ bfad_debugfs_open_fwsave(struct inode *inode, struct file *fil=
e)
 		return -ENOMEM;
 	}
=20
-	memset(fw_debug->debug_buffer, 0, fw_debug->buffer_len);
-
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 	rc =3D bfa_ioc_debug_fwsave(&bfad->bfa.ioc,
 			fw_debug->debug_buffer,
--
2.7.4

Acked by: Anil Gurumurthy <anil.gurumurthy@cavium.com>
