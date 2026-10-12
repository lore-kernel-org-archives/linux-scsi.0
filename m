Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BA4418348
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 12:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791806464; cv=none; b=rM0u/KpiQQKhnSAhxM/36MY0rTjNwiKpvqHt1azrhn7R3WbMWHiiZlknoHljUkr9h7W5H3LhguScRu6OwYeZequxkz6DVQbu1hAadXK57/U4njGaMF7p1jG0teyfZn7CxyCcyTs8iGQi0LlF2DRoxExpXS/GMlc99ZGJ+ohAZGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791806464; c=relaxed/simple;
	bh=bpKLm+RbzFiB+bE/8I3pbOaOeaDV6hPfYhyAv5Hqq1I=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=rQ0GI1h+1LN0DEtcmedab2fQJ+tamAemjQ54oUAFuy9Vmy8wbg+oWyWPtU+p9YSGFu9JaieKaTh0MPdY8D1OFi3J2M8q67UfhEFOJs0k41uGpW/6AVgsu3Xw9a+N5w+Oa0ieCo6C1mNidU6YB1mm3QRDArfT/UECi50IE3H28c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OSjMYYBe; arc=none smtp.client-ip=209.85.215.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OSjMYYBe"
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb11535e6a1so929148a12.0
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 05:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791806462; x=1792411262; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xgmqd2G/3foFRFZCjELywxiq8w/o9QCKNyLCBypUvzE=;
        b=OSjMYYBexOo3DYBUDlkyLyINC/AtnX+Z84vddtYdUh/l05GDLRkEmNKYOhv5sdzei1
         NZFb3Dw2EnNZAZBw0qwDsJ+eIjBkPD/2L5EXrPU7H0BStAXWedKd4YHjq6gz5jbznpT8
         6ZOK9qI3fmNgwVl9GGw6mWQOFqG3HfNhS+9HSgwWmW5TTuimS51nYphhsozc7cOMR5QN
         XObMJwZ4nyrmlW9DLR6TPJZdUG8Fy5ljIon8+N5rQG/3MeAW0/59b7D1LSD0/0gkL7yf
         Yykoe0yesHviawTiipDEETtMafGpCdwmPBhlFH0C5pml6ciagTCmieF3qZEDUSgWej6N
         v/nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791806462; x=1792411262;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xgmqd2G/3foFRFZCjELywxiq8w/o9QCKNyLCBypUvzE=;
        b=LRHP+shgQJ4lo+mzskiCgQvc6obcsfYaZOGN4R+Irk7F2OQtrxHllnm0seBknRSI/5
         6T+xefHyQyD+ZAWd8bxoBaTqMyiWPCWgJHDz5VQtllkhWlsq97lfshtikjsciPAGDJJK
         2fWhTsq2P68JFxAhVrtWigQbJcg1FtXdFTYEAhegj40fdh4EuixmWPYdlg1jJyLn8t3s
         m9dPuTDZa+//IsjqEp+HZiezRAJakBv9vrERDkMnBK1sOdG9EhdSmsVV4ds12xAe4VFL
         1c+mvUlUNyGMe2Wym+Ews1kY0Unh36xVjMVhK/sxDucF5QdfFDHsdhhvCBfjCuHvUP4E
         U0Qw==
X-Forwarded-Encrypted: i=1; AKwUvByl6YhfaLbRU+bccJCYnif38tHO42HTJmn/JZhAcoQ5U2DQCyVtj2ruk5RcGZJAng7XZMLZRJDHc2xs@vger.kernel.org
X-Gm-Message-State: AFq9FYI0Y64vpI70THrpsnK5i9fOczpUjdv5XMuKpQLnYOpHS9XDs9x+
	z/TMN/WJmKw3NKz4VYCfiJn5nHQJegnZAjJ5xsy8TEkRAO+7TUQceimYFWrzVjv9YFEWP21mre7
	hyuozDoWnOu0AraShEYFWzQ==
X-Received: from pglk23-n2.prod.google.com ([2002:a05:6a02:6b97:20b0:ccf:f961:1634])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:7d0b:b0:3d1:c99f:efbf with SMTP id adf61e73a8af0-3e16be892f4mr7988010637.14.1791806462062;
 Mon, 12 Oct 2026 05:01:02 -0700 (PDT)
Date: Mon, 12 Oct 2026 20:00:59 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261012120059.1371653-1-stanleyjhu@google.com>
Subject: [PATCH v2] scsi: ufs: docs: Describe how to test with QEMU
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K. Petersen" <mkp@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Jonathan Corbet <corbet@lwn.net>
Cc: Bart Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeuk Kim <jeuk20.kim@samsung.com>, Bean Huo <beanhuo@iokpp.de>, linux-scsi@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

QEMU emulates a UFS host controller and logical units, but the kernel
tree does not mention it, so developers without UFS hardware have no
documented way to exercise the UFS core.

Add a short section with the required kernel options, an example QEMU
command line, and what the emulation does not cover.

Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
Changes in v2:
- State the minimum QEMU versions for ufs and mcq=on (Bean Huo)
- Mark /dev/sda as an example (Bean Huo)
- Say the emulation accepts but does not model the link startup,
  hibernate, DME and power mode UIC commands, and that DME and power
  mode need QEMU 11.1 (Bean Huo)

v1: https://lore.kernel.org/all/20261011103319.820657-1-stanleyjhu@google.com/

 Documentation/scsi/ufs.rst | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/Documentation/scsi/ufs.rst b/Documentation/scsi/ufs.rst
index a7b2b2ed1c3a..06f1b9b4e8dd 100644
--- a/Documentation/scsi/ufs.rst
+++ b/Documentation/scsi/ufs.rst
@@ -19,6 +19,7 @@ Universal Flash Storage
      3.4 SCSI Error handling
    4. BSG Support
    5. UFS Reference Clock Frequency configuration
+   6. Testing with QEMU
 
 
 1. Overview
@@ -208,3 +209,40 @@ the UFS specification. UFS subsystem will attempt to read the value when
 executing common controller initialization. If the value is available, UFS
 subsystem will ensure the bRefClkFreq attribute of the UFS storage device is
 set accordingly and will modify it if there is a mismatch.
+
+6. Testing with QEMU
+====================
+
+QEMU emulates a UFS host controller as a PCI device named "ufs" and
+logical units named "ufs-lu". This can be used to test changes to the
+UFS core and to ufshcd-pci without UFS hardware.
+
+The "ufs" and "ufs-lu" devices are available since QEMU 8.2, and the
+"mcq" property since QEMU 9.1.
+
+Enable the following kernel options on top of the architecture
+defconfig::
+
+	CONFIG_SCSI_UFSHCD=y
+	CONFIG_SCSI_UFSHCD_PCI=y
+	CONFIG_BLK_DEV_SD=y
+
+Example for an arm64 guest with one 1 GiB logical unit::
+
+	qemu-img create -f raw ufs.img 1G
+	qemu-system-aarch64 -M virt -cpu max -smp 4 -m 2G -nographic \
+		-kernel arch/arm64/boot/Image -initrd rootfs.cpio.gz \
+		-append "console=ttyAMA0" \
+		-drive file=ufs.img,if=none,id=lu0,format=raw \
+		-device ufs,id=ufs0,serial=0001,mcq=on \
+		-device ufs-lu,drive=lu0,bus=ufs0,lun=0
+
+The logical unit appears as a SCSI disk (for example /dev/sda). Drop
+"mcq=on" to test the single doorbell mode instead of MCQ. The same
+-device options work with qemu-system-x86_64.
+
+The emulation accepts the link startup and hibernate enter/exit UIC
+commands and, since QEMU 11.1, DME get/set and the power mode change
+sequence, but it does not model UniPro, M-PHY or the resulting link
+state. Clock gating hardware and vendor host drivers are not exercised
+either. Changes in those areas still need testing on real hardware.
-- 
2.56.0.385.gd3acb90ef8-goog

