Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7ED9C7EE2F
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jun 2023 14:09:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240944AbjFGOJY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 10:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240928AbjFGOJW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 10:09:22 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989971BD6;
        Wed,  7 Jun 2023 07:08:57 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9BE676732D; Wed,  7 Jun 2023 16:08:23 +0200 (CEST)
Date:   Wed, 7 Jun 2023 16:08:23 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Martin Wilck <mwilck@suse.com>, Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 3/3] scsi: simplify scsi_stop_queue()
Message-ID: <20230607140823.GA23670@lst.de>
References: <20230606193845.9627-1-mwilck@suse.com> <20230606193845.9627-4-mwilck@suse.com> <20230607052710.GC20052@lst.de> <c0563161eb613f9500e6a1cccdcff6fc64efffad.camel@suse.com> <903c7222-c95e-fda1-9b90-b59e184944cf@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <903c7222-c95e-fda1-9b90-b59e184944cf@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 07, 2023 at 07:05:34AM -0700, Bart Van Assche wrote:
>> The reason is simple: I wasn't certain if dev_to_shost() could return
>> NULL, and preferred skipping the wait over an Oops. I hear you say that
>> dev_to_shost() can't go wrong, so I'll remove the NULL test.
>
> I propose to pass shost as the first argument to scsi_target_block() 
> instead of using dev_to_shost() inside scsi_target_block(). Except in 
> __iscsi_block_session(), shost is already available as a local variable.

That sounds like a good idea to me.

