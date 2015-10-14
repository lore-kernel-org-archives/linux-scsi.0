From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] SCSI: Fix hard lockup in scsi_remove_target()
Date: Wed, 14 Oct 2015 11:18:03 -0700
Message-ID: <20151014181803.GA12497@infradead.org>
References: <cover.1444829611.git.jthumshirn@suse.de>
 <1444833036.2220.38.camel@HansenPartnership.com>
 <1444833547.19542.21.camel@suse.de>
 <1444837556.2220.43.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1444837556.2220.43.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 14, 2015 at 08:45:56AM -0700, James Bottomley wrote:
> OK, so I really need you to separate the problems.  Fixing the bug
> you're reporting does not require a complete rework of the locking
> infrastructure; it just requires replacing the traversal macro with the
> safe version, can you verify that and it can go into fixes?

_safe only protects against deletions from yourself, it does not protect
against other threads once a lock is dropped.  After auditing the
target reap code I fear the list_move trick isn't safe either, as
scsi_target_alloc relies on a being able to find a target that is
currently in the process of being deleted.  So the only safe variant
we have is to keep the same sequence we currently have and restart the
loop once we've deleted the target.  Given that we'd normally only
ever delete a single target anyway (not sure when we'd even get a second
one ever) this does not seem to be a major efficieny problem.

Johannes, can you test the patch below?

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index b333389f..d3b34d8 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1158,31 +1158,23 @@ static void __scsi_remove_target(struct scsi_target *starget)
 void scsi_remove_target(struct device *dev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev->parent);
-	struct scsi_target *starget, *last = NULL;
+	struct scsi_target *starget;
 	unsigned long flags;
 
-	/* remove targets being careful to lookup next entry before
-	 * deleting the last
-	 */
+restart:
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_for_each_entry(starget, &shost->__targets, siblings) {
 		if (starget->state == STARGET_DEL)
 			continue;
 		if (starget->dev.parent == dev || &starget->dev == dev) {
-			/* assuming new targets arrive at the end */
 			kref_get(&starget->reap_ref);
 			spin_unlock_irqrestore(shost->host_lock, flags);
-			if (last)
-				scsi_target_reap(last);
-			last = starget;
 			__scsi_remove_target(starget);
-			spin_lock_irqsave(shost->host_lock, flags);
+			scsi_target_reap(starget);
+			goto restart;
 		}
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
-
-	if (last)
-		scsi_target_reap(last);
 }
 EXPORT_SYMBOL(scsi_remove_target);
 
