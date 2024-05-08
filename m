Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A866C79F6
	for <linux-scsi@vger.kernel.org>; Wed,  8 May 2024 17:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715188975; cv=none; b=jLuNQeT9P11kU3ucgZdPwMz7uJ+fLg9oW6VUt3s3IH/eO/bA0XpPBTpm0DPh4PKqxr/tRFfauVmJG4VKkuUA1m0H/hXShQxrRf6NJ2QLdDhmBhkCRtRDVJ3PS/9IUxzM1Cp7Tg6OE9SK/IAO6TdwPtMXfnlZW9YrCdzGHNbc/Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715188975; c=relaxed/simple;
	bh=u4IncrtpCxubuwQgD8YUieXvfjotsSuja6N1Oi10lPE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=qkwyg9y3DVB0ON3R1KzqLmAYHDdMmeQi6Usi48zkePQAR6fgh5QYetsx8LH5sZY7sRmWH3rpoQ4tcRxMf3axYvJpVv/SEMHCx20HK3zfRtb00xZksOsAzg84bNooWBsf5V/CQ3B5pvI1F6u5VTesIRSbHEMQdU77gRg5QNqnDDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--justinstitt.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t3saEfn0; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--justinstitt.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t3saEfn0"
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-7e18055c2dfso293553639f.0
        for <linux-scsi@vger.kernel.org>; Wed, 08 May 2024 10:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715188972; x=1715793772; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XE1QNsIrpSdoBDzkTgvC4e4sDaJEW78xu5f3eAO+u4k=;
        b=t3saEfn06fZdip5p3C/JgG8UevClu2UIKjFy4zUu2vcpO1t2ltDZRx6WZKNb52HkN/
         E37X3xnRng4hEcwKJceI5+Lky5tvguMvNTUQ+iSx4bo+XSbtaZ0UKcWkYePpPPg0cppl
         emMn3PDwxTXHzYWQnRCkucGUmYMH7thjypIR1ZY2iMSC3Oftes6zZdrpTgQJFgk19RSZ
         itLF8WVPNwynUBGAGAgYL1vXH7YeUUglJDFtzhNrLgEZpDxzvo9TGtVbPpIxUPJ2Jk8Z
         E2TiK1ZlH3+o5HIeyXJLTpGPDI2Ld6iB9/u0rITXD6QBX+wFwmQkcVJg7MwtNsMzx0vl
         KrQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715188972; x=1715793772;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XE1QNsIrpSdoBDzkTgvC4e4sDaJEW78xu5f3eAO+u4k=;
        b=qbx3iSr1AyEsE+mEPfQbfnIcaLCuAtlUwKkYn9Hp+fByGJ5k1kneHGdKihoDb15/77
         gU+Vi5tEqhj4rHTer3vvt+zw/Y93IH0bzQvDa/LNkTsFB5lE3B1Ymn3Dwq+qVcnf/lT0
         0YTtQrTRRRg2JCLprUyUjJHFIpy3V3WmVth37UqmKJcwytSa3E24/DkYCV606qg72rTA
         5raKnpM5bLtamhtMTFbnq1TbnvXx4Y/ABnK2EAUiz/wiTedCaqtgIvVQX7jJLE0pZ+tu
         mmimZIF9vvhF2ziN+f9y8e6vH8T1ezjJ8PgbX4wq5qooKT94xjAXLJAO++j9Dag1cI0w
         aVwg==
X-Gm-Message-State: AOJu0YwYkI9p4I7qw/gCHlx5n9HECKoPPZ9nH1OV+YUBaS8rSesSVTAO
	o5IA2x+Tn9X6SLF/URKsbRrcz+UEbtB7ChBQvbLM9mNXjGoKZj75j2gna63kGykVhuhg4n5yjjp
	QVwxA5RJZiokX+IVtqQnyaA==
X-Google-Smtp-Source: AGHT+IEuBGqzlpwNaU7svDGL3Zek3/TGDsOW4gHZZ+YDM2nc1D8NlRTOXdtcbQb/W0hoJF3F1F9uhAcjjx+hP4x81Q==
X-Received: from jstitt-linux1.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:23b5])
 (user=justinstitt job=sendgmr) by 2002:a05:6602:3f86:b0:7da:b30e:df80 with
 SMTP id ca18e2360f4ac-7e18fbcc8c5mr3658939f.0.1715188971917; Wed, 08 May 2024
 10:22:51 -0700 (PDT)
Date: Wed, 08 May 2024 17:22:51 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAOq0O2YC/32NQQqDMBBFryKzbkoSrCZd9R5FpMZpHLBGMhJax
 Ls3Ct0WZvM+/79ZgTESMlyLFSImYgpTBn0qwA2PyaOgPjNoqUt5kbXoyv1yTXBsGUd0S8szYi+
 wMk72pa6MVZD3c8QnvQ/3vck8EC8hfo5XSe3pz2r+WJMSStjslFVnpenqmw/Bj3h24QXNtm1fG XNPXsMAAAA=
X-Developer-Key: i=justinstitt@google.com; a=ed25519; pk=tC3hNkJQTpNX/gLKxTNQKDmiQl6QjBNCGKJINqAdJsE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1715188971; l=6182;
 i=justinstitt@google.com; s=20230717; h=from:subject:message-id;
 bh=u4IncrtpCxubuwQgD8YUieXvfjotsSuja6N1Oi10lPE=; b=fv+LN7qHNuPE4tQk73JaJ9gUQL3bUZ0BBo3Bg7pp+tVHXb8anS5WSRRQsIjQ1UUCkLRHE0c9o
 EFv6FCWnOtVCnmHgUVoGP14S9u5iIiOodjb2VK+zubr0V2ELop9Khn1
X-Mailer: b4 0.12.3
Message-ID: <20240508-b4-b4-sio-sr_select_speed-v2-1-00b68f724290@google.com>
Subject: [PATCH v2] scsi: sr: fix unintentional arithmetic wraparound
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

Firstly, let's change the type of "speed" to unsigned long as
sr_select_speed()'s only caller passes in an unsigned long anyways.

$ git grep '\.select_speed'
|	drivers/scsi/sr.c:      .select_speed           = sr_select_speed,
...
|	static int cdrom_ioctl_select_speed(struct cdrom_device_info *cdi,
|	                unsigned long arg)
|	{
|	        ...
|	        return cdi->ops->select_speed(cdi, arg);
|	}

Next, let's add an extra check to make sure we don't exceed 0xffff/177
(350) since 0xffff is the max speed. This has two benefits: 1) we deal
with integer overflow before it happens and 2) we properly respect the
max speed of 0xffff. There are some "magic" numbers here but I did not
want to change more than what was necessary.

Link: https://github.com/llvm/llvm-project/pull/82432 [1]
Closes: https://github.com/KSPP/linux/issues/357
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Justin Stitt <justinstitt@google.com>
---
Changes in v2:
- change @speed type from int to unsigned long and use a clamp (thanks Kees)
- also update documentation to avoid confusion
- Link to v1: https://lore.kernel.org/r/20240508-b4-b4-sio-sr_select_speed-v1-1-968906b908b7@google.com
---
Here's the syzkaller reproducer:
r0 = openat$cdrom(0xffffffffffffff9c, &(0x7f0000000140), 0x800, 0x0)
ioctl$CDROM_SELECT_SPEED(r0, 0x5322, 0x7ee9f7c1)

... which was used against Kees' tree here (v6.8rc2):
https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/log/?h=wip/v6.9-rc2/unsigned-overflow-sanitizer

... with this config:
https://gist.github.com/JustinStitt/824976568b0f228ccbcbe49f3dee9bf4
---
 Documentation/cdrom/cdrom-standard.rst | 4 ++--
 drivers/scsi/sr.h                      | 2 +-
 drivers/scsi/sr_ioctl.c                | 5 ++++-
 include/linux/cdrom.h                  | 2 +-
 4 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/Documentation/cdrom/cdrom-standard.rst b/Documentation/cdrom/cdrom-standard.rst
index 7964fe134277..6c1303cff159 100644
--- a/Documentation/cdrom/cdrom-standard.rst
+++ b/Documentation/cdrom/cdrom-standard.rst
@@ -217,7 +217,7 @@ current *struct* is::
 		int (*media_changed)(struct cdrom_device_info *, int);
 		int (*tray_move)(struct cdrom_device_info *, int);
 		int (*lock_door)(struct cdrom_device_info *, int);
-		int (*select_speed)(struct cdrom_device_info *, int);
+		int (*select_speed)(struct cdrom_device_info *, unsigned long);
 		int (*get_last_session) (struct cdrom_device_info *,
 					 struct cdrom_multisession *);
 		int (*get_mcn)(struct cdrom_device_info *, struct cdrom_mcn *);
@@ -396,7 +396,7 @@ action need be taken, and the return value should be 0.
 
 ::
 
-	int select_speed(struct cdrom_device_info *cdi, int speed)
+	int select_speed(struct cdrom_device_info *cdi, unsigned long speed)
 
 Some CD-ROM drives are capable of changing their head-speed. There
 are several reasons for changing the speed of a CD-ROM drive. Badly
diff --git a/drivers/scsi/sr.h b/drivers/scsi/sr.h
index 1175f2e213b5..dc899277b3a4 100644
--- a/drivers/scsi/sr.h
+++ b/drivers/scsi/sr.h
@@ -65,7 +65,7 @@ int sr_disk_status(struct cdrom_device_info *);
 int sr_get_last_session(struct cdrom_device_info *, struct cdrom_multisession *);
 int sr_get_mcn(struct cdrom_device_info *, struct cdrom_mcn *);
 int sr_reset(struct cdrom_device_info *);
-int sr_select_speed(struct cdrom_device_info *cdi, int speed);
+int sr_select_speed(struct cdrom_device_info *cdi, unsigned long speed);
 int sr_audio_ioctl(struct cdrom_device_info *, unsigned int, void *);
 
 int sr_is_xa(Scsi_CD *);
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index 5b0b35e60e61..a0d2556a27bb 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -425,11 +425,14 @@ int sr_reset(struct cdrom_device_info *cdi)
 	return 0;
 }
 
-int sr_select_speed(struct cdrom_device_info *cdi, int speed)
+int sr_select_speed(struct cdrom_device_info *cdi, unsigned long speed)
 {
 	Scsi_CD *cd = cdi->handle;
 	struct packet_command cgc;
 
+	/* avoid exceeding the max speed or overflowing integer bounds */
+	speed = clamp(0, speed, 0xffff / 177);
+
 	if (speed == 0)
 		speed = 0xffff;	/* set to max */
 	else
diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
index 98c6fd0b39b6..fdfb61ccf55a 100644
--- a/include/linux/cdrom.h
+++ b/include/linux/cdrom.h
@@ -77,7 +77,7 @@ struct cdrom_device_ops {
 				      unsigned int clearing, int slot);
 	int (*tray_move) (struct cdrom_device_info *, int);
 	int (*lock_door) (struct cdrom_device_info *, int);
-	int (*select_speed) (struct cdrom_device_info *, int);
+	int (*select_speed) (struct cdrom_device_info *, unsigned long);
 	int (*get_last_session) (struct cdrom_device_info *,
 				 struct cdrom_multisession *);
 	int (*get_mcn) (struct cdrom_device_info *,

---
base-commit: 0106679839f7c69632b3b9833c3268c316c0a9fc
change-id: 20240507-b4-b4-sio-sr_select_speed-e68c0d426891

Best regards,
--
Justin Stitt <justinstitt@google.com>

