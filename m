From: Christoph Hellwig <hch@lst.de>
Subject: Re: 2.6.6 + Adaptec I2O
Date: Tue, 1 Jun 2004 17:20:20 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040601152020.GA6706@lst.de>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189FAD510E@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:36296 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265080AbUFAPUf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2004 11:20:35 -0400
Content-Disposition: inline
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189FAD510E@otce2k03.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, Leon Toh <tltoh@attglobal.net>, Christoph Hellwig <hch@lst.de>

On Tue, Jun 01, 2004 at 11:11:22AM -0400, Salyzyn, Mark wrote:
> Please read CHANGELOG.dpt_i2o for change documentation.
> 
> Two changes recently posted by Christoph Hellwig have been incorporated
> in this patch.
> 
> This patch has aimed towards 2.6 purity, and although the sources
> maintained at Adaptec are unified (2.4 & 2.6), scripts were used to
> remove the ifdef KERNEL_VERSION from this release. This source is in
> synchronized with the patch on May 19th submitted for dpt_i2o in the 2.4
> tree.
> 
> I look forward to comments regarding this patch.

Patch is mostly okay although it still won't win a beaty contest.

Two showstoppers though:

 - the spin_is_locked magic is really, really bogus.  Easiest way to
   avoid this is to have your own spinlock in adpt_hba and use
   scsi_assign_lock to make it the host_lock, too.  With a little
   magic you'll also get per-host locks in the various 2.4 vendor
   trees with that..
 - you're still trying to sneak DPT_TARGET_BUSY back in.

Please fix those two issues and the patch can go in.

