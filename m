From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2.6.24-rc8-git6] initio module hangs on loading fix set
Date: Wed, 23 Jan 2008 17:45:00 -0600
Message-ID: <1201131900.3110.111.camel@localhost.localdomain>
References: <47979CF0.7060104@croftnuisk.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:32850 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751865AbYAWXpI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jan 2008 18:45:08 -0500
In-Reply-To: <47979CF0.7060104@croftnuisk.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stuart Swales <stuart.swales@croftnuisk.co.uk>
Cc: linux-scsi@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>


On Wed, 2008-01-23 at 20:00 +0000, Stuart Swales wrote:
> I've verified (on my Initio 9100 with a DAT drive) that the 
> 2.6.24-rc8-git6 initio module still hangs on loading.
> 
> These fixes (other than the printk) are needed to get the module to load 
> ok (and work correctly) with my adapter & tape drive.
> 
> a) printk cosmetic fix
> 
> b) cblk->sglen needs setting for later DMA I/O routines to use
> 
> c) host->bios_addr needs setting for debug output correctness
> 
> d) semaph & semaph_lock initialisation had got lost since 2.6.22
> 
> e) since 2.6.22 the bios data address was truncated to 16 bits (needs 20 
> when shifted left)

That's brilliant, thanks!  (Linus has been complaining about the broken
state of initio for a while, so this saves my bacon).

I made your patch actually apply (your mailer broke it in places) and
stripped out the comments, which won't make sense to anyone who doesn't
have the context of the actual patch to look at.

Thanks,

James


