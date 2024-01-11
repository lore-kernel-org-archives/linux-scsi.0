Received: from forward204a.mail.yandex.net (forward204a.mail.yandex.net [178.154.239.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD393C097
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2024 14:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="V4jfWVC7"
Received: from forward100a.mail.yandex.net (forward100a.mail.yandex.net [IPv6:2a02:6b8:c0e:500:1:45:d181:d100])
	by forward204a.mail.yandex.net (Yandex) with ESMTPS id EDC7F65051
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2024 17:12:54 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-54.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-54.vla.yp-c.yandex.net [IPv6:2a02:6b8:c18:3d80:0:640:1395:0])
	by forward100a.mail.yandex.net (Yandex) with ESMTP id 92C4746C9F;
	Thu, 11 Jan 2024 17:12:46 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-54.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id jCk1Pw8qGOs0-jmmb9P72;
	Thu, 11 Jan 2024 17:12:46 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1704982366; bh=mOSBv5IXuEhkq3SRKW6tg2z6rxHz74YIXQsbRyGello=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=V4jfWVC7P2vMKwDlgoPIdMRi6mwmKN6j91UafuEMSZobeTfZvPxbjAGf43AegZsRU
	 xcAeLPV9x1xKR1A8LhEMBQzlnfr/HXkjO1fWcMg+0z/OmgHKhTH/nH7bbL2BTbPAsc
	 dy4HIJwMbyTc/OYXU7Mx/ysyScBOTnKYCdZwPMMc=
Authentication-Results: mail-nwsmtp-smtp-production-main-54.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Nilesh Javali <njavali@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>,
	linux-scsi@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] scsi: qla2xxx: fix fortify warning
Date: Thu, 11 Jan 2024 17:11:40 +0300
Message-ID: <20240111141145.122306-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When compiling with gcc version 14.0.0 20240108 (experimental) and
CONFIG_FORTIFY_SOURCE=y, I've noticed the following warning:

In function 'fortify_memcpy_chk',
    inlined from 'qla81xx_nvram_config' at drivers/scsi/qla2xxx/qla_init.c:9190:2:
./include/linux/fortify-string.h:588:25: warning: call to '__read_overflow2_field'
declared with attribute warning: detected read beyond size of field (2nd parameter);
maybe use struct_group()? [-Wattribute-warning]
  588 |                         __read_overflow2_field(q_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This call to 'memcpy()' is interpreted as an attempt to copy
'sizeof(struct ex_init_cb_81xx)' bytes from 2-byte 'ex_version'
field of 'struct nvram_81xx' and thus overread warning is issued.
Since we actually want to copy the whole control block in 81xx
format, use the convenient 'struct_group' for the latter.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 drivers/scsi/qla2xxx/qla_fw.h   | 18 ++++++++++--------
 drivers/scsi/qla2xxx/qla_init.c |  2 +-
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index f307beed9d29..9d5031827082 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1942,14 +1942,16 @@ struct nvram_81xx {
 	__le16	reserved_6[24];
 
 	/* Offset 128. */
-	__le16	ex_version;
-	uint8_t prio_fcf_matching_flags;
-	uint8_t reserved_6_1[3];
-	__le16	pri_fcf_vlan_id;
-	uint8_t pri_fcf_fabric_name[8];
-	__le16	reserved_6_2[7];
-	uint8_t spma_mac_addr[6];
-	__le16	reserved_6_3[14];
+	struct_group(ex_cb_81xx,
+		__le16	ex_version;
+		uint8_t prio_fcf_matching_flags;
+		uint8_t reserved_6_1[3];
+		__le16	pri_fcf_vlan_id;
+		uint8_t pri_fcf_fabric_name[8];
+		__le16	reserved_6_2[7];
+		uint8_t spma_mac_addr[6];
+		__le16	reserved_6_3[14];
+	);
 
 	/* Offset 192. */
 	uint8_t min_supported_speed;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index a314cfc5b263..c20acdd634ea 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -9187,7 +9187,7 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 	}
 
 	/* Use extended-initialization control block. */
-	memcpy(ha->ex_init_cb, &nv->ex_version, sizeof(*ha->ex_init_cb));
+	memcpy(ha->ex_init_cb, &nv->ex_cb_81xx, sizeof(*ha->ex_init_cb));
 	ha->frame_payload_size = le16_to_cpu(icb->frame_payload_size);
 	/*
 	 * Setup driver NVRAM options.
-- 
2.43.0

