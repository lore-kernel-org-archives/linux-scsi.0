From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: Re: [PATCH] scsi: megaraid_sas: Use struct_size() helper
Date: Thu, 13 Jun 2019 15:27:33 +0530
Message-ID: <CAL2rwxpUyVE5T2QBT7ze5QoeH3KgkXCWPwjgQKuAUrd4VxHEOg@mail.gmail.com>
References: <20190607184053.GA11513@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190607184053.GA11513@embeddedor>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Jun 8, 2019 at 12:10 AM Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
>
> One of the more common cases of allocation size calculations is finding
> the size of a structure that has a zero-sized array at the end, along
> with memory for some number of elements for that array. For example:
>
> struct MR_PD_CFG_SEQ_NUM_SYNC {
>         ...
>         struct MR_PD_CFG_SEQ seq[1];
> } __packed;
>
> Make use of the struct_size() helper instead of an open-coded version
> in order to avoid any potential type mistakes.
>
> So, replace the following form:
>
> sizeof(struct MR_PD_CFG_SEQ_NUM_SYNC) + (sizeof(struct MR_PD_CFG_SEQ) * (MAX_PHYSICAL_DEVICES - 1))
>
> with:
>
> struct_size(pd_sync, seq, MAX_PHYSICAL_DEVICES - 1)
>
> This code was detected with the help of Coccinelle.
>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>

> ---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index a25b6b4b6548..56bd524dddbf 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -1191,7 +1191,7 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
>  int
>  megasas_sync_pd_seq_num(struct megasas_instance *instance, bool pend) {
>         int ret = 0;
> -       u32 pd_seq_map_sz;
> +       size_t pd_seq_map_sz;
>         struct megasas_cmd *cmd;
>         struct megasas_dcmd_frame *dcmd;
>         struct fusion_context *fusion = instance->ctrl_context;
> @@ -1200,9 +1200,7 @@ megasas_sync_pd_seq_num(struct megasas_instance *instance, bool pend) {
>
>         pd_sync = (void *)fusion->pd_seq_sync[(instance->pd_seq_map_id & 1)];
>         pd_seq_h = fusion->pd_seq_phys[(instance->pd_seq_map_id & 1)];
> -       pd_seq_map_sz = sizeof(struct MR_PD_CFG_SEQ_NUM_SYNC) +
> -                       (sizeof(struct MR_PD_CFG_SEQ) *
> -                       (MAX_PHYSICAL_DEVICES - 1));
> +       pd_seq_map_sz = struct_size(pd_sync, seq, MAX_PHYSICAL_DEVICES - 1);
>
>         cmd = megasas_get_cmd(instance);
>         if (!cmd) {
> --
> 2.21.0
>
