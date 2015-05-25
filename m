From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/4] target: Drop lun_sep_lock for se_lun->lun_se_dev
 RCU usage
Date: Mon, 25 May 2015 15:59:23 -0700
Message-ID: <1432594763.722.40.camel@haakon3.risingtidesystems.com>
References: <1432278417-29994-1-git-send-email-nab@daterainc.com>
	 <1432278417-29994-3-git-send-email-nab@daterainc.com>
	 <20150522115601.GB29155@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150522115601.GB29155@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2015-05-22 at 13:56 +0200, Christoph Hellwig wrote:
> > @@ -683,7 +679,7 @@ void core_tpg_remove_lun(
> >  		dev->export_count--;
> >  		spin_unlock(&dev->se_port_lock);
> >  
> > -		lun->lun_se_dev = NULL;
> > +		rcu_assign_pointer(lun->lun_se_dev, NULL);
> >  	}
> 
> What guarantees that the se_device stays around for at least a RCU
> grace period after this assignment?

Nothing.

Since se_device is embedded in the backend driver device structure, this
currently requires that each driver do it's own call_rcu().

>From c933729d347fcb3d226500346ed06deb011e73bb Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Sat, 23 May 2015 23:35:56 -0700
Subject: [PATCH] target: Convert to backend driver call_rcu release

Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c |  1 +
 drivers/target/target_core_file.c   | 11 +++++++++--
 drivers/target/target_core_iblock.c | 10 +++++++++-
 drivers/target/target_core_pscsi.c  | 11 +++++++++--
 drivers/target/target_core_rd.c     | 10 +++++++++-
 drivers/target/target_core_stat.c   |  6 +++---
 drivers/target/target_core_user.c   | 11 +++++++++--
 include/target/target_core_base.h   |  3 +++
 8 files changed, 52 insertions(+), 11 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 50314b6..75c6324 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -733,6 +733,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	dev->se_hba = hba;
 	dev->transport = hba->backend->ops;
 	dev->prot_length = sizeof(struct se_dif_v1_tuple);
+	dev->hba_index = hba->hba_index;
 
 	INIT_LIST_HEAD(&dev->dev_list);
 	INIT_LIST_HEAD(&dev->dev_sep_list);
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 90e09ba..ac9cbf1 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -241,6 +241,14 @@ fail:
 	return ret;
 }
 
+static void fd_dev_call_rcu(struct rcu_head *p)
+{
+	struct se_device *dev = container_of(p, struct se_device, rcu_head);
+	struct fd_dev *fd_dev = FD_DEV(dev);
+
+	kfree(fd_dev);
+}
+
 static void fd_free_device(struct se_device *dev)
 {
 	struct fd_dev *fd_dev = FD_DEV(dev);
@@ -249,8 +257,7 @@ static void fd_free_device(struct se_device *dev)
 		filp_close(fd_dev->fd_file, NULL);
 		fd_dev->fd_file = NULL;
 	}
-
-	kfree(fd_dev);
+	call_rcu(&dev->rcu_head, fd_dev_call_rcu);
 }
 
 static int fd_do_rw(struct se_cmd *cmd, struct file *fd,
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index bd9dcd8..1a78e31 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -191,6 +191,14 @@ out:
 	return ret;
 }
 
+static void iblock_dev_call_rcu(struct rcu_head *p)
+{
+	struct se_device *dev = container_of(p, struct se_device, rcu_head);
+	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
+
+	kfree(ib_dev);
+}
+
 static void iblock_free_device(struct se_device *dev)
 {
 	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
@@ -200,7 +208,7 @@ static void iblock_free_device(struct se_device *dev)
 	if (ib_dev->ibd_bio_set != NULL)
 		bioset_free(ib_dev->ibd_bio_set);
 
-	kfree(ib_dev);
+	call_rcu(&dev->rcu_head, iblock_dev_call_rcu);
 }
 
 static unsigned long long iblock_emulate_read_cap_with_block_size(
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 5bc458e..c710ff0 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -578,6 +578,14 @@ static int pscsi_configure_device(struct se_device *dev)
 	return -ENODEV;
 }
 
+static void pscsi_dev_call_rcu(struct rcu_head *p)
+{
+	struct se_device *dev = container_of(p, struct se_device, rcu_head);
+	struct pscsi_dev_virt *pdv = PSCSI_DEV(dev);
+
+	kfree(pdv);
+}
+
 static void pscsi_free_device(struct se_device *dev)
 {
 	struct pscsi_dev_virt *pdv = PSCSI_DEV(dev);
@@ -607,8 +615,7 @@ static void pscsi_free_device(struct se_device *dev)
 
 		pdv->pdv_sd = NULL;
 	}
-
-	kfree(pdv);
+	call_rcu(&dev->rcu_head, pscsi_dev_call_rcu);
 }
 
 static void pscsi_transport_complete(struct se_cmd *cmd, struct scatterlist *sg,
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 5f84144..dd495b6 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -350,12 +350,20 @@ fail:
 	return ret;
 }
 
+static void rd_dev_call_rcu(struct rcu_head *p)
+{
+	struct se_device *dev = container_of(p, struct se_device, rcu_head);
+	struct rd_dev *rd_dev = RD_DEV(dev);
+
+	kfree(rd_dev);
+}
+
 static void rd_free_device(struct se_device *dev)
 {
 	struct rd_dev *rd_dev = RD_DEV(dev);
 
 	rd_release_device_space(rd_dev);
-	kfree(rd_dev);
+	call_rcu(&dev->rcu_head, rd_dev_call_rcu);
 }
 
 static struct rd_dev_sg_table *rd_get_sg_table(struct rd_dev *rd_dev, u32 page)
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index d38a18e..6d675b5 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -548,7 +548,7 @@ static ssize_t target_stat_scsi_port_show_attr_inst(
 	rcu_read_lock();
 	dev = lun->lun_se_dev;
 	if (dev)
-		ret = snprintf(page, PAGE_SIZE, "%u\n", dev->se_hba->hba_index);
+		ret = snprintf(page, PAGE_SIZE, "%u\n", dev->hba_index);
 	rcu_read_unlock();
 	return ret;
 }
@@ -667,7 +667,7 @@ static ssize_t target_stat_scsi_tgt_port_show_attr_inst(
 	rcu_read_lock();
 	dev = lun->lun_se_dev;
 	if (dev)
-		ret = snprintf(page, PAGE_SIZE, "%u\n", dev->se_hba->hba_index);
+		ret = snprintf(page, PAGE_SIZE, "%u\n", dev->hba_index);
 	rcu_read_unlock();
 	return ret;
 }
@@ -838,7 +838,7 @@ static ssize_t target_stat_scsi_transport_show_attr_inst(
 	rcu_read_lock();
 	dev = lun->lun_se_dev;
 	if (dev)
-		ret = snprintf(page, PAGE_SIZE, "%u\n", dev->se_hba->hba_index);
+		ret = snprintf(page, PAGE_SIZE, "%u\n", dev->hba_index);
 	rcu_read_unlock();
 	return ret;
 }
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index d59df02..6742e53 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -960,6 +960,14 @@ static int tcmu_check_pending_cmd(int id, void *p, void *data)
 	return -EINVAL;
 }
 
+static void tcmu_dev_call_rcu(struct rcu_head *p)
+{
+	struct se_device *dev = container_of(p, struct se_device, rcu_head);
+	struct tcmu_dev *udev = TCMU_DEV(dev);
+
+	kfree(udev);
+}
+
 static void tcmu_free_device(struct se_device *dev)
 {
 	struct tcmu_dev *udev = TCMU_DEV(dev);
@@ -985,8 +993,7 @@ static void tcmu_free_device(struct se_device *dev)
 		kfree(udev->uio_info.name);
 		kfree(udev->name);
 	}
-
-	kfree(udev);
+	call_rcu(&dev->rcu_head, tcmu_dev_call_rcu);
 }
 
 enum {
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 2b90b7f..382e591 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -822,6 +822,9 @@ struct se_device {
 	struct se_lun		xcopy_lun;
 	/* Protection Information */
 	int			prot_length;
+	/* For se_lun->lun_se_dev RCU read-side critical access */
+	u32			hba_index;
+	struct rcu_head		rcu_head;
 };
 
 struct se_hba {
