From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: Fix target_sense_desc_format NULL pointer
 dereference
Date: Wed, 16 Sep 2015 21:04:12 -0700
Message-ID: <1442462652.23132.25.camel@haakon3.risingtidesystems.com>
References: <1442385079-749-1-git-send-email-nab@daterainc.com>
	 <55F95BC2.8090104@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <55F95BC2.8090104@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-09-16 at 15:08 +0300, Sagi Grimberg wrote:
> On 9/16/2015 9:31 AM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> >
> > This patch allows target_sense_desc_format() to be called without a
> > valid se_device pointer, which can occur during an early exception
> > ahead of transport_lookup_cmd_lun() setting up se_cmd->se_device.
> >
> > This addresses a v4.3-rc1 specific NULL pointer dereference
> > regression introduced by commit 4e4937e8.
> >
> > Cc: Sagi Grimberg <sagig@mellanox.com>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Hannes Reinecke <hare@suse.de>
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > ---
> >   drivers/target/target_core_hba.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
> > index 9522960..22390e0 100644
> > --- a/drivers/target/target_core_hba.c
> > +++ b/drivers/target/target_core_hba.c
> > @@ -187,5 +187,5 @@ core_delete_hba(struct se_hba *hba)
> >
> >   bool target_sense_desc_format(struct se_device *dev)
> >   {
> > -	return dev->transport->get_blocks(dev) > U32_MAX;
> > +	return (dev) ? dev->transport->get_blocks(dev) > U32_MAX : false;
> >   }
> >
> 
> Can we be sure that the only case we'll call target_sense_desc_format()
> with a NULL se_device will be when returning a CHECK_CONDITION on a
> non-existing LUN?

WRITE_PROTECTED returns with a NULL se_device pointer as well.

> 
> We return the sense format in the D_SENSE of the control modepage
> response and if some future bug will happen to call this function with
> a NULL se_device we might violate what we reported to the initiator.
> 
> Maybe we should enforce this by having transport_lookup_cmd_lun() set
> se_cmd->se_device = TARGET_NON_EXISTENT_LUN reserved identifier and 
> check for that rather then NULL?
> 

No objection.

> 
> Thoughts?

How about the following to fix up TCM_WRITE_PROTECT + D_SENSE..?

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index abf2076..ba102c5 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -62,22 +62,13 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd, u64 unpacked_lun)
 	struct se_session *se_sess = se_cmd->se_sess;
 	struct se_node_acl *nacl = se_sess->se_node_acl;
 	struct se_dev_entry *deve;
+	sense_reason_t ret = TCM_NO_SENSE;
 
 	rcu_read_lock();
 	deve = target_nacl_find_deve(nacl, unpacked_lun);
 	if (deve) {
 		atomic_long_inc(&deve->total_cmds);
 
-		if ((se_cmd->data_direction == DMA_TO_DEVICE) &&
-		    (deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY)) {
-			pr_err("TARGET_CORE[%s]: Detected WRITE_PROTECTED LUN"
-				" Access for 0x%08llx\n",
-				se_cmd->se_tfo->get_fabric_name(),
-				unpacked_lun);
-			rcu_read_unlock();
-			return TCM_WRITE_PROTECTED;
-		}
-
 		if (se_cmd->data_direction == DMA_TO_DEVICE)
 			atomic_long_add(se_cmd->data_length,
 					&deve->write_bytes);
@@ -93,6 +84,17 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd, u64 unpacked_lun)
 
 		percpu_ref_get(&se_lun->lun_ref);
 		se_cmd->lun_ref_active = true;
+
+		if ((se_cmd->data_direction == DMA_TO_DEVICE) &&
+		    (deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY)) {
+			pr_err("TARGET_CORE[%s]: Detected WRITE_PROTECTED LUN"
+				" Access for 0x%08llx\n",
+				se_cmd->se_tfo->get_fabric_name(),
+				unpacked_lun);
+			rcu_read_unlock();
+			ret = TCM_WRITE_PROTECTED;	
+			goto ref_dev;
+		}
 	}
 	rcu_read_unlock();
 
@@ -109,12 +111,6 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd, u64 unpacked_lun)
 				unpacked_lun);
 			return TCM_NON_EXISTENT_LUN;
 		}
-		/*
-		 * Force WRITE PROTECT for virtual LUN 0
-		 */
-		if ((se_cmd->data_direction != DMA_FROM_DEVICE) &&
-		    (se_cmd->data_direction != DMA_NONE))
-			return TCM_WRITE_PROTECTED;
 
 		se_lun = se_sess->se_tpg->tpg_virt_lun0;
 		se_cmd->se_lun = se_sess->se_tpg->tpg_virt_lun0;
@@ -123,6 +119,15 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd, u64 unpacked_lun)
 
 		percpu_ref_get(&se_lun->lun_ref);
 		se_cmd->lun_ref_active = true;
+
+		/*
+		 * Force WRITE PROTECT for virtual LUN 0
+		 */
+		if ((se_cmd->data_direction != DMA_FROM_DEVICE) &&
+		    (se_cmd->data_direction != DMA_NONE)) {
+			ret = TCM_WRITE_PROTECTED;
+			goto ref_dev;
+		}
 	}
 	/*
 	 * RCU reference protected by percpu se_lun->lun_ref taken above that
@@ -130,6 +135,7 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd, u64 unpacked_lun)
 	 * pointer can be kfree_rcu() by the final se_lun->lun_group put via
 	 * target_core_fabric_configfs.c:target_fabric_port_release
 	 */
+ref_dev:
 	se_cmd->se_dev = rcu_dereference_raw(se_lun->lun_se_dev);
 	atomic_long_inc(&se_cmd->se_dev->num_cmds);
 
@@ -140,7 +146,7 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd, u64 unpacked_lun)
 		atomic_long_add(se_cmd->data_length,
 				&se_cmd->se_dev->read_bytes);
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(transport_lookup_cmd_lun);
