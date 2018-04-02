From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: =?utf-8?B?562U5aSNOiBSZTogW1BBVENIIHYy?=
 =?utf-8?Q?=5D_scsi=3A_Introduc?= =?utf-8?Q?e?= sdev_printk_ratelimited to
 throttlefrequent printk
Date: Mon, 2 Apr 2018 14:29:20 +0900
Message-ID: <20180402052920.GF3795@jagdpanzerIV>
References: <5AC1976F.1040801@huawei.com>
 <201804021314481872986@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201804021314481872986@zte.com.cn>
Sender: linux-kernel-owner@vger.kernel.org
To: wen.yang99@zte.com.cn
Cc: yanaijie@huawei.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Bart.VanAssche@wdc.com, pmladek@suse.com, sergey.senozhatsky.work@gmail.com, tj@kernel.org, jiang.biao2@zte.com.cn, zhong.weidong@zte.com.cn, tan.hu@zte.com.cn
List-Id: linux-scsi@vger.kernel.org

On (04/02/18 13:14), wen.yang99@zte.com.cn wrote:
> 
>    > It's true that this print for the same device is useless. But it's
>    > useful for different devices. Is it possible to limit the print only
>    > for the same device?
> 
>    In our scene, it's  just for the same device (q->queuedata), Thanks.

Yes, what Jason meant was that rate limit struct is shared by different call
sites - including scsi_request_fn() from different devices.

If device1->scsi_request_fn()->sdev_printk_ratelimited() causes printk rate
limit, then messages from device2->scsi_request_fn()->sdev_printk_ratelimited()
may be lost entirely, unless you have enough of them.

	-ss
