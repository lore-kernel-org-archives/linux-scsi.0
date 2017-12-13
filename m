From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 5/9] lpfc: Fix SCSI LUN discovery when SCSI and NVME
 enabled
Date: Wed, 13 Dec 2017 15:47:57 +0100
Message-ID: <07995eba-c837-44c4-3e91-e7fc81a0b645@suse.de>
References: <20171209011811.23421-1-jsmart2021@gmail.com>
 <20171209011811.23421-6-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32951 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753248AbdLMOr7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Dec 2017 09:47:59 -0500
In-Reply-To: <20171209011811.23421-6-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 12/09/2017 02:18 AM, James Smart wrote:
> When enabled for both SCSI and NVME support, and connected pt2pt to a
> SCSI only target, the driver nodelist entry for the remote port is
> left in PRLI_ISSUE state and no SCSI LUNs are discovered. Works fine
> if only configured for SCSI support.
> 
> Error was due to some of the prli points still reflecting the need
> to send only 1 PRLI. On a lot of fabric configs, targets were NVME
> only, which meant the fabric-reported protocol attributes were only
> telling the driver one protocol or the other. Thus things worked
> fine. With pt2pt, the driver must send a PRLI for both protocols as
> there are no hints on what the target supports. Thus pt2pt targets
> were hitting the multiple PRLI issues.
> 
> Complete the dual PRLI support. Track explicitly whether scsi (fcp)
> or nvme prli's have been sent. Accurately track protocol support
> detected on each node as reported by the fabric or probed by PRLI
> traffic.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_ct.c        |  1 +
>  drivers/scsi/lpfc/lpfc_els.c       | 30 ++++++++++++++++++++----------
>  drivers/scsi/lpfc/lpfc_nportdisc.c | 30 +++++++++++++-----------------
>  3 files changed, 34 insertions(+), 27 deletions(-)
> Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
