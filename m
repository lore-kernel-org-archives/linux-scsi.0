Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C55558BA
	for <linux-scsi@vger.kernel.org>; Sun,  1 Sep 2024 19:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725218760; cv=none; b=r4fvxKeUKu6uxr4zfSPXWSG3ysa9QNoNLPOlNW1OFr534dAvIV1rOtfnhE/QCgNFiqkHKGyWOqxiHdMNGu/L0t3jATS4UElZaJj//vU5h/4gX6wBg6t5rryMKb0Ww3/HDGUl8uASJLmvq9OKwKvdixjK8iUwuDUzAGropd1geD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725218760; c=relaxed/simple;
	bh=ZfSos6m9KnFghAFXdFOcbbt1XwRrRBlWFyijBp9RwXk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=noI8Zj4y5AImSko2P26jQ9IRj7xVHeaRuPqwnbz349wEdAD2YPCcF5l7ytFHoI6t/GQMlOi2h5OpUYMIE30ifWgv4JqpfY3camaqLo4jLetkAZ6y/P7pelbl3QJqLu58Bv+xz9tezgH4pnRs5H5fiWAQFrxlgEt+KeDpAaXQrUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K55zRLpB; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K55zRLpB"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a86acbaddb4so409294566b.1
        for <linux-scsi@vger.kernel.org>; Sun, 01 Sep 2024 12:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725218757; x=1725823557; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2stCt+csMWSV2v89P6/XwnbpkEBxQBO3nAiKN4Nl0RE=;
        b=K55zRLpBZPaqxhP3+l/0e3/AQZ16DRUIlaJ1Olu1zUidAdN8s+kl62oTYeNUyr2QsF
         3PxqGqN8s9U93ogxMLDwrqyPe2gYLQ/W6K7GEiifC2fwoPFE0cYMk0sizWfRjfxPMwGU
         4PWr7yXXJHY5IRpm5u0XhZr4qbrYzqJjZ+obfXb0fpH/V/n4vV984IfXg/RLQdPr1MwB
         N5m1gVaT9RSLn4ZhVqdpJEA6PsPaHiY2WiGGUCywqFQ5ZdDpEAF4IWXrIW9UGTzqD56j
         YVcXVwh2Wjx8gV9tW0u7cD69jfvG8C+8jACIdBL4/WLV1VSqoAUYRxRmCpIXxUop5lPu
         PTCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725218757; x=1725823557;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2stCt+csMWSV2v89P6/XwnbpkEBxQBO3nAiKN4Nl0RE=;
        b=PWwqHzmF2faLO1gf5gncxr2q1RRQ1iR3qfbCC3pNwsM5HPlRMDTvXvIYUyrlpMRIFZ
         ZM9hAPyj5DfdGcbkfVXa3JHCHk7nC3hg3Y2V8n3ywOFnXOlDPt/82a1Ahw5fwaDSW52o
         NUdltoH4ii6wfInKoejDr3l3xDfR6pESAqW9qxEiKz2UdPk6BVnlB1lPMlD695CNcVZu
         2n1IxJrkcTs6EF1lu+lVw5cM/nEGLN42SvP44O8rHRkpALdmslSkIe5CdHdT4xPv+026
         MmxeQWTzbmLXaDCu0XZbQIvxMCCF7EXwi+adc0LUfWFobkEH0Pn/l6b0YIU/lufsDHIC
         OE1w==
X-Gm-Message-State: AOJu0Ywqk2y4byyKEBfdeGk0MRC7z29IFwSN82WlPj4yqTRYRZNKc4iv
	c5zJ4ceL0F5izY1JEB+fmjXacIeZU+dBlLHPjx2Q2cbKYdw5iC5Q
X-Google-Smtp-Source: AGHT+IGbrF4tycTSJyin21xEPa3lVhEFmyojLpgoe0WCmKxS3FneZw8rPuHOoI1k5zezlm9OjgqWFg==
X-Received: by 2002:a17:907:da5:b0:a86:67e7:c740 with SMTP id a640c23a62f3a-a897f84bbf3mr904307366b.17.1725218756699;
        Sun, 01 Sep 2024 12:25:56 -0700 (PDT)
Received: from p200300c587387573a65f3c64b00236b3.dip0.t-ipconnect.de (p200300c587387573a65f3c64b00236b3.dip0.t-ipconnect.de. [2003:c5:8738:7573:a65f:3c64:b002:36b3])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a898908eaa1sm468101866b.94.2024.09.01.12.25.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Sep 2024 12:25:56 -0700 (PDT)
Message-ID: <70c5f2620d57091be28c735765df4f7fed02ae04.camel@gmail.com>
Subject: Re: [PATCH v3 9/9] ufs: core: Remove the second argument of
 ufshcd_device_init()
From: Bean Huo <huobean@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	 <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, Manivannan Sadhasivam
 <manivannan.sadhasivam@linaro.org>, Peter Wang <peter.wang@mediatek.com>, 
 Avri Altman <avri.altman@wdc.com>, Bean Huo <beanhuo@micron.com>, Andrew
 Halaney <ahalaney@redhat.com>
Date: Sun, 01 Sep 2024 21:25:55 +0200
In-Reply-To: <20240828174435.2469498-10-bvanassche@acm.org>
References: <20240828174435.2469498-1-bvanassche@acm.org>
	 <20240828174435.2469498-10-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

It's inconvenient to review them one by one, so until the last one. I
understand the main purpose is to remove init_dev_params. Why not merge
all the preparation patches into the last one?


On Wed, 2024-08-28 at 10:44 -0700, Bart Van Assche wrote:
> Both ufshcd_device_init() callers pass 'false' as second argument.
> Hence,
> remove that second argument.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> =C2=A0drivers/ufs/core/ufshcd.c | 44 +++++-------------------------------=
-
> --
> =C2=A01 file changed, 5 insertions(+), 39 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 16638974b34f..5239caf3fc65 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -298,7 +298,7 @@ static int ufshcd_reset_and_restore(struct
> ufs_hba *hba);
> =C2=A0static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd);
> =C2=A0static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
> =C2=A0static void ufshcd_hba_exit(struct ufs_hba *hba);
> -static int ufshcd_device_init(struct ufs_hba *hba, bool
> init_dev_params);
> +static int ufshcd_device_init(struct ufs_hba *hba);
> =C2=A0static int ufshcd_probe_hba(struct ufs_hba *hba);
> =C2=A0static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
> =C2=A0static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba
> *hba);
> @@ -7713,7 +7713,7 @@ static int ufshcd_host_reset_and_restore(struct
> ufs_hba *hba)
> =C2=A0
> =C2=A0	/* Establish the link again and restore the device */
> =C2=A0	if (!err) {
> -		err =3D ufshcd_device_init(hba,
> /*init_dev_params=3D*/false);
> +		err =3D ufshcd_device_init(hba);
> =C2=A0		if (!err)
> =C2=A0			err =3D ufshcd_probe_hba(hba);
> =C2=A0	}
> @@ -8788,9 +8788,8 @@ static int ufshcd_post_device_init(struct
> ufs_hba *hba)
> =C2=A0	return 0;
> =C2=A0}
> =C2=A0
> -static int ufshcd_device_init(struct ufs_hba *hba, bool
> init_dev_params)
> +static int ufshcd_device_init(struct ufs_hba *hba)
> =C2=A0{
> -	struct Scsi_Host *host =3D hba->host;
> =C2=A0	int ret;
> =C2=A0
> =C2=A0	ret =3D ufshcd_activate_link(hba);
> @@ -8798,7 +8797,7 @@ static int ufshcd_device_init(struct ufs_hba
> *hba, bool init_dev_params)
> =C2=A0		return ret;
> =C2=A0
> =C2=A0	/* Reconfigure MCQ upon reset */
> -	if (hba->mcq_enabled && !init_dev_params) {
> +	if (hba->mcq_enabled) {
> =C2=A0		ufshcd_config_mcq(hba);
> =C2=A0		ufshcd_mcq_enable(hba);
> =C2=A0	}
> @@ -8813,39 +8812,6 @@ static int ufshcd_device_init(struct ufs_hba
> *hba, bool init_dev_params)
> =C2=A0	if (ret)
> =C2=A0		return ret;
> =C2=A0
> -	/*
> -	 * Initialize UFS device parameters used by driver, these
> -	 * parameters are associated with UFS descriptors.
> -	 */
> -	if (init_dev_params) {
> -		ret =3D ufshcd_device_params_init(hba);
> -		if (ret)
> -			return ret;
> -		if (is_mcq_supported(hba) && !hba->scsi_host_added)
> {
> -			ufshcd_mcq_enable(hba);
> -			ret =3D ufshcd_alloc_mcq(hba);
> -			if (!ret) {
> -				ufshcd_config_mcq(hba);
> -			} else {
> -				/* Continue with SDB mode */
> -				ufshcd_mcq_disable(hba);
> -				use_mcq_mode =3D false;
> -				dev_err(hba->dev, "MCQ mode is
> disabled, err=3D%d\n",
> -					 ret);
> -			}
> -			ret =3D scsi_add_host(host, hba->dev);
> -			if (ret) {
> -				dev_err(hba->dev, "scsi_add_host
> failed\n");
> -				return ret;
> -			}
> -			hba->scsi_host_added =3D true;
> -		} else if (is_mcq_supported(hba)) {
> -			/* UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH
> is set */
> -			ufshcd_config_mcq(hba);
> -			ufshcd_mcq_enable(hba);
> -		}
> -	}
> -
> =C2=A0	return ufshcd_post_device_init(hba);
> =C2=A0}
> =C2=A0
> @@ -8879,7 +8845,7 @@ static int ufshcd_probe_hba(struct ufs_hba
> *hba)
> =C2=A0		}
> =C2=A0
> =C2=A0		/* Reinit the device */
> -		ret =3D ufshcd_device_init(hba,
> /*init_dev_params=3D*/false);
> +		ret =3D ufshcd_device_init(hba);
> =C2=A0		if (ret)
> =C2=A0			goto out;
> =C2=A0	}
>=20

