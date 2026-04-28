Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F6A244685
	for <linux-scsi@vger.kernel.org>; Tue, 28 Apr 2026 20:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777408797; cv=none; b=WBpD7T0b+X1+9KBrfuUtrjM+mGQTAKmXkkbsbU+QqNkRnUFJBazm6a3TsQKV8DGksbGQvtLauFzEg+BUnXq4q3RfBsBYnfUB3QAF+C47Q88pdA+Z06UQuqXva3xbyc2f2EOqg79VnWjiFcXPotvUeEveJ4xPqtaslrdD4A9Z1DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777408797; c=relaxed/simple;
	bh=SgcA+exyHXAqIJdItIDbidRJ+F4zZ7AWpIefSP+VdFs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RD3cIPlhTNRCFES6OEdviexxbntBR1oGhAjkQFqtuinYliClSw5MO4kRUyoa8pTjiwoojXs94XAyB00lpqbU+WD4SHD/TzQiWwQE0EWjrZSkWBgLfU1sfZbc5jvnosMZ/gjzQ76ReQXr6e/Y8zT4cAxvm5asnhBma6Qm58HGcYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LdjgU3IS; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LdjgU3IS"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7dcd9061b1aso6945620a34.2
        for <linux-scsi@vger.kernel.org>; Tue, 28 Apr 2026 13:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777408795; x=1778013595; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=C+si7lg3A2lMf4zRs+JJ+IUUmngjpZnIXbiZMqlnVc4=;
        b=LdjgU3ISBuPX4xuNkqFPNE/ZGrFlz26TQ+LI6Nx1bNm0XvAm0mg/yl4QVA8vhY6QGB
         F6/DwPJSTmtpFKjnVcJV3tTGFt0jJ07/KFsY5RSp0Gv28IYEF3OiNZL4+kTgkXBU5ns3
         lkUcBzlwkU7XdDWQYZa7+nku3QiWhuGYi+PGVv8t4ktXKwWkL/LrEklHr5xbO8YEUoS7
         26SRoxW7/UylYtDJfsUoEN/L9cZft1+Z2dVzOGptU07L2SAlFOTTLugnnNuLs/yZSeeu
         6eNW9hxlHMq5wnTzACYd2HfNYjcwOHsUh1iy3fITgoPVcZ2hvJiYTXJl7kXkD+yDluhe
         EkMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777408795; x=1778013595;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C+si7lg3A2lMf4zRs+JJ+IUUmngjpZnIXbiZMqlnVc4=;
        b=VFsj/U1pgwWHXaLj/doHsWwTst63GGz8csviAqpH5B9128ipu9o4LqIsQul1/FNeIs
         p9BBN3GdqpLQjoQ3qRIyJuKluaibrTWhNLarJLOzu3BclOynunO9Hl1Q9S+eLpeYYdKZ
         ea0u6ZruMZQud+uudMwvu+U2caPMW00wIjMQHVool4RfPThmDU4hZAbV5Djw4pCe9elA
         YribX4LfvvuJY/+gZiJFFUIzWmEIj+LmJDPExn1eAZMCgviMS5bHlwPmWQm/12Pai39L
         hOKitDlXxJgek7pAiw1O21NwklnzSNuv8JLyWEc4gv/FzxeFVm8yuwAAG43wVVVP2VVa
         CmOw==
X-Forwarded-Encrypted: i=1; AFNElJ+r1UyLd4uSK20NGN85kOWPm+1nvZhL1sSJjn7KuUtUlTqlzVbMwOaoxB4oCxQaR9V8W4W3t6cRQ3Ck@vger.kernel.org
X-Gm-Message-State: AOJu0YyVQVLtgIlOfrCsUuWOwDCW9iALXRwpBSA1p6HIb88MRHe04piX
	QvK6NmKz27xAjqJeeGPuHJbHsjPvJ2PC1vvfZZED2ADFv8sAjIMWFu0R
X-Gm-Gg: AeBDiesZOtPu271sj+AIjGEUmYw6h7/ZqOoH0Y/46kQkxN0FfjH78dXEvPXzI9/vbE7
	WsPpeQvGY5ws5DeS6XVCevl0E/mIuT8CfMus96fRABVENO66KhVqeHkH0NBaGwcdMjdO2egnf/6
	bhE/UKvZY09s6lUISgSwRvVmRUuHx5W6nrpZHzkJxxmWu3jYY+8jWmQMla9zQ/eb2/tn/ca1IY6
	wKmrXTc+p+RtzC9Z3IJSNlAbranBmxV/fxb12yPAJgzYGroZGewXGdMfQD8M4Y8ILlc40AzHDSW
	Y97RozxLEIQtbgazA+6QO9kqjRAnIEIQr1C/Z9Do5/R4/7RR/KTY0xSoXysKWJO3+2+g9ce9ZVz
	323nqHlONkV9LgvVkqcgdkuq2Z+4W8Ysc4aNmKuylUkKzIIXod4G7mAkpdiGHymh31RAeikbSYH
	TeBJcMBz0u2aGyez0kZo7/CT2gNUbDdQZ4RHJbze57MbYpA3ssMyc8CA==
X-Received: by 2002:a05:6820:88b:b0:694:6acf:a42d with SMTP id 006d021491bc7-69668490410mr684717eaf.39.1777408795078;
        Tue, 28 Apr 2026 13:39:55 -0700 (PDT)
Received: from localhost.localdomain ([143.166.81.254])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4340e388b97sm233616fac.0.2026.04.28.13.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 13:39:54 -0700 (PDT)
From: Stuart Hayes <stuart.w.hayes@gmail.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Stuart Hayes <stuart.w.hayes@gmail.com>
Subject: [PATCH v2] scsi: target: Allow FUA if no write cache enabled
Date: Tue, 28 Apr 2026 15:39:38 -0500
Message-ID: <20260428203938.9738-1-stuart.w.hayes@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Modify target_check_fua() to allow FUA support for devices with no write
cache enabled.

Without this patch, accesses with FUA set will be rejected, even though
they always go directly to the media when there's no write cache.

This is needed because EDK2 FAT filesystem code sets the FUA bit when
writing, regardless of whether the device advertises support of DPOFUA. If
a UEFI pre-boot write fails, the filesystem can become inaccessible until a
reboot.  This can cause linux installs to iSCSI to be unbootable, because
some systems have firmware that will try to write a file in a
vendor-specific directory under /boot/EFI (such as /boot/EFI/Dell) before
attempting to boot to a UEFI boot entry pointing to a file in the FAT
filesystem.

Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
---
v2: rebased to latest upstream

 drivers/target/target_core_transport.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index fad03a15c969..0e07b224c4d0 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3722,5 +3722,6 @@ target_check_wce(struct se_device *dev)
 bool
 target_check_fua(struct se_device *dev)
 {
-	return target_check_wce(dev) && dev->dev_attrib.emulate_fua_write > 0;
+	/* Allow FUA if there's no write cache */
+	return target_check_wce(dev) ? dev->dev_attrib.emulate_fua_write > 0 : 1;
 }
-- 
2.47.3

