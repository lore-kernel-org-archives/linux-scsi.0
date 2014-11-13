From: Christoph Hellwig <hch@infradead.org>
Subject: Re: mpt2sas,mpt3sas: SATA affiliations
Date: Thu, 13 Nov 2014 06:26:24 -0800
Message-ID: <20141113142624.GA29354@infradead.org>
References: <5463BC0F.4050605@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33602 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932910AbaKMO0Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Nov 2014 09:26:25 -0500
Content-Disposition: inline
In-Reply-To: <5463BC0F.4050605@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>

[adding the mpt maintainers as this seems to be a driver and not
midlayer issue]

On Wed, Nov 12, 2014 at 02:59:11PM -0500, Douglas Gilbert wrote:
> From a correspondent and my own testing I have seen way
> too many of these messages in the log:
>    log_info(0x31160000): originator(PL), code(0x16), sub_code(0x0000)
> 
> That comes from either the mpt2sas or mpt3sas driver and may be
> a problem with their interaction with the SCSI EH. In one case,
> those messages go on forever, requiring a reboot; in my testing
> (with sg_readcap) the command timeout (60 seconds) stopped them.
> 
> 
> How they occur needs a bit of explaining: ATA disks are designed
> to have only only initiator (host). So if you build a SAS fabric
> including at least two initiators, an expander and one SATA disk,
> then there is potentially a problem which SAS expanders address
> with "affiliations". An affiliation is a mechanism for the
> expander to remember the SAS address of the initiator (host)
> that first "grabbed" the SATA disk, and rejecting any other
> initiator that tries to access that SATA disk.
> 
> That rejection, in the link layer in SAS for the STP protocol,
> is a OPEN_REJECT (STP RESOURCES BUSY) response. That is *not*
> a retry-able error (so the use of "busy" is unfortunate).
> FreeBSD handles this correctly, Linux in some cases retries
> which results in chaos plus bloated logs.
> 
> There are mechanisms for the owner of the affiliation to clear
> it so another initiator can claim it. However affiliations are
> designed to thwart brute force attempts by non-owners. At best
> non-owners should get one log message along the lines of:
>   cannot access SATA disk xxxx since another machine/HBA is
>   affiliated with it
> 
> Linux properly handles SATA affiliations when it comes across
> them in normal device discovery. It is the "surprise"
> disappearance of an affiliation that causes instability. That
> surprise is caused by a utility like smp_phy_control telling
> the expander to clear the affiliation and doing a rescan on
> the other machine to claim the affiliation.
> 
> Doug Gilbert
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
