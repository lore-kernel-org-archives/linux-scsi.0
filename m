From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH] BNX2I: Fixed NULL ptr deference for 1G bnx2 Linux iSCSI
 offload
Date: Tue, 21 Aug 2012 12:41:09 -0500
Message-ID: <5033C835.3040105@cs.wisc.edu>
References: <Eddie Wai <eddie.wai@broadcom.com> <1345570553-23067-1-git-send-email-eddie.wai@broadcom.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <open-iscsi+bncCLPJla3WGRC_kM-BBRoEU9mwmQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1345570553-23067-1-git-send-email-eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, open-iscsi <open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Chan <mchan-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Anil Veerabhadrappa <anilgv-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Ben Li <benli-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 08/21/2012 12:35 PM, Eddie Wai wrote:
> This patch fixes the following kernel panic invoked by uninitialized fields
> in the chip initialization for the 1G bnx2 iSCSI offload.
> 
> One of the bits in the chip initialization is being used by the latest
> firmware to control overflow packets.  When this control bit gets enabled
> erroneously, it would ultimately result in a bad packet placement which would
> cause the bnx2 driver to dereference a NULL ptr in the placement handler.
> 
> This can happen under certain stress I/O environment under the Linux
> iSCSI offload operation.
> 
> This change only affects Broadcom's 5709 chipset.
> 
> Unable to handle kernel NULL pointer dereference at 0000000000000008 RIP:
>  [<ffffffff881f0e7d>] :bnx2:bnx2_poll_work+0xd0d/0x13c5
> Pid: 0, comm: swapper Tainted: G     ---- 2.6.18-333.el5debug #2
> RIP: 0010:[<ffffffff881f0e7d>]  [<ffffffff881f0e7d>] :bnx2:bnx2_poll_work+0xd0d/0x13c5
> RSP: 0018:ffff8101b575bd50  EFLAGS: 00010216
> RAX: 0000000000000005 RBX: ffff81007c5fb180 RCX: 0000000000000000
> RDX: 0000000000000ffc RSI: 00000000817e8000 RDI: 0000000000000220
> RBP: ffff81015bbd7ec0 R08: ffff8100817e9000 R09: 0000000000000000
> R10: ffff81007c5fb180 R11: 00000000000000c8 R12: 000000007a25a010
> R13: 0000000000000000 R14: 0000000000000005 R15: ffff810159f80558
> FS:  0000000000000000(0000) GS:ffff8101afebc240(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000000008 CR3: 0000000000201000 CR4: 00000000000006a0
> Process swapper (pid: 0, threadinfo ffff8101b5754000, task ffff8101afebd820)
> Stack:  000000000000000b ffff810159f80000 0000000000000040 ffff810159f80520
>  ffff810159f80500 00cf00cf8008e84b ffffc200100939e0 ffff810009035b20
>  0000502900000000 000000be00000001 ffff8100817e7810 00d08101b575bea8
> Call Trace:
>  <IRQ>  [<ffffffff8008e0d0>] show_schedstat+0x1c2/0x25b
>  [<ffffffff881f1886>] :bnx2:bnx2_poll+0xf6/0x231
>  [<ffffffff8000c9b9>] net_rx_action+0xac/0x1b1
>  [<ffffffff800125a0>] __do_softirq+0x89/0x133
>  [<ffffffff8005e30c>] call_softirq+0x1c/0x28
>  [<ffffffff8006d5de>] do_softirq+0x2c/0x7d
>  [<ffffffff8006d46e>] do_IRQ+0xee/0xf7
>  [<ffffffff8005d625>] ret_from_intr+0x0/0xa
>  <EOI>  [<ffffffff801a5780>] acpi_processor_idle_simple+0x1c5/0x341
>  [<ffffffff801a573d>] acpi_processor_idle_simple+0x182/0x341
>  [<ffffffff801a55bb>] acpi_processor_idle_simple+0x0/0x341
>  [<ffffffff80049560>] cpu_idle+0x95/0xb8
>  [<ffffffff80078b1c>] start_secondary+0x479/0x488
> 
> Signed-off-by: Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> ---
>  drivers/scsi/bnx2i/bnx2i_hwi.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
> index 86a12b4..3878e62 100644
> --- a/drivers/scsi/bnx2i/bnx2i_hwi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
> @@ -1264,6 +1264,9 @@ int bnx2i_send_fw_iscsi_init_msg(struct bnx2i_hba *hba)
>  	int rc = 0;
>  	u64 mask64;
>  
> +	memset(&iscsi_init, 0x00, sizeof(struct iscsi_kwqe_init1));
> +	memset(&iscsi_init2, 0x00, sizeof(struct iscsi_kwqe_init2));
> +
>  	bnx2i_adjust_qp_size(hba);
>  
>  	iscsi_init.flags =
> 

Seems ok to me.

Reviewed-by: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.
