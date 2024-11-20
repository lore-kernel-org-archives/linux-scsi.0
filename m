Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54ED424B28
	for <linux-scsi@vger.kernel.org>; Wed, 20 Nov 2024 16:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732119864; cv=none; b=B1ZdwvuQ3C+Mk4075Fm2+Y6Qc5qQQPmGcbCCXb+MwnUYKF2gW+TdC7/jfzcuvI78C8usIKvSgDb85vzuGoVlo1rK+cCVLzvPDwbVaSD+h+Ec+o6wj6j7EH/YE9w43sOMs9JSRRn9rB/RbzJYIJC64sZGIe7K2W7AH5z4myi44lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732119864; c=relaxed/simple;
	bh=hJG9PFeZPpHdmSeU/cJhhE0mk/7r6FZ/nKnfNY86uKM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lIVY4x05jY7fWkNhON9hUEfa3sIdODbMDZvdO/zQkSWwOX0T4kZoD9fR9VdrPLI/DrmJdqNgc5v7uC61AhRiCbZRvDj6rWD9Pn4ts++0hPWnQP9UDWg8iUeEMqHvaXbK6f6JAjLTaz/WcGk/zPZyT2VfW4AArrjLaiKuvGZZzec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KDVOXvY1; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KDVOXvY1"
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3a7222089aaso2841575ab.1
        for <linux-scsi@vger.kernel.org>; Wed, 20 Nov 2024 08:24:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732119860; x=1732724660; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fqYHi/Kmp2kuNbO2+GynW0y7eCWIPKDZEIHabltz0vs=;
        b=KDVOXvY1drW+H4ZvL5h85+4RzXFSBaJ2xqT4h8No7aLfU0o1lo5gi/cL5tiWVS7mRK
         OeXJVCp3Usb+WJPsBjAKFpsl/IslyLPiJkgvLSxjn3c1NrjxWJHZx2kMzAsogL/rOukS
         8bb3u9Le6oY3JhrTD3BSSaWSBresI8rEEhH3eslD50GN0URoRCGCxZhEps5iAdNqQAym
         +CQ5QransJZa39/B0+b38X9REUoQ6PT/gUjAbeaKAHSf/2WDR2aGmw/M4M7CAYafc+DK
         DEjrTmyMg//pdU/O1BBUh98L5ShuxSbyxxHFyzscPbSMkjUJfYT3YaWyRU8wK/pyeJD+
         y9lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732119860; x=1732724660;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fqYHi/Kmp2kuNbO2+GynW0y7eCWIPKDZEIHabltz0vs=;
        b=Upb3xxCmKFuMrAGemN6qxQEKZsGzib8/qY/l4BoqrC2qxc5B4KHqEM1FkQ5xgbcxIv
         I42WYVRtrym88dHBHwQtGEmYrD1opMx/A+oqw0M7WHrWrEPyVTSVrz+wQrDWKL+o1r9v
         tSvEOpXtsA3ZlQH3zwwZp57xAX2WOvVWfGd6e3sdx/6ikwgrwEuLPHhgm0/Zfl8vrQJG
         YeY1XW5cfKCnZWxPk5ahKVGvufk9Fu5QddYJGR1HNPLbr1RVzDz/MDbL3VyI50VdC3KJ
         19P22xVufEhppjM3nHhCYQgTcccjr+vuGPrXDSByprChBLWGmr6qautVKd0Uu8tS1px6
         Pr3Q==
X-Forwarded-Encrypted: i=1; AJvYcCU+hzsg6+wvgQnv0ymc9FeamcHmwBbKILlAgwH2eshvVwl1aO4q7pLucAG42VDeZMEQThNYa01X3iEL@vger.kernel.org
X-Gm-Message-State: AOJu0YwVgwkF81dCtpLhg8QHQdSweqPVtXYz5ybaunBFtJYQUNIvF8dh
	/Y/H2S5yS+060LHyY6QlTjGGDQ+cbilzF9iCPHwL7EFWLcmdriDzi4d/rVvesOVtCNuPopEbPUs
	jjVhQNUCLpnpaViQRmK+pU74ddFc=
X-Google-Smtp-Source: AGHT+IFjkQAUov+vo0/crfHNZjLrt8KdrHoMYg1v2DJ5JPHYndORJiQGX/4ZcNmjaoVHlxUlmNiYbQaS8N41bSGNQDo=
X-Received: by 2002:a92:dcc7:0:b0:3a7:5ced:af04 with SMTP id
 e9e14a558f8ab-3a777377852mr61692725ab.3.1732119860178; Wed, 20 Nov 2024
 08:24:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+-ZZ_gPfU19PdfdiK7NDJpi42bF4wviUR4+8_1vbqd=FZS3yg@mail.gmail.com>
 <154e9249-dc88-46a3-a3c3-73a2eb1bcaec@suse.cz> <CA+-ZZ_geB=qr=w14VWtoJLRDnZGYyQ--bU9jt966LvBSVfRLaA@mail.gmail.com>
 <ff2eea04-aa0f-411a-bb0c-6e4c07d92ef3@lucifer.local>
In-Reply-To: <ff2eea04-aa0f-411a-bb0c-6e4c07d92ef3@lucifer.local>
From: reveliofuzzing <reveliofuzzing@gmail.com>
Date: Wed, 20 Nov 2024 11:24:09 -0500
Message-ID: <CA+-ZZ_hM=OM2gWOX7Ti7rzSKFwvLSGY+7Zk7G75EpnasctJXGw@mail.gmail.com>
Subject: Re: Report "general protection fault in unmap_vmas"
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org, 
	Liam Howlett <liam.howlett@oracle.com>, Jann Horn <jannh@google.com>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 20, 2024 at 5:42=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Tue, Nov 19, 2024 at 04:22:17PM -0500, reveliofuzzing wrote:
> > On Tue, Nov 19, 2024 at 4:03=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz=
> wrote:
> > >
> > > On 11/19/24 16:38, reveliofuzzing wrote:
> > > > Hello,
> > > >
> > > > We found a kernel crash at `unmap_vmas` when running a test generat=
ed
> > > > by Syzkaller on Linux kernel 6.10, both of which are unmodified. We=
 would like
> > >
> > > Hello, 6.10 is EOL at this point. Does this also happen on 6.12, or 6=
.11.9?
> > > Thanks, Vlastimil
> >
> > Yes, we just tested 6.12 using a configuration similar to 6.10 (make
> > olddefconfig)
> > and found that the test can still crash the kernel.
>
> I've tried the exact same config locally and cannot reproduce this, leavi=
ng
> the repro running for a long period of time.
>
> Also I am unable to resolve your symbols via addr2line to find the line o=
f
> code that fails.
>
Here are more details about our setup.

- QEMU command
qemu-system-x86_64 -m 2G -smp 2 -kernel /linux-6.12/bzImage \
    -append "console=3DttyS0 root=3D/dev/sda earlyprintk=3Dserial net.ifnam=
es=3D0" \
    -drive file=3D./bullseye.img,format=3Draw \
    -net user,host=3D10.0.2.10,hostfwd=3Dtcp:127.0.0.1:10021-:22 \
    -net nic,model=3De1000 \
    -enable-kvm \
    -nographic \
    -pidfile vm.pid \
    2>&1 | tee vm.log

- VM image
It is created using Syzkaller's script:
https://github.com/google/syzkaller/blob/master/tools/create-image.sh

- bzImage
        - GCC: Ubuntu 9.4.0-1ubuntu1~20.04.2
        - config:
https://drive.google.com/file/d/1ZfeXgVadChVJtIGx5zMhBqHnmlomP3Hf/view?usp=
=3Dsharing
        - bzimage download:
https://drive.google.com/file/d/1MJf0WQ9_eztvuBcaBwCGC-rb7VBQtuac/view?usp=
=3Dsharing

- QEMU
Version is QEMU emulator version 4.2.1 (Debian 1:4.2-3ubuntu6.30)

> >
> > However, we observed that the crash site was different, which is probab=
ly due to
> > concurrency.
> >
>
> Well no :) this points to this not being an mm problem afaict. If it were=
,
> you'd expect to see it occur on an mm path each time.
>
> There seems to be something really wrong here. It looks like the writebac=
k
> worker thread is hitting a null pointer deref, which doesn't really align
> with it being related to unmapping VMAs.
>
> It also suggests that blk_mq_submit_bio() is the originating cause of the
> null pointer deref, which really points away from VMA logic and points
> towards something else, perhaps a block device driver issue.
>
> I also see:
>
> [   91.600650] ata1: lost interrupt (Status 0x58)
> [   92.821151] ata1: found unknown device (class 0)
>
> Reports which kinda points in that direction...
>
> Also we see a warning being hit in do_exit(), which is WARN_ON(task->plug=
)
> which suggests there's something wrong with your block device somehow or =
at
> least within the block layer of the kernel.
>
> So this could be something wrong with your qemu setup and how the block
> device is configured, or a bug in the block device subsystem.
>
>
> So:
>
> I suggest your best bet, if you can reliably reproduce this, is to bisect
> this to a _specific commit_ and identify what causes this.
>
> It's also important to track down the precise line of code that triggers
> the bugs, you can do this with:
>
> addr2line -e vmlinux wb_writeback+0x4ee/0x750
>
> (Obviously replacing that second bit with whatever line you want to locat=
e)
>
> Then I'd contact the block device subsystem rather than mm as I can't see
> anything that specifically identifies mm as the cause (unless, of course,
> through bisection you find an mm commit).
Thanks for your analysis and suggestions. We will try to do more investigat=
ion.

>
>
> > - Crash log
> > syzkaller login: [   28.607581] program syz-executor is using a
> > deprecated SCSI ioctl, please convert it to SG_IO
> > [   91.600650] ata1: lost interrupt (Status 0x58)
> > [   92.821151] ata1: found unknown device (class 0)
> > [   92.826370] Oops: general protection fault, probably for
> > non-canonical address 0xdffffc0000000005: 0000 [#1] PREEMPT SMP KASAN
> > PTI
> > [   92.826775] program syz-executor is using a deprecated SCSI ioctl,
> > please convert it to SG_IO
> > [   92.830145] KASAN: null-ptr-deref in range
> > [0x0000000000000028-0x000000000000002f]
> > [   92.830162] CPU: 0 UID: 0 PID: 59 Comm: kworker/u10:1 Not tainted 6.=
12.0 #1
> > [   92.830172] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> > BIOS 1.13.0-1ubuntu1.1 04/01/2014
> > [   92.830178] Workqueue: writeback wb_workfn (flush-8:0)
> > [   92.841699] RIP: 0010:update_io_ticks+0xb3/0x220
> > [   92.843251] Code: 10 48 8d 7b 40 48 89 f8 48 c1 e8 03 80 3c 28 00
> > 0f 85 5e 01 00 00 48 8b 5b 40 e8 08 46 63 ff 4c 8d 63 28 4c 89 e0 48
> > c18
> > [   92.849232] RSP: 0018:ffff88800a1f70a0 EFLAGS: 00010206
> > [   92.850936] RAX: 0000000000000005 RBX: 0000000000000000 RCX: ffff888=
00764229c
> > [   92.853294] RDX: ffff88800893e900 RSI: ffffffff81e1cb18 RDI: 0000000=
000000000
> > [   92.855620] RBP: dffffc0000000000 R08: ffffed100143edaf R09: ffffed1=
0010e7445
> > [   92.857933] R10: ffffed10010e7444 R11: ffff88800873a227 R12: 0000000=
000000028
> > [   92.860269] R13: 00000000fffcd4d5 R14: 1ffff1100143ee15 R15: 0000000=
000000000
> > [   92.862606] FS:  0000000000000000(0000) GS:ffff88806d200000(0000)
> > knlGS:0000000000000000
> > [   92.865255] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [   92.867144] CR2: 00007fff67e96170 CR3: 000000000cd64000 CR4: 0000000=
0000006f0
> > [   92.869490] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
> > [   92.871808] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000=
000000400
> > [   92.874106] Call Trace:
> > [   92.874945]  <TASK>
> > [   92.875698]  ? __die_body+0x1a/0x60
> > [   92.876885]  ? die_addr+0x42/0x70
> > [   92.878018]  ? exc_general_protection+0x15c/0x2a0
> > [   92.879601]  ? asm_exc_general_protection+0x26/0x30
> > [   92.881198]  ? update_io_ticks+0xa8/0x220
> > [   92.882532]  ? update_io_ticks+0xb3/0x220
> > [   92.883878]  ? __pfx_update_io_ticks+0x10/0x10
> > [   92.885352]  ? __pfx_dd_bio_merge+0x10/0x10
> > [   92.886729]  ? blk_mq_sched_bio_merge+0x255/0x340
> > [   92.888317]  blk_mq_submit_bio+0xb84/0x1d00
> > [   92.889711]  ? __pfx_blk_mq_submit_bio+0x10/0x10
> > [   92.891249]  ? kasan_save_track+0x14/0x30
> > [   92.892625]  ? __kasan_slab_alloc+0x59/0x70
> > [   92.894016]  __submit_bio+0x167/0x7d0
> > [   92.895257]  ? __pfx___submit_bio+0x10/0x10
> > [   92.896678]  ? bio_associate_blkg_from_css+0x366/0xb70
> > [   92.898377]  ? _raw_spin_lock_irqsave+0x86/0xe0
> > [   92.899913]  ? kvm_clock_read+0x2c/0x50
> > [   92.901195]  ? ktime_get+0xe2/0x170
> > [   92.902393]  submit_bio_noacct_nocheck+0x5c7/0xc90
> > [   92.904005]  ? __pfx_submit_bio_noacct_nocheck+0x10/0x10
> > [   92.905753]  ? guard_bio_eod+0x97/0x660
> > [   92.907032]  ? __pfx_bio_alloc_bioset+0x10/0x10
> > [   92.908547]  ? __pfx___folio_start_writeback+0x10/0x10
> > [   92.910237]  submit_bio_noacct+0x31d/0x1080
> > [   92.911632]  __block_write_full_folio+0x5c2/0xb80
> > [   92.913205]  ? inode_to_bdi+0x9c/0x140
> > [   92.914461]  ? __pfx_blkdev_get_block+0x10/0x10
> > [   92.915982]  block_write_full_folio+0x41a/0x580
> > [   92.917487]  ? __pfx_blkdev_get_block+0x10/0x10
> > [   92.918992]  ? __pfx_block_write_full_folio+0x10/0x10
> > [   92.920668]  write_cache_pages+0x9f/0x110
> > [   92.922021]  ? __pfx_write_cache_pages+0x10/0x10
> > [   92.923569]  ? arch_stack_walk+0x87/0xf0
> > [   92.924870]  ? __pfx_blkdev_writepages+0x10/0x10
> > [   92.926400]  blkdev_writepages+0x92/0xe0
> > [   92.927724]  ? __pfx_blkdev_writepages+0x10/0x10
> > [   92.929261]  ? _raw_spin_lock+0x80/0xe0
> > [   92.930537]  ? __pfx__raw_spin_lock+0x10/0x10
> > [   92.931998]  ? deref_stack_reg+0x37/0x80
> > [   92.933291]  ? I_BDEV+0xd/0x20
> > [   92.934328]  ? inode_to_bdi+0x9c/0x140
> > [   92.935632]  do_writepages+0x174/0x740
> > [   92.936903]  ? __pfx_do_writepages+0x10/0x10
> > [   92.938325]  ? worker_thread+0x434/0xa10
> > [   92.939625]  ? __pfx_unwind_next_frame+0x10/0x10
> > [   92.941148]  ? __unwind_start+0x520/0x7d0
> > [   92.942488]  __writeback_single_inode+0xb4/0x910
> > [   92.944020]  writeback_sb_inodes+0x561/0xc50
> > [   92.945444]  ? stack_depot_save_flags+0x2c/0x6f0
> > [   92.946961]  ? __pfx_writeback_sb_inodes+0x10/0x10
> > [   92.948548]  ? __pfx_widen_string+0x10/0x10
> > [   92.949937]  ? __pfx_down_read_trylock+0x10/0x10
> > [   92.951476]  ? __pfx_move_expired_inodes+0x10/0x10
> > [   92.953043]  __writeback_inodes_wb+0xbc/0x230
> > [   92.954497]  wb_writeback+0x4ee/0x750
> > [   92.955726]  ? __pfx_wb_writeback+0x10/0x10
> > [   92.957095]  ? get_nr_dirty_inodes+0xf7/0x180
> > [   92.958556]  wb_workfn+0x62c/0x990
> > [   92.959707]  ? __switch_to+0x6a6/0xf00
> > [   92.960957]  ? __pfx_wb_workfn+0x10/0x10
> > [   92.962271]  ? read_word_at_a_time+0xe/0x20
> > [   92.963653]  ? sized_strscpy+0x9c/0x2b0
> > [   92.964927]  ? kick_pool+0x1b4/0x5a0
> > [   92.966119]  process_scheduled_works+0x921/0x10d0
> > [   92.967673]  worker_thread+0x434/0xa10
> > [   92.968985]  ? __kthread_parkme+0xe3/0x160
> > [   92.970339]  ? __pfx_worker_thread+0x10/0x10
> > [   92.971778]  kthread+0x2c7/0x3c0
> > [   92.972876]  ? __pfx_kthread+0x10/0x10
> > [   92.974129]  ret_from_fork+0x48/0x80
> > [   92.975355]  ? __pfx_kthread+0x10/0x10
> > [   92.976649]  ret_from_fork_asm+0x1a/0x30
> > [   92.977948]  </TASK>
> > [   92.978711] Modules linked in:
> > [   92.979864] ---[ end trace 0000000000000000 ]---
> > [   92.981437] RIP: 0010:update_io_ticks+0xb3/0x220
> > [   92.983600] Code: 10 48 8d 7b 40 48 89 f8 48 c1 e8 03 80 3c 28 00
> > 0f 85 5e 01 00 00 48 8b 5b 40 e8 08 46 63 ff 4c 8d 63 28 4c 89 e0 48
> > c18
> > [   92.989618] RSP: 0018:ffff88800a1f70a0 EFLAGS: 00010206
> > [   92.991438] RAX: 0000000000000005 RBX: 0000000000000000 RCX: ffff888=
00764229c
> > [   92.993854] RDX: ffff88800893e900 RSI: ffffffff81e1cb18 RDI: 0000000=
000000000
> > [   92.996272] RBP: dffffc0000000000 R08: ffffed100143edaf R09: ffffed1=
0010e7445
> > [   92.998680] R10: ffffed10010e7444 R11: ffff88800873a227 R12: 0000000=
000000028
> > [   93.001092] R13: 00000000fffcd4d5 R14: 1ffff1100143ee15 R15: 0000000=
000000000
> > [   93.003536] FS:  0000000000000000(0000) GS:ffff88806d200000(0000)
> > knlGS:0000000000000000
> > [   93.006255] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [   93.008279] CR2: 00007fff67e96170 CR3: 000000000cd64000 CR4: 0000000=
0000006f0
> > [   93.010714] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
> > [   93.013141] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000=
000000400
> > [   93.015566] note: kworker/u10:1[59] exited with preempt_count 1
> > [   93.017658] ------------[ cut here ]------------
> > [   93.019280] WARNING: CPU: 0 PID: 59 at kernel/exit.c:886
>
> This is
>
>         WARN_ON(tsk->plug);
>
> In do_exit().
>
> Which again, clearly points towards the block layer.
>
> > do_exit+0x1b60/0x2930
> > [   93.021491] Modules linked in:
> > [   93.022688] CPU: 0 UID: 0 PID: 59 Comm: kworker/u10:1 Tainted: G
> >   D            6.12.0 #1
> > [   93.025153] Tainted: [D]=3DDIE
> > [   93.026080] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> > BIOS 1.13.0-1ubuntu1.1 04/01/2014
> > [   93.028629] Workqueue: writeback wb_workfn (flush-8:0)
> > [   93.030119] RIP: 0010:do_exit+0x1b60/0x2930
> > [   93.031473] Code: 0f 85 61 0b 00 00 48 8b bb 88 05 00 00 31 f6 e8
> > 76 9e ff ff e9 8f f5 ff ff e8 cc eb 2d 00 0f 0b e9 26 e5 ff ff e8 c0
> > eb7
> > [   93.036919] RSP: 0018:ffff88800a1f7e40 EFLAGS: 00010293
> > [   93.038306] RAX: 0000000000000000 RBX: ffff88800893e900 RCX: fffffff=
f83ee3d21
> > [   93.040303] RDX: ffff88800893e900 RSI: ffffffff81172560 RDI: ffff888=
00893f170
> > [   93.042489] RBP: ffff88800893f088 R08: ffffed100143efbd R09: ffffed1=
00143efbe
> > [   93.044513] R10: ffffed100143efbd R11: 0000000000000003 R12: 0000000=
00000000b
> > [   93.046629] R13: ffff888007f9f1c0 R14: ffff8880089f8e40 R15: 0000000=
000000000
> > [   93.048917] FS:  0000000000000000(0000) GS:ffff88806d200000(0000)
> > knlGS:0000000000000000
> > [   93.051232] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [   93.053190] CR2: 00007fff67e96170 CR3: 000000000cd64000 CR4: 0000000=
0000006f0
> > [   93.055520] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
> > [   93.057847] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000=
000000400
> > [   93.060198] Call Trace:
> > [   93.061105]  <TASK>
> > [   93.061908]  ? __warn+0xea/0x2b0
> > [   93.063023]  ? do_exit+0x1b60/0x2930
> > [   93.064274]  ? report_bug+0x2cb/0x430
> > [   93.065554]  ? do_exit+0x1b60/0x2930
> > [   93.066797]  ? do_exit+0x1b61/0x2930
> > [   93.068110]  ? handle_bug+0x9a/0x110
> > [   93.069279]  ? exc_invalid_op+0x25/0x70
> > [   93.070548]  ? asm_exc_invalid_op+0x1a/0x20
> > [   93.071977]  ? _raw_spin_lock_irq+0x81/0xe0
> > [   93.073408]  ? do_exit+0x1b60/0x2930
> > [   93.074468]  ? do_exit+0x1b60/0x2930
> > [   93.075520]  ? _printk+0xbf/0x100
> > [   93.076463]  ? __pfx__printk+0x10/0x10
> > [   93.077662]  ? __pfx_do_exit+0x10/0x10
> > [   93.078957]  ? __pfx_worker_thread+0x10/0x10
> > [   93.080482]  make_task_dead+0x11a/0x340
> > [   93.081608]  ? __pfx_kthread+0x10/0x10
> > [   93.082749]  rewind_stack_and_make_dead+0x16/0x20
>
> Err this suggests you had an oops before and then this got invoked which
> then died on the nested oops... is there part of the dmesg missing?
>
> > [   93.084324] RIP: 0000:0x0
> > [   93.085272] Code: Unable to access opcode bytes at 0xffffffffffffffd=
6.
> > [   93.087412] RSP: 0000:0000000000000000 EFLAGS: 00000000 ORIG_RAX:
> > 0000000000000000
> > [   93.089470] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000=
000000000
> > [   93.091639] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000=
000000000
> > [   93.093509] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000=
000000000
> > [   93.095770] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000=
000000000
> > [   93.098087] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000=
000000000
> > [   93.100353]  </TASK>
> > [   93.101098] ---[ end trace 0000000000000000 ]---
> >
> >
> > >
> > > > to report it for your reference because this crash has not been obs=
erved before.
> > > >
> > > > In a 2-core qemu-kvm VM, this crash took about 1 minute to happen.
> > > >
> > > > This report comes with:
> > > > - the console log of the guest VM
> > > > - the test (syzlang syntax)
> > > > - the test (c program) (url)
> > > > - the compiled test (url)
> > > > - kernel configuration (url)
> > > > - the compiled kernel (url)
> > > >
> > > >
> > > > - Crash
> > > > syzkaller login: [   22.005245] program syz-executor is using a
> > > > deprecated SCSI ioctl, please convert it to SG_IO
> > > > [   83.496476] ata1: lost interrupt (Status 0x58)
> > > > [   84.532478] clocksource: Long readout interval, skipping watchdo=
g
> > > > check: cs_nsec: 1455987654 wd_nsec: 1455987593
> > > > [   84.693047] ata1: found unknown device (class 0)
> > > > [   84.696781] Oops: general protection fault, probably for
> > > > non-canonical address 0xdffffc0000000090: 0000 [#1] PREEMPT SMP KAS=
AN
> > > > PTI
> > > > [   84.699625] KASAN: null-ptr-deref in range
> > > > [0x0000000000000480-0x0000000000000487]
>
> Looking backwards at 6.10 report:
>
> A rough fuzzy look at the stack suggests this is an offset into a struct
> mm_struct and this offset points to mm_struct->exe_file.
>
> Which again points away from mm.
>
> > > > [   84.701454] CPU: 1 PID: 232 Comm: syz-executor Not tainted 6.10.=
0 #2
> > > > [   84.702995] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996=
),
> > > > BIOS 1.13.0-1ubuntu1.1 04/01/2014
> > > > [   84.705181] RIP: 0010:unmap_vmas+0x13e/0x3c0
> > > > [   84.706950] Code: 00 00 00 00 00 e8 22 ac 7f 02 48 8b 84 24 c8 0=
0
> > > > 00 00 48 ba 00 00 00 00 00 fc ff df 48 8d b8 80 04 00 00 48 89 f9 4=
8
> > > > c11
> > > > [   84.711418] RSP: 0018:ffff88800c3e78a0 EFLAGS: 00010206
> > > > [   84.712703] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000=
0000000000090
> > > > [   84.714430] RDX: dffffc0000000000 RSI: ffffffff81635b11 RDI: 000=
0000000000480
> > > > [   84.716152] RBP: ffff88800c681ee0 R08: ffffffffffffffff R09: fff=
fffffffffffff
> > > > [   84.717909] R10: ffffed1000f67931 R11: ffff888007b3c98b R12: fff=
fffffffffffff
> > > > [   84.719640] R13: dffffc0000000000 R14: ffffffffffffffff R15: 000=
0000000000000
> > > > [   84.721375] FS:  0000000000000000(0000) GS:ffff88806d300000(0000=
)
> > > > knlGS:0000000000000000
> > > > [   84.723361] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > [   84.724791] CR2: 000055cdc0a948a8 CR3: 0000000004e66000 CR4: 000=
00000000006f0
> > > > [   84.726545] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000=
0000000000000
> > > > [   84.728278] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000=
0000000000400
> > > > [   84.730029] Call Trace:
> > > > [   84.730672]  <TASK>
> > > > [   84.731232]  ? show_regs+0x73/0x80
> > > > [   84.732100]  ? __die_body+0x1f/0x70
> > > > [   84.732985]  ? die_addr+0x4c/0x90
> > > > [   84.733833]  ? exc_general_protection+0x15c/0x2a0
> > > > [   84.735024]  ? asm_exc_general_protection+0x26/0x30
> > > > [   84.736434]  ? unmap_vmas+0xb1/0x3c0
> > > > [   84.737364]  ? unmap_vmas+0x13e/0x3c0
> > > > [   84.738320]  ? __pfx_unmap_vmas+0x10/0x10
> > > > [   84.739340]  ? free_ldt_pgtables+0x94/0x180
> > > > [   84.740388]  ? mas_walk+0x986/0xd10
> > > > [   84.741285]  ? mas_next_slot+0xed8/0x1be0
> > > > [   84.742300]  ? stack_depot_save_flags+0x5ef/0x6f0
> > > > [   84.743482]  exit_mmap+0x171/0x810
> > > > [   84.744358]  ? __pfx_exit_mmap+0x10/0x10
> > > > [   84.745354]  ? exit_aio+0x260/0x340
> > > > [   84.746257]  ? mutex_unlock+0x7e/0xd0
> > > > [   84.747185]  ? __pfx_mutex_unlock+0x10/0x10
> > > > [   84.748222]  ? delayed_uprobe_remove+0x21/0x130
> > > > [   84.749356]  mmput+0x64/0x290
> > > > [   84.750179]  do_exit+0x7fd/0x2850
> > > > [   84.751060]  ? blk_mq_run_hw_queue+0x321/0x520
> > > > [   84.752176]  ? kasan_save_track+0x14/0x30
> > > > [   84.753194]  ? __pfx_do_exit+0x10/0x10
> > > > [   84.754159]  ? scsi_ioctl+0xa16/0x12c0
>
> This is suspect...
>
> > > > [   84.755107]  ? _raw_spin_lock_irq+0x81/0xe0
> > > > [   84.756161]  do_group_exit+0xb6/0x260
> > > > [   84.757107]  get_signal+0x19e3/0x1b00
> > > > [   84.758041]  ? __handle_mm_fault+0x644/0x21c0
> > > > [   84.759129]  ? __pfx_get_signal+0x10/0x10
> > > > [   84.760135]  arch_do_signal_or_restart+0x81/0x750
> > > > [   84.761304]  ? __pfx_arch_do_signal_or_restart+0x10/0x10
> > > > [   84.762621]  ? handle_mm_fault+0xe6/0x520
> > > > [   84.763624]  ? __fget_light+0x175/0x510
> > > > [   84.764586]  ? do_user_addr_fault+0x7de/0x1250
> > > > [   84.765699]  syscall_exit_to_user_mode+0xf6/0x140
> > > > [   84.766879]  do_syscall_64+0x57/0x110
> > > > [   84.767810]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > > > [   84.769062] RIP: 0033:0x7f15ec6a6aad
> > > > [   84.769968] Code: Unable to access opcode bytes at 0x7f15ec6a6a8=
3.
> > > > [   84.771469] RSP: 002b:00007ffe4c340428 EFLAGS: 00000246 ORIG_RAX=
:
> > > > 0000000000000010
> > > > [   84.773299] RAX: 0000000000000002 RBX: 00007ffe4c340450 RCX: 000=
07f15ec6a6aad
> > > > [   84.775039] RDX: 0000000020000040 RSI: 0000000000000001 RDI: 000=
0000000000003
> > > > [   84.776795] RBP: 0000000000000000 R08: 0000000000000012 R09: 000=
0000000000000
> > > > [   84.778532] R10: 00007f15ec6f403c R11: 0000000000000246 R12: 000=
07ffe4c340460
> > > > [   84.780263] R13: 00007f15ec71edf0 R14: 0000000000000000 R15: 000=
0000000000000
> > > > [   84.782008]  </TASK>
> > > > [   84.782586] Modules linked in:
> > > > [   84.783488] ---[ end trace 0000000000000000 ]---
> > > > [   84.784787] RIP: 0010:unmap_vmas+0x13e/0x3c0
> > > > [   84.785965] Code: 00 00 00 00 00 e8 22 ac 7f 02 48 8b 84 24 c8 0=
0
> > > > 00 00 48 ba 00 00 00 00 00 fc ff df 48 8d b8 80 04 00 00 48 89 f9 4=
8
> > > > c11
> > > > [   84.790487] RSP: 0018:ffff88800c3e78a0 EFLAGS: 00010206
> > > > [   84.791870] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000=
0000000000090
> > > > [   84.793702] RDX: dffffc0000000000 RSI: ffffffff81635b11 RDI: 000=
0000000000480
> > > > [   84.795546] RBP: ffff88800c681ee0 R08: ffffffffffffffff R09: fff=
fffffffffffff
> > > > [   84.797424] R10: ffffed1000f67931 R11: ffff888007b3c98b R12: fff=
fffffffffffff
> > > > [   84.799258] R13: dffffc0000000000 R14: ffffffffffffffff R15: 000=
0000000000000
> > > > [   84.801081] FS:  0000000000000000(0000) GS:ffff88806d300000(0000=
)
> > > > knlGS:0000000000000000
> > > > [   84.803135] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > [   84.804655] CR2: 000055cdc0a948a8 CR3: 0000000004e66000 CR4: 000=
00000000006f0
> > > > [   84.806521] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000=
0000000000000
> > > > [   84.808419] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000=
0000000000400
> > > > [   84.810281] Fixing recursive fault but reboot is needed!
> > > > [   84.811680] BUG: scheduling while atomic: syz-executor/232/0x000=
00000
> > > > [   84.813351] Modules linked in:
> > > > [   84.814245] CPU: 1 PID: 232 Comm: syz-executor Tainted: G      D
> > > >         6.10.0 #2
> > > > [   84.816151] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996=
),
> > > > BIOS 1.13.0-1ubuntu1.1 04/01/2014
> > > > [   84.818353] Call Trace:
> > > > [   84.818988]  <TASK>
> > > > [   84.819548]  dump_stack_lvl+0x7d/0xa0
> > > > [   84.820470]  __schedule_bug+0xaa/0xf0
> > > > [   84.821414]  ? irq_work_queue+0x23/0x60
> > > > [   84.822404]  __schedule+0x17ce/0x2010
> > > > [   84.823336]  ? __wake_up_klogd.part.0+0x69/0x80
> > > > [   84.824469]  ? vprintk_emit+0x239/0x300
> > > > [   84.825431]  ? __pfx___schedule+0x10/0x10
> > > > [   84.826451]  ? vprintk+0x6b/0x80
> > > > [   84.827276]  ? _printk+0xbf/0x100
> > > > [   84.828123]  ? __pfx__printk+0x10/0x10
> > > > [   84.829065]  ? _raw_spin_lock_irqsave+0x86/0xe0
> > > > [   84.830214]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
> > > > [   84.831460]  do_task_dead+0x9d/0xc0
> > > > [   84.832344]  make_task_dead+0x2f6/0x340
> > > > [   84.833319]  rewind_stack_and_make_dead+0x16/0x20
> > > > [   84.834504] RIP: 0033:0x7f15ec6a6aad
> > > > [   84.835404] Code: Unable to access opcode bytes at 0x7f15ec6a6a8=
3.
> > > > [   84.836920] RSP: 002b:00007ffe4c340428 EFLAGS: 00000246 ORIG_RAX=
:
> > > > 0000000000000010
> > > > [   84.838751] RAX: 0000000000000002 RBX: 00007ffe4c340450 RCX: 000=
07f15ec6a6aad
> > > > [   84.840474] RDX: 0000000020000040 RSI: 0000000000000001 RDI: 000=
0000000000003
> > > > [   84.842209] RBP: 0000000000000000 R08: 0000000000000012 R09: 000=
0000000000000
> > > > [   84.843932] R10: 00007f15ec6f403c R11: 0000000000000246 R12: 000=
07ffe4c340460
> > > > [   84.845654] R13: 00007f15ec71edf0 R14: 0000000000000000 R15: 000=
0000000000000
> > > > [   84.847402]  </TASK>
> > > >
> > > >
> > > > - syzlang test
> > > > r0 =3D syz_open_dev$sg(&(0x7f0000000000), 0x0, 0x0)
> > > > ioctl$SCSI_IOCTL_SEND_COMMAND(r0, 0x1,
> > > > &(0x7f0000000040)=3DANY=3D[@ANYBLOB=3D"00000000420d0000850aaa",
> > > > @ANYRESHEX=3Dr0])
> > > >
The reproducer implies that the crash might involve SCSI subsystem.

> > > >
> > > > - c test
> > > > // autogenerated by syzkaller (https://github.com/google/syzkaller)
> > > >
> > > > #define _GNU_SOURCE
> > > >
> > > > #include <dirent.h>
> > > > #include <endian.h>
> > > > #include <errno.h>
> > > > #include <fcntl.h>
> > > > #include <sched.h>
> > > > #include <setjmp.h>
> > > > #include <signal.h>
> > > > #include <stdarg.h>
> > > > #include <stdbool.h>
> > > > #include <stdint.h>
> > > > #include <stdio.h>
> > > > #include <stdlib.h>
> > > > #include <string.h>
> > > > #include <sys/mount.h>
> > > > #include <sys/prctl.h>
> > > > #include <sys/resource.h>
> > > > #include <sys/stat.h>
> > > > #include <sys/syscall.h>
> > > > #include <sys/time.h>
> > > > #include <sys/types.h>
> > > > #include <sys/wait.h>
> > > > #include <time.h>
> > > > #include <unistd.h>
> > > >
> > > > #include <linux/capability.h>
> > > >
> > > > static unsigned long long procid;
> > > >
> > > > static __thread int clone_ongoing;
> > > > static __thread int skip_segv;
> > > > static __thread jmp_buf segv_env;
> > > >
> > > > static void segv_handler(int sig, siginfo_t* info, void* ctx)
> > > > {
> > > >         if (__atomic_load_n(&clone_ongoing, __ATOMIC_RELAXED) !=3D =
0) {
> > > >                 exit(sig);
> > > >         }
> > > >         uintptr_t addr =3D (uintptr_t)info->si_addr;
> > > >         const uintptr_t prog_start =3D 1 << 20;
> > > >         const uintptr_t prog_end =3D 100 << 20;
> > > >         int skip =3D __atomic_load_n(&skip_segv, __ATOMIC_RELAXED) =
!=3D 0;
> > > >         int valid =3D addr < prog_start || addr > prog_end;
> > > >         if (skip && valid) {
> > > >                 _longjmp(segv_env, 1);
> > > >         }
> > > >         exit(sig);
> > > > }
> > > >
> > > > static void install_segv_handler(void)
> > > > {
> > > >         struct sigaction sa;
> > > >         memset(&sa, 0, sizeof(sa));
> > > >         sa.sa_handler =3D SIG_IGN;
> > > >         syscall(SYS_rt_sigaction, 0x20, &sa, NULL, 8);
> > > >         syscall(SYS_rt_sigaction, 0x21, &sa, NULL, 8);
> > > >         memset(&sa, 0, sizeof(sa));
> > > >         sa.sa_sigaction =3D segv_handler;
> > > >         sa.sa_flags =3D SA_NODEFER | SA_SIGINFO;
> > > >         sigaction(SIGSEGV, &sa, NULL);
> > > >         sigaction(SIGBUS, &sa, NULL);
> > > > }
> > > >
> > > > #define NONFAILING(...) ({ int ok =3D 1; __atomic_fetch_add(&skip_s=
egv,
> > > > 1, __ATOMIC_SEQ_CST); if (_setjmp(segv_env) =3D=3D 0) { __VA_ARGS__=
; }
> > > > else ok =3D 0; __atomic_fetch_sub(&skip_segv, 1, __ATOMIC_SEQ_CST);=
 ok;
> > > > })
> > > >
> > > > static void sleep_ms(uint64_t ms)
> > > > {
> > > >         usleep(ms * 1000);
> > > > }
> > > >
> > > > static uint64_t current_time_ms(void)
> > > > {
> > > >         struct timespec ts;
> > > >         if (clock_gettime(CLOCK_MONOTONIC, &ts))
> > > >         exit(1);
> > > >         return (uint64_t)ts.tv_sec * 1000 + (uint64_t)ts.tv_nsec / =
1000000;
> > > > }
> > > >
> > > > static bool write_file(const char* file, const char* what, ...)
> > > > {
> > > >         char buf[1024];
> > > >         va_list args;
> > > >         va_start(args, what);
> > > >         vsnprintf(buf, sizeof(buf), what, args);
> > > >         va_end(args);
> > > >         buf[sizeof(buf) - 1] =3D 0;
> > > >         int len =3D strlen(buf);
> > > >         int fd =3D open(file, O_WRONLY | O_CLOEXEC);
> > > >         if (fd =3D=3D -1)
> > > >                 return false;
> > > >         if (write(fd, buf, len) !=3D len) {
> > > >                 int err =3D errno;
> > > >                 close(fd);
> > > >                 errno =3D err;
> > > >                 return false;
> > > >         }
> > > >         close(fd);
> > > >         return true;
> > > > }
> > > >
> > > > static long syz_open_dev(volatile long a0, volatile long a1, volati=
le long a2)
> > > > {
> > > >         if (a0 =3D=3D 0xc || a0 =3D=3D 0xb) {
> > > >                 char buf[128];
> > > >                 sprintf(buf, "/dev/%s/%d:%d", a0 =3D=3D 0xc ? "char=
" :
> > > > "block", (uint8_t)a1, (uint8_t)a2);
> > > >                 return open(buf, O_RDWR, 0);
> > > >         } else {
> > > >                 char buf[1024];
> > > >                 char* hash;
> > > >                 strncpy(buf, (char*)a0, sizeof(buf) - 1);
> > > >                 buf[sizeof(buf) - 1] =3D 0;
> > > >                 while ((hash =3D strchr(buf, '#'))) {
> > > >                         *hash =3D '0' + (char)(a1 % 10);
> > > >                         a1 /=3D 10;
> > > >                 }
> > > >                 return open(buf, a2, 0);
> > > >         }
> > > > }
> > > >
> > > > static void setup_binderfs();
> > > > static void setup_fusectl();
> > > > static void sandbox_common_mount_tmpfs(void)
> > > > {
> > > >         write_file("/proc/sys/fs/mount-max", "100000");
> > > >         if (mkdir("./syz-tmp", 0777))
> > > >         exit(1);
> > > >         if (mount("", "./syz-tmp", "tmpfs", 0, NULL))
> > > >         exit(1);
> > > >         if (mkdir("./syz-tmp/newroot", 0777))
> > > >         exit(1);
> > > >         if (mkdir("./syz-tmp/newroot/dev", 0700))
> > > >         exit(1);
> > > >         unsigned bind_mount_flags =3D MS_BIND | MS_REC | MS_PRIVATE=
;
> > > >         if (mount("/dev", "./syz-tmp/newroot/dev", NULL,
> > > > bind_mount_flags, NULL))
> > > >         exit(1);
> > > >         if (mkdir("./syz-tmp/newroot/proc", 0700))
> > > >         exit(1);
> > > >         if (mount("syz-proc", "./syz-tmp/newroot/proc", "proc", 0, =
NULL))
> > > >         exit(1);
> > > >         if (mkdir("./syz-tmp/newroot/selinux", 0700))
> > > >         exit(1);
> > > >         const char* selinux_path =3D "./syz-tmp/newroot/selinux";
> > > >         if (mount("/selinux", selinux_path, NULL, bind_mount_flags,=
 NULL)) {
> > > >                 if (errno !=3D ENOENT)
> > > >         exit(1);
> > > >                 if (mount("/sys/fs/selinux", selinux_path, NULL,
> > > > bind_mount_flags, NULL) && errno !=3D ENOENT)
> > > >         exit(1);
> > > >         }
> > > >         if (mkdir("./syz-tmp/newroot/sys", 0700))
> > > >         exit(1);
> > > >         if (mount("/sys", "./syz-tmp/newroot/sys", 0, bind_mount_fl=
ags, NULL))
> > > >         exit(1);
> > > >         if (mount("/sys/kernel/debug",
> > > > "./syz-tmp/newroot/sys/kernel/debug", NULL, bind_mount_flags, NULL)=
 &&
> > > > errno !=3D ENOENT)
> > > >         exit(1);
> > > >         if (mount("/sys/fs/smackfs",
> > > > "./syz-tmp/newroot/sys/fs/smackfs", NULL, bind_mount_flags, NULL) &=
&
> > > > errno !=3D ENOENT)
> > > >         exit(1);
> > > >         if (mount("/proc/sys/fs/binfmt_misc",
> > > > "./syz-tmp/newroot/proc/sys/fs/binfmt_misc", NULL, bind_mount_flags=
,
> > > > NULL) && errno !=3D ENOENT)
> > > >         exit(1);
> > > >         if (mkdir("./syz-tmp/pivot", 0777))
> > > >         exit(1);
> > > >         if (syscall(SYS_pivot_root, "./syz-tmp", "./syz-tmp/pivot")=
) {
> > > >                 if (chdir("./syz-tmp"))
> > > >         exit(1);
> > > >         } else {
> > > >                 if (chdir("/"))
> > > >         exit(1);
> > > >                 if (umount2("./pivot", MNT_DETACH))
> > > >         exit(1);
> > > >         }
> > > >         if (chroot("./newroot"))
> > > >         exit(1);
> > > >         if (chdir("/"))
> > > >         exit(1);
> > > >         setup_binderfs();
> > > >         setup_fusectl();
> > > > }
> > > >
> > > > static void setup_fusectl()
> > > > {
> > > >         if (mount(0, "/sys/fs/fuse/connections", "fusectl", 0, 0)) =
{
> > > >         }
> > > > }
> > > >
> > > > static void setup_binderfs()
> > > > {
> > > >         if (mkdir("/dev/binderfs", 0777)) {
> > > >         }
> > > >         if (mount("binder", "/dev/binderfs", "binder", 0, NULL)) {
> > > >         }
> > > >         if (symlink("/dev/binderfs", "./binderfs")) {
> > > >         }
> > > > }
> > > >
> > > > static void loop();
> > > >
> > > > static void sandbox_common()
> > > > {
> > > >         prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);
> > > >         if (getppid() =3D=3D 1)
> > > >         exit(1);
> > > >         struct rlimit rlim;
> > > >         rlim.rlim_cur =3D rlim.rlim_max =3D (200 << 20);
> > > >         setrlimit(RLIMIT_AS, &rlim);
> > > >         rlim.rlim_cur =3D rlim.rlim_max =3D 32 << 20;
> > > >         setrlimit(RLIMIT_MEMLOCK, &rlim);
> > > >         rlim.rlim_cur =3D rlim.rlim_max =3D 136 << 20;
> > > >         setrlimit(RLIMIT_FSIZE, &rlim);
> > > >         rlim.rlim_cur =3D rlim.rlim_max =3D 1 << 20;
> > > >         setrlimit(RLIMIT_STACK, &rlim);
> > > >         rlim.rlim_cur =3D rlim.rlim_max =3D 128 << 20;
> > > >         setrlimit(RLIMIT_CORE, &rlim);
> > > >         rlim.rlim_cur =3D rlim.rlim_max =3D 256;
> > > >         setrlimit(RLIMIT_NOFILE, &rlim);
> > > >         if (unshare(CLONE_NEWNS)) {
> > > >         }
> > > >         if (mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, NULL)) {
> > > >         }
> > > >         if (unshare(CLONE_NEWIPC)) {
> > > >         }
> > > >         if (unshare(0x02000000)) {
> > > >         }
> > > >         if (unshare(CLONE_NEWUTS)) {
> > > >         }
> > > >         if (unshare(CLONE_SYSVSEM)) {
> > > >         }
> > > >         typedef struct {
> > > >                 const char* name;
> > > >                 const char* value;
> > > >         } sysctl_t;
> > > >         static const sysctl_t sysctls[] =3D {
> > > >             {"/proc/sys/kernel/shmmax", "16777216"},
> > > >             {"/proc/sys/kernel/shmall", "536870912"},
> > > >             {"/proc/sys/kernel/shmmni", "1024"},
> > > >             {"/proc/sys/kernel/msgmax", "8192"},
> > > >             {"/proc/sys/kernel/msgmni", "1024"},
> > > >             {"/proc/sys/kernel/msgmnb", "1024"},
> > > >             {"/proc/sys/kernel/sem", "1024 1048576 500 1024"},
> > > >         };
> > > >         unsigned i;
> > > >         for (i =3D 0; i < sizeof(sysctls) / sizeof(sysctls[0]); i++=
)
> > > >                 write_file(sysctls[i].name, sysctls[i].value);
> > > > }
> > > >
> > > > static int wait_for_loop(int pid)
> > > > {
> > > >         if (pid < 0)
> > > >         exit(1);
> > > >         int status =3D 0;
> > > >         while (waitpid(-1, &status, __WALL) !=3D pid) {
> > > >         }
> > > >         return WEXITSTATUS(status);
> > > > }
> > > >
> > > > static void drop_caps(void)
> > > > {
> > > >         struct __user_cap_header_struct cap_hdr =3D {};
> > > >         struct __user_cap_data_struct cap_data[2] =3D {};
> > > >         cap_hdr.version =3D _LINUX_CAPABILITY_VERSION_3;
> > > >         cap_hdr.pid =3D getpid();
> > > >         if (syscall(SYS_capget, &cap_hdr, &cap_data))
> > > >         exit(1);
> > > >         const int drop =3D (1 << CAP_SYS_PTRACE) | (1 << CAP_SYS_NI=
CE);
> > > >         cap_data[0].effective &=3D ~drop;
> > > >         cap_data[0].permitted &=3D ~drop;
> > > >         cap_data[0].inheritable &=3D ~drop;
> > > >         if (syscall(SYS_capset, &cap_hdr, &cap_data))
> > > >         exit(1);
> > > > }
> > > >
> > > > static int do_sandbox_none(void)
> > > > {
> > > >         if (unshare(CLONE_NEWPID)) {
> > > >         }
> > > >         int pid =3D fork();
> > > >         if (pid !=3D 0)
> > > >                 return wait_for_loop(pid);
> > > >         sandbox_common();
> > > >         drop_caps();
> > > >         if (unshare(CLONE_NEWNET)) {
> > > >         }
> > > >         write_file("/proc/sys/net/ipv4/ping_group_range", "0 65535"=
);
> > > >         sandbox_common_mount_tmpfs();
> > > >         loop();
> > > >         exit(1);
> > > > }
> > > >
> > > > static void kill_and_wait(int pid, int* status)
> > > > {
> > > >         kill(-pid, SIGKILL);
> > > >         kill(pid, SIGKILL);
> > > >         for (int i =3D 0; i < 100; i++) {
> > > >                 if (waitpid(-1, status, WNOHANG | __WALL) =3D=3D pi=
d)
> > > >                         return;
> > > >                 usleep(1000);
> > > >         }
> > > >         DIR* dir =3D opendir("/sys/fs/fuse/connections");
> > > >         if (dir) {
> > > >                 for (;;) {
> > > >                         struct dirent* ent =3D readdir(dir);
> > > >                         if (!ent)
> > > >                                 break;
> > > >                         if (strcmp(ent->d_name, ".") =3D=3D 0 ||
> > > > strcmp(ent->d_name, "..") =3D=3D 0)
> > > >                                 continue;
> > > >                         char abort[300];
> > > >                         snprintf(abort, sizeof(abort),
> > > > "/sys/fs/fuse/connections/%s/abort", ent->d_name);
> > > >                         int fd =3D open(abort, O_WRONLY);
> > > >                         if (fd =3D=3D -1) {
> > > >                                 continue;
> > > >                         }
> > > >                         if (write(fd, abort, 1) < 0) {
> > > >                         }
> > > >                         close(fd);
> > > >                 }
> > > >                 closedir(dir);
> > > >         } else {
> > > >         }
> > > >         while (waitpid(-1, status, __WALL) !=3D pid) {
> > > >         }
> > > > }
> > > >
> > > > static void setup_test()
> > > > {
> > > >         prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);
> > > >         setpgrp();
> > > >         write_file("/proc/self/oom_score_adj", "1000");
> > > > }
> > > >
> > > > static void execute_one(void);
> > > >
> > > > #define WAIT_FLAGS __WALL
> > > >
> > > > static void loop(void)
> > > > {
> > > >         int iter =3D 0;
> > > >         for (;; iter++) {
> > > >                 int pid =3D fork();
> > > >                 if (pid < 0)
> > > >         exit(1);
> > > >                 if (pid =3D=3D 0) {
> > > >                         setup_test();
> > > >                         execute_one();
> > > >                         exit(0);
> > > >                 }
> > > >                 int status =3D 0;
> > > >                 uint64_t start =3D current_time_ms();
> > > >                 for (;;) {
> > > >                         sleep_ms(10);
> > > >                         if (waitpid(-1, &status, WNOHANG | WAIT_FLA=
GS) =3D=3D pid)
> > > >                                 break;
> > > >                         if (current_time_ms() - start < 5000)
> > > >                                 continue;
> > > >                         kill_and_wait(pid, &status);
> > > >                         break;
> > > >                 }
> > > >         }
> > > > }
> > > >
> > > > uint64_t r[1] =3D {0xffffffffffffffff};
> > > >
> > > > void execute_one(void)
> > > > {
> > > >         intptr_t res =3D 0;
> > > >         if (write(1, "executing program\n", sizeof("executing
> > > > program\n") - 1)) {}
> > > >         NONFAILING(memcpy((void*)0x20000000, "/dev/sg#\000", 9));
> > > >         res =3D -1;
> > > >         NONFAILING(res =3D syz_open_dev(/*dev=3D*/0x20000000, /*id=
=3D*/0,
> > > > /*flags=3D*/0));
> > > >         if (res !=3D -1)
> > > >                 r[0] =3D res;
> > > >         NONFAILING(memcpy((void*)0x20000040,
> > > > "\x00\x00\x00\x00\x42\x0d\x00\x00\x85\x0a\xaa", 11));
> > > >         NONFAILING(sprintf((char*)0x2000004b, "0x%016llx", (long lo=
ng)r[0]));
> > > >         syscall(__NR_ioctl, /*fd=3D*/r[0], /*cmd=3D*/1, /*arg=3D*/0=
x20000040ul);
> > > >
> > > > }
> > > > int main(void)
> > > > {
> > > >         syscall(__NR_mmap, /*addr=3D*/0x1ffff000ul, /*len=3D*/0x100=
0ul,
> > > > /*prot=3D*/0ul, /*flags=3DMAP_FIXED|MAP_ANONYMOUS|MAP_PRIVATE*/0x32=
ul,
> > > > /*fd=3D*/-1, /*offset=3D*/0ul);
> > > >         syscall(__NR_mmap, /*addr=3D*/0x20000000ul, /*len=3D*/0x100=
0000ul,
> > > > /*prot=3DPROT_WRITE|PROT_READ|PROT_EXEC*/7ul,
> > > > /*flags=3DMAP_FIXED|MAP_ANONYMOUS|MAP_PRIVATE*/0x32ul, /*fd=3D*/-1,
> > > > /*offset=3D*/0ul);
> > > >         syscall(__NR_mmap, /*addr=3D*/0x21000000ul, /*len=3D*/0x100=
0ul,
> > > > /*prot=3D*/0ul, /*flags=3DMAP_FIXED|MAP_ANONYMOUS|MAP_PRIVATE*/0x32=
ul,
> > > > /*fd=3D*/-1, /*offset=3D*/0ul);
> > > >         const char* reason;
> > > >         (void)reason;
> > > >         install_segv_handler();
> > > >         for (procid =3D 0; procid < 4; procid++) {
> > > >                 if (fork() =3D=3D 0) {
> > > >                         do_sandbox_none();
> > > >                 }
> > > >         }
> > > >         sleep(1000000);
> > > >         return 0;
> > > > }
> > > >
> > > >
> > > > - compiled test (please run inside VM)
> > > > https://drive.google.com/file/d/1Q9prtQKi5LVrOwrFJ162eXzTwTnDUq5X/v=
iew?usp=3Dsharing
> > > >
> > > > - kernel config
> > > > https://drive.google.com/file/d/1LMJgfJPhTu78Cd2DfmDaRitF6cdxxcey/v=
iew?usp=3Dsharing
> > > >
> > > > - compiled kernel
> > > > https://drive.google.com/file/d/1B22XKuDqrtk8gvWFFEMXR0o-VcVdYvB4/v=
iew?usp=3Dsharing
> > > >
> > >
> >
> >
