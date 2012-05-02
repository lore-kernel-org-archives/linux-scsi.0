From: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>
Subject: [PATCH][TRIVIAL] scsi: aha152x: Fix sparse warning and make printing pointer address more portable.
Date: Wed,  2 May 2012 11:34:01 +0100
Message-ID: <1335954841-18899-1-git-send-email-krzysztof.wilczynski@linux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Juergen E . Fischer" <fischer@norbit.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, trivial@kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is to change use of "0x%08x" in favour of "%p" as per ../Documenta=
tion/printk-formats.txt,
which also takes care about the following warning during compilation ti=
me:

  drivers/scsi/aha152x.c: In function =E2=80=98get_command=E2=80=99:
  drivers/scsi/aha152x.c:2987: warning: cast from pointer to integer of=
 different size

Signed-off-by: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>
---
 drivers/scsi/aha152x.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 19a3694..dd4547b 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -2984,8 +2984,8 @@ static int get_command(char *pos, Scsi_Cmnd * ptr=
)
 	char *start =3D pos;
 	int i;
=20
-	SPRINTF("0x%08x: target=3D%d; lun=3D%d; cmnd=3D( ",
-		(unsigned int) ptr, ptr->device->id, ptr->device->lun);
+	SPRINTF("%p: target=3D%d; lun=3D%d; cmnd=3D( ",
+		ptr, ptr->device->id, ptr->device->lun);
=20
 	for (i =3D 0; i < COMMAND_SIZE(ptr->cmnd[0]); i++)
 		SPRINTF("0x%02x ", ptr->cmnd[i]);
--=20
1.7.2.5
