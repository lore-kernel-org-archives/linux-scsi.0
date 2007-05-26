From: "Thibaut VARENE" <T-Bone@parisc-linux.org>
Subject: Re: [PATCH] add help to WAIT_SCAN option
Date: Sun, 27 May 2007 00:25:22 +0200
Message-ID: <7d01f9f00705261525k56cd1b9ag531640cc212036ae@mail.gmail.com>
References: <20070526191127.GB7080@colo.lackof.org>
	 <20070526204447.GM5798@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.249]:4529 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbXEZWZW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 May 2007 18:25:22 -0400
Received: by an-out-0708.google.com with SMTP id d31so325510and
        for <linux-scsi@vger.kernel.org>; Sat, 26 May 2007 15:25:22 -0700 (PDT)
In-Reply-To: <20070526204447.GM5798@parisc-linux.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On 5/26/07, Matthew Wilcox <matthew@wil.cx> wrote:
> On Sat, May 26, 2007 at 01:11:27PM -0600, Grant Grundler wrote:
> > Thibaut Varene's parisc box didn't find the root disk.
> > Problem is he had ASYNC_SCAN enabled and the required SYM2 driver builtin
> > but the root disk wasn't discovered before the kernel wanted to mount root.
> > Oh, and he (like many folks who build their own kernels) didn't use
> > an initrd or initramfs. So no chance to load scsi_wait_scan module.
>
> I don't know what Thibaut's problem was, but this explanation is
> definitely incorrect.  If you build in the sym2 driver and the scsi
> core, then we wait for the discs to be discovered automatically.

My problem was that:
- I use a standalone kernel (no init{rd,ramfs})
- I have CONFIG_MODULES=y
- I build all my (needed) scsi drivers 'y' (builtin)

Yet CONFIG_SCSI_WAIT_SCAN defaults to 'm' with no possibility of
setting it otherwise. So I ended up with a kernel with builtin async
scsi scan and no wait_scan, thus not waiting for the probes to
complete before trying to mount rootfs...

Editing KConfig to allow setting CONFIG_SCSI_WAIT_SCAN=y "fixed" the problem.

HTH

T-Bone

-- 
Thibaut VARENE
http://www.parisc-linux.org/~varenet/
