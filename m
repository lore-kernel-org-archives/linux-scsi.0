From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] libata: rewrite SCSI host scheme to be one per ATA host
Date: Thu, 23 Apr 2009 08:35:42 +0200
Message-ID: <20090423063542.GK4593@kernel.dk>
References: <20090422090929.GA14928@havoc.gtf.org> <49EEE225.3010700@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49EEE225.3010700@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 22 2009, Jeff Garzik wrote:
> Jeff Garzik wrote:
>> Currently, libata creates a Scsi_Host per port.  This was originally
>> done to leverage SCSI's infrastructure to arbitrate among master/slave
>> devices, but is not needed for most modern SATA controllers.   And I
>> _think_ it is not needed for master/slave if done properly, either.
>
> BTW note the above, with regards to the libata SCSI->block conversion.  
> libata currently relies on SCSI for some amount of generic device  
> arbitration, in several situations (see ->qc_defer,  
> SCSI_MLQUEUE_.*_BUSY).  libata expects SCSI to be intelligent and not  
> starve devices, etc.

Defer looks like internal policy, I don't see that functioning any
different in the block layer. SCSI_MLQUEUE_*_BUSY in SCSI is primarily
using the block layer functionality of BLKPREP_DEFER to begin with, so I
think we're pretty close to providing all that already.

-- 
Jens Axboe

