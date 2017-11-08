From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 02/17] lpfc: Expand WQE capability of every NVME hardware
 queue
Date: Wed, 8 Nov 2017 10:08:08 +0100
Message-ID: <b8713ef3-547f-2f2b-e90a-fe5ecbeeb4f8@suse.de>
References: <20171103225628.24716-1-jsmart2021@gmail.com>
 <20171103225628.24716-3-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55463 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751571AbdKHJIK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Nov 2017 04:08:10 -0500
In-Reply-To: <20171103225628.24716-3-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 11/03/2017 11:56 PM, James Smart wrote:
> Hardware queues are a fast staging area to push commands into the adapter.
> The adapter should drain them extremely quickly. However, under heavy
> io load, the host cpu is pushing commands faster than the drain rate of
> the adapter causing the driver to resource busy commands.
> 
> Enlarge the hardware queue (wq & cq) to support a larger number of
> queue entries (4x the prior size) before backpressure. Enlarging
> the queue requires larger contiguous buffers (16k) per logical page
> for the hardware. This changed calling sequences that were expecting
> 4K page sizes that now must pass a parameter with the page sizes. It
> also required use of a new version of an adapter command that can vary
> the page size values.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_hw4.h  |  6 +++-
>  drivers/scsi/lpfc/lpfc_init.c | 67 ++++++++++++++++++++++++++--------------
>  drivers/scsi/lpfc/lpfc_nvme.h |  3 +-
>  drivers/scsi/lpfc/lpfc_sli.c  | 71 +++++++++++++++++++++++++++++++++----------
>  drivers/scsi/lpfc/lpfc_sli4.h |  8 +++--
>  5 files changed, 112 insertions(+), 43 deletions(-)
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
