From: Christoph Hellwig <hch@lst.de>
Subject: Re: 2.6.6 + Adaptec I2O
Date: Tue, 1 Jun 2004 17:23:57 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040601152357.GA6928@lst.de>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189FAD510E@otce2k03.adaptec.com> <20040601152020.GA6706@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:40648 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265033AbUFAPYL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2004 11:24:11 -0400
Content-Disposition: inline
In-Reply-To: <20040601152020.GA6706@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, Leon Toh <tltoh@attglobal.net>

On Tue, Jun 01, 2004 at 05:20:20PM +0200, Christoph Hellwig wrote:
> Two showstoppers though:
> 
>  - the spin_is_locked magic is really, really bogus.  Easiest way to
>    avoid this is to have your own spinlock in adpt_hba and use
>    scsi_assign_lock to make it the host_lock, too.  With a little
>    magic you'll also get per-host locks in the various 2.4 vendor
>    trees with that..
>  - you're still trying to sneak DPT_TARGET_BUSY back in.
> 
> Please fix those two issues and the patch can go in.

Ah, and one more:  README.dpti is misplaced in drivers/scsi/, it should
update Documentation/scsi/dpti.txt instead.

