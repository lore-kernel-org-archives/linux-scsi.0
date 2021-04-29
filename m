Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F245C43603
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 12:25:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E146A61400
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 12:25:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235751AbhD2M0Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Apr 2021 08:26:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:39522 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234863AbhD2M0Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Apr 2021 08:26:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2D9A4B019;
        Thu, 29 Apr 2021 12:25:36 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/3] fnic: use scsi_host_busy_iter() to traverse commands
Date:   Thu, 29 Apr 2021 14:25:14 +0200
Message-Id: <20210429122517.39659-1-hare@suse.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

the fnic driver is walking the list of tags manually, causing frequent
crashes as the block layer doesn't necessarily cleans up requests after
usage.
So switch to scsi_host_busy_iter() to traverse commands avoiding this
problem.

As usual, comments and reviews are welcome.

Hannes Reinecke (3):
  fnic: kill 'exclude_id' argument to fnic_cleanup_io()
  fnic: use scsi_host_busy_iter() to traverse commands
  fnic: check for started requests in fnic_wq_copy_cleanup_handler()

 drivers/scsi/fnic/fnic_scsi.c | 830 ++++++++++++++++------------------
 1 file changed, 378 insertions(+), 452 deletions(-)

-- 
2.29.2

