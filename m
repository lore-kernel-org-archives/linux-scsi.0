From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH 4/4] [SCSI] ufshcd: SCSI error handling
Date: Sun, 5 Feb 2012 14:47:46 +0530
Message-ID: <CALMYJDtpdFcVs_b-ePBnVHi-xkPc0NUST1_9WhpHsjoLaVnpUQ@mail.gmail.com>
References: <1328158649-4137-1-git-send-email-vinholikatti@gmail.com>
 <1328158649-4137-5-git-send-email-vinholikatti@gmail.com> <CAKYAXd9k5i2_SuD8YSJeG25CBpK0b4jQGJstc-Ef1jD20cph1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <CAKYAXd9k5i2_SuD8YSJeG25CBpK0b4jQGJstc-Ef1jD20cph1Q@mail.gmail.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, saugata.das@linaro.org, arnd@arndb.de, venkat@linaro.org, girish.shivananjappa@linaro.org, vishak.g@samsung.com, k.rajesh@samsung.com, yejin.moon@samsung.com
List-Id: linux-scsi@vger.kernel.org

On Sun, Feb 5, 2012 at 1:07 PM, Namjae Jeon <linkinjeon@gmail.com> wrot=
e:
>> +
>> +/**
>> + * ufshcd_abort - abort a specific command
>> + * @cmd: SCSI command pointer
>> + *
>> + * Returns 0 on success, non-zero value on failure
>> + */
>> +static int ufshcd_abort(struct scsi_cmnd *cmd)
>> +{
>> + =A0 =A0 =A0 struct Scsi_Host *host;
>> + =A0 =A0 =A0 struct ufs_hba *hba;
>> + =A0 =A0 =A0 unsigned long flags;
>> + =A0 =A0 =A0 unsigned int tag;
>> + =A0 =A0 =A0 unsigned int pos;
>> + =A0 =A0 =A0 int err;
>> +
>> + =A0 =A0 =A0 host =3D cmd->device->host;
>> + =A0 =A0 =A0 hba =3D (struct ufs_hba *) host->hostdata;
>> + =A0 =A0 =A0 tag =3D cmd->request->tag;
>> +
>> + =A0 =A0 =A0 spin_lock_irqsave(host->host_lock, flags);
>> + =A0 =A0 =A0 pos =3D (1 << tag);
>> +
>> + =A0 =A0 =A0 /* check if command is still pending */
>> + =A0 =A0 =A0 if (!(hba->outstanding_reqs & pos)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D -1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irqrestore(host->host_lock=
, flags);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 err =3D ufshcd_issue_tm_cmd(hba, &hba->lrb[tag], UFS_A=
BORT_TASK);
> Hi.
> You called spin_lock_irqsave in ufshcd_issue_tm_cmd() without
> spin_unlock_irqrestore.

Thanks for reviewing the code. We'll correct it.
Please let us know your comments on the other patches too.

>
>> + =A0 =A0 =A0 if (!err) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock_irqsave(host->host_lock, fla=
gs);
> This case is same also.
> Thanks.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 scsi_dma_unmap(cmd);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* clear the respective UTRLCLR bit */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 writel(~pos,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (UFSHCD_MMIO_BASE +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0REG_UTP_TRANSFER_RE=
Q_LIST_CLEAR));
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hba->outstanding_reqs &=3D ~pos;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hba->lrb[tag].cmd =3D NULL;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irqrestore(host->host_lock=
, flags);
>> + =A0 =A0 =A0 }
>> +out:
>> + =A0 =A0 =A0 return err;
>> +}
>> +

--=20
~Santosh
