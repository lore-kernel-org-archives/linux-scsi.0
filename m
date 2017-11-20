From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 16/17] lpfc: small sg cnt cleanup
Date: Mon, 20 Nov 2017 14:34:31 +0100
Message-ID: <77257e94-12bc-e496-f2bc-1a704737eedc@suse.de>
References: <20171110010834.4542-1-jsmart2021@gmail.com>
 <20171110010834.4542-17-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58153 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751658AbdKTNed (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Nov 2017 08:34:33 -0500
In-Reply-To: <20171110010834.4542-17-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 11/10/2017 02:08 AM, James Smart wrote:
> The logic for sg_seg_cnt is a bit convoluted. This patch tries to
> clean up a couple of areas, especially around the +2 and +1 logic.
> 
> This patch:
> - cleans up the lpfc_sg_seg_cnt attribute to specify a real minimum
>   rather than making the minimum be whatever the default is.
> - Remove the hardcoding of +2 (for the number of elements we use in
>   a sgl for cmd iu and rsp iu) and +1 (an additional entry to
>   compensate for nvme's reduction of io size based on a possible
>   partial page) logic in sg list initialization. In the case where
>   the +1 logic is referenced in host and target io checks, use the
>   values set in the transport template as that value was properly set.
> 
> There can certainly be more done in this area and it will be addressed
> in combined host/target driver effort.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc.h       |  1 +
>  drivers/scsi/lpfc/lpfc_attr.c  |  2 +-
>  drivers/scsi/lpfc/lpfc_init.c  | 19 ++++++++++++++-----
>  drivers/scsi/lpfc/lpfc_nvme.c  |  3 ++-
>  drivers/scsi/lpfc/lpfc_nvmet.c |  2 +-
>  5 files changed, 19 insertions(+), 8 deletions(-)
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
