From: "Bean Huo (beanhuo)" <beanhuo@micron.com>
Subject: RE:  [PATCH v4 1/3] scsi: ufs-bsg: Change the calling convention for
 write descriptor
Date: Wed, 30 Jan 2019 14:53:14 +0000
Message-ID: <BYAPR08MB453398C5D7BD52EB90A36096DB900@BYAPR08MB4533.namprd08.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Avri Altman <avri.altman@wdc.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Evan Green <evgreen@chromium.org>
Cc: Avi Shchislowski <avi.shchislowski@wdc.com>, Alex Lemberg <alex.lemberg@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Hi, Avri

>
>When we had a write descriptor query upiu, we appended the descriptor righ=
t
>after the bsg request.  This was fine as the bsg driver allows to allocate=
 whatever
>buffer we needed in its job request.
>
>Still, the proper way to deliver payload, however small (we only write con=
fig
>descriptors of 144 bytes), is by using the job request payload data buffer=
.
>
>So change this ABI now, while ufs-bsg is still new, and nobody is actually=
 using it.
>
>Signed-off-by: Avri Altman <avri.altman@wdc.com>
>Reviewed-by: Evan Green <evgreen@chromium.org>
>---
> Documentation/scsi/ufs.txt |  6 ++++++
> drivers/scsi/ufs/ufs_bsg.c | 47 +++++++++++++++++++++++++----------------=
-----
> 2 files changed, 32 insertions(+), 21 deletions(-)
>
>diff --git a/Documentation/scsi/ufs.txt b/Documentation/scsi/ufs.txt index
>520b5b0..78fe7cb 100644
>--- a/Documentation/scsi/ufs.txt
>+++ b/Documentation/scsi/ufs.txt
>@@ -147,6 +147,12 @@ send SG_IO with the applicable sg_io_v4:
> 	io_hdr_v4.max_response_len =3D reply_len;
> 	io_hdr_v4.request_len =3D request_len;
> 	io_hdr_v4.request =3D (__u64)request_upiu;
>+	if (dir =3D=3D SG_DXFER_TO_DEV) {
>+		io_hdr_v4.dout_xfer_len =3D (uint32_t)byte_cnt;
>+		io_hdr_v4.dout_xferp =3D (uintptr_t)(__u64)buff;
>+	}
>+
>+If you wish to write a descriptor, use the dout_xferp sg_io_v4.
>
> UFS Specifications can be found at,
> UFS - http://www.jedec.org/sites/default/files/docs/JESD220.pdf
>diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c index
>775bb4e..2fd0769 100644
>--- a/drivers/scsi/ufs/ufs_bsg.c
>+++ b/drivers/scsi/ufs/ufs_bsg.c
>@@ -27,15 +27,11 @@ static int ufs_bsg_get_query_desc_size(struct ufs_hba
>*hba, int *desc_len,
>
> static int ufs_bsg_verify_query_size(struct ufs_hba *hba,
> 				     unsigned int request_len,
>-				     unsigned int reply_len,
>-				     int desc_len, enum query_opcode desc_op)
>+				     unsigned int reply_len)
> {
> 	int min_req_len =3D sizeof(struct ufs_bsg_request);
> 	int min_rsp_len =3D sizeof(struct ufs_bsg_reply);
>
>-	if (desc_op =3D=3D UPIU_QUERY_OPCODE_WRITE_DESC)
>-		min_req_len +=3D desc_len;
>-
> 	if (min_req_len > request_len || min_rsp_len > reply_len) {
> 		dev_err(hba->dev, "not enough space assigned\n");
> 		return -EINVAL;
>@@ -44,14 +40,13 @@ static int ufs_bsg_verify_query_size(struct ufs_hba *h=
ba,
> 	return 0;
> }
>
>-static int ufs_bsg_verify_query_params(struct ufs_hba *hba,
>-				       struct ufs_bsg_request *bsg_request,
>-				       unsigned int request_len,
>-				       unsigned int reply_len,
>-				       uint8_t *desc_buff, int *desc_len,
>-				       enum query_opcode desc_op)
>+static int ufs_bsg_alloc_desc_buffer(struct ufs_hba *hba, struct bsg_job =
*job,
>+				     uint8_t **desc_buff, int *desc_len,

Maybe here also we should use 'u8'.

Reviewed-by: Bean Huo <beanhuo@beanhuo@micron.com>

//Beanhuo
