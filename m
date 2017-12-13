From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/9] lpfc: Fix -EOVERFLOW behavior for NVMET and defer_rcv
Date: Wed, 13 Dec 2017 15:41:13 +0100
Message-ID: <0835afc0-c29f-c7eb-fff0-b4b53786ffc1@suse.de>
References: <20171209011811.23421-1-jsmart2021@gmail.com>
 <20171209011811.23421-3-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60579 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752749AbdLMOlP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Dec 2017 09:41:15 -0500
In-Reply-To: <20171209011811.23421-3-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 12/09/2017 02:18 AM, James Smart wrote:
> The driver is all set to handle the defer_rcv api for the
> nvmet_fc transport, yet didn't properly recognize the return
> status when the defer_rcv occurred. The driver treated it simply
> as an error and aborted the io. Several residual issues occurred
> at that point.
> 
> Finish the defer_rcv support: recognize the return status when
> the io request is being handled in a deferred style. This stops
> the rogue aborts; Replenish the async cmd rcv buffer in the
> deferred receive if needed.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_nvmet.c | 24 ++++++++++++++++++++++--
>  drivers/scsi/lpfc/lpfc_nvmet.h |  1 +
>  drivers/scsi/lpfc/lpfc_sli.c   | 24 +++++++++++++-----------
>  3 files changed, 36 insertions(+), 13 deletions(-)
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
