Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B18B27B353
	for <linux-scsi@vger.kernel.org>; Sat, 11 Jul 2026 15:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783782444; cv=none; b=BbAGVGIF+ZcCd9Pp2SULHmRnVGjVFdImxGUTF/WomYIQ0SaoOTCvF10cDm1YIlC68EKHqG8cu1znWEFyf8XtmHVFpm6ymfaezSo/2kSeL9/wJhyfUp6G+Z6OiaFKol7ptuWdkHUCaUIE/F5/+/tubfiA0zF/NfNHeGUod66WWN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783782444; c=relaxed/simple;
	bh=qZKp+z9HirEVTEKlUTkgUjk21u9/4uh/QDsm2GwhDqM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Qyk1wVROnFocWy+OIbFOJLV7gadpKv2zxuRpRSEs58OfYVuEXnRZeCdrDrjxsNLTf1xcHusCkgTcnPSsT/n5Wz+QX63O2C7JJpuu2fSWuqjmRG4VZjBLJAv0bKmUDTYLudo7GSyj/ISnzYeeFB2P5MWa2Bk20Heo9LDTZXN3THY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z1tezw0U; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z1tezw0U"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8ee43b3e5abso13043156d6.3
        for <linux-scsi@vger.kernel.org>; Sat, 11 Jul 2026 08:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783782442; x=1784387242; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SjugYT8ZtISkSYVVGIIzosPwNQGFsZmwG7TxRtXpKf8=;
        b=Z1tezw0UbRvWXINJoNBR70j6cXSiS82PuOmpOyIjDE60chpzw7DXM4FUIQuabOsswe
         CSJSB/R0uQdruN2tRHJ0rAZCfVgNg1LJnJPSo9JO97qPjdtfBr5pPIvznUF+KEHqDdye
         HmmtSOaDgr/3me26R2TdNmbO9922URd7s32w1k2rubafSVxTtkqfXjkjUJb+AUZ62R1g
         V2RRdG4urxrj/mI/zGMWbVo4lf6rzTqRNQoyNSek7o/ini/XHcrjjZ5ScmgDkRPJOyv8
         WawAVELLBtotVXSQgkp2xVe5KBddcbs+JMXEMhYiQKj8niz29++SjDmQLnZeJ0DFd2bP
         7UPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783782442; x=1784387242;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SjugYT8ZtISkSYVVGIIzosPwNQGFsZmwG7TxRtXpKf8=;
        b=Zki6ASXM8QXNz8C1SgD5ceXICCQ1FjUgJoowjbEsTLdZJvJMGOEq8G4p0EYkYz92sI
         H0Qtd7YQD1xCyunDc05Ea+rgUw/thjOP7HG9PWcM8pwNUBvJ+L35YCwi/EX7scO3yOGg
         vMYJeQS86pHWe/URTmM6ki4N8RaSLanRB4pzmpktcHikJYNG6cIOIaeNRe7I+WQhH8hz
         AVgRjym53xbu2KFfuIjPhdj9jiEF/KPtu3VGUueq1cgCuOVZSMNpizi/fTeV8d7oZ+Dl
         zEAjh8AFpaHoR4eaSEYy5LNiLfEYv8HKMM5SUgl+us4emx1O69r+SBI7QzQszYqbChTx
         O8oA==
X-Gm-Message-State: AOJu0YzgKi7pJaJe/wNWe+Rrsdog9qFsCtJKoS3t3vl5Rt8lf0SVTirk
	0gXylJGF9qqcjpLjug6NmUcuxFryOhIRG6Tc9hU6LjCLKLCvVyiQYAjp
X-Gm-Gg: AfdE7cmaJV2/hQ6SclFg63S2HVzEKniVr4dO49kI5WUR0dmYKMHA8od5Xkj2i0NyXOV
	FOlUiPV4WUqBnx0HaZBcPm9vodzhStlVo2h/DBqj5i/yq8Y1VHoHbSKp8v7fGMdTzbM+5KimL1c
	mjatNlTOnJUi1y+wm/xfbGzBL3DTUS5M55XHEEdhUYYrlW6GvVWANt+T9UQzGzpfoxfcSUSWt57
	v9MG49XmUeBeJ+DHb5FbLRu1jFQSDdiPwZWvaQUDcAD8hjRrBAgG4E5YS1m5RkKW7jMepxgAvbv
	UasKu4fLsZNbKRnkVby+bJulVBDGmrBw/I7KYIW12MgnZAaPK50pjFE6F6qvbIkuOno7dcqva0z
	hPpo9veOBCUEwn9ncrjJJK1NbahxK7Waje5y3rSCkdowrfTqg64yUzR3dUvdgtj5qN5WZWB+ISW
	5Jx70aAYacOb2rBnbFOXsSJSxKpE3MLAbseZLI7V/VafAn7f5IhKF7uzmXEx9rfpfuEKth0hy7x
	Smz2xNW4w==
X-Received: by 2002:a05:6214:2489:b0:8fd:6de3:dd78 with SMTP id 6a1803df08f44-90403d510b0mr35964526d6.58.1783782442051;
        Sat, 11 Jul 2026 08:07:22 -0700 (PDT)
Received: from server0 (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9044a771331sm16469916d6.38.2026.07.11.08.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 08:07:21 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] scsi: core: bound the VPD page 0x83 designator walk
Date: Sat, 11 Jul 2026 11:07:18 -0400
Message-ID: <20260711150718.2916641-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

scsi_vpd_lun_id(), scsi_vpd_tpg_id() and sd_get_unique_id() walk the VPD
page 0x83 designator list with a stride of d[3] + 4 taken from the
device-supplied designator length d[3], without checking it against the
bytes remaining in the page. A device, or a compromised virtio/hypervisor
block backend, that returns a page 0x83 whose final designator length runs
past vpd_pg83->len makes the walk read out of bounds of the cached VPD
buffer.

Impact: a malicious or malfunctioning SCSI device, or a compromised
hypervisor block backend, drives an out-of-bounds read of the cached VPD
page 0x83 buffer (KASAN) during LUN-id, target-port-group, or unique-id
computation.

Bound each iteration: stop the walk when fewer than four header bytes
remain and when the designator length exceeds the bytes left in the page,
in all three walkers.

Fixes: 9983bed3907c ("scsi: Add scsi_vpd_lun_id()")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---
 drivers/scsi/scsi_lib.c | 27 ++++++++++++++++++++-------
 drivers/scsi/sd.c       | 10 +++++++++-
 2 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 22e2e3223440d..407440bbf46c1 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3375,6 +3375,7 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
 	u8 cur_id_size = 0;
 	const unsigned char *d, *cur_id_str;
 	const struct scsi_vpd *vpd_pg83;
+	size_t off;
 	int id_size = -EINVAL;
 
 	rcu_read_lock();
@@ -3391,11 +3392,17 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
 	}
 
 	memset(id, 0, id_len);
-	for (d = vpd_pg83->data + 4;
-	     d < vpd_pg83->data + vpd_pg83->len;
-	     d += d[3] + 4) {
-		u8 prio = designator_prio(d);
+	for (off = 4; off < vpd_pg83->len; off += d[3] + 4) {
+		u8 prio;
 
+		if (vpd_pg83->len - off < 4)
+			break;
+
+		d = vpd_pg83->data + off;
+		if (d[3] > vpd_pg83->len - off - 4)
+			break;
+
+		prio = designator_prio(d);
 		if (prio == 0 || cur_id_prio > prio)
 			continue;
 
@@ -3545,6 +3552,7 @@ int scsi_vpd_tpg_id(struct scsi_device *sdev, int *rel_id)
 {
 	const unsigned char *d;
 	const struct scsi_vpd *vpd_pg83;
+	size_t off;
 	int group_id = -EAGAIN, rel_port = -1;
 
 	rcu_read_lock();
@@ -3554,8 +3562,14 @@ int scsi_vpd_tpg_id(struct scsi_device *sdev, int *rel_id)
 		return -ENXIO;
 	}
 
-	d = vpd_pg83->data + 4;
-	while (d < vpd_pg83->data + vpd_pg83->len) {
+	for (off = 4; off < vpd_pg83->len; off += d[3] + 4) {
+		if (vpd_pg83->len - off < 4)
+			break;
+
+		d = vpd_pg83->data + off;
+		if (d[3] > vpd_pg83->len - off - 4)
+			break;
+
 		switch (d[1] & 0xf) {
 		case 0x4:
 			/* Relative target port */
@@ -3568,7 +3582,6 @@ int scsi_vpd_tpg_id(struct scsi_device *sdev, int *rel_id)
 		default:
 			break;
 		}
-		d += d[3] + 4;
 	}
 	rcu_read_unlock();
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 599e75f333343..5b8fa74052f2e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1949,6 +1949,7 @@ static int sd_get_unique_id(struct gendisk *disk, u8 id[16],
 	struct scsi_device *sdev = scsi_disk(disk)->device;
 	const struct scsi_vpd *vpd;
 	const unsigned char *d;
+	size_t off;
 	int ret = -ENXIO, len;
 
 	rcu_read_lock();
@@ -1957,7 +1958,14 @@ static int sd_get_unique_id(struct gendisk *disk, u8 id[16],
 		goto out_unlock;
 
 	ret = -EINVAL;
-	for (d = vpd->data + 4; d < vpd->data + vpd->len; d += d[3] + 4) {
+	for (off = 4; off < vpd->len; off += d[3] + 4) {
+		if (vpd->len - off < 4)
+			break;
+
+		d = vpd->data + off;
+		if (d[3] > vpd->len - off - 4)
+			break;
+
 		/* we only care about designators with LU association */
 		if (((d[1] >> 4) & 0x3) != 0x00)
 			continue;
-- 
2.53.0

