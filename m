Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82C71779B8
	for <linux-scsi@vger.kernel.org>; Thu, 17 Oct 2024 06:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729147559; cv=none; b=jV5XBnme0MG2GuDUNAqY+r9/taEZxt4mEr6EEpzpxVWI6FHPFKSIjAZ4tzFdxxOZBf7eT+7wMyCxa7ONV6BrCiiANCJSJNrdUh53ZYmMWImuz/dpTEAiFRUZJiDmZBqqmGW1hqaW2oMpw0f/XGzEcgkkbc036JHN/29pluIQf2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729147559; c=relaxed/simple;
	bh=WvEl9DacNb0/BST0J+DTdTUbgLuLI3VskPgh+pfr+R4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SayN881dRA6zARv1jMaoNpD7HyBsbrR0qu2h3YR8ytUXFgdXc2bebdPOI3I/mLKfSIL+brfJWj6bp9t+nLUAQ5Fc9sNFXHsyf83KlQ8vNxsQpLkht261/+cLtXgMbKWIrEcWMkWB2OrKEbuGZTu3xH+bWD+VOG2IYvI222fohKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=Rq8iqK+D; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="Rq8iqK+D"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5c939e5a0f6so88602a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2024 23:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1729147555; x=1729752355; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hA7C/VJ2ogxqQJtDshb/T2bDSZIF624vqyDyYkZ46Hs=;
        b=Rq8iqK+DHGJe61XdAHe1xXAjZqR3ZxF6dss5Q7gFqY97/UcD6r2+n68DJpGQzltekz
         Mp+vffsuKaT4H9pU0b74Yx8RcRXybxiCc6kv1EeJ6flhqF2kpDkrDCrmOrR3ACiMDO4W
         u3pF52x09h9+MKfleqyDnz9UzFm/I2wO6iZc0fxcXPKB7/m2PFcBFqCGz0vc2L0SmW1N
         H6WkCZXbKfS2sBKuueFYrNCLcIWMaR49vJ+XMQTVRvMTWjfTbZHwtBMN0+EXDDU+h2ow
         TCxz+g4oEZFDeDNyk2/JjAHb7qyIiwW3cVn4cUvXBlpEVN/Qn7PjgKGt3eEUv5nXcD1F
         kg/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729147555; x=1729752355;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hA7C/VJ2ogxqQJtDshb/T2bDSZIF624vqyDyYkZ46Hs=;
        b=t5V7bDir5xCXqle83ka1M2ZBITBV03eyNS0oMCHTWwAs6GLAbeMVepdYCy9c5jK7v3
         rCmjPVvv9OblgYlzomdBet2hPJDHPjdz/JMNCefuy5ouKDks0RZM0giDEt9OMgnv343h
         Osf+LmCHG8i8g6g5/53HowSO86JEZ4uKwWdY386WbehDBBvssnu82f0jXxzz4XUp/Xai
         ukaXGFBc0sFN4lzKHbsPhtMoaUmqlI5cq+5bO5bPtOeXVtHEgPKUdeEXyfHC9Mr8GN9R
         YE+uy/BzcljZp+Lc/TnIifOsTqMQ7n6v2ZlozYLy8ldCjI30pK6I/gaQgt1ZCP4566Ik
         aqLA==
X-Forwarded-Encrypted: i=1; AJvYcCVbdOxRpDD7k906s7kspSyKPxC8heigT0flJo6cqadlstDMZOx/jzZkrRs8HWKWf8g0PJ24wwBzPLJY@vger.kernel.org
X-Gm-Message-State: AOJu0YyKyVj7sIbBg02NTJZdP8DvyQpI3csNFwnSaUmWStwR5a/sXnas
	HwQJciocYJQYQLyJJIx2vAOwqDy23Y/iM8Xgl1IfOFtttWLIutaKaUrnRZW06Z0PiHNKWDyMIx2
	WpJWV9nrN5Jj0NJHXLjo45atxP4MQzHuyYg852A==
X-Google-Smtp-Source: AGHT+IGvpu0H/wkCYjOHR1j1gd+ny9Zce6kSu5Qi/Zi4b3sW7Fe8QJ3fF6w/Nr24bNVxZt2SRBfk1slaPwZVfl8Y6hs=
X-Received: by 2002:a05:6402:2741:b0:5c9:4499:2810 with SMTP id
 4fb4d7f45d1cf-5c99979830dmr1687144a12.5.1729147554947; Wed, 16 Oct 2024
 23:45:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241016220944.370539-1-salomondush@google.com>
In-Reply-To: <20241016220944.370539-1-salomondush@google.com>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Thu, 17 Oct 2024 08:45:43 +0200
Message-ID: <CAMGffEmEJp_oVAsbCVV9PKs7vOKWLrUhRGcBGoUSx7+t4ZtsQA@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm80xx: Use module param to set pcs event log severity
To: Salomon Dushimirimana <salomondush@google.com>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Bhavesh Jashnani <bjashnani@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 17, 2024 at 12:10=E2=80=AFAM Salomon Dushimirimana
<salomondush@google.com> wrote:
>
> The pm8006 driver sets pcs event log threshold very high which causes
> most of the FW logs to not be captured. This adds a module parameter to
> configure pcs event log severity with 3 (medium severity) as the
> default.
upstream does not like more module parameters, can we just change the
default to 3, any harm?

Thx!
>
> Signed-off-by: Bhavesh Jashnani <bjashnani@google.com>
> Signed-off-by: Salomon Dushimirimana <salomondush@google.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 4 ++++
>  drivers/scsi/pm8001/pm8001_sas.h  | 2 ++
>  drivers/scsi/pm8001/pm80xx_hwi.c  | 3 ++-
>  3 files changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm80=
01_init.c
> index 1e63cb6cd8e3..355aab0c982a 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -68,6 +68,10 @@ static bool pm8001_read_wwn =3D true;
>  module_param_named(read_wwn, pm8001_read_wwn, bool, 0444);
>  MODULE_PARM_DESC(zoned, "Get WWN from the controller. Default: true");
>
> +uint pcs_event_log_severity =3D 0x03;
> +module_param(pcs_event_log_severity, int, 0644);
> +MODULE_PARM_DESC(pcs_event_log_severity, "PCS event log severity level")=
;
> +
>  static struct scsi_transport_template *pm8001_stt;
>  static int pm8001_init_ccb_tag(struct pm8001_hba_info *);
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm800=
1_sas.h
> index ced6721380a8..42c7b3f7afbf 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -96,6 +96,8 @@ extern struct list_head hba_list;
>  extern const struct pm8001_dispatch pm8001_8001_dispatch;
>  extern const struct pm8001_dispatch pm8001_80xx_dispatch;
>
> +extern uint pcs_event_log_severity;
> +
>  struct pm8001_hba_info;
>  struct pm8001_ccb_info;
>  struct pm8001_device;
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
> index 8fe886dc5e47..9b237a764d0b 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -763,7 +763,8 @@ static void init_default_table_values(struct pm8001_h=
ba_info *pm8001_ha)
>                 pm8001_ha->memoryMap.region[IOP].phys_addr_lo;
>         pm8001_ha->main_cfg_tbl.pm80xx_tbl.pcs_event_log_size           =
=3D
>                                                         PM8001_EVENT_LOG_=
SIZE;
> -       pm8001_ha->main_cfg_tbl.pm80xx_tbl.pcs_event_log_severity       =
=3D 0x01;
> +       pm8001_ha->main_cfg_tbl.pm80xx_tbl.pcs_event_log_severity       =
=3D
> +               pcs_event_log_severity;
>         pm8001_ha->main_cfg_tbl.pm80xx_tbl.fatal_err_interrupt          =
=3D 0x01;
>
>         /* Enable higher IQs and OQs, 32 to 63, bit 16 */
> --
> 2.47.0.rc1.288.g06298d1525-goog
>
