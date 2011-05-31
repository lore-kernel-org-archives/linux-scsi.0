From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 39/42] target: Call transport_new_cmd instead of adding
	to cmd queue
Date: Tue, 31 May 2011 02:32:47 -0700
Message-ID: <1306834367.8193.169.camel@haakon2.linux-iscsi.org>
References: <1306523240-15543-1-git-send-email-agrover@redhat.com>
	 <1306523240-15543-40-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:52608 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab1EaJlM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2011 05:41:12 -0400
In-Reply-To: <1306523240-15543-40-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-iscsi-target-dev@googlegroups.com
Cc: target-devel <target-devel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2011-05-27 at 12:07 -0700, Andy Grover wrote:
> This will cause transport_new_cmd to be executed in the calling thread's
> context, instead of the backstore thread's context. This saves two
> context switches per cmd.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---

As Christoph mentioned earler, this original patch to enable your
iscsi-target optimization series breaks all non iscsi-target fabrics.
But hey, that is easy enough for me to fix now.  ;-)

Committed as 5bb520f61 with the following changes to skip patch #25/#26
for the wholesale target_*() naming for the moment, and make your
original change here optional based upon TFO->new_cmd_map() usage for
other fabric modules.

Thanks again Andy,

--nab

-----------------------------------------------------------------------

[PATCH] target: Add optional transport_generic_new_cmd instead of adding to cmd queue

This will cause transport_generic_new_cmd() to be optionally executed in the calling
thread's context, instead of the backstore thread's context.  This saves two
context switches per cmd, and assumes that fabric modules (like iscsi-target) who
do not provide a struct target_core_fabric_ops->new_cmd_map() in order to work
with existing non iscsi-target fabric modules.

Signed-off-by: Andy Grover <agrover@redhat.com>
Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 915b2ef..7596f6f 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -203,6 +203,7 @@ typedef int (*map_func_t)(struct se_task *, u32);

 static int transport_generic_write_pending(struct se_cmd *);
 static int transport_processing_thread(void *param);
+static int transport_generic_new_cmd(struct se_cmd *cmd);
 static int __transport_execute_tasks(struct se_device *dev);
 static void transport_complete_task_attr(struct se_cmd *cmd);
 static void transport_direct_request_timeout(struct se_cmd *cmd);
@@ -751,7 +752,7 @@ void transport_cmd_finish_abort_tmr(struct se_cmd *cmd)
        transport_generic_remove(cmd, 0, 0);
 }

-static void transport_add_cmd_to_queue(
+static int transport_add_cmd_to_queue(
        struct se_cmd *cmd,
        int t_state)
 {
@@ -775,6 +776,8 @@ static void transport_add_cmd_to_queue(

        atomic_inc(&qobj->queue_cnt);
        wake_up_interruptible(&qobj->thread_wq);
+
+       return 0;
 }

 static struct se_cmd *
@@ -1847,9 +1850,14 @@ int transport_generic_handle_cdb(
                printk(KERN_ERR "cmd->se_lun is NULL\n");
                return -EINVAL;
        }
-
-       transport_add_cmd_to_queue(cmd, TRANSPORT_NEW_CMD);
-       return 0;
+       /*
+        * Assume that target fabrics not presenting an cmd->se_tfo->new_cmd_map
+        * function pointer (like iscsi-target) want direct execution of
+        * transport_generic_new_cmd()
+        */
+       return (cmd->se_tfo->new_cmd_map) ?
+               transport_add_cmd_to_queue(cmd, TRANSPORT_NEW_CMD) :
+               transport_generic_new_cmd(cmd);
 }
 EXPORT_SYMBOL(transport_generic_handle_cdb);

-- 
1.7.2.5





