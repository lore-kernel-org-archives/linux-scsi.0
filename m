Received: from mx6.ucr.edu (mx6.ucr.edu [138.23.62.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3481314BF8D
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2024 22:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=138.23.62.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724885884; cv=none; b=dwEacorFdhOJ18aeW9gZbboc3IDmBiHedQzCTMYkBDLapNH+mxoORtZ0PK11ujBl88dQagl/4m9N4JFTRAD0ud6IjV+Ag7wU9YEbNgdOsjXxNS961SCRmdqXGocrmRVJncUGeFwICIAMFZN3LOMmyCjc/cp56gXzxilAEYxnSEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724885884; c=relaxed/simple;
	bh=mH/g7ll4FI7BDdOfh5JOlytsoVZVoCZLbdj/TexsXbk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=pBy/JYLYhs8ljji5883SGDe/E6vx48Agp68+ds2Z4S+/ThjKkgz4Zn1hmnBRmhCZw1SuwSb4rDAWs5cAUc42maDl54qPbJAnwmfEX3qIrQK2BdaPzzWEA8CTaGuX+jgIaYGRbUy3iN2BHVlZJ5I3lkSyB/3exX+M19N9WAlZXR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ucr.edu; spf=pass smtp.mailfrom=ucr.edu; dkim=pass (2048-bit key) header.d=ucr.edu header.i=@ucr.edu header.b=eq9W5waJ; dkim=pass (1024-bit key) header.d=ucr.edu header.i=@ucr.edu header.b=QLj7ubsU; arc=none smtp.client-ip=138.23.62.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ucr.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ucr.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ucr.edu header.i=@ucr.edu header.b="eq9W5waJ";
	dkim=pass (1024-bit key) header.d=ucr.edu header.i=@ucr.edu header.b="QLj7ubsU"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1724885884; x=1756421884;
  h=dkim-signature:x-google-dkim-signature:
   x-forwarded-encrypted:x-gm-message-state:
   x-google-smtp-source:mime-version:from:date:message-id:
   subject:to:cc:content-type:x-cse-connectionguid:
   x-cse-msgguid;
  bh=mH/g7ll4FI7BDdOfh5JOlytsoVZVoCZLbdj/TexsXbk=;
  b=eq9W5waJ/BLwJZAuX6a2GfUUZR4kLXpKBqjvobD59FGEGePGAHegqJir
   wbAcpuY0dzBHdA5/7w7mdax60D35beeZJUKmDhTzYcH3jNdVTqdK9abii
   gaiYIjKDwSztVSIpWoqI3LlrUOmVUkTdS1QeuemAhzYqKjzbpomiK0lDr
   tzxw3Ly3LHU8QTMkmsJmoPopB8JRrOou8OoTd3mXyu6r+gKEsPku36Lh2
   nQ4ysUr3nPVliT8TnsdlYxSLr1hpoJ3/KHrN9dEDX1wj1oSI6YpVbY5GT
   b8Ja+AniQ2xAePqgoCmYOhbHoKWDfWbXS10arGDVpgi7OhwI3vFC6lGin
   g==;
X-CSE-ConnectionGUID: 736aH5UxQ/GA0wuedkUAyw==
X-CSE-MsgGUID: 1PY8APkSST6sjBKmsUKpWg==
Received: from mail-pj1-f70.google.com ([209.85.216.70])
  by smtpmx6.ucr.edu with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 28 Aug 2024 15:58:03 -0700
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2d404dffd54so27671a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2024 15:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ucr.edu; s=rmail; t=1724885881; x=1725490681; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yLxVY8X/T4f7fRZ6UyOP0yKGoxXEhzabMD9FibXb7GE=;
        b=QLj7ubsUmvJh16E23vtf/wRgs4lrIV7HaFWPJ7cl5gp+x2Sm3FSJNZ9rbWDTAU4Ahp
         bnFbhMFu623f1nfaLUvjyPheUh6p9IkWRtORKCOZeUuWKG23BwT6zN65Qp/BTBDBStim
         DIw4Uw8N68gsJ9u6UZEmWPtI1T/cDnmkljg2E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724885881; x=1725490681;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yLxVY8X/T4f7fRZ6UyOP0yKGoxXEhzabMD9FibXb7GE=;
        b=ehdA9KXs4HsSTIZyNoHVTQdUj6rClFMDzXxTKUb6KcKUXVy0cVnpP3/Di5aEH24gvT
         ve0yKAo1QlQfWO7z3xWwaooX54QhpykpxRHxpP7oKg3xaIYPkvoNFrCtZ9uoxpq18+56
         9elkW30nROi4+BlFxna7gkZkDhDIIJJEUEU66u0IFVluGga0/qc8pWNbfKu5ot4uZ51R
         OJAAdNdpW9v5PMQy55wq/Km5hfi9SwEqdIjZkuwRR0WTZNS8DBVZl/2yZD4Ykf6HWH24
         zSpHSOjiCqnuGHD1u+vdDe6QweFCzYn3GPiyqRECPCAXWk1P009+y/KcdARGgh8DLH3j
         zSlg==
X-Forwarded-Encrypted: i=1; AJvYcCUsPUKFed/vxzmrHvn/tIcDIcesOJTVopqq9rg/EpKZDC7O03Ko4OMocNlkMaUT7E4U32TFYlLdMqaY@vger.kernel.org
X-Gm-Message-State: AOJu0YyfV6lUqcUx9hdDHGugjG2QHwdDJbEcLH/t4LOwyEnfdqjze3ZC
	PAbQfXpNKL+e5CUC/vL2/7V+tA7b5O1cb52t4I67b926u5ou4jkGFrHHKx2Cg5hfspd3VQYheZt
	YoK0jxfTFCt6QgC/rjQ5fb05GRcrUKzZLHQJeakvWnpYDoSvlEn6BU9y5W61mzTPj4k1au1ZdHT
	/WXyeWfmGk2qkB6Wiq/APSgGAhzh96KFD9ha0=
X-Received: by 2002:a17:90b:17d2:b0:2c8:f3b7:ec45 with SMTP id 98e67ed59e1d1-2d8564af81cmr825623a91.36.1724885881539;
        Wed, 28 Aug 2024 15:58:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHXEe6dhUHQh465WEYk7KUByrrAZDRSly0qwGGKpGNnIr+sgNfIemlPXdgVS5YvdQVvQxPGAJKRxkeedJF+AwU=
X-Received: by 2002:a17:90b:17d2:b0:2c8:f3b7:ec45 with SMTP id
 98e67ed59e1d1-2d8564af81cmr825608a91.36.1724885881159; Wed, 28 Aug 2024
 15:58:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Xingyu Li <xli399@ucr.edu>
Date: Wed, 28 Aug 2024 15:57:50 -0700
Message-ID: <CALAgD-718DVmcVHtgSFGKbgr0ePoUjN2ST=gBtdYtGX5GUqBQg@mail.gmail.com>
Subject: BUG: kernel panic: corrupted stack end in sg_ioctl
To: dgilbert@interlog.com, James.Bottomley@hansenpartnership.com, 
	martin.petersen@oracle.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: Yu Hao <yhao016@ucr.edu>
Content-Type: text/plain; charset="UTF-8"

Hi,

We found a bug in Linux 6.10 using syzkaller. It is possibly a
corrupted stack  bug.
The reprodcuer is
https://gist.github.com/freexxxyyy/9025a217d3002b14deca0b14768c6f97

The bug report is:

Syzkaller hit 'kernel panic: corrupted stack end in sg_ioctl' bug.

Kernel panic - not syncing: corrupted stack end detected inside scheduler
CPU: 0 PID: 8135 Comm: syz-executor302 Not tainted 6.10.0 #13
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x23d/0x360 lib/dump_stack.c:114
 panic+0x331/0x850 kernel/panic.c:347
 schedule_debug+0x2a8/0x3f0 kernel/sched/core.c:5964
 __schedule+0x12b/0x15e0 kernel/sched/core.c:6630
 __schedule_loop kernel/sched/core.c:6825 [inline]
 schedule+0x143/0x310 kernel/sched/core.c:6840
 schedule_timeout+0x1b9/0x300 kernel/time/timer.c:2581
 io_schedule_timeout+0x96/0x120 kernel/sched/core.c:9034
 do_wait_for_common kernel/sched/completion.c:95 [inline]
 __wait_for_common kernel/sched/completion.c:116 [inline]
 wait_for_common_io+0x31c/0x620 kernel/sched/completion.c:133
 blk_wait_io block/blk.h:82 [inline]
 blk_execute_rq+0x369/0x4a0 block/blk-mq.c:1408
 sg_scsi_ioctl drivers/scsi/scsi_ioctl.c:593 [inline]
 scsi_ioctl+0x20fc/0x2c70 drivers/scsi/scsi_ioctl.c:901
 sg_ioctl_common drivers/scsi/sg.c:1109 [inline]
 sg_ioctl+0x16c3/0x2d50 drivers/scsi/sg.c:1163
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:907 [inline]
 __se_sys_ioctl+0xfe/0x170 fs/ioctl.c:893
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0x7e/0x150 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x67/0x6f
RIP: 0033:0x7f63634e0e0d
Code: c3 e8 37 25 00 00 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f636347c1a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f636357d088 RCX: 00007f63634e0e0d
RDX: 0000000020000080 RSI: 0000000000000001 RDI: 0000000000000003
RBP: 00007f636357d080 R08: 00007f636347c640 R09: 00007f636347c640
R10: 00007f636347c640 R11: 0000000000000246 R12: 00007f636357d08c
R13: 00007f63635412b4 R14: 2367732f7665642f R15: 00007f636345c000
 </TASK>
Kernel Offset: disabled
Rebooting in 86400 seconds..


-- 
Yours sincerely,
Xingyu
