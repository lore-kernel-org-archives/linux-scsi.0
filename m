From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCHv2] libsas: Fixup transport protocol definition in
 sas_get_ata_info()
Date: Tue, 07 Apr 2015 08:59:23 -0700
Message-ID: <1428422363.15207.45.camel@HansenPartnership.com>
References: <1428396547-87814-1-git-send-email-hare@suse.de>
	 <20150407154550.GA18837@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47412 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754107AbbDGP7Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2015 11:59:24 -0400
In-Reply-To: <20150407154550.GA18837@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

On Tue, 2015-04-07 at 17:45 +0200, Christoph Hellwig wrote:
> On Tue, Apr 07, 2015 at 10:49:07AM +0200, Hannes Reinecke wrote:
> > 'tproto' specifies the transport protocol, not the device type.
> > So use the correct definitions here.
> > 
> > Signed-off-by: Hannes Reinecke <hare@suse.de>
> 
> This looks correct, but opens up questions:

I'm not entirely convinced it is.  I think the correct value might be
SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP which is the same numeric value as
SAS_SATA_DEV.

STP is the SATA Tunnelling Protocol.  It's what you use to talk to an
expander with a directly attached SATA device on one of its ports.
SAS_PROTOCOL_SATA means talk directly to the device using SATA (not SAS
tunnelled SATA) and is only appropriate for a SATA device directly
attached to the SAS initiator.

This function is examining an expander phy, so the initiator will always
have to speak STP to it, regardless of what the actual value is.

James

>  - how did you find this?
>  - why didn't we notice earlier?
> 
> Also I wonder if we should move to more __bitwise types for these
> kinds of things..
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



