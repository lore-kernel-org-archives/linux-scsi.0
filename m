From: Mukesh Ojha <mojha@codeaurora.org>
Subject: Re: [RESEND PATCH] scsi: qedi: Fix global-out-of-bounds bug in qedi
 dbg function
Date: Thu, 28 Mar 2019 19:20:15 +0530
Message-ID: <de12f110-48c1-8d31-4001-5e3e95858d21@codeaurora.org>
References: <20190328075428.25432-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190328075428.25432-1-yuehaibing@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yue Haibing <yuehaibing@huawei.com>, qla2xxx-upstream@qlogic.com, jejb@linux.ibm.com, martin.petersen@oracle.com, mrangankar@marvell.com, nilesh.javali@cavium.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On 3/28/2019 1:24 PM, Yue Haibing wrote:
> From: YueHaibing <yuehaibing@huawei.com>
>
> KASAN report this:
>
> BUG: KASAN: global-out-of-bounds in qedi_dbg_err+0xda/0x330 [qedi]
> Read of size 31 at addr ffffffffc12b0ae0 by task syz-executor.0/2429
>
> CPU: 0 PID: 2429 Comm: syz-executor.0 Not tainted 5.0.0-rc7+ #45
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
> Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0xfa/0x1ce lib/dump_stack.c:113
>   print_address_description+0x1c4/0x270 mm/kasan/report.c:187
>   kasan_report+0x149/0x18d mm/kasan/report.c:317
>   memcpy+0x1f/0x50 mm/kasan/common.c:130
>   qedi_dbg_err+0xda/0x330 [qedi]
>   ? 0xffffffffc12d0000
>   qedi_init+0x118/0x1000 [qedi]
>   ? 0xffffffffc12d0000
>   ? 0xffffffffc12d0000
>   ? 0xffffffffc12d0000
>   do_one_initcall+0xfa/0x5ca init/main.c:887
>   do_init_module+0x204/0x5f6 kernel/module.c:3460
>   load_module+0x66b2/0x8570 kernel/module.c:3808
>   __do_sys_finit_module+0x238/0x2a0 kernel/module.c:3902
>   do_syscall_64+0x147/0x600 arch/x86/entry/common.c:290
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x462e99
> Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f2d57e55c58 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
> RAX: ffffffffffffffda RBX: 000000000073bfa0 RCX: 0000000000462e99
> RDX: 0000000000000000 RSI: 00000000200003c0 RDI: 0000000000000003
> RBP: 00007f2d57e55c70 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f2d57e566bc
> R13: 00000000004bcefb R14: 00000000006f7030 R15: 0000000000000004
>
> The buggy address belongs to the variable:
>   __func__.67584+0x0/0xffffffffffffd520 [qedi]
>
> Memory state around the buggy address:
>   ffffffffc12b0980: fa fa fa fa 00 04 fa fa fa fa fa fa 00 00 05 fa
>   ffffffffc12b0a00: fa fa fa fa 00 00 04 fa fa fa fa fa 00 05 fa fa
>> ffffffffc12b0a80: fa fa fa fa 00 06 fa fa fa fa fa fa 00 02 fa fa
>                                                            ^
>   ffffffffc12b0b00: fa fa fa fa 00 00 04 fa fa fa fa fa 00 00 03 fa
>   ffffffffc12b0b80: fa fa fa fa 00 00 02 fa fa fa fa fa 00 00 04 fa
>
> qedi_dbg_err function does not check the length of caller's name,
> blindly copy 31 characters to array 'nfunc', then print it to log,
> which trigger global-out-of-bounds bug and may leak kernel info.
> Also other qedi dbg function may have the same issue, this patch
> fix this.
>
> Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI driver framework.")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>

-Mukesh
> ---
>   drivers/scsi/qedi/qedi_dbg.c | 12 ++++--------
>   1 file changed, 4 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/scsi/qedi/qedi_dbg.c b/drivers/scsi/qedi/qedi_dbg.c
> index 8fd28b0..cce44b9 100644
> --- a/drivers/scsi/qedi/qedi_dbg.c
> +++ b/drivers/scsi/qedi/qedi_dbg.c
> @@ -18,8 +18,7 @@ qedi_dbg_err(struct qedi_dbg_ctx *qedi, const char *func, u32 line,
>   	struct va_format vaf;
>   	char nfunc[32];
>   
> -	memset(nfunc, 0, sizeof(nfunc));
> -	memcpy(nfunc, func, sizeof(nfunc) - 1);
> +	snprintf(nfunc, sizeof(nfunc), "%s", func);
>   
>   	va_start(va, fmt);
>   
> @@ -43,8 +42,7 @@ qedi_dbg_warn(struct qedi_dbg_ctx *qedi, const char *func, u32 line,
>   	struct va_format vaf;
>   	char nfunc[32];
>   
> -	memset(nfunc, 0, sizeof(nfunc));
> -	memcpy(nfunc, func, sizeof(nfunc) - 1);
> +	snprintf(nfunc, sizeof(nfunc), "%s", func);
>   
>   	va_start(va, fmt);
>   
> @@ -72,8 +70,7 @@ qedi_dbg_notice(struct qedi_dbg_ctx *qedi, const char *func, u32 line,
>   	struct va_format vaf;
>   	char nfunc[32];
>   
> -	memset(nfunc, 0, sizeof(nfunc));
> -	memcpy(nfunc, func, sizeof(nfunc) - 1);
> +	snprintf(nfunc, sizeof(nfunc), "%s", func);
>   
>   	va_start(va, fmt);
>   
> @@ -102,8 +99,7 @@ qedi_dbg_info(struct qedi_dbg_ctx *qedi, const char *func, u32 line,
>   	struct va_format vaf;
>   	char nfunc[32];
>   
> -	memset(nfunc, 0, sizeof(nfunc));
> -	memcpy(nfunc, func, sizeof(nfunc) - 1);
> +	snprintf(nfunc, sizeof(nfunc), "%s", func);
>   
>   	va_start(va, fmt);
>   
