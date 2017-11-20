From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 14/17] lpfc: Fix crash during driver unload with
 running nvme traffic
Date: Mon, 20 Nov 2017 14:30:41 +0100
Message-ID: <63fee29b-62da-78e3-0f72-51b396d3155e@suse.de>
References: <20171110010834.4542-1-jsmart2021@gmail.com>
 <20171110010834.4542-15-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57741 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751086AbdKTNam (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Nov 2017 08:30:42 -0500
In-Reply-To: <20171110010834.4542-15-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 11/10/2017 02:08 AM, James Smart wrote:
> When the driver is unloading, the nvme transport could be in the
> process of submitting new requests, will send abort requests to
> terminate associations, or may make LS-related requests.
> The driver's abort and request entry points currently is ignorant
> of the unloading state and is starting the requests even though
> the infrastructure to complete them continues to teardown.
> 
> Change the entry points for new requests to check whether unloading
> and if so, reject the requests. Abort routines check unloading, and
> if so, noop the request. An abort is noop'd as the teardown paths
> are already aborting/terminating the io outstanding at the time the
> teardown initiated.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_nvme.c  | 14 ++++++++++++++
>  drivers/scsi/lpfc/lpfc_nvmet.c | 11 +++++++++++
>  2 files changed, 25 insertions(+)
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
