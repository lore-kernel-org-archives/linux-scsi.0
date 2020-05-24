Return-Path: <SRS0=1EFY=7G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F1A6C433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 24 May 2020 04:28:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A52B2076C
	for <linux-scsi@archiver.kernel.org>; Sun, 24 May 2020 04:28:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbgEXE2X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 May 2020 00:28:23 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:39322 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgEXE2W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 24 May 2020 00:28:22 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id BF32B22857;
        Sun, 24 May 2020 00:28:10 -0400 (EDT)
Date:   Sun, 24 May 2020 14:28:09 +1000 (AEST)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Daniel Wagner <dwagner@suse.de>,
        Bart Van Assche <bvanassche@acm.org>
cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Arun Easi <aeasi@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH v7 15/15] qla2xxx: Fix endianness annotations in source
 files
In-Reply-To: <20200520085652.ps64ccmgjefc46cc@beryllium.lan>
Message-ID: <alpine.LNX.2.22.394.2005211358460.8@nippy.intranet>
References: <20200518211712.11395-1-bvanassche@acm.org> <20200518211712.11395-16-bvanassche@acm.org> <20200519152401.oh6cewdru3fu7ogd@beryllium.lan> <alpine.LNX.2.22.394.2005201726250.8@nippy.intranet> <20200520085652.ps64ccmgjefc46cc@beryllium.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I went through commit 7ffa5b939751 ("scsi: qla2xxx: Fix endianness 
annotations in source files") and produced a new version without the 
'const' changes and without the new local variables. I also tweaked a few 
line breaks so that the line numbers did not change.

I then built the driver both with and without the patch:

mkdir /tmp/patched /tmp/unpatched
rm drivers/scsi/qla2xxx/built-in.a drivers/scsi/qla2xxx/*.o *.[is] 
make KBUILD_CFLAGS=-save-temps drivers/scsi/qla2xxx/built-in.a
mv *.s /tmp/patched/
git checkout @^
rm drivers/scsi/qla2xxx/built-in.a drivers/scsi/qla2xxx/*.o *.[is] 
make KBUILD_CFLAGS=-save-temps drivers/scsi/qla2xxx/built-in.a
mv *.s /tmp/unpatched/
meld /tmp/patched/ /tmp/unpatched/

This revealed some differences, in both x86_64 and i686 builds.

1. The wordsize changes in qla24xx_els_ct_entry() apparently prevented the 
compiler from emitting zero-extension mov (movzwl) instructions.

diff -ru /tmp/unpatched/qla_isr.s /tmp/patched/qla_isr.s
--- /tmp/unpatched/qla_isr.s    2020-05-24 13:59:04.327714528 +1000
+++ /tmp/patched/qla_isr.s      2020-05-24 13:56:58.437529886 +1000
@@ -8947,11 +8947,9 @@
        movw    %ax, -26(%rbp)
        movq    -104(%rbp), %rax
        movl    36(%rax), %eax
-       movzwl  %ax, %eax
        movl    %eax, -76(%rbp)
        movq    -104(%rbp), %rax
        movl    40(%rax), %eax
-       movzwl  %ax, %eax
        movl    %eax, -72(%rbp)
        cmpl    $83, -108(%rbp)
        jne     .L601
@@ -8991,8 +8989,7 @@
        movl    $458752, -12(%rbp)
 .L603:
        movq    -104(%rbp), %rax
-       movl    32(%rax), %eax
-       movzwl  %ax, %edi
+       movl    32(%rax), %edi
        movl    -72(%rbp), %esi
        movl    -76(%rbp), %ecx
        movzwl  -26(%rbp), %edx
(and so on.)

2. The get_unaligned_le32() changes produce new pointer offsets in the 
assembly code for qla82xx_get_table_desc() and qla82xx_get_data_desc().

diff -ru /tmp/unpatched/qla_target.s /tmp/patched/qla_target.s
--- /tmp/unpatched/qla_target.s 2020-05-24 14:02:32.178019380 +1000
+++ /tmp/patched/qla_target.s   2020-05-24 14:01:43.487947966 +1000
@@ -12884,10 +12884,10 @@
        .cfi_offset 6, -16
        movq    %rsp, %rbp
        .cfi_def_cfa_register 6
-       subq    $32, %rsp
-       movq    %rdi, -24(%rbp)
-       movq    %rsi, -32(%rbp)
-       movq    -32(%rbp), %rax
+       subq    $64, %rsp
+       movq    %rdi, -56(%rbp)
+       movq    %rsi, -64(%rbp)
+       movq    -64(%rbp), %rax
        movl    52(%rax), %eax
        movl    %eax, -8(%rbp)
        movl    $24, -12(%rbp)
@@ -12895,62 +12895,62 @@
        cmpl    %eax, -12(%rbp)
        cmovbe  -12(%rbp), %eax
        movl    %eax, %edx
-       movq    -32(%rbp), %rax
+       movq    -64(%rbp), %rax
        movl    %edx, 52(%rax)
-       movq    -24(%rbp), %rax
+       movq    -56(%rbp), %rax
(and so on.)

Was this expected? I find it surprising...

FWIW, I think that the .s files could have been validated automatically 
had the changes in the patch been confined to annotations.
