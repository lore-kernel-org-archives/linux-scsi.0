From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [REGRESSION 3.17] scsi (uas) disks no longer using tagged
 command queuing
Date: Tue, 9 Sep 2014 08:27:30 -0700
Message-ID: <20140909152730.GA17882@infradead.org>
References: <540EC52C.3000804@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <540EC52C.3000804@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-usb <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 09, 2014 at 11:15:24AM +0200, Hans de Goede wrote:
> Taking the uas.c file from 3.17, and building it for 3.16 restores
> the use of tcq (debugged by adding a printk blk_rq_tagged + request->tag).
> 
> So either uas is doing something wrong which happened to work in
> 3.16, or something has broken in 3.17.
> 
> I've already added debug printk-s of scsi_device->tagged_supported,
> queue_depth, ordered_tags and simple_tags and those all look good
> (1, 29, 1, 1).
> 
> I've also tried setting disable_blk_mq and that does not help.
> 
> Any hints to help debugging this further (other then a bisect) are
> appreciated. If no-one has any smart ideas I guess I'll end up doing
> a full bisect.

scsi-mq isn't enabled by default, so setting disable_blk_mq should
indeed not make a difference.

One interesting thing with uas is that it uses scsi_init_shared_tag_map,
which only few drivers do.

Can you apply a debug patch like the one below and see if that helps to
poinpoint down the issue?

diff --git a/block/blk-tag.c b/block/blk-tag.c
index a185b86..584db25 100644
--- a/block/blk-tag.c
+++ b/block/blk-tag.c
@@ -175,8 +175,10 @@ int blk_queue_init_tags(struct request_queue *q, int depth,
 			return rc;
 		queue_flag_set(QUEUE_FLAG_QUEUED, q);
 		return 0;
-	} else
+	} else {
+		printk("%s: grabbing reference to shared tag structure!\n", __func__);
 		atomic_inc(&tags->refcnt);
+	}
 
 	/*
 	 * assign it, all done
diff --git a/include/scsi/scsi_tcq.h b/include/scsi/scsi_tcq.h
index cdcc90b..7f3b5cb 100644
--- a/include/scsi/scsi_tcq.h
+++ b/include/scsi/scsi_tcq.h
@@ -164,8 +164,13 @@ static inline int scsi_init_shared_tag_map(struct Scsi_Host *shost, int depth)
 	 */
 	if (!shost->bqt) {
 		shost->bqt = blk_init_tags(depth);
-		if (!shost->bqt)
+		if (!shost->bqt) {
+			printk("failed to init host-wide tag map!\n");
 			return -ENOMEM;
+		}
+		printk("initialized host-wide tag map!\n");
+	} else {
+		printk("host-wide tag map already set!\n");
 	}
 
 	return 0;
