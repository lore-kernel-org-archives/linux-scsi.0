From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/2] workqueue: convert BUG_ON()s in __queue_delayed_work()
 to WARN_ON_ONCE()s
Date: Tue, 4 Dec 2012 07:55:06 -0800
Message-ID: <20121204155506.GF3885@mtj.dyndns.org>
References: <1354620834-2953-1-git-send-email-xtfeng@gmail.com>
 <20121204155434.GE3885@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121204155434.GE3885@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dannyfeng@tencent.com>, Neela Syam Kolli <megaraidlinux@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>From 87aa1e796ff6d491b5ed4e5663e5a4e449ac513b Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Tue, 4 Dec 2012 07:40:39 -0800

8852aac25e ("workqueue: mod_delayed_work_on() shouldn't queue timer on
0 delay") unexpectedly uncovered a very nasty abuse of delayed_work in
megaraid - it allocated work_struct, used container_of() to cast it to
delayed_work and then pass that into queue_delayed_work().

Previously, this was okay because 0 @delay short-circuited to
queue_work() before doing anything with delayed_work.  8852aac25e
moved 0 @delay test into __queue_delayed_work() after sanity check on
delayed_work making megaraid trigger BUG_ON().

Although megaraid is already fixed by c1d390d8e6 ("megaraid: fix
BUG_ON() from incorrect use of delayed work"), this patch converts
BUG_ON()s in __queue_delayed_work() to WARN_ON_ONCE()s so that such
abusers, if there are more, trigger warning but don't crash the
machine.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Xiaotian Feng <xtfeng@gmail.com>
---
 kernel/workqueue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 084aa47..1dae900 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1361,8 +1361,8 @@ static void __queue_delayed_work(int cpu, struct workqueue_struct *wq,
 
 	WARN_ON_ONCE(timer->function != delayed_work_timer_fn ||
 		     timer->data != (unsigned long)dwork);
-	BUG_ON(timer_pending(timer));
-	BUG_ON(!list_empty(&work->entry));
+	WARN_ON_ONCE(timer_pending(timer));
+	WARN_ON_ONCE(!list_empty(&work->entry));
 
 	/*
 	 * If @delay is 0, queue @dwork->work immediately.  This is for
-- 
1.7.11.7
