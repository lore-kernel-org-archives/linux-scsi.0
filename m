From: Jan Vesely <jvesely@redhat.com>
Subject: block: Allow merging of tail pages into the last segment
Date: Thu, 28 Mar 2013 10:38:27 +0100
Message-ID: <1364463509-24975-1-git-send-email-jvesely@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756052Ab3C1Jio (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Mar 2013 05:38:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, axboe@kernel.dk
Cc: James.Bottomley@hansenpartnership.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org


Hi

These patches modify __bio_add_page to accept pages that extent the last bio
segment. some drivers craft their buffers and rely on this behavior (see
message in patch 2 for details)

jan

v3: Use code from __blk_recalc_rq_segments to decide whether the page is
    mergeable, 

v2: modify a comment

Jan Vesely (2):
      block: factor out vector mergeable decision to a helper function
      block: modify __bio_add_page check to accept pages that don't start a new

 block/blk-merge.c   | 52 +++++++++++++++++++++++++++++++---------------------
 fs/bio.c            | 29 ++++++++++++++++++-----------
 include/linux/bio.h |  3 +++
 3 files changed, 52 insertions(+), 32 deletions(-)

