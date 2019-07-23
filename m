From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: Re: [PATCH RESEND] scsi: megaraid_sas: fix panic on loading firmware crashdump
Date: Tue, 23 Jul 2019 23:46:25 +0530
Message-ID: <CAL2rwxoGqznXyi_bdV-ODoHE2Mhv6gT=PH=3jXkQXPnUJrEUNw@mail.gmail.com>
References: <20190722161524.23192-1-junxiao.bi@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190722161524.23192-1-junxiao.bi@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Junxiao Bi <junxiao.bi@oracle.com>
Cc: "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kashyap Desai <kashyap.desai@broadcom.com>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 22, 2019 at 9:45 PM Junxiao Bi <junxiao.bi@oracle.com> wrote:
>
> While loading fw crashdump in function fw_crash_buffer_show(),
> left bytes in one dma chunk was not checked, if copying size
> over it, overflow access will cause kernel panic.
>
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 80ab9700f1de..3eef0858fa8e 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -3153,6 +3153,7 @@ fw_crash_buffer_show(struct device *cdev,
>                 (struct megasas_instance *) shost->hostdata;
>         u32 size;
>         unsigned long dmachunk = CRASH_DMA_BUF_SIZE;
> +       unsigned long chunk_left_bytes;
>         unsigned long src_addr;
>         unsigned long flags;
>         u32 buff_offset;
> @@ -3176,6 +3177,8 @@ fw_crash_buffer_show(struct device *cdev,
>         }
>
>         size = (instance->fw_crash_buffer_size * dmachunk) - buff_offset;
> +       chunk_left_bytes = dmachunk - (buff_offset % dmachunk);
> +       size = (size > chunk_left_bytes) ? chunk_left_bytes : size;
>         size = (size >= PAGE_SIZE) ? (PAGE_SIZE - 1) : size;
>
>         src_addr = (unsigned long)instance->crash_buf[buff_offset / dmachunk] +
> --
> 2.17.1
>
