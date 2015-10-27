From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/3] megaraid_sas: Convert printk to printk_<level>
Date: Tue, 27 Oct 2015 12:32:18 -0700
Message-ID: <1445974338.2757.44.camel@perches.com>
References: <1445934375-17784-1-git-send-email-wangweidong1@huawei.com>
	 <1445934375-17784-3-git-send-email-wangweidong1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445934375-17784-3-git-send-email-wangweidong1@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Weidong Wang <wangweidong1@huawei.com>
Cc: kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com, JBottomley@odin.com, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-10-27 at 16:26 +0800, Weidong Wang wrote:
> Reduce object size a little by using pr_<level>
> calls instead of printk(KERN_<LEVEL>.

pr_debug does not behave the same as printk(KERN_DEBUG

pr_debug is only active when DEBUG is #defined or dynamic_debug
is enabled.

printk(KERN_DEBUG is always emitted as long as the debug level
is enabled for the console.

At a minimum, your commit message should show you know that.

> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
[]
> @@ -5889,7 +5889,7 @@ static int megasas_mgmt_fasync(int fd, struct file *filep, int mode)
>  		return 0;
>  	}
>  
> -	printk(KERN_DEBUG "megasas: fasync_helper failed [%d]\n", rc);
> +	pr_debug("megasas: fasync_helper failed [%d]\n", rc);

[]

> @@ -6233,7 +6233,7 @@ static int megasas_mgmt_ioctl_aen(struct file *file, unsigned long arg)
>  	u32 wait_time = MEGASAS_RESET_WAIT_TIME;
>  
>  	if (file->private_data != file) {
> -		printk(KERN_DEBUG "megasas: fasync_helper was not "
> +		pr_debug("megasas: fasync_helper was not "
>  		       "called first\n");

Please also coalesce format strings where possible.
