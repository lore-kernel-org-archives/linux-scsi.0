From: adam radford <aradford@gmail.com>
Subject: Re: [PATCH 4/6] scsi: megaraid: remove a useless call to memset().
Date: Mon, 3 Dec 2012 14:27:07 -0800
Message-ID: <CAHtARFE0y=ug1icuPdUcA0BVqnn6VfknAaVs=V16J-hcbZemGQ@mail.gmail.com>
References: <1354416022-20189-1-git-send-email-tipecaml@gmail.com>
	<1354416022-20189-5-git-send-email-tipecaml@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1354416022-20189-5-git-send-email-tipecaml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Cyril Roelandt <tipecaml@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, megaraidlinux@lsi.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Dec 1, 2012 at 6:40 PM, Cyril Roelandt <tipecaml@gmail.com> wrote:
> This call is followed by a call to memcpy() on the same memory area, so it can
> be safely removed.
>
> Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c |    2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index 74030af..71cc3eb 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -1028,8 +1028,6 @@ map_cmd_status(struct megasas_cmd_fusion *cmd, u8 status, u8 ext_status)
>
>                 cmd->scmd->result = (DID_OK << 16) | ext_status;
>                 if (ext_status == SAM_STAT_CHECK_CONDITION) {
> -                       memset(cmd->scmd->sense_buffer, 0,
> -                              SCSI_SENSE_BUFFERSIZE);
>                         memcpy(cmd->scmd->sense_buffer, cmd->sense,
>                                SCSI_SENSE_BUFFERSIZE);
>                         cmd->scmd->result |= DRIVER_SENSE << 24;
> --

Acked-by: Adam Radford <aradford@gmail.com>
