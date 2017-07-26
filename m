From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC 1/9] zfcp: drop unsuitable scsi_cmnd usage from SCSI traces
 for scsi_eh / TMF
Date: Wed, 26 Jul 2017 07:50:10 +0200
Message-ID: <2abd0ddc-3562-aef9-b63d-b5070dca38df@suse.de>
References: <20170725141427.35258-1-maier@linux.vnet.ibm.com>
 <20170725141427.35258-2-maier@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49684 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750747AbdGZFuM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Jul 2017 01:50:12 -0400
In-Reply-To: <20170725141427.35258-2-maier@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
Cc: linux-s390@vger.kernel.org, Benjamin Block <bblock@linux.vnet.ibm.com>

On 07/25/2017 04:14 PM, Steffen Maier wrote:
> The SCSI command pointer passed to scsi_eh callbacks is just one arbitrary
> command of potentially many that are in the eh queue to be processed.
> The command is only used to indirectly pass the TMF scope in terms of
> SCSI ID/target and SCSI LUN for LUN reset.
> 
> Hence, zfcp had filled in SCSI trace record fields which do not really
> belong to the TMF. This was confusing.
> 
> Therefore, refactor the TMF tracing to work without SCSI command
> and instead pass explicit arguments for SCSI ID and SCSI LUN.
> As context we now need a pointer to zfcp_adapter.
> To make it even clearer, we set all bits to 1 for the fields, which do
> not belong to the TMF, to indicate that these fields are invalid.
> 
> The old zfcp_dbf_scsi() became zfcp_dbf_scsi_common() to now handle both
> SCSI commands and TMFs. The old argument scsi_cmnd is now optional and
> can be NULL with TMFs. Two new arguments scsi_id and scsi_lun are
> optional and only used if scsi_cmnd is NULL, i.e. with TMFs.
> 
> Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
> ---
>  drivers/s390/scsi/zfcp_dbf.c  | 51 ++++++++++++++++++++++++++++---------------
>  drivers/s390/scsi/zfcp_dbf.h  | 26 +++++++++++++++-------
>  drivers/s390/scsi/zfcp_ext.h  |  8 ++++---
>  drivers/s390/scsi/zfcp_scsi.c | 20 ++++++++++++-----
>  4 files changed, 71 insertions(+), 34 deletions(-)
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
