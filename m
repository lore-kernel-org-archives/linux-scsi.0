From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 15/17] lpfc: Fix driver handling of nvme resources
 during unload
Date: Mon, 20 Nov 2017 14:33:02 +0100
Message-ID: <109a9b1b-a953-f5a3-8f4d-bfb1903d84dd@suse.de>
References: <20171110010834.4542-1-jsmart2021@gmail.com>
 <20171110010834.4542-16-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57939 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751252AbdKTNdE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Nov 2017 08:33:04 -0500
In-Reply-To: <20171110010834.4542-16-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 11/10/2017 02:08 AM, James Smart wrote:
> During driver unload, the driver may crash due to NULL pointers.
> The NULL pointers were due to the driver not protecting itself
> sufficiently during some of the teardown paths.
> Additionally, the driver was not waiting for and cleanup up nvme
> io resources. As such, the driver wasn't making the callbacks
> to the transport, stalling the transports association teardown.
> 
> This patch waits for io clean up before tearding down and adds
> checks for possible NULL pointers.
> 
> Cc: <stable@vger.kernel.org> # 4.12+
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_crtn.h |  2 +
>  drivers/scsi/lpfc/lpfc_init.c | 18 ++++++++
>  drivers/scsi/lpfc/lpfc_nvme.c | 96 ++++++++++++++++++++++++++++++++++++++-----
>  3 files changed, 105 insertions(+), 11 deletions(-)
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
