From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC 2/9] zfcp: decouple TMF response handler from scsi_cmnd
Date: Wed, 26 Jul 2017 07:52:12 +0200
Message-ID: <c5ba7c87-6633-b81d-46a5-e89aef532830@suse.de>
References: <20170725141427.35258-1-maier@linux.vnet.ibm.com>
 <20170725141427.35258-3-maier@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50060 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750768AbdGZFwP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Jul 2017 01:52:15 -0400
In-Reply-To: <20170725141427.35258-3-maier@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
Cc: linux-s390@vger.kernel.org, Benjamin Block <bblock@linux.vnet.ibm.com>

On 07/25/2017 04:14 PM, Steffen Maier wrote:
> Do not get scsi_device via req->data any more, but pass an optional(!)
> scsi_device to zfcp_fsf_fcp_handler_common(). The latter must now guard
> any access to scsi_device as it can be NULL.
> 
> Since we always have at least a zfcp port as scope, pass this as mandatory
> argument to zfcp_fsf_fcp_handler_common() because we cannot get it through
> scsi_device => zfcp_scsi_dev => port any more.
> 
> Hence, the callers of zfcp_fsf_fcp_handler_common() must resolve req->data.
> 
> TMF handling now has different context data in fsf_req->data
> depending on the TMF scope in fcp_cmnd->fc_tm_flags:
> * scsi_device if FCP_TMF_LUN_RESET,
> * zfcp_port if FCP_TMF_TGT_RESET.
> 
> Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
> ---
>  drivers/s390/scsi/zfcp_fsf.c | 72 ++++++++++++++++++++++++++++----------------
>  1 file changed, 46 insertions(+), 26 deletions(-)
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
