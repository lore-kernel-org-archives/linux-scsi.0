From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] add help to WAIT_SCAN option
Date: Sat, 26 May 2007 18:27:10 -0600
Message-ID: <20070527002710.GR5798@parisc-linux.org>
References: <20070526191127.GB7080@colo.lackof.org> <1180209014.3712.69.camel@mulgrave.il.steeleye.com> <20070527000637.GB31023@colo.lackof.org> <1180224943.3712.84.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:44687 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbXE0A1M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 May 2007 20:27:12 -0400
Content-Disposition: inline
In-Reply-To: <1180224943.3712.84.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Grant Grundler <grundler@parisc-linux.org>, linux-scsi@vger.kernel.org, Thibaut VARENE <T-Bone@parisc-linux.org>

On Sat, May 26, 2007 at 07:15:43PM -0500, James Bottomley wrote:
> Actually, it's a thinko on my part ... I thought late_initcall() and
> module_init() are the same level, and hence this would be link order
> dependent.  Actually that's only true in the modular case, so the patch
> is fine ... I'll put it in.

I disagree that Grant's patch is fine.  Consider:

 - CONFIG_SCSI=y
 - CONFIG_SCSI_SYM2=y
 - CONFIG_SCSI_QLA2XYZ=m

You want the root disc on your sym2 to be found, so you need
SCSI_WAIT_SCAN=y, but you also want to know when qla2xyz has finished
scanning the fabric, so you need SCSI_WAIT_SCAN=m.  My patch doesn't
have this problem.
