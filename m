From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] lpfc: Fix hard lock up NMI in els timeout handling.
Date: Wed, 08 Nov 2017 18:25:45 -0500
Message-ID: <yq1zi7wxshy.fsf@oracle.com>
References: <20171107205902.17352-1-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47050 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752718AbdKHXZv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2017 18:25:51 -0500
In-Reply-To: <20171107205902.17352-1-jsmart2021@gmail.com> (James Smart's
        message of "Tue, 7 Nov 2017 12:59:02 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: linux-scsi@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>


James,

> System crashed due to a hard lockup at lpfc_els_timeout_handler+0x128.
>
> The els ring's txcmplq list is corrupted: the last element in the list
> does not point back the the head causing a loop. Issue is the
> els processing path for sli4 hbas are using the hbalock instead of
> the ring_lock for removing elements from the txcmplq list.
>
> Use the adapter SLI_REV to determine which lock should be used for
> removing iocbqs from the els rings txcmplq.

Applied to 4.15/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
