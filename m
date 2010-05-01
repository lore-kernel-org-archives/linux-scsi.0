From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] QEMU-KVM scsi-bus: Add LBA+Transfer Length to outgoing SBC
	CDBs in scsi_req_setup() for SG_IO
Date: Sat, 01 May 2010 07:10:05 -0700
Message-ID: <1272723005.6280.101.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:46098 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751026Ab0EAOKN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 May 2010 10:10:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kvm-devel <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, Gerd Hoffmann <kraxel@redhat.com>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Douglas Gilbert <dgilbert@interlog.com>, "J.H." <warthog9@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>

Greetings Hannes, Gerd and co,

So after doing more digging into the work for a SGL capable QEMU SCSI
HBA emulation interface with the megasas driver on Linux/KVM Hosts, I
realized that the SG_IO breakage we originally encountered is due to the
fact that CDBs containing SBC LBA+block_count where not getting built in
the new HBA I/O helper in hw/scsi-bus.c:scsi_req_setup().

This is AFAICT because hw/scsi-disk.c logic is doing it's underlying
userspace AIO to struct file without any knowledge of SBC CDBs to begin
with. (Please correct me if I am wrong)  With the following patch on top
of my working qemu-kvm.git tree containing Gerd's SCSI bus interface, I
am now able to run bulk SG_IO with megasas emulation in a v2.6.26-2
x86_64 KVM Guest on a 2.6.34-rc4 x86_64 Host with TCM_Loop virtual SAS
ports!

Also the original lack of a valid req->cmd.len assignment in
scsi_req_setup() is what was causing the original 'Message too long'
SG_IO failures I encountered..  Here is the combined patch to make go:

diff --git a/hw/scsi-bus.c b/hw/scsi-bus.c
index 48e8d40..b8e4b71 100644
--- a/hw/scsi-bus.c
+++ b/hw/scsi-bus.c
@@ -453,7 +453,39 @@ int scsi_req_parse(SCSIRequest *req, uint8_t *buf)

 int scsi_req_setup(SCSIRequest *req, int is_write, uint64_t lba, uint64_t count)
 {
-    req->cmd.buf[0] = is_write ? WRITE_12 : READ_12;
+    /*
+     * Set the req->cmd.len and fill in the CDB's Logical Block Address and
+     * Transfer length (block count) that is required by SG_IO passthrough
+     * in hw/scsi-generic.c:execute_command_run()
+     */
+    if (lba > 0x00000000ffffffff) {
+       req->cmd.len = 16;
+       req->cmd.buf[0] = is_write ? WRITE_16 : READ_16;
+       req->cmd.buf[2] = (lba >> 56) & 0xff;
+       req->cmd.buf[3] = (lba >> 48) & 0xff;
+       req->cmd.buf[4] = (lba >> 40) & 0xff;
+       req->cmd.buf[5] = (lba >> 32) & 0xff;
+       req->cmd.buf[6] = (lba >> 24) & 0xff;
+       req->cmd.buf[7] = (lba >> 16) & 0xff;
+       req->cmd.buf[8] = (lba >> 8) & 0xff;
+       req->cmd.buf[9] = lba & 0xff;
+       req->cmd.buf[10] = (count >> 24) & 0xff;
+       req->cmd.buf[11] = (count >> 16) & 0xff;
+       req->cmd.buf[12] = (count >> 8) & 0xff;
+       req->cmd.buf[13] = count & 0xff;
+    } else {
+       req->cmd.len = 12;
+       req->cmd.buf[0] = is_write ? WRITE_12 : READ_12;
+       req->cmd.buf[2] = (lba >> 24) & 0xff;
+       req->cmd.buf[3] = (lba >> 16) & 0xff;
+       req->cmd.buf[4] = (lba >> 8) & 0xff;
+       req->cmd.buf[5] = lba & 0xff;
+       req->cmd.buf[6] = (count >> 24) & 0xff;
+       req->cmd.buf[7] = (count >> 16) & 0xff;
+       req->cmd.buf[8] = (count >> 8) & 0xff;
+       req->cmd.buf[9] = count & 0xff;
+    }
+
     req->cmd.mode = is_write ? SCSI_XFER_TO_DEV : SCSI_XFER_FROM_DEV;
     req->cmd.lba = lba;
     req->cmd.xfer = count * req->dev->blocksize;

and the the link containing the commit proper:

http://git.kernel.org/?p=virt/kvm/nab/qemu-kvm.git;a=commitdiff;h=6a1a11bfbcde49bb864fe40cf3b254b1ed607c72

So far using the LTP-Disktest O_DIRECT benchmark with 8 threads and 64k
blocksize in a guest with 4 VCPUs and 2048MB memory to a SG_IO <->
TCM/RAMDISK_DR backstore running on a KVM 5500 series Nehalem host, I am
seeing ~8.9 Gb/sec (~1050 MB/sec) of bandwith to megasas with the large
blocksizes.  Seperately I am able to mkfs and mount filesystems from
within KVM guest, shutdown and then mount locally with TCM_Loop on the
host, etc.

Here is how it looks in action so far:

http://linux-iscsi.org/images/Megasas-SGIO-TCM_Loop-05012010.png

In order to achieve these results I am running with the recommended
MEGASAS_MAX_FRAMES=1000, and two extra kernel patches for seting
include/scsi/sg.h:SG_MAX_QUEUE=128 and increasing TCM_Loop's SCSI LLD
settings for struct scsi_host_template to can_queue=1024,
cmd_per_lun=1024, and max_sectors=256.

diff --git a/include/scsi/sg.h b/include/scsi/sg.h
index a9f3c6f..5decefd 100644
--- a/include/scsi/sg.h
+++ b/include/scsi/sg.h
@@ -240,7 +240,7 @@ typedef struct sg_req_info { /* used by SG_GET_REQUEST_TABLE ioctl() */
 #define SG_DEF_RESERVED_SIZE SG_SCATTER_SZ /* load time option */
 
 /* maximum outstanding requests, write() yields EDOM if exceeded */
-#define SG_MAX_QUEUE 16
+#define SG_MAX_QUEUE 128
 
 #define SG_BIG_BUFF SG_DEF_RESERVED_SIZE    /* for backward compatibility */
diff --git a/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c b/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
index 5417579..4d4c573 100644
--- a/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
+++ b/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
@@ -391,11 +391,11 @@ static struct scsi_host_template tcm_loop_driver_template = {
        .eh_device_reset_handler = NULL,
        .eh_host_reset_handler  = NULL,
        .bios_param             = NULL,
-       .can_queue              = 1,
+       .can_queue              = 1024,
        .this_id                = -1,
        .sg_tablesize           = 256,
-       .cmd_per_lun            = 1,
-       .max_sectors            = 128,
+       .cmd_per_lun            = 1024,
+       .max_sectors            = 256,
        .use_clustering         = DISABLE_CLUSTERING,
        .module                 = THIS_MODULE,
 };

With the v2.6.26-2 Linux guests everything feels quite solid running for
extended periods at 1000 MB/sec to TCM_Loop virtual SAS ports and
TCM/RAMDISK_DR and TCM/FILEIO backstores running on the Linux Host.

One big item that I did notice was that using a v2.6.34-rc kernel in KVM
guest caused number of problems with SG_IO that eventually required a
reboot on the host machine.  I assume this must have something to do
with upstream linux megaraid_sas driver changes..?  Hannes, any comments
here before taking a look with git bisect..?

Best,

--nab



