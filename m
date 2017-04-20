From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH-v1 11/22] Fix driver unload/reload operation.
Date: Thu, 20 Apr 2017 09:37:12 +0200
Message-ID: <20170420073712.GL6217@linux-x5ow.site>
References: <20170420044641.10657-1-jsmart2021@gmail.com>
 <20170420044641.10657-12-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48441 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S938258AbdDTHhU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 20 Apr 2017 03:37:20 -0400
Content-Disposition: inline
In-Reply-To: <20170420044641.10657-12-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jsmart2021@gmail.com, Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, martin.petersen@oracle.com, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On Wed, Apr 19, 2017 at 09:46:30PM -0700, jsmart2021@gmail.com wrote:
> From: James Smart <jsmart2021@gmail.com>
> 
> There are couple of different load/unload issues fixed with this patch.
> One of the issues was reported by Junichi Nomura, a patch was submitted
> by Johannes Thumsrhirn which did fix one of the problems but the fix in
> this patch separates the pring free from the queue free and does not set
> the parameter passed in to NULL.
> 
> issues:
> (1) driver could not be unloaded and reloaded without some Oops or
>  Panic occurring.
> (2) The driver was panicking because of a corruption in the Memory
> Manager when the iocb list was getting allocated.
> 
> Root cause for the memory corruption was a double free of the Work Queue
> ring pointer memory - Freed once in the lpfc_sli4_queue_free when the CQ
> was destroyed and again in lpfc_sli4_queue_free when the WQ was destroyed.
> 
> The pring free and the queue free were separated, the pring free was moved
> to the wq destroy routine because it a better fit logically to delete the
> ring with the wq.
> 
> The checkpatch flagged several alignmenet issues that were also corrected
> with this patch.
> 
> The mboxq was never initialed correctly before it was used by the driver
> this patch corrects that issue.
> 
> Reported-by: Junichi Nomura <j-nomura@ce.jp.nec.com>
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

But I'd really like to see a Tested-by from Junichi here.

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
