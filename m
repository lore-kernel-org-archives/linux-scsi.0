From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 04/25] nvme: split nvme status from block req->errors
Date: Thu, 6 Apr 2017 20:47:32 +0200
Message-ID: <20170406184730.GB8673@linux-x5ow.site>
References: <20170406153944.10058-1-hch@lst.de>
 <20170406153944.10058-5-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50433 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754404AbdDFSrj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 6 Apr 2017 14:47:39 -0400
Content-Disposition: inline
In-Reply-To: <20170406153944.10058-5-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com

On Thu, Apr 06, 2017 at 05:39:23PM +0200, Christoph Hellwig wrote:
> We want our own clearly defined error field for NVMe passthrough commands,
> and the request errors field is going away in its current form.
> 
> Just store the status and result field in the nvme_request field from
> hardirq completion context (using a new helper) and then generate a
> Linux errno for the block layer only when we actually need it.
> 
> Because we can't overload the status value with a negative error code
> for cancelled command we now have a flags filed in struct nvme_request
> that contains a bit for this condition.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
