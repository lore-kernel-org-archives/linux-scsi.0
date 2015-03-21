From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 2/3] iscsi-target: Drop legacy iscsi_target_tq.c logic
Date: Sat, 21 Mar 2015 06:16:03 +0000
Message-ID: <1426918564-22581-3-git-send-email-nab@daterainc.com>
References: <1426918564-22581-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1426918564-22581-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Slava Shwartsman <valyushash@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Now that iscsi_conn allocates new [rx,tx] threads using kthread.h
primitives on the fly, and kthread_stop() is called directly during
connection shutdown, it's time to go ahead and drop iscsi_target_tq.c
legacy code.

The use of multiple struct completion in iscsi_activate_thread_set()
has been proven to cause issues during repeated iser login/logout.

Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Slava Shwartsman <valyushash@gmail.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/Makefile             |   1 -
 drivers/target/iscsi/iscsi_target.c       |   3 -
 drivers/target/iscsi/iscsi_target_erl0.c  |   1 -
 drivers/target/iscsi/iscsi_target_login.c |   1 -
 drivers/target/iscsi/iscsi_target_tq.c    | 495 ------------------------------
 drivers/target/iscsi/iscsi_target_tq.h    |  84 -----
 drivers/target/iscsi/iscsi_target_util.c  |   1 -
 include/target/iscsi/iscsi_target_core.h  |   6 +-
 8 files changed, 2 insertions(+), 590 deletions(-)
 delete mode 100644 drivers/target/iscsi/iscsi_target_tq.c
 delete mode 100644 drivers/target/iscsi/iscsi_target_tq.h

diff --git a/drivers/target/iscsi/Makefile b/drivers/target/iscsi/Makefile
index 13a9240..0f43be9 100644
--- a/drivers/target/iscsi/Makefile
+++ b/drivers/target/iscsi/Makefile
@@ -1,6 +1,5 @@
 iscsi_target_mod-y +=		iscsi_target_parameters.o \
 				iscsi_target_seq_pdu_list.o \
-				iscsi_target_tq.o \
 				iscsi_target_auth.o \
 				iscsi_target_datain_values.o \
 				iscsi_target_device.o \
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index cb97b59..ca731b5 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -33,7 +33,6 @@
 #include <target/iscsi/iscsi_target_core.h>
 #include "iscsi_target_parameters.h"
 #include "iscsi_target_seq_pdu_list.h"
-#include "iscsi_target_tq.h"
 #include "iscsi_target_configfs.h"
 #include "iscsi_target_datain_values.h"
 #include "iscsi_target_erl0.h"
@@ -4369,8 +4368,6 @@ int iscsit_close_connection(
 
 	iscsit_put_transport(conn->conn_transport);
 
-	conn->thread_set = NULL;
-
 	pr_debug("Moving to TARG_CONN_STATE_FREE.\n");
 	conn->conn_state = TARG_CONN_STATE_FREE;
 	kfree(conn);
diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
index e008ed2..959a14c 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.c
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -23,7 +23,6 @@
 
 #include <target/iscsi/iscsi_target_core.h>
 #include "iscsi_target_seq_pdu_list.h"
-#include "iscsi_target_tq.h"
 #include "iscsi_target_erl0.h"
 #include "iscsi_target_erl1.h"
 #include "iscsi_target_erl2.h"
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 345f073..af20ddf 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -26,7 +26,6 @@
 
 #include <target/iscsi/iscsi_target_core.h>
 #include <target/iscsi/iscsi_target_stat.h>
-#include "iscsi_target_tq.h"
 #include "iscsi_target_device.h"
 #include "iscsi_target_nego.h"
 #include "iscsi_target_erl0.h"
diff --git a/drivers/target/iscsi/iscsi_target_tq.c b/drivers/target/iscsi/iscsi_target_tq.c
deleted file mode 100644
index 26aa509..0000000
--- a/drivers/target/iscsi/iscsi_target_tq.c
+++ /dev/null
@@ -1,495 +0,0 @@
-/*******************************************************************************
- * This file contains the iSCSI Login Thread and Thread Queue functions.
- *
- * (c) Copyright 2007-2013 Datera, Inc.
- *
- * Author: Nicholas A. Bellinger <nab@linux-iscsi.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- ******************************************************************************/
-
-#include <linux/kthread.h>
-#include <linux/list.h>
-#include <linux/bitmap.h>
-
-#include <target/iscsi/iscsi_target_core.h>
-#include "iscsi_target_tq.h"
-#include "iscsi_target.h"
-
-static LIST_HEAD(inactive_ts_list);
-static DEFINE_SPINLOCK(inactive_ts_lock);
-static DEFINE_SPINLOCK(ts_bitmap_lock);
-
-static void iscsi_add_ts_to_inactive_list(struct iscsi_thread_set *ts)
-{
-	if (!list_empty(&ts->ts_list)) {
-		WARN_ON(1);
-		return;
-	}
-	spin_lock(&inactive_ts_lock);
-	list_add_tail(&ts->ts_list, &inactive_ts_list);
-	iscsit_global->inactive_ts++;
-	spin_unlock(&inactive_ts_lock);
-}
-
-static struct iscsi_thread_set *iscsi_get_ts_from_inactive_list(void)
-{
-	struct iscsi_thread_set *ts;
-
-	spin_lock(&inactive_ts_lock);
-	if (list_empty(&inactive_ts_list)) {
-		spin_unlock(&inactive_ts_lock);
-		return NULL;
-	}
-
-	ts = list_first_entry(&inactive_ts_list, struct iscsi_thread_set, ts_list);
-
-	list_del_init(&ts->ts_list);
-	iscsit_global->inactive_ts--;
-	spin_unlock(&inactive_ts_lock);
-
-	return ts;
-}
-
-int iscsi_allocate_thread_sets(u32 thread_pair_count)
-{
-	int allocated_thread_pair_count = 0, i, thread_id;
-	struct iscsi_thread_set *ts = NULL;
-
-	for (i = 0; i < thread_pair_count; i++) {
-		ts = kzalloc(sizeof(struct iscsi_thread_set), GFP_KERNEL);
-		if (!ts) {
-			pr_err("Unable to allocate memory for"
-					" thread set.\n");
-			return allocated_thread_pair_count;
-		}
-		/*
-		 * Locate the next available regision in the thread_set_bitmap
-		 */
-		spin_lock(&ts_bitmap_lock);
-		thread_id = bitmap_find_free_region(iscsit_global->ts_bitmap,
-				iscsit_global->ts_bitmap_count, get_order(1));
-		spin_unlock(&ts_bitmap_lock);
-		if (thread_id < 0) {
-			pr_err("bitmap_find_free_region() failed for"
-				" thread_set_bitmap\n");
-			kfree(ts);
-			return allocated_thread_pair_count;
-		}
-
-		ts->thread_id = thread_id;
-		ts->status = ISCSI_THREAD_SET_FREE;
-		INIT_LIST_HEAD(&ts->ts_list);
-		spin_lock_init(&ts->ts_state_lock);
-		init_completion(&ts->rx_restart_comp);
-		init_completion(&ts->tx_restart_comp);
-		init_completion(&ts->rx_start_comp);
-		init_completion(&ts->tx_start_comp);
-		sema_init(&ts->ts_activate_sem, 0);
-
-		ts->create_threads = 1;
-		ts->tx_thread = kthread_run(iscsi_target_tx_thread, ts, "%s",
-					ISCSI_TX_THREAD_NAME);
-		if (IS_ERR(ts->tx_thread)) {
-			dump_stack();
-			pr_err("Unable to start iscsi_target_tx_thread\n");
-			break;
-		}
-
-		ts->rx_thread = kthread_run(iscsi_target_rx_thread, ts, "%s",
-					ISCSI_RX_THREAD_NAME);
-		if (IS_ERR(ts->rx_thread)) {
-			kthread_stop(ts->tx_thread);
-			pr_err("Unable to start iscsi_target_rx_thread\n");
-			break;
-		}
-		ts->create_threads = 0;
-
-		iscsi_add_ts_to_inactive_list(ts);
-		allocated_thread_pair_count++;
-	}
-
-	pr_debug("Spawned %d thread set(s) (%d total threads).\n",
-		allocated_thread_pair_count, allocated_thread_pair_count * 2);
-	return allocated_thread_pair_count;
-}
-
-static void iscsi_deallocate_thread_one(struct iscsi_thread_set *ts)
-{
-	spin_lock_bh(&ts->ts_state_lock);
-	ts->status = ISCSI_THREAD_SET_DIE;
-
-	if (ts->rx_thread) {
-		complete(&ts->rx_start_comp);
-		spin_unlock_bh(&ts->ts_state_lock);
-		kthread_stop(ts->rx_thread);
-		spin_lock_bh(&ts->ts_state_lock);
-	}
-	if (ts->tx_thread) {
-		complete(&ts->tx_start_comp);
-		spin_unlock_bh(&ts->ts_state_lock);
-		kthread_stop(ts->tx_thread);
-		spin_lock_bh(&ts->ts_state_lock);
-	}
-	spin_unlock_bh(&ts->ts_state_lock);
-	/*
-	 * Release this thread_id in the thread_set_bitmap
-	 */
-	spin_lock(&ts_bitmap_lock);
-	bitmap_release_region(iscsit_global->ts_bitmap,
-			ts->thread_id, get_order(1));
-	spin_unlock(&ts_bitmap_lock);
-
-	kfree(ts);
-}
-
-void iscsi_deallocate_thread_sets(void)
-{
-	struct iscsi_thread_set *ts = NULL;
-	u32 released_count = 0;
-
-	while ((ts = iscsi_get_ts_from_inactive_list())) {
-
-		iscsi_deallocate_thread_one(ts);
-		released_count++;
-	}
-
-	if (released_count)
-		pr_debug("Stopped %d thread set(s) (%d total threads)."
-			"\n", released_count, released_count * 2);
-}
-
-static void iscsi_deallocate_extra_thread_sets(void)
-{
-	u32 orig_count, released_count = 0;
-	struct iscsi_thread_set *ts = NULL;
-
-	orig_count = TARGET_THREAD_SET_COUNT;
-
-	while ((iscsit_global->inactive_ts + 1) > orig_count) {
-		ts = iscsi_get_ts_from_inactive_list();
-		if (!ts)
-			break;
-
-		iscsi_deallocate_thread_one(ts);
-		released_count++;
-	}
-
-	if (released_count)
-		pr_debug("Stopped %d thread set(s) (%d total threads)."
-			"\n", released_count, released_count * 2);
-}
-
-void iscsi_activate_thread_set(struct iscsi_conn *conn, struct iscsi_thread_set *ts)
-{
-	spin_lock_bh(&ts->ts_state_lock);
-	conn->thread_set = ts;
-	ts->conn = conn;
-	ts->status = ISCSI_THREAD_SET_ACTIVE;
-	spin_unlock_bh(&ts->ts_state_lock);
-
-	complete(&ts->rx_start_comp);
-	complete(&ts->tx_start_comp);
-
-	down(&ts->ts_activate_sem);
-}
-
-struct iscsi_thread_set *iscsi_get_thread_set(void)
-{
-	struct iscsi_thread_set *ts;
-
-get_set:
-	ts = iscsi_get_ts_from_inactive_list();
-	if (!ts) {
-		iscsi_allocate_thread_sets(1);
-		goto get_set;
-	}
-
-	ts->delay_inactive = 1;
-	ts->signal_sent = 0;
-	ts->thread_count = 2;
-	init_completion(&ts->rx_restart_comp);
-	init_completion(&ts->tx_restart_comp);
-	sema_init(&ts->ts_activate_sem, 0);
-
-	return ts;
-}
-
-void iscsi_set_thread_clear(struct iscsi_conn *conn, u8 thread_clear)
-{
-	struct iscsi_thread_set *ts = NULL;
-
-	if (!conn->thread_set) {
-		pr_err("struct iscsi_conn->thread_set is NULL\n");
-		return;
-	}
-	ts = conn->thread_set;
-
-	spin_lock_bh(&ts->ts_state_lock);
-	ts->thread_clear &= ~thread_clear;
-
-	if ((thread_clear & ISCSI_CLEAR_RX_THREAD) &&
-	    (ts->blocked_threads & ISCSI_BLOCK_RX_THREAD))
-		complete(&ts->rx_restart_comp);
-	else if ((thread_clear & ISCSI_CLEAR_TX_THREAD) &&
-		 (ts->blocked_threads & ISCSI_BLOCK_TX_THREAD))
-		complete(&ts->tx_restart_comp);
-	spin_unlock_bh(&ts->ts_state_lock);
-}
-
-void iscsi_set_thread_set_signal(struct iscsi_conn *conn, u8 signal_sent)
-{
-	struct iscsi_thread_set *ts = NULL;
-
-	if (!conn->thread_set) {
-		pr_err("struct iscsi_conn->thread_set is NULL\n");
-		return;
-	}
-	ts = conn->thread_set;
-
-	spin_lock_bh(&ts->ts_state_lock);
-	ts->signal_sent |= signal_sent;
-	spin_unlock_bh(&ts->ts_state_lock);
-}
-
-int iscsi_release_thread_set(struct iscsi_conn *conn)
-{
-	int thread_called = 0;
-	struct iscsi_thread_set *ts = NULL;
-
-	if (!conn || !conn->thread_set) {
-		pr_err("connection or thread set pointer is NULL\n");
-		BUG();
-	}
-	ts = conn->thread_set;
-
-	spin_lock_bh(&ts->ts_state_lock);
-	ts->status = ISCSI_THREAD_SET_RESET;
-
-	if (!strncmp(current->comm, ISCSI_RX_THREAD_NAME,
-			strlen(ISCSI_RX_THREAD_NAME)))
-		thread_called = ISCSI_RX_THREAD;
-	else if (!strncmp(current->comm, ISCSI_TX_THREAD_NAME,
-			strlen(ISCSI_TX_THREAD_NAME)))
-		thread_called = ISCSI_TX_THREAD;
-
-	if (ts->rx_thread && (thread_called == ISCSI_TX_THREAD) &&
-	   (ts->thread_clear & ISCSI_CLEAR_RX_THREAD)) {
-
-		if (!(ts->signal_sent & ISCSI_SIGNAL_RX_THREAD)) {
-			send_sig(SIGINT, ts->rx_thread, 1);
-			ts->signal_sent |= ISCSI_SIGNAL_RX_THREAD;
-		}
-		ts->blocked_threads |= ISCSI_BLOCK_RX_THREAD;
-		spin_unlock_bh(&ts->ts_state_lock);
-		wait_for_completion(&ts->rx_restart_comp);
-		spin_lock_bh(&ts->ts_state_lock);
-		ts->blocked_threads &= ~ISCSI_BLOCK_RX_THREAD;
-	}
-	if (ts->tx_thread && (thread_called == ISCSI_RX_THREAD) &&
-	   (ts->thread_clear & ISCSI_CLEAR_TX_THREAD)) {
-
-		if (!(ts->signal_sent & ISCSI_SIGNAL_TX_THREAD)) {
-			send_sig(SIGINT, ts->tx_thread, 1);
-			ts->signal_sent |= ISCSI_SIGNAL_TX_THREAD;
-		}
-		ts->blocked_threads |= ISCSI_BLOCK_TX_THREAD;
-		spin_unlock_bh(&ts->ts_state_lock);
-		wait_for_completion(&ts->tx_restart_comp);
-		spin_lock_bh(&ts->ts_state_lock);
-		ts->blocked_threads &= ~ISCSI_BLOCK_TX_THREAD;
-	}
-
-	ts->conn = NULL;
-	ts->status = ISCSI_THREAD_SET_FREE;
-	spin_unlock_bh(&ts->ts_state_lock);
-
-	return 0;
-}
-
-int iscsi_thread_set_force_reinstatement(struct iscsi_conn *conn)
-{
-	struct iscsi_thread_set *ts;
-
-	if (!conn->thread_set)
-		return -1;
-	ts = conn->thread_set;
-
-	spin_lock_bh(&ts->ts_state_lock);
-	if (ts->status != ISCSI_THREAD_SET_ACTIVE) {
-		spin_unlock_bh(&ts->ts_state_lock);
-		return -1;
-	}
-
-	if (ts->tx_thread && (!(ts->signal_sent & ISCSI_SIGNAL_TX_THREAD))) {
-		send_sig(SIGINT, ts->tx_thread, 1);
-		ts->signal_sent |= ISCSI_SIGNAL_TX_THREAD;
-	}
-	if (ts->rx_thread && (!(ts->signal_sent & ISCSI_SIGNAL_RX_THREAD))) {
-		send_sig(SIGINT, ts->rx_thread, 1);
-		ts->signal_sent |= ISCSI_SIGNAL_RX_THREAD;
-	}
-	spin_unlock_bh(&ts->ts_state_lock);
-
-	return 0;
-}
-
-static void iscsi_check_to_add_additional_sets(void)
-{
-	int thread_sets_add;
-
-	spin_lock(&inactive_ts_lock);
-	thread_sets_add = iscsit_global->inactive_ts;
-	spin_unlock(&inactive_ts_lock);
-	if (thread_sets_add == 1)
-		iscsi_allocate_thread_sets(1);
-}
-
-static int iscsi_signal_thread_pre_handler(struct iscsi_thread_set *ts)
-{
-	spin_lock_bh(&ts->ts_state_lock);
-	if (ts->status == ISCSI_THREAD_SET_DIE || kthread_should_stop() ||
-	    signal_pending(current)) {
-		spin_unlock_bh(&ts->ts_state_lock);
-		return -1;
-	}
-	spin_unlock_bh(&ts->ts_state_lock);
-
-	return 0;
-}
-
-struct iscsi_conn *iscsi_rx_thread_pre_handler(struct iscsi_thread_set *ts)
-{
-	int ret;
-
-	spin_lock_bh(&ts->ts_state_lock);
-	if (ts->create_threads) {
-		spin_unlock_bh(&ts->ts_state_lock);
-		goto sleep;
-	}
-
-	if (ts->status != ISCSI_THREAD_SET_DIE)
-		flush_signals(current);
-
-	if (ts->delay_inactive && (--ts->thread_count == 0)) {
-		spin_unlock_bh(&ts->ts_state_lock);
-
-		if (!iscsit_global->in_shutdown)
-			iscsi_deallocate_extra_thread_sets();
-
-		iscsi_add_ts_to_inactive_list(ts);
-		spin_lock_bh(&ts->ts_state_lock);
-	}
-
-	if ((ts->status == ISCSI_THREAD_SET_RESET) &&
-	    (ts->thread_clear & ISCSI_CLEAR_RX_THREAD))
-		complete(&ts->rx_restart_comp);
-
-	ts->thread_clear &= ~ISCSI_CLEAR_RX_THREAD;
-	spin_unlock_bh(&ts->ts_state_lock);
-sleep:
-	ret = wait_for_completion_interruptible(&ts->rx_start_comp);
-	if (ret != 0)
-		return NULL;
-
-	if (iscsi_signal_thread_pre_handler(ts) < 0)
-		return NULL;
-
-	iscsi_check_to_add_additional_sets();
-
-	spin_lock_bh(&ts->ts_state_lock);
-	if (!ts->conn) {
-		pr_err("struct iscsi_thread_set->conn is NULL for"
-			" RX thread_id: %s/%d\n", current->comm, current->pid);
-		spin_unlock_bh(&ts->ts_state_lock);
-		return NULL;
-	}
-	ts->thread_clear |= ISCSI_CLEAR_RX_THREAD;
-	spin_unlock_bh(&ts->ts_state_lock);
-
-	up(&ts->ts_activate_sem);
-
-	return ts->conn;
-}
-
-struct iscsi_conn *iscsi_tx_thread_pre_handler(struct iscsi_thread_set *ts)
-{
-	int ret;
-
-	spin_lock_bh(&ts->ts_state_lock);
-	if (ts->create_threads) {
-		spin_unlock_bh(&ts->ts_state_lock);
-		goto sleep;
-	}
-
-	if (ts->status != ISCSI_THREAD_SET_DIE)
-		flush_signals(current);
-
-	if (ts->delay_inactive && (--ts->thread_count == 0)) {
-		spin_unlock_bh(&ts->ts_state_lock);
-
-		if (!iscsit_global->in_shutdown)
-			iscsi_deallocate_extra_thread_sets();
-
-		iscsi_add_ts_to_inactive_list(ts);
-		spin_lock_bh(&ts->ts_state_lock);
-	}
-	if ((ts->status == ISCSI_THREAD_SET_RESET) &&
-	    (ts->thread_clear & ISCSI_CLEAR_TX_THREAD))
-		complete(&ts->tx_restart_comp);
-
-	ts->thread_clear &= ~ISCSI_CLEAR_TX_THREAD;
-	spin_unlock_bh(&ts->ts_state_lock);
-sleep:
-	ret = wait_for_completion_interruptible(&ts->tx_start_comp);
-	if (ret != 0)
-		return NULL;
-
-	if (iscsi_signal_thread_pre_handler(ts) < 0)
-		return NULL;
-
-	iscsi_check_to_add_additional_sets();
-
-	spin_lock_bh(&ts->ts_state_lock);
-	if (!ts->conn) {
-		pr_err("struct iscsi_thread_set->conn is NULL for"
-			" TX thread_id: %s/%d\n", current->comm, current->pid);
-		spin_unlock_bh(&ts->ts_state_lock);
-		return NULL;
-	}
-	ts->thread_clear |= ISCSI_CLEAR_TX_THREAD;
-	spin_unlock_bh(&ts->ts_state_lock);
-
-	up(&ts->ts_activate_sem);
-
-	return ts->conn;
-}
-
-int iscsi_thread_set_init(void)
-{
-	int size;
-
-	iscsit_global->ts_bitmap_count = ISCSI_TS_BITMAP_BITS;
-
-	size = BITS_TO_LONGS(iscsit_global->ts_bitmap_count) * sizeof(long);
-	iscsit_global->ts_bitmap = kzalloc(size, GFP_KERNEL);
-	if (!iscsit_global->ts_bitmap) {
-		pr_err("Unable to allocate iscsit_global->ts_bitmap\n");
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
-void iscsi_thread_set_free(void)
-{
-	kfree(iscsit_global->ts_bitmap);
-}
diff --git a/drivers/target/iscsi/iscsi_target_tq.h b/drivers/target/iscsi/iscsi_target_tq.h
deleted file mode 100644
index cc1eede..0000000
--- a/drivers/target/iscsi/iscsi_target_tq.h
+++ /dev/null
@@ -1,84 +0,0 @@
-#ifndef ISCSI_THREAD_QUEUE_H
-#define ISCSI_THREAD_QUEUE_H
-
-/*
- * Defines for thread sets.
- */
-extern int iscsi_thread_set_force_reinstatement(struct iscsi_conn *);
-extern int iscsi_allocate_thread_sets(u32);
-extern void iscsi_deallocate_thread_sets(void);
-extern void iscsi_activate_thread_set(struct iscsi_conn *, struct iscsi_thread_set *);
-extern struct iscsi_thread_set *iscsi_get_thread_set(void);
-extern void iscsi_set_thread_clear(struct iscsi_conn *, u8);
-extern void iscsi_set_thread_set_signal(struct iscsi_conn *, u8);
-extern int iscsi_release_thread_set(struct iscsi_conn *);
-extern struct iscsi_conn *iscsi_rx_thread_pre_handler(struct iscsi_thread_set *);
-extern struct iscsi_conn *iscsi_tx_thread_pre_handler(struct iscsi_thread_set *);
-extern int iscsi_thread_set_init(void);
-extern void iscsi_thread_set_free(void);
-
-extern int iscsi_target_tx_thread(void *);
-extern int iscsi_target_rx_thread(void *);
-
-#define TARGET_THREAD_SET_COUNT			4
-
-#define ISCSI_RX_THREAD                         1
-#define ISCSI_TX_THREAD                         2
-#define ISCSI_RX_THREAD_NAME			"iscsi_trx"
-#define ISCSI_TX_THREAD_NAME			"iscsi_ttx"
-#define ISCSI_BLOCK_RX_THREAD			0x1
-#define ISCSI_BLOCK_TX_THREAD			0x2
-#define ISCSI_CLEAR_RX_THREAD			0x1
-#define ISCSI_CLEAR_TX_THREAD			0x2
-#define ISCSI_SIGNAL_RX_THREAD			0x1
-#define ISCSI_SIGNAL_TX_THREAD			0x2
-
-/* struct iscsi_thread_set->status */
-#define ISCSI_THREAD_SET_FREE			1
-#define ISCSI_THREAD_SET_ACTIVE			2
-#define ISCSI_THREAD_SET_DIE			3
-#define ISCSI_THREAD_SET_RESET			4
-#define ISCSI_THREAD_SET_DEALLOCATE_THREADS	5
-
-/* By default allow a maximum of 32K iSCSI connections */
-#define ISCSI_TS_BITMAP_BITS			32768
-
-struct iscsi_thread_set {
-	/* flags used for blocking and restarting sets */
-	int	blocked_threads;
-	/* flag for creating threads */
-	int	create_threads;
-	/* flag for delaying readding to inactive list */
-	int	delay_inactive;
-	/* status for thread set */
-	int	status;
-	/* which threads have had signals sent */
-	int	signal_sent;
-	/* flag for which threads exited first */
-	int	thread_clear;
-	/* Active threads in the thread set */
-	int	thread_count;
-	/* Unique thread ID */
-	u32	thread_id;
-	/* pointer to connection if set is active */
-	struct iscsi_conn	*conn;
-	/* used for controlling ts state accesses */
-	spinlock_t	ts_state_lock;
-	/* used for restarting thread queue */
-	struct completion	rx_restart_comp;
-	/* used for restarting thread queue */
-	struct completion	tx_restart_comp;
-	/* used for normal unused blocking */
-	struct completion	rx_start_comp;
-	/* used for normal unused blocking */
-	struct completion	tx_start_comp;
-	/* OS descriptor for rx thread */
-	struct task_struct	*rx_thread;
-	/* OS descriptor for tx thread */
-	struct task_struct	*tx_thread;
-	/* struct iscsi_thread_set in list list head*/
-	struct list_head	ts_list;
-	struct semaphore	ts_activate_sem;
-};
-
-#endif   /*** ISCSI_THREAD_QUEUE_H ***/
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 390df8e..b18edda 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -33,7 +33,6 @@
 #include "iscsi_target_erl1.h"
 #include "iscsi_target_erl2.h"
 #include "iscsi_target_tpg.h"
-#include "iscsi_target_tq.h"
 #include "iscsi_target_util.h"
 #include "iscsi_target.h"
 
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index dd0f3ab..0e394a0 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -20,6 +20,8 @@
 #define ISCSIT_MIN_TAGS			16
 #define ISCSIT_EXTRA_TAGS		8
 #define ISCSIT_TCP_BACKLOG		256
+#define ISCSI_RX_THREAD_NAME		"iscsi_trx"
+#define ISCSI_TX_THREAD_NAME		"iscsi_ttx"
 
 /* struct iscsi_node_attrib sanity values */
 #define NA_DATAOUT_TIMEOUT		3
@@ -600,8 +602,6 @@ struct iscsi_conn {
 	struct iscsi_tpg_np	*tpg_np;
 	/* Pointer to parent session */
 	struct iscsi_session	*sess;
-	/* Pointer to thread_set in use for this conn's threads */
-	struct iscsi_thread_set	*thread_set;
 	int			bitmap_id;
 	int			rx_thread_active;
 	struct task_struct	*rx_thread;
@@ -877,8 +877,6 @@ struct iscsit_global {
 	u32			auth_id;
 	u32			inactive_ts;
 #define ISCSIT_BITMAP_BITS	262144
-	/* Thread Set bitmap count */
-	int			ts_bitmap_count;
 	/* Thread Set bitmap pointer */
 	unsigned long		*ts_bitmap;
 	spinlock_t		ts_bitmap_lock;
-- 
1.9.1
