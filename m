Received: from mx-lax3-3.ucr.edu (mx.ucr.edu [169.235.156.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152C71D47B7
	for <linux-scsi@vger.kernel.org>; Tue, 27 Aug 2024 23:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=169.235.156.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724802566; cv=none; b=Kh30LPHAUaAaYEyH3JRvKG+MKG3KEown1QO5yJrEi0B/XZcm4D43WUzsbIdI0ojpIGXG5v+kLeb5Wh5ixdBIoKcBUROBQO94mxky06pHeu5oLTAvZyYsiGLz2aKZsub9Pr8B62u+eew7u1ElF/0Gv0EQKfjUCFL15F16woueaZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724802566; c=relaxed/simple;
	bh=Oa/q/B7QC9shO/oS8EXiewx53fGXKpzhCJSJ6R64P3I=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=QFyBJ7Tp4f51sM4B7BmKvdeIqsQf2sOEvCw9GoEOkoFog+uPPl+uKJMrP6JiRva2o56lCwLXU2MnpX9KbxzqNQeJPuFgmwzJGqzXAv3OWn1asTMuwu9NkC1Epu/98Y/RC3B/JX4ZPVAg0Gmp5EFgnwgMLsxx/DCHPZeB1Gkm1b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=email.ucr.edu; spf=pass smtp.mailfrom=ucr.edu; dkim=pass (2048-bit key) header.d=ucr.edu header.i=@ucr.edu header.b=oS19z5ZM; dkim=pass (1024-bit key) header.d=ucr.edu header.i=@ucr.edu header.b=kUfLFSMX; arc=none smtp.client-ip=169.235.156.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=email.ucr.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ucr.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ucr.edu header.i=@ucr.edu header.b="oS19z5ZM";
	dkim=pass (1024-bit key) header.d=ucr.edu header.i=@ucr.edu header.b="kUfLFSMX"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1724802565; x=1756338565;
  h=dkim-signature:x-google-dkim-signature:
   x-forwarded-encrypted:x-gm-message-state:
   x-google-smtp-source:mime-version:from:date:message-id:
   subject:to:content-type:x-cse-connectionguid:
   x-cse-msgguid;
  bh=Oa/q/B7QC9shO/oS8EXiewx53fGXKpzhCJSJ6R64P3I=;
  b=oS19z5ZMDs7zAgx8Wg43dqwLnuXRMDApAgfyoFEB/rWcLvrYXJqD4W5j
   gUI/2+aJskfAbiz1ZQGlcRcDy1OcwV6ZDupksaPPkP2pRwWX2UjRzVsMQ
   Fx01kBvlc3geoqJGDGVSDxvu6j4ProqM9cnj36ACPI/UyIXiPLzNy3CM+
   02AaFC2W2mxutnT6pkrBhU8hQKII98SD6ImNnF/Re/tYbASAZD2OlaAMM
   xqM/uZetl02xqjnilv3LwT9MhwppdjcTTmJwe/A2FbU0Qrf9GOtmc7rFi
   osljVQDzc9/jV7IRqLG3Tr+NpUD5GLpSr56Ut9K9NZs2YwWXut7Ye6b/w
   g==;
X-CSE-ConnectionGUID: wh2r5PkwS+m32JHhg5Iqeg==
X-CSE-MsgGUID: zo3yxAQUSpOEQjZ0uiJ36g==
Received: from mail-io1-f70.google.com ([209.85.166.70])
  by smtp-lax3-3.ucr.edu with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 27 Aug 2024 16:49:17 -0700
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-81f99a9111fso649572439f.2
        for <linux-scsi@vger.kernel.org>; Tue, 27 Aug 2024 16:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ucr.edu; s=rmail; t=1724802556; x=1725407356; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VhkdcW8ZfYHu6XlXCqHwIh0I4/YRYFz8/VqS+ioBQ68=;
        b=kUfLFSMX84oVMjEfw+lpah2hotRY6CcXigKX/e8RIS7QkoRAbUBVOIG+sf6CIwn3N1
         qd2N8WHWvs7ym9XXhtve60F9vrLVsmeAKN2xoQCBwA44GuH7z8EsSKitX1fwDn0XMZNB
         F08/oTRTyPt3E3duA4nm8eAAun+/FYAfRDmQg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724802556; x=1725407356;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VhkdcW8ZfYHu6XlXCqHwIh0I4/YRYFz8/VqS+ioBQ68=;
        b=XpwWBp1IkhUzrarmKJld1ORbbaRpsh0uv5en58nku7YtJEE81VGE6KQPTh9UU6p9GA
         WyQ2o3EZBMH624yePBWzWOG5/Wo87rkf2Urx4YYgmlvtqGwNa0Q0RIQTu4j0kbf4s2Yx
         OL45IkeTNKoS7CvMMcWZJtNPOPwsxj/KKYRXc2nwTkifB4D+6OAWkKP4xfjQ3RFQyfLu
         zZRCq7YaMjAOpz5m8uxLo/h6c21ELuE/EBWU2SybXeBWzXUVdVw5uFkKRxKURKbKldig
         mIBjgLiR3iLhbNa4E+oTbBVWpcfCX0lZ92zU7s3VznyXwy5Z1UzRVCY5JZcx4FT+tr0X
         +kJw==
X-Forwarded-Encrypted: i=1; AJvYcCV+x9DzZ35NfwCR1UzAt4Zoi0Hr27EUrFt8235twBP72Lw3s9ZbH+H1+QAZjHVMsX/xXmh5xjNarFmp@vger.kernel.org
X-Gm-Message-State: AOJu0YyeTtP0KejaPptDbGvqrBfAwT2A2ugmZos4oW3qU6QeHNvtDjsl
	mxv4KE9EHnlnsymKC1pch2U7/nrRN6SmZOk4551Av4Vr0NJFlLsA4Hzba1AnX9HBo4lahSin0dl
	N0BwPy2mN/a4gsc0RNiXHQRs1BRfRfeM0IqmC8dKw/2LSs+ISxtey1Q/Aw7b6JBuYTHdAvyiUU9
	C6j9c+s+Hf1A/g42ru1ZtKxnUY+4s0GiCxHGo=
X-Received: by 2002:a05:6e02:1562:b0:39d:2a84:869f with SMTP id e9e14a558f8ab-39e3c9756e4mr163288785ab.6.1724802555940;
        Tue, 27 Aug 2024 16:49:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHUBOoBnmQiWTUynS2fxSdY+CC+P2PsHPuzJdu9eahzwq/2ll+ccECRRFgXem+6XGY2oTPkmP3A99AQ2q0lQ3A=
X-Received: by 2002:a05:6e02:1562:b0:39d:2a84:869f with SMTP id
 e9e14a558f8ab-39e3c9756e4mr163288615ab.6.1724802555664; Tue, 27 Aug 2024
 16:49:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Juefei Pu <juefei.pu@email.ucr.edu>
Date: Tue, 27 Aug 2024 16:49:04 -0700
Message-ID: <CANikGpf0OmGMSkksH_ihW9_yXVAL25xKD4CBy8d1gpKj0inPjQ@mail.gmail.com>
Subject: BUG: kernel panic: corrupted stack end in worker_thread
To: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yu Hao <yhao016@ucr.edu>
Content-Type: text/plain; charset="UTF-8"

Hello,
We found the following issue using syzkaller on Linux v6.10.
The PoC generated by Syzkaller can have the kernel panic.
The full report including the Syzkaller reproducer:
https://gist.github.com/TomAPU/a96f6ccff8be688eb2870a71ef4d035d

The brief report is below:

Syzkaller hit 'kernel panic: corrupted stack end in worker_thread' bug.

Kernel panic - not syncing: corrupted stack end detected inside scheduler
CPU: 0 PID: 5818 Comm: kworker/0:4 Not tainted 6.10.0 #13
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
Workqueue:  0x0 (ata_sff)
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x23d/0x360 lib/dump_stack.c:114
 panic+0x331/0x850 kernel/panic.c:347
 schedule_debug+0x2a8/0x3f0 kernel/sched/core.c:5964
 __schedule+0x12b/0x15e0 kernel/sched/core.c:6630
 __schedule_loop kernel/sched/core.c:6825 [inline]
 schedule+0x143/0x310 kernel/sched/core.c:6840
 worker_thread+0xc6b/0x1020 kernel/workqueue.c:3424
 kthread+0x2eb/0x380 kernel/kthread.c:389
 ret_from_fork+0x49/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:244
 </TASK>
Kernel Offset: disabled
Rebooting in 86400 seconds..
