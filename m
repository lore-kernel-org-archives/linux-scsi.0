From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 2/5] fusion: vmware bug fix prevent inifinite retries
Date: Mon, 8 Jan 2007 18:37:36 -0700
Message-ID: <664A4EBB07F29743873A87CF62C26D704E90F8@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:34444 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbXAIBhs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jan 2007 20:37:48 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: manon@manon.de, azimman@vmware.com, linux-scsi@vger.kernel.org, "Shirron, Stephen" <Stephen.Shirron@lsi.com>, Michael Reed <mdr@sgi.com>

On  Monday, January 08, 2007 3:25 PM, James Bottomley wrote:

> Right, I sort of suspected something like this.  BUSY/QUEUE_FULL
> handling was a bit iffy in 2.4; but it was sorted out in the 2003/4
> timeframe.  Nowadays, I think you want to translate the
> MPI_SCSI_STATUS_BUSY directly to SAM_STAT_BUSY (i.e. just remove the
> special casing if).
> 

I think your'e on the same page with the folks from VMware,
where the've asked us to go back to our old driver code.
Meaning we kill the check for "MPI_SCSI_STATUS_BUSY", instead the sam
status
is sent back "as is" without changing the DID_OK to DID_BUS_BUSY, etc. 

My problem with that is whether is breaks the Fibre Channel Folks. 
Will FC failover solution work properly if we go back to the old code?
I add Stephen Shirron and Mike Reed. 
I don't know.   Here is an explanation why that fix was needed back
about a year ago:


"When a target device responds with BUSY status, the MPT driver was
sending DID_OK to the 
SCSI mid layer, which caused the IO to be retried indefinitely between
the mid layer and the 
driver.  By changing the driver return status to DID_BUS_BUSY, the
target BUSY status can 
now flow through the mid layer to an upper layer Failover driver, which
will manage the I/O timeout."

