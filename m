From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 17/19] lpfc: Fix nonrecovery of NVME controller after
 cable swap.
Date: Mon, 29 Jan 2018 09:34:42 +0100
Message-ID: <e226ee98-b233-2521-bf7f-a1a88f74eab5@suse.de>
References: <20180124224548.9530-1-jsmart2021@gmail.com>
 <20180124224548.9530-18-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45434 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750913AbeA2Jng (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jan 2018 04:43:36 -0500
In-Reply-To: <20180124224548.9530-18-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 01/24/2018 11:45 PM, James Smart wrote:
> In a test that is doing large numbers of cable swaps on the target,
> the nvme controllers wouldn't reconnect.
> 
> During the cable swaps, the targets n_port_id would change. This
> information was passed to the nvme-fc transport, in the new remoteport
> registration. However, the nvme-fc transport didn't update the n_port_id
> value in the remoteport struct when it reused an existing structure.
> Later, when a new association was attempted on the remoteport, the
> driver's NVME LS routine would use the stale n_port_id from the remoteport
> struct to address the LS. As the device is no longer at that address,
> the LS would go into never never land.
> 
> Separately, the nvme-fc transport will be corrected to update the
> n_port_id value on a re-registration.
> 
> However, for now, there's no reason to use the transports values.
> The private pointer points to the drivers node structure and the
> node structure is up to date. Therefore, revise the LS routine to
> use the drivers data structures for the LS. Augmented the debug
> message for better debugging in the future.
> 
> Also removed a duplicate if check that seems to have slipped in.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_nvme.c | 24 +++++++++++++-----------
>  1 file changed, 13 insertions(+), 11 deletions(-)
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
