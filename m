From: Dave Boutcher <sleddog@us.ibm.com>
Subject: Re: [PATCH] ibmvscsi driver - fourth version
Date: Thu, 11 Mar 2004 15:25:58 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <opr4pu5kazl6e53g@us.ibm.com>
References: <opr3u0ffo7l6e53g@us.ibm.com> <20040225134518.A4238@infradead.org>  <opr3xta6gbl6e53g@us.ibm.com> <1079027038.2820.57.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:1784 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261738AbUCKV01 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Mar 2004 16:26:27 -0500
In-Reply-To: <1079027038.2820.57.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James,

Thanks for the comments, I'll send a revised patch.  On a couple of the 
issues...

On 11 Mar 2004 12:43:57 -0500, James Bottomley 
<James.Bottomley@steeleye.com> wrote:
> +static int map_single_data(struct scsi_cmnd *cmd,
> +			   struct SRP_CMD *srp_cmd, struct device *dev)
> +{
> [...]
> +	data->virtual_address =
> +	    (u64) (unsigned long)dma_map_single(dev, cmd->request_buffer,
> +						cmd->request_bufflen,
> +						DMA_BIDIRECTIONAL);
> +	if (data->virtual_address == 0xFFFFFFFF) {
> +		printk(KERN_ERR
> +		       "ibmvscsi: Unable to map request_buffer for command!\n");
>
> dma_map_single() has no error return currently, what is this trying to
> do?

Well, actually in in arch/ppc64/pci_iommu.c it can return 0xFFFFFFFF 
(actually, it returns NO_TCE, which is ((dma_addr_t)-1)).

> +
> +	/* Block requests until we get the SRP login back */
> +	scsi_block_requests(host);
> +
> +	if (!scsi_add_host(hostdata->host, hostdata->dev)) {
> +
> +		scsi_scan_host(host);
> +		return hostdata;
> +	}
>
> Er, have you actually tried this ... the block requests will block all
> requests including the attempt to scan. I assume the unblock is coming
> from the schedule_work, but you're still hanging the rest of the system
> waiting for this on a bootup.

Yes, this works fine, but I don't like it.  The scenario is that until we 
get the SRP_LOGIN response back from the adapter, we don't know what the 
queue_limit is (can_queue).  If the mid-layer starts scanning and sending 
SCSI cmnds, we have to hold them up until we get that response back.  I've 
tried a number of approaches....originally I kicked off scsi_scan from the 
bottom half that gets the SRP_LOGIN_RSP.  However:
- The bottom half is executing in a work queue.  Calling scsi_scan() 
causes more requests to be sent and responses returned, which would like 
to execute in the bottom_half workqueue, except that the workqueue is busy 
because it is executing scsi_scan().
- I created a second workqueue just to handle scsi_scan(), but that was 
getting byzantine and Christoph threw up on it.

The only other approach I have considered is not doing the 
scsi_block_requests(), but waiting on a completion before issuing 
scsi_scan() and posting the completion when the SRP_LOGIN_RSP is received.

Dave B
