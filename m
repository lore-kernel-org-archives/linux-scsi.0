From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 7/9] lpfc: Fix infinite wait when driver unregisters a
 remote NVME port.
Date: Wed, 13 Dec 2017 15:53:26 +0100
Message-ID: <9f1888cb-f09e-47c7-1687-abfab7378174@suse.de>
References: <20171209011811.23421-1-jsmart2021@gmail.com>
 <20171209011811.23421-8-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33373 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753256AbdLMOx2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Dec 2017 09:53:28 -0500
In-Reply-To: <20171209011811.23421-8-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 12/09/2017 02:18 AM, James Smart wrote:
> When unregistering a remote port the lpfc driver would eventually
> wait for the remoteport_unreg done callback. But the driver never
> completed the io aborts that would allow the connections to terminate
> thus the unreg done callback was never issued.  Turns out the coding
> style of the driver allowed for the wait to occur on the same cpu
> that the deferred isr is called on. The blocking for the wait, blocked
> the isr, and as the isr didn't run, the io aborts wouldn't finish.
> 
> Turns out there was never a good reason to block waiting for the
> unreg done in the first place. The driver can continue execution and
> the ref counting within the driver will do the right thing.
> 
> Resolve by removing the wait and patching up a few cases where the
> ref counting didn't look right - mainly cases where the remote port
> comes back before the aborts had completed and the unreg done had
> been called. Additionally, a few places which used pointer values
> to guide driver actions weren't protected by lock, so correct those.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_nvme.c | 135 ++++++++++++++++--------------------------
>  1 file changed, 51 insertions(+), 84 deletions(-)
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
