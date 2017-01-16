From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [PATCH] preview - block layer help to detect sequential IO
Date: Mon, 16 Jan 2017 19:37:48 +0530
Message-ID: <6eda2ef22e4a1f75f2ea1076b508a850@mail.gmail.com>
References: <1484138217-20486-1-git-send-email-kashyap.desai@broadcom.com> <x494m14atio.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <x494m14atio.fsf@segfault.boston.devel.redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, Sumit Saxena <sumit.saxena@broadcom.com>, kent.overstreet@gmail.com
List-Id: linux-scsi@vger.kernel.org

> Hi, Kashyap,
>
> I'm CC-ing Kent, seeing how this is his code.

Hi Jeff and Kent, See my reply inline.

>
> Kashyap Desai <kashyap.desai@broadcom.com> writes:
>
> > Objective of this patch is -
> >
> > To move code used in bcache module in block layer which is used to
> > find IO stream.  Reference code @drivers/md/bcache/request.c
> > check_should_bypass().  This is a high level patch for review and
> > understand if it is worth to follow ?
> >
> > As of now bcache module use this logic, but good to have it in block
> > layer and expose function for external use.
> >
> > In this patch, I move logic of sequential IO search in block layer and
> > exposed function blk_queue_rq_seq_cutoff.  Low level driver just need
> > to call if they want stream detection per request queue.  For my
> > testing I just added call blk_queue_rq_seq_cutoff(sdev->request_queue,
> > 4) megaraid_sas driver.
> >
> > In general, code of bcache module was referred and they are doing
> > almost same as what we want to do in megaraid_sas driver below patch -
> >
> > http://marc.info/?l=linux-scsi&m=148245616108288&w=2
> >
> > bcache implementation use search algorithm (hashed based on bio start
> > sector) and detects 128 streams. <bcache> wanted those implementation
> > to skip sequential IO to be placed on SSD and move it direct to the
> > HDD.
> >
> > Will it be good design to keep this algorithm open at block layer (as
> > proposed in patch.) ?
>
> It's almost always a good idea to avoid code duplication, but this patch
> definitely needs some work.

Jeff, I was not aware of the actual block layer module, so created just a
working patch to explain my point.
Check new patch. This patch is driver changes only in <megaraid_sas>
driver.

1. Below MR driver patch does similar things but code is Array base linear
lookup.
 http://marc.info/?l=linux-scsi&m=148245616108288&w=2

2. I thought to improve this using appended patch. It is similar of what
<bcache> is doing. This patch has duplicate code as <bcache> is doing the
same.

>
> I haven't looked terribly closely at the bcache implementaiton, so do
let me
> know if I've misinterpreted something.
>
> We should track streams per io_context/queue pair.  We already have a
data
> structure for that, the io_cq.  Right now that structure is tailored for
use by the
> I/O schedulers, but I'm sure we could rework that.  That would also get
rid of the
> tremedous amount of bloat this patch adds to the request_queue.  It will
also
> allow us to remove the bcache-specific fields that were added to
task_struct.
> Overall, it should be a good simplification, unless I've completely
missed the
> point (which happens).

Your understanding of requirement is correct. What we need is tracker of
<request> in block layer and check the tracker for every request to know
if this is a random or sequential IO.  As you explained, there is a
similar logic in <cfq> ..I search the kernel code and figure out below
code section @ block/elevator.c

        /*
         * See if our hash lookup can find a potential backmerge.
         */
        __rq = elv_rqhash_find(q, bio->bi_iter.bi_sector);


I am looking for similar logic done in elv_rqhash_find() for all the IOs
and provide information in request, if this particular request is a
potential back-merge candidate (Having new req_flags_t e.a  RQF_SEQ) . It
is OK, even thought it was not merged due to other checks in IO path.

Safer side (to avoid any performance issues), we can opt for API to be
called by low level driver on particular request queue/sdev, if someone is
interested in this request queue such help ?

I need help (some level of patch to work on) or pointer, if this path is
good. I can drive this, but need to understand direction.

>
> I don't like that you put sequential I/O detection into bio_check_eod.
> Split it out into its own function.

Sorry for this. I thought of sending patch to get better understanding. My
first patch was very high level and not complaint with many design or
coding issue.
For my learning - BTW, for such post (if I have high level patch) ..what
shall I do ?

> You've added a member to struct bio that isn't referenced.  It would
have been
> nice of you to put enough work into this RFC so that we could at least
see how
> the common code was used by bcache and your driver.

See my second patch appended here. I can work on block layer generic
changes, if we have some another area (as mentioned elevator/cfq) doing
the stuffs which I am looking for.

>
> EWMA (exponentially weighted moving average) is not an acronym I keep
handy
> in my head.  It would be nice to add documentation on the algorithm and
design
> choices.  More comments in the code would also be appreciated.  CFQ does
> some similar things (detecting sequential vs. seeky I/O) in a much
lighter-weight
> fashion.  Any change to the algorithm, of course, would have to be
verified to
> still meet bcache's needs.
>
> A queue flag might be a better way for the driver to request this
functionality.
>
> Coding style will definitely need fixing.
>
> I hope that was helpful.

Really help. I copied patch which is doing same things in <megaraid_sas>
driver, without any changes in kernel/block layer. This patch is not from
upstream, but my local repo. You can compare this patch with
"@drivers/md/bcache/request.c check_should_bypass().  "

There can be a potential  duplicate logic/code in <md/bache> and low level
storage driver (megaraid_sas).
Can we keep logic of detecting Sequential vs Seeking IO  in upper layer
and provide flags for low level driver to use ?

diff --git a/megaraid_sas.h b/megaraid_sas.h
index 43d9d41..3ea10cb 100755
--- a/megaraid_sas.h
+++ b/megaraid_sas.h
@@ -1949,6 +1949,19 @@ union megasas_frame {
 	u8 raw_bytes[64];
 };

+#define MEGASAS_RECENT_IO_BITS  7
+#define MEGASAS_RECENT_IO       (1 << MEGASAS_RECENT_IO_BITS)
+struct megasas_seq_io_tracker {
+	/* Used to track sequential IO so it can be skipped */
+	struct hlist_node	hash;
+	struct list_head	lru;
+
+	unsigned long		jiffies;
+	unsigned int		sequential;
+	sector_t			last;
+};
+
+
 /**
  * struct MR_PRIV_DEVICE - sdev private hostdata
  * @is_tm_capable: firmware managed tm capable flag
@@ -1959,6 +1972,13 @@ struct MR_PRIV_DEVICE {
 	bool tm_busy;
 	atomic_t r1_ldio_hint;
 	u8	interface_type;
+	/* For tracking sequential IO */
+	struct megasas_seq_io_tracker	io[MEGASAS_RECENT_IO];
+	struct hlist_head	io_hash[MEGASAS_RECENT_IO + 1];
+	struct list_head	io_lru;
+	spinlock_t		io_lock;
+	unsigned int		sequential_cutoff;
+	unsigned int		sequential_io;
 };

 struct megasas_cmd;
@@ -2548,6 +2568,7 @@ struct megasas_instance {
 	u32 fw_support_ieee;

 	atomic_t fw_outstanding;
+	atomic_t total_seq_io;
 	atomic_t ldio_outstanding;
 	atomic_t fw_reset_no_pci_access;
 	atomic_t ieee_sgl;
diff --git a/megaraid_sas_base.c b/megaraid_sas_base.c
index 1ffeb61..bf2c1b0 100755
--- a/megaraid_sas_base.c
+++ b/megaraid_sas_base.c
@@ -50,6 +50,7 @@
 #include <linux/blkdev.h>
 #include <linux/mutex.h>
 #include <linux/poll.h>
+#include <linux/hash.h>

 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -1868,6 +1869,94 @@ out_return_cmd:
 	return SCSI_MLQUEUE_HOST_BUSY;
 }

+static void add_sequential(struct MR_PRIV_DEVICE *mr_device_priv_data)
+{
+	mr_device_priv_data->sequential_io = 0;
+}
+static struct hlist_head *megasas_iohash(struct MR_PRIV_DEVICE *data,
+		uint64_t k)
+{
+	return &data->io_hash[hash_64(k, MEGASAS_RECENT_IO_BITS)];
+}
+
+ /**
+ * megasas_detect_seq_stream - 	Detect sequential IO per pattern
using hash table per scsi device.
+ *                             	Each scsi device will have hash
table in private data.
+ *                             	This function will iterate/update
hash table and find out if
+ *                             	recent BIO is a sequence of any
BIO looking at io tracker history.
+ *
+ *                             	This function is a referenced from
<bcache>
+ *                             	@drivers/md/bcache/request.c
check_should_bypass().
+ *
+ * 				Current megaraid_sas driver use similar
logic without hash table.
+ * 				It is array based searched in for loop.
Not efficient compare.
+ *
+ *
http://marc.info/?l=linux-scsi&m=148245616108288&w=2
+ *
+ * @instance:			Adapter soft state
+ * @scmd:			SCSI command to be queued
+ */
+static void
+megasas_detect_seq_stream(struct megasas_instance *instance,
+			struct scsi_cmnd *scmd)
+{
+
+	struct MR_PRIV_DEVICE *mr_device_priv_data;
+	struct megasas_seq_io_tracker *i;
+	unsigned int sectors;
+	struct bio *bio;
+	unsigned long flags;
+
+	mr_device_priv_data = scmd->device->hostdata;
+
+	if (!mr_device_priv_data ||
!mr_device_priv_data->sequential_cutoff)
+		return;
+
+	if (scmd->request &&
+		!scmd->request->bio)
+		return;
+
+	bio = scmd->request->bio;
+
+	spin_lock_irqsave(&mr_device_priv_data->io_lock, flags);
+
+	hlist_for_each_entry(i, megasas_iohash(mr_device_priv_data,
bio->bi_iter.bi_sector), hash)
+		if (i->last == bio->bi_iter.bi_sector &&
+			time_before(jiffies, i->jiffies))
+			goto found;
+
+	i = list_first_entry(&mr_device_priv_data->io_lru,
+				struct megasas_seq_io_tracker, lru);
+
+	/* For every random IO pattern, code will hit here as there is no
relavent
+ 	 * BIO in IO tracker with previous BIO sector and current BIO
sector match
+ 	 */
+	add_sequential(mr_device_priv_data);
+	i->sequential = 0;
+found:
+	if (i->sequential + bio->bi_iter.bi_size > i->sequential)
+		i->sequential	+= bio->bi_iter.bi_size;
+
+	i->last			 = bio_end_sector(bio);
+	i->jiffies		 = jiffies + msecs_to_jiffies(5000);
+	/* megaraid driver/firmware need this information. Pass this down
to fimrware */
+	mr_device_priv_data->sequential_io	 = i->sequential;
+
+	hlist_del(&i->hash);
+	hlist_add_head(&i->hash,
+		megasas_iohash(mr_device_priv_data, i->last));
+	list_move_tail(&i->lru, &mr_device_priv_data->io_lru);
+
+	spin_unlock_irqrestore(&mr_device_priv_data->io_lock, flags);
+
+	sectors = mr_device_priv_data->sequential_io >> 9;
+	if (sectors >= mr_device_priv_data->sequential_cutoff >> 9)
+		atomic_inc(&instance->total_seq_io);
+
+	return;
+
+}
+
 /**
  * megasas_queue_command -	Queue entry point
  * @scmd:			SCSI command to be queued
@@ -1951,6 +2040,8 @@ megasas_queue_command(struct Scsi_Host *shost,
struct scsi_cmnd *scmd)
 		goto out_done;
 	}
 	
+	megasas_detect_seq_stream(instance, scmd);
+
 	return instance->instancet->build_and_issue_cmd(instance,scmd);
 	

@@ -2137,6 +2228,31 @@ static void
megasas_set_static_target_properties(struct scsi_device *sdev, bool

 }

+void megasas_set_stream_detect(struct scsi_device *sdev)
+{
+	struct megasas_instance *instance;
+	struct MR_PRIV_DEVICE *mr_device_priv_data;
+	struct megasas_seq_io_tracker *io;
+
+	instance = megasas_lookup_instance(sdev->host->host_no);
+	mr_device_priv_data = sdev->hostdata;
+
+	if (!mr_device_priv_data)
+		return;
+	/* 1MB cutoff */
+	mr_device_priv_data->sequential_cutoff = 1 << 20;
+	dev_info(&instance->pdev->dev, "%s:%d set seq cutoff 0x%x\n",
+		__func__, __LINE__,
mr_device_priv_data->sequential_cutoff);
+	spin_lock_init(&mr_device_priv_data->io_lock);
+	INIT_LIST_HEAD(&mr_device_priv_data->io_lru);
+
+	for (io = mr_device_priv_data->io;
+		io < mr_device_priv_data->io + MEGASAS_RECENT_IO; io++) {
+		list_add(&io->lru, &mr_device_priv_data->io_lru);
+		hlist_add_head(&io->hash,
+			mr_device_priv_data->io_hash + MEGASAS_RECENT_IO);
+	}
+}

 static int megasas_slave_configure(struct scsi_device *sdev)
 {
@@ -2156,6 +2272,7 @@ static int megasas_slave_configure(struct
scsi_device *sdev)
 		}
 	}

+
 	mutex_lock(&instance->hba_mutex);
 	/* Send DCMD to Firmware and cache the information */
 	if ((instance->pd_info) && !MEGASAS_IS_LOGICAL(sdev))
@@ -2172,6 +2289,7 @@ static int megasas_slave_configure(struct
scsi_device *sdev)

 	mutex_unlock(&instance->hba_mutex);

+	megasas_set_stream_detect(sdev);

 	sdev_printk(KERN_INFO, sdev, "qdepth(%d), tagged(%d), "
 		"scsi_level(%d), cmd_que(%d)\n", sdev->queue_depth,
@@ -4306,6 +4424,16 @@ megasas_page_size_show(struct device *cdev, struct
device_attribute *attr,
 }

 static ssize_t
+megasas_seq_io_show(struct device *cdev, struct device_attribute *attr,
+	char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct megasas_instance *instance = (struct megasas_instance
*)shost->hostdata;
+	return snprintf(buf, PAGE_SIZE, "%ld\n",
+					(unsigned
long)atomic_read(&instance->total_seq_io));
+}
+
+static ssize_t
 megasas_ldio_outstanding_show (struct device *cdev, struct
device_attribute *attr,
         char *buf)
 {
@@ -4336,6 +4464,8 @@ static DEVICE_ATTR(fw_crash_state, S_IRUGO |
S_IWUSR,
         megasas_fw_crash_state_show, megasas_fw_crash_state_store);
 static DEVICE_ATTR(page_size, S_IRUGO,
         megasas_page_size_show, NULL);
+static DEVICE_ATTR(total_seq_io, S_IRUGO,
+		megasas_seq_io_show, NULL);
 static DEVICE_ATTR(ldio_outstanding, S_IRUGO,
         megasas_ldio_outstanding_show, NULL);
 static DEVICE_ATTR(io_stats, S_IRUGO,
@@ -4348,6 +4478,7 @@ struct device_attribute *megaraid_host_attrs[] = {
         &dev_attr_fw_crash_buffer,
         &dev_attr_fw_crash_state,
         &dev_attr_page_size,
+		&dev_attr_total_seq_io,
         &dev_attr_ldio_outstanding,
 		&dev_attr_io_stats,
 		&dev_attr_ldio_hint_count,
