From: Vaughan Cao <vaughan.cao@oracle.com>
Subject: [PATCH v4 0/4] [SCSI] sg: fix race condition in sg_open
Date: Wed, 17 Jul 2013 23:34:02 +0800
Message-ID: <1374075246-22923-1-git-send-email-vaughan.cao@oracle.com>
References: <20130715203730.GA21804@logfs.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130715203730.GA21804@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
To: joern@logfs.org
Cc: dgilbert@interlog.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, vaughan.cao@oracle.com
List-Id: linux-scsi@vger.kernel.org

There is a race when open sg with O_EXCL flag. Also a race may happen between
sg_open and sg_remove.

Changes from v3:
 * release o_sem in sg_release(), not in sg_remove_sfp().
 * not set exclude with sfd_lock held.

Vaughan Cao (4):
  [SCSI] sg: use rwsem to solve race during exclusive open
  [SCSI] sg: no need sg_open_exclusive_lock
  [SCSI] sg: checking sdp->detached isn't protected when open
  [SCSI] sg: push file descriptor list locking down to per-device
    locking

 drivers/scsi/sg.c | 186 ++++++++++++++++++++++++++----------------------------
 1 file changed, 88 insertions(+), 98 deletions(-)

-- 
1.7.11.7
