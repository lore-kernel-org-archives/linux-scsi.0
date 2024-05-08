Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F768BEA
	for <linux-scsi@vger.kernel.org>; Wed,  8 May 2024 00:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715126559; cv=none; b=bCslkh6+ILopxMCFHpfutYRausbxum7tnDu3j4NZBWu1LxCeqKMcz+QZA9NiM6d1wQb9+7KZeSnk6Qkd+vHfqPlbdBHHk4wq60HJvMdttkCwo1FUBgrwNpBB5tF5IHk7ebPLOcJAiuidOCcXE7hsSUXsIlEXPyuyDiuW/infyg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715126559; c=relaxed/simple;
	bh=x8yzkCVk6Wolns38BJznG8F1DF6BmLfscTRYXzWxiFY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=D+Dr0wtYKck0YiEuRv9quBiiS1YNagj/x+55OCYapfVkNbm4ufgTEiHcUA1lNF+f9d+5C0ct0LhpGQwtWDDHmzBwslEube8VGj2PlgqefTp1UVyyYvaWCk8IaNaw+Xt80hsjHv7LBOAelO9XYJ56zGUGwKRVq5o+xOw3VriwXzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--justinstitt.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GdpblQXo; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--justinstitt.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GdpblQXo"
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-7d9d0936d6aso461863539f.0
        for <linux-scsi@vger.kernel.org>; Tue, 07 May 2024 17:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715126549; x=1715731349; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2EzQcPBxS/fsLuAnrDweegMDqFpI++/qb4hh3xWGZ0s=;
        b=GdpblQXo4Kb0hrYYpH4pnJQ+o5cPP+aKxKYmYYCqqcytbyFeW9R7YgV/OS5GqYGuuK
         CE/zZS/fzjgq1z7NJTa7UC2dqQdjjrMAoBdJM5j0vg3+y3S95d0wFUcJoV1DhmZQliHK
         nZMNksktsOpuOFmj11fx2V2hEl0/Wjy8nerpPuoCUu2P8XO+wBR7WXcwwXTe6F+TvOHv
         /HEJ2RHQUPTTxpExMhWR1p1gthAEXXXCl3d2sbuiRmDFwhinVJZR4nWceSRpjkNbnU3N
         ZlUzDrOIST1sSlD/a/2su/Q0EJigvA975qQd7KGEzl1PbTtFXyZ+4u8aJUVsAxnmZzqT
         MntQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715126549; x=1715731349;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2EzQcPBxS/fsLuAnrDweegMDqFpI++/qb4hh3xWGZ0s=;
        b=GvWoB0aOzWeY/Dxo6aY7vMiaELEqkvqfAxCEUbgA4tQ2MMCrvoOeLVXbx0HYUYLD4L
         hJJYYHX8Tca7HbmHmPQBtGsTOIqxtfDbihGMnyNIab3C+yoWUbrpddzf0ZUlXFVqlJTA
         zn50aA0rfOqdGu4YPjI+wtBKANX1BVIEfwUz6pg7yOkUeNCMRSY7R0ol/qcMN1qhJXvl
         PwmnP9X4Lv5UitvqYBys14CzCiNRzkooD86mrChIjmcYATs0Fc2szZt7geoqsVEM++d3
         wdsy2ESSBNuMKql/fmybDWGhbnO8Ca2yM7hodeR+ewrtiyBQ1CdQOuoJJsr4biMaWWv/
         iDrA==
X-Gm-Message-State: AOJu0YxSF+nIYz3nxWiHtEPFgEZXpc4rgav5W+1svAQqRPTyxPmEcgng
	7rdKjNG+XqJfoxctcKenKG/yjdQOnCnzT2dpZrWRsQ94pb8VYCe7RTb1tQl1vdwQRrvnIMT7ipl
	2h8BDT0rZykGBJ2LCYrdtLA==
X-Google-Smtp-Source: AGHT+IGw/gpETax6yTNA3i+9Zl+QI37sM3g2h6H0L5ARm9tG/6yPfzStL17AVO5/mFkhkenOKA0hprTVnxl15+f/xA==
X-Received: from jstitt-linux1.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:23b5])
 (user=justinstitt job=sendgmr) by 2002:a05:6638:1648:b0:488:d489:3940 with
 SMTP id 8926c6da1cb9f-488fdb12340mr66133173.3.1715126549481; Tue, 07 May 2024
 17:02:29 -0700 (PDT)
Date: Wed, 08 May 2024 00:02:27 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIABLBOmYC/x2MWwqEMBAEryLzbSCG+FivIoto0urAopJZRAje3
 SjUT0F1RxIEhlCbRQo4WHhbkxR5Rm4Z1hmKfXIy2lhd6lqN9iFlSkIv+MH9e9kBr1A1TntrquZ TUNrvAROf73f3va4bRAFkr2sAAAA=
X-Developer-Key: i=justinstitt@google.com; a=ed25519; pk=tC3hNkJQTpNX/gLKxTNQKDmiQl6QjBNCGKJINqAdJsE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1715126548; l=2860;
 i=justinstitt@google.com; s=20230717; h=from:subject:message-id;
 bh=x8yzkCVk6Wolns38BJznG8F1DF6BmLfscTRYXzWxiFY=; b=Sj99Fwr6AVwgXA4Y1BeQQmQ9JnnNDd7bY5VrSgi54QBOz4VkOqHiWOJ+sI+4TBriRdbf+MPy6
 pOsiE1rtNb6DspdDULYONRJEuLYkienHIofZLsdYrGz2xSOQp0ISZ1m
X-Mailer: b4 0.12.3
Message-ID: <20240508-b4-b4-sio-sr_select_speed-v1-1-968906b908b7@google.com>
Subject: [PATCH] scsi: sr: fix unintentional arithmetic wraparound
From: Justin Stitt <justinstitt@google.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Nathan Chancellor <nathan@kernel.org>, 
	Bill Wendling <morbo@google.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, linux-hardening@vger.kernel.org, 
	Justin Stitt <justinstitt@google.com>
Content-Type: text/plain; charset="utf-8"

Running syzkaller with the newly reintroduced signed integer overflow
sanitizer produces this report:

[   65.194362] ------------[ cut here ]------------
[   65.197752] UBSAN: signed-integer-overflow in ../drivers/scsi/sr_ioctl.c:436:9
[   65.203607] -2147483648 * 177 cannot be represented in type 'int'
[   65.207911] CPU: 2 PID: 10416 Comm: syz-executor.1 Not tainted 6.8.0-rc2-00035-gb3ef86b5a957 #1
[   65.213585] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   65.219923] Call Trace:
[   65.221556]  <TASK>
[   65.223029]  dump_stack_lvl+0x93/0xd0
[   65.225573]  handle_overflow+0x171/0x1b0
[   65.228219]  sr_select_speed+0xeb/0xf0
[   65.230786]  ? __pm_runtime_resume+0xe6/0x130
[   65.233606]  sr_block_ioctl+0x15d/0x1d0
...

Historically, the signed integer overflow sanitizer did not work in the
kernel due to its interaction with `-fwrapv` but this has since been
changed [1] in the newest version of Clang. It was re-enabled in the
kernel with Commit 557f8c582a9ba8ab ("ubsan: Reintroduce signed overflow
sanitizer").

Let's add an extra check to make sure we don't exceed 0xffff/177 (350)
since 0xffff is the max speed. This has two benefits: 1) we deal with
integer overflow before it happens and 2) we properly respect the max
speed of 0xffff. There are some "magic" numbers here but I did not want
to change more than what was necessary.

Link: https://github.com/llvm/llvm-project/pull/82432 [1]
Closes: https://github.com/KSPP/linux/issues/357
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Justin Stitt <justinstitt@google.com>
---
Here's the syzkaller reproducer:
r0 = openat$cdrom(0xffffffffffffff9c, &(0x7f0000000140), 0x800, 0x0)
ioctl$CDROM_SELECT_SPEED(r0, 0x5322, 0x7ee9f7c1)

... which was used against Kees' tree here (v6.8rc2):
https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/log/?h=wip/v6.9-rc2/unsigned-overflow-sanitizer

... with this config:
https://gist.github.com/JustinStitt/824976568b0f228ccbcbe49f3dee9bf4
---
 drivers/scsi/sr_ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index 5b0b35e60e61..2d78bcf68eb3 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -430,7 +430,8 @@ int sr_select_speed(struct cdrom_device_info *cdi, int speed)
 	Scsi_CD *cd = cdi->handle;
 	struct packet_command cgc;
 
-	if (speed == 0)
+	/* avoid exceeding the max speed or overflowing integer bounds */
+	if (speed == 0 || speed > 0xffff / 177)
 		speed = 0xffff;	/* set to max */
 	else
 		speed *= 177;	/* Nx to kbyte/s */

---
base-commit: 0106679839f7c69632b3b9833c3268c316c0a9fc
change-id: 20240507-b4-b4-sio-sr_select_speed-e68c0d426891

Best regards,
--
Justin Stitt <justinstitt@google.com>

