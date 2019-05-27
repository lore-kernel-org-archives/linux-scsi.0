From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi: scsi_dh_alua: Fix possible null-ptr-deref
Date: Mon, 27 May 2019 08:08:37 -0700
Message-ID: <dea3ea6b-66e7-a325-539f-63695cd87e51@acm.org>
References: <20190527142209.21768-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190527142209.21768-1-yuehaibing@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>, jejb@linux.ibm.com, martin.petersen@oracle.com, axboe@kernel.dk, hare@suse.de
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 5/27/19 7:22 AM, YueHaibing wrote:
> If alloc_workqueue fails in alua_init, it should return
> -ENOMEM, otherwise it will trigger null-ptr-deref while
> unloading module which calls destroy_workqueue dereference
> wq->lock like this:
> 
> BUG: KASAN: null-ptr-deref in __lock_acquire+0x6b4/0x1ee0
> Read of size 8 at addr 0000000000000080 by task syz-executor.0/7045
> 
> CPU: 0 PID: 7045 Comm: syz-executor.0 Tainted: G         C        5.1.0+ #28
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1
> Call Trace:
>  dump_stack+0xa9/0x10e
>  __kasan_report+0x171/0x18d
>  ? __lock_acquire+0x6b4/0x1ee0
>  kasan_report+0xe/0x20
>  __lock_acquire+0x6b4/0x1ee0
>  lock_acquire+0xb4/0x1b0
>  __mutex_lock+0xd8/0xb90
>  drain_workqueue+0x25/0x290
>  destroy_workqueue+0x1f/0x3f0
>  __x64_sys_delete_module+0x244/0x330
>  do_syscall_64+0x72/0x2a0
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: 03197b61c5ec ("scsi_dh_alua: Use workqueue for RTPG")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index d7ac498ba35a..2a9dcb8973b7 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -1174,10 +1174,8 @@ static int __init alua_init(void)
>  	int r;
>  
>  	kaluad_wq = alloc_workqueue("kaluad", WQ_MEM_RECLAIM, 0);
> -	if (!kaluad_wq) {
> -		/* Temporary failure, bypass */
> -		return SCSI_DH_DEV_TEMP_BUSY;
> -	}
> +	if (!kaluad_wq)
> +		return -ENOMEM;
>  
>  	r = scsi_register_device_handler(&alua_dh);
>  	if (r != 0) {
> 

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
