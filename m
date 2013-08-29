From: Vaughan Cao <vaughan.cao@oracle.com>
Subject: [PATCH v7 0/4][SCSI] sg: fix race condition in sg_open
Date: Thu, 29 Aug 2013 10:00:35 +0800
Message-ID: <1377741639-3693-1-git-send-email-vaughan.cao@oracle.com>
References: <1377685578.2005.50.camel@dabdike>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1377685578.2005.50.camel@dabdike>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: joern@logfs.org, vaughan.cao@oracle.com, dgilbert@interlog.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

There is a race when open sg with O_EXCL flag. Also a race may happen between
sg_open and sg_remove.

Changes from v6:
 * [1/4] remove double if.
 * [3/4] fix via IS_ERR
Changes from v5:
 Patches based on v3.11-rc7 and passed sg_tst_excl test.
 * [1/4] * remove unused variables - res,sdp.
	 * fix insane code dealing with sg_add_sfp.
 * [2/4] resolve conflict with v3.11-rc7. 
 * [3/4] remove sem_out label.
 * [4/4] add sdp definition.

Changes from v4:
 * [3/4] use ERR_PTR series instead of adding another parameter in sg_add_sfp
 * [4/4] fix conflict for cherry-pick from v3.

Changes from v3:
 * release o_sem in sg_release(), not in sg_remove_sfp().
 * not set exclude with sfd_lock held.

Vaughan Cao (4):
  sg: use rwsem to solve race during exclusive open
  sg: no need sg_open_exclusive_lock
  sg: checking sdp->detached isn't protected when open
  sg: push file descriptor list locking down to per-device locking

 drivers/scsi/sg.c | 176 +++++++++++++++++++++++++-----------------------------
 1 file changed, 81 insertions(+), 95 deletions(-)

-- 
1.8.3.1
