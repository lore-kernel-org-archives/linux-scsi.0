From: Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH v2] [SCSI] scsi_debug: silence GCC warning
Date: Mon, 15 Jul 2013 20:48:01 +0200
Message-ID: <1373914081.2591.40.camel@x61.thuisdomein>
References: <1373879920.2591.13.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1373879920.2591.13.camel@x61.thuisdomein>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Building scsi_debug.o triggers a GCC warning:
    drivers/scsi/scsi_debug.c: In function =E2=80=98dif_verify=E2=80=99=
:
    drivers/scsi/scsi_debug.c:1755:3: warning: =E2=80=98csum=E2=80=99 m=
ay be used uninitialized in this function [-Wmaybe-uninitialized]

This is a false positive. But if we transform the switch statement in
dif_compute_csum() to a straightforward if/else statement we supply GCC
with enough information to determine that csum will not be used
uninitialized.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) v2 because I started to worry whether v1 would change an interface
(ie, the way the "guard" module parameter behaves). This patch is much
simpler, and doesn't change any behavior.

1) Still only compile tested.

 drivers/scsi/scsi_debug.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index cb4fefa..7565ec5 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1735,14 +1735,11 @@ static u16 dif_compute_csum(const void *buf, in=
t len)
 {
 	u16 csum;
=20
-	switch (scsi_debug_guard) {
-	case 1:
+	if (scsi_debug_guard =3D=3D 1)
 		csum =3D ip_compute_csum(buf, len);
-		break;
-	case 0:
+	else
 		csum =3D cpu_to_be16(crc_t10dif(buf, len));
-		break;
-	}
+
 	return csum;
 }
=20
--=20
1.8.1.4
