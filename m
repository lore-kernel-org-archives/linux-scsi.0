From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [RFC PATCH 0/4] libfc: Do not send ABTS when resetting
 exchanges
Date: Thu, 18 Aug 2016 10:38:13 -0400
Message-ID: <alpine.OSX.2.00.1608181036200.529@administrators-macbook-pro.local>
References: <1470401703-87045-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0119.outbound.protection.outlook.com ([104.47.36.119]:52544
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753696AbcHSBA5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Aug 2016 21:00:57 -0400
In-Reply-To: <1470401703-87045-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, chad.dupuis@qlogic.com


On Fri, 5 Aug 2016, 12:54pm -0000, Hannes Reinecke wrote:

> Hi all,
> 
> here's a patchset to fixup an issue reported by QLogic: when running
> against a certain target the libfc stack would get in an infinite loop
> sending ABTS when trying to reset a connection.
> The problem is that the libfc stack is sending ABTS for any open exchanges
> when removing an rport, totally ignorant of the fact that in most cases
> we are already logged out of the said remote port.
> This patchset alters the handling slightly so that we will only ever reset
> open exchanges after we have either logged out of the port or an implicit
> logout can be assumed.
> With that we don't need to send ABTS any more during rport reset.
> 
> As usual, comments and reviews are welcome.
> 
> Hannes Reinecke (4):
>   libfc: Issue PRLI after a PRLO has been received
>   libfc: send LOGO for PLOGI failure
>   libfc: reset exchange manager during LOGO handling
>   libfc: do not send ABTS when resetting exchanges
> 
>  drivers/scsi/libfc/fc_exch.c  |  1 -
>  drivers/scsi/libfc/fc_rport.c | 26 +++++++++++++++++++++++---
>  2 files changed, 23 insertions(+), 4 deletions(-)
> 
> 

Hannes, thanks for posting this.  I've been working witih a customer of 
ours and have successfully tested this patch set.

Reviewed-by: Chad Dupuis <chad.dupuis@qlogic.com>
Tested-by: Chad Dupuis <chad.dupuis@qlogic.com>
