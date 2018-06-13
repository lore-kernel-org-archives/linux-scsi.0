From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 3/3] scsi: don't add scsi command result bytes
Date: Wed, 13 Jun 2018 04:59:29 -0700
Message-ID: <20180613115929.GC12438@infradead.org>
References: <20180613075349.7509-1-jthumshirn@suse.de>
 <20180613075349.7509-4-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180613075349.7509-4-jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 13, 2018 at 09:53:49AM +0200, Johannes Thumshirn wrote:
> Some drivers are ADDing the scsi command's result bytes instead of
> ORing them.
> 
> While this can produce correct results it has unexpected side effects.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

> -			cmd->result = (DID_OK << 16) + (l & STATUS_MASK);
> +			cmd->result = DID_OK << 16 | (l & STATUS_MASK);

Although I would have keep the braces around the shift operators
to stick closer to the original code.  But the code should be fine
even without them.
