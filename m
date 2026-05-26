Received: from mail-lf1-f74.google.com (mail-lf1-f74.google.com [209.85.167.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F3C3FFAB9
	for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 14:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779805792; cv=none; b=ubjX3PW81UQ2d8weAHbYz+0hU8Nx1Su6HHYsXh/hnEteu47J6/GbIU7EeL4a20kmGPeoWCm+tRQXrAsF7LAR2bSEB3o1TJIDiWqFOEKqq+GU2DNoK4DQR9IqeY5e59lxLeiU+fbiI1VuRNxesTKINiMOujRIOFJS7YpCuFHjzlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779805792; c=relaxed/simple;
	bh=2DSBhxHo6ohfJ1agRy9QlK58xQlyhvZcVHLLoZrDDSA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oXHh6L1rUUxd5sBt/CuIHopJ0/qRbShTfyac9jRmzeUvvw0n6OmGwj1mhCrxRxL6qRYTErUNh//8Xw+86XPln3QkheW6a9Afg8MQpAMaHpaym6y5D/ZaC0QH/T4Hbdm4CRtXk3hknTsCYCJcH6/qA2qZ7v3+jnIbM5gT1kia5FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rnj.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UNlHhNZz; arc=none smtp.client-ip=209.85.167.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rnj.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UNlHhNZz"
Received: by mail-lf1-f74.google.com with SMTP id 2adb3069b0e04-5a8704dc495so5668529e87.3
        for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 07:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779805788; x=1780410588; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T4UbM0pmtE8rclzkFOKgkg1jhZu8iQJeEXlQMwnCTfg=;
        b=UNlHhNZzBBa10yuCt0vtf+E2Z1M2KUXZnXGV9948d0Mvy6yxPklHi8/ZswzbNKJxug
         nH7y6kYASt+A2XAkjjCKWdgROqL89tnoEGqoy4ZYa/6avSb/xdHNC96dQaxd78qMdd9L
         5lxfRCHqN+rtxknPpXUFhfwgKNRfyDkf2zhdZOPZpQHFGVuU+xg41KEK5cIni0igi+y7
         kQ9U2It7z7kjYqoxVaeW9No6TsTVHTN+AN5x6skQ3FedC2Gf3kWOxAVd0B46yLfSrGo/
         8uQHBEshlqOOJZ6dWcpRX4TJFkDERgykuLrfyWhwq2qQvDVTf8gLrKNbvHl1ztzWgxGB
         X2gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779805788; x=1780410588;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T4UbM0pmtE8rclzkFOKgkg1jhZu8iQJeEXlQMwnCTfg=;
        b=jKiHuKAQziRBoGlxsVipeDFPmfFVo00b93iRepU0eyixag+fcOmWfFLr87IBk5CdEt
         pzUrojLCMKhlE5dUxjO1jPkKZNPcFkufGzxmYgG0XIXOzHox8DN46L1sQKxjuAPRE8Jx
         dGkKWrBKzjFyROpjENO8JUYa+DJsc/U3aeZKVgu+po2hb2K1cez/8+SboghUidppLAeP
         STKgbY5Ag9gbRsQ5sAClsojimOr70dQamnmPN1IbXVv7P18qBofPQlmuFk5zUW9+OFnl
         2gnFWqjxBi633qXlh6Nz9DTD4f/SIOcEXnwxD6NK8n6+j6pTYDwoCxIlrGHHWybxVVge
         7U9Q==
X-Forwarded-Encrypted: i=1; AFNElJ83t+DhmyEvNYmMQXkhBb3HgYf2Ru6zser+rPEvcmh/OOZPzGCyfypZy6gQQjU+8Hlow+isBxgp862I@vger.kernel.org
X-Gm-Message-State: AOJu0YzcLqlLaZs4QSU+OqpvHK3fyre2+8Lrr9k0LlliTro8IzzTTHXT
	MHH51PtZ6oQsIpGNK5DE2kPS+0dlmr1juE5l9avS74/Ya9xPQATCMY1qxLY41oaZnRH7Ag==
X-Received: from ljxb4.prod.google.com ([2002:a05:651c:a084:b0:394:4549:7323])
 (user=rnj job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6512:3408:b0:5a8:74ac:cf7e
 with SMTP id 2adb3069b0e04-5aa32373293mr6233942e87.24.1779805787628; Tue, 26
 May 2026 07:29:47 -0700 (PDT)
Date: Tue, 26 May 2026 14:29:43 +0000
In-Reply-To: <20260526-fortify_pm80-v2-0-359b743eb97a@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260526-fortify_pm80-v2-0-359b743eb97a@google.com>
X-Developer-Key: i=rnj@google.com; a=ed25519; pk=QwUkB1OONd7dk9zV4pLRQRehoWHHsLcRZD2QcswqHTc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779805783; l=6025;
 i=rnj@google.com; s=20260515; h=from:subject:message-id; bh=2DSBhxHo6ohfJ1agRy9QlK58xQlyhvZcVHLLoZrDDSA=;
 b=+ZHcfB7RAQSUDax4PveJEUhJ1V0FJhzw7Zh6xd4eb16O4bW8krB3GpHqXsskdwZoq3V1ik+4i 9FPpMC3GSBFCEiizrxOlbEyREmhozxQg0sXAD43pHOBjfPETgC/n7KX
X-Mailer: b4 0.14.3
Message-ID: <20260526-fortify_pm80-v2-1-359b743eb97a@google.com>
Subject: [PATCH v2 1/2] scsi: libsas: Define sas_identify_frame_local via struct_group
From: Ronja Meyer <rnj@google.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Tom Peng <tom_peng@usish.com>, 
	Kevin Ao <aoqingyun@usish.com>, Lindar Liu <lindar_liu@usish.com>, 
	James Bottomley <James.Bottomley@suse.de>
Cc: jack wang <jack_wang@usish.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Ronja Meyer <rnj@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

The pm80 drivers both need a variant of the sas_identify_frame struct
without the CRC struct member. The pm80xx driver previously duplicated
the struct, omitting this field, to sas_identify_frame_local in:
commit 5990fd57ebea ("scsi: pm80xx: redefine sas_identify_frame structure")

The pm8001 driver also needs the _local variant. Instead of duplicating
the struct again, let's define it as a struct group inside the main
sas_identify_frame struct and remove the duplicate in the pm80xx driver.

Sending to stable, as this change is required for the fortify-panic fix
later in this chain to apply cleanly.

Cc: stable@vger.kernel.org
Fixes: dbf9bfe61571 ("[SCSI] pm8001: add SAS/SATA HBA driver")
Signed-off-by: Ronja Meyer <rnj@google.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.h |  96 --------------------------
 include/scsi/sas.h               | 144 ++++++++++++++++++++-------------------
 2 files changed, 74 insertions(+), 166 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
index d8a63b7fed6a..2fa54b901a2e 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -236,102 +236,6 @@
 /* Port recovery timeout, 10000 ms for PM8006 controller */
 #define CHIP_8006_PORT_RECOVERY_TIMEOUT 0x640000
 
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
diff --git a/include/scsi/sas.h b/include/scsi/sas.h
index 71b749bed3b0..90f3081a3270 100644
--- a/include/scsi/sas.h
+++ b/include/scsi/sas.h
@@ -252,48 +252,50 @@ struct host_to_dev_fis {
  */
 #ifdef __LITTLE_ENDIAN_BITFIELD
 struct sas_identify_frame {
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
+	__struct_group(sas_identify_frame_local, payload, __packed,
+		/* Byte 0 */
+		u8  frame_type:4;
+		u8  dev_type:3;
+		u8  _un0:1;
+
+		/* Byte 1 */
+		u8  _un1;
+
+		/* Byte 2 */
+		union {
+			struct {
+				u8  _un20:1;
+				u8  smp_iport:1;
+				u8  stp_iport:1;
+				u8  ssp_iport:1;
+				u8  _un247:4;
+			};
+			u8 initiator_bits;
 		};
-		u8 initiator_bits;
-	};
 
-	/* Byte 3 */
-	union {
-		struct {
-			u8  _un30:1;
-			u8 smp_tport:1;
-			u8 stp_tport:1;
-			u8 ssp_tport:1;
-			u8 _un347:4;
+		/* Byte 3 */
+		union {
+			struct {
+				u8  _un30:1;
+				u8 smp_tport:1;
+				u8 stp_tport:1;
+				u8 ssp_tport:1;
+				u8 _un347:4;
+			};
+			u8 target_bits;
 		};
-		u8 target_bits;
-	};
 
-	/* Byte 4 - 11 */
-	u8 _un4_11[8];
+		/* Byte 4 - 11 */
+		u8 _un4_11[8];
 
-	/* Byte 12 - 19 */
-	u8 sas_addr[SAS_ADDR_SIZE];
+		/* Byte 12 - 19 */
+		u8 sas_addr[SAS_ADDR_SIZE];
 
-	/* Byte 20 */
-	u8 phy_id;
+		/* Byte 20 */
+		u8 phy_id;
 
-	u8 _un21_27[7];
+		u8 _un21_27[7];
+	);
 
 	__be32 crc;
 } __attribute__ ((packed));
@@ -473,48 +475,50 @@ struct report_phy_sata_resp {
 
 #elif defined(__BIG_ENDIAN_BITFIELD)
 struct sas_identify_frame {
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
+	__struct_group(sas_identify_frame_local, payload, __packed,
+		/* Byte 0 */
+		u8  _un0:1;
+		u8  dev_type:3;
+		u8  frame_type:4;
+
+		/* Byte 1 */
+		u8  _un1;
+
+		/* Byte 2 */
+		union {
+			struct {
+				u8  _un247:4;
+				u8  ssp_iport:1;
+				u8  stp_iport:1;
+				u8  smp_iport:1;
+				u8  _un20:1;
+			};
+			u8 initiator_bits;
 		};
-		u8 initiator_bits;
-	};
 
-	/* Byte 3 */
-	union {
-		struct {
-			u8 _un347:4;
-			u8 ssp_tport:1;
-			u8 stp_tport:1;
-			u8 smp_tport:1;
-			u8 _un30:1;
+		/* Byte 3 */
+		union {
+			struct {
+				u8 _un347:4;
+				u8 ssp_tport:1;
+				u8 stp_tport:1;
+				u8 smp_tport:1;
+				u8 _un30:1;
+			};
+			u8 target_bits;
 		};
-		u8 target_bits;
-	};
 
-	/* Byte 4 - 11 */
-	u8 _un4_11[8];
+		/* Byte 4 - 11 */
+		u8 _un4_11[8];
 
-	/* Byte 12 - 19 */
-	u8 sas_addr[SAS_ADDR_SIZE];
+		/* Byte 12 - 19 */
+		u8 sas_addr[SAS_ADDR_SIZE];
 
-	/* Byte 20 */
-	u8 phy_id;
+		/* Byte 20 */
+		u8 phy_id;
 
-	u8 _un21_27[7];
+		u8 _un21_27[7];
+	);
 
 	__be32 crc;
 } __attribute__ ((packed));

-- 
2.54.0.746.g67dd491aae-goog

