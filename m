From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 4/6] target: Send UA on ALUA target port group change
Date: Tue, 23 Jun 2015 00:54:24 -0700
Message-ID: <1435046064.7460.23.camel@haakon3.risingtidesystems.com>
References: <1434009689-112909-1-git-send-email-hare@suse.de>
	 <1434009689-112909-5-git-send-email-hare@suse.de>
	 <20150619130519.GA7783@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150619130519.GA7783@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>, Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2015-06-19 at 15:05 +0200, Christoph Hellwig wrote:
> > --- a/drivers/target/target_core_alua.c
> > +++ b/drivers/target/target_core_alua.c
> > @@ -1880,12 +1880,19 @@ static void core_alua_put_tg_pt_gp_from_name(
> >  static void __target_attach_tg_pt_gp(struct se_lun *lun,
> >  		struct t10_alua_tg_pt_gp *tg_pt_gp)
> >  {
> > +	struct se_dev_entry *se_deve;
> > +
> >  	assert_spin_locked(&lun->lun_tg_pt_gp_lock);
> >  
> >  	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
> >  	lun->lun_tg_pt_gp = tg_pt_gp;
> >  	list_add_tail(&lun->lun_tg_pt_gp_link, &tg_pt_gp->tg_pt_gp_lun_list);
> >  	tg_pt_gp->tg_pt_gp_members++;
> > +	spin_lock_bh(&lun->lun_deve_lock);
> > +	list_for_each_entry(se_deve, &lun->lun_deve_list, lun_link)
> > +		core_scsi3_ua_allocate(se_deve, 0x3f,
> > +				       ASCQ_3FH_INQUIRY_DATA_HAS_CHANGED);
> > +	spin_unlock_bh(&lun->lun_deve_lock);
> >  	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
> 
> Taking a _bh lock inside a regular spinlock is completely broken.
> 

...

> Fortunately I don't think lun_deve_lock needs to disable bottom halves,
> but this needs to be fixed first.

<nod>

Applying the following + updating this original patch to use normal
spinlock_t access.

>From 1adff1b3a7f75a1c255b7fcab5676edf29d4a5d8 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Mon, 22 Jun 2015 23:44:05 -0700
Subject: [PATCH 65/76] target: Convert se_lun->lun_deve_lock to normal
 spinlock

This patch converts se_lun->lun_deve_lock acquire/release access
to use a normal, non bottom-half spin_lock_t for protecting
se_lun->lun_deve_list access.

Reported-by: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_alua.c   |  4 ++--
 drivers/target/target_core_device.c | 12 ++++++------
 drivers/target/target_core_pr.c     |  8 ++++----
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index aa2e4b1..c56ae02 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -968,7 +968,7 @@ static void core_alua_queue_state_change_ua(struct t10_alua_tg_pt_gp *tg_pt_gp)
 			continue;
 		spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
 
-		spin_lock_bh(&lun->lun_deve_lock);
+		spin_lock(&lun->lun_deve_lock);
 		list_for_each_entry(se_deve, &lun->lun_deve_list, lun_link) {
 			lacl = rcu_dereference_check(se_deve->se_lun_acl,
 					lockdep_is_held(&lun->lun_deve_lock));
@@ -1000,7 +1000,7 @@ static void core_alua_queue_state_change_ua(struct t10_alua_tg_pt_gp *tg_pt_gp)
 			core_scsi3_ua_allocate(se_deve, 0x2A,
 				ASCQ_2AH_ASYMMETRIC_ACCESS_STATE_CHANGED);
 		}
-		spin_unlock_bh(&lun->lun_deve_lock);
+		spin_unlock(&lun->lun_deve_lock);
 
 		spin_lock(&tg_pt_gp->tg_pt_gp_lock);
 		percpu_ref_put(&lun->lun_ref);
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index ed08402..b6df5b9 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -352,10 +352,10 @@ int core_enable_device_list_for_node(
 		hlist_add_head_rcu(&new->link, &nacl->lun_entry_hlist);
 		mutex_unlock(&nacl->lun_entry_mutex);
 
-		spin_lock_bh(&lun->lun_deve_lock);
+		spin_lock(&lun->lun_deve_lock);
 		list_del(&orig->lun_link);
 		list_add_tail(&new->lun_link, &lun->lun_deve_list);
-		spin_unlock_bh(&lun->lun_deve_lock);
+		spin_unlock(&lun->lun_deve_lock);
 
 		kref_put(&orig->pr_kref, target_pr_kref_release);
 		wait_for_completion(&orig->pr_comp);
@@ -369,9 +369,9 @@ int core_enable_device_list_for_node(
 	hlist_add_head_rcu(&new->link, &nacl->lun_entry_hlist);
 	mutex_unlock(&nacl->lun_entry_mutex);
 
-	spin_lock_bh(&lun->lun_deve_lock);
+	spin_lock(&lun->lun_deve_lock);
 	list_add_tail(&new->lun_link, &lun->lun_deve_list);
-	spin_unlock_bh(&lun->lun_deve_lock);
+	spin_unlock(&lun->lun_deve_lock);
 
 	return 0;
 }
@@ -403,9 +403,9 @@ void core_disable_device_list_for_node(
 	 * NodeACL context specific PR metadata for demo-mode
 	 * MappedLUN *deve will be released below..
 	 */
-	spin_lock_bh(&lun->lun_deve_lock);
+	spin_lock(&lun->lun_deve_lock);
 	list_del(&orig->lun_link);
-	spin_unlock_bh(&lun->lun_deve_lock);
+	spin_unlock(&lun->lun_deve_lock);
 	/*
 	 * Disable struct se_dev_entry LUN ACL mapping
 	 */
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 0bb3292..7403b03 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -709,7 +709,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 			continue;
 		spin_unlock(&dev->se_port_lock);
 
-		spin_lock_bh(&lun_tmp->lun_deve_lock);
+		spin_lock(&lun_tmp->lun_deve_lock);
 		list_for_each_entry(deve_tmp, &lun_tmp->lun_deve_list, lun_link) {
 			/*
 			 * This pointer will be NULL for demo mode MappedLUNs
@@ -742,7 +742,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 				continue;
 
 			kref_get(&deve_tmp->pr_kref);
-			spin_unlock_bh(&lun_tmp->lun_deve_lock);
+			spin_unlock(&lun_tmp->lun_deve_lock);
 			/*
 			 * Grab a configfs group dependency that is released
 			 * for the exception path at label out: below, or upon
@@ -779,9 +779,9 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 
 			list_add_tail(&pr_reg_atp->pr_reg_atp_mem_list,
 				      &pr_reg->pr_reg_atp_list);
-			spin_lock_bh(&lun_tmp->lun_deve_lock);
+			spin_lock(&lun_tmp->lun_deve_lock);
 		}
-		spin_unlock_bh(&lun_tmp->lun_deve_lock);
+		spin_unlock(&lun_tmp->lun_deve_lock);
 
 		spin_lock(&dev->se_port_lock);
 		percpu_ref_put(&lun_tmp->lun_ref);
-- 
1.9.1
