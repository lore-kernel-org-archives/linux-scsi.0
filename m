From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 39/42] target: Call transport_new_cmd instead of adding
	to cmd queue
Date: Tue, 31 May 2011 03:10:41 -0700
Message-ID: <1306836641.8193.185.camel@haakon2.linux-iscsi.org>
References: <1306523240-15543-1-git-send-email-agrover@redhat.com>
	 <1306523240-15543-40-git-send-email-agrover@redhat.com>
	 <1306834367.8193.169.camel@haakon2.linux-iscsi.org>
	 <20110531094800.GA31240@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:52705 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab1EaKTF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2011 06:19:05 -0400
In-Reply-To: <20110531094800.GA31240@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-iscsi-target-dev@googlegroups.com, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2011-05-31 at 11:48 +0200, Christoph Hellwig wrote:
> On Tue, May 31, 2011 at 02:32:47AM -0700, Nicholas A. Bellinger wrote:
> > -static void transport_add_cmd_to_queue(
> > +static int transport_add_cmd_to_queue(
> >         struct se_cmd *cmd,
> >         int t_state)
> >  {
> > @@ -775,6 +776,8 @@ static void transport_add_cmd_to_queue(
> > 
> >         atomic_inc(&qobj->queue_cnt);
> >         wake_up_interruptible(&qobj->thread_wq);
> > +
> > +       return 0;
> >  }
> > 
> >  static struct se_cmd *
> > @@ -1847,9 +1850,14 @@ int transport_generic_handle_cdb(
> >                 printk(KERN_ERR "cmd->se_lun is NULL\n");
> >                 return -EINVAL;
> >         }
> > -
> > -       transport_add_cmd_to_queue(cmd, TRANSPORT_NEW_CMD);
> > -       return 0;
> > +       /*
> > +        * Assume that target fabrics not presenting an cmd->se_tfo->new_cmd_map
> > +        * function pointer (like iscsi-target) want direct execution of
> > +        * transport_generic_new_cmd()
> > +        */
> > +       return (cmd->se_tfo->new_cmd_map) ?
> > +               transport_add_cmd_to_queue(cmd, TRANSPORT_NEW_CMD) :
> > +               transport_generic_new_cmd(cmd);
> >  }
> 
> This it too ugly to live, please revert it.
> 
> The proper way to do it is to simply mark transport_generic_new_cmd
> non-static and call it directly from the iscsi code.
> 

<nod>, rebased patch #39 to the following commit.

Thanks,

--nab

---------------------------------------------------------------------

[PATCH] target: Make transport_generic_new_cmd() available for iscsi-target

This patch makes transport_generic_new_cmd() defined as EXPORT_SYMBOL()
for use with iscsi-target direct task allocation.  It then changes
iscsi-target to use this direct method instead of the legacy
transport_generic_handle_cdb() queue usage.

Signed-off-by: Andy Grover <agrover@redhat.com>
Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c    |    2 +-
 drivers/target/target_core_transport.c |    4 ++--
 include/target/target_core_transport.h |    1 +
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index bf4261e..16be7b7 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1118,7 +1118,7 @@ attach_cmd:
         * the underlying transport plugin has allocated the buffer to
         * receive the Immediate Write Data into.
         */
-       transport_generic_handle_cdb(SE_CMD(cmd));
+       transport_generic_new_cmd(SE_CMD(cmd));

        wait_for_completion(&cmd->unsolicited_data_comp);

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 915b2ef..5a689fd 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1847,7 +1847,6 @@ int transport_generic_handle_cdb(
                printk(KERN_ERR "cmd->se_lun is NULL\n");
                return -EINVAL;
        }
-
        transport_add_cmd_to_queue(cmd, TRANSPORT_NEW_CMD);
        return 0;
 }
@@ -4754,7 +4753,7 @@ transport_map_control_cmd_to_task(struct se_cmd *cmd)
        /*
         * Generate struct se_task(s) and/or their payloads for this CDB.
         */
-static int transport_generic_new_cmd(struct se_cmd *cmd)
+int transport_generic_new_cmd(struct se_cmd *cmd)
 {
        struct se_portal_group *se_tpg;
        struct se_task *task;
@@ -4824,6 +4823,7 @@ static int transport_generic_new_cmd(struct se_cmd *cmd)
        transport_execute_tasks(cmd);
        return 0;
 }
+EXPORT_SYMBOL(transport_generic_new_cmd);


