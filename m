From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] ibmvscsi driver - fourth version
Date: 11 Mar 2004 17:07:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1079042865.2820.88.camel@mulgrave>
References: <opr3u0ffo7l6e53g@us.ibm.com>
	<20040225134518.A4238@infradead.org>  <opr3xta6gbl6e53g@us.ibm.com>
	<1079027038.2820.57.camel@mulgrave>  <opr4pu5kazl6e53g@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:23425 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261772AbUCKWIZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Mar 2004 17:08:25 -0500
In-Reply-To: <opr4pu5kazl6e53g@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Dave Boutcher <sleddog@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-03-11 at 16:25, Dave Boutcher wrote:
> On 11 Mar 2004 12:43:57 -0500, James Bottomley 
> <James.Bottomley@steeleye.com> wrote:
> > dma_map_single() has no error return currently, what is this trying to
> > do?
> Well, actually in in arch/ppc64/pci_iommu.c it can return 0xFFFFFFFF 
> (actually, it returns NO_TCE, which is ((dma_addr_t)-1)).

Well, OK, put a fixme in there, since eventually there will be a
standard for dma_map_single errors, and it may not be -1.

> 
> > +
> > +	/* Block requests until we get the SRP login back */
> > +	scsi_block_requests(host);
> > +
> > +	if (!scsi_add_host(hostdata->host, hostdata->dev)) {
> > +
> > +		scsi_scan_host(host);
> > +		return hostdata;
> > +	}
> >
> > Er, have you actually tried this ... the block requests will block all
> > requests including the attempt to scan. I assume the unblock is coming
> > from the schedule_work, but you're still hanging the rest of the system
> > waiting for this on a bootup.
> 
> Yes, this works fine, but I don't like it.  The scenario is that until we 
> get the SRP_LOGIN response back from the adapter, we don't know what the 
> queue_limit is (can_queue).  If the mid-layer starts scanning and sending 
> SCSI cmnds, we have to hold them up until we get that response back.  I've 
> tried a number of approaches....originally I kicked off scsi_scan from the 
> bottom half that gets the SRP_LOGIN_RSP.  However:
> - The bottom half is executing in a work queue.  Calling scsi_scan() 
> causes more requests to be sent and responses returned, which would like 
> to execute in the bottom_half workqueue, except that the workqueue is busy 
> because it is executing scsi_scan().
> - I created a second workqueue just to handle scsi_scan(), but that was 
> getting byzantine and Christoph threw up on it.
> 
> The only other approach I have considered is not doing the 
> scsi_block_requests(), but waiting on a completion before issuing 
> scsi_scan() and posting the completion when the SRP_LOGIN_RSP is received.

I don't quite follow this.  SCSI uses a softirq in 2.6, so there are no
bottom half scheduling issues for us at all.

Hanging the boot sequence like this waiting for a login isn't
acceptable.

As I see it, the preferred option would be simply to trigger a scan of
the device from user land using the scsi_host class, so dispense with
the scsi_scan_host() altogether.

James


