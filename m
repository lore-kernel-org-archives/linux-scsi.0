From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH v2 4/5] [SCSI] ufshcd: SCSI error handling
Date: Mon, 27 Feb 2012 11:52:09 +0530
Message-ID: <CALMYJDtxKw_doL=nwJiyE4sGFXcwrdAUCR4KbmAmwPvgK+78pw@mail.gmail.com>
References: <1330067945-9128-1-git-send-email-santoshsy@gmail.com>
 <1330067945-9128-5-git-send-email-santoshsy@gmail.com> <CAJd=RBAVfG1J66VVrCNAiaoMEJ3O7MZOU21g-T_CkyF10WJa8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJd=RBAVfG1J66VVrCNAiaoMEJ3O7MZOU21g-T_CkyF10WJa8w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hillf Danton <dhillf@gmail.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, arnd@linaro.org, girish.shivananjappa@linaro.org, saugata.das@linaro.org, vishak.g@samsung.com, venkat@linaro.org, k.rajesh@samsung.com, yeji@jasper.es
List-Id: linux-scsi@vger.kernel.org

On Sun, Feb 26, 2012 at 10:16 AM, Hillf Danton <dhillf@gmail.com> wrote=
:
> On Fri, Feb 24, 2012 at 3:19 PM, Santosh Y <santoshsy@gmail.com> wrot=
e:
>> +/**
>> + * ufshcd_is_tmq_full - checks if the task management slots are ful=
l
>> + * @hba: per adapter instance
>> + *
>> + * Returns maximum number of task management request slots in case =
of
>> + * task management queue full or returns the free slot number
>> + */
>> +static inline int ufshcd_is_tmq_full(struct ufs_hba *hba)
>
> This helper function is named to be misleading, little to do with
> its functionality as full is checked at callsite.

ok, thanks, I'll change it.

>
> -hd
>
>> +{
>> + =A0 =A0 =A0 return find_first_zero_bit(&hba->outstanding_tasks, hb=
a->nutmrs);
>> +}
>> +
> [...]
>> + =A0 =A0 =A0 host =3D hba->host;
>> +
>> + =A0 =A0 =A0 spin_lock_irqsave(host->host_lock, flags);
>> +
>> + =A0 =A0 =A0 /* If task management queue is full */
>> + =A0 =A0 =A0 free_slot =3D ufshcd_is_tmq_full(hba);
>> + =A0 =A0 =A0 if (free_slot >=3D hba->nutmrs) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irqrestore(host->host_lock=
, flags);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->pdev->dev, "Task managem=
ent queue full\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D FAILED;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 =A0 }

--=20
~Santosh
