From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [RFC PATCH v2] scsi: fix oops in scsi_uninit_cmd()
Date: Thu, 21 Mar 2019 11:39:02 -0700
Message-ID: <1553193542.65329.119.camel@acm.org>
References: <20190316020905.14962-1-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190316020905.14962-1-yanaijie@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.com, hch@lst.de, tom.leiming@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Sat, 2019-03-16 at 10:09 +-0800, Jason Yan wrote:
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
+AD4 +AFs-11347.191370+AF0 pstate: a0c00009 (NzCv daif +PAN+UAO113471w

Please verify whether the following patch is a valid alternative for your patch:

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ed34bfbc3844..745ffdda1bc1 100644
--- a/drivers/scsi/sd.c
+-+-+- b/drivers/scsi/sd.c
+AEAAQA -1408,6 +-1408,7 +AEAAQA static void sd+AF8-release(struct gendisk +ACo-disk, fmode+AF8-t mode)
 +AHs
 	struct scsi+AF8-disk +ACo-sdkp +AD0 scsi+AF8-disk(disk)+ADs
 	struct scsi+AF8-device +ACo-sdev +AD0 sdkp-+AD4-device+ADs
+-	struct request+AF8-queue +ACo-q +AD0 sdkp-+AD4-disk-+AD4-queue+ADs
 
 	SCSI+AF8-LOG+AF8-HLQUEUE(3, sd+AF8-printk(KERN+AF8-INFO, sdkp, +ACI-sd+AF8-release+AFw-n+ACI))+ADs
 
+AEAAQA -1417,9 +-1418,12 +AEAAQA static void sd+AF8-release(struct gendisk +ACo-disk, fmode+AF8-t mode)
 	+AH0
 
 	/+ACo
-	 +ACo XXX and what if there are packets in flight and this close()
-	 +ACo XXX is followed by a +ACI-rmmod sd+AF8-mod+ACI?
+-	 +ACo Wait until any requests that are in progress have completed.
+-	 +ACo This is necessary to avoid that e.g. scsi+AF8-end+AF8-request() crashes
+-	 +ACo due to scsi+AF8-disk+AF8-relase() clearing the disk-+AD4-private+AF8-data pointer.
 	 +ACo-/
+-	blk+AF8-mq+AF8-freeze+AF8-queue(q)+ADs
+-	blk+AF8-mq+AF8-unfreeze+AF8-queue(q)+ADs
 
 	scsi+AF8-disk+AF8-put(sdkp)+ADs
 +AH0

Thanks,

Bart.
