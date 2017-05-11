From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/15] lpfc: Separate NVMET RQ buffer posting from IO
 resources SGL/iocbq/context
Date: Thu, 11 May 2017 09:23:00 +0200
Message-ID: <968af0f0-078b-fd85-363c-0fe3c111d3f8@suse.de>
References: <20170510190713.30171-1-jsmart2021@gmail.com>
 <20170510190713.30171-9-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45240 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750917AbdEKHXD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 May 2017 03:23:03 -0400
In-Reply-To: <20170510190713.30171-9-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 05/10/2017 09:07 PM, James Smart wrote:
> Currently IO resources are mapped 1 to 1 with RQ buffers posted
> 
> Added logic to separate RQE buffers from IO op resources
> (sgl/iocbq/context). During initialization, the driver will determine
> how many SGLs it will allocate for NVMET (based on what the
> firmware reports) and associate a NVMET IOCBq and NVMET context
> structure with each one.
> 
> Now that hdr/data buffers are immediately reposted back to the RQ,
> 512 RQEs for each MRQ is sufficient. Also, since NVMET data buffers
> are now 128 bytes, lpfc_nvmet_mrq_post is not necessary anymore
> as we will always post the max (512) buffers per NVMET MRQ.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc.h       |  11 +-
>  drivers/scsi/lpfc/lpfc_attr.c  |  11 --
>  drivers/scsi/lpfc/lpfc_crtn.h  |   8 +-
>  drivers/scsi/lpfc/lpfc_init.c  |  92 ++-------------
>  drivers/scsi/lpfc/lpfc_mem.c   |  73 +-----------
>  drivers/scsi/lpfc/lpfc_nvmet.c | 246 +++++++++++++++++++++++++++++++----------
>  drivers/scsi/lpfc/lpfc_nvmet.h |   1 +
>  drivers/scsi/lpfc/lpfc_sli.c   |  88 +++++++++++++--
>  drivers/scsi/lpfc/lpfc_sli4.h  |   4 +-
>  9 files changed, 295 insertions(+), 239 deletions(-)
> 
Re-posting must die :-)

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
