From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH 2/5] fusion: vmware bug fix prevent inifinite retries
Date: Tue, 09 Jan 2007 10:17:17 -0600
Message-ID: <45A3C00D.2030707@sgi.com>
References: <664A4EBB07F29743873A87CF62C26D704E90F8@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:38624 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932191AbXAIQRg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Jan 2007 11:17:36 -0500
In-Reply-To: <664A4EBB07F29743873A87CF62C26D704E90F8@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, manon@manon.de, azimman@vmware.com, linux-scsi@vger.kernel.org, "Shirron, Stephen" <Stephen.Shirron@lsi.com>



Moore, Eric wrote:
> On  Monday, January 08, 2007 3:25 PM, James Bottomley wrote:
> 
>> Right, I sort of suspected something like this.  BUSY/QUEUE_FULL
>> handling was a bit iffy in 2.4; but it was sorted out in the 2003/4
>> timeframe.  Nowadays, I think you want to translate the
>> MPI_SCSI_STATUS_BUSY directly to SAM_STAT_BUSY (i.e. just remove the
>> special casing if).

Christoph put in code to limit a command's lifetime to prevent infinite
loops in the case of QUEUE_FULL and BUSY.  (See scsi_softirq_done()
for implementation.)

DID_OK / COMMAND_COMPLETE / BUSY results in a ADD_TO_MLQUEUE for a retry,
same as QUEUE_FULL.  I don't infinite retries, just a whole lot of them.
See scsi_decide_disposition().

Mike

>>
> 
> I think your'e on the same page with the folks from VMware,
> where the've asked us to go back to our old driver code.
> Meaning we kill the check for "MPI_SCSI_STATUS_BUSY", instead the sam
> status
> is sent back "as is" without changing the DID_OK to DID_BUS_BUSY, etc. 
> 
> My problem with that is whether is breaks the Fibre Channel Folks. 
> Will FC failover solution work properly if we go back to the old code?
> I add Stephen Shirron and Mike Reed. 
> I don't know.   Here is an explanation why that fix was needed back
> about a year ago:
> 
> 
> "When a target device responds with BUSY status, the MPT driver was
> sending DID_OK to the 
> SCSI mid layer, which caused the IO to be retried indefinitely between
> the mid layer and the 
> driver.  By changing the driver return status to DID_BUS_BUSY, the
> target BUSY status can 
> now flow through the mid layer to an upper layer Failover driver, which
> will manage the I/O timeout."
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
