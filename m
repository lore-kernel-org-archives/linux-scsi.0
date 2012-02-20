From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-io async WRITE_SAME results in iSCSI NULL pointer [was: Re:
 Write same support]
Date: Mon, 20 Feb 2012 13:46:24 -0500
Message-ID: <20120220184623.GA29931@redhat.com>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
 <20120216200202.GA27311@redhat.com>
 <20120216210301.GA27404@redhat.com>
 <yq139a55rhr.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="X1bOJ3K7DJ5YkBrT"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327Ab2BTSqh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Feb 2012 13:46:37 -0500
Content-Disposition: inline
In-Reply-To: <yq139a55rhr.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, jaxboe@fusionio.com, dm-devel@redhat.com, michaelc@cs.wisc.edu


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 20 2012 at 12:44pm -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike> But testing with iSCSI, I get a NULL pointer _every_ time in the
> Mike> iSCSI scatter-gather code,
> 
> I finally managed to get a WRITE SAME-capable iSCSI target set up.
> 
> Can you beam me your test case?

I've been using the thinp-test-suite, here:
https://github.com/jthornber/thinp-test-suite

After establishing a minimal config in config.rb, e.g.:
    'hostname' =>
    { :metadata_dev => '/dev/thin_iscsi/metadata',
      :metadata_size => 2097152,
      :data_dev => '/dev/thin_iscsi/data',
      :data_size => 17825792
    }

I run a single test:
export THIN_TESTS=EXECUTE
./run_tests -n /test_two_pools_can_create_thins/

Anyway, looking at the code, the sg setup code is common for all SCSI,
so I have no reason to believe that FC is different than iSCSI -- FC's
sg code may just be much more forgiving?:

sd_setup_write_same_cmnd -> sd_setup_write_same_cmnd -> scsi_setup_blk_pc_cmnd ->
 scsi_init_io -> scsi_init_sgtable -> blk_rq_map_sg

I'm not seeing any code that accounts for the possibility of a
WRITE_SAME bio having bv_len=512 but bi_size=65536 in blk_rq_map_sg().
I'm definitely seeing blk_rq_map_sg() take a WRITE SAME request and
create a sg with multiple segments.  That in and of itself seems like a
bug.  But I'm no scatter-gather expert!

I'm adding more debug printks to blk_rq_map_sg() to try to understand
what is going on... will share more once I have it.

But the iSCSI traces I got, with some debugging code that Mike Christie
provided -- attached to this mail, showed that the sg was setup
improperly (so I think) because there are multiple segments, e.g.:

iscsi prep [write cid 0 sc ffff880117ce5080 cdb 0x41 itt 0x15 len 512 sg count 8 bidi_len 0 cmdsn 883 win 128]
0 sg ffff88011a471800 0 512
1 sg ffff88011a471828 0 512
2 sg ffff88011a471850 0 512
3 sg ffff88011a471878 0 512
4 sg ffff88011a4718a0 0 512
5 sg ffff88011a4718c8 0 512
6 sg ffff88011a4718f0 0 512
7 sg ffff88011a471918 0 512

When the test is executed using your synchronous blkdev_issue_write_same
interface each WRITE SAME is confined to an sg with a single segment,
e.g.:

iscsi prep [write cid 0 sc ffff880117ce1c80 cdb 0x41 itt 0x5e len 512 sg count 1 bidi_len 0 cmdsn 902 win 128]
0 sg ffff880118d72e80 0 512
iscsi prep [write cid 0 sc ffff880116fc0b80 cdb 0x41 itt 0x5f len 512 sg count 1 bidi_len 0 cmdsn 903 win 128]
0 sg ffff88011a471940 0 512
iscsi prep [write cid 0 sc ffff880117ce1c80 cdb 0x41 itt 0x60 len 512 sg count 1 bidi_len 0 cmdsn 904 win 128]
0 sg ffff880118d72e80 0 512

And here is the sg that ultimately caused the libiscsi_tcp code to NULL
pointer (len is much too large, and it _seems_ like WRITE SAME has been
merged on a WRITE cdb's sg):

iscsi prep [write cid 0 sc ffff8800cfc953c0 cdb 0x2a itt 0x27 len 512000 sg count 20 bidi_len 0 cmdsn 1146 win 128]
0 sg ffff88011a476040 0 4096
1 sg ffff88011a476068 0 4096
2 sg ffff88011a476090 0 4096
3 sg ffff88011a4760b8 0 4096
4 sg ffff88011a4760e0 0 4096
5 sg ffff88011a476108 0 4096
6 sg ffff88011a476130 0 4096
7 sg ffff88011a476158 0 4096
8 sg ffff88011a476180 0 4096
9 sg ffff88011a4761a8 0 4096
10 sg ffff88011a4761d0 0 4096
11 sg ffff88011a4761f8 0 4096
12 sg ffff88011a476220 0 4096
13 sg ffff88011a476248 0 512
14 sg ffff88011a476270 0 512
15 sg ffff88011a476298 0 512
16 sg ffff88011a4762c0 0 512
17 sg ffff88011a4762e8 0 512
18 sg ffff88011a476310 0 512
19 sg ffff88011a476338 0 512
Bad! offset 0 size 65536 copied 56832

--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="cmd-sgl-check.patch"

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 9075cfa..50a1d79 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -362,7 +362,8 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 	struct iscsi_cmd *hdr;
 	unsigned hdrlength, cmd_len;
 	itt_t itt;
-	int rc;
+	int rc, i;
+	struct scatterlist *sg;
 
 	rc = iscsi_check_tmf_restrictions(task, ISCSI_OP_SCSI_CMD);
 	if (rc)
@@ -479,15 +480,19 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 	session->cmdsn++;
 
 	conn->scsicmd_pdus_cnt++;
-	ISCSI_DBG_SESSION(session, "iscsi prep [%s cid %d sc %p cdb 0x%x "
-			  "itt 0x%x len %d bidi_len %d cmdsn %d win %d]\n",
+	printk(KERN_ERR "iscsi prep [%s cid %d sc %p cdb 0x%x "
+			  "itt 0x%x len %d sg count %d bidi_len %d cmdsn %d win %d]\n",
 			  scsi_bidi_cmnd(sc) ? "bidirectional" :
 			  sc->sc_data_direction == DMA_TO_DEVICE ?
 			  "write" : "read", conn->id, sc, sc->cmnd[0],
-			  task->itt, scsi_bufflen(sc),
+			  task->itt, scsi_bufflen(sc), scsi_sg_count(sc),
 			  scsi_bidi_cmnd(sc) ? scsi_in(sc)->length : 0,
 			  session->cmdsn,
 			  session->max_cmdsn - session->exp_cmdsn + 1);
+
+	scsi_for_each_sg(sc, sg, scsi_sg_count(sc), i)
+		printk(KERN_ERR "%d sg %p %u %u\n", i, sg, sg->offset, sg->length);
+
 	return 0;
 }
 
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index e0ea92c..240f2d2 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -95,6 +95,12 @@ static inline void
 iscsi_tcp_segment_init_sg(struct iscsi_segment *segment,
 			  struct scatterlist *sg, unsigned int offset)
 {
+	if (!sg) {
+		printk(KERN_ERR "Bad! offset %u size %u copied %u\n",
+			offset, segment->total_size, segment->total_copied);
+		return;
+	}
+
 	segment->sg = sg;
 	segment->sg_offset = offset;
 	segment->size = min(sg->length - offset,

--X1bOJ3K7DJ5YkBrT--
