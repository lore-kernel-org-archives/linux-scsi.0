From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/12] target: Convert se_node_acl->device_list[] to
	RCU hlist
Date: Thu, 21 May 2015 19:03:09 +0200
Message-ID: <20150521170309.GA1172@lst.de>
References: <1431422736-29125-1-git-send-email-nab@daterainc.com> <1431422736-29125-2-git-send-email-nab@daterainc.com> <20150513063555.GA21770@lst.de> <1431506771.26897.78.camel@haakon3.risingtidesystems.com> <20150517165142.GA17217@lst.de> <1431933444.24645.7.camel@haakon3.risingtidesystems.com> <20150518074102.GA6157@lst.de> <20150518080155.GA6451@lst.de> <1432015547.9093.76.camel@haakon3.risingtidesystems.com> <20150519062231.GB29468@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150519062231.GB29468@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, May 19, 2015 at 08:22:31AM +0200, Christoph Hellwig wrote:
> On Mon, May 18, 2015 at 11:05:47PM -0700, Nicholas A. Bellinger wrote:
> > > [   12.830576] kernel BUG at ../drivers/target/target_core_device.c:337!
> > > 
> > 
> > How did you hit this..?
> 
> tcm_node --block iblock_0/array /dev/sda
> 
> line=$(tcm_loop --createnexus=0)
> wwn=$(echo $line | awk '{print $15}')
> tcm_loop --addlun=$wwn 0 0 iblock_0/array

And here is the fix.  Seems like anything using dynamic node ACLs was
broken the same way (I could reproduce it with vhost as well).

I don't really like how HBA_FLAGS_INTERNAL_USE means this is a virtual
lun0, so I'll send another patch to replace it with a per-device flag
eventually.

---
>From 9fd0e75cffde876b84b08952cc7f026d4e08d77a Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Thu, 21 May 2015 18:58:21 +0200
Subject: target: don't add lun0 to tpg_lun_hlist

We never want to find the virtual lun0 when looking up a lun on the TPG,
otherwise the core code gets really confused.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_tpg.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index b8c2a32..ced1dd6 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -647,7 +647,8 @@ int core_tpg_add_lun(
 
 	lun->lun_access = lun_access;
 	lun->lun_status = TRANSPORT_LUN_STATUS_ACTIVE;
-	hlist_add_head_rcu(&lun->link, &tpg->tpg_lun_hlist);
+	if (!(dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE))
+		hlist_add_head_rcu(&lun->link, &tpg->tpg_lun_hlist);
 
 	mutex_unlock(&tpg->tpg_lun_mutex);
 
@@ -687,7 +688,8 @@ void core_tpg_remove_lun(
 	}
 
 	lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
-	hlist_del_rcu(&lun->link);
+	if (!(dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE))
+		hlist_del_rcu(&lun->link);
 	mutex_unlock(&tpg->tpg_lun_mutex);
 
 	percpu_ref_exit(&lun->lun_ref);
-- 
1.9.1
