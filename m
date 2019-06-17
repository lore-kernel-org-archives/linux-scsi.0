From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] megaraid_sas: Delete a redundant memory setting in
 megasas_alloc_cmds()
Date: Mon, 17 Jun 2019 13:00:28 +0200
Message-ID: <3921d044-72d6-d092-e792-01c896ae222b@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com, "James E. J. Bottomley" <jejb@linux.ibm.com>, Kashyap Desai <kashyap.desai@broadcom.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>
Cc: kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 17 Jun 2019 12:42:15 +0200

The memory was set to zero already by a call of the function =E2=80=9Ckcal=
loc=E2=80=9D.
Thus remove an extra call of the function =E2=80=9Cmemset=E2=80=9D for thi=
s purpose.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/mega=
raid/megaraid_sas_base.c
index 176b59a34a79..047990d3cffd 100644
=2D-- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4239,8 +4239,6 @@ int megasas_alloc_cmds(struct megasas_instance *inst=
ance)
 		return -ENOMEM;
 	}

-	memset(instance->cmd_list, 0, sizeof(struct megasas_cmd *) *max_cmd);
-
 	for (i =3D 0; i < max_cmd; i++) {
 		instance->cmd_list[i] =3D kmalloc(sizeof(struct megasas_cmd),
 						GFP_KERNEL);
=2D-
2.22.0
