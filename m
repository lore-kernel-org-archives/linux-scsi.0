From: Abhijeet Joglekar <abjoglek@cisco.com>
Subject: [PATCH 0/3] Address review comments for fnic
Date: Wed, 25 Mar 2009 10:38:52 -0700
Message-ID: <20090325173136.21346.86030.stgit@feynman.nuovasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.nuovasystems.com ([67.91.200.194]:38335 "EHLO
	feynman.nuovasystems.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1763780AbZCYRi5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Mar 2009 13:38:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: abjoglek@cisco.com, jeykholt@cisco.com

The following series addresses Mike C.'s review comments for fnic:
    1) Use static workQ item per fnic for link transitions
    2) Use static workQ item and skb queue per fnic for FCS frames
    3) Use shost_printk to print host_no instead of printing fnic_no

(1) and (2) address the comment that allocating memory in the critical path
for link transitions and FCS frames (fabric login etc) is not good since
failure in memory allocation can prove fatal. The patches get rid of the
event structure and its allocation, and instead use static workQ items.

---

Abhijeet Joglekar (3):
      fnic: Use shost_printk and print host no in print messages
      fnic: Change FCS frame handling to use skb queues and no events
      fnic: Change link transition handling


 drivers/scsi/fnic/fnic.h      |   45 +++-------
 drivers/scsi/fnic/fnic_fcs.c  |  155 +++++++++++++++++++--------------
 drivers/scsi/fnic/fnic_isr.c  |   15 ++-
 drivers/scsi/fnic/fnic_main.c |  186 +++++++++++++++-------------------------
 drivers/scsi/fnic/fnic_res.c  |   80 ++++++++++-------
 drivers/scsi/fnic/fnic_scsi.c |  192 ++++++++++++++++++++---------------------
 6 files changed, 322 insertions(+), 351 deletions(-)

-- 
Signature
