From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] merge scsiiom.c into tmscsim.c
Date: Sun, 17 Jun 2007 20:09:49 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0706171845490.9578@poirot.grange>
References: <20041003134714.GA1623@lst.de> <Pine.LNX.4.60.0706171651350.9578@poirot.grange>
 <46756069.5010607@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45164 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756981AbXFQSJs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Jun 2007 14:09:48 -0400
In-Reply-To: <46756069.5010607@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Sun, 17 Jun 2007, Boaz Harrosh wrote:

> I think the all thing is no longer relevant. It is leftovers from the time
> scsi_error.c specifically scsi_send_eh_cmnd (used by scsi_request_sense) was
> stepping all over the scsi_cmnd fields and things needed to be saved, if they
> were needed for a retry. But now (since a later cleanup made by Christoph)
> scsi_send_eh_cmnd() does not do that any more.

Ok, what I really was trying to understand is the auto request sense path 
in tmscsim, and, I think, I have a better idea now how it is supposed to 
work. In fact, I don't know how really necessary this path is. I guess, 
requesting sense would anyway be handled by the ml, so, doing it in the 
lld is just a (micro-) optimization, right? So, though superfluous and 
making the driver less maintainable, we might keep it for now.

> In any way pcmd->use_sg is
> never touched anywhere in the code and any code called from this driver.
> So why save it?
> 
> Or am I missing some bigger picture Here?

Looks like you're right. SavedSGCount seems indeed unneeded. I'll ack your 
patch.

Thanks
Guennadi
---
Guennadi Liakhovetski
