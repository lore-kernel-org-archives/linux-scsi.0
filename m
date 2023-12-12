Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="o0ipufjW"
X-Greylist: delayed 63 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 12 Dec 2023 02:32:06 PST
Received: from forward206b.mail.yandex.net (forward206b.mail.yandex.net [178.154.239.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45492A0
	for <linux-scsi@vger.kernel.org>; Tue, 12 Dec 2023 02:32:06 -0800 (PST)
Received: from forward103c.mail.yandex.net (forward103c.mail.yandex.net [IPv6:2a02:6b8:c03:500:1:45:d181:d103])
	by forward206b.mail.yandex.net (Yandex) with ESMTP id 080BB65464
	for <linux-scsi@vger.kernel.org>; Tue, 12 Dec 2023 13:31:34 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-45.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-45.sas.yp-c.yandex.net [IPv6:2a02:6b8:c14:c83:0:640:84f9:0])
	by forward103c.mail.yandex.net (Yandex) with ESMTP id CF2A66090C;
	Tue, 12 Dec 2023 13:31:00 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-45.sas.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id xUf4TSEOr8c0-JMQ4o2Ux;
	Tue, 12 Dec 2023 13:31:00 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1702377060; bh=+trNBK0UUh2iWSA2m2lenpdJrAcqNBI83m7uYcaBhAg=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=o0ipufjWmK/MNu1qm4qa9plmXdfLpmnP/LymPPGyI3dnLV4XtpHDIxlZXGoaHsv2E
	 bn33dycTVmC608BPmC1NKYJYOowD0xFXMJ6jwk7t59OtMC8NRh6CJ9CuyyK4VhdrUT
	 O1P5Qh0fQjznvM+REhT4Hw0Y3WGL4Jl44qXan6t4=
Authentication-Results: mail-nwsmtp-smtp-production-main-45.sas.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Nilesh Javali <njavali@marvell.com>
Cc: Manish Rangankar <mrangankar@marvell.com>,
	linux-scsi@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] scsi: bnx2i: fix fortify warning
Date: Tue, 12 Dec 2023 13:27:55 +0300
Message-ID: <20231212102805.55005-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When compiling with gcc version 14.0.0 20231206 (experimental)
and CONFIG_FORTIFY_SOURCE=y, I've noticed the following warning:

...
In function 'fortify_memcpy_chk',
    inlined from 'bnx2i_process_login_resp.isra' at drivers/scsi/bnx2i/bnx2i_hwi.c:1460:2:
./include/linux/fortify-string.h:588:25: warning: call to '__read_overflow2_field'
declared with attribute warning: detected read beyond size of field (2nd parameter);
maybe use struct_group()? [-Wattribute-warning]
  588 |                         __read_overflow2_field(q_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This call to 'memcpy()' is interpreted as an attempt to copy 6 bytes from
4-byte 'isid_lo' field of 'struct bnx2i_login_response' and thus overread
warning is issued. Since we actually want to copy 'isid_lo' and following
2-byte field at once, use the convenient 'struct_group_attr()' here.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 drivers/scsi/bnx2i/57xx_iscsi_hsi.h | 11 ++++++++---
 drivers/scsi/bnx2i/bnx2i_hwi.c      |  3 ++-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bnx2i/57xx_iscsi_hsi.h b/drivers/scsi/bnx2i/57xx_iscsi_hsi.h
index 19b3a97dbacd..1e0b30de9d9f 100644
--- a/drivers/scsi/bnx2i/57xx_iscsi_hsi.h
+++ b/drivers/scsi/bnx2i/57xx_iscsi_hsi.h
@@ -938,12 +938,17 @@ struct bnx2i_login_response {
 	u16 reserved3;
 #endif
 	u32 stat_sn;
-	u32 isid_lo;
 #if defined(__BIG_ENDIAN)
-	u16 isid_hi;
+	struct_group_attr(isid, __packed,
+		u32 isid_lo;
+		u16 isid_hi;
+	);
 	u16 tsih;
 #elif defined(__LITTLE_ENDIAN)
-	u16 tsih;
+	struct_group_attr(isid, __packed,
+		u32 isid_lo;
+		u16 tsih;
+	);
 	u16 isid_hi;
 #endif
 #if defined(__BIG_ENDIAN)
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 6c864b093ac9..9c4c6a89d270 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1457,7 +1457,8 @@ static int bnx2i_process_login_resp(struct iscsi_session *session,
 	resp_hdr->hlength = 0;
 
 	hton24(resp_hdr->dlength, login->data_length);
-	memcpy(resp_hdr->isid, &login->isid_lo, 6);
+	memcpy(resp_hdr->isid, &login->isid,
+	       sizeof_field(struct bnx2i_login_response, isid));
 	resp_hdr->tsih = cpu_to_be16(login->tsih);
 	resp_hdr->itt = task->hdr->itt;
 	resp_hdr->statsn = cpu_to_be32(login->stat_sn);
-- 
2.43.0

