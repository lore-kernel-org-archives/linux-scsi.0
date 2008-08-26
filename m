From: Abhijeet Joglekar <ajoglekar@nuovasystems.com>
Subject: [RFC] [PATCH] Potential bug fix for blk_tag_queue
Date: Mon, 25 Aug 2008 18:03:01 -0700
Message-ID: <20080826005856.27375.59152.stgit@feynman.nuovasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.nuovasystems.com ([67.91.200.194]:29697 "EHLO
	feynman.nuovasystems.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753687AbYHZByc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2008 21:54:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, ajoglekar@nuovasystems.com

The following patch fixes a potential bug in the blk_tag_queue structure.
"busy" is used to keep track of outstanding tags, is declared as int,
and updated inside queue lock. For host-wide shared tag map, this corrupts
the value of busy, which hits BUG_ON during __blk_free_tags.

Recommend converting busy to atomic_t and using atomic_macros to access it.

---

Abhijeet Joglekar (1):
      blk-tag: Use atomic_t type for bqt->busy.


 block/blk-tag.c        |    8 ++++----
 include/linux/blkdev.h |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

-- 
Signature
