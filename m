From: Marc Gonzalez <marc.w.gonzalez@free.fr>
Subject: Re: [PATCH v1] scsi: ufs: Use explicit access size in ufshcd_dump_regs
Date: Wed, 9 Jan 2019 13:42:29 +0100
Message-ID: <214700f8-a381-5740-47c0-54923dae60b1@free.fr>
References: <3bf7ea8e-4cf2-1f9b-7f46-15609dfcad19@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <3bf7ea8e-4cf2-1f9b-7f46-15609dfcad19@free.fr>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Bjorn Andersson <bjorn.andersson@linaro.org>, Andy Gross <andy.gross@linaro.org>, Jeffrey Hugo <jhugo@codeaurora.org>
Cc: SCSI <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Joao Pinto <jpinto@synopsys.com>, MSM <linux-arm-msm@vger.kernel.org>, Avri Altman <avri.altman@wdc.com>, Tomas Winkler <tomas.winkler@intel.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Robin Murphy <robin.murphy@arm.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

Bjorn, Andy, Jeffrey,

What do you think about the patch below?

Regards.

On 11/12/2018 15:18, Marc Gonzalez wrote:

> memcpy_fromio() doesn't provide any control over access size.
> For example, on arm64, it is implemented using readb and readq.
> This may trigger a synchronous external abort:
> 
> [    3.729943] Internal error: synchronous external abort: 96000210 [#1] PREEMPT SMP
> [    3.737000] Modules linked in:
> [    3.744371] CPU: 2 PID: 1 Comm: swapper/0 Tainted: G S                4.20.0-rc4 #16
> [    3.747413] Hardware name: Qualcomm Technologies, Inc. MSM8998 v1 MTP (DT)
> [    3.755295] pstate: 00000005 (nzcv daif -PAN -UAO)
> [    3.761978] pc : __memcpy_fromio+0x68/0x80
> [    3.766718] lr : ufshcd_dump_regs+0x50/0xb0
> [    3.770767] sp : ffff00000807ba00
> [    3.774830] x29: ffff00000807ba00 x28: 00000000fffffffb
> [    3.778344] x27: ffff0000089db068 x26: ffff8000f6e58000
> [    3.783728] x25: 000000000000000e x24: 0000000000000800
> [    3.789023] x23: ffff8000f6e587c8 x22: 0000000000000800
> [    3.794319] x21: ffff000008908368 x20: ffff8000f6e1ab80
> [    3.799615] x19: 000000000000006c x18: ffffffffffffffff
> [    3.804910] x17: 0000000000000000 x16: 0000000000000000
> [    3.810206] x15: ffff000009199648 x14: ffff000089244187
> [    3.815502] x13: ffff000009244195 x12: ffff0000091ab000
> [    3.820797] x11: 0000000005f5e0ff x10: ffff0000091998a0
> [    3.826093] x9 : 0000000000000000 x8 : ffff8000f6e1ac00
> [    3.831389] x7 : 0000000000000000 x6 : 0000000000000068
> [    3.836676] x5 : ffff8000f6e1abe8 x4 : 0000000000000000
> [    3.841971] x3 : ffff00000928c868 x2 : ffff8000f6e1abec
> [    3.847267] x1 : ffff00000928c868 x0 : ffff8000f6e1abe8
> [    3.852567] Process swapper/0 (pid: 1, stack limit = 0x(____ptrval____))
> [    3.857900] Call trace:
> [    3.864473]  __memcpy_fromio+0x68/0x80
> [    3.866683]  ufs_qcom_dump_dbg_regs+0x1c0/0x370
> [    3.870522]  ufshcd_print_host_regs+0x168/0x190
> [    3.874946]  ufshcd_init+0xd4c/0xde0
> [    3.879459]  ufshcd_pltfrm_init+0x3c8/0x550
> [    3.883264]  ufs_qcom_probe+0x24/0x60
> [    3.887188]  platform_drv_probe+0x50/0xa0
> 
> Assuming aligned 32-bit registers, let's use readl, after making sure
> that 'offset' and 'len' are indeed multiples of 4.
> 
> Fixes: ba80917d9932d ("scsi: ufs: ufshcd_dump_regs to use memcpy_fromio")
> Signed-off-by: Marc Gonzalez <marc.w.gonzalez@free.fr>
> ---
>  drivers/scsi/ufs/ufshcd.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 535180c01ce8..320bbd9849bc 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -112,13 +112,19 @@
>  int ufshcd_dump_regs(struct ufs_hba *hba, size_t offset, size_t len,
>  		     const char *prefix)
>  {
> -	u8 *regs;
> +	u32 *regs;
> +	size_t pos;
> +
> +	if (offset % 4 != 0 || len % 4 != 0) /* keep readl happy */
> +		return -EINVAL;
>  
>  	regs = kzalloc(len, GFP_KERNEL);
>  	if (!regs)
>  		return -ENOMEM;
>  
> -	memcpy_fromio(regs, hba->mmio_base + offset, len);
> +	for (pos = 0; pos < len; pos += 4)
> +		regs[pos / 4] = ufshcd_readl(hba, offset + pos);
> +
>  	ufshcd_hex_dump(prefix, regs, len);
>  	kfree(regs);
>  
