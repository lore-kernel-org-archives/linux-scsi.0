From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH V2 2/2] blk-mq: fix blk_mq_tagset_busy_iter
Date: Thu, 2 Aug 2018 11:37:20 -0700
Message-ID: <20180802183720.GA19280@roeck-us.net>
References: <20180802174937.15444-1-ming.lei@redhat.com>
 <20180802174937.15444-3-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180802174937.15444-3-ming.lei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, Mark Brown <broonie@kernel.org>, Matt Hart <matthew.hart@linaro.org>, Johannes Thumshirn <jthumshirn@suse.de>, John Garry <john.garry@huawei.com>, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 03, 2018 at 01:49:37AM +0800, Ming Lei wrote:
> Commit d250bf4e776ff09d5("blk-mq: only iterate over inflight requests
> in blk_mq_tagset_busy_iter") uses 'blk_mq_rq_state(rq) == MQ_RQ_IN_FLIGHT'
> to replace 'blk_mq_request_started(req)', this way is wrong, and causes
> lots of test system hang during booting.
> 
> Fix the issue by using blk_mq_request_started(req) inside bt_tags_iter().
> 
> Fixes: d250bf4e776ff09d5 ("blk-mq: only iterate over inflight requests in blk_mq_tagset_busy_iter")
> Cc: Josef Bacik <josef@toxicpanda.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Matt Hart <matthew.hart@linaro.org>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Hannes Reinecke <hare@suse.com>,
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
> Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Reported-by: Mark Brown <broonie@kernel.org>
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

Tested-by: Guenter Roeck <linux@roeck-us.net>

Test builds (with both patches applied):

Building mips:malta_defconfig:nosmp ... running ..... passed
Building mips:malta_defconfig:smp ... running ..... passed
Building x86_64:q35:Broadwell-noTSX:defconfig:smp:sata:rootfs ... running .....  passed
Building x86_64:q35:IvyBridge:defconfig:smp:nvme:rootfs ... running ..... passed
Building x86_64:q35:SandyBridge:defconfig:smp:usb:rootfs ... running ......  passed
Building x86_64:q35:Haswell:defconfig:smp:usb-uas:rootfs ... running ......  passed
Building x86_64:q35:Skylake-Client:defconfig:smp:mmc:rootfs ... running ......  passed
Building x86_64:q35:Conroe:defconfig:smp:scsi[DC395]:rootfs ... running .......  passed
Building x86_64:q35:Nehalem:defconfig:smp:scsi[AM53C974]:rootfs ... running ....... passed
Building x86_64:q35:Westmere-IBRS:defconfig:smp:scsi[53C810]:rootfs ... running ...... passed
Building x86_64:q35:Skylake-Server:defconfig:smp:scsi[53C895A]:rootfs ...  running ...... passed
Building x86_64:pc:EPYC:defconfig:smp:scsi[MEGASAS]:rootfs ... running ......  passed
Building x86_64:q35:EPYC-IBPB:defconfig:smp:scsi[MEGASAS2]:rootfs ... running ..... passed
Building x86_64:q35:Opteron_G5:defconfig:smp:scsi[FUSION]:rootfs ... running ..... passed
Building x86_64:pc:phenom:defconfig:smp:initrd ... running ..... passed
Building x86_64:q35:Opteron_G1:defconfig:smp:initrd ... running ..... passed
Building x86_64:pc:Opteron_G2:defconfig:smp:sata:rootfs ... running ..... passed
Building x86_64:q35:core2duo:defconfig:smp:usb:rootfs ... running ...... passed
Building x86_64:pc:Opteron_G3:defconfig:nosmp:usb:rootfs ... running .......  passed
Building x86_64:q35:Opteron_G4:defconfig:nosmp:sata:rootfs ... running ......  passed

Guenter
