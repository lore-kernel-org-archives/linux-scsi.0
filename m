From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 6/9] lpfc: Fix issues connecting with nvme initiator
Date: Wed, 13 Dec 2017 15:50:02 +0100
Message-ID: <99033e2b-b1ce-78c3-bd96-f36df7b3605d@suse.de>
References: <20171209011811.23421-1-jsmart2021@gmail.com>
 <20171209011811.23421-7-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33133 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753301AbdLMOuE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Dec 2017 09:50:04 -0500
In-Reply-To: <20171209011811.23421-7-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 12/09/2017 02:18 AM, James Smart wrote:
> In the lpfc discovery engine, when as a nvme target, where the
> driver was performing mailbox io with the adapter for port login
> when a NVME PRLI is received from the host. Rather than queue and
> eventually get back to sending a response after the mailbox traffic,
> the driver rejected the io with an error response.
> 
> Turns out this particular initiator didn't like the rejection values
> (unable to process command/command in progress) so it never attempted
> a retry of the PRLI. Thus the host never established nvme connectivity
> with the lpfc target.
> 
> By changing the rejection values (to Logical Busy/nothing more), the
> initiator accepted the response and would retry the PRLI, resulting in
> nvme connectivity.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_nportdisc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
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
