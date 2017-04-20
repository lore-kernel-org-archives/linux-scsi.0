From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH-v1 13/22] Fix nvme initiator handling when not enabled.
Date: Thu, 20 Apr 2017 09:38:57 +0200
Message-ID: <20170420073857.GN6217@linux-x5ow.site>
References: <20170420044641.10657-1-jsmart2021@gmail.com>
 <20170420044641.10657-14-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48556 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S943087AbdDTHjA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 20 Apr 2017 03:39:00 -0400
Content-Disposition: inline
In-Reply-To: <20170420044641.10657-14-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jsmart2021@gmail.com
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, martin.petersen@oracle.com, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On Wed, Apr 19, 2017 at 09:46:32PM -0700, jsmart2021@gmail.com wrote:
> From: James Smart <jsmart2021@gmail.com>
> 
> Fix nvme initiator handline when CONFIG_LPFC_NVME_INITIATOR is not enabled.
> 
> With update nvme upstream driver sources, loading
> the driver with nvme enabled resulting in this Oops.
> 
>  BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
>  IP: lpfc_nvme_update_localport+0x23/0xd0 [lpfc]
>  PGD 0
>  Oops: 0000 [#1] SMP
>  CPU: 0 PID: 10256 Comm: lpfc_worker_0 Tainted
>  Hardware name: ...
>  task: ffff881028191c40 task.stack: ffff880ffdf00000
>  RIP: 0010:lpfc_nvme_update_localport+0x23/0xd0 [lpfc]
>  RSP: 0018:ffff880ffdf03c20 EFLAGS: 00010202
> 
> Cause: As the initiator driver completes discovery at different stages,
> it call lpfc_nvme_update_localport to hint that the DID and role may have
> changed.  In the implementation of lpfc_nvme_update_localport, the driver
> was not validating the localport or the lport during the execution
> of the update_localport routine.  With the recent upstream additions to
> the driver, the create_localport routine didn't run and so the localport
> was NULL causing the page-fault Oops.
> 
> Fix: Add the CONFIG_LPFC_NVME_INITIATOR preprocessor inclusions to
> lpfc_nvme_update_localport to turn off all routine processing when
> the running kernel does not have NVME configured.  Add NULL pointer
> checks on the localport and lport in lpfc_nvme_update_localport and
> dump messages if they are NULL and just exit.
> Also one alingment issue fixed.
> Repalces the ifdef with the IS_ENABLED macro.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
