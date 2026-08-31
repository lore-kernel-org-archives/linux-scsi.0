Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8DC443A83
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 17:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788198544; cv=none; b=KWjZ4jTY611Mst8x/K113iuNKV61Obe4v/Odat3HdyGRV8z9L22PUWRACFVZkEAplbBo6ReWhMknEZ1dck91hRPoWIcalmQVaxxNtJZPJKdgkBww6K8vOFnv9fyndgZp43S/iiTXlnQQvmKsg0QJxAU5i4cLBky4LsYB70KQmvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788198544; c=relaxed/simple;
	bh=lW5nz/CKf+kLuByUir5AnmHmQXjaO2jR7R0h7r1qm4I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NMoOfhGhl4PUbhaT6tAiXvkL3rg620OAfzW/jMPQ9FpWiJQD6leCdh/4yOFHXXrh/zx4shHQufKNM/6rK8Y2qpGxQvC39tSR1geklI4J58+lEKq8p6l7gKPk0Cdjl27QClEkGAK6dwZFlZgMFcL3g3UJ+lK6P5Bm4cSALrBevHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=0wKbh4Fa; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="0wKbh4Fa"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hYc1M40rtz1XM0p3;
	Mon, 31 Aug 2026 17:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1788198518; x=1790790519; bh=1W1TrPaEBL4qztxStYX0WrNJk5v7wVxzoaw
	QsbcRDns=; b=0wKbh4FaC38jZlWQJT68VPFSQ5DGdQGdkjBS8Sf9U6n6DFS7tXZ
	0WXvosxX4axfHVuz+w6fnvurPgKv6HvpVCJ8Pmy08ZGiAnjUVL16Oa69QExFR3CY
	SoQwkU8KgQUPBDEtki2Spiu4MAftKiDRUb8ETeUOT0h1KmF6kOAGgBsKa+qMo+EM
	cqEptwF0neL8mJnIqvtzGle7NW143B+WFGgFRDa5OIFGK8z2cKEsOem0fhTVT4RR
	BPbfHoLCswe1dexNIh3WANQYXzWr3WmGdCI8YFZW/wGi2pD+3D4IMNg6sLBci4GD
	08WKbNNjrNnhJ6qNVVlzTNc/5EAadLLhnEA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id pkPsQ8dd9mUH; Mon, 31 Aug 2026 17:48:38 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hYc0x5Nk1z1XM0vy;
	Mon, 31 Aug 2026 17:48:33 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Lindar Liu <lindar_liu@usish.com>,
	Kevin Ao <aoqingyun@usish.com>,
	Tom Peng <tom_peng@usish.com>,
	Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>,
	Hannes Reinecke <hare@suse.de>,
	Anand Kumar S <AnandKumar.Santhanam@pmcs.com>
Subject: [PATCH] scsi: pm8001: Fix SATA FIS offset in struct hw_event_resp
Date: Mon, 31 Aug 2026 10:48:21 -0700
Message-ID: <31963d53810f42970447e78ef46030ab13d2e91f.1788198434.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

In struct hw_event_resp, sas_identify was defined using struct
sas_identify_frame, which is 32 bytes long because it includes a 4-byte
CRC field. However, PM8001 and PM80xx hardware does not send the CRC in
the event response frame, providing only the 28-byte identify payload.

Because sas_identify had a size of 32 bytes, the following sata_fis
member was located at byte offset 44 instead of the actual hardware
offset 40. In hw_event_sata_phy_up(), this discrepancy was worked
around with negative pointer arithmetic: ((u8 *)&pPayload->sata_fis - 4).
This triggers a compiler error under Clang with -Wstringop-overread:

  error: 'memcpy' reading 20 bytes from a region of size 0
  [-Werror,-Wstringop-overread]
          memcpy(phy->frame_rcvd, ((u8 *)&pPayload->sata_fis - 4),

Move struct sas_identify_frame_local (28 bytes) into pm8001_defs.h,
and update struct hw_event_resp in both pm8001_hwi.h and pm80xx_hwi.h
to use struct sas_identify_frame_local followed by sata_fis and a 4-byte
padding word. This correctly aligns sata_fis at byte offset 40 while
maintaining the 64-byte total payload size.

Update hw_event_sata_phy_up() in pm8001_hwi.c and pm80xx_hwi.c to copy
directly from &pPayload->sata_fis.

Compile-tested only. Both the patch and its description have been generat=
ed
by Gemini.

Fixes: dbf9bfe61571 ("[SCSI] pm8001: add SAS/SATA HBA driver")
Fixes: f5860992db55 ("[SCSI] pm80xx: Added SPCv/ve specific hardware func=
tionalities and relevant changes in common files")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/pm8001/pm8001_defs.h |  98 +++++++++++++++++++++++++++++
 drivers/scsi/pm8001/pm8001_hwi.c  |   2 +-
 drivers/scsi/pm8001/pm8001_hwi.h  |   4 +-
 drivers/scsi/pm8001/pm80xx_hwi.c  |   2 +-
 drivers/scsi/pm8001/pm80xx_hwi.h  | 100 +-----------------------------
 5 files changed, 106 insertions(+), 100 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_defs.h b/drivers/scsi/pm8001/pm80=
01_defs.h
index 4e19d61dffbb..a9605ca317f3 100644
--- a/drivers/scsi/pm8001/pm8001_defs.h
+++ b/drivers/scsi/pm8001/pm8001_defs.h
@@ -41,6 +41,104 @@
 #ifndef _PM8001_DEFS_H_
 #define _PM8001_DEFS_H_
=20
+#include <scsi/sas.h>
+
+#ifdef __LITTLE_ENDIAN_BITFIELD
+struct sas_identify_frame_local {
+	/* Byte 0 */
+	u8  frame_type:4;
+	u8  dev_type:3;
+	u8  _un0:1;
+
+	/* Byte 1 */
+	u8  _un1;
+
+	/* Byte 2 */
+	union {
+		struct {
+			u8  _un20:1;
+			u8  smp_iport:1;
+			u8  stp_iport:1;
+			u8  ssp_iport:1;
+			u8  _un247:4;
+		};
+		u8 initiator_bits;
+	};
+
+	/* Byte 3 */
+	union {
+		struct {
+			u8  _un30:1;
+			u8 smp_tport:1;
+			u8 stp_tport:1;
+			u8 ssp_tport:1;
+			u8 _un347:4;
+		};
+		u8 target_bits;
+	};
+
+	/* Byte 4 - 11 */
+	u8 _un4_11[8];
+
+	/* Byte 12 - 19 */
+	u8 sas_addr[SAS_ADDR_SIZE];
+
+	/* Byte 20 */
+	u8 phy_id;
+
+	u8 _un21_27[7];
+
+} __packed;
+
+#elif defined(__BIG_ENDIAN_BITFIELD)
+struct sas_identify_frame_local {
+	/* Byte 0 */
+	u8  _un0:1;
+	u8  dev_type:3;
+	u8  frame_type:4;
+
+	/* Byte 1 */
+	u8  _un1;
+
+	/* Byte 2 */
+	union {
+		struct {
+			u8  _un247:4;
+			u8  ssp_iport:1;
+			u8  stp_iport:1;
+			u8  smp_iport:1;
+			u8  _un20:1;
+		};
+		u8 initiator_bits;
+	};
+
+	/* Byte 3 */
+	union {
+		struct {
+			u8 _un347:4;
+			u8 ssp_tport:1;
+			u8 stp_tport:1;
+			u8 smp_tport:1;
+			u8 _un30:1;
+		};
+		u8 target_bits;
+	};
+
+	/* Byte 4 - 11 */
+	u8 _un4_11[8];
+
+	/* Byte 12 - 19 */
+	u8 sas_addr[SAS_ADDR_SIZE];
+
+	/* Byte 20 */
+	u8 phy_id;
+
+	u8 _un21_27[7];
+} __packed;
+#else
+#error "Bitfield order not defined!"
+#endif
+
 enum chip_flavors {
 	chip_8001,
 	chip_8008,
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
index fff8d877abb9..55a01e533fd1 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3208,7 +3208,7 @@ hw_event_sata_phy_up(struct pm8001_hba_info *pm8001=
_ha, void *piomb)
 	phy->sas_phy.oob_mode =3D SATA_OOB_MODE;
 	sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE, GFP_ATOMIC);
 	spin_lock_irqsave(&phy->sas_phy.frame_rcvd_lock, flags);
-	memcpy(phy->frame_rcvd, ((u8 *)&pPayload->sata_fis - 4),
+	memcpy(phy->frame_rcvd, &pPayload->sata_fis,
 		sizeof(struct dev_to_host_fis));
 	phy->frame_rcvd_size =3D sizeof(struct dev_to_host_fis);
 	phy->identify.target_port_protocols =3D SAS_PROTOCOL_SATA;
diff --git a/drivers/scsi/pm8001/pm8001_hwi.h b/drivers/scsi/pm8001/pm800=
1_hwi.h
index f1ce8df082b0..a21b1b37a8ea 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.h
+++ b/drivers/scsi/pm8001/pm8001_hwi.h
@@ -42,6 +42,7 @@
=20
 #include <linux/types.h>
 #include <scsi/libsas.h>
+#include "pm8001_defs.h"
=20
=20
 /* for Request Opcode of IOMB */
@@ -229,8 +230,9 @@ struct hw_event_resp {
 	__le32	lr_evt_status_phyid_portid;
 	__le32	evt_param;
 	__le32	npip_portstate;
-	struct sas_identify_frame	sas_identify;
+	struct sas_identify_frame_local	sas_identify;
 	struct dev_to_host_fis	sata_fis;
+	u32	_r_a;
 } __attribute__((packed, aligned(4)));
=20
=20
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index 2c0fa7ab33d2..659dbd603a03 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3296,7 +3296,7 @@ hw_event_sata_phy_up(struct pm8001_hba_info *pm8001=
_ha, void *piomb)
 	phy->sas_phy.oob_mode =3D SATA_OOB_MODE;
 	sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE, GFP_ATOMIC);
 	spin_lock_irqsave(&phy->sas_phy.frame_rcvd_lock, flags);
-	memcpy(phy->frame_rcvd, ((u8 *)&pPayload->sata_fis - 4),
+	memcpy(phy->frame_rcvd, &pPayload->sata_fis,
 		sizeof(struct dev_to_host_fis));
 	phy->frame_rcvd_size =3D sizeof(struct dev_to_host_fis);
 	phy->identify.target_port_protocols =3D SAS_PROTOCOL_SATA;
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80x=
x_hwi.h
index d8a63b7fed6a..d6796ba40df9 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -43,6 +43,7 @@
=20
 #include <linux/types.h>
 #include <scsi/libsas.h>
+#include "pm8001_defs.h"
=20
 /* for Request Opcode of IOMB */
 #define OPC_INB_ECHO				1	/* 0x000 */
@@ -236,102 +237,6 @@
 /* Port recovery timeout, 10000 ms for PM8006 controller */
 #define CHIP_8006_PORT_RECOVERY_TIMEOUT 0x640000
=20
-#ifdef __LITTLE_ENDIAN_BITFIELD
-struct sas_identify_frame_local {
-	/* Byte 0 */
-	u8  frame_type:4;
-	u8  dev_type:3;
-	u8  _un0:1;
-
-	/* Byte 1 */
-	u8  _un1;
-
-	/* Byte 2 */
-	union {
-		struct {
-			u8  _un20:1;
-			u8  smp_iport:1;
-			u8  stp_iport:1;
-			u8  ssp_iport:1;
-			u8  _un247:4;
-		};
-		u8 initiator_bits;
-	};
-
-	/* Byte 3 */
-	union {
-		struct {
-			u8  _un30:1;
-			u8 smp_tport:1;
-			u8 stp_tport:1;
-			u8 ssp_tport:1;
-			u8 _un347:4;
-		};
-		u8 target_bits;
-	};
-
-	/* Byte 4 - 11 */
-	u8 _un4_11[8];
-
-	/* Byte 12 - 19 */
-	u8 sas_addr[SAS_ADDR_SIZE];
-
-	/* Byte 20 */
-	u8 phy_id;
-
-	u8 _un21_27[7];
-
-} __packed;
-
-#elif defined(__BIG_ENDIAN_BITFIELD)
-struct sas_identify_frame_local {
-	/* Byte 0 */
-	u8  _un0:1;
-	u8  dev_type:3;
-	u8  frame_type:4;
-
-	/* Byte 1 */
-	u8  _un1;
-
-	/* Byte 2 */
-	union {
-		struct {
-			u8  _un247:4;
-			u8  ssp_iport:1;
-			u8  stp_iport:1;
-			u8  smp_iport:1;
-			u8  _un20:1;
-		};
-		u8 initiator_bits;
-	};
-
-	/* Byte 3 */
-	union {
-		struct {
-			u8 _un347:4;
-			u8 ssp_tport:1;
-			u8 stp_tport:1;
-			u8 smp_tport:1;
-			u8 _un30:1;
-		};
-		u8 target_bits;
-	};
-
-	/* Byte 4 - 11 */
-	u8 _un4_11[8];
-
-	/* Byte 12 - 19 */
-	u8 sas_addr[SAS_ADDR_SIZE];
-
-	/* Byte 20 */
-	u8 phy_id;
-
-	u8 _un21_27[7];
-} __packed;
-#else
-#error "Bitfield order not defined!"
-#endif
-
 struct mpi_msg_hdr {
 	__le32	header;	/* Bits [11:0] - Message operation code */
 	/* Bits [15:12] - Message Category */
@@ -427,8 +332,9 @@ struct hw_event_resp {
 	__le32	lr_status_evt_portid;
 	__le32	evt_param;
 	__le32	phyid_npip_portstate;
-	struct sas_identify_frame	sas_identify;
+	struct sas_identify_frame_local	sas_identify;
 	struct dev_to_host_fis	sata_fis;
+	u32	_r_a;
 } __attribute__((packed, aligned(4)));
=20
 /*
