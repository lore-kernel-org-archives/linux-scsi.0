From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH 3/4] qla2xxx: Add Block Multi Queue functionality.
Date: Mon, 07 Nov 2016 11:43:28 -0500
Message-ID: <1478537008.32271.43.camel@localhost.localdomain>
References: <1478277213-3848-1-git-send-email-himanshu.madhani@cavium.com>
         <1478277213-3848-4-git-send-email-himanshu.madhani@cavium.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40444 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752174AbcKGQn3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Nov 2016 11:43:29 -0500
In-Reply-To: <1478277213-3848-4-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: himanshu.madhani@cavium.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, himanshu.madhani@qlogic.com

On Fri, 2016-11-04 at 09:33 -0700, himanshu.madhani@cavium.com wrote:
> From: Michael Hernandez <michael.hernandez@cavium.com>
> 
> Tell the SCSI layer how many hardware queues we have based on the
> number of max queue pairs created. The number of max queue pairs
> created will depend on number of MSI X vector count or number of CPU's
> in a system.
> 
> This feature can be turned on via CONFIG_SCSI_MQ_DEFAULT or passing
> scsi_mod.use_blk_mq=Y as a parameter to the kernel
> Queue pair creation depend on module parameter "ql2xmqsupport", which
> need to be enabled to create queue pair.
> 

I don't understand this change at all.  Setting ->nr_hw_queues causes
the block layer to allocate a number of queues for that Scsi_Host
object, but it does not appear as if this code uses that functionality.
There is nothing in the patch that examines the tag to see which queue
the request came in on, in order to map it to a hardware queue.

Instead, this patch seems to be reworking the mechanism involved in
NPIV vport creation, which creates an entirely separate Scsi_Host
object.  The driver was already creating separate request queues to
the card for vports, so what does this have to do with Block-MQ?

-Ewan
 

