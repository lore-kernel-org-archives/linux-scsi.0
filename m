From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 06/15] lpfc: Fix NMI watchdog assertions when running
 nvmet IOPS tests
Date: Thu, 11 May 2017 08:21:09 +0200
Message-ID: <26548783-b861-a415-5d39-03d040a0b998@suse.de>
References: <20170510190713.30171-1-jsmart2021@gmail.com>
 <20170510190713.30171-7-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41851 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750917AbdEKGVM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 May 2017 02:21:12 -0400
In-Reply-To: <20170510190713.30171-7-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 05/10/2017 09:07 PM, James Smart wrote:
> After running IOPS test for 30 second we get
> kernel:NMI watchdog: Watchdog detected hard LOCKUP on cpu 0
> 
> The driver is speend too much time in it's ISR.
> 
> In ISR EQ and CQ processing routines, if we hit the entry_repost
> numbers of EQE/CQEs just break out of the routine as opposed to
> hitting the doorbell with NOARM and continue processing.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_debugfs.c | 30 +++++++++++++++---------------
>  drivers/scsi/lpfc/lpfc_sli.c     |  8 ++------
>  2 files changed, 17 insertions(+), 21 deletions(-)
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
