From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 05/15] lpfc: Fix NVMEI driver not decrementing counter
 causing bad rport state.
Date: Thu, 11 May 2017 08:18:58 +0200
Message-ID: <f7328a57-bd4d-37cb-ba76-0e028198fbb9@suse.de>
References: <20170510190713.30171-1-jsmart2021@gmail.com>
 <20170510190713.30171-6-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41691 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751028AbdEKGTA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 May 2017 02:19:00 -0400
In-Reply-To: <20170510190713.30171-6-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 05/10/2017 09:07 PM, James Smart wrote:
> During driver boot, a latency in the NVMET driver
> side causes the incoming NVMEI PRLI to get rejected by the
> NVMET driver.  When this happens, the NVMEI driver runs
> out of PRLI retries.  Bouncing the link does not fix the
> situation.
> 
> If the NVMEI driver decides, on PRLI completion
> failures, to retry the PRLI, always decrement the
> fc4_prli_sent counter.  This allows the PRLI completion
> to resolve to UNMAPPED when NVMET rejects the PRLI.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_els.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
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
