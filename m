From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/31] Avoid that scsi_exit_rq() triggers a use-after-free
Date: Wed, 24 May 2017 07:58:51 +0200
Message-ID: <cd37eb82-f85a-afca-c027-2fd1675bdb4c@suse.de>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
 <20170524003420.5381-11-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170524003420.5381-11-bart.vanassche@sandisk.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Scott Bauer <scott.bauer@intel.com>, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, Hannes Reinecke <hare@suse.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/24/2017 02:33 AM, Bart Van Assche wrote:
> Dereferencing shost from scsi_exit_rq() is not safe because the
> SCSI host may already have been freed when scsi_exit_rq() is
> called. Increasing the shost reference count in scsi_init_rq()
> and dropping that reference in scsi_exit_rq() is nontrivial since
> scsi_host_dev_release() may sleep and since scsi_exit_rq() may
> be called from interrupt context. Since scsi_exit_rq() only needs
> a single bit from shost, copy that bit into struct scsi_cmnd.
> 
> Reported-by: Scott Bauer <scott.bauer@intel.com>
> Fixes: e9c787e65c0c ("scsi: allocate scsi_cmnd structures as part of struct request")
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Scott Bauer <scott.bauer@intel.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/scsi/scsi_lib.c  | 43 +++++++++++++++++++++++++------------------
>  include/scsi/scsi_cmnd.h |  1 +
>  2 files changed, 26 insertions(+), 18 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
