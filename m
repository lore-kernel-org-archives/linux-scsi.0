Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739323C3C
	for <linux-scsi@vger.kernel.org>; Wed, 20 Nov 2024 04:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732076610; cv=none; b=dsYPC6ouLtvFtpZ6jXBFxbWHcwBrXT9qNYI18nXr+A+ubDsd4Z7rs9JD08GNg1cKif9BQRmaM5UsRd/GZbzThULu50Ll3XMoSPG5azKa74P3oyjeDdGDZyY1UoqvhA8sd6QWiA8skKvcQOZLHXbvyMG8iB2rZsRGhZiaU2vHrEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732076610; c=relaxed/simple;
	bh=/oHVUI/Y1A96yTMqP59ZKPaZtM0WZTbLj39uTUysbIQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=sUhbZFjQiC3EvEhBoyywhNEjYgy4+iV3lTX8xyzL/gGjoHHK1LCAEL1G5Cc32CSkm27QIvLsVlH8l2Tp4rUgtuaysOS4sLm/cTCqKUwUswTs/DrTlF6RywABMgNV+YIyVbgCLueXnEvuGluwzbBf8CWVi9CQMirjcDo5Xp7i7rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XpXs9TJ2; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XpXs9TJ2"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-83a9cd37a11so63223139f.3
        for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2024 20:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732076605; x=1732681405; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KrZsFkg2/fQRWAXcieBtEb0S5B4oPHslX2RC3I1z9fk=;
        b=XpXs9TJ2ZlnU4EI9KxhVapqbIXIW0fMtsK9MVXlccdryznrvE4yYPDn+u42zdhMGOa
         9mXFBHf6EuAlCtcxshsgLRpoL+skSxFypUeVPRTNJF23DSaf+C2MrB/WBCPUqBZhUinI
         LCEceXeUUkioPVIelSUfYtjpVq5K2VHKa2hcuXoTkT60vrDXX6vrccXcIdM3NZnkAGPU
         k1oOjYbIZqvW9QpNUc8tIAoPru08umW1AlcYOqeWZkGUBIvqlFpmlR1PggtuCn3dRQ9d
         U0uEEvxjyqMgH1rkOz1fIxkdZ8S0rKr59dFXtve8umlNjwTVj2t9nOomOn2qLQUmMdS+
         jWPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732076605; x=1732681405;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KrZsFkg2/fQRWAXcieBtEb0S5B4oPHslX2RC3I1z9fk=;
        b=wiyHQ+Gcb7sy14I10mmk3Hk5afyKVslJ403+rv8aRW08JqYLcpDsHK+2kcqfOarqQh
         AdNdphnoMEGaSpLS84BEPS8Gv5EA4960uMqubE6i1ScTCilZF63nE4LwQj6flINA9UOj
         twbN/C6O8t0xplY27EBPilaydQX3o2xjERmY5bF6yYWu2eadEe1JicXU4CQ4OLNlEPa9
         fEJORtJsFDNGbe4XKbC6wRMDvmqkLhd0/vaRlOtP6bghzCXRwKPxybv1XbeqK2NfIX19
         QOq32ugPe1ZVDLsF50e+1fu++tiUdjXt+GMJTEB8zBOB49U/qwB53TCMzJf6FV0gUO6o
         LJrQ==
X-Forwarded-Encrypted: i=1; AJvYcCVZv3jzN/oxPaVzGBktupO9gRNm5/NxhelgkQHrQmY/FC+7nllGN0liCeXCB2350SloJbGjLUkdnL+N@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9qOm9QxEXR6oatxUETHR7b11BxuBAFzexoz4CXsp7OIUea/7I
	nDIuXxbxtwenPudhAyta8kjENGOHnmfWFDQqfavdgcIvtjkJb02ZtoPhvMfTkpg7S9DsNFLSxHi
	GE3frhrP1zW+bSr8mJGrE/DvNpcw=
X-Google-Smtp-Source: AGHT+IFY+vqIvnBf/6kZqQZpIY0RSfbH1+88vek2/unsBqfuZhX1wcjDsFgIIs9dSQiug6lT12OxPNm+MDLm7bYXOT8=
X-Received: by 2002:a05:6602:3424:b0:83a:db84:41a8 with SMTP id
 ca18e2360f4ac-83eb6095330mr167972139f.10.1732076605287; Tue, 19 Nov 2024
 20:23:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+-ZZ_gPfU19PdfdiK7NDJpi42bF4wviUR4+8_1vbqd=FZS3yg@mail.gmail.com>
In-Reply-To: <CA+-ZZ_gPfU19PdfdiK7NDJpi42bF4wviUR4+8_1vbqd=FZS3yg@mail.gmail.com>
From: reveliofuzzing <reveliofuzzing@gmail.com>
Date: Tue, 19 Nov 2024 23:23:14 -0500
Message-ID: <CA+-ZZ_hqBcx_jcPsDkZ=1hbctSw5ui2UjcZ8c8oXH-x61nDX7g@mail.gmail.com>
Subject: Fwd: Report "general protection fault in unmap_vmas"
To: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, 
	linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

We would like to forward this bug report to the scsi developers because
the bug-inducing test seems to involve scsi ioctl.

Also, we have confirmed that the test can crash Linux kernel 6.12.

---------- Forwarded message ---------
From: reveliofuzzing <reveliofuzzing@gmail.com>
Date: Tue, Nov 19, 2024 at 10:38=E2=80=AFAM
Subject: Report "general protection fault in unmap_vmas"
To: <linux-mm@kvack.org>


Hello,

We found a kernel crash at `unmap_vmas` when running a test generated
by Syzkaller on Linux kernel 6.10, both of which are unmodified. We would l=
ike
to report it for your reference because this crash has not been observed be=
fore.

In a 2-core qemu-kvm VM, this crash took about 1 minute to happen.

This report comes with:
- the console log of the guest VM
- the test (syzlang syntax)
- the test (c program) (url)
- the compiled test (url)
- kernel configuration (url)
- the compiled kernel (url)


- Crash
syzkaller login: [   22.005245] program syz-executor is using a
deprecated SCSI ioctl, please convert it to SG_IO
[   83.496476] ata1: lost interrupt (Status 0x58)
[   84.532478] clocksource: Long readout interval, skipping watchdog
check: cs_nsec: 1455987654 wd_nsec: 1455987593
[   84.693047] ata1: found unknown device (class 0)
[   84.696781] Oops: general protection fault, probably for
non-canonical address 0xdffffc0000000090: 0000 [#1] PREEMPT SMP KASAN
PTI
[   84.699625] KASAN: null-ptr-deref in range
[0x0000000000000480-0x0000000000000487]
[   84.701454] CPU: 1 PID: 232 Comm: syz-executor Not tainted 6.10.0 #2
[   84.702995] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.13.0-1ubuntu1.1 04/01/2014
[   84.705181] RIP: 0010:unmap_vmas+0x13e/0x3c0
[   84.706950] Code: 00 00 00 00 00 e8 22 ac 7f 02 48 8b 84 24 c8 00
00 00 48 ba 00 00 00 00 00 fc ff df 48 8d b8 80 04 00 00 48 89 f9 48
c11
[   84.711418] RSP: 0018:ffff88800c3e78a0 EFLAGS: 00010206
[   84.712703] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000000000=
00090
[   84.714430] RDX: dffffc0000000000 RSI: ffffffff81635b11 RDI: 00000000000=
00480
[   84.716152] RBP: ffff88800c681ee0 R08: ffffffffffffffff R09: fffffffffff=
fffff
[   84.717909] R10: ffffed1000f67931 R11: ffff888007b3c98b R12: fffffffffff=
fffff
[   84.719640] R13: dffffc0000000000 R14: ffffffffffffffff R15: 00000000000=
00000
[   84.721375] FS:  0000000000000000(0000) GS:ffff88806d300000(0000)
knlGS:0000000000000000
[   84.723361] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   84.724791] CR2: 000055cdc0a948a8 CR3: 0000000004e66000 CR4: 00000000000=
006f0
[   84.726545] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[   84.728278] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[   84.730029] Call Trace:
[   84.730672]  <TASK>
[   84.731232]  ? show_regs+0x73/0x80
[   84.732100]  ? __die_body+0x1f/0x70
[   84.732985]  ? die_addr+0x4c/0x90
[   84.733833]  ? exc_general_protection+0x15c/0x2a0
[   84.735024]  ? asm_exc_general_protection+0x26/0x30
[   84.736434]  ? unmap_vmas+0xb1/0x3c0
[   84.737364]  ? unmap_vmas+0x13e/0x3c0
[   84.738320]  ? __pfx_unmap_vmas+0x10/0x10
[   84.739340]  ? free_ldt_pgtables+0x94/0x180
[   84.740388]  ? mas_walk+0x986/0xd10
[   84.741285]  ? mas_next_slot+0xed8/0x1be0
[   84.742300]  ? stack_depot_save_flags+0x5ef/0x6f0
[   84.743482]  exit_mmap+0x171/0x810
[   84.744358]  ? __pfx_exit_mmap+0x10/0x10
[   84.745354]  ? exit_aio+0x260/0x340
[   84.746257]  ? mutex_unlock+0x7e/0xd0
[   84.747185]  ? __pfx_mutex_unlock+0x10/0x10
[   84.748222]  ? delayed_uprobe_remove+0x21/0x130
[   84.749356]  mmput+0x64/0x290
[   84.750179]  do_exit+0x7fd/0x2850
[   84.751060]  ? blk_mq_run_hw_queue+0x321/0x520
[   84.752176]  ? kasan_save_track+0x14/0x30
[   84.753194]  ? __pfx_do_exit+0x10/0x10
[   84.754159]  ? scsi_ioctl+0xa16/0x12c0
[   84.755107]  ? _raw_spin_lock_irq+0x81/0xe0
[   84.756161]  do_group_exit+0xb6/0x260
[   84.757107]  get_signal+0x19e3/0x1b00
[   84.758041]  ? __handle_mm_fault+0x644/0x21c0
[   84.759129]  ? __pfx_get_signal+0x10/0x10
[   84.760135]  arch_do_signal_or_restart+0x81/0x750
[   84.761304]  ? __pfx_arch_do_signal_or_restart+0x10/0x10
[   84.762621]  ? handle_mm_fault+0xe6/0x520
[   84.763624]  ? __fget_light+0x175/0x510
[   84.764586]  ? do_user_addr_fault+0x7de/0x1250
[   84.765699]  syscall_exit_to_user_mode+0xf6/0x140
[   84.766879]  do_syscall_64+0x57/0x110
[   84.767810]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   84.769062] RIP: 0033:0x7f15ec6a6aad
[   84.769968] Code: Unable to access opcode bytes at 0x7f15ec6a6a83.
[   84.771469] RSP: 002b:00007ffe4c340428 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[   84.773299] RAX: 0000000000000002 RBX: 00007ffe4c340450 RCX: 00007f15ec6=
a6aad
[   84.775039] RDX: 0000000020000040 RSI: 0000000000000001 RDI: 00000000000=
00003
[   84.776795] RBP: 0000000000000000 R08: 0000000000000012 R09: 00000000000=
00000
[   84.778532] R10: 00007f15ec6f403c R11: 0000000000000246 R12: 00007ffe4c3=
40460
[   84.780263] R13: 00007f15ec71edf0 R14: 0000000000000000 R15: 00000000000=
00000
[   84.782008]  </TASK>
[   84.782586] Modules linked in:
[   84.783488] ---[ end trace 0000000000000000 ]---
[   84.784787] RIP: 0010:unmap_vmas+0x13e/0x3c0
[   84.785965] Code: 00 00 00 00 00 e8 22 ac 7f 02 48 8b 84 24 c8 00
00 00 48 ba 00 00 00 00 00 fc ff df 48 8d b8 80 04 00 00 48 89 f9 48
c11
[   84.790487] RSP: 0018:ffff88800c3e78a0 EFLAGS: 00010206
[   84.791870] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000000000=
00090
[   84.793702] RDX: dffffc0000000000 RSI: ffffffff81635b11 RDI: 00000000000=
00480
[   84.795546] RBP: ffff88800c681ee0 R08: ffffffffffffffff R09: fffffffffff=
fffff
[   84.797424] R10: ffffed1000f67931 R11: ffff888007b3c98b R12: fffffffffff=
fffff
[   84.799258] R13: dffffc0000000000 R14: ffffffffffffffff R15: 00000000000=
00000
[   84.801081] FS:  0000000000000000(0000) GS:ffff88806d300000(0000)
knlGS:0000000000000000
[   84.803135] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   84.804655] CR2: 000055cdc0a948a8 CR3: 0000000004e66000 CR4: 00000000000=
006f0
[   84.806521] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[   84.808419] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[   84.810281] Fixing recursive fault but reboot is needed!
[   84.811680] BUG: scheduling while atomic: syz-executor/232/0x00000000
[   84.813351] Modules linked in:
[   84.814245] CPU: 1 PID: 232 Comm: syz-executor Tainted: G      D
        6.10.0 #2
[   84.816151] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.13.0-1ubuntu1.1 04/01/2014
[   84.818353] Call Trace:
[   84.818988]  <TASK>
[   84.819548]  dump_stack_lvl+0x7d/0xa0
[   84.820470]  __schedule_bug+0xaa/0xf0
[   84.821414]  ? irq_work_queue+0x23/0x60
[   84.822404]  __schedule+0x17ce/0x2010
[   84.823336]  ? __wake_up_klogd.part.0+0x69/0x80
[   84.824469]  ? vprintk_emit+0x239/0x300
[   84.825431]  ? __pfx___schedule+0x10/0x10
[   84.826451]  ? vprintk+0x6b/0x80
[   84.827276]  ? _printk+0xbf/0x100
[   84.828123]  ? __pfx__printk+0x10/0x10
[   84.829065]  ? _raw_spin_lock_irqsave+0x86/0xe0
[   84.830214]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
[   84.831460]  do_task_dead+0x9d/0xc0
[   84.832344]  make_task_dead+0x2f6/0x340
[   84.833319]  rewind_stack_and_make_dead+0x16/0x20
[   84.834504] RIP: 0033:0x7f15ec6a6aad
[   84.835404] Code: Unable to access opcode bytes at 0x7f15ec6a6a83.
[   84.836920] RSP: 002b:00007ffe4c340428 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[   84.838751] RAX: 0000000000000002 RBX: 00007ffe4c340450 RCX: 00007f15ec6=
a6aad
[   84.840474] RDX: 0000000020000040 RSI: 0000000000000001 RDI: 00000000000=
00003
[   84.842209] RBP: 0000000000000000 R08: 0000000000000012 R09: 00000000000=
00000
[   84.843932] R10: 00007f15ec6f403c R11: 0000000000000246 R12: 00007ffe4c3=
40460
[   84.845654] R13: 00007f15ec71edf0 R14: 0000000000000000 R15: 00000000000=
00000
[   84.847402]  </TASK>


- syzlang test
r0 =3D syz_open_dev$sg(&(0x7f0000000000), 0x0, 0x0)
ioctl$SCSI_IOCTL_SEND_COMMAND(r0, 0x1,
&(0x7f0000000040)=3DANY=3D[@ANYBLOB=3D"00000000420d0000850aaa",
@ANYRESHEX=3Dr0])


- c test
// autogenerated by syzkaller (https://github.com/google/syzkaller)

#define _GNU_SOURCE

#include <dirent.h>
#include <endian.h>
#include <errno.h>
#include <fcntl.h>
#include <sched.h>
#include <setjmp.h>
#include <signal.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mount.h>
#include <sys/prctl.h>
#include <sys/resource.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#include <linux/capability.h>

static unsigned long long procid;

static __thread int clone_ongoing;
static __thread int skip_segv;
static __thread jmp_buf segv_env;

static void segv_handler(int sig, siginfo_t* info, void* ctx)
{
        if (__atomic_load_n(&clone_ongoing, __ATOMIC_RELAXED) !=3D 0) {
                exit(sig);
        }
        uintptr_t addr =3D (uintptr_t)info->si_addr;
        const uintptr_t prog_start =3D 1 << 20;
        const uintptr_t prog_end =3D 100 << 20;
        int skip =3D __atomic_load_n(&skip_segv, __ATOMIC_RELAXED) !=3D 0;
        int valid =3D addr < prog_start || addr > prog_end;
        if (skip && valid) {
                _longjmp(segv_env, 1);
        }
        exit(sig);
}

static void install_segv_handler(void)
{
        struct sigaction sa;
        memset(&sa, 0, sizeof(sa));
        sa.sa_handler =3D SIG_IGN;
        syscall(SYS_rt_sigaction, 0x20, &sa, NULL, 8);
        syscall(SYS_rt_sigaction, 0x21, &sa, NULL, 8);
        memset(&sa, 0, sizeof(sa));
        sa.sa_sigaction =3D segv_handler;
        sa.sa_flags =3D SA_NODEFER | SA_SIGINFO;
        sigaction(SIGSEGV, &sa, NULL);
        sigaction(SIGBUS, &sa, NULL);
}

#define NONFAILING(...) ({ int ok =3D 1; __atomic_fetch_add(&skip_segv,
1, __ATOMIC_SEQ_CST); if (_setjmp(segv_env) =3D=3D 0) { __VA_ARGS__; }
else ok =3D 0; __atomic_fetch_sub(&skip_segv, 1, __ATOMIC_SEQ_CST); ok;
})

static void sleep_ms(uint64_t ms)
{
        usleep(ms * 1000);
}

static uint64_t current_time_ms(void)
{
        struct timespec ts;
        if (clock_gettime(CLOCK_MONOTONIC, &ts))
        exit(1);
        return (uint64_t)ts.tv_sec * 1000 + (uint64_t)ts.tv_nsec / 1000000;
}

static bool write_file(const char* file, const char* what, ...)
{
        char buf[1024];
        va_list args;
        va_start(args, what);
        vsnprintf(buf, sizeof(buf), what, args);
        va_end(args);
        buf[sizeof(buf) - 1] =3D 0;
        int len =3D strlen(buf);
        int fd =3D open(file, O_WRONLY | O_CLOEXEC);
        if (fd =3D=3D -1)
                return false;
        if (write(fd, buf, len) !=3D len) {
                int err =3D errno;
                close(fd);
                errno =3D err;
                return false;
        }
        close(fd);
        return true;
}

static long syz_open_dev(volatile long a0, volatile long a1, volatile long =
a2)
{
        if (a0 =3D=3D 0xc || a0 =3D=3D 0xb) {
                char buf[128];
                sprintf(buf, "/dev/%s/%d:%d", a0 =3D=3D 0xc ? "char" :
"block", (uint8_t)a1, (uint8_t)a2);
                return open(buf, O_RDWR, 0);
        } else {
                char buf[1024];
                char* hash;
                strncpy(buf, (char*)a0, sizeof(buf) - 1);
                buf[sizeof(buf) - 1] =3D 0;
                while ((hash =3D strchr(buf, '#'))) {
                        *hash =3D '0' + (char)(a1 % 10);
                        a1 /=3D 10;
                }
                return open(buf, a2, 0);
        }
}

static void setup_binderfs();
static void setup_fusectl();
static void sandbox_common_mount_tmpfs(void)
{
        write_file("/proc/sys/fs/mount-max", "100000");
        if (mkdir("./syz-tmp", 0777))
        exit(1);
        if (mount("", "./syz-tmp", "tmpfs", 0, NULL))
        exit(1);
        if (mkdir("./syz-tmp/newroot", 0777))
        exit(1);
        if (mkdir("./syz-tmp/newroot/dev", 0700))
        exit(1);
        unsigned bind_mount_flags =3D MS_BIND | MS_REC | MS_PRIVATE;
        if (mount("/dev", "./syz-tmp/newroot/dev", NULL,
bind_mount_flags, NULL))
        exit(1);
        if (mkdir("./syz-tmp/newroot/proc", 0700))
        exit(1);
        if (mount("syz-proc", "./syz-tmp/newroot/proc", "proc", 0, NULL))
        exit(1);
        if (mkdir("./syz-tmp/newroot/selinux", 0700))
        exit(1);
        const char* selinux_path =3D "./syz-tmp/newroot/selinux";
        if (mount("/selinux", selinux_path, NULL, bind_mount_flags, NULL)) =
{
                if (errno !=3D ENOENT)
        exit(1);
                if (mount("/sys/fs/selinux", selinux_path, NULL,
bind_mount_flags, NULL) && errno !=3D ENOENT)
        exit(1);
        }
        if (mkdir("./syz-tmp/newroot/sys", 0700))
        exit(1);
        if (mount("/sys", "./syz-tmp/newroot/sys", 0, bind_mount_flags, NUL=
L))
        exit(1);
        if (mount("/sys/kernel/debug",
"./syz-tmp/newroot/sys/kernel/debug", NULL, bind_mount_flags, NULL) &&
errno !=3D ENOENT)
        exit(1);
        if (mount("/sys/fs/smackfs",
"./syz-tmp/newroot/sys/fs/smackfs", NULL, bind_mount_flags, NULL) &&
errno !=3D ENOENT)
        exit(1);
        if (mount("/proc/sys/fs/binfmt_misc",
"./syz-tmp/newroot/proc/sys/fs/binfmt_misc", NULL, bind_mount_flags,
NULL) && errno !=3D ENOENT)
        exit(1);
        if (mkdir("./syz-tmp/pivot", 0777))
        exit(1);
        if (syscall(SYS_pivot_root, "./syz-tmp", "./syz-tmp/pivot")) {
                if (chdir("./syz-tmp"))
        exit(1);
        } else {
                if (chdir("/"))
        exit(1);
                if (umount2("./pivot", MNT_DETACH))
        exit(1);
        }
        if (chroot("./newroot"))
        exit(1);
        if (chdir("/"))
        exit(1);
        setup_binderfs();
        setup_fusectl();
}

static void setup_fusectl()
{
        if (mount(0, "/sys/fs/fuse/connections", "fusectl", 0, 0)) {
        }
}

static void setup_binderfs()
{
        if (mkdir("/dev/binderfs", 0777)) {
        }
        if (mount("binder", "/dev/binderfs", "binder", 0, NULL)) {
        }
        if (symlink("/dev/binderfs", "./binderfs")) {
        }
}

static void loop();

static void sandbox_common()
{
        prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);
        if (getppid() =3D=3D 1)
        exit(1);
        struct rlimit rlim;
        rlim.rlim_cur =3D rlim.rlim_max =3D (200 << 20);
        setrlimit(RLIMIT_AS, &rlim);
        rlim.rlim_cur =3D rlim.rlim_max =3D 32 << 20;
        setrlimit(RLIMIT_MEMLOCK, &rlim);
        rlim.rlim_cur =3D rlim.rlim_max =3D 136 << 20;
        setrlimit(RLIMIT_FSIZE, &rlim);
        rlim.rlim_cur =3D rlim.rlim_max =3D 1 << 20;
        setrlimit(RLIMIT_STACK, &rlim);
        rlim.rlim_cur =3D rlim.rlim_max =3D 128 << 20;
        setrlimit(RLIMIT_CORE, &rlim);
        rlim.rlim_cur =3D rlim.rlim_max =3D 256;
        setrlimit(RLIMIT_NOFILE, &rlim);
        if (unshare(CLONE_NEWNS)) {
        }
        if (mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, NULL)) {
        }
        if (unshare(CLONE_NEWIPC)) {
        }
        if (unshare(0x02000000)) {
        }
        if (unshare(CLONE_NEWUTS)) {
        }
        if (unshare(CLONE_SYSVSEM)) {
        }
        typedef struct {
                const char* name;
                const char* value;
        } sysctl_t;
        static const sysctl_t sysctls[] =3D {
            {"/proc/sys/kernel/shmmax", "16777216"},
            {"/proc/sys/kernel/shmall", "536870912"},
            {"/proc/sys/kernel/shmmni", "1024"},
            {"/proc/sys/kernel/msgmax", "8192"},
            {"/proc/sys/kernel/msgmni", "1024"},
            {"/proc/sys/kernel/msgmnb", "1024"},
            {"/proc/sys/kernel/sem", "1024 1048576 500 1024"},
        };
        unsigned i;
        for (i =3D 0; i < sizeof(sysctls) / sizeof(sysctls[0]); i++)
                write_file(sysctls[i].name, sysctls[i].value);
}

static int wait_for_loop(int pid)
{
        if (pid < 0)
        exit(1);
        int status =3D 0;
        while (waitpid(-1, &status, __WALL) !=3D pid) {
        }
        return WEXITSTATUS(status);
}

static void drop_caps(void)
{
        struct __user_cap_header_struct cap_hdr =3D {};
        struct __user_cap_data_struct cap_data[2] =3D {};
        cap_hdr.version =3D _LINUX_CAPABILITY_VERSION_3;
        cap_hdr.pid =3D getpid();
        if (syscall(SYS_capget, &cap_hdr, &cap_data))
        exit(1);
        const int drop =3D (1 << CAP_SYS_PTRACE) | (1 << CAP_SYS_NICE);
        cap_data[0].effective &=3D ~drop;
        cap_data[0].permitted &=3D ~drop;
        cap_data[0].inheritable &=3D ~drop;
        if (syscall(SYS_capset, &cap_hdr, &cap_data))
        exit(1);
}

static int do_sandbox_none(void)
{
        if (unshare(CLONE_NEWPID)) {
        }
        int pid =3D fork();
        if (pid !=3D 0)
                return wait_for_loop(pid);
        sandbox_common();
        drop_caps();
        if (unshare(CLONE_NEWNET)) {
        }
        write_file("/proc/sys/net/ipv4/ping_group_range", "0 65535");
        sandbox_common_mount_tmpfs();
        loop();
        exit(1);
}

static void kill_and_wait(int pid, int* status)
{
        kill(-pid, SIGKILL);
        kill(pid, SIGKILL);
        for (int i =3D 0; i < 100; i++) {
                if (waitpid(-1, status, WNOHANG | __WALL) =3D=3D pid)
                        return;
                usleep(1000);
        }
        DIR* dir =3D opendir("/sys/fs/fuse/connections");
        if (dir) {
                for (;;) {
                        struct dirent* ent =3D readdir(dir);
                        if (!ent)
                                break;
                        if (strcmp(ent->d_name, ".") =3D=3D 0 ||
strcmp(ent->d_name, "..") =3D=3D 0)
                                continue;
                        char abort[300];
                        snprintf(abort, sizeof(abort),
"/sys/fs/fuse/connections/%s/abort", ent->d_name);
                        int fd =3D open(abort, O_WRONLY);
                        if (fd =3D=3D -1) {
                                continue;
                        }
                        if (write(fd, abort, 1) < 0) {
                        }
                        close(fd);
                }
                closedir(dir);
        } else {
        }
        while (waitpid(-1, status, __WALL) !=3D pid) {
        }
}

static void setup_test()
{
        prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);
        setpgrp();
        write_file("/proc/self/oom_score_adj", "1000");
}

static void execute_one(void);

#define WAIT_FLAGS __WALL

static void loop(void)
{
        int iter =3D 0;
        for (;; iter++) {
                int pid =3D fork();
                if (pid < 0)
        exit(1);
                if (pid =3D=3D 0) {
                        setup_test();
                        execute_one();
                        exit(0);
                }
                int status =3D 0;
                uint64_t start =3D current_time_ms();
                for (;;) {
                        sleep_ms(10);
                        if (waitpid(-1, &status, WNOHANG | WAIT_FLAGS) =3D=
=3D pid)
                                break;
                        if (current_time_ms() - start < 5000)
                                continue;
                        kill_and_wait(pid, &status);
                        break;
                }
        }
}

uint64_t r[1] =3D {0xffffffffffffffff};

void execute_one(void)
{
        intptr_t res =3D 0;
        if (write(1, "executing program\n", sizeof("executing
program\n") - 1)) {}
        NONFAILING(memcpy((void*)0x20000000, "/dev/sg#\000", 9));
        res =3D -1;
        NONFAILING(res =3D syz_open_dev(/*dev=3D*/0x20000000, /*id=3D*/0,
/*flags=3D*/0));
        if (res !=3D -1)
                r[0] =3D res;
        NONFAILING(memcpy((void*)0x20000040,
"\x00\x00\x00\x00\x42\x0d\x00\x00\x85\x0a\xaa", 11));
        NONFAILING(sprintf((char*)0x2000004b, "0x%016llx", (long long)r[0])=
);
        syscall(__NR_ioctl, /*fd=3D*/r[0], /*cmd=3D*/1, /*arg=3D*/0x2000004=
0ul);

}
int main(void)
{
        syscall(__NR_mmap, /*addr=3D*/0x1ffff000ul, /*len=3D*/0x1000ul,
/*prot=3D*/0ul, /*flags=3DMAP_FIXED|MAP_ANONYMOUS|MAP_PRIVATE*/0x32ul,
/*fd=3D*/-1, /*offset=3D*/0ul);
        syscall(__NR_mmap, /*addr=3D*/0x20000000ul, /*len=3D*/0x1000000ul,
/*prot=3DPROT_WRITE|PROT_READ|PROT_EXEC*/7ul,
/*flags=3DMAP_FIXED|MAP_ANONYMOUS|MAP_PRIVATE*/0x32ul, /*fd=3D*/-1,
/*offset=3D*/0ul);
        syscall(__NR_mmap, /*addr=3D*/0x21000000ul, /*len=3D*/0x1000ul,
/*prot=3D*/0ul, /*flags=3DMAP_FIXED|MAP_ANONYMOUS|MAP_PRIVATE*/0x32ul,
/*fd=3D*/-1, /*offset=3D*/0ul);
        const char* reason;
        (void)reason;
        install_segv_handler();
        for (procid =3D 0; procid < 4; procid++) {
                if (fork() =3D=3D 0) {
                        do_sandbox_none();
                }
        }
        sleep(1000000);
        return 0;
}


- compiled test (please run inside VM)
https://drive.google.com/file/d/1Q9prtQKi5LVrOwrFJ162eXzTwTnDUq5X/view?usp=
=3Dsharing

- kernel config
https://drive.google.com/file/d/1LMJgfJPhTu78Cd2DfmDaRitF6cdxxcey/view?usp=
=3Dsharing

- compiled kernel
https://drive.google.com/file/d/1B22XKuDqrtk8gvWFFEMXR0o-VcVdYvB4/view?usp=
=3Dsharing
