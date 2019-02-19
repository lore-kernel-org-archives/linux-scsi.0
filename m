From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [RFC PATCH] scsi: fix oops in scsi_uninit_cmd()
Date: Tue, 19 Feb 2019 08:56:28 -0800
Message-ID: <1550595388.31902.133.camel@acm.org>
References: <20190219072743.13606-1-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190219072743.13606-1-yanaijie@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, Steffen Maier <maier@linux.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2019-02-19 at 15:27 +-0800, Jason Yan wrote:
+AD4 If we remove the scsi disk when running io with fio, oops occured with
+AD4 the following condition.
+AD4 
+AD4 +AFs-scsi+AF8-eh+AF8-0+AF0                              +AFs-fio+AF0
+AD4 scsi+AF8-end+AF8-request
+AD4   -+AD4-blk+AF8-update+AF8-request
+AD4     -+AD4-end+AF8-bio(io returned to userspace)
+AD4                                          close
+AD4                                            -+AD4-sd+AF8-release
+AD4                                               -+AD4-scsi+AF8-disk+AF8-put
+AD4                                                  -+AD4-scsi+AF8-disk+AF8-release
+AD4                                                      -+AD4-disk-+AD4-private+AF8-data +AD0 NULL+ADs
+AD4 
+AD4   -+AD4-scsi+AF8-mq+AF8-uninit+AF8-cmd
+AD4     -+AD4-scsi+AF8-uninit+AF8-cmd
+AD4       -+AD4-scsi+AF8-cmd+AF8-to+AF8-driver
+AD4     -+AD4-drv is NULL, Oops
+AD4 
+AD4 There is a small window between blk+AF8-update+AF8-request() and
+AD4 scsi+AF8-mq+AF8-uninit+AF8-cmd() that scsi disk may have been released. This will
+AD4 cause a oops like below:
+AD4 
+AD4 Unable to handle kernel NULL pointer dereference at virtual address
+AD4 0000000000000000
+AD4 s/sync.c:67, func+AD0-xfer, error+AD0-In+AFs-11347.116050+AF0 Mem abort info:
+AD4 put/output error
+AD4 +AFs-11347.121598+AF0   ESR +AD0 0x96000006
+AD4 +AFs-11347.126200+AF0   Exception class +AD0 DABT (current EL), IL +AD0 32 bits
+AD4 +AFs-11347.132117+AF0   SET +AD0 0, FnV +AD0 0
+AD4 +AFs-11347.135170+AF0   EA +AD0 0, S1PTW +AD0 0
+AD4 +AFs-11347.138308+AF0 Data abort info:
+AD4 +AFs-11347.141186+AF0   ISV +AD0 0, ISS +AD0 0x00000006
+AD4 +AFs-11347.145019+AF0   CM +AD0 0, WnR +AD0 0
+AD4 +AFs-11347.147977+AF0 user pgtable: 4k pages, 48-bit VAs, pgdp +AD0
+AD4 00000000a67aece2
+AD4 +AFs-11347.154591+AF0 +AFs-0000000000000000+AF0 pgd+AD0-0000002f90774003,
+AD4 pud+AD0-0000002fab098003, pmd+AD0-0000000000000000
+AD4 +AFs-11347.163304+AF0 Internal error: Oops: 96000006 +AFsAIw-1+AF0 PREEMPT SMP
+AD4 +AFs-11347.168870+AF0 Modules linked in: hisi+AF8-sas+AF8-v3+AF8-hw hisi+AF8-sas+AF8-main libsas
+AD4 +AFs-11347.175044+AF0 CPU: 56 PID: 4294 Comm: scsi+AF8-eh+AF8-2 Not tainted
+AD4 4.19.0-g8052059-dirty +ACM-2
+AD4 +AFs-11347.182600+AF0 Hardware name: Huawei D06/D06, BIOS Hisilicon D06 UEFI
+AD4 RC0 - B601 (V6.01) 11/08/2018
+AD4 +AFs-11347.191370+AF0 pstate: a0c00009 (NzCv daif +-PAN +-UAO)
+AD4 +AFs-11347.196155+AF0 pc : scsi+AF8-uninit+AF8-cmd+-0x24/0x3c
+AD4 +AFs-11347.200240+AF0 lr : scsi+AF8-mq+AF8-uninit+AF8-cmd+-0x1c/0x30
+AD4 +AFs-11347.204583+AF0 sp : ffff000024dabb60
+AD4 +AFs-11347.207884+AF0 x29: ffff000024dabb60 x28: ffff000024dabd38
+AD4 +AFs-11347.213184+AF0 x27: ffff000000f5b3a8 x26: ffff7df3b0181600
+AD4 +AFs-11347.218484+AF0 x25: 0000000000000000 x24: ffff803bc5d36778
+AD4 +AFs-11347.223783+AF0 x23: 000000000000000a x22: 0000000000000000
+AD4 +AFs-11347.229082+AF0 x21: ffff803bc7397000 x20: ffff802f9148e530
+AD4 +AFs-11347.234381+AF0 x19: ffff802f9148e530 x18: ffff7e0000000000
+AD4 +AFs-11347.239679+AF0 x17: 0000000000000000 x16: 0000002f9e37d000
+AD4 +AFs-11347.244979+AF0 x15: ffff7e0000000000 x14: 3863206336203839
+AD4 +AFs-11347.250278+AF0 x13: 2036302030302038 x12: a46fac3d0d363d00
+AD4 +AFs-11347.255578+AF0 x11: ffffffffffffffff x10: a46fac3d0d363d00
+AD4 +AFs-11347.260877+AF0 x9 : 0000000040040000 x8 : 000000000000eb4b
+AD4 +AFs-11347.266177+AF0 x7 : ffff000009771000 x6 : 0000000000210d00
+AD4 +AFs-11347.271476+AF0 x5 : ffff803bc9f50000 x4 : 0000000000000000
+AD4 +AFs-11347.276775+AF0 x3 : ffff802fb02b4380 x2 : ffff802f9148e400
+AD4 +AFs-11347.282075+AF0 x1 : 0000000000000000 x0 : ffff802f9148e530
+AD4 +AFs-11347.287375+AF0 Process scsi+AF8-eh+AF8-2 (pid: 4294, stack limit +AD0
+AD4 0x000000007d2257f8)
+AD4 +AFs-11347.294323+AF0 Call trace:
+AD4 Jobs: 6 (f+AD0-6): +AFs-R+AFs-RRR1XXX1XRR3+AF0 47.296758+AF0  scsi+AF8-uninit+AF8-cmd+-0x24/0x3c
+AD4 +AFs-22.7+ACU done+AF0 +AFs-1516MB/0KB/0KB /s+AF0 +AFs-754/0/0 iops+AF0 +AFs-eta 08m:39s+AF0
+AD4 +AFs-11347.308390+AF0  scsi+AF8-mq+AF8-uninit+AF8-cmd+-0x1c/0x30
+AD4 +AFs-11347.312387+AF0  scsi+AF8-end+AF8-request+-0x7c/0x1b8
+AD4 +AFs-11347.316297+AF0  scsi+AF8-io+AF8-completion+-0x464/0x668
+AD4 +AFs-11347.320467+AF0  scsi+AF8-finish+AF8-command+-0xbc/0x160
+AD4 +AFs-11347.324636+AF0  scsi+AF8-eh+AF8-flush+AF8-done+AF8-q+-0x10c/0x170
+AD4 +AFs-11347.328990+AF0  sas+AF8-scsi+AF8-recover+AF8-host+-0x84c/0xa98 +AFs-libsas+AF0
+AD4 +AFs-11347.334202+AF0  scsi+AF8-error+AF8-handler+-0x140/0x5b0
+AD4 +AFs-11347.338374+AF0  kthread+-0x100/0x12c
+AD4 +AFs-11347.341590+AF0  ret+AF8-from+AF8-fork+-0x10/0x18
+AD4 +AFs-11347.345153+AF0 Code: 71000c3f 540000e9 f9404c41 f941f421 (f9400021)
+AD4 +AFs-11347.351234+AF0 ---+AFs end trace f496aacdaa1dcc51 +AF0----
+AD4 
+AD4 To fix this, get a refcount of scsi+AF8-disk in sd+AF8-init+AF8-command() to ensure
+AD4 it will not be released before sd+AF8-uninit+AF8-command().
+AD4 
+AD4 Signed-off-by: Jason Yan +ADw-yanaijie+AEA-huawei.com+AD4
+AD4 ---
+AD4  drivers/scsi/sd.c +AHw 46 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+------------
+AD4  1 file changed, 35 insertions(+-), 11 deletions(-)
+AD4 
+AD4 diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
+AD4 index 5464d467e23e..6bdb8fbb570f 100644
+AD4 --- a/drivers/scsi/sd.c
+AD4 +-+-+- b/drivers/scsi/sd.c
+AD4 +AEAAQA -1249,42 +-1249,64 +AEAAQA static blk+AF8-status+AF8-t sd+AF8-setup+AF8-read+AF8-write+AF8-cmnd(struct scsi+AF8-cmnd +ACo-SCpnt)
+AD4  static blk+AF8-status+AF8-t sd+AF8-init+AF8-command(struct scsi+AF8-cmnd +ACo-cmd)
+AD4  +AHs
+AD4  	struct request +ACo-rq +AD0 cmd-+AD4-request+ADs
+AD4 +-	struct scsi+AF8-disk +ACo-sdkp +AD0 NULL+ADs
+AD4 +-	blk+AF8-status+AF8-t ret+ADs
+AD4  
+AD4  	switch (req+AF8-op(rq)) +AHs
+AD4  	case REQ+AF8-OP+AF8-DISCARD:
+AD4  		switch (scsi+AF8-disk(rq-+AD4-rq+AF8-disk)-+AD4-provisioning+AF8-mode) +AHs
+AD4  		case SD+AF8-LBP+AF8-UNMAP:
+AD4 -			return sd+AF8-setup+AF8-unmap+AF8-cmnd(cmd)+ADs
+AD4 +-			ret +AD0 sd+AF8-setup+AF8-unmap+AF8-cmnd(cmd)+ADs
+AD4 +-			break+ADs
+AD4  		case SD+AF8-LBP+AF8-WS16:
+AD4 -			return sd+AF8-setup+AF8-write+AF8-same16+AF8-cmnd(cmd, true)+ADs
+AD4 +-			ret +AD0 sd+AF8-setup+AF8-write+AF8-same16+AF8-cmnd(cmd, true)+ADs
+AD4 +-			break+ADs
+AD4  		case SD+AF8-LBP+AF8-WS10:
+AD4 -			return sd+AF8-setup+AF8-write+AF8-same10+AF8-cmnd(cmd, true)+ADs
+AD4 +-			ret +AD0 sd+AF8-setup+AF8-write+AF8-same10+AF8-cmnd(cmd, true)+ADs
+AD4 +-			break+ADs
+AD4  		case SD+AF8-LBP+AF8-ZERO:
+AD4 -			return sd+AF8-setup+AF8-write+AF8-same10+AF8-cmnd(cmd, false)+ADs
+AD4 +-			ret +AD0 sd+AF8-setup+AF8-write+AF8-same10+AF8-cmnd(cmd, false)+ADs
+AD4 +-			break+ADs
+AD4  		default:
+AD4 -			return BLK+AF8-STS+AF8-TARGET+ADs
+AD4 +-			ret +AD0 BLK+AF8-STS+AF8-TARGET+ADs
+AD4 +-			break+ADs
+AD4  		+AH0
+AD4 +-		break+ADs
+AD4  	case REQ+AF8-OP+AF8-WRITE+AF8-ZEROES:
+AD4 -		return sd+AF8-setup+AF8-write+AF8-zeroes+AF8-cmnd(cmd)+ADs
+AD4 +-		ret +AD0 sd+AF8-setup+AF8-write+AF8-zeroes+AF8-cmnd(cmd)+ADs
+AD4 +-		break+ADs
+AD4  	case REQ+AF8-OP+AF8-WRITE+AF8-SAME:
+AD4 -		return sd+AF8-setup+AF8-write+AF8-same+AF8-cmnd(cmd)+ADs
+AD4 +-		ret +AD0 sd+AF8-setup+AF8-write+AF8-same+AF8-cmnd(cmd)+ADs
+AD4 +-		break+ADs
+AD4  	case REQ+AF8-OP+AF8-FLUSH:
+AD4 -		return sd+AF8-setup+AF8-flush+AF8-cmnd(cmd)+ADs
+AD4 +-		ret +AD0 sd+AF8-setup+AF8-flush+AF8-cmnd(cmd)+ADs
+AD4 +-		break+ADs
+AD4  	case REQ+AF8-OP+AF8-READ:
+AD4  	case REQ+AF8-OP+AF8-WRITE:
+AD4 -		return sd+AF8-setup+AF8-read+AF8-write+AF8-cmnd(cmd)+ADs
+AD4 +-		ret +AD0 sd+AF8-setup+AF8-read+AF8-write+AF8-cmnd(cmd)+ADs
+AD4 +-		break+ADs
+AD4  	case REQ+AF8-OP+AF8-ZONE+AF8-RESET:
+AD4 -		return sd+AF8-zbc+AF8-setup+AF8-reset+AF8-cmnd(cmd)+ADs
+AD4 +-		ret +AD0 sd+AF8-zbc+AF8-setup+AF8-reset+AF8-cmnd(cmd)+ADs
+AD4 +-		break+ADs
+AD4  	default:
+AD4  		WARN+AF8-ON+AF8-ONCE(1)+ADs
+AD4 -		return BLK+AF8-STS+AF8-NOTSUPP+ADs
+AD4 +-		ret +AD0 BLK+AF8-STS+AF8-NOTSUPP+ADs
+AD4 +-		break+ADs
+AD4  	+AH0
+AD4 +-
+AD4 +-	if (+ACE-ret) +AHs
+AD4 +-		sdkp +AD0 scsi+AF8-disk(rq-+AD4-rq+AF8-disk)+ADs
+AD4 +-		get+AF8-device(+ACY-sdkp-+AD4-dev)+ADs
+AD4 +-	+AH0
+AD4 +-
+AD4 +-	return ret+ADs
+AD4  +AH0
+AD4  
+AD4  static void sd+AF8-uninit+AF8-command(struct scsi+AF8-cmnd +ACo-SCpnt)
+AD4  +AHs
+AD4  	struct request +ACo-rq +AD0 SCpnt-+AD4-request+ADs
+AD4  	u8 +ACo-cmnd+ADs
+AD4 +-	struct scsi+AF8-disk +ACo-sdkp +AD0 NULL+ADs
+AD4  
+AD4  	if (rq-+AD4-rq+AF8-flags +ACY RQF+AF8-SPECIAL+AF8-PAYLOAD)
+AD4  		mempool+AF8-free(rq-+AD4-special+AF8-vec.bv+AF8-page, sd+AF8-page+AF8-pool)+ADs
+AD4 +AEAAQA -1295,6 +-1317,8 +AEAAQA static void sd+AF8-uninit+AF8-command(struct scsi+AF8-cmnd +ACo-SCpnt)
+AD4  		SCpnt-+AD4-cmd+AF8-len +AD0 0+ADs
+AD4  		mempool+AF8-free(cmnd, sd+AF8-cdb+AF8-pool)+ADs
+AD4  	+AH0
+AD4 +-	sdkp +AD0 scsi+AF8-disk(rq-+AD4-rq+AF8-disk)+ADs
+AD4 +-	put+AF8-device(+ACY-sdkp-+AD4-dev)+ADs
+AD4  +AH0

Hi Jens and Christoph,

My interpretation of the above bug report and patch is that this is a
regression in the SCSI sd driver due to the switch from the legacy block
layer to scsi-mq. The above patch introduces two atomic operations in the
hot path and hence would introduce a performance regression. I think this
can be avoided by making sure that sd+AF8-uninit+AF8-command() gets called before
the request tag is freed. What changes would be required to make the block
layer core call sd+AF8-uninit+AF8-command() before the request tag is freed? Would
introducing prep+AF8-rq+AF8-fn and unprep+AF8-rq+AF8-fn callbacks in struct blk+AF8-mq+AF8-ops and
making sure that the SCSI core sets these callback function pointers
appropriately be sufficient? Would such a change allow to simplify the NVMe
initiator driver? Are there any alternatives to this approach that are more
elegant?

Thanks,

Bart.
