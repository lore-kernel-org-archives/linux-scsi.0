From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] sd: WRITE SAME(16) / UNMAP support
Date: Fri, 30 Oct 2009 01:11:20 -0400
Message-ID: <20091030051120.GE17714@infradead.org>
References: <1256873409-12668-1-git-send-email-martin.petersen@oracle.com> <1256873409-12668-3-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53855 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010AbZJ3FLS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2009 01:11:18 -0400
Content-Disposition: inline
In-Reply-To: <1256873409-12668-3-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: hch@infradead.org, axboe@kernel.dk, matthew@wil.cx, linux-scsi@vger.kernel.org

On Thu, Oct 29, 2009 at 11:30:09PM -0400, Martin K. Petersen wrote:
> +sd_show_thin_provisioning(struct device *dev, struct device_attribute *attr,
> +			  char *buf)
> +{
> +	struct scsi_disk *sdkp = to_scsi_disk(dev);
> +
> +	return snprintf(buf, 20, "%u\n", sdkp->thin_provisioning);
> +}

If we want to expose this we'd better do it at the block layer so that
it also coverts non-scsi dicard support.  Besides the mtd one already in
tree I also plan to add a discard command to virtio-blk.

