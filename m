From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/3] libfc: fix potential timer list corruption
Date: Tue, 30 May 2017 17:14:11 +0200
Message-ID: <1496157254-114166-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58452 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750985AbdE3POi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 May 2017 11:14:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

we've seen reports for a crash with an invalid timer_list->function,
which turned out to be an unsafe usage of libfc discovery callbacks.
This patchset fixes up the problem

As usual, comments and reviews are welcome.

Hannes Reinecke (3):
  libfc: move 'pending' and 'requested' setting
  libfc: only restart discovery after timeout if not already running
  libfc: fixup locking in fc_disc_stop()

 drivers/scsi/libfc/fc_disc.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

-- 
1.8.5.6
