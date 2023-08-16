Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B3E7C07E8C
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Aug 2023 14:40:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343755AbjHPOjv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Aug 2023 10:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343751AbjHPOjV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2023 10:39:21 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3132733
        for <linux-scsi@vger.kernel.org>; Wed, 16 Aug 2023 07:38:53 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 41be03b00d2f7-5654051b27fso4978093a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 16 Aug 2023 07:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20221208.gappssmtp.com; s=20221208; t=1692196728; x=1692801528;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z7kyCuHl1t/gCCGpNTbA3hwFj/lf6SuaKvtbsxGuDBs=;
        b=dZxL0Ptmo/RfqSZAnaNdMqEON3wvqTtz9rCCZbGwRlxrXd7njXeZ9MC0HoDMQnzbMm
         Mbp7gkbEr8As7DndYa19Nv36eYd2hToSSCFzF826MiTxJFQPanB3TDkisU5ug1n2xO0x
         lqvfBU8gjYGcjvzm7z1KhnYi76zAKQMvLjSkKN8VKcgO7yrfcLxnnczFGmL7s8fYvGKe
         iupXY/7su7eB4Qp8Ot15WegMitq0aXkC7C2B4amBqtpQq9iCTqbSvz7oVYvokSqAF4SL
         qE7Cmnt2iThlim9z5xca3mEZ27llu2nfrUpa7hwX8WY7UkN0OSfjH/LjoRTW/fMpY9+M
         GNdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692196728; x=1692801528;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z7kyCuHl1t/gCCGpNTbA3hwFj/lf6SuaKvtbsxGuDBs=;
        b=XWZtGPcCqJs9uHQXNBFSGN2v5SLolPWSiY95SI4zpSOWX9xT3KXVWmasfF/LNg9fgv
         MgDpwW0nsOrM0fA0TkGcSCCrMLE5GiSFyX2aeyXLdWlS8Lj1b98xhfWKmjZlVtbtEBJH
         FfLqmZ0Cb8nnfm5HRsXTAh3FDXlPFvK5iRpxb0zzWi0wvRhUu96w3VCTmebz/e0Xgnvh
         FMuLCWTPrvqsCH+d9fFP/QvNU0VxUTro6Ku92WA859zNO/0SpnAGlhBXKwe0/wPdz/mA
         JI96WUCFKruEyu8t1SzS2YdpCmHETvNpjsHWK4wBJCkcqDe7YjLWnR+64E0Hky41umF0
         iHCg==
X-Gm-Message-State: AOJu0YywccrYha4eP7lhD4ytc3u/PnAnZE9kAkPrp2COh/gS9dDNhiBP
        4A1xciI3n3hdgpTO9jn3X/++gQ==
X-Google-Smtp-Source: AGHT+IG9lm23RRLom/xb7C80klG2aDXB0ZwUgcZV4fsV/hyXYHdBd19S4I3YH9SwHqrCXPj4TdemSQ==
X-Received: by 2002:a17:90a:f982:b0:26b:4e59:57e7 with SMTP id cq2-20020a17090af98200b0026b4e5957e7mr1730234pjb.43.1692196727793;
        Wed, 16 Aug 2023 07:38:47 -0700 (PDT)
Received: from localhost ([135.180.227.0])
        by smtp.gmail.com with ESMTPSA id gi23-20020a17090b111700b0025645ce761dsm13120399pjb.35.2023.08.16.07.38.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 07:38:47 -0700 (PDT)
Date:   Wed, 16 Aug 2023 07:38:47 -0700 (PDT)
X-Google-Original-Date: Wed, 16 Aug 2023 07:38:45 PDT (-0700)
Subject:     Re: [PATCH 00/17] -Wmissing-prototype warning fixes
In-Reply-To: <20230810141947.1236730-1-arnd@kernel.org>
CC:     akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, mattst88@gmail.com,
        vgupta@kernel.org, linux@armlinux.org.uk,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, guoren@kernel.org,
        bcain@quicinc.com, chenhuacai@kernel.org, kernel@xen0n.name,
        geert@linux-m68k.org, monstr@monstr.eu, tsbogend@alpha.franken.de,
        dinguyen@kernel.org, jonas@southpole.se,
        stefan.kristiansson@saunalahti.fi, shorne@gmail.com,
        James.Bottomley@HansenPartnership.com, deller@gmx.de,
        mpe@ellerman.id.au, christophe.leroy@csgroup.eu, hca@linux.ibm.com,
        glaubitz@physik.fu-berlin.de, x86@kernel.org, bp@alien8.de,
        jcmvbkbc@gmail.com, axboe@kernel.dk, sudipm.mukherjee@gmail.com,
        martin.petersen@oracle.com, richard@nod.at, bhelgaas@google.com,
        masahiroy@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        linux@roeck-us.net, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-alpha@vger.kernel.org,
        linux-snps-arc@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
        linux-hexagon@vger.kernel.org, linux-ia64@vger.kernel.org,
        loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org,
        linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-trace-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kbuild@vger.kernel.org
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     arnd@kernel.org
Message-ID: <mhng-ce493a2d-71e9-440f-84d0-522a4f694bbe@palmer-ri-x1c9>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 10 Aug 2023 07:19:18 PDT (-0700), arnd@kernel.org wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> Most of the patches I sent so far for the -Wmissing-prototype warnings
> have made it into linux-next now. There are a few that I'm resending
> now as nobody has picked them up, and then a number of fixes that I
> found while test-building across all architectures rather than just the
> ones I usually test.
>
> The first 15 patches in this series should be uncontroversial, so
> I expect that either a subsystem maintainer or Andrew Morton can
> apply these directly.
>
> For the last two patches, these might still need some debate about how
> to handle them. I added a Kconfig option to turn off most of the missing
> prototype warnings in the architectures that nobody has fixed yet,
> see patch 16 for those. The last patch does cause some known warnings
> and likely unknown ones for architectures other than x86 and arm,
> so applying it now will bring new problems, but not applying it also
> means that new warnings creep in, so I think this is mainly a question
> of what the best timing is for having this in linux-next.
>
> Arnd Bergmann (17):
>   [RESEND] jffs2: mark __jffs2_dbg_superblock_counts() static
>   [RESEND] irq_work: consolidate arch_irq_work_raise prototypes
>   [RESEND] ida: make 'ida_dump' static
>   pci: sysfs: move declarations to linux/pci.h
>   swim3: mark swim3_init() static
>   macintosh/ams: mark ams_init() static
>   scsi: qlogicpti: mark qlogicpti_info() static
>   microblaze: mark flush_dcache_folio() inline
>   parport: gsc: mark init function static
>   zorro: include zorro.h in names.c
>   scsi: gvp11: remove unused gvp11_setup() function
>   time: make sysfs_get_uname() function visible in header
>   stackleak: add declarations for global functions
>   kprobes: unify kprobes_exceptions_nofify() prototypes
>   arch: fix asm-offsets.c building with -Wmissing-prototypes
>   [RFC] arch: turn -Wmissing-prototypes off conditionally
>   [RFC] Makefile.extrawarn: turn on missing-prototypes again
>
>  arch/alpha/Kbuild                        |  2 ++
>  arch/alpha/include/asm/pci.h             |  3 ---
>  arch/alpha/kernel/asm-offsets.c          |  2 +-
>  arch/alpha/lib/Makefile                  |  1 +
>  arch/arc/Kbuild                          |  2 ++
>  arch/arc/include/asm/kprobes.h           |  3 ---
>  arch/arm/include/asm/irq_work.h          |  2 --
>  arch/arm/include/asm/kprobes.h           |  2 --
>  arch/arm64/include/asm/irq_work.h        |  2 --
>  arch/arm64/include/asm/kprobes.h         |  2 --
>  arch/csky/Kbuild                         |  2 ++
>  arch/csky/include/asm/irq_work.h         |  2 +-
>  arch/hexagon/Kbuild                      |  2 ++
>  arch/ia64/Kbuild                         |  2 ++
>  arch/ia64/include/asm/kprobes.h          |  2 --
>  arch/ia64/kernel/asm-offsets.c           |  2 +-
>  arch/ia64/lib/Makefile                   |  1 +
>  arch/loongarch/Kbuild                    |  2 ++
>  arch/loongarch/kernel/asm-offsets.c      | 12 ++++++++++++
>  arch/m68k/Kbuild                         |  2 ++
>  arch/m68k/lib/Makefile                   |  1 +
>  arch/microblaze/Kbuild                   |  2 ++
>  arch/microblaze/include/asm/cacheflush.h |  2 +-
>  arch/mips/Kbuild                         |  2 ++
>  arch/mips/boot/compressed/Makefile       |  3 ++-
>  arch/mips/include/asm/kprobes.h          |  2 --
>  arch/nios2/Kbuild                        |  2 ++
>  arch/nios2/lib/Makefile                  |  1 +
>  arch/openrisc/Kbuild                     |  2 ++
>  arch/parisc/Kbuild                       |  2 ++
>  arch/parisc/lib/Makefile                 |  1 +
>  arch/powerpc/include/asm/irq_work.h      |  1 -
>  arch/powerpc/include/asm/kprobes.h       |  2 --
>  arch/riscv/include/asm/irq_work.h        |  2 +-
>  arch/s390/include/asm/irq_work.h         |  2 --
>  arch/s390/include/asm/kprobes.h          |  2 --
>  arch/sh/Kbuild                           |  2 ++
>  arch/sh/boot/compressed/Makefile         |  1 +
>  arch/sh/include/asm/kprobes.h            |  2 --
>  arch/sparc/Kbuild                        |  2 ++
>  arch/sparc/include/asm/kprobes.h         |  2 --
>  arch/sparc/kernel/asm-offsets.c          | 13 ++-----------
>  arch/sparc/lib/Makefile                  |  1 +
>  arch/sparc/prom/Makefile                 |  1 +
>  arch/x86/include/asm/irq_work.h          |  1 -
>  arch/x86/include/asm/kprobes.h           |  2 --
>  arch/xtensa/Kbuild                       |  2 ++
>  arch/xtensa/boot/lib/Makefile            |  2 ++
>  drivers/block/swim3.c                    |  2 +-
>  drivers/macintosh/ams/ams-core.c         |  2 +-
>  drivers/parport/parport_gsc.c            |  2 +-
>  drivers/scsi/gvp11.c                     |  5 -----
>  drivers/scsi/qlogicpti.c                 |  2 +-
>  drivers/zorro/names.c                    |  1 +
>  fs/jffs2/debug.c                         |  2 +-
>  include/linux/irq_work.h                 |  3 +++
>  include/linux/kprobes.h                  |  4 ++++
>  include/linux/pci.h                      |  5 +++++
>  include/linux/stackleak.h                |  6 ++++++
>  init/Kconfig                             | 10 ++++++++++
>  kernel/time/tick-internal.h              |  3 ++-
>  lib/test_ida.c                           |  2 +-
>  scripts/Makefile.extrawarn               |  5 +++--
>  63 files changed, 101 insertions(+), 63 deletions(-)

Acked-by: Palmer Dabbelt <palmer@rivosinc.com> # RISC-V
