Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F209CC7EE25
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jun 2023 05:44:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234434AbjFHFoz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Jun 2023 01:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234517AbjFHFoy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jun 2023 01:44:54 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9C1271D;
        Wed,  7 Jun 2023 22:44:49 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id D1BD26732D; Thu,  8 Jun 2023 07:44:44 +0200 (CEST)
Date:   Thu, 8 Jun 2023 07:44:44 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Martin Wilck <mwilck@suse.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 4/8] scsi: call scsi_stop_queue() without
 state_mutex held
Message-ID: <20230608054444.GB11554@lst.de>
References: <20230607182249.22623-1-mwilck@suse.com> <20230607182249.22623-5-mwilck@suse.com> <3b8b13bf-a458-827a-b916-07d7eee8ae00@acm.org> <50cb1a5bd501721d7c816b1ca8bf560daa8e3cc9.camel@suse.com> <ff669f59e3c42e5dec4920d705e2b8748ad600d5.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff669f59e3c42e5dec4920d705e2b8748ad600d5.camel@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > Thanks. This wasn't obvious to me from the current code. I'll add a
> > comment in the next version.
> 
> The crucial question is now, is it sufficient to call
> blk_mq_quiesce_queue_nowait() under the mutex, or does the call to
> blk_mq_wait_quiesce_done() have to be under the mutex, too?
> The latter would actually kill off our attempt to fix the delay
> in fc_remote_port_delete() that was caused by repeated
> synchronize_rcu() calls.
> 
> But if I understand you correctly, moving the wait out of the mutex
> should be ok. I'll update the series accordingly.

I can't think of a reason we'd want to lock over the wait, but Bart
knows this code way better than I do.
