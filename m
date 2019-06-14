From: Saurav Kashyap <skashyap@marvell.com>
Subject: Re: [PATCH] scsi: bnx2fc: Check if sense buffer has been allocated
 during completion
Date: Fri, 14 Jun 2019 09:47:26 +0000
Message-ID: <D9296ADB.1A233%skashyap@marvell.com>
References: <1560501397-831-1-git-send-email-92siuyang@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1560501397-831-1-git-send-email-92siuyang@gmail.com>
Content-Language: en-US
Content-ID: <238FE32BDB6C7C4BAEE1507B150D240B@namprd18.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Young Xiao <92siuyang@gmail.com>, "QLogic-Storage-Upstream@qlogic.com" <QLogic-Storage-Upstream@qlogic.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



-----Original Message-----
From: <linux-scsi-owner@vger.kernel.org> on behalf of Young Xiao
<92siuyang@gmail.com>
Date: Friday, 14 June 2019 at 2:06 PM
To: "QLogic-Storage-Upstream@qlogic.com"
<QLogic-Storage-Upstream@qlogic.com>, "jejb@linux.ibm.com"
<jejb@linux.ibm.com>, "martin.petersen@oracle.com"
<martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org"
<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
<linux-kernel@vger.kernel.org>
Cc: Young Xiao <92siuyang@gmail.com>
Subject: [PATCH] scsi: bnx2fc: Check if sense buffer has been allocated
during completion

>sc_cmd->sense_buffer is not guaranteed to be allocated so we need to
>sc_cmd->check if the pointer is NULL before trying to copy anything into
>it.
>
>See commit 16a611154dc1 ("scsi: qedf: Check if sense buffer has been
>allocated
>during completion") for details.
>
>Signed-off-by: Young Xiao <92siuyang@gmail.com>
>---
> drivers/scsi/bnx2fc/bnx2fc_io.c | 8 +++++---
> 1 file changed, 5 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c
>b/drivers/scsi/bnx2fc/bnx2fc_io.c
>index 8def63c..44a5e59 100644
>--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
>+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
>@@ -1789,9 +1789,11 @@ static void bnx2fc_parse_fcp_rsp(struct bnx2fc_cmd
>*io_req,
> 			fcp_sns_len =3D SCSI_SENSE_BUFFERSIZE;
> 		}
>=20
>-		memset(sc_cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
>-		if (fcp_sns_len)
>-			memcpy(sc_cmd->sense_buffer, rq_data, fcp_sns_len);
>+		if (sc_cmd->sense_buffer) {
>+			memset(sc_cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
>+			if (fcp_sns_len)
>+				memcpy(sc_cmd->sense_buffer, rq_data, fcp_sns_len);
>+		}
>=20
> 		/* return RQ entries */
> 		for (i =3D 0; i < num_rq; i++)
>--=20
>2.7.4

Thanks for the patch
Acked-by: Saurav Kashyap <skashyap@marvell.com>

Thanks,
~Saurav
>
