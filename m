From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH v3 1/5] [SCSI] ufshcd: UFS Host controller driver
Date: Tue, 27 Mar 2012 09:31:37 +0530
Message-ID: <CALMYJDu5+=wQSkR9SGMFqOSRARPeSK0XzmG8sfjuj2qUn9jOLA@mail.gmail.com>
References: <1330497714-26504-2-git-send-email-santoshsy@gmail.com> <4F6FF179.5090600@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F6FF179.5090600@toshiba.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: KOBAYASHI Yoshitake <yoshitake.kobayashi@toshiba.co.jp>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org, arnd.bergmann@linaro.org, saugata.das@linaro.org, dsaxena@linaro.org, stephen.doel@linaro.org, venkat@linaro.org, ilho215.lee@samsung.com, nala.la@samsung.com, girish.shivananjappa@linaro.org, vishak.g@samsung.com, k.rajesh@samsung.com, yejin.moon@samsung.com, sreekumar.c@samsung.com, vinholikatti@gmail.com, linkinjeon@gmail.com, michaelc@cs.wisc.edu
List-Id: linux-scsi@vger.kernel.org

On Mon, Mar 26, 2012 at 10:02 AM, KOBAYASHI Yoshitake
<yoshitake.kobayashi@toshiba.co.jp> wrote:
>> > + =A0 =A0 =A0 =A0utrdlp[i].response_upiu_length =3D
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cpu_to_le16(ALIGNED_UPIU_SIZE);
>
>
> Response UPIU Length(RUL) shows the response UPIU length in Dword.
> (JEDEC Standard No.223 6.2.1 UTP Transfer Request Descriptor)
> The following will be correct.
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 07ec973..feffe65 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -836,7 +836,7 @@ static void ufshcd_host_memory_configure(struct u=
fs_hba
> *hba)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0utrdlp[i].prd_table_offset =3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cpu_to=
_le16((prdt_offset >> 2));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0utrdlp[i].response_upiu_length =3D
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_=
le16(ALIGNED_UPIU_SIZE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_=
le16(ALIGNED_UPIU_SIZE >> 2);
>
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0hba->lrb[i].utr_descriptor_ptr =3D (ut=
rdlp + i);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0hba->lrb[i].ucd_cmd_ptr =3D
>

Thanks, i'll update it.

--=20
~Santosh
