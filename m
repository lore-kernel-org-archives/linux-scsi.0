From: Christoph Hellwig <hch@infradead.org>
Subject: Re: RFC: move hosts.h, scsi.h
Date: Thu, 22 May 2003 21:45:56 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030522214555.A13150@infradead.org>
References: <3ECD346D.2070302@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.mvhi.com ([195.224.96.167]:43278 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263274AbTEVV3w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 May 2003 17:29:52 -0400
Content-Disposition: inline
In-Reply-To: <3ECD346D.2070302@pobox.com>; from jgarzik@pobox.com on Thu, May 22, 2003 at 04:34:53PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, May 22, 2003 at 04:34:53PM -0400, Jeff Garzik wrote:
> I request permission to do the following:
> 
> 1) bk mv drivers/scsi/scsi.h include/linux
> 2) bk mv drivers/scsi/hosts.h include/linux/scsi_hosts.h
> 3) bk mv drivers/scsi/scsi_obsolete.h include/linux
> 4) create shell drivers/scsi/{...}.h that includes just-moved files, so 
> to preserve full driver source compatibility.
> 5) edit include/linux/scsi.h to include <linux/scsi_obsolete.h> not 
> "scsi_obsolete.h"
> 
> Objections/comments?

It's not that easy.  The current host.h/scsi.h split is silly we either want
to merge them or better split them saner (and into more pieces).  The current
scsi_obsolete.h should go away completly, it may make a driver compile but
not work (missing EH).  OTOH all those ugly typedefs should move into a 'new'
onbsolete.h.  Also all this should go into include/scsi/

