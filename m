From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/9] lpfc: Fix random heartbeat timeouts during heavy IO
Date: Wed, 13 Dec 2017 12:33:03 +0100
Message-ID: <30c3b4cf-4860-61e1-ec56-c8897b2e82dd@suse.de>
References: <20171209011811.23421-1-jsmart2021@gmail.com>
 <20171209011811.23421-2-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44561 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752584AbdLMLdF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Dec 2017 06:33:05 -0500
In-Reply-To: <20171209011811.23421-2-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 12/09/2017 02:18 AM, James Smart wrote:
> NVME targets appear to randomly disconnect from the initiator
> when running heavy IO.
> 
> The error is due to the host aggregate (across all controllers)
> io load was beyond the maximum exchange count for nvme on the
> adapter. The driver was properly returning a resource busy status,
> but the io load was so great heartbeat commands would be bounced
> and not have a successful retry within the fuzz amount for the
> nvme heartbeat (yes, a very high io load!). Thus the target was
> terminating the controller due to a keep alive failure.
> 
> Resolve by reserving a few exchanges (by counters) which can be
> used when the adapter is out of normal exchanges and the command
> is a NVME heartbeat command. As counters are used, while the
> reserved command is outstanding, as soon as any other exchange
> completes, the counters are adjusted and the reserved count is
> replenished. The heartbeat completes execution in a normal fashion.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc.h      |  2 ++
>  drivers/scsi/lpfc/lpfc_init.c | 16 ++++++++++-
>  drivers/scsi/lpfc/lpfc_nvme.c | 66 +++++++++++++++++++++++++++++--------------
>  drivers/scsi/lpfc/lpfc_nvme.h |  1 +
>  4 files changed, 63 insertions(+), 22 deletions(-)
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
