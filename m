Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394CF6CDDF
	for <linux-scsi@vger.kernel.org>; Sun, 28 Apr 2024 14:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714313328; cv=none; b=d6LWX6KHRwUZzBspv3LP5hUrLI8VQshlmaAnEY9MWFYqZfH9Z1hRfqvyIBM+hfpiHm1oUJNNfY0v07wdP9+8RIBLjYjdTK19lQ2/ztfiVM1Mxqkxn1WbRNdT9sNQv4ICFYdgeTWvhcHZ7Q7VCZVocW7Kji5ZKaWswsEFpOzHRSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714313328; c=relaxed/simple;
	bh=wY+5ieGzwczR+VF3VJYHYl6IpKwpWp+SmjSX7w/X92o=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=SWeVPN+NLajGNfeZPhnSpTkDTFojLYyTD19uWs7hA+SIgdZ6RcxzhQQpmwDFs/15OflH3NOXpiUHPNxLspPx0/1+b2Fge7YeTBubUbsJkaEkP4pfxbvF5v5fNDo2n7i+tUblurVbpBUjQNT3Y4uLpiieMkR12M15isv1I58qJdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zettlmeissl.de; spf=pass smtp.mailfrom=zettlmeissl.de; dkim=pass (2048-bit key) header.d=zettlmeissl.de header.i=@zettlmeissl.de header.b=TSCvyzYD; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zettlmeissl.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zettlmeissl.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zettlmeissl.de header.i=@zettlmeissl.de header.b="TSCvyzYD"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-34c09040154so2917176f8f.3
        for <linux-scsi@vger.kernel.org>; Sun, 28 Apr 2024 07:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zettlmeissl.de; s=2024-02-28; t=1714313321; x=1714918121; darn=vger.kernel.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cAdBKJZtOayz0aoh4dqB5IMk9MbkwxOzWIADKpMRfoc=;
        b=TSCvyzYDdUdd3PJfqPgWNTQxM0YUvuuXrefetpmNlvv8DlqfaH6u97lTyJ51YTHabr
         lCMOdroUQ4QJTS5p7rYyrYV5EYteE7mP0MSleILUPJ1x16Fp0/AnbUaut1OcVzRAlCak
         KC7oHMx2fbYTMxp7b3vEXvwAADGrrzFEBaSyCoYxRf+jj+QJ2W/CwrUf6ddXopdq72Fa
         Xcs9mQ+Albc5gGDJcDI3JMzdiwzfeqX/oalG7bNeIPxBiZgxvKDQXVAa+gd/nldPl39J
         3orVu2GVZPj09INgwgU7QMmM6YBXS1Kb1qf91TRCtnBKuIf5ES1o1d+ZsrOleTo2H018
         98iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714313321; x=1714918121;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cAdBKJZtOayz0aoh4dqB5IMk9MbkwxOzWIADKpMRfoc=;
        b=JVvDm4wTEIQwCFIKXIBXhNPPigT89pMsKRjec36JAlbQREUW9FncrTVe9v2dg9kqPV
         j7rZx31+99RrSMZGA8Eb+R8LsGt5wY15mPRxAXOoWAlzK94rvWXRvBwb4prTRgIl7r+4
         N1OIaPImJ9kUsRicw48iFxQXjtQhUq7Gcz4CItSFI841zsycNY7Ia8BrSNqayg589xGT
         SkiDDzdn35Kdc/XxifBVNLXpzpGYn95Lfa8TS897ZzzVmM4lwth4iSnz4FSAuPjCdRD+
         wpZ3u41cfo2+I71Y+DyU2qlYuqlgxZ81iXO62MLYB8/LPvxfCV8gKq50nW4wOAGss4jw
         ub8A==
X-Gm-Message-State: AOJu0YzomhG+NA1/7Gl1a0ylIhks0deLcFJRnPiDobhuAp1JJTT1xN1O
	T9TP+89CHhXoYFM+m8/Ljww6yvXf951RkOgO5fNijuoFeSxEKkZg93okbDDBCz8/RLybcOne1Nh
	DOG9irA==
X-Google-Smtp-Source: AGHT+IEfJHryIL4bNuvUfiYb1jKoddc+ZejesbmAwl93iDgIJCcUjOCYNWtadQIl1ErEIL80QnV9Jg==
X-Received: by 2002:adf:9791:0:b0:34a:e884:977b with SMTP id s17-20020adf9791000000b0034ae884977bmr4464758wrb.32.1714313321116;
        Sun, 28 Apr 2024 07:08:41 -0700 (PDT)
Received: from zettlmeissl.de ([2a02:810d:1cc0:1c81:4e7f:3f83:c979:803b])
        by smtp.gmail.com with ESMTPSA id o28-20020adfa11c000000b0034ce8f59fb1sm1565750wro.3.2024.04.28.07.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Apr 2024 07:08:40 -0700 (PDT)
Date: Sun, 28 Apr 2024 16:08:13 +0200
From: Max =?utf-8?Q?Zettlmei=C3=9Fl?= <max@zettlmeissl.de>
To: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Subject: Oops (nullpointer dereference) in SCSI subsystem
Message-ID: <Zi5YTR98mKEsPqQQ@zettlmeissl.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/MekBxPzKyiz2ziv"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit


--/MekBxPzKyiz2ziv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I came across an oops caused by a nullpointer dereference which seems
to happen in the SCSI subsystem.

It is mostly reproducible, meaning that it happens repeatedly and I
have a rough idea of what triggers it, but it does not happen in 100%
of the cases.


I'm ripping optical media with a PLEXTOR W4012A connected via a IDE to
USB adapter, using the software DiscImageCreator (DIC), version
20240401T222316.
When a disc is heavily scratched or otherwise deteriorated, then the
oops can be triggered in about 2/3 of the cases when trying to create
an image of the disc. It seems to trigger easier when using the
software consecutively on discs. (i. e. it rarely happens right after
a fresh system start on the first discs, but almost guaranteed on the
second or third one after the start. The Kernel is not tainted at that
point.)
It did not happen in the past, but I think this is more likely due to
a new SCSI command usage pattern in DIC than due to a Kernel
regression.

It first happened with Kernel version 6.7.12. My Kernel is usually
configured to panic on oops, so I would have noticed if this had
happened earlier.
It still happens with Kernel 6.9.0-rc5.


The dereferenced address is always the same. Across restarts, across
Kernel versions and is not affected by Kernel structure randomization.


While reproducing the oops on 6.9.0-rc5 I came across another oops
which happens when I send a keyboard interrupt to the software while
it is waiting for the disc drive to be ready. This new oops seems
mostly identical to the original one, but the Kernel additionally
signals that a reboot is needed.


Kernel version: Linux version 6.9.0-rc5-maxz (root@max-computer) (gcc (Gentoo 13.2.1_p20240210 p14) 13.2.1 20240210, GNU ld (Gentoo 2.41 p5) 2.41.0) #4 SMP Sat Apr 27 19:19:48 CEST 2024
Machine and platform: x86_64 AuthenticAMD


Find the further dmesg logs attached in a following message in this thread.


The oops:
[ 1329.388291] BUG: kernel NULL pointer dereference, address: 0000000000000248
[ 1329.388301] #PF: supervisor read access in kernel mode
[ 1329.388305] #PF: error_code(0x0000) - not-present page
[ 1329.388310] PGD 0 P4D 0
[ 1329.388317] Oops: 0000 [#1] SMP NOPTI
[ 1329.388322] CPU: 17 PID: 3195 Comm: DiscImageCreato Not tainted 6.9.0-rc5-maxz #4
[ 1329.388328] Hardware name: System manufacturer System Product Name/PRIME B450-PLUS, BIOS 4401 09/04/2023
[ 1329.388333] RIP: 0010:scsi_block_when_processing_errors (./include/scsi/scsi_host.h:751 drivers/scsi/scsi_error.c:388) 
[ 1329.388342] Code: 00 90 f3 0f 1e fa 48 83 ec 38 48 89 5c 24 30 48 89 fb 65 48 8b 04 25 28 00 00 00 48 89 44 24 28 31 c0 e8 5b f4 5c 00 48 8b 13 <8b> 82 48 02 00 00 83 e8 05 83 f8 02 76 09 f6 82 f8 01 00 00 10 74
All code
========
   0:   00 90 f3 0f 1e fa       add    %dl,-0x5e1f00d(%rax)
   6:   48 83 ec 38             sub    $0x38,%rsp
   a:   48 89 5c 24 30          mov    %rbx,0x30(%rsp)
   f:   48 89 fb                mov    %rdi,%rbx
  12:   65 48 8b 04 25 28 00    mov    %gs:0x28,%rax
  19:   00 00 
  1b:   48 89 44 24 28          mov    %rax,0x28(%rsp)
  20:   31 c0                   xor    %eax,%eax
  22:   e8 5b f4 5c 00          call   0x5cf482
  27:   48 8b 13                mov    (%rbx),%rdx
  2a:*  8b 82 48 02 00 00       mov    0x248(%rdx),%eax         <-- trapping instruction
  30:   83 e8 05                sub    $0x5,%eax
  33:   83 f8 02                cmp    $0x2,%eax
  36:   76 09                   jbe    0x41
  38:   f6 82 f8 01 00 00 10    testb  $0x10,0x1f8(%rdx)
  3f:   74                      .byte 0x74

Code starting with the faulting instruction
===========================================
   0:   8b 82 48 02 00 00       mov    0x248(%rdx),%eax
   6:   83 e8 05                sub    $0x5,%eax
   9:   83 f8 02                cmp    $0x2,%eax
   c:   76 09                   jbe    0x17
   e:   f6 82 f8 01 00 00 10    testb  $0x10,0x1f8(%rdx)
  15:   74                      .byte 0x74
[ 1329.388348] RSP: 0018:ffffa8f18294fc80 EFLAGS: 00010246
[ 1329.388354] RAX: 0000000000000000 RBX: ffff8cf08679b800 RCX: 0000000000000000
[ 1329.388358] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[ 1329.388362] RBP: ffffa8f18294fcd8 R08: 0000000000000000 R09: 0000000000000004
[ 1329.388366] R10: ffffa8f18294fdcc R11: 0000000000000000 R12: ffffa8f18294fd58
[ 1329.388370] R13: ffff8cf08679b800 R14: 0000000000000000 R15: ffffa8f18294fcd0
[ 1329.388374] FS:  000077c954b60480(0000) GS:ffff8cff6ee40000(0000) knlGS:0000000000000000
[ 1329.388379] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1329.388384] CR2: 0000000000000248 CR3: 0000000100c8e000 CR4: 0000000000350ef0
[ 1329.388388] Call Trace:
[ 1329.388393]  <TASK>
[ 1329.388397] ? __die (arch/x86/kernel/dumpstack.c:421 arch/x86/kernel/dumpstack.c:434) 
[ 1329.388404] ? page_fault_oops (arch/x86/mm/fault.c:708) 
[ 1329.388412] ? exc_page_fault (./arch/x86/include/asm/irqflags.h:37 ./arch/x86/include/asm/irqflags.h:72 arch/x86/mm/fault.c:1513 arch/x86/mm/fault.c:1563) 
[ 1329.388419] ? asm_exc_page_fault (./arch/x86/include/asm/idtentry.h:623) 
[ 1329.388427] ? scsi_block_when_processing_errors (./include/scsi/scsi_host.h:751 drivers/scsi/scsi_error.c:388) 
[ 1329.388433] ? srso_return_thunk (arch/x86/lib/retpoline.S:224) 
[ 1329.388439] ? __slab_free (mm/slub.c:4090) 
[ 1329.388445] sr_do_ioctl (drivers/scsi/sr_ioctl.c:202 (discriminator 1)) 
[ 1329.388454] sr_packet (drivers/scsi/sr.c:924) 
[ 1329.388459] cdrom_get_disc_info (drivers/cdrom/cdrom.c:385) 
[ 1329.388467] cdrom_mrw_exit (drivers/cdrom/cdrom.c:538) 
[ 1329.388473] ? srso_return_thunk (arch/x86/lib/retpoline.S:224) 
[ 1329.388478] ? xa_destroy (lib/xarray.c:948 lib/xarray.c:2221) 
[ 1329.388484] ? srso_return_thunk (arch/x86/lib/retpoline.S:224) 
[ 1329.388489] ? __cond_resched (kernel/sched/core.c:8607) 
[ 1329.388496] unregister_cdrom (drivers/cdrom/cdrom.c:657) 
[ 1329.388501] sr_free_disk (drivers/scsi/sr.c:576) 
[ 1329.388507] disk_release (block/genhd.c:1194) 
[ 1329.388515] device_release (drivers/base/core.c:2585) 
[ 1329.388521] kobject_release (lib/kobject.c:693 lib/kobject.c:720) 
[ 1329.388529] blkdev_release (block/fops.c:630) 
[ 1329.388536] __fput (fs/file_table.c:423 (discriminator 1)) 
[ 1329.388543] __x64_sys_close (fs/open.c:1559 fs/open.c:1541 fs/open.c:1541) 
[ 1329.388549] do_syscall_64 (arch/x86/entry/common.c:52 (discriminator 1) arch/x86/entry/common.c:83 (discriminator 1)) 
[ 1329.388556] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130) 
[ 1329.388562] RIP: 0033:0x77c954d3cea4
[ 1329.388568] Code: 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 80 3d c5 34 0e 00 00 74 13 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 44 c3 0f 1f 00 48 83 ec 18 89 7c 24 0c e8 a3
All code
========
   0:   00 f7                   add    %dh,%bh
   2:   d8 64 89 01             fsubs  0x1(%rcx,%rcx,4)
   6:   48 83 c8 ff             or     $0xffffffffffffffff,%rax
   a:   c3                      ret
   b:   66 2e 0f 1f 84 00 00    cs nopw 0x0(%rax,%rax,1)
  12:   00 00 00 
  15:   90                      nop
  16:   f3 0f 1e fa             endbr64
  1a:   80 3d c5 34 0e 00 00    cmpb   $0x0,0xe34c5(%rip)        # 0xe34e6
  21:   74 13                   je     0x36
  23:   b8 03 00 00 00          mov    $0x3,%eax
  28:   0f 05                   syscall
  2a:*  48 3d 00 f0 ff ff       cmp    $0xfffffffffffff000,%rax         <-- trapping instruction
  30:   77 44                   ja     0x76
  32:   c3                      ret
  33:   0f 1f 00                nopl   (%rax)
  36:   48 83 ec 18             sub    $0x18,%rsp
  3a:   89 7c 24 0c             mov    %edi,0xc(%rsp)
  3e:   e8                      .byte 0xe8
  3f:   a3                      .byte 0xa3

Code starting with the faulting instruction
===========================================
   0:   48 3d 00 f0 ff ff       cmp    $0xfffffffffffff000,%rax
   6:   77 44                   ja     0x4c
   8:   c3                      ret
   9:   0f 1f 00                nopl   (%rax)
   c:   48 83 ec 18             sub    $0x18,%rsp
  10:   89 7c 24 0c             mov    %edi,0xc(%rsp)
  14:   e8                      .byte 0xe8
  15:   a3                      .byte 0xa3
[ 1329.388572] RSP: 002b:00007ffc967a9aa8 EFLAGS: 00000202 ORIG_RAX: 0000000000000003
[ 1329.388579] RAX: ffffffffffffffda RBX: 00007ffc967aad10 RCX: 000077c954d3cea4
[ 1329.388583] RDX: 000077c9547fd000 RSI: 000000000012c000 RDI: 0000000000000004
[ 1329.388587] RBP: 00007ffc967aad04 R08: 000000000012c000 R09: 0000000000000007
[ 1329.388591] R10: 0000000000000007 R11: 0000000000000202 R12: 0000000000000000
[ 1329.388595] R13: 00007ffc967a9ad0 R14: 00007ffc967a9ac8 R15: 0000000000000001
[ 1329.388601]  </TASK>
[ 1329.388604] Modules linked in:
[ 1329.388609] CR2: 0000000000000248
[ 1329.388614] ---[ end trace 0000000000000000 ]---
[ 1329.452047] pstore: backend (efi_pstore) writing error (-5)
[ 1329.452054] RIP: 0010:scsi_block_when_processing_errors (./include/scsi/scsi_host.h:751 drivers/scsi/scsi_error.c:388) 
[ 1329.452063] Code: 00 90 f3 0f 1e fa 48 83 ec 38 48 89 5c 24 30 48 89 fb 65 48 8b 04 25 28 00 00 00 48 89 44 24 28 31 c0 e8 5b f4 5c 00 48 8b 13 <8b> 82 48 02 00 00 83 e8 05 83 f8 02 76 09 f6 82 f8 01 00 00 10 74
All code
========
   0:   00 90 f3 0f 1e fa       add    %dl,-0x5e1f00d(%rax)
   6:   48 83 ec 38             sub    $0x38,%rsp
   a:   48 89 5c 24 30          mov    %rbx,0x30(%rsp)
   f:   48 89 fb                mov    %rdi,%rbx
  12:   65 48 8b 04 25 28 00    mov    %gs:0x28,%rax
  19:   00 00 
  1b:   48 89 44 24 28          mov    %rax,0x28(%rsp)
  20:   31 c0                   xor    %eax,%eax
  22:   e8 5b f4 5c 00          call   0x5cf482
  27:   48 8b 13                mov    (%rbx),%rdx
  2a:*  8b 82 48 02 00 00       mov    0x248(%rdx),%eax         <-- trapping instruction
  30:   83 e8 05                sub    $0x5,%eax
  33:   83 f8 02                cmp    $0x2,%eax
  36:   76 09                   jbe    0x41
  38:   f6 82 f8 01 00 00 10    testb  $0x10,0x1f8(%rdx)
  3f:   74                      .byte 0x74

Code starting with the faulting instruction
===========================================
   0:   8b 82 48 02 00 00       mov    0x248(%rdx),%eax
   6:   83 e8 05                sub    $0x5,%eax
   9:   83 f8 02                cmp    $0x2,%eax
   c:   76 09                   jbe    0x17
   e:   f6 82 f8 01 00 00 10    testb  $0x10,0x1f8(%rdx)
  15:   74                      .byte 0x74
[ 1329.452068] RSP: 0018:ffffa8f18294fc80 EFLAGS: 00010246
[ 1329.452074] RAX: 0000000000000000 RBX: ffff8cf08679b800 RCX: 0000000000000000
[ 1329.452079] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[ 1329.452083] RBP: ffffa8f18294fcd8 R08: 0000000000000000 R09: 0000000000000004
[ 1329.452086] R10: ffffa8f18294fdcc R11: 0000000000000000 R12: ffffa8f18294fd58
[ 1329.452091] R13: ffff8cf08679b800 R14: 0000000000000000 R15: ffffa8f18294fcd0
[ 1329.452095] FS:  000077c954b60480(0000) GS:ffff8cff6ee40000(0000) knlGS:0000000000000000
[ 1329.452100] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1329.452104] CR2: 0000000000000248 CR3: 0000000100c8e000 CR4: 0000000000350ef0
[ 1329.452109] note: DiscImageCreato[3195] exited with irqs disabled


--/MekBxPzKyiz2ziv
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="oops-dmesg-nocolor-decoded.txt"
Content-Transfer-Encoding: 8bit

[    0.000000] Linux version 6.9.0-rc5-maxz (root@max-computer) (gcc (Gentoo 13.2.1_p20240210 p14) 13.2.1 20240210, GNU ld (Gentoo 2.41 p5) 2.41.0) #4 SMP Sat Apr 27 19:19:48 CEST 2024
[    0.000000] Kernel is locked down from Kernel configuration; see man kernel_lockdown.7
[    0.000000] Command line:
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000000a0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000009cfefff] usable
[    0.000000] BIOS-e820: [mem 0x0000000009cff000-0x0000000009ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x000000000a000000-0x000000000a1fffff] usable
[    0.000000] BIOS-e820: [mem 0x000000000a200000-0x000000000a213fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000000a214000-0x000000000affffff] usable
[    0.000000] BIOS-e820: [mem 0x000000000b000000-0x000000000b01ffff] reserved
[    0.000000] BIOS-e820: [mem 0x000000000b020000-0x00000000c327ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000c3280000-0x00000000c3280fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000c3281000-0x00000000ca228fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ca229000-0x00000000ca5dffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ca5e0000-0x00000000ca62bfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000ca62c000-0x00000000cad3dfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cad3e000-0x00000000cb9fefff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000cb9ff000-0x00000000ccffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cd000000-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fd200000-0x00000000fd2fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fd600000-0x00000000fd7fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fea00000-0x00000000fea0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feb80000-0x00000000fec01fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec10fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec30000-0x00000000fec30fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed40000-0x00000000fed44fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed8ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fedc2000-0x00000000fedcffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fedd4000-0x00000000fedd5fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000102f2fffff] usable
[    0.000000] BIOS-e820: [mem 0x000000102f300000-0x000000102fffffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] APIC: Static calls initialized
[    0.000000] e820: update [mem 0xc075d018-0xc076b057] usable ==> usable
[    0.000000] e820: update [mem 0xc0743018-0xc075c457] usable ==> usable
[    0.000000] extended physical RAM map:
[    0.000000] reserve setup_data: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] reserve setup_data: [mem 0x00000000000a0000-0x00000000000fffff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000000100000-0x0000000009cfefff] usable
[    0.000000] reserve setup_data: [mem 0x0000000009cff000-0x0000000009ffffff] reserved
[    0.000000] reserve setup_data: [mem 0x000000000a000000-0x000000000a1fffff] usable
[    0.000000] reserve setup_data: [mem 0x000000000a200000-0x000000000a213fff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x000000000a214000-0x000000000affffff] usable
[    0.000000] reserve setup_data: [mem 0x000000000b000000-0x000000000b01ffff] reserved
[    0.000000] reserve setup_data: [mem 0x000000000b020000-0x00000000c0743017] usable
[    0.000000] reserve setup_data: [mem 0x00000000c0743018-0x00000000c075c457] usable
[    0.000000] reserve setup_data: [mem 0x00000000c075c458-0x00000000c075d017] usable
[    0.000000] reserve setup_data: [mem 0x00000000c075d018-0x00000000c076b057] usable
[    0.000000] reserve setup_data: [mem 0x00000000c076b058-0x00000000c327ffff] usable
[    0.000000] reserve setup_data: [mem 0x00000000c3280000-0x00000000c3280fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000c3281000-0x00000000ca228fff] usable
[    0.000000] reserve setup_data: [mem 0x00000000ca229000-0x00000000ca5dffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000ca5e0000-0x00000000ca62bfff] ACPI data
[    0.000000] reserve setup_data: [mem 0x00000000ca62c000-0x00000000cad3dfff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x00000000cad3e000-0x00000000cb9fefff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000cb9ff000-0x00000000ccffffff] usable
[    0.000000] reserve setup_data: [mem 0x00000000cd000000-0x00000000cfffffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fd200000-0x00000000fd2fffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fd600000-0x00000000fd7fffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fea00000-0x00000000fea0ffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000feb80000-0x00000000fec01fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fec10000-0x00000000fec10fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fec30000-0x00000000fec30fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fed00000-0x00000000fed00fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fed40000-0x00000000fed44fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fed80000-0x00000000fed8ffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fedc2000-0x00000000fedcffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fedd4000-0x00000000fedd5fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000100000000-0x000000102f2fffff] usable
[    0.000000] reserve setup_data: [mem 0x000000102f300000-0x000000102fffffff] reserved
[    0.000000] efi: EFI v2.7 by American Megatrends
[    0.000000] efi: ACPI=0xca62b000 ACPI 2.0=0xca62b014 TPMFinalLog=0xcacf3000 SMBIOS=0xcb802000 SMBIOS 3.0=0xcb801000 MEMATTR=0xc673f198 ESRT=0xc673ae18 RNG=0xca612c18 TPMEventLog=0xc076c018
[    0.000000] random: crng init done
[    0.000000] efi: Remove mem101: MMIO range=[0xf8000000-0xfbffffff] (64MB) from e820 map
[    0.000000] e820: remove [mem 0xf8000000-0xfbffffff] reserved
[    0.000000] efi: Remove mem102: MMIO range=[0xfd200000-0xfd2fffff] (1MB) from e820 map
[    0.000000] e820: remove [mem 0xfd200000-0xfd2fffff] reserved
[    0.000000] efi: Remove mem103: MMIO range=[0xfd600000-0xfd7fffff] (2MB) from e820 map
[    0.000000] e820: remove [mem 0xfd600000-0xfd7fffff] reserved
[    0.000000] efi: Not removing mem104: MMIO range=[0xfea00000-0xfea0ffff] (64KB) from e820 map
[    0.000000] efi: Remove mem105: MMIO range=[0xfeb80000-0xfec01fff] (0MB) from e820 map
[    0.000000] e820: remove [mem 0xfeb80000-0xfec01fff] reserved
[    0.000000] efi: Not removing mem106: MMIO range=[0xfec10000-0xfec10fff] (4KB) from e820 map
[    0.000000] efi: Not removing mem107: MMIO range=[0xfec30000-0xfec30fff] (4KB) from e820 map
[    0.000000] efi: Not removing mem108: MMIO range=[0xfed00000-0xfed00fff] (4KB) from e820 map
[    0.000000] efi: Not removing mem109: MMIO range=[0xfed40000-0xfed44fff] (20KB) from e820 map
[    0.000000] efi: Not removing mem110: MMIO range=[0xfed80000-0xfed8ffff] (64KB) from e820 map
[    0.000000] efi: Not removing mem111: MMIO range=[0xfedc2000-0xfedcffff] (56KB) from e820 map
[    0.000000] efi: Not removing mem112: MMIO range=[0xfedd4000-0xfedd5fff] (8KB) from e820 map
[    0.000000] efi: Remove mem113: MMIO range=[0xff000000-0xffffffff] (16MB) from e820 map
[    0.000000] e820: remove [mem 0xff000000-0xffffffff] reserved
[    0.000000] SMBIOS 3.3.0 present.
[    0.000000] DMI: System manufacturer System Product Name/PRIME B450-PLUS, BIOS 4401 09/04/2023
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3792.788 MHz processor
[    0.000382] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000384] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000393] last_pfn = 0x102f300 max_arch_pfn = 0x400000000
[    0.000398] MTRR map: 7 entries (3 fixed + 4 variable; max 20), built from 9 variable MTRRs
[    0.000400] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT
[    0.000614] e820: update [mem 0xca7a0000-0xca7affff] usable ==> reserved
[    0.000619] e820: update [mem 0xd0000000-0xffffffff] usable ==> reserved
[    0.000623] last_pfn = 0xcd000 max_arch_pfn = 0x400000000
[    0.003525] esrt: Reserving ESRT space from 0x00000000c673ae18 to 0x00000000c673ae50.
[    0.003533] e820: update [mem 0xc673a000-0xc673afff] usable ==> reserved
[    0.003556] Using GB pages for direct mapping
[    0.004051] Secure boot disabled
[    0.004053] ACPI: Early table checksum verification disabled
[    0.004056] ACPI: RSDP 0x00000000CA62B014 000024 (v02 ALASKA)
[    0.004059] ACPI: XSDT 0x00000000CA62A728 0000AC (v01 ALASKA A M I    01072009 AMI  01000013)
[    0.004063] ACPI: FACP 0x00000000CA623000 000114 (v06 ALASKA A M I    01072009 AMI  00010013)
[    0.004067] ACPI: DSDT 0x00000000CA617000 00B702 (v02 ALASKA A M I    01072009 INTL 20120913)
[    0.004069] ACPI: FACS 0x00000000CAD23000 000040
[    0.004070] ACPI: SSDT 0x00000000CA629000 00092A (v02 AMD    AmdTable 00000002 MSFT 04000000)
[    0.004072] ACPI: SSDT 0x00000000CA625000 003CB6 (v02 AMD    AMD AOD  00000001 INTL 20120913)
[    0.004074] ACPI: SSDT 0x00000000CA624000 000164 (v02 ALASKA CPUSSDT  01072009 AMI  01072009)
[    0.004075] ACPI: FIDT 0x00000000CA616000 00009C (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.004077] ACPI: FPDT 0x00000000CA5FE000 000044 (v01 ALASKA A M I    01072009 AMI  01000013)
[    0.004078] ACPI: MCFG 0x00000000CA614000 00003C (v01 ALASKA A M I    01072009 MSFT 00010013)
[    0.004080] ACPI: HPET 0x00000000CA613000 000038 (v01 ALASKA A M I    01072009 AMI  00000005)
[    0.004082] ACPI: IVRS 0x00000000CA611000 0000D0 (v02 AMD    AmdTable 00000001 AMD  00000001)
[    0.004083] ACPI: TPM2 0x00000000CA610000 00004C (v03 ALASKA A M I    00000001 AMI  00000000)
[    0.004085] ACPI: PCCT 0x00000000CA60F000 00006E (v02 AMD    AmdTable 00000001 AMD  00000001)
[    0.004087] ACPI: SSDT 0x00000000CA608000 00603B (v02 AMD    AmdTable 00000001 AMD  00000001)
[    0.004088] ACPI: CRAT 0x00000000CA606000 0016D0 (v01 AMD    AmdTable 00000001 AMD  00000001)
[    0.004090] ACPI: CDIT 0x00000000CA605000 000029 (v01 AMD    AmdTable 00000001 AMD  00000001)
[    0.004091] ACPI: SSDT 0x00000000CA601000 0037DC (v02 AMD    MYRTLE   00000001 INTL 20120913)
[    0.004093] ACPI: SSDT 0x00000000CA600000 0000BF (v01 AMD    AmdTable 00001000 INTL 20120913)
[    0.004095] ACPI: APIC 0x00000000CA5FF000 00015E (v04 ALASKA A M I    01072009 AMI  00010013)
[    0.004096] ACPI: Reserving FACP table memory at [mem 0xca623000-0xca623113]
[    0.004097] ACPI: Reserving DSDT table memory at [mem 0xca617000-0xca622701]
[    0.004098] ACPI: Reserving FACS table memory at [mem 0xcad23000-0xcad2303f]
[    0.004099] ACPI: Reserving SSDT table memory at [mem 0xca629000-0xca629929]
[    0.004099] ACPI: Reserving SSDT table memory at [mem 0xca625000-0xca628cb5]
[    0.004100] ACPI: Reserving SSDT table memory at [mem 0xca624000-0xca624163]
[    0.004100] ACPI: Reserving FIDT table memory at [mem 0xca616000-0xca61609b]
[    0.004101] ACPI: Reserving FPDT table memory at [mem 0xca5fe000-0xca5fe043]
[    0.004102] ACPI: Reserving MCFG table memory at [mem 0xca614000-0xca61403b]
[    0.004102] ACPI: Reserving HPET table memory at [mem 0xca613000-0xca613037]
[    0.004103] ACPI: Reserving IVRS table memory at [mem 0xca611000-0xca6110cf]
[    0.004103] ACPI: Reserving TPM2 table memory at [mem 0xca610000-0xca61004b]
[    0.004104] ACPI: Reserving PCCT table memory at [mem 0xca60f000-0xca60f06d]
[    0.004105] ACPI: Reserving SSDT table memory at [mem 0xca608000-0xca60e03a]
[    0.004105] ACPI: Reserving CRAT table memory at [mem 0xca606000-0xca6076cf]
[    0.004106] ACPI: Reserving CDIT table memory at [mem 0xca605000-0xca605028]
[    0.004107] ACPI: Reserving SSDT table memory at [mem 0xca601000-0xca6047db]
[    0.004107] ACPI: Reserving SSDT table memory at [mem 0xca600000-0xca6000be]
[    0.004108] ACPI: Reserving APIC table memory at [mem 0xca5ff000-0xca5ff15d]
[    0.004181] No NUMA configuration found
[    0.004182] Faking a node at [mem 0x0000000000000000-0x000000102f2fffff]
[    0.004185] NODE_DATA(0) allocated [mem 0x102f2fc000-0x102f2fffff]
[    0.004230] Zone ranges:
[    0.004230]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.004231]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.004232]   Normal   [mem 0x0000000100000000-0x000000102f2fffff]
[    0.004233] Movable zone start for each node
[    0.004234] Early memory node ranges
[    0.004234]   node   0: [mem 0x0000000000001000-0x000000000009ffff]
[    0.004235]   node   0: [mem 0x0000000000100000-0x0000000009cfefff]
[    0.004236]   node   0: [mem 0x000000000a000000-0x000000000a1fffff]
[    0.004236]   node   0: [mem 0x000000000a214000-0x000000000affffff]
[    0.004237]   node   0: [mem 0x000000000b020000-0x00000000c327ffff]
[    0.004237]   node   0: [mem 0x00000000c3281000-0x00000000ca228fff]
[    0.004238]   node   0: [mem 0x00000000cb9ff000-0x00000000ccffffff]
[    0.004239]   node   0: [mem 0x0000000100000000-0x000000102f2fffff]
[    0.004242] Initmem setup node 0 [mem 0x0000000000001000-0x000000102f2fffff]
[    0.004247] On node 0, zone DMA: 1 pages in unavailable ranges
[    0.004266] On node 0, zone DMA: 96 pages in unavailable ranges
[    0.004444] On node 0, zone DMA32: 769 pages in unavailable ranges
[    0.004461] On node 0, zone DMA32: 20 pages in unavailable ranges
[    0.008359] On node 0, zone DMA32: 32 pages in unavailable ranges
[    0.008530] On node 0, zone DMA32: 1 pages in unavailable ranges
[    0.008597] On node 0, zone DMA32: 6102 pages in unavailable ranges
[    0.099478] On node 0, zone Normal: 12288 pages in unavailable ranges
[    0.099499] On node 0, zone Normal: 3328 pages in unavailable ranges
[    0.099737] ACPI: PM-Timer IO Port: 0x808
[    0.099744] CPU topo: Ignoring hot-pluggable APIC ID 0 in present package.
[    0.099747] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.099758] IOAPIC[0]: apic_id 25, version 33, address 0xfec00000, GSI 0-23
[    0.099764] IOAPIC[1]: apic_id 26, version 33, address 0xfec01000, GSI 24-55
[    0.099766] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.099767] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.099770] ACPI: Using ACPI (MADT) for SMP configuration information
[    0.099771] ACPI: HPET id: 0x10228201 base: 0xfed00000
[    0.099778] CPU topo: Max. logical packages:   1
[    0.099778] CPU topo: Max. logical dies:       1
[    0.099779] CPU topo: Max. dies per package:   1
[    0.099782] CPU topo: Max. threads per core:   2
[    0.099783] CPU topo: Num. cores per package:    12
[    0.099784] CPU topo: Num. threads per package:  24
[    0.099784] CPU topo: Allowing 24 present CPUs plus 0 hotplug CPUs
[    0.099785] CPU topo: Rejected CPUs 8
[    0.099815] [mem 0xd0000000-0xfe9fffff] available for PCI devices
[    0.099819] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
[    0.105207] setup_percpu: NR_CPUS:24 nr_cpumask_bits:24 nr_cpu_ids:24 nr_node_ids:1
[    0.105786] percpu: Embedded 63 pages/cpu s134760 r8192 d115096 u262144
[    0.105793] pcpu-alloc: s134760 r8192 d115096 u262144 alloc=1*2097152
[    0.105794] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 [0] 08 09 10 11 12 13 14 15
[    0.105800] pcpu-alloc: [0] 16 17 18 19 20 21 22 23
[    0.105825] Kernel command line: root=PARTUUID=980432ad-0b63-4c9a-b20a-567aabeacb91 rootfstype=ext4 libata.allow_tpm=1
[    0.110919] Dentry cache hash table entries: 8388608 (order: 14, 67108864 bytes, linear)
[    0.113471] Inode-cache hash table entries: 4194304 (order: 13, 33554432 bytes, linear)
[    0.113608] Fallback order for Node 0: 0
[    0.113614] Built 1 zonelists, mobility grouping on.  Total pages: 16492628
[    0.113614] Policy zone: Normal
[    0.113808] mem auto-init: stack:all(zero), heap alloc:on, heap free:on
[    0.113809] mem auto-init: clearing system memory may take some time...
[    0.113842] software IO TLB: area num 32.
[    5.284145] Memory: 65652692K/67018316K available (24576K kernel code, 4609K rwdata, 8296K rodata, 2056K init, 2616K bss, 1365364K reserved, 0K cma-reserved)
[    5.284845] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=24, Nodes=1
[    5.284995] rcu: Hierarchical RCU implementation.
[    5.284997] rcu: RCU calculated value of scheduler-enlistment delay is 100 jiffies.
[    5.285006] NR_IRQS: 4352, nr_irqs: 1160, preallocated irqs: 16
[    5.285208] rcu: srcu_init: Setting srcu_struct sizes based on contention.
[    5.285309] kfence: initialized - using 2097152 bytes for 255 objects at 0x(____ptrval____)-0x(____ptrval____)
[    5.285341] Console: colour dummy device 80x25
[    5.285342] printk: legacy console [tty0] enabled
[    5.285550] ACPI: Core revision 20230628
[    5.285676] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 133484873504 ns
[    5.285695] APIC: Switch to symmetric I/O mode setup
[    5.286528] AMD-Vi: Using global IVHD EFR:0x0, EFR2:0x0
[    5.605018] x2apic: IRQ remapping doesn't support X2APIC mode
[    5.605032] APIC: Switched APIC routing to: physical flat
[    5.605653] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    5.609698] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x6d57781ce72, max_idle_ns: 881591098239 ns
[    5.609703] Calibrating delay loop (skipped), value calculated using timer frequency.. 7585.57 BogoMIPS (lpj=3792788)
[    5.609715] Zenbleed: please update your microcode for the most optimal fix
[    5.609719] x86/cpu: User Mode Instruction Prevention (UMIP) activated
[    5.609762] LVT offset 1 assigned for vector 0xf9
[    5.609879] LVT offset 2 assigned for vector 0xf4
[    5.609912] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 512
[    5.609914] Last level dTLB entries: 4KB 2048, 2MB 2048, 4MB 1024, 1GB 0
[    5.609916] process: using mwait in idle threads
[    5.609918] Spectre V1 : Mitigation: usercopy/swapgs barriers and __user pointer sanitization
[    5.609921] Spectre V2 : Mitigation: Retpolines
[    5.609922] Spectre V2 : Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch
[    5.609924] Spectre V2 : Spectre v2 / SpectreRSB : Filling RSB on VMEXIT
[    5.609925] Spectre V2 : Enabling Speculation Barrier for firmware calls
[    5.609926] RETBleed: Mitigation: untrained return thunk
[    5.609929] Spectre V2 : mitigation: Enabling conditional Indirect Branch Prediction Barrier
[    5.609930] Spectre V2 : Selecting STIBP always-on mode to complement retbleed mitigation
[    5.609932] Spectre V2 : User space: Mitigation: STIBP always-on protection
[    5.609934] Speculative Store Bypass: Mitigation: Speculative Store Bypass disabled via prctl
[    5.609936] Speculative Return Stack Overflow: Mitigation: Safe RET
[    5.609941] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
[    5.609943] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    5.609944] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    5.609946] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    5.609947] x86/fpu: Enabled xstate features 0x7, context size is 832 bytes, using 'compacted' format.
[    5.625158] Freeing SMP alternatives memory: 40K
[    5.625162] pid_max: default: 32768 minimum: 301
[    5.633762] LSM: initializing lsm=lockdown,capability,landlock,yama
[    5.633810] landlock: Up and running.
[    5.633812] Yama: becoming mindful.
[    5.633852] Mount-cache hash table entries: 131072 (order: 8, 1048576 bytes, linear)
[    5.633858] Mountpoint-cache hash table entries: 131072 (order: 8, 1048576 bytes, linear)
[    5.736688] smpboot: CPU0: AMD Ryzen 9 3900X 12-Core Processor (family: 0x17, model: 0x71, stepping: 0x0)
[    5.736701] Performance Events: Fam17h+ core perfctr, AMD PMU driver.
[    5.736701] ... version:                0
[    5.736701] ... bit width:              48
[    5.736701] ... generic registers:      6
[    5.736701] ... value mask:             0000ffffffffffff
[    5.736701] ... max period:             00007fffffffffff
[    5.736701] ... fixed-purpose events:   0
[    5.736701] ... event mask:             000000000000003f
[    5.736701] signal: max sigframe size: 1776
[    5.736701] rcu: Hierarchical SRCU implementation.
[    5.736701] rcu: 	Max phase no-delay instances is 400.
[    5.736701] smp: Bringing up secondary CPUs ...
[    5.736701] smpboot: x86: Booting SMP configuration:
[    5.736701] .... node  #0, CPUs:        #1  #2  #3  #4  #5  #6  #7  #8  #9 #10 #11 #12 #13 #14 #15 #16 #17 #18 #19 #20 #21 #22 #23
[    5.752780] Spectre V2 : Update user space SMT mitigation: STIBP always-on
[    5.764720] smp: Brought up 1 node, 24 CPUs
[    5.764721] smpboot: Total of 24 processors activated (182053.82 BogoMIPS)
[    5.768349] devtmpfs: initialized
[    5.769454] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
[    5.769454] futex hash table entries: 8192 (order: 7, 524288 bytes, linear)
[    5.769454] pinctrl core: initialized pinctrl subsystem
[    5.769753] NET: Registered PF_NETLINK/PF_ROUTE protocol family
[    5.769902] audit: initializing netlink subsys (disabled)
[    5.769908] audit: type=2000 audit(1714287612.167:1): state=initialized audit_enabled=0 res=1
[    5.769908] thermal_sys: Registered thermal governor 'bang_bang'
[    5.769908] thermal_sys: Registered thermal governor 'step_wise'
[    5.769908] thermal_sys: Registered thermal governor 'user_space'
[    5.769908] cpuidle: using governor ladder
[    5.769908] cpuidle: using governor menu
[    5.769908] Detected 1 PCC Subspaces
[    5.769908] Registering PCC driver as Mailbox controller
[    5.769908] PCI: ECAM [mem 0xf8000000-0xfbffffff] (base 0xf8000000) for domain 0000 [bus 00-3f]
[    5.769908] PCI: not using ECAM ([mem 0xf8000000-0xfbffffff] not reserved)
[    5.769908] PCI: Using configuration type 1 for base access
[    5.769908] PCI: Using configuration type 1 for extended access
[    5.769937] HugeTLB: registered 1.00 GiB page size, pre-allocated 0 pages
[    5.769937] HugeTLB: 16380 KiB vmemmap can be freed for a 1.00 GiB page
[    5.769937] HugeTLB: registered 2.00 MiB page size, pre-allocated 0 pages
[    5.769937] HugeTLB: 28 KiB vmemmap can be freed for a 2.00 MiB page
[    5.769937] Demotion targets for Node 0: null
[    5.769937] cryptd: max_cpu_qlen set to 1000
[    5.770764] ACPI: Added _OSI(Module Device)
[    5.770768] ACPI: Added _OSI(Processor Device)
[    5.770770] ACPI: Added _OSI(3.0 _SCP Extensions)
[    5.770773] ACPI: Added _OSI(Processor Aggregator Device)
[    5.781259] ACPI: 7 ACPI AML tables successfully acquired and loaded
[    5.783379] ACPI: [Firmware Bug]: BIOS _OSI(Linux) query ignored
[    5.783723] ACPI: _OSC evaluation for CPUs failed, trying _PDC
[    5.784257] ACPI: Interpreter enabled
[    5.784263] ACPI: PM: (supports S0 S5)
[    5.784266] ACPI: Using IOAPIC for interrupt routing
[    5.784702] PCI: ECAM [mem 0xf8000000-0xfbffffff] (base 0xf8000000) for domain 0000 [bus 00-3f]
[    5.784745] PCI: ECAM [mem 0xf8000000-0xfbffffff] reserved as ACPI motherboard resource
[    5.784757] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    5.784760] PCI: Ignoring E820 reservations for host bridge windows
[    5.785056] ACPI: Enabled 4 GPEs in block 00 to 1F
[    5.812132] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    5.812140] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI HPX-Type3]
[    5.812240] acpi PNP0A08:00: _OSC: platform does not support [PME LTR]
[    5.812432] acpi PNP0A08:00: _OSC: OS now controls [PCIeCapability]
[    5.812443] acpi PNP0A08:00: [Firmware Info]: ECAM [mem 0xf8000000-0xfbffffff] for domain 0000 [bus 00-3f] only partially covers this bridge
[    5.812812] PCI host bridge to bus 0000:00
[    5.812815] pci_bus 0000:00: root bus resource [io  0x0000-0x03af window]
[    5.812820] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7 window]
[    5.812823] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df window]
[    5.812827] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    5.812830] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000dffff window]
[    5.812834] pci_bus 0000:00: root bus resource [mem 0xd0000000-0xfec2ffff window]
[    5.812838] pci_bus 0000:00: root bus resource [mem 0xfee00000-0xffffffff window]
[    5.812842] pci_bus 0000:00: root bus resource [bus 00-ff]
[    5.812863] pci 0000:00:00.0: [1022:1480] type 00 class 0x060000 conventional PCI endpoint
[    5.812965] pci 0000:00:00.2: [1022:1481] type 00 class 0x080600 conventional PCI endpoint
[    5.813068] pci 0000:00:01.0: [1022:1482] type 00 class 0x060000 conventional PCI endpoint
[    5.813144] pci 0000:00:01.3: [1022:1483] type 01 class 0x060400 PCIe Root Port
[    5.813167] pci 0000:00:01.3: PCI bridge to [bus 01-07]
[    5.813174] pci 0000:00:01.3:   bridge window [io  0xf000-0xffff]
[    5.813179] pci 0000:00:01.3:   bridge window [mem 0xfcd00000-0xfcefffff]
[    5.813197] pci 0000:00:01.3: enabling Extended Tags
[    5.813261] pci 0000:00:01.3: PME# supported from D0 D3hot D3cold
[    5.813436] pci 0000:00:02.0: [1022:1482] type 00 class 0x060000 conventional PCI endpoint
[    5.813514] pci 0000:00:03.0: [1022:1482] type 00 class 0x060000 conventional PCI endpoint
[    5.813586] pci 0000:00:03.1: [1022:1483] type 01 class 0x060400 PCIe Root Port
[    5.813607] pci 0000:00:03.1: PCI bridge to [bus 08-0a]
[    5.813613] pci 0000:00:03.1:   bridge window [io  0xe000-0xefff]
[    5.813618] pci 0000:00:03.1:   bridge window [mem 0xfcb00000-0xfccfffff]
[    5.813627] pci 0000:00:03.1:   bridge window [mem 0xe0000000-0xf01fffff 64bit pref]
[    5.813688] pci 0000:00:03.1: PME# supported from D0 D3hot D3cold
[    5.813803] pci 0000:00:04.0: [1022:1482] type 00 class 0x060000 conventional PCI endpoint
[    5.813880] pci 0000:00:05.0: [1022:1482] type 00 class 0x060000 conventional PCI endpoint
[    5.813955] pci 0000:00:07.0: [1022:1482] type 00 class 0x060000 conventional PCI endpoint
[    5.814026] pci 0000:00:07.1: [1022:1484] type 01 class 0x060400 PCIe Root Port
[    5.814046] pci 0000:00:07.1: PCI bridge to [bus 0b]
[    5.814063] pci 0000:00:07.1: enabling Extended Tags
[    5.814111] pci 0000:00:07.1: PME# supported from D0 D3hot D3cold
[    5.814209] pci 0000:00:08.0: [1022:1482] type 00 class 0x060000 conventional PCI endpoint
[    5.814282] pci 0000:00:08.1: [1022:1484] type 01 class 0x060400 PCIe Root Port
[    5.814303] pci 0000:00:08.1: PCI bridge to [bus 0c]
[    5.814310] pci 0000:00:08.1:   bridge window [mem 0xfc800000-0xfcafffff]
[    5.814325] pci 0000:00:08.1: enabling Extended Tags
[    5.814376] pci 0000:00:08.1: PME# supported from D0 D3hot D3cold
[    5.814489] pci 0000:00:08.3: [1022:1484] type 01 class 0x060400 PCIe Root Port
[    5.814510] pci 0000:00:08.3: PCI bridge to [bus 0d]
[    5.814517] pci 0000:00:08.3:   bridge window [mem 0xfcf00000-0xfcffffff]
[    5.814532] pci 0000:00:08.3: enabling Extended Tags
[    5.814583] pci 0000:00:08.3: PME# supported from D0 D3hot D3cold
[    5.814703] pci 0000:00:14.0: [1022:790b] type 00 class 0x0c0500 conventional PCI endpoint
[    5.814826] pci 0000:00:14.3: [1022:790e] type 00 class 0x060100 conventional PCI endpoint
[    5.814963] pci 0000:00:18.0: [1022:1440] type 00 class 0x060000 conventional PCI endpoint
[    5.815013] pci 0000:00:18.1: [1022:1441] type 00 class 0x060000 conventional PCI endpoint
[    5.815059] pci 0000:00:18.2: [1022:1442] type 00 class 0x060000 conventional PCI endpoint
[    5.815103] pci 0000:00:18.3: [1022:1443] type 00 class 0x060000 conventional PCI endpoint
[    5.815148] pci 0000:00:18.4: [1022:1444] type 00 class 0x060000 conventional PCI endpoint
[    5.815193] pci 0000:00:18.5: [1022:1445] type 00 class 0x060000 conventional PCI endpoint
[    5.815238] pci 0000:00:18.6: [1022:1446] type 00 class 0x060000 conventional PCI endpoint
[    5.815282] pci 0000:00:18.7: [1022:1447] type 00 class 0x060000 conventional PCI endpoint
[    5.815383] pci 0000:01:00.0: [1022:43d5] type 00 class 0x0c0330 PCIe Legacy Endpoint
[    5.815406] pci 0000:01:00.0: BAR 0 [mem 0xfcea0000-0xfcea7fff 64bit]
[    5.815454] pci 0000:01:00.0: enabling Extended Tags
[    5.815521] pci 0000:01:00.0: PME# supported from D3hot D3cold
[    5.815682] pci 0000:01:00.1: [1022:43c8] type 00 class 0x010601 PCIe Legacy Endpoint
[    5.815740] pci 0000:01:00.1: BAR 5 [mem 0xfce80000-0xfce9ffff]
[    5.815751] pci 0000:01:00.1: ROM [mem 0xfce00000-0xfce7ffff pref]
[    5.815761] pci 0000:01:00.1: enabling Extended Tags
[    5.815811] pci 0000:01:00.1: PME# supported from D3hot D3cold
[    5.815894] pci 0000:01:00.2: [1022:43c6] type 01 class 0x060400 PCIe Switch Upstream Port
[    5.815929] pci 0000:01:00.2: PCI bridge to [bus 02-07]
[    5.815938] pci 0000:01:00.2:   bridge window [io  0xf000-0xffff]
[    5.815944] pci 0000:01:00.2:   bridge window [mem 0xfcd00000-0xfcdfffff]
[    5.815969] pci 0000:01:00.2: enabling Extended Tags
[    5.816025] pci 0000:01:00.2: PME# supported from D3hot D3cold
[    5.816142] pci 0000:00:01.3: PCI bridge to [bus 01-07]
[    5.816208] pci 0000:02:00.0: [1022:43c7] type 01 class 0x060400 PCIe Switch Downstream Port
[    5.816244] pci 0000:02:00.0: PCI bridge to [bus 03]
[    5.816253] pci 0000:02:00.0:   bridge window [io  0xf000-0xffff]
[    5.816258] pci 0000:02:00.0:   bridge window [mem 0xfcd00000-0xfcdfffff]
[    5.816286] pci 0000:02:00.0: enabling Extended Tags
[    5.816362] pci 0000:02:00.0: PME# supported from D3hot D3cold
[    5.816477] pci 0000:02:01.0: [1022:43c7] type 01 class 0x060400 PCIe Switch Downstream Port
[    5.816513] pci 0000:02:01.0: PCI bridge to [bus 04]
[    5.816549] pci 0000:02:01.0: enabling Extended Tags
[    5.816622] pci 0000:02:01.0: PME# supported from D3hot D3cold
[    5.816739] pci 0000:02:04.0: [1022:43c7] type 01 class 0x060400 PCIe Switch Downstream Port
[    5.816775] pci 0000:02:04.0: PCI bridge to [bus 05]
[    5.816811] pci 0000:02:04.0: enabling Extended Tags
[    5.816885] pci 0000:02:04.0: PME# supported from D3hot D3cold
[    5.817004] pci 0000:02:06.0: [1022:43c7] type 01 class 0x060400 PCIe Switch Downstream Port
[    5.817040] pci 0000:02:06.0: PCI bridge to [bus 06]
[    5.817076] pci 0000:02:06.0: enabling Extended Tags
[    5.817150] pci 0000:02:06.0: PME# supported from D3hot D3cold
[    5.817265] pci 0000:02:07.0: [1022:43c7] type 01 class 0x060400 PCIe Switch Downstream Port
[    5.817301] pci 0000:02:07.0: PCI bridge to [bus 07]
[    5.817337] pci 0000:02:07.0: enabling Extended Tags
[    5.817410] pci 0000:02:07.0: PME# supported from D3hot D3cold
[    5.817536] pci 0000:01:00.2: PCI bridge to [bus 02-07]
[    5.817620] pci 0000:03:00.0: [10ec:8168] type 00 class 0x020000 PCIe Endpoint
[    5.817653] pci 0000:03:00.0: BAR 0 [io  0xf000-0xf0ff]
[    5.817695] pci 0000:03:00.0: BAR 2 [mem 0xfcd04000-0xfcd04fff 64bit]
[    5.817723] pci 0000:03:00.0: BAR 4 [mem 0xfcd00000-0xfcd03fff 64bit]
[    5.817900] pci 0000:03:00.0: supports D1 D2
[    5.817903] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    5.818157] pci 0000:02:00.0: PCI bridge to [bus 03]
[    5.818212] pci 0000:02:01.0: PCI bridge to [bus 04]
[    5.818267] pci 0000:02:04.0: PCI bridge to [bus 05]
[    5.818321] pci 0000:02:06.0: PCI bridge to [bus 06]
[    5.818378] pci 0000:02:07.0: PCI bridge to [bus 07]
[    5.818467] pci 0000:08:00.0: [1002:1478] type 01 class 0x060400 PCIe Switch Upstream Port
[    5.818485] pci 0000:08:00.0: BAR 0 [mem 0xfcc00000-0xfcc03fff]
[    5.818503] pci 0000:08:00.0: PCI bridge to [bus 09-0a]
[    5.818510] pci 0000:08:00.0:   bridge window [io  0xe000-0xefff]
[    5.818516] pci 0000:08:00.0:   bridge window [mem 0xfcb00000-0xfcbfffff]
[    5.818528] pci 0000:08:00.0:   bridge window [mem 0xe0000000-0xf01fffff 64bit pref]
[    5.818620] pci 0000:08:00.0: PME# supported from D0 D3hot D3cold
[    5.818666] pci 0000:08:00.0: 126.016 Gb/s available PCIe bandwidth, limited by 8.0 GT/s PCIe x16 link at 0000:00:03.1 (capable of 252.048 Gb/s with 16.0 GT/s PCIe x16 link)
[    5.818770] pci 0000:00:03.1: PCI bridge to [bus 08-0a]
[    5.818826] pci 0000:09:00.0: [1002:1479] type 01 class 0x060400 PCIe Switch Downstream Port
[    5.818857] pci 0000:09:00.0: PCI bridge to [bus 0a]
[    5.818865] pci 0000:09:00.0:   bridge window [io  0xe000-0xefff]
[    5.818870] pci 0000:09:00.0:   bridge window [mem 0xfcb00000-0xfcbfffff]
[    5.818882] pci 0000:09:00.0:   bridge window [mem 0xe0000000-0xf01fffff 64bit pref]
[    5.818975] pci 0000:09:00.0: PME# supported from D0 D3hot D3cold
[    5.819114] pci 0000:08:00.0: PCI bridge to [bus 09-0a]
[    5.819174] pci 0000:0a:00.0: [1002:731f] type 00 class 0x030000 PCIe Legacy Endpoint
[    5.819194] pci 0000:0a:00.0: BAR 0 [mem 0xe0000000-0xefffffff 64bit pref]
[    5.819208] pci 0000:0a:00.0: BAR 2 [mem 0xf0000000-0xf01fffff 64bit pref]
[    5.819219] pci 0000:0a:00.0: BAR 4 [io  0xe000-0xe0ff]
[    5.819229] pci 0000:0a:00.0: BAR 5 [mem 0xfcb00000-0xfcb7ffff]
[    5.819239] pci 0000:0a:00.0: ROM [mem 0xfcb80000-0xfcb9ffff pref]
[    5.819284] pci 0000:0a:00.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    5.819361] pci 0000:0a:00.0: PME# supported from D1 D2 D3hot D3cold
[    5.819418] pci 0000:0a:00.0: 126.016 Gb/s available PCIe bandwidth, limited by 8.0 GT/s PCIe x16 link at 0000:00:03.1 (capable of 252.048 Gb/s with 16.0 GT/s PCIe x16 link)
[    5.819503] pci 0000:0a:00.1: [1002:ab38] type 00 class 0x040300 PCIe Legacy Endpoint
[    5.819520] pci 0000:0a:00.1: BAR 0 [mem 0xfcba0000-0xfcba3fff]
[    5.819625] pci 0000:0a:00.1: PME# supported from D1 D2 D3hot D3cold
[    5.819730] pci 0000:09:00.0: PCI bridge to [bus 0a]
[    5.819792] pci 0000:0b:00.0: [1022:148a] type 00 class 0x130000 PCIe Endpoint
[    5.819825] pci 0000:0b:00.0: enabling Extended Tags
[    5.819970] pci 0000:00:07.1: PCI bridge to [bus 0b]
[    5.820020] pci 0000:0c:00.0: [1022:1485] type 00 class 0x130000 PCIe Endpoint
[    5.820058] pci 0000:0c:00.0: enabling Extended Tags
[    5.820212] pci 0000:0c:00.1: [1022:1486] type 00 class 0x108000 PCIe Endpoint
[    5.820232] pci 0000:0c:00.1: BAR 2 [mem 0xfc900000-0xfc9fffff]
[    5.820246] pci 0000:0c:00.1: BAR 5 [mem 0xfca08000-0xfca09fff]
[    5.820257] pci 0000:0c:00.1: enabling Extended Tags
[    5.820389] pci 0000:0c:00.3: [1022:149c] type 00 class 0x0c0330 PCIe Endpoint
[    5.820405] pci 0000:0c:00.3: BAR 0 [mem 0xfc800000-0xfc8fffff 64bit]
[    5.820439] pci 0000:0c:00.3: enabling Extended Tags
[    5.820492] pci 0000:0c:00.3: PME# supported from D0 D3hot D3cold
[    5.820595] pci 0000:0c:00.4: [1022:1487] type 00 class 0x040300 PCIe Endpoint
[    5.820608] pci 0000:0c:00.4: BAR 0 [mem 0xfca00000-0xfca07fff]
[    5.820637] pci 0000:0c:00.4: enabling Extended Tags
[    5.820687] pci 0000:0c:00.4: PME# supported from D0 D3hot D3cold
[    5.820797] pci 0000:00:08.1: PCI bridge to [bus 0c]
[    5.820848] pci 0000:0d:00.0: [1022:7901] type 00 class 0x010601 PCIe Endpoint
[    5.820887] pci 0000:0d:00.0: BAR 5 [mem 0xfcf00000-0xfcf007ff]
[    5.820900] pci 0000:0d:00.0: enabling Extended Tags
[    5.820967] pci 0000:0d:00.0: PME# supported from D3hot D3cold
[    5.821089] pci 0000:00:08.3: PCI bridge to [bus 0d]
[    5.821601] ACPI: PCI: Interrupt link LNKA configured for IRQ 0
[    5.821656] ACPI: PCI: Interrupt link LNKB configured for IRQ 0
[    5.821708] ACPI: PCI: Interrupt link LNKC configured for IRQ 0
[    5.821767] ACPI: PCI: Interrupt link LNKD configured for IRQ 0
[    5.821820] ACPI: PCI: Interrupt link LNKE configured for IRQ 0
[    5.821866] ACPI: PCI: Interrupt link LNKF configured for IRQ 0
[    5.821911] ACPI: PCI: Interrupt link LNKG configured for IRQ 0
[    5.821956] ACPI: PCI: Interrupt link LNKH configured for IRQ 0
[    5.822751] iommu: Default domain type: Translated
[    5.822751] iommu: DMA domain TLB invalidation policy: strict mode
[    5.822817] SCSI subsystem initialized
[    5.822828] libata version 3.00 loaded.
[    5.822847] ACPI: bus type USB registered
[    5.822863] usbcore: registered new interface driver usbfs
[    5.822872] usbcore: registered new interface driver hub
[    5.822884] usbcore: registered new device driver usb
[    5.822899] videodev: Linux video capture interface: v2.00
[    5.822909] pps_core: LinuxPPS API ver. 1 registered
[    5.822912] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    5.822917] PTP clock support registered
[    5.822953] efivars: Registered efivars operations
[    5.822953] Advanced Linux Sound Architecture Driver Initialized.
[    5.822953] PCI: Using ACPI for IRQ routing
[    5.824899] PCI: pci_cache_line_size set to 64 bytes
[    5.824973] e820: reserve RAM buffer [mem 0x09cff000-0x0bffffff]
[    5.824976] e820: reserve RAM buffer [mem 0x0a200000-0x0bffffff]
[    5.824977] e820: reserve RAM buffer [mem 0x0b000000-0x0bffffff]
[    5.824979] e820: reserve RAM buffer [mem 0xc0743018-0xc3ffffff]
[    5.824980] e820: reserve RAM buffer [mem 0xc075d018-0xc3ffffff]
[    5.824982] e820: reserve RAM buffer [mem 0xc3280000-0xc3ffffff]
[    5.824983] e820: reserve RAM buffer [mem 0xc673a000-0xc7ffffff]
[    5.824985] e820: reserve RAM buffer [mem 0xca229000-0xcbffffff]
[    5.824987] e820: reserve RAM buffer [mem 0xcd000000-0xcfffffff]
[    5.824988] e820: reserve RAM buffer [mem 0x102f300000-0x102fffffff]
[    5.825004] pci 0000:0a:00.0: vgaarb: setting as boot VGA device
[    5.825004] pci 0000:0a:00.0: vgaarb: bridge control possible
[    5.825004] pci 0000:0a:00.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
[    5.825004] vgaarb: loaded
[    5.825193] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    5.825201] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    5.827763] clocksource: Switched to clocksource tsc-early
[    5.827796] VFS: Disk quotas dquot_6.6.0
[    5.827811] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    5.827854] pnp: PnP ACPI init
[    5.827938] system 00:00: [mem 0xf8000000-0xfbffffff] has been reserved
[    5.828055] system 00:01: [mem 0xfd200000-0xfd2fffff] has been reserved
[    5.828259] system 00:03: [io  0x0300-0x030f] has been reserved
[    5.828263] system 00:03: [io  0x0230-0x023f] has been reserved
[    5.828267] system 00:03: [io  0x0290-0x029f] has been reserved
[    5.828655] system 00:05: [io  0x04d0-0x04d1] has been reserved
[    5.828660] system 00:05: [io  0x040b] has been reserved
[    5.828663] system 00:05: [io  0x04d6] has been reserved
[    5.828667] system 00:05: [io  0x0c00-0x0c01] has been reserved
[    5.828670] system 00:05: [io  0x0c14] has been reserved
[    5.828674] system 00:05: [io  0x0c50-0x0c51] has been reserved
[    5.828677] system 00:05: [io  0x0c52] has been reserved
[    5.828680] system 00:05: [io  0x0c6c] has been reserved
[    5.828684] system 00:05: [io  0x0c6f] has been reserved
[    5.828687] system 00:05: [io  0x0cd8-0x0cdf] has been reserved
[    5.828690] system 00:05: [io  0x0800-0x089f] has been reserved
[    5.828694] system 00:05: [io  0x0b00-0x0b0f] has been reserved
[    5.828697] system 00:05: [io  0x0b20-0x0b3f] has been reserved
[    5.828701] system 00:05: [io  0x0900-0x090f] has been reserved
[    5.828704] system 00:05: [io  0x0910-0x091f] has been reserved
[    5.828708] system 00:05: [mem 0xfec00000-0xfec00fff] could not be reserved
[    5.828712] system 00:05: [mem 0xfec01000-0xfec01fff] could not be reserved
[    5.828716] system 00:05: [mem 0xfedc0000-0xfedc0fff] has been reserved
[    5.828720] system 00:05: [mem 0xfee00000-0xfee00fff] has been reserved
[    5.828724] system 00:05: [mem 0xfed80000-0xfed8ffff] could not be reserved
[    5.828727] system 00:05: [mem 0xfec10000-0xfec10fff] has been reserved
[    5.828731] system 00:05: [mem 0xff000000-0xffffffff] has been reserved
[    5.829278] pnp: PnP ACPI: found 6 devices
[    5.835243] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    5.835287] NET: Registered PF_INET protocol family
[    5.835313] IP idents hash table entries: 262144 (order: 9, 2097152 bytes, linear)
[    5.837384] tcp_listen_portaddr_hash hash table entries: 32768 (order: 7, 524288 bytes, linear)
[    5.837431] Table-perturb hash table entries: 65536 (order: 6, 262144 bytes, linear)
[    5.837448] TCP established hash table entries: 524288 (order: 10, 4194304 bytes, linear)
[    5.837847] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes, linear)
[    5.837981] TCP: Hash tables configured (established 524288 bind 65536)
[    5.838024] UDP hash table entries: 32768 (order: 8, 1048576 bytes, linear)
[    5.838115] UDP-Lite hash table entries: 32768 (order: 8, 1048576 bytes, linear)
[    5.838252] NET: Registered PF_UNIX/PF_LOCAL protocol family
[    5.838273] pci 0000:02:00.0: PCI bridge to [bus 03]
[    5.838279] pci 0000:02:00.0:   bridge window [io  0xf000-0xffff]
[    5.838286] pci 0000:02:00.0:   bridge window [mem 0xfcd00000-0xfcdfffff]
[    5.838297] pci 0000:02:01.0: PCI bridge to [bus 04]
[    5.838310] pci 0000:02:04.0: PCI bridge to [bus 05]
[    5.838324] pci 0000:02:06.0: PCI bridge to [bus 06]
[    5.838337] pci 0000:02:07.0: PCI bridge to [bus 07]
[    5.838350] pci 0000:01:00.2: PCI bridge to [bus 02-07]
[    5.838354] pci 0000:01:00.2:   bridge window [io  0xf000-0xffff]
[    5.838361] pci 0000:01:00.2:   bridge window [mem 0xfcd00000-0xfcdfffff]
[    5.838371] pci 0000:00:01.3: PCI bridge to [bus 01-07]
[    5.838375] pci 0000:00:01.3:   bridge window [io  0xf000-0xffff]
[    5.838380] pci 0000:00:01.3:   bridge window [mem 0xfcd00000-0xfcefffff]
[    5.838389] pci 0000:09:00.0: PCI bridge to [bus 0a]
[    5.838393] pci 0000:09:00.0:   bridge window [io  0xe000-0xefff]
[    5.838400] pci 0000:09:00.0:   bridge window [mem 0xfcb00000-0xfcbfffff]
[    5.838405] pci 0000:09:00.0:   bridge window [mem 0xe0000000-0xf01fffff 64bit pref]
[    5.838413] pci 0000:08:00.0: PCI bridge to [bus 09-0a]
[    5.838417] pci 0000:08:00.0:   bridge window [io  0xe000-0xefff]
[    5.838423] pci 0000:08:00.0:   bridge window [mem 0xfcb00000-0xfcbfffff]
[    5.838428] pci 0000:08:00.0:   bridge window [mem 0xe0000000-0xf01fffff 64bit pref]
[    5.838436] pci 0000:00:03.1: PCI bridge to [bus 08-0a]
[    5.838440] pci 0000:00:03.1:   bridge window [io  0xe000-0xefff]
[    5.838445] pci 0000:00:03.1:   bridge window [mem 0xfcb00000-0xfccfffff]
[    5.838450] pci 0000:00:03.1:   bridge window [mem 0xe0000000-0xf01fffff 64bit pref]
[    5.838457] pci 0000:00:07.1: PCI bridge to [bus 0b]
[    5.838466] pci 0000:00:08.1: PCI bridge to [bus 0c]
[    5.838472] pci 0000:00:08.1:   bridge window [mem 0xfc800000-0xfcafffff]
[    5.838479] pci 0000:00:08.3: PCI bridge to [bus 0d]
[    5.838484] pci 0000:00:08.3:   bridge window [mem 0xfcf00000-0xfcffffff]
[    5.838491] pci_bus 0000:00: resource 4 [io  0x0000-0x03af window]
[    5.838495] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7 window]
[    5.838499] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df window]
[    5.838502] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff window]
[    5.838505] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000dffff window]
[    5.838509] pci_bus 0000:00: resource 9 [mem 0xd0000000-0xfec2ffff window]
[    5.838512] pci_bus 0000:00: resource 10 [mem 0xfee00000-0xffffffff window]
[    5.838516] pci_bus 0000:01: resource 0 [io  0xf000-0xffff]
[    5.838519] pci_bus 0000:01: resource 1 [mem 0xfcd00000-0xfcefffff]
[    5.838523] pci_bus 0000:02: resource 0 [io  0xf000-0xffff]
[    5.838526] pci_bus 0000:02: resource 1 [mem 0xfcd00000-0xfcdfffff]
[    5.838529] pci_bus 0000:03: resource 0 [io  0xf000-0xffff]
[    5.838533] pci_bus 0000:03: resource 1 [mem 0xfcd00000-0xfcdfffff]
[    5.838537] pci_bus 0000:08: resource 0 [io  0xe000-0xefff]
[    5.838540] pci_bus 0000:08: resource 1 [mem 0xfcb00000-0xfccfffff]
[    5.838543] pci_bus 0000:08: resource 2 [mem 0xe0000000-0xf01fffff 64bit pref]
[    5.838547] pci_bus 0000:09: resource 0 [io  0xe000-0xefff]
[    5.838550] pci_bus 0000:09: resource 1 [mem 0xfcb00000-0xfcbfffff]
[    5.838554] pci_bus 0000:09: resource 2 [mem 0xe0000000-0xf01fffff 64bit pref]
[    5.838557] pci_bus 0000:0a: resource 0 [io  0xe000-0xefff]
[    5.838561] pci_bus 0000:0a: resource 1 [mem 0xfcb00000-0xfcbfffff]
[    5.838564] pci_bus 0000:0a: resource 2 [mem 0xe0000000-0xf01fffff 64bit pref]
[    5.838568] pci_bus 0000:0c: resource 1 [mem 0xfc800000-0xfcafffff]
[    5.838572] pci_bus 0000:0d: resource 1 [mem 0xfcf00000-0xfcffffff]
[    5.838804] pci 0000:0a:00.0: disabling ATS
[    5.838830] pci 0000:0a:00.1: D0 power state depends on 0000:0a:00.0
[    5.839001] PCI: CLS 64 bytes, default 64
[    5.839026] pci 0000:00:00.2: AMD-Vi: IOMMU performance counters supported
[    5.839071] pci 0000:00:01.0: Adding to iommu group 0
[    5.839090] pci 0000:00:01.3: Adding to iommu group 1
[    5.839114] pci 0000:00:02.0: Adding to iommu group 2
[    5.839140] pci 0000:00:03.0: Adding to iommu group 3
[    5.839157] pci 0000:00:03.1: Adding to iommu group 4
[    5.839182] pci 0000:00:04.0: Adding to iommu group 5
[    5.839207] pci 0000:00:05.0: Adding to iommu group 6
[    5.839232] pci 0000:00:07.0: Adding to iommu group 7
[    5.839249] pci 0000:00:07.1: Adding to iommu group 8
[    5.839276] pci 0000:00:08.0: Adding to iommu group 9
[    5.839294] pci 0000:00:08.1: Adding to iommu group 10
[    5.839312] pci 0000:00:08.3: Adding to iommu group 11
[    5.839360] pci 0000:00:14.0: Adding to iommu group 12
[    5.839377] pci 0000:00:14.3: Adding to iommu group 12
[    5.839456] pci 0000:00:18.0: Adding to iommu group 13
[    5.839473] pci 0000:00:18.1: Adding to iommu group 13
[    5.839490] pci 0000:00:18.2: Adding to iommu group 13
[    5.839508] pci 0000:00:18.3: Adding to iommu group 13
[    5.839526] pci 0000:00:18.4: Adding to iommu group 13
[    5.839544] pci 0000:00:18.5: Adding to iommu group 13
[    5.839561] pci 0000:00:18.6: Adding to iommu group 13
[    5.839579] pci 0000:00:18.7: Adding to iommu group 13
[    5.839619] pci 0000:01:00.0: Adding to iommu group 14
[    5.839638] pci 0000:01:00.1: Adding to iommu group 14
[    5.839657] pci 0000:01:00.2: Adding to iommu group 14
[    5.839664] pci 0000:02:00.0: Adding to iommu group 14
[    5.839671] pci 0000:02:01.0: Adding to iommu group 14
[    5.839677] pci 0000:02:04.0: Adding to iommu group 14
[    5.839684] pci 0000:02:06.0: Adding to iommu group 14
[    5.839690] pci 0000:02:07.0: Adding to iommu group 14
[    5.839697] pci 0000:03:00.0: Adding to iommu group 14
[    5.839715] pci 0000:08:00.0: Adding to iommu group 15
[    5.839734] pci 0000:09:00.0: Adding to iommu group 16
[    5.839757] pci 0000:0a:00.0: Adding to iommu group 17
[    5.839778] pci 0000:0a:00.1: Adding to iommu group 18
[    5.839799] pci 0000:0b:00.0: Adding to iommu group 19
[    5.839817] pci 0000:0c:00.0: Adding to iommu group 20
[    5.839836] pci 0000:0c:00.1: Adding to iommu group 21
[    5.839855] pci 0000:0c:00.3: Adding to iommu group 22
[    5.839874] pci 0000:0c:00.4: Adding to iommu group 23
[    5.839892] pci 0000:0d:00.0: Adding to iommu group 24
[    5.842213] AMD-Vi: Extended features (0x58f77ef22294a5a, 0x0): PPR NX GT IA PC GA_vAPIC
[    5.842223] AMD-Vi: Interrupt remapping enabled
[    5.842301] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    5.842304] software IO TLB: mapped [mem 0x00000000bc743000-0x00000000c0743000] (64MB)
[    5.842465] RAPL PMU: API unit is 2^-32 Joules, 1 fixed counters, 163840 ms ovfl timer
[    5.842470] RAPL PMU: hw unit of domain package 2^-16 Joules
[    5.842475] LVT offset 0 assigned for vector 0x400
[    5.842588] perf: AMD IBS detected (0x000003ff)
[    5.842693] amd_uncore: 4 amd_df counters detected
[    5.842700] amd_uncore: 6 amd_l3 counters detected
[    5.842845] perf/amd_iommu: Detected AMD IOMMU #0 (2 banks, 4 counters/bank).
[    5.842871] kvm_amd: TSC scaling supported
[    5.842874] kvm_amd: Nested Virtualization enabled
[    5.842876] kvm_amd: Nested Paging enabled
[    5.842884] kvm_amd: Virtual VMLOAD VMSAVE supported
[    5.842886] kvm_amd: Virtual GIF supported
[    5.842889] kvm_amd: LBR virtualization supported
[    5.848426] Initialise system trusted keyrings
[    5.848455] workingset: timestamp_bits=40 max_order=24 bucket_order=0
[    5.848859] utf8_selftest: All 154 tests passed
[    5.848862] ntfs3: Max link count 4000
[    5.848865] ntfs3: Read-only LZX/Xpress compression included
[    5.848878] fuse: init (API version 7.40)
[    5.848953] NET: Registered PF_ALG protocol family
[    5.848957] Key type asymmetric registered
[    5.848960] Asymmetric key parser 'x509' registered
[    5.849575] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 247)
[    5.855714] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    5.855721] ACPI: button: Power Button [PWRB]
[    5.855758] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    5.855768] ACPI: button: Power Button [PWRF]
[    5.856817] Estimated ratio of average max frequency by base frequency (times 1024): 1141
[    5.856832] Monitor-Mwait will be used to enter C-1 state
[    5.856835] ACPI: _PR_.C000: Found 2 idle states
[    5.856982] ACPI: _PR_.C002: Found 2 idle states
[    5.857103] ACPI: _PR_.C004: Found 2 idle states
[    5.857232] ACPI: _PR_.C006: Found 2 idle states
[    5.857369] ACPI: _PR_.C008: Found 2 idle states
[    5.857507] ACPI: _PR_.C00A: Found 2 idle states
[    5.857640] ACPI: _PR_.C00C: Found 2 idle states
[    5.857777] ACPI: _PR_.C00E: Found 2 idle states
[    5.857884] ACPI: _PR_.C010: Found 2 idle states
[    5.858015] ACPI: _PR_.C012: Found 2 idle states
[    5.858154] ACPI: _PR_.C014: Found 2 idle states
[    5.858296] ACPI: _PR_.C016: Found 2 idle states
[    5.858427] ACPI: _PR_.C001: Found 2 idle states
[    5.858567] ACPI: _PR_.C003: Found 2 idle states
[    5.858699] ACPI: _PR_.C005: Found 2 idle states
[    5.858848] ACPI: _PR_.C007: Found 2 idle states
[    5.858986] ACPI: _PR_.C009: Found 2 idle states
[    5.859091] ACPI: _PR_.C00B: Found 2 idle states
[    5.859236] ACPI: _PR_.C00D: Found 2 idle states
[    5.859374] ACPI: _PR_.C00F: Found 2 idle states
[    5.859513] ACPI: _PR_.C011: Found 2 idle states
[    5.859648] ACPI: _PR_.C013: Found 2 idle states
[    5.859783] ACPI: _PR_.C015: Found 2 idle states
[    5.859923] ACPI: _PR_.C017: Found 2 idle states
[    5.860119] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    5.860611] ACPI: bus type drm_connector registered
[    5.860637] [drm] amdgpu kernel modesetting enabled.
[    5.860681] amdgpu: Virtual CRAT table created for CPU
[    5.860695] amdgpu: Topology: Add CPU node
[    5.860774] [drm] initializing kernel modesetting (NAVI10 0x1002:0x731F 0x1DA2:0xE409 0xC1).
[    5.860783] [drm] register mmio base: 0xFCB00000
[    5.860786] [drm] register mmio size: 524288
[    5.864418] [drm] add ip block number 0 <nv_common>
[    5.864421] [drm] add ip block number 1 <gmc_v10_0>
[    5.864424] [drm] add ip block number 2 <navi10_ih>
[    5.864427] [drm] add ip block number 3 <psp>
[    5.864429] [drm] add ip block number 4 <smu>
[    5.864432] [drm] add ip block number 5 <dm>
[    5.864434] [drm] add ip block number 6 <gfx_v10_0>
[    5.864437] [drm] add ip block number 7 <sdma_v5_0>
[    5.864440] [drm] add ip block number 8 <vcn_v2_0>
[    5.864443] [drm] add ip block number 9 <jpeg_v2_0>
[    5.864453] amdgpu 0000:0a:00.0: No more image in the PCI ROM
[    5.864468] amdgpu 0000:0a:00.0: amdgpu: Fetched VBIOS from ROM BAR
[    5.864472] amdgpu: ATOM BIOS: 113-D1990103-O09
[    5.864490] [drm] VCN decode is enabled in VM mode
[    5.864493] [drm] VCN encode is enabled in VM mode
[    5.864496] [drm] JPEG decode is enabled in VM mode
[    5.864501] amdgpu 0000:0a:00.0: vgaarb: deactivate vga console
[    5.864506] amdgpu 0000:0a:00.0: amdgpu: Trusted Memory Zone (TMZ) feature disabled as experimental (default)
[    5.864554] [drm] vm size is 262144 GB, 4 levels, block size is 9-bit, fragment size is 9-bit
[    5.864565] amdgpu 0000:0a:00.0: amdgpu: VRAM: 8176M 0x0000008000000000 - 0x00000081FEFFFFFF (8176M used)
[    5.864570] amdgpu 0000:0a:00.0: amdgpu: GART: 512M 0x0000000000000000 - 0x000000001FFFFFFF
[    5.864580] [drm] Detected VRAM RAM=8176M, BAR=256M
[    5.864583] [drm] RAM width 256bits GDDR6
[    5.864735] [drm] amdgpu: 8176M of VRAM memory ready
[    5.864739] [drm] amdgpu: 32102M of GTT memory ready.
[    5.864752] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    5.864913] [drm] PCIE GART of 512M enabled (table at 0x0000008000300000).
[    5.865729] [drm] Found VCN firmware Version ENC: 1.21 DEC: 7 VEP: 0 Revision: 2
[    5.865742] amdgpu 0000:0a:00.0: amdgpu: Will use PSP to load VCN firmware
[    5.918819] amdgpu 0000:0a:00.0: amdgpu: reserve 0x900000 from 0x81fd000000 for PSP TMR
[    5.966834] amdgpu 0000:0a:00.0: amdgpu: RAS: optional ras ta ucode is not available
[    5.973820] amdgpu 0000:0a:00.0: amdgpu: RAP: optional rap ta ucode is not available
[    5.973825] amdgpu 0000:0a:00.0: amdgpu: SECUREDISPLAY: securedisplay ta ucode is not available
[    5.973886] amdgpu 0000:0a:00.0: amdgpu: use vbios provided pptable
[    5.973890] amdgpu 0000:0a:00.0: amdgpu: smc_dpm_info table revision(format.content): 4.5
[    6.009488] amdgpu 0000:0a:00.0: amdgpu: SMU is initialized successfully!
[    6.009642] [drm] Display Core v3.2.273 initialized on DCN 2.0
[    6.009646] [drm] DP-HDMI FRL PCON supported
[    6.070590] [drm] kiq ring mec 2 pipe 1 q 0
[    6.072778] [drm] VCN decode and encode initialized successfully(under DPG Mode).
[    6.073071] [drm] JPEG decode initialized successfully.
[    6.580259] [drm] Fence fallback timer expired on ring sdma0
[    6.580318] kfd kfd: amdgpu: Allocated 3969056 bytes on gart
[    6.580328] kfd kfd: amdgpu: Total number of KFD nodes to be created: 1
[    6.850915] tsc: Refined TSC clocksource calibration: 3792.873 MHz
[    6.850938] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x6d5818a734c, max_idle_ns: 881590694765 ns
[    6.851023] clocksource: Switched to clocksource tsc
[    7.082898] [drm] Fence fallback timer expired on ring sdma0
[    7.083022] amdgpu: Virtual CRAT table created for GPU
[    7.083421] amdgpu: Topology: Add dGPU node [0x731f:0x1002]
[    7.083426] kfd kfd: amdgpu: added device 1002:731f
[    7.083447] amdgpu 0000:0a:00.0: amdgpu: SE 2, SH per SE 2, CU per SH 10, active_cu_number 40
[    7.083455] amdgpu 0000:0a:00.0: amdgpu: ring gfx_0.0.0 uses VM inv eng 0 on hub 0
[    7.083460] amdgpu 0000:0a:00.0: amdgpu: ring comp_1.0.0 uses VM inv eng 1 on hub 0
[    7.083477] amdgpu 0000:0a:00.0: amdgpu: ring comp_1.1.0 uses VM inv eng 4 on hub 0
[    7.083481] amdgpu 0000:0a:00.0: amdgpu: ring comp_1.2.0 uses VM inv eng 5 on hub 0
[    7.083486] amdgpu 0000:0a:00.0: amdgpu: ring comp_1.3.0 uses VM inv eng 6 on hub 0
[    7.083490] amdgpu 0000:0a:00.0: amdgpu: ring comp_1.0.1 uses VM inv eng 7 on hub 0
[    7.083494] amdgpu 0000:0a:00.0: amdgpu: ring comp_1.1.1 uses VM inv eng 8 on hub 0
[    7.083499] amdgpu 0000:0a:00.0: amdgpu: ring comp_1.2.1 uses VM inv eng 9 on hub 0
[    7.083503] amdgpu 0000:0a:00.0: amdgpu: ring comp_1.3.1 uses VM inv eng 10 on hub 0
[    7.083508] amdgpu 0000:0a:00.0: amdgpu: ring kiq_0.2.1.0 uses VM inv eng 11 on hub 0
[    7.083512] amdgpu 0000:0a:00.0: amdgpu: ring sdma0 uses VM inv eng 12 on hub 0
[    7.083517] amdgpu 0000:0a:00.0: amdgpu: ring sdma1 uses VM inv eng 13 on hub 0
[    7.083521] amdgpu 0000:0a:00.0: amdgpu: ring vcn_dec uses VM inv eng 0 on hub 8
[    7.083526] amdgpu 0000:0a:00.0: amdgpu: ring vcn_enc0 uses VM inv eng 1 on hub 8
[    7.083530] amdgpu 0000:0a:00.0: amdgpu: ring vcn_enc1 uses VM inv eng 4 on hub 8
[    7.083534] amdgpu 0000:0a:00.0: amdgpu: ring jpeg_dec uses VM inv eng 5 on hub 8
[    7.085401] amdgpu 0000:0a:00.0: amdgpu: Using BACO for runtime pm
[    7.085628] [drm] Initialized amdgpu 3.57.0 20150101 for 0000:0a:00.0 on minor 0
[    7.096412] fbcon: amdgpudrmfb (fb0) is primary device
[    7.096803] [drm] DSC precompute is not needed.
[    7.177913] Console: switching to colour frame buffer device 320x90
[    7.212116] amdgpu 0000:0a:00.0: [drm] fb0: amdgpudrmfb frame buffer device
[    7.215704] loop: module loaded
[    7.215807] ahci 0000:01:00.1: version 3.0
[    7.215997] ahci 0000:01:00.1: SSS flag set, parallel bus scan disabled
[    7.216053] ahci 0000:01:00.1: AHCI vers 0001.0301, 32 command slots, 6 Gbps, SATA mode
[    7.216068] ahci 0000:01:00.1: 4/8 ports implemented (port mask 0x33)
[    7.216078] ahci 0000:01:00.1: flags: 64bit ncq sntf stag pm led clo only pmp pio slum part sxs deso sadm sds apst
[    7.216721] scsi host0: ahci
[    7.216854] scsi host1: ahci
[    7.216981] scsi host2: ahci
[    7.217102] scsi host3: ahci
[    7.217220] scsi host4: ahci
[    7.217369] scsi host5: ahci
[    7.217486] scsi host6: ahci
[    7.217635] scsi host7: ahci
[    7.217678] ata1: SATA max UDMA/133 abar m131072@0xfce80000 port 0xfce80100 irq 42 lpm-pol 0
[    7.217692] ata2: SATA max UDMA/133 abar m131072@0xfce80000 port 0xfce80180 irq 42 lpm-pol 0
[    7.217704] ata3: DUMMY
[    7.217709] ata4: DUMMY
[    7.217716] ata5: SATA max UDMA/133 abar m131072@0xfce80000 port 0xfce80300 irq 42 lpm-pol 0
[    7.217728] ata6: SATA max UDMA/133 abar m131072@0xfce80000 port 0xfce80380 irq 42 lpm-pol 0
[    7.217740] ata7: DUMMY
[    7.217745] ata8: DUMMY
[    7.218114] ahci 0000:0d:00.0: AHCI vers 0001.0301, 32 command slots, 6 Gbps, SATA mode
[    7.218128] ahci 0000:0d:00.0: 2/2 ports implemented (port mask 0x30)
[    7.218139] ahci 0000:0d:00.0: flags: 64bit ncq sntf ilck pm led clo only pmp fbs pio slum part
[    7.218610] scsi host8: ahci
[    7.218724] scsi host9: ahci
[    7.218831] scsi host10: ahci
[    7.218938] scsi host11: ahci
[    7.219044] scsi host12: ahci
[    7.219160] scsi host13: ahci
[    7.219211] ata9: DUMMY
[    7.219217] ata10: DUMMY
[    7.219222] ata11: DUMMY
[    7.219227] ata12: DUMMY
[    7.219233] ata13: SATA max UDMA/133 abar m2048@0xfcf00000 port 0xfcf00300 irq 48 lpm-pol 0
[    7.219245] ata14: SATA max UDMA/133 abar m2048@0xfcf00000 port 0xfcf00380 irq 49 lpm-pol 0
[    7.219289] wireguard: WireGuard 1.0.0 loaded. See www.wireguard.com for information.
[    7.219301] wireguard: Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
[    7.219515] tun: Universal TUN/TAP device driver, 1.6
[    7.227540] r8169 0000:03:00.0 eth0: RTL8168h/8111h, fc:34:97:64:37:ea, XID 541, IRQ 60
[    7.227569] r8169 0000:03:00.0 eth0: jumbo features [frames: 9194 bytes, tx checksumming: ko]
[    7.227718] VFIO - User Level meta-driver version: 0.3
[    7.227892] xhci_hcd 0000:01:00.0: xHCI Host Controller
[    7.227950] xhci_hcd 0000:01:00.0: new USB bus registered, assigned bus number 1
[    7.283316] xhci_hcd 0000:01:00.0: hcc params 0x0200ef81 hci version 0x110 quirks 0x0000000000000410
[    7.283705] xhci_hcd 0000:01:00.0: xHCI Host Controller
[    7.283768] xhci_hcd 0000:01:00.0: new USB bus registered, assigned bus number 2
[    7.283784] xhci_hcd 0000:01:00.0: Host supports USB 3.1 Enhanced SuperSpeed
[    7.283932] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 6.09
[    7.283949] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.283963] usb usb1: Product: xHCI Host Controller
[    7.283973] usb usb1: Manufacturer: Linux 6.9.0-rc5-maxz xhci-hcd
[    7.283985] usb usb1: SerialNumber: 0000:01:00.0
[    7.284240] hub 1-0:1.0: USB hub found
[    7.284287] hub 1-0:1.0: 10 ports detected
[    7.297930] usb usb2: We don't know the algorithms for LPM for this host, disabling LPM.
[    7.298002] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 6.09
[    7.298945] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.299611] usb usb2: Product: xHCI Host Controller
[    7.300189] usb usb2: Manufacturer: Linux 6.9.0-rc5-maxz xhci-hcd
[    7.300768] usb usb2: SerialNumber: 0000:01:00.0
[    7.301458] hub 2-0:1.0: USB hub found
[    7.302045] hub 2-0:1.0: 4 ports detected
[    7.308164] xhci_hcd 0000:0c:00.3: xHCI Host Controller
[    7.308769] xhci_hcd 0000:0c:00.3: new USB bus registered, assigned bus number 3
[    7.309473] xhci_hcd 0000:0c:00.3: hcc params 0x0278ffe5 hci version 0x110 quirks 0x0000000000000410
[    7.310462] xhci_hcd 0000:0c:00.3: xHCI Host Controller
[    7.311754] xhci_hcd 0000:0c:00.3: new USB bus registered, assigned bus number 4
[    7.312348] xhci_hcd 0000:0c:00.3: Host supports USB 3.1 Enhanced SuperSpeed
[    7.312954] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 6.09
[    7.313514] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.314058] usb usb3: Product: xHCI Host Controller
[    7.314606] usb usb3: Manufacturer: Linux 6.9.0-rc5-maxz xhci-hcd
[    7.315142] usb usb3: SerialNumber: 0000:0c:00.3
[    7.316092] hub 3-0:1.0: USB hub found
[    7.316636] hub 3-0:1.0: 4 ports detected
[    7.317361] usb usb4: We don't know the algorithms for LPM for this host, disabling LPM.
[    7.317915] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 6.09
[    7.318433] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.318950] usb usb4: Product: xHCI Host Controller
[    7.319463] usb usb4: Manufacturer: Linux 6.9.0-rc5-maxz xhci-hcd
[    7.319972] usb usb4: SerialNumber: 0000:0c:00.3
[    7.320588] hub 4-0:1.0: USB hub found
[    7.321105] hub 4-0:1.0: 4 ports detected
[    7.321730] usb: port power management may be unreliable
[    7.322363] usbcore: registered new interface driver usb-storage
[    7.322877] usbcore: registered new interface driver chaoskey
[    7.323422] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    7.323927] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    7.324565] serio: i8042 KBD port at 0x60,0x64 irq 1
[    7.325141] mousedev: PS/2 mouse device common for all mice
[    7.325762] rtc_cmos 00:02: RTC can wake from S4
[    7.326524] rtc_cmos 00:02: registered as rtc0
[    7.327563] rtc_cmos 00:02: setting system clock to 2024-04-28T07:00:14 UTC (1714287614)
[    7.328192] rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvram
[    7.328779] usbcore: registered new interface driver uvcvideo
[    7.329476] device-mapper: ioctl: 4.48.0-ioctl (2023-03-01) initialised: dm-devel@lists.linux.dev
[    7.330015] amd_pstate: driver load is disabled, boot with specific mode to enable this
[    7.330596] pstore: Using crash dump compression: deflate
[    7.331130] pstore: Registered efi_pstore as persistent store backend
[    7.331676] hid: raw HID events driver (C) Jiri Kosina
[    7.332232] usbcore: registered new interface driver usbhid
[    7.332767] usbhid: USB HID core driver
[    7.334844] snd_hda_intel 0000:0a:00.1: Force to non-snoop mode
[    7.335821] snd_hda_intel 0000:0c:00.4: enabling device (0000 -> 0002)
[    7.336552] usbcore: registered new interface driver snd-usb-audio
[    7.337478] NET: Registered PF_INET6 protocol family
[    7.338370] Segment Routing with IPv6
[    7.338957] In-situ OAM (IOAM) with IPv6
[    7.339552] NET: Registered PF_PACKET protocol family
[    7.340120] 8021q: 802.1Q VLAN Support v1.8
[    7.343035] microcode: Current revision: 0x08701030
[    7.343368] snd_hda_codec_generic hdaudioC1D0: ignore pin 0x7, too many assigned pins
[    7.344540] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    7.344928] snd_hda_codec_generic hdaudioC1D0: ignore pin 0x9, too many assigned pins
[    7.345265] IPI shorthand broadcast: enabled
[    7.345267] AVX2 version of gcm_enc/dec engaged.
[    7.348058] AES CTR mode by8 optimization enabled
[    7.348059] snd_hda_codec_generic hdaudioC1D0: ignore pin 0xb, too many assigned pins
[    7.349285] snd_hda_codec_generic hdaudioC1D0: ignore pin 0xd, too many assigned pins
[    7.349884] snd_hda_codec_generic hdaudioC1D0: autoconfig for Generic: line_outs=0 (0x0/0x0/0x0/0x0/0x0) type:line
[    7.350477] snd_hda_codec_generic hdaudioC1D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    7.351042] snd_hda_codec_generic hdaudioC1D0:    hp_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    7.351608] snd_hda_codec_generic hdaudioC1D0:    mono: mono_out=0x0
[    7.352162] snd_hda_codec_generic hdaudioC1D0:    dig-out=0x3/0x5
[    7.352715] snd_hda_codec_generic hdaudioC1D0:    inputs:
[    7.353811] input: HDA ATI HDMI HDMI as /devices/pci0000:00/0000:00:03.1/0000:08:00.0/0000:09:00.0/0000:0a:00.1/sound/card1/input3
[    7.354455] input: HDA ATI HDMI HDMI as /devices/pci0000:00/0000:00:03.1/0000:08:00.0/0000:09:00.0/0000:0a:00.1/sound/card1/input4
[    7.354744] sched_clock: Marking stable (7037000996, 317464730)->(7380371680, -25905954)
[    7.355679] Timer migration: 2 hierarchy levels; 8 children per group; 2 crossnode level
[    7.356523] registered taskstats version 1
[    7.357096] Loading compiled-in X.509 certificates
[    7.359383] snd_hda_codec_realtek hdaudioC2D0: autoconfig for ALC887-VD: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:line
[    7.359984] snd_hda_codec_realtek hdaudioC2D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    7.360977] snd_hda_codec_realtek hdaudioC2D0:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[    7.361693] snd_hda_codec_realtek hdaudioC2D0:    mono: mono_out=0x0
[    7.362341] snd_hda_codec_realtek hdaudioC2D0:    dig-out=0x11/0x0
[    7.362969] snd_hda_codec_realtek hdaudioC2D0:    inputs:
[    7.363590] snd_hda_codec_realtek hdaudioC2D0:      Front Mic=0x19
[    7.364187] snd_hda_codec_realtek hdaudioC2D0:      Rear Mic=0x18
[    7.364777] snd_hda_codec_realtek hdaudioC2D0:      Line=0x1a
[    7.377453] input: HD-Audio Generic Front Mic as /devices/pci0000:00/0000:00:08.1/0000:0c:00.4/sound/card2/input5
[    7.378447] input: HD-Audio Generic Rear Mic as /devices/pci0000:00/0000:00:08.1/0000:0c:00.4/sound/card2/input6
[    7.379210] input: HD-Audio Generic Line as /devices/pci0000:00/0000:00:08.1/0000:0c:00.4/sound/card2/input7
[    7.379923] input: HD-Audio Generic Line Out as /devices/pci0000:00/0000:00:08.1/0000:0c:00.4/sound/card2/input8
[    7.380621] input: HD-Audio Generic Front Headphone as /devices/pci0000:00/0000:00:08.1/0000:0c:00.4/sound/card2/input9
[    7.409842] Loaded X.509 cert 'Max Zettlmeißl: e04ecff8f122124c670f06825e23843c4c40d1d0'
[    7.422895] zswap: loaded using pool zstd/z3fold
[    7.504442] acpi_cpufreq: overriding BIOS provided _PSD data
[    7.519358] clk: Disabling unused clocks
[    7.520238] ALSA device list:
[    7.520901]   #0: Loopback 1
[    7.521489]   #1: HDA ATI HDMI at 0xfcba0000 irq 80
[    7.522069]   #2: HD-Audio Generic at 0xfca00000 irq 81
[    7.556486] usb 3-1: new high-speed USB device number 2 using xhci_hcd
[    7.602488] usb 1-7: new full-speed USB device number 2 using xhci_hcd
[    7.682510] ata14: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    7.682524] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    7.683448] ata13: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    7.685904] ata14.00: supports DRM functions and may not be fully accessible
[    7.686847] ata14.00: ATA-9: Samsung SSD 850 PRO 1TB, EXM04B6Q, max UDMA/133
[    7.688075] ata13.00: supports DRM functions and may not be fully accessible
[    7.689116] ata13.00: ATA-9: Samsung SSD 850 PRO 128GB, EXM04B6Q, max UDMA/133
[    7.692799] ata14.00: 2000409264 sectors, multi 1: LBA48 NCQ (depth 32), AA
[    7.694558] ata13.00: 250069680 sectors, multi 1: LBA48 NCQ (depth 32), AA
[    7.696294] ata1.00: ATA-8: OCZ-AGILITY3, 2.15, max UDMA/133
[    7.697776] ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 32), AA
[    7.703431] ata14.00: Features: Trust Dev-Sleep NCQ-sndrcv
[    7.704953] ata14.00: supports DRM functions and may not be fully accessible
[    7.706232] ata13.00: Features: Trust Dev-Sleep NCQ-sndrcv
[    7.706693] ata1.00: configured for UDMA/133
[    7.707350] ata13.00: supports DRM functions and may not be fully accessible
[    7.708772] scsi 0:0:0:0: Direct-Access     ATA      OCZ-AGILITY3     2.15 PQ: 0 ANSI: 5
[    7.711162] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    7.711247] sd 0:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB/112 GiB)
[    7.713390] sd 0:0:0:0: [sda] Write Protect is off
[    7.714344] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    7.714365] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.715045] sd 0:0:0:0: [sda] Preferred minimum I/O size 512 bytes
[    7.720408] ata14.00: configured for UDMA/133
[    7.723811] ata13.00: configured for UDMA/133
[    7.737087]  sda: sda2 sda3 sda4
[    7.738793] sd 0:0:0:0: [sda] Attached SCSI disk
[    7.977180] usb 1-7: New USB device found, idVendor=046d, idProduct=c07d, bcdDevice=88.02
[    7.978598] usb 1-7: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    7.979826] usb 1-7: Product: Gaming Mouse G502
[    7.981027] usb 1-7: Manufacturer: Logitech
[    7.982221] usb 1-7: SerialNumber: 046C34793638
[    8.008062] input: Logitech Gaming Mouse G502 as /devices/pci0000:00/0000:00:01.3/0000:01:00.0/usb1/1-7/1-7:1.0/0003:046D:C07D.0001/input/input10
[    8.011752] hid-generic 0003:046D:C07D.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech Gaming Mouse G502] on usb-0000:01:00.0-7/input0
[    8.022348] input: Logitech Gaming Mouse G502 Keyboard as /devices/pci0000:00/0000:00:01.3/0000:01:00.0/usb1/1-7/1-7:1.1/0003:046D:C07D.0002/input/input11
[    8.075606] hid-generic 0003:046D:C07D.0002: input,hiddev96,hidraw1: USB HID v1.11 Keyboard [Logitech Gaming Mouse G502] on usb-0000:01:00.0-7/input1
[    8.202975] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    8.207929] ata2.00: ATA-11: TOSHIBA MG09ACA18TE, 0104, max UDMA/133
[    8.215920] ata2.00: 35156656128 sectors, multi 16: LBA48 NCQ (depth 32), AA
[    8.228963] ata2.00: Features: NCQ-prio
[    8.252002] ata2.00: configured for UDMA/133
[    8.253897] scsi 1:0:0:0: Direct-Access     ATA      TOSHIBA MG09ACA1 0104 PQ: 0 ANSI: 5
[    8.254518] usb 1-8: new high-speed USB device number 3 using xhci_hcd
[    8.255938] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    8.255995] sd 1:0:0:0: [sdb] 35156656128 512-byte logical blocks: (18.0 TB/16.4 TiB)
[    8.256000] sd 1:0:0:0: [sdb] 4096-byte physical blocks
[    8.256020] sd 1:0:0:0: [sdb] Write Protect is off
[    8.256027] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    8.256059] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.256095] sd 1:0:0:0: [sdb] Preferred minimum I/O size 4096 bytes
[    8.257972] usb 3-1: New USB device found, idVendor=046d, idProduct=0892, bcdDevice= 0.19
[    8.263353] usb 3-1: New USB device strings: Mfr=0, Product=2, SerialNumber=1
[    8.263989] usb 3-1: Product: HD Pro Webcam C920
[    8.264628] usb 3-1: SerialNumber: 81EB18EF
[    8.289140] usb 3-1: Found UVC 1.00 device HD Pro Webcam C920 (046d:0892)
[    8.299909]  sdb: sdb1
[    8.301427] sd 1:0:0:0: [sdb] Attached SCSI disk
[    8.483334] usb 1-8: New USB device found, idVendor=152d, idProduct=2338, bcdDevice= 1.00
[    8.484938] usb 1-8: New USB device strings: Mfr=1, Product=2, SerialNumber=5
[    8.486319] usb 1-8: Product: USB to ATA/ATAPI bridge
[    8.487659] usb 1-8: Manufacturer: JMicron
[    8.488971] usb 1-8: SerialNumber: 4922CD522220
[    8.513366] usb-storage 1-8:1.0: USB Mass Storage device detected
[    8.517657] scsi host14: usb-storage 1-8:1.0
[    8.583974] ata5: SATA link down (SStatus 0 SControl 330)
[    9.058639] ata6: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    9.061299] ata6.00: ATA-10: WDC WD2004FBYZ-01YCBB0, RR02, max UDMA/133
[    9.143807] ata6.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 32), AA
[    9.145450] ata6.00: Features: NCQ-sndrcv NCQ-prio
[    9.173437] ata6.00: configured for UDMA/133
[    9.175177] scsi 5:0:0:0: Direct-Access     ATA      WDC WD2004FBYZ-0 RR02 PQ: 0 ANSI: 5
[    9.177239] sd 5:0:0:0: [sdc] 3907029168 512-byte logical blocks: (2.00 TB/1.82 TiB)
[    9.177255] sd 5:0:0:0: Attached scsi generic sg2 type 0
[    9.178386] sd 5:0:0:0: [sdc] Write Protect is off
[    9.180634] sd 5:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    9.180694] sd 5:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    9.181968] sd 5:0:0:0: [sdc] Preferred minimum I/O size 512 bytes
[    9.257110] scsi 12:0:0:0: Direct-Access     ATA      Samsung SSD 850  4B6Q PQ: 0 ANSI: 5
[    9.260163] sd 12:0:0:0: Attached scsi generic sg3 type 0
[    9.260197] sd 12:0:0:0: [sdd] 250069680 512-byte logical blocks: (128 GB/119 GiB)
[    9.262880] sd 12:0:0:0: [sdd] Write Protect is off
[    9.263787] sd 12:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    9.263881] sd 12:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    9.264154] scsi 13:0:0:0: Direct-Access     ATA      Samsung SSD 850  4B6Q PQ: 0 ANSI: 5
[    9.264597] sd 12:0:0:0: [sdd] Preferred minimum I/O size 512 bytes
[    9.265364] sd 13:0:0:0: Attached scsi generic sg4 type 0
[    9.265411] sd 13:0:0:0: [sde] 2000409264 512-byte logical blocks: (1.02 TB/954 GiB)
[    9.265424] sd 13:0:0:0: [sde] Write Protect is off
[    9.265430] sd 13:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    9.265450] sd 13:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    9.265503] sd 13:0:0:0: [sde] Preferred minimum I/O size 512 bytes
[    9.266385]  sdd: sdd1 sdd2 < sdd5 >
[    9.269681]  sde: sde1
[    9.270357] sd 12:0:0:0: [sdd] Attached SCSI disk
[    9.271531] sd 13:0:0:0: [sde] Attached SCSI disk
[    9.292006]  sdc: sdc1
[    9.293125] sd 5:0:0:0: [sdc] Attached SCSI disk
[    9.299126] EXT4-fs (sda4): mounted filesystem 678f73f9-85d2-4985-8822-ea376e57e3d8 ro with ordered data mode. Quota mode: none.
[    9.300456] VFS: Mounted root (ext4 filesystem) readonly on device 8:4.
[    9.303009] devtmpfs: mounted
[    9.304788] Freeing unused kernel image (initmem) memory: 2056K
[    9.305931] Write protecting the kernel read-only data: 34816k
[    9.307978] Freeing unused kernel image (rodata/data gap) memory: 1944K
[    9.362748] x86/mm: Checked W+X mappings: passed, no W+X pages found.
[    9.363773] Run /sbin/init as init process
[    9.365399]   with arguments:
[    9.365401]     /sbin/init
[    9.365402]   with environment:
[    9.365403]     HOME=/
[    9.365404]     TERM=linux
[    9.588555] scsi 14:0:0:0: CD-ROM            PLEXTOR  CD-R   PX-W4012A 1.07 PQ: 0 ANSI: 0 CCS
[    9.591671] sr 14:0:0:0: [sr0] scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
[    9.592848] cdrom: Uniform CD-ROM driver Revision: 3.20
[    9.594839] sr 14:0:0:0: Attached scsi CD-ROM sr0
[    9.594895] sr 14:0:0:0: Attached scsi generic sg5 type 5
[   10.807138] r8169 0000:03:00.0 enp3s0: renamed from eth0
[   11.024944] usb 3-1: reset high-speed USB device number 2 using xhci_hcd
[   11.354219] EXT4-fs (sda4): re-mounted 678f73f9-85d2-4985-8822-ea376e57e3d8 r/w. Quota mode: none.
[   11.364101] EXT4-fs (sda4): re-mounted 678f73f9-85d2-4985-8822-ea376e57e3d8 r/w. Quota mode: none.
[   11.599271] Adding 16777212k swap on /dev/sda3.  Priority:-2 extents:1 across:16777212k SS
[   12.445990] elogind-daemon[1790]: New seat seat0.
[   12.447331] elogind-daemon[1790]: Watching system buttons on /dev/input/event1 (Power Button)
[   12.447394] elogind-daemon[1790]: Watching system buttons on /dev/input/event0 (Power Button)
[   12.447519] elogind-daemon[1790]: Watching system buttons on /dev/input/event11 (Logitech Gaming Mouse G502 Keyboard)
[   12.448186] elogind-daemon[1790]: Watching system buttons on /dev/input/event2 (AT Translated Set 2 keyboard)
[   14.572481] Generic FE-GE Realtek PHY r8169-0-300:00: attached PHY driver (mii_bus:phy_addr=r8169-0-300:00, irq=MAC)
[   14.716888] r8169 0000:03:00.0 enp3s0: Link is Down
[   17.805718] r8169 0000:03:00.0 enp3s0: Link is Up - 1Gbps/Full - flow control rx/tx
[   27.418683] elogind-daemon[1790]: New session 2 of user max.
[   86.016392] sr 14:0:0:0: [sr0] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=DRIVER_OK cmd_age=1s
[   86.016401] sr 14:0:0:0: [sr0] tag#0 Sense Key : 0x5 [current]
[   86.016405] sr 14:0:0:0: [sr0] tag#0 ASC=0x63 ASCQ=0x0
[   86.016416] sr 14:0:0:0: [sr0] tag#0 CDB: opcode=0x28 28 00 00 04 ad b6 00 00 02 00
[   86.016420] I/O error, dev sr0, sector 1226456 op 0x0:(READ) flags 0x80700 phys_seg 1 prio class 0
[   87.727942] sr 14:0:0:0: [sr0] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=DRIVER_OK cmd_age=1s
[   87.727952] sr 14:0:0:0: [sr0] tag#0 Sense Key : 0x5 [current]
[   87.727956] sr 14:0:0:0: [sr0] tag#0 ASC=0x63 ASCQ=0x0
[   87.727961] sr 14:0:0:0: [sr0] tag#0 CDB: opcode=0x28 28 00 00 04 ac 80 00 00 3c 00
[   87.727964] I/O error, dev sr0, sector 1225216 op 0x0:(READ) flags 0x84700 phys_seg 30 prio class 0
[   88.541888] sr 14:0:0:0: [sr0] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=DRIVER_OK cmd_age=0s
[   88.541898] sr 14:0:0:0: [sr0] tag#0 Sense Key : 0x5 [current]
[   88.541902] sr 14:0:0:0: [sr0] tag#0 ASC=0x63 ASCQ=0x0
[   88.541907] sr 14:0:0:0: [sr0] tag#0 CDB: opcode=0x28 28 00 00 04 ac bc 00 00 04 00
[   88.541910] I/O error, dev sr0, sector 1225456 op 0x0:(READ) flags 0x80700 phys_seg 2 prio class 0
[   89.355879] sr 14:0:0:0: [sr0] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=DRIVER_OK cmd_age=0s
[   89.355888] sr 14:0:0:0: [sr0] tag#0 Sense Key : 0x5 [current]
[   89.355893] sr 14:0:0:0: [sr0] tag#0 ASC=0x63 ASCQ=0x0
[   89.355898] sr 14:0:0:0: [sr0] tag#0 CDB: opcode=0x28 28 00 00 04 ac 80 00 00 02 00
[   89.355901] I/O error, dev sr0, sector 1225216 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[   89.355907] Buffer I/O error on dev sr0, logical block 153152, async page read
[   90.156910] sr 14:0:0:0: [sr0] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=DRIVER_OK cmd_age=0s
[   90.156915] sr 14:0:0:0: [sr0] tag#0 Sense Key : 0x5 [current]
[   90.156919] sr 14:0:0:0: [sr0] tag#0 ASC=0x63 ASCQ=0x0
[   90.156923] sr 14:0:0:0: [sr0] tag#0 CDB: opcode=0x28 28 00 00 04 ad b4 00 00 02 00
[   90.156926] I/O error, dev sr0, sector 1226448 op 0x0:(READ) flags 0x80700 phys_seg 1 prio class 0
[  120.971018] usb 1-8: reset high-speed USB device number 3 using xhci_hcd
[  126.474713] sr 14:0:0:0: Power-on or device reset occurred
[  138.341021] sr 14:0:0:0: [sr0] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=DRIVER_OK cmd_age=1s
[  138.341034] sr 14:0:0:0: [sr0] tag#0 Sense Key : 0x5 [current]
[  138.341039] sr 14:0:0:0: [sr0] tag#0 ASC=0x63 ASCQ=0x0
[  138.341043] sr 14:0:0:0: [sr0] tag#0 CDB: opcode=0x28 28 00 00 04 ad b6 00 00 02 00
[  138.341046] I/O error, dev sr0, sector 1226456 op 0x0:(READ) flags 0x80700 phys_seg 1 prio class 0
[  140.104170] sr 14:0:0:0: [sr0] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=DRIVER_OK cmd_age=1s
[  140.104176] sr 14:0:0:0: [sr0] tag#0 Sense Key : 0x5 [current]
[  140.104180] sr 14:0:0:0: [sr0] tag#0 ASC=0x63 ASCQ=0x0
[  140.104184] sr 14:0:0:0: [sr0] tag#0 CDB: opcode=0x28 28 00 00 04 ac 80 00 00 3c 00
[  140.104187] I/O error, dev sr0, sector 1225216 op 0x0:(READ) flags 0x84700 phys_seg 29 prio class 0
[  140.930286] sr 14:0:0:0: [sr0] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=DRIVER_OK cmd_age=0s
[  140.930291] sr 14:0:0:0: [sr0] tag#0 Sense Key : 0x5 [current]
[  140.930295] sr 14:0:0:0: [sr0] tag#0 ASC=0x63 ASCQ=0x0
[  140.930299] sr 14:0:0:0: [sr0] tag#0 CDB: opcode=0x28 28 00 00 04 ac bc 00 00 04 00
[  140.930302] I/O error, dev sr0, sector 1225456 op 0x0:(READ) flags 0x80700 phys_seg 2 prio class 0
[  141.722386] sr 14:0:0:0: [sr0] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=DRIVER_OK cmd_age=0s
[  141.722391] sr 14:0:0:0: [sr0] tag#0 Sense Key : 0x5 [current]
[  141.722395] sr 14:0:0:0: [sr0] tag#0 ASC=0x63 ASCQ=0x0
[  141.722399] sr 14:0:0:0: [sr0] tag#0 CDB: opcode=0x28 28 00 00 04 ac 80 00 00 02 00
[  141.722401] I/O error, dev sr0, sector 1225216 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[  141.722406] Buffer I/O error on dev sr0, logical block 153152, async page read
[  142.545489] sr 14:0:0:0: [sr0] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=DRIVER_OK cmd_age=0s
[  142.545494] sr 14:0:0:0: [sr0] tag#0 Sense Key : 0x5 [current]
[  142.545498] sr 14:0:0:0: [sr0] tag#0 ASC=0x63 ASCQ=0x0
[  142.545502] sr 14:0:0:0: [sr0] tag#0 CDB: opcode=0x28 28 00 00 04 ad b4 00 00 02 00
[  142.545504] I/O error, dev sr0, sector 1226448 op 0x0:(READ) flags 0x80700 phys_seg 1 prio class 0
[  929.118155] usb 1-8: reset high-speed USB device number 3 using xhci_hcd
[  929.322872] usb 1-8: device firmware changed
[  929.322936] usb 1-8: USB disconnect, device number 3
[  929.545965] usb 1-8: new high-speed USB device number 4 using xhci_hcd
[  929.767979] usb 1-8: New USB device found, idVendor=152d, idProduct=2338, bcdDevice= 1.00
[  929.767988] usb 1-8: New USB device strings: Mfr=1, Product=2, SerialNumber=5
[  929.767992] usb 1-8: Product: USB to ATA/ATAPI bridge
[  929.767995] usb 1-8: Manufacturer: JMicron
[  929.767998] usb 1-8: SerialNumber: 4922CD522200
[  929.788999] usb-storage 1-8:1.0: USB Mass Storage device detected
[  929.789230] scsi host15: usb-storage 1-8:1.0
[  931.739972] scsi 15:0:0:0: CD-ROM            PLEXTOR  CD-R   PX-W4012A 1.07 PQ: 0 ANSI: 0 CCS
[  937.131209] sr 15:0:0:0: Power-on or device reset occurred
[  937.131767] sr 15:0:0:0: [sr1] scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
[  937.132805] sr 15:0:0:0: Attached scsi CD-ROM sr1
[  937.132930] sr 15:0:0:0: Attached scsi generic sg5 type 5
[  949.698016] sr 15:0:0:0: [sr1] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=DRIVER_OK cmd_age=2s
[  949.698026] sr 15:0:0:0: [sr1] tag#0 Sense Key : 0x5 [current]
[  949.698030] sr 15:0:0:0: [sr1] tag#0 ASC=0x63 ASCQ=0x0
[  949.698035] sr 15:0:0:0: [sr1] tag#0 CDB: opcode=0x28 28 00 00 04 ad b6 00 00 02 00
[  949.698039] I/O error, dev sr1, sector 1226456 op 0x0:(READ) flags 0x80700 phys_seg 1 prio class 0
[  951.444988] sr 15:0:0:0: [sr1] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=DRIVER_OK cmd_age=0s
[  951.444996] sr 15:0:0:0: [sr1] tag#0 Sense Key : 0x5 [current]
[  951.445000] sr 15:0:0:0: [sr1] tag#0 ASC=0x63 ASCQ=0x0
[  951.445008] sr 15:0:0:0: [sr1] tag#0 CDB: opcode=0x28 28 00 00 04 ac 80 00 00 3c 00
[  951.445011] I/O error, dev sr1, sector 1225216 op 0x0:(READ) flags 0x84700 phys_seg 30 prio class 0
[  952.244113] sr 15:0:0:0: [sr1] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=DRIVER_OK cmd_age=0s
[  952.244120] sr 15:0:0:0: [sr1] tag#0 Sense Key : 0x5 [current]
[  952.244123] sr 15:0:0:0: [sr1] tag#0 ASC=0x63 ASCQ=0x0
[  952.244127] sr 15:0:0:0: [sr1] tag#0 CDB: opcode=0x28 28 00 00 04 ac bc 00 00 04 00
[  952.244129] I/O error, dev sr1, sector 1225456 op 0x0:(READ) flags 0x80700 phys_seg 2 prio class 0
[  953.042271] sr 15:0:0:0: [sr1] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=DRIVER_OK cmd_age=0s
[  953.042278] sr 15:0:0:0: [sr1] tag#0 Sense Key : 0x5 [current]
[  953.042281] sr 15:0:0:0: [sr1] tag#0 ASC=0x63 ASCQ=0x0
[  953.042284] sr 15:0:0:0: [sr1] tag#0 CDB: opcode=0x28 28 00 00 04 ac 80 00 00 02 00
[  953.042286] I/O error, dev sr1, sector 1225216 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[  953.042291] Buffer I/O error on dev sr1, logical block 153152, async page read
[  953.840453] sr 15:0:0:0: [sr1] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=DRIVER_OK cmd_age=0s
[  953.840463] sr 15:0:0:0: [sr1] tag#0 Sense Key : 0x5 [current]
[  953.840467] sr 15:0:0:0: [sr1] tag#0 ASC=0x63 ASCQ=0x0
[  953.840472] sr 15:0:0:0: [sr1] tag#0 CDB: opcode=0x28 28 00 00 04 ad b4 00 00 02 00
[  953.840475] I/O error, dev sr1, sector 1226448 op 0x0:(READ) flags 0x80700 phys_seg 1 prio class 0
[ 1329.388291] BUG: kernel NULL pointer dereference, address: 0000000000000248
[ 1329.388301] #PF: supervisor read access in kernel mode
[ 1329.388305] #PF: error_code(0x0000) - not-present page
[ 1329.388310] PGD 0 P4D 0
[ 1329.388317] Oops: 0000 [#1] SMP NOPTI
[ 1329.388322] CPU: 17 PID: 3195 Comm: DiscImageCreato Not tainted 6.9.0-rc5-maxz #4
[ 1329.388328] Hardware name: System manufacturer System Product Name/PRIME B450-PLUS, BIOS 4401 09/04/2023
[ 1329.388333] RIP: 0010:scsi_block_when_processing_errors (./include/scsi/scsi_host.h:751 drivers/scsi/scsi_error.c:388) 
[ 1329.388342] Code: 00 90 f3 0f 1e fa 48 83 ec 38 48 89 5c 24 30 48 89 fb 65 48 8b 04 25 28 00 00 00 48 89 44 24 28 31 c0 e8 5b f4 5c 00 48 8b 13 <8b> 82 48 02 00 00 83 e8 05 83 f8 02 76 09 f6 82 f8 01 00 00 10 74
All code
========
   0:	00 90 f3 0f 1e fa    	add    %dl,-0x5e1f00d(%rax)
   6:	48 83 ec 38          	sub    $0x38,%rsp
   a:	48 89 5c 24 30       	mov    %rbx,0x30(%rsp)
   f:	48 89 fb             	mov    %rdi,%rbx
  12:	65 48 8b 04 25 28 00 	mov    %gs:0x28,%rax
  19:	00 00 
  1b:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  20:	31 c0                	xor    %eax,%eax
  22:	e8 5b f4 5c 00       	call   0x5cf482
  27:	48 8b 13             	mov    (%rbx),%rdx
  2a:*	8b 82 48 02 00 00    	mov    0x248(%rdx),%eax		<-- trapping instruction
  30:	83 e8 05             	sub    $0x5,%eax
  33:	83 f8 02             	cmp    $0x2,%eax
  36:	76 09                	jbe    0x41
  38:	f6 82 f8 01 00 00 10 	testb  $0x10,0x1f8(%rdx)
  3f:	74                   	.byte 0x74

Code starting with the faulting instruction
===========================================
   0:	8b 82 48 02 00 00    	mov    0x248(%rdx),%eax
   6:	83 e8 05             	sub    $0x5,%eax
   9:	83 f8 02             	cmp    $0x2,%eax
   c:	76 09                	jbe    0x17
   e:	f6 82 f8 01 00 00 10 	testb  $0x10,0x1f8(%rdx)
  15:	74                   	.byte 0x74
[ 1329.388348] RSP: 0018:ffffa8f18294fc80 EFLAGS: 00010246
[ 1329.388354] RAX: 0000000000000000 RBX: ffff8cf08679b800 RCX: 0000000000000000
[ 1329.388358] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[ 1329.388362] RBP: ffffa8f18294fcd8 R08: 0000000000000000 R09: 0000000000000004
[ 1329.388366] R10: ffffa8f18294fdcc R11: 0000000000000000 R12: ffffa8f18294fd58
[ 1329.388370] R13: ffff8cf08679b800 R14: 0000000000000000 R15: ffffa8f18294fcd0
[ 1329.388374] FS:  000077c954b60480(0000) GS:ffff8cff6ee40000(0000) knlGS:0000000000000000
[ 1329.388379] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1329.388384] CR2: 0000000000000248 CR3: 0000000100c8e000 CR4: 0000000000350ef0
[ 1329.388388] Call Trace:
[ 1329.388393]  <TASK>
[ 1329.388397] ? __die (arch/x86/kernel/dumpstack.c:421 arch/x86/kernel/dumpstack.c:434) 
[ 1329.388404] ? page_fault_oops (arch/x86/mm/fault.c:708) 
[ 1329.388412] ? exc_page_fault (./arch/x86/include/asm/irqflags.h:37 ./arch/x86/include/asm/irqflags.h:72 arch/x86/mm/fault.c:1513 arch/x86/mm/fault.c:1563) 
[ 1329.388419] ? asm_exc_page_fault (./arch/x86/include/asm/idtentry.h:623) 
[ 1329.388427] ? scsi_block_when_processing_errors (./include/scsi/scsi_host.h:751 drivers/scsi/scsi_error.c:388) 
[ 1329.388433] ? srso_return_thunk (arch/x86/lib/retpoline.S:224) 
[ 1329.388439] ? __slab_free (mm/slub.c:4090) 
[ 1329.388445] sr_do_ioctl (drivers/scsi/sr_ioctl.c:202 (discriminator 1)) 
[ 1329.388454] sr_packet (drivers/scsi/sr.c:924) 
[ 1329.388459] cdrom_get_disc_info (drivers/cdrom/cdrom.c:385) 
[ 1329.388467] cdrom_mrw_exit (drivers/cdrom/cdrom.c:538) 
[ 1329.388473] ? srso_return_thunk (arch/x86/lib/retpoline.S:224) 
[ 1329.388478] ? xa_destroy (lib/xarray.c:948 lib/xarray.c:2221) 
[ 1329.388484] ? srso_return_thunk (arch/x86/lib/retpoline.S:224) 
[ 1329.388489] ? __cond_resched (kernel/sched/core.c:8607) 
[ 1329.388496] unregister_cdrom (drivers/cdrom/cdrom.c:657) 
[ 1329.388501] sr_free_disk (drivers/scsi/sr.c:576) 
[ 1329.388507] disk_release (block/genhd.c:1194) 
[ 1329.388515] device_release (drivers/base/core.c:2585) 
[ 1329.388521] kobject_release (lib/kobject.c:693 lib/kobject.c:720) 
[ 1329.388529] blkdev_release (block/fops.c:630) 
[ 1329.388536] __fput (fs/file_table.c:423 (discriminator 1)) 
[ 1329.388543] __x64_sys_close (fs/open.c:1559 fs/open.c:1541 fs/open.c:1541) 
[ 1329.388549] do_syscall_64 (arch/x86/entry/common.c:52 (discriminator 1) arch/x86/entry/common.c:83 (discriminator 1)) 
[ 1329.388556] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130) 
[ 1329.388562] RIP: 0033:0x77c954d3cea4
[ 1329.388568] Code: 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 80 3d c5 34 0e 00 00 74 13 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 44 c3 0f 1f 00 48 83 ec 18 89 7c 24 0c e8 a3
All code
========
   0:	00 f7                	add    %dh,%bh
   2:	d8 64 89 01          	fsubs  0x1(%rcx,%rcx,4)
   6:	48 83 c8 ff          	or     $0xffffffffffffffff,%rax
   a:	c3                   	ret
   b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  12:	00 00 00 
  15:	90                   	nop
  16:	f3 0f 1e fa          	endbr64
  1a:	80 3d c5 34 0e 00 00 	cmpb   $0x0,0xe34c5(%rip)        # 0xe34e6
  21:	74 13                	je     0x36
  23:	b8 03 00 00 00       	mov    $0x3,%eax
  28:	0f 05                	syscall
  2a:*	48 3d 00 f0 ff ff    	cmp    $0xfffffffffffff000,%rax		<-- trapping instruction
  30:	77 44                	ja     0x76
  32:	c3                   	ret
  33:	0f 1f 00             	nopl   (%rax)
  36:	48 83 ec 18          	sub    $0x18,%rsp
  3a:	89 7c 24 0c          	mov    %edi,0xc(%rsp)
  3e:	e8                   	.byte 0xe8
  3f:	a3                   	.byte 0xa3

Code starting with the faulting instruction
===========================================
   0:	48 3d 00 f0 ff ff    	cmp    $0xfffffffffffff000,%rax
   6:	77 44                	ja     0x4c
   8:	c3                   	ret
   9:	0f 1f 00             	nopl   (%rax)
   c:	48 83 ec 18          	sub    $0x18,%rsp
  10:	89 7c 24 0c          	mov    %edi,0xc(%rsp)
  14:	e8                   	.byte 0xe8
  15:	a3                   	.byte 0xa3
[ 1329.388572] RSP: 002b:00007ffc967a9aa8 EFLAGS: 00000202 ORIG_RAX: 0000000000000003
[ 1329.388579] RAX: ffffffffffffffda RBX: 00007ffc967aad10 RCX: 000077c954d3cea4
[ 1329.388583] RDX: 000077c9547fd000 RSI: 000000000012c000 RDI: 0000000000000004
[ 1329.388587] RBP: 00007ffc967aad04 R08: 000000000012c000 R09: 0000000000000007
[ 1329.388591] R10: 0000000000000007 R11: 0000000000000202 R12: 0000000000000000
[ 1329.388595] R13: 00007ffc967a9ad0 R14: 00007ffc967a9ac8 R15: 0000000000000001
[ 1329.388601]  </TASK>
[ 1329.388604] Modules linked in:
[ 1329.388609] CR2: 0000000000000248
[ 1329.388614] ---[ end trace 0000000000000000 ]---
[ 1329.452047] pstore: backend (efi_pstore) writing error (-5)
[ 1329.452054] RIP: 0010:scsi_block_when_processing_errors (./include/scsi/scsi_host.h:751 drivers/scsi/scsi_error.c:388) 
[ 1329.452063] Code: 00 90 f3 0f 1e fa 48 83 ec 38 48 89 5c 24 30 48 89 fb 65 48 8b 04 25 28 00 00 00 48 89 44 24 28 31 c0 e8 5b f4 5c 00 48 8b 13 <8b> 82 48 02 00 00 83 e8 05 83 f8 02 76 09 f6 82 f8 01 00 00 10 74
All code
========
   0:	00 90 f3 0f 1e fa    	add    %dl,-0x5e1f00d(%rax)
   6:	48 83 ec 38          	sub    $0x38,%rsp
   a:	48 89 5c 24 30       	mov    %rbx,0x30(%rsp)
   f:	48 89 fb             	mov    %rdi,%rbx
  12:	65 48 8b 04 25 28 00 	mov    %gs:0x28,%rax
  19:	00 00 
  1b:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  20:	31 c0                	xor    %eax,%eax
  22:	e8 5b f4 5c 00       	call   0x5cf482
  27:	48 8b 13             	mov    (%rbx),%rdx
  2a:*	8b 82 48 02 00 00    	mov    0x248(%rdx),%eax		<-- trapping instruction
  30:	83 e8 05             	sub    $0x5,%eax
  33:	83 f8 02             	cmp    $0x2,%eax
  36:	76 09                	jbe    0x41
  38:	f6 82 f8 01 00 00 10 	testb  $0x10,0x1f8(%rdx)
  3f:	74                   	.byte 0x74

Code starting with the faulting instruction
===========================================
   0:	8b 82 48 02 00 00    	mov    0x248(%rdx),%eax
   6:	83 e8 05             	sub    $0x5,%eax
   9:	83 f8 02             	cmp    $0x2,%eax
   c:	76 09                	jbe    0x17
   e:	f6 82 f8 01 00 00 10 	testb  $0x10,0x1f8(%rdx)
  15:	74                   	.byte 0x74
[ 1329.452068] RSP: 0018:ffffa8f18294fc80 EFLAGS: 00010246
[ 1329.452074] RAX: 0000000000000000 RBX: ffff8cf08679b800 RCX: 0000000000000000
[ 1329.452079] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[ 1329.452083] RBP: ffffa8f18294fcd8 R08: 0000000000000000 R09: 0000000000000004
[ 1329.452086] R10: ffffa8f18294fdcc R11: 0000000000000000 R12: ffffa8f18294fd58
[ 1329.452091] R13: ffff8cf08679b800 R14: 0000000000000000 R15: ffffa8f18294fcd0
[ 1329.452095] FS:  000077c954b60480(0000) GS:ffff8cff6ee40000(0000) knlGS:0000000000000000
[ 1329.452100] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1329.452104] CR2: 0000000000000248 CR3: 0000000100c8e000 CR4: 0000000000350ef0
[ 1329.452109] note: DiscImageCreato[3195] exited with irqs disabled

--/MekBxPzKyiz2ziv--
