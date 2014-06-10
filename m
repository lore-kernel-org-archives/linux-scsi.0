From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Tue, 10 Jun 2014 23:19:29 +0300
Message-ID: <CAJZOPZ+sc2uvCqQQpo+KO8q9+u6X5je+-AnCiijX6K9q2w2yrQ@mail.gmail.com>
References: <1402223228-23768-1-git-send-email-sagig@mellanox.com>
	<1402223228-23768-2-git-send-email-sagig@mellanox.com>
	<yq1fvjcvb8f.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <yq1fvjcvb8f.fsf-+q57XtR/GgMb6DWv4sQWN6xOck334EZe@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 10, 2014 at 10:02 PM, Martin K. Petersen
<martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>>>>>> "Sagi" == Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> writes:
>
> +static inline unsigned scsi_prot_length(unsigned data_length,
> +                                       unsigned sector_size)
> +{
> +       switch (sector_size) {
> +       case 512:
> +               return (data_length >> 9) * 8;
> +       case 1024:
> +               return (data_length >> 10) * 8;
> +       case 2048:
> +               return (data_length >> 11) * 8;
> +       case 4096:
> +               return (data_length >> 12) * 8;
> +       default:
> +               return (data_length >> ilog2(sector_size)) * 8;
> +       }
> +}
> +
> +static inline unsigned scsi_transfer_length(struct scsi_cmnd *cmd)
> +{
> +       unsigned data_length;
> +
> +       if (cmd->sc_data_direction == DMA_FROM_DEVICE) {
> +               data_length = scsi_in(cmd)->length;
> +               if (scsi_get_prot_op(cmd) ==  SCSI_PROT_NORMAL ||
> +                   scsi_get_prot_op(cmd) ==  SCSI_PROT_READ_INSERT)
> +                       return data_length;
> +       } else {
> +               data_length = scsi_out(cmd)->length;
> +               if (scsi_get_prot_op(cmd) ==  SCSI_PROT_NORMAL ||
> +                   scsi_get_prot_op(cmd) ==  SCSI_PROT_WRITE_STRIP)
> +                       return data_length;
> +       }
> +
> +       /* Protection information exists on the wire */
> +       return data_length + scsi_prot_length(data_length,
> +                                             cmd->device->sector_size);
> +}
>
> Let's do this for 3.16:

Just to make sure, by 3.16 you also mean 3.15.y, right?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
