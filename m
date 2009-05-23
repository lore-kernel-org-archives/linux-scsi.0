From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Convert scsi_scan to use generic async mechanism
Date: Sat, 23 May 2009 15:42:20 -0500
Message-ID: <1243111340.3630.41.camel@localhost.localdomain>
References: <20090428193557.GC21648@parisc-linux.org>
	 <1243095703.3630.24.camel@localhost.localdomain>
	 <20090523095108.6ccccd08@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43114 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752904AbZEWUmT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 May 2009 16:42:19 -0400
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

OK, this turns out to be a classic ABBA deadlock.

async_synchronize_domain() is one waiter and the scan mutex is the
other.  What's happening is that scsi_add_device() takes the scan mutex
and then waits for the async scan thread to complete.  Meanwhile the
async thread is dropping and reacquiring the mutex as it moves from
scanning to adding devices.  Result: Deadlock.

I think a reasonable fix is to take the scan mutex *after* waiting for
the async scans to complete.  An alternative might be to have a version
of scsi_scan_host_selected that doesn't take the mutex so we can hold it
entirely over async_scsi_scan_host(), but that gets a bit messy.

I'll drop the async scan conversion patch until we can get this all
sorted out.

James


