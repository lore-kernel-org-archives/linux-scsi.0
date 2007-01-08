From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH 2/5] fusion: vmware bug fix prevent inifinite retries
Date: Mon, 08 Jan 2007 16:24:44 -0600
Message-ID: <1168295084.2824.38.camel@mulgrave.il.steeleye.com>
References: <664A4EBB07F29743873A87CF62C26D704E9054@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:37708 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964902AbXAHW2E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jan 2007 17:28:04 -0500
In-Reply-To: <664A4EBB07F29743873A87CF62C26D704E9054@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: manon@manon.de, azimman@vmware.com, linux-scsi@vger.kernel.org

On Mon, 2007-01-08 at 15:03 -0700, Moore, Eric wrote:
> In the 03.02.19, we add added the current logic for the following
> reason:
> 
> "When a target device responds with BUSY status, the MPT driver was
> sending DID_OK to the 
> SCSI mid layer, which caused the IO to be retried indefinitely between
> the mid layer and the 
> driver.  By changing the driver return status to DID_BUS_BUSY, the
> target BUSY status can 
> now flow through the mid layer to an upper layer Failover driver, which
> will manage the I/O timeout."

Right, I sort of suspected something like this.  BUSY/QUEUE_FULL
handling was a bit iffy in 2.4; but it was sorted out in the 2003/4
timeframe.  Nowadays, I think you want to translate the
MPI_SCSI_STATUS_BUSY directly to SAM_STAT_BUSY (i.e. just remove the
special casing if).

James


