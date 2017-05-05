From: Johannes Thumshirn <jth@kernel.org>
Subject: Re: [PATCH 5/5] scsi: bnx2fc: convert bnx2fc_l2_rcv_thread() to
 workqueue
Date: Fri, 5 May 2017 12:34:53 +0200
Message-ID: <98dd998c-7c74-3f59-1b61-35986382c8e6@kernel.org>
References: <20170410171254.30367-1-bigeasy@linutronix.de>
 <20170410171254.30367-6-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:33489 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751492AbdEEKe5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 May 2017 06:34:57 -0400
Received: by mail-wr0-f194.google.com with SMTP id w50so255838wrc.0
        for <linux-scsi@vger.kernel.org>; Fri, 05 May 2017 03:34:57 -0700 (PDT)
In-Reply-To: <20170410171254.30367-6-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
Cc: rt@linutronix.de, Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, Chad Dupuis <chad.dupuis@qlogic.com>, QLogic-Storage-Upstream@qlogic.com, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>, fcoe-devel@open-fcoe.org


On 04/10/2017 07:12 PM, Sebastian Andrzej Siewior wrote:
> This is not driven by the hotplug conversation but while I am at it
> looks like a good candidate. Converting the thread to a workqueue user
> removes also the kthread member from struct fcoe_percpu_s.
>
> This driver uses the struct fcoe_percpu_s but it does not need the
> crc_eof_page member, only the work item and fcoe_rx_list. So it is
> removed there.
>
> We had one thread so we only use the workqueue on the current CPU. If
> someone knows how spread this nicely, it would only require the usage of
> schedule_work_on() instead schedule_work() :)
>
> This patch was only compile-tested due to -ENODEV.
>
> Cc: QLogic-Storage-Upstream@qlogic.com
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: fcoe-devel@open-fcoe.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
