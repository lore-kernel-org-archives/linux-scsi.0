From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] scsi: libsas: Remove pcidev reference
Date: Mon, 12 Nov 2018 10:30:29 -0800
Message-ID: <31d224e8c4b9bcebc3657c17fa50302f7da90e64.camel@perches.com>
References: <1542043689-214071-1-git-send-email-john.garry@huawei.com>
         <584e7b4fcd6f95fe0c581f6f9472852685c754d1.camel@perches.com>
         <310504a2-f33c-183b-d00a-fa067b273dfd@huawei.com>
         <3b62b0ad-53ba-37c2-817c-591d94eed838@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3b62b0ad-53ba-37c2-817c-591d94eed838@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-scsi@vger.kernel.org

On Mon, 2018-11-12 at 17:55 +0000, John Garry wrote:
> On 12/11/2018 17:49, John Garry wrote:
> > On 12/11/2018 17:32, Joe Perches wrote:
> > > On Tue, 2018-11-13 at 01:28 +0800, John Garry wrote:
> > > > Not all host drivers are PCI drivers - like hisi_sas, which supports a
> > > > platform driver - so remove reference to "pcidev".
> > > > 
> > > > The debug level is also downgraded to KERN_ERR for the same message.
> > > []
> > > > diff --git a/drivers/scsi/libsas/sas_discover.c
> > > > b/drivers/scsi/libsas/sas_discover.c
> > > []
> > > > @@ -186,7 +186,7 @@ int sas_notify_lldd_dev_found(struct
> > > > domain_device *dev)
> > > > 
> > > >      res = i->dft->lldd_dev_found(dev);
> > > >      if (res) {
> > > > -        printk("sas: driver on pcidev %s cannot handle "
> > > > +        pr_err("sas: driver on host %s cannot handle "
> > > >                 "device %llx, error:%d\n",
> > > 
> > > As a printk without a KERN_<LEVEL> is printed at whatever
> > > CONFIG_MESSAGE_LOGLEVEL_DEFAULT is set to (default: 4 and
> > > rarely unchanged), this is effectively upgraded from a
> > > KERN_WARNING to KERN_ERR.
> > 
> > ah, I thought that it was printed always.
> > 
> > So maybe I'll just leave as-is.
> 
> I forgot to mention that checkpatch complains about using printk() - 
> that's why I changed it.

I believe that always assigning a KERN_<LEVEL>
is good thing so I am not against this change.

Describing the change a bit more correctly than
'debug level downgraded' would be useful.

My preference is a patch like this which
always prefixes "sas: " to each log message
by adding a #define pr_fmt and converts the
bare printks to pr_notice, and converts the
slightly odd sas_printk macro and uses with
a hidden KERN_NOTICE to pr_notice.

---
 drivers/scsi/libsas/sas_discover.c |  9 ++++-----
 drivers/scsi/libsas/sas_expander.c | 33 ++++++++++++++++-----------------
 drivers/scsi/libsas/sas_init.c     | 10 +++++-----
 drivers/scsi/libsas/sas_internal.h |  5 ++++-
 drivers/scsi/libsas/sas_phy.c      | 10 +++++-----
 drivers/scsi/libsas/sas_port.c     |  3 +--
 6 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index dde433aa59c2..193d7a1ebeb3 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -128,7 +128,8 @@ static int sas_get_port_device(struct asd_sas_port *port)
 					  SAS_FANOUT_EXPANDER_DEVICE);
 		break;
 	default:
-		printk("ERROR: Unidentified device type %d\n", dev->dev_type);
+		pr_notice("ERROR: Unidentified device type %d\n",
+			  dev->dev_type);
 		rphy = NULL;
 		break;
 	}
@@ -186,10 +187,8 @@ int sas_notify_lldd_dev_found(struct domain_device *dev)
 
 	res = i->dft->lldd_dev_found(dev);
 	if (res) {
-		printk("sas: driver on pcidev %s cannot handle "
-		       "device %llx, error:%d\n",
-		       dev_name(sas_ha->dev),
-		       SAS_ADDR(dev->sas_addr), res);
+		pr_notice("driver on pcidev %s cannot handle device %llx, error:%d\n",
+			  dev_name(sas_ha->dev), SAS_ADDR(dev->sas_addr), res);
 	}
 	set_bit(SAS_DEV_FOUND, &dev->state);
 	kref_get(&dev->kref);
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 0d1f72752ca2..922253f1b05f 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -393,7 +393,7 @@ static int sas_ex_phy_discover_helper(struct domain_device *dev, u8 *disc_req,
 		return res;
 	dr = &((struct smp_resp *)disc_resp)->disc;
 	if (memcmp(dev->sas_addr, dr->attached_sas_addr, SAS_ADDR_SIZE) == 0) {
-		sas_printk("Found loopback topology, just ignore it!\n");
+		pr_notice("Found loopback topology, just ignore it!\n");
 		return 0;
 	}
 	sas_set_ex_phy(dev, single, disc_resp);
@@ -1262,19 +1262,18 @@ static void sas_print_parent_topology_bug(struct domain_device *child,
 	};
 	struct domain_device *parent = child->parent;
 
-	sas_printk("%s ex %016llx phy 0x%x <--> %s ex %016llx "
-		   "phy 0x%x has %c:%c routing link!\n",
+	pr_notice("%s ex %016llx phy 0x%x <--> %s ex %016llx phy 0x%x has %c:%c routing link!\n",
 
-		   ex_type[parent->dev_type],
-		   SAS_ADDR(parent->sas_addr),
-		   parent_phy->phy_id,
+		  ex_type[parent->dev_type],
+		  SAS_ADDR(parent->sas_addr),
+		  parent_phy->phy_id,
 
-		   ex_type[child->dev_type],
-		   SAS_ADDR(child->sas_addr),
-		   child_phy->phy_id,
+		  ex_type[child->dev_type],
+		  SAS_ADDR(child->sas_addr),
+		  child_phy->phy_id,
 
-		   sas_route_char(parent, parent_phy),
-		   sas_route_char(child, child_phy));
+		  sas_route_char(parent, parent_phy),
+		  sas_route_char(child, child_phy));
 }
 
 static int sas_check_eeds(struct domain_device *child,
@@ -2154,23 +2153,23 @@ void sas_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
 	case SAS_FANOUT_EXPANDER_DEVICE:
 		break;
 	default:
-		printk("%s: can we send a smp request to a device?\n",
-		       __func__);
+		pr_notice("%s: can we send a smp request to a device?\n",
+			  __func__);
 		goto out;
 	}
 
 	dev = sas_find_dev_by_rphy(rphy);
 	if (!dev) {
-		printk("%s: fail to find a domain_device?\n", __func__);
+		pr_notice("%s: fail to find a domain_device?\n", __func__);
 		goto out;
 	}
 
 	/* do we need to support multiple segments? */
 	if (job->request_payload.sg_cnt > 1 ||
 	    job->reply_payload.sg_cnt > 1) {
-		printk("%s: multiple segments req %u, rsp %u\n",
-		       __func__, job->request_payload.payload_len,
-		       job->reply_payload.payload_len);
+		pr_notice("%s: multiple segments req %u, rsp %u\n",
+			  __func__, job->request_payload.payload_len,
+			  job->reply_payload.payload_len);
 		goto out;
 	}
 
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index ede0af78144f..221340ee8651 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -128,19 +128,19 @@ int sas_register_ha(struct sas_ha_struct *sas_ha)
 
 	error = sas_register_phys(sas_ha);
 	if (error) {
-		printk(KERN_NOTICE "couldn't register sas phys:%d\n", error);
+		pr_notice("couldn't register sas phys:%d\n", error);
 		return error;
 	}
 
 	error = sas_register_ports(sas_ha);
 	if (error) {
-		printk(KERN_NOTICE "couldn't register sas ports:%d\n", error);
+		pr_notice("couldn't register sas ports:%d\n", error);
 		goto Undo_phys;
 	}
 
 	error = sas_init_events(sas_ha);
 	if (error) {
-		printk(KERN_NOTICE "couldn't start event thread:%d\n", error);
+		pr_notice("couldn't start event thread:%d\n", error);
 		goto Undo_ports;
 	}
 
@@ -623,8 +623,8 @@ struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy)
 	if (atomic_read(&phy->event_nr) > phy->ha->event_thres) {
 		if (i->dft->lldd_control_phy) {
 			if (cmpxchg(&phy->in_shutdown, 0, 1) == 0) {
-				sas_printk("The phy%02d bursting events, shut it down.\n",
-					phy->id);
+				pr_notice("The phy%02d bursting events, shut it down.\n",
+					  phy->id);
 				sas_notify_phy_event(phy, PHYE_SHUTDOWN);
 			}
 		} else {
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 50e12d662ffe..263cb41853c2 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -32,7 +32,10 @@
 #include <scsi/libsas.h>
 #include <scsi/sas_ata.h>
 
-#define sas_printk(fmt, ...) printk(KERN_NOTICE "sas: " fmt, ## __VA_ARGS__)
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+#define pr_fmt(fmt) "sas: " fmt
 
 #define SAS_DPRINTK(fmt, ...) printk(KERN_DEBUG "sas: " fmt, ## __VA_ARGS__)
 
diff --git a/drivers/scsi/libsas/sas_phy.c b/drivers/scsi/libsas/sas_phy.c
index bf3e1b979ca6..d628c0e6289d 100644
--- a/drivers/scsi/libsas/sas_phy.c
+++ b/drivers/scsi/libsas/sas_phy.c
@@ -122,11 +122,11 @@ static void sas_phye_shutdown(struct work_struct *work)
 		phy->enabled = 0;
 		ret = i->dft->lldd_control_phy(phy, PHY_FUNC_DISABLE, NULL);
 		if (ret)
-			sas_printk("lldd disable phy%02d returned %d\n",
-				phy->id, ret);
-	} else
-		sas_printk("phy%02d is not enabled, cannot shutdown\n",
-			phy->id);
+			pr_notice("lldd disable phy%02d returned %d\n",
+				  phy->id, ret);
+	} else {
+		pr_notice("phy%02d is not enabled, cannot shutdown\n", phy->id);
+	}
 }
 
 /* ---------- Phy class registration ---------- */
diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index fad23dd39114..f2a25cef85b7 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -147,8 +147,7 @@ static void sas_form_port(struct asd_sas_phy *phy)
 	}
 
 	if (i >= sas_ha->num_phys) {
-		printk(KERN_NOTICE "%s: couldn't find a free port, bug?\n",
-		       __func__);
+		pr_notice("%s: couldn't find a free port, bug?\n", __func__);
 		spin_unlock_irqrestore(&sas_ha->phy_port_lock, flags);
 		return;
 	}
