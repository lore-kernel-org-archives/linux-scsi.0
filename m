From: "Bean Huo (beanhuo)" <beanhuo@micron.com>
Subject: [PATCH v2 3/3] scsi: ufs-bsg: complete ufs-bsg job only if no error
Date: Sun, 23 Jun 2019 17:38:56 +0000
Message-ID: <BN7PR08MB568413353176CE5E61C2CF87DBE10@BN7PR08MB5684.namprd08.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, Evan Green <evgreen@chromium.org>, Stanley Chu <stanley.chu@mediatek.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Bean Huo (beanhuo)" <beanhuo@micron.com>
List-Id: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

In the case of UPIU/DME request execution failed in UFS device,
ufs_bsg_request() will complete this failed bsg job by calling
bsg_job_done(). Meanwhile, it returns this error status to blk-mq
layer, then triggers blk-mq completing this request again, this will
cause below panic.

Call trace:
ll_sc___cmpxchg_case_acq_32+0x4/0x20
complete+0x28/0x70
blk_end_sync_rq+0x24/0x30
blk_mq_end_request+0xb8/0x118
bsg_job_put+0x4c/0x58
bsg_complete+0x20/0x30
blk_done_softirq+0xb4/0xe8
do_softirq+0x154/0x3f0
run_ksoftirqd+0x4c/0x68
smpboot_thread_fn+0x22c/0x268
kthread+0x130/0x138
ret_from_fork+0x10/0x1c
Code: f84107fe d65f03c0 d503201f f9800011 (885ffc10)
---[ end trace d92825bff6326e66 ]---
Kernel panic - not syncing: Fatal exception in interrupt

This patch is to fix this issue. The solution is we complete
the ufs-bsg job only if no error happened.

Fixes: df032bf27a41 (scsi: ufs: Add a bsg endpoint that supports UPIUs)
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufs_bsg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c
index f420d6f8d84c..a9344eb4e047 100644
--- a/drivers/scsi/ufs/ufs_bsg.c
+++ b/drivers/scsi/ufs/ufs_bsg.c
@@ -149,7 +149,9 @@ static int ufs_bsg_request(struct bsg_job *job)
 out:
 	bsg_reply->result =3D ret;
 	job->reply_len =3D sizeof(struct ufs_bsg_reply);
-	bsg_job_done(job, ret, bsg_reply->reply_payload_rcv_len);
+	/* complete the job here only if no error */
+	if (ret =3D=3D 0)
+		bsg_job_done(job, ret, bsg_reply->reply_payload_rcv_len);
=20
 	return ret;
 }
--=20
2.7.4
