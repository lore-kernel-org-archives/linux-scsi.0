Return-Path: <SRS0=4FRQ=XO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 169C7C4CEC4
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 09:45:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA85F21929
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 09:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388893AbfISJpw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Sep 2019 05:45:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:59254 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387767AbfISJpv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Sep 2019 05:45:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D53F5B66A;
        Thu, 19 Sep 2019 09:45:49 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
        Hans Holmberg <hans.holmberg@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [RFC PATCH 0/2]  blk-mq I/O scheduling fixes
Date:   Thu, 19 Sep 2019 11:45:45 +0200
Message-Id: <20190919094547.67194-1-hare@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

Damien pointed out that there are some areas in the blk-mq I/O
scheduling algorithm which have a distinct legacy feel to it,
and prohibit multiqueue I/O schedulers from working properly.
These two patches should clear up this situation, but as it's
not quite clear what the original intention of the code was
I'll be posting them as an RFC.

So as usual, comments and reviews are welcome.

Hannes Reinecke (2):
  blk-mq: fixup request re-insert in blk_mq_try_issue_list_directly()
  blk-mq: always call into the scheduler in blk_mq_make_request()

 block/blk-mq.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

-- 
2.16.4

