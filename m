From: Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Date: Fri, 9 Aug 2013 10:23:35 +0200
Message-ID: <20130809082335.GA25306@dhcp-26-207.brq.redhat.com>
References: <1374248000.2266.20.camel@dabdike>
 <1374267684.7397.1058.camel@haakon3.risingtidesystems.com>
 <1374296162.7397.1098.camel@haakon3.risingtidesystems.com>
 <20130722150359.GA16564@dhcp-26-207.brq.redhat.com>
 <1374527436.7397.1145.camel@haakon3.risingtidesystems.com>
 <20130725101641.GB31994@dhcp-26-207.brq.redhat.com>
 <1374790082.7397.1411.camel@haakon3.risingtidesystems.com>
 <20130726020928.GL29296@kernel.dk>
 <1374873276.7397.1512.camel@haakon3.risingtidesystems.com>
 <20130729114653.GB20951@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130729114653.GB20951@mtj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Jens Axboe <axboe@kernel.dk>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 29, 2013 at 07:46:53AM -0400, Tejun Heo wrote:
> One thing which would probably be worthwhile tho is getting rid of the
> bitmap based qc tag allocator in libata.  That one is just borderline
> stupid to keep around on any setup which is supposed to be scalable.

Hi Tejun,

How about this approach?

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index f218427..5c2a236 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -72,6 +72,8 @@
 #include "libata.h"
 #include "libata-transport.h"
 
+#include "../../block/blk-mq-tag.h"
+
 /* debounce timing parameters in msecs { interval, duration, timeout } */
 const unsigned long sata_deb_timing_normal[]		= {   5,  100, 2000 };
 const unsigned long sata_deb_timing_hotplug[]		= {  25,  500, 2000 };
@@ -1569,18 +1571,8 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
 
 	/* initialize internal qc */
 
-	/* XXX: Tag 0 is used for drivers with legacy EH as some
-	 * drivers choke if any other tag is given.  This breaks
-	 * ata_tag_internal() test for those drivers.  Don't use new
-	 * EH stuff without converting to it.
-	 */
-	if (ap->ops->error_handler)
-		tag = ATA_TAG_INTERNAL;
-	else
-		tag = 0;
-
-	if (test_and_set_bit(tag, &ap->qc_allocated))
-		BUG();
+	tag = blk_mq_get_tag(ap->qc_tags, GFP_ATOMIC, true);
+	BUG_ON(!ata_tag_internal(tag));
 	qc = __ata_qc_from_tag(ap, tag);
 
 	qc->tag = tag;
@@ -4733,21 +4725,17 @@ void swap_buf_le16(u16 *buf, unsigned int buf_words)
 static struct ata_queued_cmd *ata_qc_new(struct ata_port *ap)
 {
 	struct ata_queued_cmd *qc = NULL;
-	unsigned int i;
+	unsigned int tag;
 
 	/* no command while frozen */
 	if (unlikely(ap->pflags & ATA_PFLAG_FROZEN))
 		return NULL;
 
-	/* the last tag is reserved for internal command. */
-	for (i = 0; i < ATA_MAX_QUEUE - 1; i++)
-		if (!test_and_set_bit(i, &ap->qc_allocated)) {
-			qc = __ata_qc_from_tag(ap, i);
-			break;
-		}
+	tag = blk_mq_get_tag(ap->qc_tags, GFP_ATOMIC, false);
+	qc = __ata_qc_from_tag(ap, tag);
 
 	if (qc)
-		qc->tag = i;
+		qc->tag = tag;
 
 	return qc;
 }
@@ -4799,7 +4787,7 @@ void ata_qc_free(struct ata_queued_cmd *qc)
 	tag = qc->tag;
 	if (likely(ata_tag_valid(tag))) {
 		qc->tag = ATA_TAG_POISON;
-		clear_bit(tag, &ap->qc_allocated);
+		blk_mq_put_tag(ap->qc_tags, tag);
 	}
 }
 
@@ -5639,6 +5627,12 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 	if (!ap)
 		return NULL;
 
+	ap->qc_tags = blk_mq_init_tags(ATA_MAX_QUEUE, 1, NUMA_NO_NODE);
+	if (!ap->qc_tags) {
+		kfree(ap);
+		return NULL;
+	}
+
 	ap->pflags |= ATA_PFLAG_INITIALIZING | ATA_PFLAG_FROZEN;
 	ap->lock = &host->lock;
 	ap->print_id = -1;
@@ -5677,6 +5671,14 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 	return ap;
 }
 
+static void ata_port_free(struct ata_port *ap)
+{
+	kfree(ap->pmp_link);
+	kfree(ap->slave_link);
+	blk_mq_free_tags(ap->qc_tags);
+	kfree(ap);
+}
+
 static void ata_host_release(struct device *gendev, void *res)
 {
 	struct ata_host *host = dev_get_drvdata(gendev);
@@ -5691,9 +5693,7 @@ static void ata_host_release(struct device *gendev, void *res)
 		if (ap->scsi_host)
 			scsi_host_put(ap->scsi_host);
 
-		kfree(ap->pmp_link);
-		kfree(ap->slave_link);
-		kfree(ap);
+		ata_port_free(ap);
 		host->ports[i] = NULL;
 	}
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index eae7a05..4ff9494 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -126,7 +126,7 @@ enum {
 	ATA_DEF_QUEUE		= 1,
 	/* tag ATA_MAX_QUEUE - 1 is reserved for internal commands */
 	ATA_MAX_QUEUE		= 32,
-	ATA_TAG_INTERNAL	= ATA_MAX_QUEUE - 1,
+	ATA_TAG_INTERNAL	= 0,
 	ATA_SHORT_PAUSE		= 16,
 
 	ATAPI_MAX_DRAIN		= 16 << 10,
@@ -766,7 +766,7 @@ struct ata_port {
 	unsigned int		cbl;	/* cable type; ATA_CBL_xxx */
 
 	struct ata_queued_cmd	qcmd[ATA_MAX_QUEUE];
-	unsigned long		qc_allocated;
+	struct blk_mq_tags	*qc_tags;
 	unsigned int		qc_active;
 	int			nr_active_links; /* #links with active qcs */
 

> Thanks.
> 
> -- 
> tejun

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
