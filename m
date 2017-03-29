From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [REGRESSION] v4.11-rc3: lpfc: panic during module removal /
 shutdown
Date: Wed, 29 Mar 2017 23:26:57 +0000
Message-ID: <64fad7b0-134a-c82b-87c9-c37a860f30b9@ce.jp.nec.com>
References: <99ad422f-8233-ddac-2e69-deda4a43b3d7@ce.jp.nec.com>
 <20170329111754.GA9183@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tyo161.gate.nec.co.jp ([114.179.232.161]:56292 "EHLO
        tyo161.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932735AbdC2X2h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Mar 2017 19:28:37 -0400
In-Reply-To: <20170329111754.GA9183@linux-x5ow.site>
Content-Language: ja-JP
Content-ID: <A3E9A32B1D8A1E4A8AE108F95BF8E18B@gisp.nec.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "dick.kennedy@broadcom.com" <dick.kennedy@broadcom.com>, "james.smart@broadcom.com" <james.smart@broadcom.com>, "anton@samba.org" <anton@samba.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On 03/29/17 20:17, Johannes Thumshirn wrote:
> On Wed, Mar 29, 2017 at 02:29:45AM +0000, Junichi Nomura wrote:
>> The double-free occurs as followings:
>>   - During initialization, lpfc_create_wq_cq() binds cq and wq to
>>     the same ring in the way that both cq->pring and wq->pring point
>>     to the same object.
>>   - Upon removal, lpfc_sli4_queue_destroy() ends up calling
>>     lpfc_sli4_queue_free() for both wqs and cqs
>>     and kfree(queue->pring) is done twice.
>>
>> The problem became more visible in v4.11-rc3 because commit 85e8a23936ab
>> ("scsi: lpfc: Add shutdown method for kexec") made lpfc_pci_remove_one()
>> called during driver shutdown.
> 
> Well the obvious band-aid would be setting the pointers to NULL after freeing
> them. lpfc_sli4_queue_free() checks for queue's precense and doesn't use
> queue->pring prior to freeing it, so the following _should_ to the trick:
> 
> From befa936d8935a1bed01df65b376f515fa42c99da Mon Sep 17 00:00:00 2001
> From: Johannes Thumshirn <jthumshirn@suse.de>
> Date: Wed, 29 Mar 2017 13:08:55 +0200
> Subject: [PATCH] lpfc: prevent double free of lpfc queue ring pointer
> 
> Since commit 895427bd012c ("scsi: lpfc: NVME Initiator: Base modifications")
> rmoving the lpfc module causes a double free in lpfc_sli4_queue_free().
> 
> This can be prevented by setting the queue->pring and queue pointers to NULL,
> so kfree() will simply ignore the pointers on a second call.

No, it doesn't work.

Even if lpfc_sli4_queue_free(wq) sets wq->pring to NULL, cq->pring still
holds bogus pointer and lpfc_sli4_queue_free(cq) will call kfree(cq->pring)
and cause double-free.

-- 
Jun'ichi Nomura, NEC Corporation / NEC Solution Innovators, Ltd.
