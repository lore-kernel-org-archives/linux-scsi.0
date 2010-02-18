From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Thu, 18 Feb 2010 09:47:29 -0600
Message-ID: <1266508049.4355.37.camel@mulgrave.site>
References: <3e7aae31002170437i52ba4ba1w10c1ff224d9b37ef@mail.gmail.com>
	 <1266418952.2787.5.camel@mulgrave.site>
	 <3e7aae31002180046i771f2e1encfcda864f564c87e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:59013 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758515Ab0BRPrg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2010 10:47:36 -0500
In-Reply-To: <3e7aae31002180046i771f2e1encfcda864f564c87e@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ramya Desai <ramya.desai@gmail.com>
Cc: USB list <linux-usb@vger.kernel.org>, linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>

On Thu, 2010-02-18 at 14:16 +0530, Ramya Desai wrote:
> On Wed, Feb 17, 2010 at 8:32 PM, James Bottomley
> <James.Bottomley@suse.de> wrote:
> 
> > I have no idea what the MS driver is, so it's impossible to answer
> > specifically.
> 
> MS means mass storage driver only.

OK, still don't know what that is ... but Randy decoded this for me; he
said you mean a driver under drivers/usb/storage?  

In that case, it looks like the helpers in protocol.c do use chaining
correctly (as long as the driver isn't doing direct dma), but there's a
clamp on the sg table size in scsiglue.c:

.sg_tablesize = SG_ALL

That would have to be changed to SCSI_MAX_SG_CHAIN_SEGMENTS to enable
chaining.

James


