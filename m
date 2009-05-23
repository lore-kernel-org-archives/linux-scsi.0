From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] Convert scsi_scan to use generic async mechanism
Date: Sat, 23 May 2009 09:51:08 -0700
Message-ID: <20090523095108.6ccccd08@infradead.org>
References: <20090428193557.GC21648@parisc-linux.org>
	<1243095703.3630.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:41881 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789AbZEWQ7m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 May 2009 12:59:42 -0400
In-Reply-To: <1243095703.3630.24.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>

On Sat, 23 May 2009 11:21:43 -0500
> The reason scsi_add_device() is failing seems to be that
> async_synchronize_full_domain() is a bit fragile in that it only
> expects to be called once.  Call it again, like we do, to make sure
> there aren't any outstanding scans and it hangs on the wait event.

it's supposed to be ok to call as many times as you want.
What is NOT allowed is calling it from async work itself, due to the
obvious deadlock.
