From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [scsi] ae86a1c553: BUG:kernel_NULL_pointer_dereference,address
Date: Sat, 27 Jul 2019 10:15:44 +0800
Message-ID: <20190727021523.GB6926@ming.t460p>
References: <20190720030637.14447-3-ming.lei@redhat.com>
 <20190725104629.GC3640@shao2-debian>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190725104629.GC3640@shao2-debian>
Sender: stable-owner@vger.kernel.org
To: kernel test robot <rong.a.chen@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, "Ewan D . Milne" <emilne@redhat.com>, Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, stable@vger.kernel.org, lkp@01.org
List-Id: linux-scsi@vger.kernel.org

Hi,

Thanks for your report!

On Thu, Jul 25, 2019 at 06:46:29PM +0800, kernel test robot wrote:
> FYI, we noticed the following commit (built with gcc-7):
> 
> commit: ae86a1c5530b52dc44a280e78feb0c4eb2dd8595 ("[PATCH V2 2/2] scsi: implement .cleanup_rq callback")
> url: https://github.com/0day-ci/linux/commits/Ming-Lei/blk-mq-add-callback-of-cleanup_rq/20190720-133431
> 
> 
> in testcase: blktests
> with following parameters:
> 
> 	disk: 1SSD
> 	test: block-group1
> 
> 
> 
> on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 4G
> 
> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
> 
> 
> +---------------------------------------------------------------------------------------------------------------+------------+------------+
> |                                                                                                               | bd222ca85f | ae86a1c553 |
> +---------------------------------------------------------------------------------------------------------------+------------+------------+
> | boot_successes                                                                                                | 0          | 0          |
> | boot_failures                                                                                                 | 11         | 14         |
> | BUG:kernel_reboot-without-warning_in_test_stage                                                               | 11         | 1          |
> | BUG:kernel_NULL_pointer_dereference,address                                                                   | 0          | 4          |
> | Oops:#[##]                                                                                                    | 0          | 4          |
> | RIP:scsi_queue_rq                                                                                             | 0          | 4          |
> | Kernel_panic-not_syncing:Fatal_exception                                                                      | 0          | 4          |
> | invoked_oom-killer:gfp_mask=0x                                                                                | 0          | 9          |
> | Mem-Info                                                                                                      | 0          | 9          |
> | page_allocation_failure:order:#,mode:#(GFP_KERNEL|__GFP_RETRY_MAYFAIL),nodemask=(null),cpuset=/,mems_allowed= | 0          | 2          |
> +---------------------------------------------------------------------------------------------------------------+------------+------------+
> 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kernel test robot <rong.a.chen@intel.com>
> 
> 
> [  140.974865] BUG: kernel NULL pointer dereference, address: 000000000000001c

Yeah, I know this issue, and it has been fixed in either V3 or V4.

Thanks,
Ming
