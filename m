From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_transport_fc: Hold queue lock while calling blk_run_queue_async()
Date: Mon, 14 Nov 2016 18:26:21 -0500
Message-ID: <yq137ithcde.fsf@sermon.lab.mkp.net>
References: <fb002f66-4648-9653-63b1-9c24a2c02666@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51038 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753048AbcKNX0f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Nov 2016 18:26:35 -0500
In-Reply-To: <fb002f66-4648-9653-63b1-9c24a2c02666@sandisk.com> (Bart Van
        Assche's message of "Fri, 11 Nov 2016 16:55:50 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, James Smart <james.smart@broadcom.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>>>>> "Bart" == Bart Van Assche <bart.vanassche@sandisk.com> writes:

Bart> It is required to hold the queue lock when calling
Bart> blk_run_queue_async() to avoid that a race between
Bart> blk_run_queue_async() and blk_cleanup_queue() is
Bart> triggered. Additionally, remove the get_device() and put_device()
Bart> calls from fc_bsg_goose_queue. It is namely the responsibility of
Bart> the caller of fc_bsg_goose_queue() to ensure that the bsg queue
Bart> does not disappear while fc_bsg_goose_queue() is in progress.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
