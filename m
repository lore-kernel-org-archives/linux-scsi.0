From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v2 4/5] [SCSI] ufshcd: SCSI error handling
Date: Sun, 26 Feb 2012 12:46:39 +0800
Message-ID: <CAJd=RBAVfG1J66VVrCNAiaoMEJ3O7MZOU21g-T_CkyF10WJa8w@mail.gmail.com>
References: <1330067945-9128-1-git-send-email-santoshsy@gmail.com>
	<1330067945-9128-5-git-send-email-santoshsy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1330067945-9128-5-git-send-email-santoshsy@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Santosh Y <santoshsy@gmail.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, arnd@linaro.org, girish.shivananjappa@linaro.org, saugata.das@linaro.org, vishak.g@samsung.com, venkat@linaro.org, k.rajesh@samsung.com, yeji@jasper.es
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 24, 2012 at 3:19 PM, Santosh Y <santoshsy@gmail.com> wrote:
> +/**
> + * ufshcd_is_tmq_full - checks if the task management slots are full
> + * @hba: per adapter instance
> + *
> + * Returns maximum number of task management request slots in case o=
f
> + * task management queue full or returns the free slot number
> + */
> +static inline int ufshcd_is_tmq_full(struct ufs_hba *hba)

This helper function is named to be misleading, little to do with
its functionality as full is checked at callsite.

-hd

> +{
> + =C2=A0 =C2=A0 =C2=A0 return find_first_zero_bit(&hba->outstanding_t=
asks, hba->nutmrs);
> +}
> +
[...]
> + =C2=A0 =C2=A0 =C2=A0 host =3D hba->host;
> +
> + =C2=A0 =C2=A0 =C2=A0 spin_lock_irqsave(host->host_lock, flags);
> +
> + =C2=A0 =C2=A0 =C2=A0 /* If task management queue is full */
> + =C2=A0 =C2=A0 =C2=A0 free_slot =3D ufshcd_is_tmq_full(hba);
> + =C2=A0 =C2=A0 =C2=A0 if (free_slot >=3D hba->nutmrs) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqres=
tore(host->host_lock, flags);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dev_err(&hba->pdev=
->dev, "Task management queue full\n");
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D FAILED;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> + =C2=A0 =C2=A0 =C2=A0 }
