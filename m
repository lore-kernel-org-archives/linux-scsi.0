From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [lpfc 05/19] Fix driver unload/reload operation.
Date: Wed, 5 Apr 2017 09:20:01 +0200
Message-ID: <20170405072001.GE3941@linux-x5ow.site>
References: <1491326232-11255-1-git-send-email-rkennedy@broadcom.com>
 <1491326232-11255-6-git-send-email-rkennedy@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47553 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753016AbdDEHUI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 5 Apr 2017 03:20:08 -0400
Content-Disposition: inline
In-Reply-To: <1491326232-11255-6-git-send-email-rkennedy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dick Kennedy <dick.kennedy@broadcom.com>
Cc: linux-scsi@vger.kernel.org, James Smart <james.smart@broadcom.com>

On Tue, Apr 04, 2017 at 10:16:58AM -0700, Dick Kennedy wrote:
> From: Dick Kennedy <rkennedy@lvnvda1400.lvn.broadcom.net>
> 
> Two issues: (1) driver could not be unloaded and
> reloaded without some Oops or Panic occurring. (2) The
> driver was panicking because of a corruption in the Memory
> Manager when the iocb list was getting allocated.
> 
> Root cause for the memory corruption was a double
> free of the Work Queue ring pointer memory - Freed once
> in the lpfc_sli4_queue_free when the CQ was destroyed
> and again in lpfc_sli4_queue_free when the WQ was
> destroyed.  While the linux memory manager protects
> against NULL pointers, it can't protect against stale
> pointer kfree calls.
> 
> There are other fixes in this patch found during testing.
> While they are not a direct corruption cause, they should
> be fixed to ensure consistent unload/reload.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---

Is this the regression Junichi Nomura reported? If yes please Cc him to get a
test result (plus proper Reported-by: attribution).

Note there was also a fix from Mauricio Faria de Oliveira [1] which IIRC
Junichi successfully tested.

[1] http://www.spinics.net/lists/linux-scsi/msg106877.html
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
