From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: Re: [patch] qla2xxx: fix a timeout loop
Date: Thu, 17 Dec 2015 01:25:16 +0000
Message-ID: <D2974DA7.CE3FD%himanshu.madhani@qlogic.com>
References: <20151216110746.GB21018@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20151216110746.GB21018@mwanda>
Content-Language: en-US
Content-ID: <2434BDB7D00870409B42162E2FB444B9@qlogic.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@qlogic.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Dan,=20


On 12/16/15, 3:07 AM, "linux-scsi-owner@vger.kernel.org on behalf of Da=
n
Carpenter" <linux-scsi-owner@vger.kernel.org on behalf of
dan.carpenter@oracle.com> wrote:

>After the loop we test for "if (!retries) " as a failure, but actually
>the post-op here will end with retries set to -1.  I have fixed this b=
y
>using a pre-op instead.
>
>Fixes: 7ec0effd30bb ('[SCSI] qla2xxx: Add support for ISP8044.')
>Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
>diff --git a/drivers/scsi/qla2xxx/qla_nx2.c
>b/drivers/scsi/qla2xxx/qla_nx2.c
>index 007192d..66d629e 100644
>--- a/drivers/scsi/qla2xxx/qla_nx2.c
>+++ b/drivers/scsi/qla2xxx/qla_nx2.c
>@@ -3491,7 +3491,7 @@ qla8044_poll_flash_status_reg(struct scsi_qla_ho=
st
>*vha)
> 	int retries =3D QLA8044_FLASH_READ_RETRY_COUNT;
> 	int ret_val =3D QLA_SUCCESS;
>=20
>-	while (retries--) {
>+	while (--retries) {
> 		ret_val =3D qla8044_rd_reg_indirect(vha, QLA8044_FLASH_STATUS,
> 		    &flash_status);
> 		if (ret_val) {

There is flaw in this pre-decrement logic here for following 2 reasons
1. The pre-decrement reduces the total number of retries by one
2. If the retries is already Zero, then the pre-decrement would cause l=
oop
to iterate for a very large number of times.

The correct fix for this would be to change the if(!retries) to if
(retries =3D=3D -1) or if (retries < 0)

We=B9ll send a follow up patch to fix this.

Thanks,
Himanshu
>--
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" =
in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe kernel-janito=
rs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
