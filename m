From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH 4/4] [SCSI] ufshcd: SCSI error handling
Date: Sun, 5 Feb 2012 16:37:05 +0900
Message-ID: <CAKYAXd9k5i2_SuD8YSJeG25CBpK0b4jQGJstc-Ef1jD20cph1Q@mail.gmail.com>
References: <1328158649-4137-1-git-send-email-vinholikatti@gmail.com>
	<1328158649-4137-5-git-send-email-vinholikatti@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54317 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab2BEHhH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Feb 2012 02:37:07 -0500
In-Reply-To: <1328158649-4137-5-git-send-email-vinholikatti@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, saugata.das@linaro.org, arnd@arndb.de, venkat@linaro.org, girish.shivananjappa@linaro.org, vishak.g@samsung.com, k.rajesh@samsung.com, yejin.moon@samsung.com, Santosh Yaraganavi <santoshsy@gmail.com>

> +
> +/**
> + * ufshcd_abort - abort a specific command
> + * @cmd: SCSI command pointer
> + *
> + * Returns 0 on success, non-zero value on failure
> + */
> +static int ufshcd_abort(struct scsi_cmnd *cmd)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct Scsi_Host *host;
> + =C2=A0 =C2=A0 =C2=A0 struct ufs_hba *hba;
> + =C2=A0 =C2=A0 =C2=A0 unsigned long flags;
> + =C2=A0 =C2=A0 =C2=A0 unsigned int tag;
> + =C2=A0 =C2=A0 =C2=A0 unsigned int pos;
> + =C2=A0 =C2=A0 =C2=A0 int err;
> +
> + =C2=A0 =C2=A0 =C2=A0 host =3D cmd->device->host;
> + =C2=A0 =C2=A0 =C2=A0 hba =3D (struct ufs_hba *) host->hostdata;
> + =C2=A0 =C2=A0 =C2=A0 tag =3D cmd->request->tag;
> +
> + =C2=A0 =C2=A0 =C2=A0 spin_lock_irqsave(host->host_lock, flags);
> + =C2=A0 =C2=A0 =C2=A0 pos =3D (1 << tag);
> +
> + =C2=A0 =C2=A0 =C2=A0 /* check if command is still pending */
> + =C2=A0 =C2=A0 =C2=A0 if (!(hba->outstanding_reqs & pos)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D -1;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqres=
tore(host->host_lock, flags);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 err =3D ufshcd_issue_tm_cmd(hba, &hba->lrb[tag=
], UFS_ABORT_TASK);
Hi.
You called spin_lock_irqsave in ufshcd_issue_tm_cmd() without
spin_unlock_irqrestore.

> + =C2=A0 =C2=A0 =C2=A0 if (!err) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock_irqsave(=
host->host_lock, flags);
This case is same also.
Thanks.
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 scsi_dma_unmap(cmd=
);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* clear the respe=
ctive UTRLCLR bit */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 writel(~pos,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 (UFSHCD_MMIO_BASE +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0REG_UTP_TRANSFER_REQ_LIST_CLEAR));
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 hba->outstanding_r=
eqs &=3D ~pos;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 hba->lrb[tag].cmd =
=3D NULL;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqres=
tore(host->host_lock, flags);
> + =C2=A0 =C2=A0 =C2=A0 }
> +out:
> + =C2=A0 =C2=A0 =C2=A0 return err;
> +}
> +
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
