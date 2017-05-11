From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 12/15] lpfc: Cleanup entry_repost settings on SLI4 queues
Date: Thu, 11 May 2017 09:49:52 +0200
Message-ID: <1f3ad2eb-4db8-5181-02d9-cde8d43e952c@suse.de>
References: <20170510190713.30171-1-jsmart2021@gmail.com>
 <20170510190713.30171-13-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47310 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755146AbdEKHt5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 May 2017 03:49:57 -0400
In-Reply-To: <20170510190713.30171-13-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 05/10/2017 09:07 PM, James Smart wrote:
> Too many work items being processed in IRQ context take a lot
> of CPU time and cause problems.
> 
> With a recent change, we get out of the ISR after hitting entry_repost
> work items on a queue. However, the actual values for entry repost are
> still high. EQ is 128 and CQ is 128, this could translate into
> processing 128 * 128 (16384) work items under IRQ context.
> 
> Set entry_repost in the actual queue creation routine now.
> Limit EQ repost to 8 and CQ repost to 64 to further limit the amount
> of time spent in the IRQ.
> 
> Fix fof IRQ routines as well.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_init.c |  3 --
>  drivers/scsi/lpfc/lpfc_sli.c  | 64 +++++++++++--------------------------------
>  drivers/scsi/lpfc/lpfc_sli4.h |  8 ++++--
>  3 files changed, 21 insertions(+), 54 deletions(-)
> 
If this is a fix to a previous patch (Patch 6/15 ?), please merge it
with that.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
