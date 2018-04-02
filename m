From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH v2] scsi: Introduce sdev_printk_ratelimited to throttle
 frequent printk
Date: Mon, 2 Apr 2018 11:10:32 +0900
Message-ID: <20180402021032.GE3795@jagdpanzerIV>
References: <1522634332-151328-1-git-send-email-wen.yang99@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1522634332-151328-1-git-send-email-wen.yang99@zte.com.cn>
Sender: linux-kernel-owner@vger.kernel.org
To: Wen Yang <wen.yang99@zte.com.cn>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Bart.VanAssche@wdc.com, pmladek@suse.com, sergey.senozhatsky.work@gmail.com, tj@kernel.org, jiang.biao2@zte.com.cn, zhong.weidong@zte.com.cn, Tan Hu <tan.hu@zte.com.cn>
List-Id: linux-scsi@vger.kernel.org

Hello,

On (04/02/18 09:58), Wen Yang wrote:
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

Did you test the patch? Rate limiting does not completely remove
printk calls. printk is still there, in a loop under spin_lock.
A big enough I/O request queue can cause the same lockup problems.

	-ss
