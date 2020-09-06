Return-Path: <SRS0=a8U3=CP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59702C43461
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Sep 2020 16:06:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 203D320708
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Sep 2020 16:06:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbgIFQGI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Sep 2020 12:06:08 -0400
Received: from netrider.rowland.org ([192.131.102.5]:43209 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726931AbgIFQGB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Sep 2020 12:06:01 -0400
Received: (qmail 742015 invoked by uid 1000); 6 Sep 2020 12:06:00 -0400
Date:   Sun, 6 Sep 2020 12:06:00 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/9] Rework runtime suspend and SCSI domain validation
Message-ID: <20200906160600.GB741441@rowland.harvard.edu>
References: <20200906012219.17893-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200906012219.17893-1-bvanassche@acm.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Sep 05, 2020 at 06:22:10PM -0700, Bart Van Assche wrote:
> Hi Jens,
> 
> The SCSI runtime suspend and domain validation mechanisms both use
> scsi_device_quiesce(). scsi_device_quiesce() restricts blk_queue_enter() to
> BLK_MQ_REQ_PREEMPT requests. There is a conflict between the requirements
> of runtime suspend and SCSI domain validation: no requests must be sent to
> runtime suspended devices that are in the state RPM_SUSPENDED while
> BLK_MQ_REQ_PREEMPT requests must be processed during SCSI domain
> validation. This conflict is resolved by reworking the SCSI domain
> validation implementation.
> 
> Hybernation and runtime suspend have been retested but SCSI domain
> validation not yet.
> 
> Please consider this patch series for kernel v5.10.
> 
> Thanks,
> 
> Bart.
> 
> Alan Stern (1):
>   block: Do not accept any requests while suspended
> 
> Bart Van Assche (8):
>   block: Fix a race in the runtime power management code
>   ide: Do not set the RQF_PREEMPT flag for sense requests
>   scsi: Pass a request queue pointer to __scsi_execute()
>   scsi: Rework scsi_mq_alloc_queue()
>   scsi: Do not wait for a request in scsi_eh_lock_door()
>   scsi_transport_spi: Make spi_execute() accept a request queue pointer
>   scsi_transport_spi: Freeze request queues instead of quiescing
>   block, scsi, ide: Only process PM requests if rpm_status != RPM_ACTIVE

I don't know enough about the IDE subsystem to judge patches 2 or 8.

For patches 3 - 7:

Reviewed-by: Alan Stern <stern@rowland.harvard.edu>

Alan Stern
