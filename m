From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v4 0/5] Target sense data handling modifications
Date: Thu, 23 Jul 2015 22:16:04 -0700
Message-ID: <1437714964.8929.5.camel@haakon3.risingtidesystems.com>
References: <1436367534-15995-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1436367534-15995-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

Hi Sagi & Co,

Apologies for the extended delayed follow-up on this series..

Applied to target-pending/for-next, including the scsi_error.c
-> scsi_common.c conversion in patch #4.

Thanks folks!

On Wed, 2015-07-08 at 17:58 +0300, Sagi Grimberg wrote:
> This patch set modifies the target sense data handling.
> First, cleanup transport_send_check_condition_and_sense()
> by splitting the sense translation to a separate function.
> Second, convert sense reason the switch statement to a table
> driven code. Third, Use scsi common helpers to correctly set
> the sense buffer. Last, Fix sense key wrong setting of t10-pi
> errors.
> 
> Changes from v2:
> - Removed wrong patch 5/5 for descriptor format sense data
> - Added a patch (5/5) that fixes wrong sense key for PI errors
> - Incorporate hch's comments
> - Added Reviewed-by tags
> 
> Changes from v2:
> - Pass sense_reason_t to scsi_translate_sense()
> - Split patch 3:
>   1) move the helpers to scsi_common.c
>   2) use helpers in the target code
>   3) always use descriptor-type sense data for PI errors
> 
> Changes from v1:
> - Added Reviewed-by tags for patches 1,2
> - Fixed compilation error after testing patch #3 on scsi/for-next
>   branch. Moved scsi_sense_desc_find() to scsi_common as well (dependency)
>   and also moved <asm/unaligned.h> include to scsi_common.h
> 
> Changes from v0:
> - Added Bart's patches and converted my patch to apply over his
> - Moved scsi sense helpers to scsi_common
> 
> Bart Van Assche (2):
>   target: Inline transport_get_sense_codes()
>   target: Split transport_send_check_condition_and_sense()
> 
> Sagi Grimberg (3):
>   scsi: Move sense handling routines to scsi_common
>   target: Use scsi helpers to build the sense data correctly
>   target: Return ABORTED_COMMAND sense key for PI errors
> 
>  drivers/scsi/scsi_common.c             |  98 ++++++++
>  drivers/scsi/scsi_error.c              |  99 +--------
>  drivers/target/target_core_spc.c       |  31 +--
>  drivers/target/target_core_transport.c | 396 ++++++++++++---------------------
>  include/scsi/scsi_common.h             |   5 +
>  include/scsi/scsi_eh.h                 |   7 +-
>  6 files changed, 252 insertions(+), 384 deletions(-)
> 
