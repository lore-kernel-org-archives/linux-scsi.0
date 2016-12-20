From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH] scsi: do not requeue requests unaligned with device sector size
Date: Tue, 20 Dec 2016 00:02:27 -0200
Message-ID: <1482199347-9128-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, gpiccoli@linux.vnet.ibm.com
List-Id: linux-scsi@vger.kernel.org

When a SCSI command (e.g., read operation) is partially completed
with good status and residual bytes (i.e., not all the bytes from
the specified transfer length were transferred) the SCSI midlayer
will update the request/bios with the completed bytes and requeue
the request in order to complete the remainder/pending bytes.

However, when the device sector size is greater than the 512-byte
default/kernel sector size, alignment restrictions and validation
apply (both to the starting logical block address, and the number
of logical blocks to transfer) -- values must be multiples of the
device sector size, otherwise the kernel fails the request in the
preparation stage (e.g., sd_setup_read_write_cmnd() at sd.c file):

  [...] sd 0:0:0:0: [sda] Bad block number requested

Hence, this error message (and the respective failed request) can
be observed on devices with larger sector sizes which may respond
the SCSI command with a SCSI residual size that is unaligned with
the device sector size -- because the requeued request's starting
logical block and number of logical blocks are based on the value
of the remainder/pending bytes.

In order to address this problem, introduce a check for this case
in scsi_io_completion() (before it calls scsi_end_request() which
in turn calls blk_update_request() which is the site that changes
the request's __sector and __data_len fields, which are validated
by sd_setup_read_write_cmnd()).

This check verifies whether there is any residual/remainder bytes
in the (potentially partially) completed requested and calculates
the correctly aligned values for the number of completed bytes to
pass up to scsi_end_request()/blk_update_request() that guarantee
that the requeued request is aligned with the device sector size.

The corner case is when one sector is requested and the response
is partially complete, for which the remainder/pending bytes are
unaligned and no further request would be valid.  On such a case,
the original request is retried after a delay (in case the error
is hopefully due to a temporary condition in the device), but up
to the retry limit (in case the condition is permanent, e.g. bad
sector in the medium), after which the request is finally failed.

In order to reproduce and verify this problem, the virtio_scsi.c
file can be modified to respond to 3 'special' SCSI commands, on
which partial completions are introduced (described in the patch).

This is the guest's disk test image and libvirt XML snippets for
the 4k-sector disk using the virtio scsi driver:

    # qemu-img create -f qcow2 /var/lib/libvirt/images/test.qcow2 128G

    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2'/>
      <source file='/var/lib/libvirt/images/test.qcow2'/>
      <blockio logical_block_size='4096' physical_block_size='4096'/>
      <target dev='sda' bus='scsi'/>
      <address type='drive' controller='0' bus='0' target='0' unit='0'/>
    </disk>

    <controller type='scsi' index='0' model='virtio-scsi'>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x05'
function='0x0'/>
    </controller>

And the verification in the guest:

    # cat /sys/block/sda/queue/physical_block_size
    4096

    # cat /sys/block/sda/queue/hw_sector_size
    4096

This is the patch to virtio_scsi.c (lines prefixed with ' ___ '):

 ___ --- a/drivers/scsi/virtio_scsi.c
 ___ +++ b/drivers/scsi/virtio_scsi.c
 ___ @@ -153,11 +153,45 @@
 ___  	struct virtio_scsi_cmd_resp *resp = &cmd->resp.cmd;
 ___  	struct virtio_scsi_target_state *tgt =
 ___  				scsi_target(sc->device)->hostdata;
 ___ +	static int debug_failures = 0;
 ___
 ___  	dev_dbg(&sc->device->sdev_gendev,
 ___  		"cmd %p response %u status %#02x sense_len %u\n",
 ___  		sc, resp->response, resp->status, resp->sense_len);
 ___
 ___ +	// DEBUG: filter this CDB for testing purposes.
 ___ +	// CDB: Read(10) 28 00 01 02 03 xx 00 00 yy 00
 ___ +	// (xx: LSB of the LBA, and yy: LSB of the LEN)
 ___ +	if ((sc->cmnd[0] == 0x28) && (sc->cmnd[1] == 0x00)
 ___ +	&&  (sc->cmnd[2] == 0x01) && (sc->cmnd[3] == 0x02)
 ___ +	&&  (sc->cmnd[4] == 0x03) && (sc->cmnd[6] == 0x00)
 ___ +	&&  (sc->cmnd[7] == 0x00) && (sc->cmnd[9] == 0x00)) {
 ___ +
 ___ +		// Test 1:
 ___ +		// - LBA: 01 02 03 _04_
 ___ +		// - LEN: two sectors (2 * 4k = 8k)
 ___ +		// - Action: complete 5k out of 8k (3k residual)
 ___ +		if ((sc->cmnd[5] == 0x04) && (sc->cmnd[8] == 0x02))
 ___ +			resp->resid = 6 * 512;
 ___ +
 ___ +		// Test 2:
 ___ +		// - LBA: 01 02 03 _04_
 ___ +		// - LEN: one sector (1 * 4k = 4k)
 ___ +		// - Action: complete 3k out of 4k (1k residual)
 ___ +		//           always.
 ___ +		if ((sc->cmnd[5] == 0x04) && (sc->cmnd[8] == 0x01))
 ___ +			resp->resid = 2 * 512;
 ___ +
 ___ +		// Test 3:
 ___ +		// - LBA: 01 02 03 _08_
 ___ +		// - LEN: one sector (1 * 4k = 4k)
 ___ +		// - Action: complete 3k out of 4k (1k residual)
 ___ +		//           but on every 4th attempt (complete 4k)
 ___ +		if ((sc->cmnd[5] == 0x08) &&  (sc->cmnd[8] == 0x01)
 ___ +		&&  (++debug_failures % 4 != 0))
 ___ +			resp->resid = 2 * 512;
 ___ +	}
 ___ +
 ___  	sc->result = resp->status;
 ___  	virtscsi_compute_resid(sc, virtio32_to_cpu(vscsi->vdev,
 ___ resp->resid));
 ___  	switch (resp->response) {

Without this patch all the 3 tests fail w/ 'Bad block number requested'.

  Test 1)

  # dd if=/dev/sda of=/dev/null bs=8192 count=1 skip=8454530 iflag=direct
  dd: error reading ‘/dev/sda’: Input/output error
  0+0 records in
  0+0 records out
  0 bytes (0 B) copied, 0.00260138 s, 0.0 kB/s

  # dmesg
  [...] sd 0:0:0:0: [sda] Bad block number requested

And if you look with more detail using scsi_logging_level (HLQUEUE = 2
and HLCOMPLETE = 2) the unaligned requeued request is clearly visible
(on a 4k-sector device, block/count must be multiples of 8 512-byte sectors)
then it fails:

    # echo $(( (2<<21) + (2<<24) )) > /proc/sys/dev/scsi/logging_level;

    Test 1)

    # dmesg -c >/dev/null; dd if=/dev/sda of=/dev/null bs=8192 count=1
      skip=8454530 iflag=direct 2>/dev/null; dmesg
    [...] sd 0:0:0:0: [sda] sd_setup_read_write_cmnd: block=135272480, count=16
    [...] sd 0:0:0:0: [sda] tag#0 sd_done: completed 8192 of 8192 bytes
    [...] sd 0:0:0:0: [sda] tag#0 16 sectors total, 5120 bytes done.
    [...] sd 0:0:0:0: [sda] sd_setup_read_write_cmnd: block=135272490, count=6
    [...] sd 0:0:0:0: [sda] Bad block number requested
    [...] sd 0:0:0:0: tag#0 0 sectors total, 0 bytes done.

With the patch, this happily changes into another 4k-sized request:

    # dmesg -c >/dev/null; dd if=/dev/sda of=/dev/null bs=8192 count=1
      skip=8454530 iflag=direct 2>/dev/null; dmesg
    [...] sd 0:0:0:0: [sda] sd_setup_read_write_cmnd: block=135272480, count=16
    [...] sd 0:0:0:0: [sda] tag#0 sd_done: completed 8192 of 8192 bytes
    [...] sd 0:0:0:0: [sda] tag#0 16 sectors total, 5120 bytes done.
    [...] sd 0:0:0:0: [sda] tag#0 checking 5120 bytes for alignment
                            (sector size 4096, remainder 1024, resid 3072)
    [...] sd 0:0:0:0: [sda] sd_setup_read_write_cmnd: block=135272488, count=8
    [...] sd 0:0:0:0: [sda] tag#0 sd_done: completed 4096 of 4096 bytes
    [...] sd 0:0:0:0: [sda] tag#0 8 sectors total, 4096 bytes done.
    [...] sd 0:0:0:0: tag#0 0 sectors total, 0 bytes done.

And verifying the one sector corner case in which all retries are failed
by the driver (when we must finally fail the request up the stack), we
observe the original request plus five retries, then the I/O error occurs:

    Test 2)

    # dmesg -c >/dev/null; dd if=/dev/sda of=/dev/null bs=4096 count=1
      skip=16909060 iflag=direct 2>/dev/null; dmesg
    [...] sd 0:0:0:0: [sda] sd_setup_read_write_cmnd: block=135272480, count=8
    [...] sd 0:0:0:0: [sda] tag#0 sd_done: completed 4096 of 4096 bytes
    [...] sd 0:0:0:0: [sda] tag#0 8 sectors total, 3072 bytes done.
    [...] sd 0:0:0:0: [sda] tag#0 checking 3072 bytes for alignment
                            (sector size 4096, remainder 3072, resid 1024)
    [...] sd 0:0:0:0: [sda] tag#0 sd_done: completed 4096 of 4096 bytes
    [...] sd 0:0:0:0: [sda] tag#0 8 sectors total, 3072 bytes done.
    [...] sd 0:0:0:0: [sda] tag#0 checking 3072 bytes for alignment
                            (sector size 4096, remainder 3072, resid 1024)
    [...] sd 0:0:0:0: [sda] tag#0 sd_done: completed 4096 of 4096 bytes
    [...] sd 0:0:0:0: [sda] tag#0 8 sectors total, 3072 bytes done.
    [...] sd 0:0:0:0: [sda] tag#0 checking 3072 bytes for alignment
                            (sector size 4096, remainder 3072, resid 1024)
    [...] sd 0:0:0:0: [sda] tag#0 sd_done: completed 4096 of 4096 bytes
    [...] sd 0:0:0:0: [sda] tag#0 8 sectors total, 3072 bytes done.
    [...] sd 0:0:0:0: [sda] tag#0 checking 3072 bytes for alignment
                            (sector size 4096, remainder 3072, resid 1024)
    [...] sd 0:0:0:0: [sda] tag#0 sd_done: completed 4096 of 4096 bytes
    [...] sd 0:0:0:0: [sda] tag#0 8 sectors total, 3072 bytes done.
    [...] sd 0:0:0:0: [sda] tag#0 checking 3072 bytes for alignment
                            (sector size 4096, remainder 3072, resid 1024)
    [...] sd 0:0:0:0: [sda] tag#0 sd_done: completed 4096 of 4096 bytes
    [...] sd 0:0:0:0: [sda] tag#0 8 sectors total, 3072 bytes done.
    [...] sd 0:0:0:0: [sda] tag#0 checking 3072 bytes for alignment
                            (sector size 4096, remainder 3072, resid 1024)
    [...] sd 0:0:0:0: [sda] tag#0 FAILED Result: hostbyte=DID_TIME_OUT driverbyte=DRIVER_OK
    [...] sd 0:0:0:0: [sda] tag#0 CDB: Read(10) 28 00 01 02 03 04 00 00 01 00
    [...] blk_update_request: I/O error, dev sda, sector 135272480
    [...] sd 0:0:0:0: tag#0 0 sectors total, 0 bytes done.

And now the one sector corner case when eventually one retry succeeds
(the original request plus three retries, of which the last retry passes)
and the request is successfully passed up the stack and finished:

    Test 3)

    # dmesg -c >/dev/null; dd if=/dev/sda of=/dev/null bs=4096 count=1
      skip=16909064 iflag=direct 2>/dev/null; dmesg
    [...] sd 0:0:0:0: [sda] sd_setup_read_write_cmnd: block=135272512, count=8
    [...] sd 0:0:0:0: [sda] tag#0 sd_done: completed 4096 of 4096 bytes
    [...] sd 0:0:0:0: [sda] tag#0 8 sectors total, 3072 bytes done.
    [...] sd 0:0:0:0: [sda] tag#0 checking 3072 bytes for alignment
                      (sector size 4096, remainder 3072, resid 1024)
    [...] sd 0:0:0:0: [sda] tag#0 sd_done: completed 4096 of 4096 bytes
    [...] sd 0:0:0:0: [sda] tag#0 8 sectors total, 3072 bytes done.
    [...] sd 0:0:0:0: [sda] tag#0 checking 3072 bytes for alignment
                      (sector size 4096, remainder 3072, resid 1024)
    [...] sd 0:0:0:0: [sda] tag#0 sd_done: completed 4096 of 4096 bytes
    [...] sd 0:0:0:0: [sda] tag#0 8 sectors total, 3072 bytes done.
    [...] sd 0:0:0:0: [sda] tag#0 checking 3072 bytes for alignment
                      (sector size 4096, remainder 3072, resid 1024)
    [...] sd 0:0:0:0: [sda] tag#0 sd_done: completed 4096 of 4096 bytes
    [...] sd 0:0:0:0: [sda] tag#0 8 sectors total, 4096 bytes done.
    [...] sd 0:0:0:0: tag#0 0 sectors total, 0 bytes done.

Apologies for the ridiculously long commit message with description and
test-cases, but this problem has been relatively difficult to reproduce
and understand, so I thought the documentation/instructions for working
with that could be helpful for others too.

Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
---
 drivers/scsi/scsi_lib.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 2cca9cffc63f..190ab28cfb2d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -821,6 +821,45 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	}
 
 	/*
+	 * If the SCSI command is successful but has residual bytes,
+	 * align good_bytes to the device sector size to ensure the
+	 * requeued request (to complete the remainder transfer) is
+	 * also aligned and does not fail alignment/size validation.
+	 */
+	if (unlikely(!result && scsi_get_resid(cmd) &&
+		     req->cmd_type == REQ_TYPE_FS)) {
+
+		unsigned int sector_size = cmd->device->sector_size;
+		unsigned int remainder = good_bytes % sector_size;
+		int resid = scsi_get_resid(cmd);
+
+		SCSI_LOG_HLCOMPLETE(1, scmd_printk(KERN_INFO, cmd,
+			"checking %d bytes for alignment "
+			"(sector size %u, remainder %u, resid %d)\n",
+			good_bytes, sector_size, remainder, resid));
+
+		if (remainder) {
+			good_bytes -= remainder;
+			resid += remainder;
+			scsi_set_resid(cmd, resid);
+
+			/*
+			 * If less than one device sector has completed, retry the
+			 * request after delay (up to the retry limit) or timeout.
+			 */
+			if (!good_bytes) {
+				if ((++cmd->retries) <= cmd->allowed
+				&& !scsi_noretry_cmd(cmd)) {
+					goto delayed_retry;
+				} else {
+					set_host_byte(cmd, DID_TIME_OUT);
+					goto error;
+				}
+			}
+		}
+	}
+
+	/*
 	 * special case: failed zero length commands always need to
 	 * drop down into the retry code. Otherwise, if we finished
 	 * all bytes in the request we are done now.
@@ -845,6 +884,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	if (result == 0)
 		goto requeue;
 
+	error:
 	error = __scsi_error_from_host_byte(cmd, result);
 
 	if (host_byte(result) == DID_RESET) {
@@ -985,6 +1025,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		__scsi_queue_insert(cmd, SCSI_MLQUEUE_EH_RETRY, 0);
 		break;
 	case ACTION_DELAYED_RETRY:
+	delayed_retry:
 		/* Retry the same command after a delay */
 		__scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY, 0);
 		break;
-- 
1.8.3.1

