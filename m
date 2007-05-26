From: "Thibaut VARENE" <T-Bone@parisc-linux.org>
Subject: Re: [PATCH] add help to WAIT_SCAN option
Date: Sun, 27 May 2007 01:10:36 +0200
Message-ID: <7d01f9f00705261610q7d2d8bf8m777362802f8eb090@mail.gmail.com>
References: <20070526191127.GB7080@colo.lackof.org>
	 <20070526204447.GM5798@parisc-linux.org>
	 <7d01f9f00705261525k56cd1b9ag531640cc212036ae@mail.gmail.com>
	 <20070526230307.GN5798@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.247]:29977 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbXEZXKh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 May 2007 19:10:37 -0400
Received: by an-out-0708.google.com with SMTP id d31so326666and
        for <linux-scsi@vger.kernel.org>; Sat, 26 May 2007 16:10:36 -0700 (PDT)
In-Reply-To: <20070526230307.GN5798@parisc-linux.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On 5/27/07, Matthew Wilcox <matthew@wil.cx> wrote:
> On Sun, May 27, 2007 at 12:25:22AM +0200, Thibaut VARENE wrote:
> > My problem was that:
> > - I use a standalone kernel (no init{rd,ramfs})
> > - I have CONFIG_MODULES=y
> > - I build all my (needed) scsi drivers 'y' (builtin)
>
> > Yet CONFIG_SCSI_WAIT_SCAN defaults to 'm' with no possibility of
> > setting it otherwise. So I ended up with a kernel with builtin async
> > scsi scan and no wait_scan, thus not waiting for the probes to
> > complete before trying to mount rootfs...
>
> Thanks.  That's expected to work, as it's how I build my kernels too.
> Looks like this got broken when other people were trying to fix the
> modular case.  It *was* the case that scsi_wait_scan got built in to the
> kernel if CONFIG_SCSI was =y.  But of course, that's no good for people
> who build with CONFIG_SCSI=y and their driver =m -- they still have to
> have a module to load.  And we shouldn't prompt the user for it, we
> should determine the right thing to do.
>
> Not even compile tested (but it's at least approximately what the
> original async scanning patches used to do):
>
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c

Works For Me (tm)

HTH

T-Bone

-- 
Thibaut VARENE
http://www.parisc-linux.org/~varenet/
