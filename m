From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 6/6] target: Send UA when changing LUN inventory
Date: Tue, 23 Jun 2015 00:56:12 -0700
Message-ID: <1435046172.7460.26.camel@haakon3.risingtidesystems.com>
References: <1434009689-112909-1-git-send-email-hare@suse.de>
	 <1434009689-112909-7-git-send-email-hare@suse.de>
	 <20150619130733.GC7783@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150619130733.GC7783@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>, Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2015-06-19 at 15:07 +0200, Christoph Hellwig wrote:
> > +		hlist_for_each_entry_rcu(tmp, &nacl->lun_entry_hlist, link) {
> > +			if (tmp == new)
> > +				continue;
> > +			core_scsi3_ua_allocate(tmp, 0x3F,
> > +				ASCQ_3FH_REPORTED_LUNS_DATA_HAS_CHANGED);
> > +		}
> > +		rcu_read_unlock();
> > +
> 
> > +	rcu_read_lock();
> > +	hlist_for_each_entry_rcu(tmp, &nacl->lun_entry_hlist, link) {
> > +		if (tmp == new)
> > +			continue;
> > +		core_scsi3_ua_allocate(tmp, 0x3F,
> > +			ASCQ_3FH_REPORTED_LUNS_DATA_HAS_CHANGED);
> > +	}
> > +	rcu_read_unlock();
> 
> > +
> > +	rcu_read_lock();
> > +	hlist_for_each_entry_rcu(tmp, &nacl->lun_entry_hlist, link)
> > +		core_scsi3_ua_allocate(tmp, 0x3F,
> > +			ASCQ_3FH_REPORTED_LUNS_DATA_HAS_CHANGED);
> > +	rcu_read_unlock();
> 
> Please add a helper instead of duplicating this three times.

<nod>

Applying the following squashed commit:

>From 7c0d0d51d26497866d2951a35f1736fc765e4fcf Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.de>
Date: Thu, 11 Jun 2015 10:01:29 +0200
Subject: [PATCH 68/76] target: Send UA when changing LUN inventory

When changind the LUN inventory via core_enable_device_list_for_node()
or core_disable_device_list_for_node() a REPORTED LUNS DATA HAS CHANGED
UA should be send.

(Convert to target_luns_data_has_changed helper usage - hch)

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c | 23 +++++++++++++++++++----
 drivers/target/target_core_ua.h     |  1 +
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index b6df5b9..5244848 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -293,10 +293,22 @@ void target_pr_kref_release(struct kref *kref)
 	complete(&deve->pr_comp);
 }
 
-/*      core_enable_device_list_for_node():
- *
- *
- */
+static void
+target_luns_data_has_changed(struct se_node_acl *nacl, struct se_dev_entry *new,
+			     bool skip_new)
+{
+	struct se_dev_entry *tmp;
+
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(tmp, &nacl->lun_entry_hlist, link) {
+		if (skip_new && tmp == new)
+			continue;
+		core_scsi3_ua_allocate(tmp, 0x3F,
+				       ASCQ_3FH_REPORTED_LUNS_DATA_HAS_CHANGED);
+	}
+	rcu_read_unlock();
+}
+
 int core_enable_device_list_for_node(
 	struct se_lun *lun,
 	struct se_lun_acl *lun_acl,
@@ -360,6 +372,7 @@ int core_enable_device_list_for_node(
 		kref_put(&orig->pr_kref, target_pr_kref_release);
 		wait_for_completion(&orig->pr_comp);
 
+		target_luns_data_has_changed(nacl, new, true);
 		kfree_rcu(orig, rcu_head);
 		return 0;
 	}
@@ -373,6 +386,7 @@ int core_enable_device_list_for_node(
 	list_add_tail(&new->lun_link, &lun->lun_deve_list);
 	spin_unlock(&lun->lun_deve_lock);
 
+	target_luns_data_has_changed(nacl, new, true);
 	return 0;
 }
 
@@ -428,6 +442,7 @@ void core_disable_device_list_for_node(
 	kfree_rcu(orig, rcu_head);
 
 	core_scsi3_free_pr_reg_from_nacl(dev, nacl);
+	target_luns_data_has_changed(nacl, NULL, false);
 }
 
 /*      core_clear_lun_from_tpg():
diff --git a/drivers/target/target_core_ua.h b/drivers/target/target_core_ua.h
index 59278d6..bd6e78b 100644
--- a/drivers/target/target_core_ua.h
+++ b/drivers/target/target_core_ua.h
@@ -26,6 +26,7 @@
 #define ASCQ_2CH_PREVIOUS_RESERVATION_CONFLICT_STATUS		0x09
 
 #define ASCQ_3FH_INQUIRY_DATA_HAS_CHANGED			0x03
+#define ASCQ_3FH_REPORTED_LUNS_DATA_HAS_CHANGED			0x0E
 
 extern struct kmem_cache *se_ua_cache;
 
-- 
1.9.1
