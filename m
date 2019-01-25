From: "Satish Kharat (satishkh)" <satishkh@cisco.com>
Subject: RE: [PATCH -next] scsi: fnic: Remove set but not used variable 'vdev'
Date: Fri, 25 Jan 2019 19:41:56 +0000
Message-ID: <e2c3cd5a937045269760d703985392bb@XCH-RCD-012.cisco.com>
References: <20190125020014.11184-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190125020014.11184-1-yuehaibing@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>, "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>, "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Looks good to me.

Acked-by: Satish Kharat <satishkh@cisco.com>


Satish Kharat
TECHNICAL LEADER.ENGINEERING
satishkh@cisco.com
Tel: +1 408 526 7504

Cisco Systems, Inc.
3800 Zanker Road
SAN JOSE
95134
United States
cisco.com

Think before you print.
This email may contain confidential and privileged material for the sole us=
e of the intended recipient. Any review, use, distribution or disclosure by=
 others is strictly prohibited. If you are not the intended recipient (or a=
uthorized to receive for the recipient), please contact the sender by reply=
 email and delete all copies of this message.
http://www.cisco.com/c/en/us/about/legal/terms-sale-software-license-agreem=
ent/company-registration-information.html
-----Original Message-----
From: YueHaibing <yuehaibing@huawei.com>=20
Sent: Thursday, January 24, 2019 6:00 PM
To: Satish Kharat (satishkh) <satishkh@cisco.com>; Sesidhar Baddela (sebadd=
el) <sebaddel@cisco.com>; Karan Tilak Kumar (kartilak) <kartilak@cisco.com>=
; jejb@linux.ibm.com; martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; YueHaibing <y=
uehaibing@huawei.com>
Subject: [PATCH -next] scsi: fnic: Remove set but not used variable 'vdev'

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/scsi/fnic/vnic_wq.c: In function 'vnic_wq_alloc_bufs':
drivers/scsi/fnic/vnic_wq.c:50:19: warning:
 variable 'vdev' set but not used [-Wunused-but-set-variable]

drivers/scsi/fnic/vnic_rq.c: In function 'vnic_rq_alloc_bufs':
drivers/scsi/fnic/vnic_rq.c:30:19: warning:
 variable 'vdev' set but not used [-Wunused-but-set-variable]

It never used since introduction

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/scsi/fnic/vnic_rq.c | 3 ---
 drivers/scsi/fnic/vnic_wq.c | 3 ---
 2 files changed, 6 deletions(-)

diff --git a/drivers/scsi/fnic/vnic_rq.c b/drivers/scsi/fnic/vnic_rq.c inde=
x 74d2f2c..6a35b1b 100644
--- a/drivers/scsi/fnic/vnic_rq.c
+++ b/drivers/scsi/fnic/vnic_rq.c
@@ -27,12 +27,9 @@
 static int vnic_rq_alloc_bufs(struct vnic_rq *rq)  {
 	struct vnic_rq_buf *buf;
-	struct vnic_dev *vdev;
 	unsigned int i, j, count =3D rq->ring.desc_count;
 	unsigned int blks =3D VNIC_RQ_BUF_BLKS_NEEDED(count);
=20
-	vdev =3D rq->vdev;
-
 	for (i =3D 0; i < blks; i++) {
 		rq->bufs[i] =3D kzalloc(VNIC_RQ_BUF_BLK_SZ, GFP_ATOMIC);
 		if (!rq->bufs[i]) {
diff --git a/drivers/scsi/fnic/vnic_wq.c b/drivers/scsi/fnic/vnic_wq.c inde=
x 74cfc56..015af2c 100644
--- a/drivers/scsi/fnic/vnic_wq.c
+++ b/drivers/scsi/fnic/vnic_wq.c
@@ -47,12 +47,9 @@ int vnic_wq_alloc_ring(struct vnic_dev *vdev, struct vni=
c_wq *wq,  static int vnic_wq_alloc_bufs(struct vnic_wq *wq)  {
 	struct vnic_wq_buf *buf;
-	struct vnic_dev *vdev;
 	unsigned int i, j, count =3D wq->ring.desc_count;
 	unsigned int blks =3D VNIC_WQ_BUF_BLKS_NEEDED(count);
=20
-	vdev =3D wq->vdev;
-
 	for (i =3D 0; i < blks; i++) {
 		wq->bufs[i] =3D kzalloc(VNIC_WQ_BUF_BLK_SZ, GFP_ATOMIC);
 		if (!wq->bufs[i]) {
--
2.7.0
