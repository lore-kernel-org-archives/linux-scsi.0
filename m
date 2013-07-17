From: Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH v3] [SCSI] scsi_debug: silence GCC warning
Date: Wed, 17 Jul 2013 09:36:24 +0200
Message-ID: <1374046584.26384.36.camel@x61.thuisdomein>
References: <1373879920.2591.13.camel@x61.thuisdomein>
	 <1373914081.2591.40.camel@x61.thuisdomein>
	 <CAC5umyj2bOyU_z0HVawXL7k4FmF9oHh1yZfHExbKn9ck85RsUQ@mail.gmail.com>
	 <1373988586.17662.4.camel@x61.thuisdomein>
	 <CAC5umyioeYDxFVs5J8fvPmXWOB8k9dp_qCp8Ntcq_d8cKhkS9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:50324 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752569Ab3GQHg0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Jul 2013 03:36:26 -0400
In-Reply-To: <CAC5umyioeYDxFVs5J8fvPmXWOB8k9dp_qCp8Ntcq_d8cKhkS9g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Building scsi_debug.o triggers a GCC warning:
    drivers/scsi/scsi_debug.c: In function =E2=80=98dif_verify=E2=80=99=
:
    drivers/scsi/scsi_debug.c:1755:3: warning: =E2=80=98csum=E2=80=99 m=
ay be used uninitialized in this function [-Wmaybe-uninitialized]

This warning was apparently introduced (in v3.11-rc1) by commit
beb40ea42b ("[SCSI] scsi_debug: reduce duplication between
prot_verify_read and prot_verify_write"). It is a false positive. But i=
f
we transform the switch statement in dif_compute_csum() to a
straightforward if/else statement we supply GCC with enough information
to determine that csum will not be used uninitialized.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) v2: much simpler, and doesn't change any behavior;
   v3: mention commit bebe40ea42b, as Akinobu suggested.

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

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
