From: Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH v3] scsi: Introduce sdev_printk_ratelimited to throttle
 frequent printk
Date: Tue, 3 Apr 2018 17:12:02 +0800
Message-ID: <5AC34562.6030207@huawei.com>
References: <1522735480-159023-1-git-send-email-wen.yang99@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1522735480-159023-1-git-send-email-wen.yang99@zte.com.cn>
Sender: linux-kernel-owner@vger.kernel.org
To: Wen Yang <wen.yang99@zte.com.cn>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Bart.VanAssche@wdc.com, pmladek@suse.com, sergey.senozhatsky.work@gmail.com, tj@kernel.org, jiang.biao2@zte.com.cn, zhong.weidong@zte.com.cn, Tan Hu <tan.hu@zte.com.cn>
List-Id: linux-scsi@vger.kernel.org


On 2018/4/3 14:04, Wen Yang wrote:
> There would be so many same lines printed by frequent printk if one
> disk went wrong, like,
> [  546.185242] sd 0:1:0:0: rejecting I/O to offline device
> [  546.185258] sd 0:1:0:0: rejecting I/O to offline device
> [  546.185280] sd 0:1:0:0: rejecting I/O to offline device
> [  546.185307] sd 0:1:0:0: rejecting I/O to offline device
> [  546.185334] sd 0:1:0:0: rejecting I/O to offline device
> [  546.185364] sd 0:1:0:0: rejecting I/O to offline device
> [  546.185390] sd 0:1:0:0: rejecting I/O to offline device
> [  546.185410] sd 0:1:0:0: rejecting I/O to offline device
> For slow serial console, the frequent printk may be blocked for a
> long time, and if any spin_lock has been acquired before the printk
> like in scsi_request_fn, watchdog could be triggered.
>
> Related disscussion can be found here,
> https://bugzilla.kernel.org/show_bug.cgi?id=199003
> And Petr brought the idea to throttle the frequent printk, it's
> useless to print the same lines frequently after all.
>
> v2: fix some typos
> v3: limit the print only for the same device
>
> Suggested-by: Petr Mladek<pmladek@suse.com>
> Suggested-by: Sergey Senozhatsky<sergey.senozhatsky.work@gmail.com>
> Signed-off-by: Wen Yang<wen.yang99@zte.com.cn>
> Signed-off-by: Jiang Biao<jiang.biao2@zte.com.cn>
> Signed-off-by: Tan Hu<tan.hu@zte.com.cn>
> Reviewed-by: Bart Van Assche<bart.vanassche@wdc.com>
> CC: BartVanAssche<Bart.VanAssche@wdc.com>
> CC: Petr Mladek<pmladek@suse.com>
> CC: Sergey Senozhatsky<sergey.senozhatsky.work@gmail.com>
> CC: Martin K. Petersen<martin.petersen@oracle.com>
> CC: "James E.J. Bottomley"<jejb@linux.vnet.ibm.com>
> CC: Tejun Heo<tj@kernel.org>
> CC: JasonYan<yanaijie@huawei.com>

In my machine it works fine.

Tested-by: Jason Yan <yanaijie@huawei.com>
