From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Patch] Fix oops on rmmod usb-storage
Date: Wed, 29 Sep 2004 13:03:32 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040929130332.A11785@infradead.org>
References: <415A67B8.2080003@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:29188 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S268327AbUI2MDg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 08:03:36 -0400
Content-Disposition: inline
In-Reply-To: <415A67B8.2080003@suse.de>; from hare@suse.de on Wed, Sep 29, 2004 at 09:43:52AM +0200
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com, Andrew Morton <akpm@osdl.org>

[please send scsi issues to linux-scsi, thanks]

> It turned out that in drivers/scsi/hosts.c:scsi_remove_host()
> first the host is removed with scsi_forget_host() and _then_ all 
> outstanding I/O to this host is cancelled with scsi_host_cancel(). 
> Sounds a bit fishy as scsi_host_cancel() tries to talk to a host which 
> we just have deleted ...
> (Incidentally, this is most likely the same bug as Bug #2752 and #3480 
> from bugme.osdl.org :-).
> (And also #133249 from bugzilla.redhat.com :-).
> 
> The attached patch corrects this.
> Please apply.

I'ts not that easy.  If we cancel the host first we won't get our write
caches flushed because the drivers don't accept the SYNCRHONIZE_CACHE.
command in cancelled state.  Mike just changed the order to what it is
now a short while ago.

So we'll have to find a way to send a SYNCHRNOZIE_CACHE command even
in canncelled state.

In fact I can't see how these problems could happen, and that they only
happen with usb-storage seems strange.
