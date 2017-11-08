From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/17] lpfc: Handle XRI_ABORTED_CQE in soft IRQ
Date: Wed, 8 Nov 2017 10:09:36 +0100
Message-ID: <bc031f26-3a77-ebea-d9c3-597ff84335d6@suse.de>
References: <20171103225628.24716-1-jsmart2021@gmail.com>
 <20171103225628.24716-4-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55605 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751821AbdKHJJh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Nov 2017 04:09:37 -0500
In-Reply-To: <20171103225628.24716-4-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 11/03/2017 11:56 PM, James Smart wrote:
> XRI_ABORTED_CQE completions were not being handled in the fast path.
> They were being queued and deferred to the lpfc worker thread
> for processing. This is an artifact of the driver design prior
> to moving queue processing out of the isr and into a workq
> element. Now that queue processing is already in a deferred context,
> remove this artifact and process them directly.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc.h         |  1 -
>  drivers/scsi/lpfc/lpfc_hbadisc.c |  2 -
>  drivers/scsi/lpfc/lpfc_init.c    |  8 ----
>  drivers/scsi/lpfc/lpfc_sli.c     | 97 +++++++++++++++-------------------------
>  drivers/scsi/lpfc/lpfc_sli4.h    |  2 -
>  5 files changed, 35 insertions(+), 75 deletions(-)
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
