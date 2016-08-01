From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: dm-mq and end_clone_request()
Date: Mon, 1 Aug 2016 15:41:31 -0700
Message-ID: <8e265fcc-8021-830e-ffcb-23a8a28ec247@sandisk.com>
References: <6880321d-e14f-169b-d100-6e460dd9bd09@sandisk.com>
	<1110327939.7305916.1469819453678.JavaMail.zimbra@redhat.com>
	<a5c1a149-b1a2-b5a4-2207-bdaf32db3cbd@sandisk.com>
	<757522831.7667712.1470059860543.JavaMail.zimbra@redhat.com>
	<536022978.7668211.1470060125271.JavaMail.zimbra@redhat.com>
	<931235537.7668834.1470060339483.JavaMail.zimbra@redhat.com>
	<1264951811.7684268.1470065187014.JavaMail.zimbra@redhat.com>
	<17da3ab0-233a-2cec-f921-bfd42c953ccc@sandisk.com>
	<20160801175948.GA6685@redhat.com>
	<f9e71e1d-54ca-40fe-a5ea-ae2863c94ff9@sandisk.com>
	<20160801204628.GA94704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160801204628.GA94704@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Laurence Oberman <loberman@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 08/01/2016 01:46 PM, Mike Snitzer wrote:
> Please retry both variant (CONFIG_DM_MQ_DEFAULT=y first) with this patch
> applied.  Interested to see if things look better for you (WARN_ON_ONCEs
> added just to see if we hit the corresponding suspend/stopped state
> while mapping requests -- if so this speaks to an inherently racy
> problem that will need further investigation for a proper fix but
> results from this should let us know if we're closer).
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 1b2f962..0e0f6e0 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -2007,6 +2007,9 @@ static int map_request(struct dm_rq_target_io *tio, struct request *rq,
>  	struct dm_target *ti = tio->ti;
>  	struct request *clone = NULL;
>  
> +	if (WARN_ON_ONCE(unlikely(dm_suspended_md(md))))
> +		return DM_MAPIO_REQUEUE;
> +
>  	if (tio->clone) {
>  		clone = tio->clone;
>  		r = ti->type->map_rq(ti, clone, &tio->info);
> @@ -2722,6 +2725,9 @@ static int dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
>  		dm_put_live_table(md, srcu_idx);
>  	}
>  
> +	if (WARN_ON_ONCE(unlikely(test_bit(BLK_MQ_S_STOPPED, &hctx->state))))
> +		return BLK_MQ_RQ_QUEUE_BUSY;
> +
>  	if (ti->type->busy && ti->type->busy(ti))
>  		return BLK_MQ_RQ_QUEUE_BUSY;

Hello Mike,

The test results with this patch and also the three other patches that
have been posted in the context of this e-mail thread applied on top of
kernel v4.7 are as follows:

(1) CONFIG_DM_MQ_DEFAULT=y and fio running on top of XFS:

>From the system log:

[ ... ]
mpath 254:0: queue_if_no_path 0 -> 1
executing DM ioctl DEV_SUSPEND on mpathbe
mpath 254:0: queue_if_no_path 1 -> 0
__multipath_map(): (a) returning -5
map_request(): clone_and_map_rq() returned -5
dm_complete_request: error = -5
dm_softirq_done: dm-0 tio->error = -5
blk_update_request: I/O error (-5), dev dm-0, sector 311960
[ ... ]

After this test finished, "dmsetup remove_all" failed and the following
message appeared in the system log: "device-mapper: ioctl: remove_all
left 1 open device(s)".

Note: when I reran this test after a reboot "dmsetup remove_all" succeeded.


(2) CONFIG_DM_MQ_DEFAULT=y and fio running on top of ext4:

>From the system log:
[ ... ]
[  146.023067] WARNING: CPU: 2 PID: 482 at drivers/md/dm.c:2748 dm_mq_queue_rq+0xc1/0x150 [dm_mod]
[  146.026073] Workqueue: kblockd blk_mq_run_work_fn
[  146.026083] Call Trace:
[  146.026087]  [<ffffffff81320047>] dump_stack+0x68/0xa1
[  146.026090]  [<ffffffff81061c46>] __warn+0xc6/0xe0
[  146.026092]  [<ffffffff81061d18>] warn_slowpath_null+0x18/0x20
[  146.026098]  [<ffffffffa0286791>] dm_mq_queue_rq+0xc1/0x150 [dm_mod]
[  146.026100]  [<ffffffff81306f7a>] __blk_mq_run_hw_queue+0x1da/0x350
[  146.026102]  [<ffffffff813076c0>] blk_mq_run_work_fn+0x10/0x20
[  146.026105]  [<ffffffff8107efe9>] process_one_work+0x1f9/0x6a0
[  146.026109]  [<ffffffff8107f4d9>] worker_thread+0x49/0x490
[  146.026116]  [<ffffffff81085cda>] kthread+0xea/0x100
[  146.026119]  [<ffffffff81624fbf>] ret_from_fork+0x1f/0x40
[ ... ]
[  146.269194] mpath 254:1: queue_if_no_path 0 -> 1
[  146.276502] executing DM ioctl DEV_SUSPEND on mpathbf
[  146.276556] mpath 254:1: queue_if_no_path 1 -> 0
[  146.276560] __multipath_map(): (a) returning -5
[  146.276561] map_request(): clone_and_map_rq() returned -5
[  146.276562] dm_complete_request: error = -5
[  146.276563] dm_softirq_done: dm-1 tio->error = -5
[  146.276566] blk_update_request: I/O error (-5), dev dm-1, sector 2097144
[ ... ]

After this test finished running "dmsetup remove_all" and unloading ib_srp
succeeded.


(3) CONFIG_DM_MQ_DEFAULT=n and fio running on top of XFS:

The first run of this test passed. During the second run fio reported
an I/O error. From the system log:

[ ... ]
[ 1290.010886] mpath 254:0: queue_if_no_path 0 -> 1
[ 1290.026905] executing DM ioctl DEV_SUSPEND on mpathbe
[ 1290.026960] mpath 254:0: queue_if_no_path 1 -> 0
[ 1290.027001] __multipath_map(): (a) returning -5
[ 1290.027002] map_request(): clone_and_map_rq() returned -5
[ 1290.027003] dm_complete_request: error = -5
[ ... ]


(4) CONFIG_DM_MQ_DEFAULT=n and fio running on top of ext4:

The first two runs of this test passed. After the second run "dmsetup
remove_all" failed and the following error message appeared in the system
log: "device-mapper: ioctl: remove_all left 1 open device(s)". The following
kernel thread might be the one that was holding open /dev/dm-0:

# ps aux | grep dio/
root      5306  0.0  0.0      0     0 ?        S<   15:24   0:00 [dio/dm-0]


Please let me know if you need more information.

Bart.
