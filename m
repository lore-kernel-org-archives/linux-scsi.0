From: Petr Mladek <pmladek@suse.com>
Subject: Re: =?utf-8?B?562U5aSNOiBSZTog562U5aSNOiBS?=
 =?utf-8?Q?e=3A_=5BPATCH_v2=5D_scsi?= =?utf-8?Q?=3A?= Introduce
 sdev_printk_ratelimited tothrottlefrequent printk
Date: Mon, 9 Apr 2018 10:59:44 +0200
Message-ID: <20180409085944.3bxu5cnvnfj43zs7@pathway.suse.cz>
References: <20180406084901.3353tnfbup6gblfx@pathway.suse.cz>
 <201804091013439214247@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201804091013439214247@zte.com.cn>
Sender: linux-kernel-owner@vger.kernel.org
To: wen.yang99@zte.com.cn
Cc: sergey.senozhatsky.work@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Bart.VanAssche@wdc.com, tj@kernel.org, jiang.biao2@zte.com.cn, zhong.weidong@zte.com.cn, tan.hu@zte.com.cn
List-Id: linux-scsi@vger.kernel.org

On Mon 2018-04-09 10:13:43, wen.yang99@zte.com.cn wrote:
> That's a good idea, but it only solves part of the problem.
>  loopping printks under spinlock, there's two path:
> one path is: 

> scsi_request_fn -->  loop ->  blk_peek_request-> scsi_prep_fn -> scsi_prep_state_check -> sdev_printk

> another path is:

> scsi_request_fn -->  loop ->  sdev_printk

Is this message redundant? It seems to be printed in the same
situations as the messages in scsi_prep_state_check().

In fact, there seems to be a mismatch. scsi_request_fn() prints
about offline device also for sdev->sdev_state == SDEV_DEL.
While scsi_prep_state_check() prints about a dead device
in this case.

Would it make sense to remove the redundant dev_printk() from
scsi_request_fn()?


Then we could add a flag into struct scsi_device that
would remember if we already printed the error in
scsi_prep_state_check() for the given device. It could
be used to print the error only once.

The flag might be scsi_device_state value for which
we printed the error last time. We would need to reset
it scsi_prep_state_check() see another state.

It is a bit hairy but it really does not make much sense
to print the same error message thousand times.

Best Regards,
Petr

PS: Your mail was again strangely formatted. Please, send
mails in plain text format (no html).
