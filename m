From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: New TRIM/UNMAP tree published (2009-05-02)
Date: Sun, 03 May 2009 14:04:32 -0500
Message-ID: <1241377472.5596.88.camel@mulgrave.int.hansenpartnership.com>
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com>
	 <49D8A3D7.5070507@panasas.com> <20090503061150.GF10704@linux.intel.com>
	 <20090503071619.GP8822@parisc-linux.org>
	 <Pine.LNX.4.64.0905031346350.29671@blonde.anvils>
	 <20090503144847.GR8822@parisc-linux.org> <49FDB21B.3080301@panasas.com>
	 <20090503154216.GU8822@parisc-linux.org> <49FDC786.6070309@panasas.com>
	 <49FDE3BB.505@garzik.org>  <49FDE50A.4060503@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55142 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752183AbZECTEd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 May 2009 15:04:33 -0400
In-Reply-To: <49FDE50A.4060503@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Jens Axboe <jens.axboe@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, Hugh Dickins <hugh@veritas.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Mark Lord <lkml@rtr.ca>

On Sun, 2009-05-03 at 14:40 -0400, Jeff Garzik wrote:
> Jeff Garzik wrote:
> > (2) determine at init if queue (a) supports explicit DISCARD and/or (b) 
> > supports DISCARD flag passed with READ or WRITE
> 
> 
> As an aside -- does any existing command set support case #b, above?

Not to my knowledge.

I think discard was modelled on barrier (which can be associated with
data or stand on its own).

> AFAICT, ATA, SCSI and NVMHCI all have a single, explicit hardware 
> command to discard/deallocate unused sectors.
> 
> Therefore, creating REQ_TYPE_DISCARD seems to eliminate any need for new 
> hook ->prepare_discard().

Well, yes and no ... in the SCSI implementation of either UNMAP or WRITE
SAME, we still need a data buffer to store either the extents or the
actual same data.

> This provides a 1:1 correspondence between hardware and struct request, 
> most closely matching the setup of known hardware.

Agreed ... but we still have to allocate the adjunct buffer
somewhere ....

James


