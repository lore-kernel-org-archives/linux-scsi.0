From: "Bean Huo (beanhuo)" <beanhuo@micron.com>
Subject: [PATCH v2 2/3] scsi: ufs-bsg: fix typo in ufs_bsg_request
Date: Sun, 23 Jun 2019 17:38:39 +0000
Message-ID: <BN7PR08MB56845341A1F184196F0D5C4FDBE10@BN7PR08MB5684.namprd08.prod.outlook.com>
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

Correct dev_dbg to dev_err, so as to print out the error
information in case of DME command failed.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufs_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c
index 869e71f861d6..f420d6f8d84c 100644
--- a/drivers/scsi/ufs/ufs_bsg.c
+++ b/drivers/scsi/ufs/ufs_bsg.c
@@ -122,7 +122,7 @@ static int ufs_bsg_request(struct bsg_job *job)
 		memcpy(&uc, &bsg_request->upiu_req.uc, UIC_CMD_SIZE);
 		ret =3D ufshcd_send_uic_cmd(hba, &uc);
 		if (ret)
-			dev_dbg(hba->dev,
+			dev_err(hba->dev,
 				"send uic cmd: error code %d\n", ret);
=20
 		memcpy(&bsg_reply->upiu_rsp.uc, &uc, UIC_CMD_SIZE);
--=20
2.7.4
