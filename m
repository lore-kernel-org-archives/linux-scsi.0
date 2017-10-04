From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 9/9] bsg: split handling of SCSI CDBs vs transport
 requeues
Date: Wed, 4 Oct 2017 08:26:36 +0200
Message-ID: <0f42d858-57a0-a499-eb56-6d1b8bd46218@suse.de>
References: <20171003104845.10417-1-hch@lst.de>
 <20171003104845.10417-10-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171003104845.10417-10-hch@lst.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 10/03/2017 12:48 PM, Christoph Hellwig wrote:
> The current BSG design tries to shoe-horn the transport-specific passthrough
> commands into the overall framework for SCSI passthrough requests.  This
> has a couple problems:
> 
>  - each passthrough queue has to set the QUEUE_FLAG_SCSI_PASSTHROUGH flag
>    despite not dealing with SCSI commands at all.  Because of that these
>    queues could also incorrectly accept SCSI commands from in-kernel
>    users or through the legacy SCSI_IOCTL_SEND_COMMAND ioctl.
>  - the real SCSI bsg queues also incorrectly accept bsg requests of the
>    BSG_SUB_PROTOCOL_SCSI_TRANSPORT type
>  - the bsg transport code is almost unredable because it tries to reuse
>    different SCSI concepts for its own purpose.
> 
> This patch instead adds a new bsg_ops structure to handle the two cases
> differently, and thus solves all of the above problems.  Another side
> effect is that the bsg-lib queues also don't need to embedd a
> struct scsi_request anymore.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/bsg-lib.c                   | 158 +++++++++++++++--------
>  block/bsg.c                       | 257 +++++++++++++++++---------------------
>  drivers/scsi/scsi_lib.c           |   4 +-
>  drivers/scsi/scsi_sysfs.c         |   3 +-
>  drivers/scsi/scsi_transport_sas.c |   1 -
>  include/linux/bsg-lib.h           |   4 +-
>  include/linux/bsg.h               |  35 ++++--
>  7 files changed, 251 insertions(+), 211 deletions(-)
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
