From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH 4/5] nvme: move the retries count to struct nvme_request
Date: Wed, 5 Apr 2017 11:14:30 -0400
Message-ID: <20170405151430.GS20181@localhost.localdomain>
References: <20170405141856.1862-1-hch@lst.de>
 <20170405141856.1862-5-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170405141856.1862-5-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 05, 2017 at 04:18:55PM +0200, Christoph Hellwig wrote:
> The way NVMe uses this field is entirely different from the older
> SCSI/BLOCK_PC usage, so move it into struct nvme_request.
> 
> Also reduce the size of the file to a unsigned char so that we leave space
> for additional smaller fields that will appear soon.

What new fields can we expect? Why temporarily pad the middle of the
struct instead of appending to the end? The "result" packed nicely
on 64-bit, at least.

>  struct nvme_request {
>  	struct nvme_command	*cmd;
> +	u8			retries;
>  	union nvme_result	result;
>  };
