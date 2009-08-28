From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH][RESUBMIT] scsi_dh_rdac: Fix for returning
 correct mode select cmd return info
Date: Fri, 28 Aug 2009 08:18:39 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF474C65F39@cosmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>, "'dm-devel@redhat.com'" <dm-devel@redhat.com>, "Chauhan,
	Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>
List-Id: linux-scsi@vger.kernel.org

The function mode_select_handle_sense returns SCSI_DH_OK even when there =
is a sense code which is incorrect. Removing it so that it returns SCSI_D=
H_IO when there is sense that is not handled by this function.

Signed-off-by: Babu Moger <babu.moger@lsi.com>
Reviewed-by: Vijay Chauhan <vijay.chauhan@lsi.com>
Reviewed-by: Bob Stankey <Robert.stankey@lsi.com>

---
--- linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2009=
-08-22 06:20:45.000000000 -0500
+++ linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-08-2=
2 06:18:36.000000000 -0500
@@ -455,8 +455,6 @@ static int mode_select_handle_sense(stru
 	if (!ret)
 		goto done;
=20
-	err =3D SCSI_DH_OK;
-
 	switch (sense_hdr.sense_key) {
 	case NO_SENSE:
 	case ABORTED_COMMAND:
