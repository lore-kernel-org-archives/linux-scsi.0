From: Borislav Petkov <bp@alien8.de>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
 scsi_prep_state_check+0x9/0x90
Date: Thu, 26 Jan 2012 11:49:13 +0100
Message-ID: <20120126104913.GA5095@x1.osrc.amd.com>
References: <20120125162748.GA2715@x1.osrc.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.skyhub.de ([78.46.96.112]:56319 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab2AZKtS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jan 2012 05:49:18 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTP id 989CB1D9896
	for <linux-scsi@vger.kernel.org>; Thu, 26 Jan 2012 11:49:16 +0100 (CET)
Received: from mail.skyhub.de ([127.0.0.1])
	by localhost (door.skyhub.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GqPv7HJsRrlG for <linux-scsi@vger.kernel.org>;
	Thu, 26 Jan 2012 11:49:16 +0100 (CET)
Received: from x1.localdomain (ip-90-186-152-201.web.vodafone.de [90.186.152.201])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA
	for <linux-scsi@vger.kernel.org>; Thu, 26 Jan 2012 11:49:16 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20120125162748.GA2715@x1.osrc.amd.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Wed, Jan 25, 2012 at 05:27:49PM +0100, Borislav Petkov wrote:
> Hi all,
> 
> this is the oopsie I'm getting on 3.3-rc1 when inserting a Nokia
> internet stick CS-19 which has obviously a CD-ROM interface which
> is addressed through the SCSI layer. However, the blk request gets
> killed prematurely, causing a scsi_device * ptr to be NULL in
> scsi_prep_state_check(), which, IMHO, shouldn't happen, no matter
> whether the request is killed or not. Here's the relevant dmesg text and
> follow-up oops:

Btw,

I forgot to dump the actual function decode. So, according to the
register dump in the backtrace, we have %rdi = 0x0

And we are right at the beginning of scsi_prep_state_check:

scsi_prep_state_check:
	pushq	%rbp	#
	movq	%rsp, %rbp	#,
	call	mcount
	movl	2536(%rdi), %eax	# sdev_3(D)->sdev_state, D.34805


0000000000000b80 <scsi_prep_state_check>:
     b80:       55                      push   %rbp
     b81:       48 89 e5                mov    %rsp,%rbp
     b84:       e8 00 00 00 00          callq  b89 <scsi_prep_state_check+0x9>
     b89:       8b 87 e8 09 00 00       mov    0x9e8(%rdi),%eax			<-------------
     b8f:       83 f8 02                cmp    $0x2,%eax
     b92:       75 04                   jne    b98 <scsi_prep_state_check+0x18>
     b94:       31 c0                   xor    %eax,%eax

so sdev is NULL.

-- 
Regards/Gruss,
Boris.
