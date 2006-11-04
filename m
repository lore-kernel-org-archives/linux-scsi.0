From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] use one-element sg list in scsi_send_eh_cmnd
Date: Sat, 4 Nov 2006 21:28:35 +0100
Message-ID: <20061104202835.GA26880@lst.de>
References: <20061104190421.GA23477@lst.de> <809856.67393.qm@web31801.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:27082 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S965664AbWKDU2j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Nov 2006 15:28:39 -0500
Content-Disposition: inline
In-Reply-To: <809856.67393.qm@web31801.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, linux-scsi@vger.kernel.org

On Sat, Nov 04, 2006 at 12:15:58PM -0800, Luben Tuikov wrote:
> --- Christoph Hellwig <hch@lst.de> wrote:
> 
> > scsi_send_eh_cmnd is the last user of non-sg commands currently.
> > This patch switches it to a one-element SG list.  Also updates the
> > kerneldoc comment for scsi_send_eh_cmnd to reflect reality while we're
> > at it.
> 
> So now "use_sg" means "always yes".

Yes. (Except for the no data transfer case of course)

> In this case I'd suggest you rename "use_sg" to something like
> "num_sg" or "num_scatter" or "num_scatter_elements" or something
> to this effect.
> 
> This will unambiguate its meaning and use.

That's entirely correct and I plan to fix it.  The fix will happen
as part of introducing support for bidirectional commands, as we
will need to use_sg/num_scatter elements in that case anyway.

