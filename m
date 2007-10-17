From: Willy Tarreau <w@1wt.eu>
Subject: Re: [Bug 3680] sym53c8xx_2 SMP deadlock on driver load
Date: Wed, 17 Oct 2007 17:20:19 +0200
Message-ID: <20071017152019.GA1871@1wt.eu>
References: <20071017013045.A19ED108036@picon.linux-foundation.org> <471621D2.5080806@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 1wt.eu ([62.212.114.60]:3165 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762188AbXJQPvx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Oct 2007 11:51:53 -0400
Content-Disposition: inline
In-Reply-To: <471621D2.5080806@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, protasnb@gmail.com, bugme-daemon@bugzilla.kernel.org

On Wed, Oct 17, 2007 at 10:53:06AM -0400, Tony Battersby wrote:
> > So we should unconditionally drop the lock (and re-enable
> > interrupts) and re-acquire it.
> 
> After looking at it carefully, this is true of pci_map_mem, but not
> pci_unmap_mem.  pci_unmap_mem can be called from both ->detect and
> ->release.  io_request_lock is held in ->detect but not in ->release.
> So, your patch locks up the system on module unload.
> 
> I have put together and tested a new patch which does it correctly,
> while still trying to make only minimal changes.
> If you approve, this can go into the next 2.4.x release.

(...)

> -static void __init pci_unmap_mem(u_long vaddr, u_long size)
> -{
> -	if (vaddr)
> +static void __init pci_unmap_mem(u_long vaddr,
> +                                 u_long size,
> +                                 int holding_io_request_lock)

This is marked __init, and pci_unmap_mem() is called from
sym_free_resources(), which in turn is called from sym_detach(),
called from sym53c8xx_release() when unloading module. So the section
may not be there anymore upon unload. I wonder how this can work right
now. I'm surely missing something :-/

Willy

