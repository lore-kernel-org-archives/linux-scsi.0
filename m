From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] qla2xxx: correct locking while call starget_for_each_device()
Date: Tue, 9 Jan 2007 12:58:24 -0700
Message-ID: <20070109195824.GB9819@parisc-linux.org>
References: <A6970E9A290F3F4682E1EAD0EA14F32B8069EA@AVEXCH2.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:51651 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932186AbXAIT6Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jan 2007 14:58:25 -0500
Content-Disposition: inline
In-Reply-To: <A6970E9A290F3F4682E1EAD0EA14F32B8069EA@AVEXCH2.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>, James Bottomley <James.Bottomley@SteelEye.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi@vger.kernel.org

On Tue, Jan 09, 2007 at 11:37:52AM -0800, Seokmann Ju wrote:
> Removed spin_unlock_irq()/spin_lock_irq() pairs surrounding
> starget_for_each_device() calls.
> As Matthew W. pointed out, starget_for_each_device() can be called under
> a spinlock being held.
> The change has been tested and verified on qla2xxx.ko module.

Did you try it with lockdep enabled?  I worry about an AB-BA deadlock.

