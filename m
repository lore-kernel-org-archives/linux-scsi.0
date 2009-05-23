From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Convert scsi_scan to use generic async mechanism
Date: Sat, 23 May 2009 12:07:05 -0500
Message-ID: <1243098425.3630.26.camel@localhost.localdomain>
References: <20090428193557.GC21648@parisc-linux.org>
	 <1243095703.3630.24.camel@localhost.localdomain>
	 <20090523095108.6ccccd08@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34178 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752181AbZEWRHE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 May 2009 13:07:04 -0400
In-Reply-To: <20090523095108.6ccccd08@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>

On Sat, 2009-05-23 at 09:51 -0700, Arjan van de Ven wrote:
> On Sat, 23 May 2009 11:21:43 -0500
> > The reason scsi_add_device() is failing seems to be that
> > async_synchronize_full_domain() is a bit fragile in that it only
> > expects to be called once.  Call it again, like we do, to make sure
> > there aren't any outstanding scans and it hangs on the wait event.
> 
> it's supposed to be ok to call as many times as you want.
> What is NOT allowed is calling it from async work itself, due to the
> obvious deadlock.

The call trace doesn't seem to show we're nested ... although I suppose
we could eventually be if someone decided to do async PCI scanning.

Any other thoughts as to why this would be hanging?

James


