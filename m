From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 13/17] lpfc: Correct driver deregistrations with host
 nvme transport
Date: Tue, 21 Nov 2017 09:13:53 +0100
Message-ID: <5ca245e5-0399-adb0-2003-920344b3adc2@suse.de>
References: <20171121000044.27702-1-jsmart2021@gmail.com>
 <20171121000044.27702-14-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38522 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751154AbdKUINy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Nov 2017 03:13:54 -0500
In-Reply-To: <20171121000044.27702-14-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 11/21/2017 01:00 AM, James Smart wrote:
> The driver's interaction with the host nvme transport has been
> incorrect for a while. The driver did not wait for the unregister
> callbacks (waited only 5 jiffies). Thus the driver may remove
> objects that may be referenced by subsequent abort commands from
> the transport, and the actual unregister callback was effectively
> a noop. This was especially problematic if the driver was unloaded.
> 
> The driver now waits for the unregister callbacks, as it should,
> before continuing with teardown.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> 
> ---
> v3:
>   per review: clear NLP_WAIT_FOR_UNREG in all cases
> ---
>  drivers/scsi/lpfc/lpfc_disc.h |   2 +
>  drivers/scsi/lpfc/lpfc_nvme.c | 116 +++++++++++++++++++++++++++++++++++++++---
>  drivers/scsi/lpfc/lpfc_nvme.h |   2 +
>  3 files changed, 114 insertions(+), 6 deletions(-)
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
