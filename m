From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH v3 2/5] [SCSI] ufshcd: UFS UTP Transfer requests handling
Date: Tue, 27 Mar 2012 11:22:45 +0530
Message-ID: <CALMYJDvvY_7FpiVGuguK8i1C_n9ogJhrgsH+KerDc62Omn35aA@mail.gmail.com>
References: <1330497714-26504-3-git-send-email-santoshsy@gmail.com> <4F6FF1E3.7080908@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <4F6FF1E3.7080908@toshiba.co.jp>
Sender: linux-samsung-soc-owner@vger.kernel.org
To: KOBAYASHI Yoshitake <yoshitake.kobayashi@toshiba.co.jp>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org, arnd.bergmann@linaro.org, saugata.das@linaro.org, dsaxena@linaro.org, stephen.doel@linaro.org, venkat@linaro.org, ilho215.lee@samsung.com, nala.la@samsung.com, girish.shivananjappa@linaro.org, vishak.g@samsung.com, k.rajesh@samsung.com, yejin.moon@samsung.com, sreekumar.c@samsung.com, vinholikatti@gmail.com, linkinjeon@gmail.com, michaelc@cs.wisc.edu
List-Id: linux-scsi@vger.kernel.org

On Mon, Mar 26, 2012 at 10:04 AM, KOBAYASHI Yoshitake
<yoshitake.kobayashi@toshiba.co.jp> wrote:
> Santosh Y wrote:
>>
>> + =A0 =A0 =A0 =A0ucd_cmd_ptr->exp_data_transfer_len =3D
>> + =A0 =A0 =A0 =A0 =A0 =A0cpu_to_be32(lrbp->cmd->transfersize);
>> +
>> + =A0 =A0 =A0 =A0memcpy(ucd_cmd_ptr->cdb,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 lrbp->cmd->cmnd,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 (min_t(unsigned short,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0lrbp->cmd->cmd_len,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0MAX_CDB_SIZE)));
>
>
> "Exptected Data Transfer Length" field contains a value that
> represents the number of bytes that are required to complete the
> SCSI command request and the number of bytes that the Initiator
> expects to be transferred to/from the Target.
> (JEDEC Standard 220 Table7-7)
> On the other hand, "transfersize" in a scsi_cmnd struct is trimmed
> to the sector size when requested transfer length exceeds it.
> You may derive the actual transfer length from SCSI command itself li=
ke
> following.
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index feffe65..e63fecb 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -647,6 +647,34 @@ static void ufshcd_compose_upiu(struct ufshcd_lr=
b
> *lrbp)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (min_t(unsigned short,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0lrbp->cmd-=
>cmd_len,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0MAX_CDB_SI=
ZE)));
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Overwrite exptected transfer length =
by using
> TRANSFER_LENGTH in SCSI commands */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 switch(ucd_cmd_ptr->cdb[0]) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case READ_6:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case WRITE_6:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ucd_cmd_ptr->exp_data_t=
ransfer_len =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_=
be32(lrbp->cmd->transfersize *
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 ucd_cmd_ptr->cdb[4]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case READ_10:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case WRITE_10:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ucd_cmd_ptr->exp_data_t=
ransfer_len =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_=
be32(lrbp->cmd->transfersize *
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 ((ucd_cmd_ptr->cdb[7] << 8) |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0ucd_cmd_ptr->cdb[8]));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case READ_12:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case WRITE_12:

Just a minor change, this will be READ_16 and WRITE_16.

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ucd_cmd_ptr->exp_data_t=
ransfer_len =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_=
be32(lrbp->cmd->transfersize *
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 ((ucd_cmd_ptr->cdb[10] << 24) |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0(ucd_cmd_ptr->cdb[11] << 16) |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0(ucd_cmd_ptr->cdb[12] << 8) |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0ucd_cmd_ptr->cdb[13]));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0case UTP_CMD_TYPE_DEV_MANAGE:
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* For query function implementation *=
/
>

--=20
~Santosh
