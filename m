From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] qla2xxx: Fix oops in qla2x00_probe_one error path
Date: Mon, 23 Oct 2017 04:22:45 -0400
Message-ID: <yq1lgk2l1d6.fsf@oracle.com>
References: <1508505442-30352-1-git-send-email-dougmill@linux.vnet.ibm.com>
        <1508505442-30352-2-git-send-email-dougmill@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33753 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751207AbdJWIWw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2017 04:22:52 -0400
In-Reply-To: <1508505442-30352-2-git-send-email-dougmill@linux.vnet.ibm.com>
        (Douglas Miller's message of "Fri, 20 Oct 2017 08:17:22 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Miller <dougmill@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, qla2xxx-upstream@qlogic.com


Douglas,

> On error, kthread_create() returns an errno-encoded pointer, not NULL.
> The routine qla2x00_probe_one() detects the error case and jumps
> to probe_failed, but has already assigned the return value from
> kthread_create() to ha->dpc_thread.  Then probe_failed checks to see
> if ha->dpc_thread is not NULL before doing cleanup on it. Since in the
> error case this is also not NULL, it ends up trying to access an invalid
> task pointer.
>
> Solution is to assign NULL to ha->dpc_thread in the error path to avoid
> kthread cleanup in that case.

QLogic folks: Please review!

-- 
Martin K. Petersen	Oracle Linux Engineering
