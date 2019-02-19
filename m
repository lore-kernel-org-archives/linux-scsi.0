From: Jason Yan <yanaijie@huawei.com>
Subject: [RFC PATCH] scsi: fix oops in scsi_uninit_cmd()
Date: Tue, 19 Feb 2019 15:27:43 +0800
Message-ID: <20190219072743.13606-1-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, hch@lst.de, Jason Yan <yanaijie@huawei.com>
List-Id: linux-scsi@vger.kernel.org

If we remove the scsi disk when running io with fio, oops occured with
the following condition.

[scsi_eh_0]                              [fio]
scsi_end_request
  ->blk_update_request
    ->end_bio(io returned to userspace)
                                         close
                                           ->sd_release
                                              ->scsi_disk_put
                                                 ->scsi_disk_release
                                                     ->disk->private_data = NULL;

  ->scsi_mq_uninit_cmd
    ->scsi_uninit_cmd
      ->scsi_cmd_to_driver
    ->drv is NULL, Oops

There is a small window between blk_update_request() and
scsi_mq_uninit_cmd() that scsi disk may have been released. This will
cause a oops like below:

Unable to handle kernel NULL pointer dereference at virtual address
0000000000000000
s/sync.c:67, func=xfer, error=In[11347.116050] Mem abort info:
put/output error
[11347.121598]   ESR = 0x96000006
[11347.126200]   Exception class = DABT (current EL), IL = 32 bits
[11347.132117]   SET = 0, FnV = 0
[11347.135170]   EA = 0, S1PTW = 0
[11347.138308] Data abort info:
[11347.141186]   ISV = 0, ISS = 0x00000006
[11347.145019]   CM = 0, WnR = 0
[11347.147977] user pgtable: 4k pages, 48-bit VAs, pgdp =
00000000a67aece2
[11347.154591] [0000000000000000] pgd=0000002f90774003,
pud=0000002fab098003, pmd=0000000000000000
[11347.163304] Internal error: Oops: 96000006 [#1] PREEMPT SMP
[11347.168870] Modules linked in: hisi_sas_v3_hw hisi_sas_main libsas
[11347.175044] CPU: 56 PID: 4294 Comm: scsi_eh_2 Not tainted
4.19.0-g8052059-dirty #2
[11347.182600] Hardware name: Huawei D06/D06, BIOS Hisilicon D06 UEFI
RC0 - B601 (V6.01) 11/08/2018
[11347.191370] pstate: a0c00009 (NzCv daif +PAN +UAO)
[11347.196155] pc : scsi_uninit_cmd+0x24/0x3c
[11347.200240] lr : scsi_mq_uninit_cmd+0x1c/0x30
[11347.204583] sp : ffff000024dabb60
[11347.207884] x29: ffff000024dabb60 x28: ffff000024dabd38
[11347.213184] x27: ffff000000f5b3a8 x26: ffff7df3b0181600
[11347.218484] x25: 0000000000000000 x24: ffff803bc5d36778
[11347.223783] x23: 000000000000000a x22: 0000000000000000
[11347.229082] x21: ffff803bc7397000 x20: ffff802f9148e530
[11347.234381] x19: ffff802f9148e530 x18: ffff7e0000000000
[11347.239679] x17: 0000000000000000 x16: 0000002f9e37d000
[11347.244979] x15: ffff7e0000000000 x14: 3863206336203839
[11347.250278] x13: 2036302030302038 x12: a46fac3d0d363d00
[11347.255578] x11: ffffffffffffffff x10: a46fac3d0d363d00
[11347.260877] x9 : 0000000040040000 x8 : 000000000000eb4b
[11347.266177] x7 : ffff000009771000 x6 : 0000000000210d00
[11347.271476] x5 : ffff803bc9f50000 x4 : 0000000000000000
[11347.276775] x3 : ffff802fb02b4380 x2 : ffff802f9148e400
[11347.282075] x1 : 0000000000000000 x0 : ffff802f9148e530
[11347.287375] Process scsi_eh_2 (pid: 4294, stack limit =
0x000000007d2257f8)
[11347.294323] Call trace:
Jobs: 6 (f=6): [R[RRR1XXX1XRR3] 47.296758]  scsi_uninit_cmd+0x24/0x3c
[22.7% done] [1516MB/0KB/0KB /s] [754/0/0 iops] [eta 08m:39s]
[11347.308390]  scsi_mq_uninit_cmd+0x1c/0x30
[11347.312387]  scsi_end_request+0x7c/0x1b8
[11347.316297]  scsi_io_completion+0x464/0x668
[11347.320467]  scsi_finish_command+0xbc/0x160
[11347.324636]  scsi_eh_flush_done_q+0x10c/0x170
[11347.328990]  sas_scsi_recover_host+0x84c/0xa98 [libsas]
[11347.334202]  scsi_error_handler+0x140/0x5b0
[11347.338374]  kthread+0x100/0x12c
[11347.341590]  ret_from_fork+0x10/0x18
[11347.345153] Code: 71000c3f 540000e9 f9404c41 f941f421 (f9400021)
[11347.351234] ---[ end trace f496aacdaa1dcc51 ]---

To fix this, get a refcount of scsi_disk in sd_init_command() to ensure
it will not be released before sd_uninit_command().

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/sd.c | 46 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5464d467e23e..6bdb8fbb570f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1249,42 +1249,64 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 static blk_status_t sd_init_command(struct scsi_cmnd *cmd)
 {
 	struct request *rq = cmd->request;
+	struct scsi_disk *sdkp = NULL;
+	blk_status_t ret;
 
 	switch (req_op(rq)) {
 	case REQ_OP_DISCARD:
 		switch (scsi_disk(rq->rq_disk)->provisioning_mode) {
 		case SD_LBP_UNMAP:
-			return sd_setup_unmap_cmnd(cmd);
+			ret = sd_setup_unmap_cmnd(cmd);
+			break;
 		case SD_LBP_WS16:
-			return sd_setup_write_same16_cmnd(cmd, true);
+			ret = sd_setup_write_same16_cmnd(cmd, true);
+			break;
 		case SD_LBP_WS10:
-			return sd_setup_write_same10_cmnd(cmd, true);
+			ret = sd_setup_write_same10_cmnd(cmd, true);
+			break;
 		case SD_LBP_ZERO:
-			return sd_setup_write_same10_cmnd(cmd, false);
+			ret = sd_setup_write_same10_cmnd(cmd, false);
+			break;
 		default:
-			return BLK_STS_TARGET;
+			ret = BLK_STS_TARGET;
+			break;
 		}
+		break;
 	case REQ_OP_WRITE_ZEROES:
-		return sd_setup_write_zeroes_cmnd(cmd);
+		ret = sd_setup_write_zeroes_cmnd(cmd);
+		break;
 	case REQ_OP_WRITE_SAME:
-		return sd_setup_write_same_cmnd(cmd);
+		ret = sd_setup_write_same_cmnd(cmd);
+		break;
 	case REQ_OP_FLUSH:
-		return sd_setup_flush_cmnd(cmd);
+		ret = sd_setup_flush_cmnd(cmd);
+		break;
 	case REQ_OP_READ:
 	case REQ_OP_WRITE:
-		return sd_setup_read_write_cmnd(cmd);
+		ret = sd_setup_read_write_cmnd(cmd);
+		break;
 	case REQ_OP_ZONE_RESET:
-		return sd_zbc_setup_reset_cmnd(cmd);
+		ret = sd_zbc_setup_reset_cmnd(cmd);
+		break;
 	default:
 		WARN_ON_ONCE(1);
-		return BLK_STS_NOTSUPP;
+		ret = BLK_STS_NOTSUPP;
+		break;
 	}
+
+	if (!ret) {
+		sdkp = scsi_disk(rq->rq_disk);
+		get_device(&sdkp->dev);
+	}
+
+	return ret;
 }
 
 static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 {
 	struct request *rq = SCpnt->request;
 	u8 *cmnd;
+	struct scsi_disk *sdkp = NULL;
 
 	if (rq->rq_flags & RQF_SPECIAL_PAYLOAD)
 		mempool_free(rq->special_vec.bv_page, sd_page_pool);
@@ -1295,6 +1317,8 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 		SCpnt->cmd_len = 0;
 		mempool_free(cmnd, sd_cdb_pool);
 	}
+	sdkp = scsi_disk(rq->rq_disk);
+	put_device(&sdkp->dev);
 }
 
 /**
-- 
2.14.4
