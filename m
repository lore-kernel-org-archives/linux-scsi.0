Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172881F5FA
	for <linux-scsi@vger.kernel.org>; Fri, 14 Jun 2024 05:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718343455; cv=none; b=cc0Ox3ZyC+OLQ+viDzFtmOQJXns0K6C2gmqgfTCO1ipdQzRNYV30a8WVm+lbB07mWlIqta1hPBaP2oQEZNApKfxWJDaaDQoMSok7ulHWjUdO+HyljoLajK5GhpWErOvpGLusxK7t9qF0EJFIP+bQIAzTMzydu8m+LObXmceDQQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718343455; c=relaxed/simple;
	bh=8T+QhiNg7Bt++0GshJwj6I0GfsY8Q9BnSjRJgs2YKgc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EFhXgwNWP+ILxz/svOncLu4e4+IJ2pR/kKYfvKoIWrf1qv1xG35Np6FKxLpSCR8eCytwTZMZkRCRnJbDrJAOIDCk9aMQuhpDPFY3UO3sUSlPtyGwkyz/2/L91WLfC6qRswuhZ7rKI9vD+uCLswYe9/5uYGfADp4grgMyVWj1Pas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=ZWlqtdBa; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="ZWlqtdBa"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-57c714a1e24so1826963a12.2
        for <linux-scsi@vger.kernel.org>; Thu, 13 Jun 2024 22:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1718343451; x=1718948251; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=delu4YQTi6u5yOUmpwf63WiLLU0nftXUSM4UoxUZK0o=;
        b=ZWlqtdBasYcxJz83FwMmc6PF6N3cUWU10GK2fhlMt5gIR9DwIjbbhhZthk3iQV0d5o
         wfId2bYbKitHo62P1N936SdiADci4cjNYmgFp2udN2rWZfjfuoWUKjkj+fsR/2H39/bE
         w6jKN3o6R7PUeFGgJQNEaCCqFz0lIcaP6ITnQbSpfMNcTRtZ5Sk8MrZ5F34Xb+Yaa+ZY
         2eWsFkUMnicF5dyuQ1KogoNVSMcnnXDwqAaSKoperMQBMQQZhNmNL20+Txa5RCuoW7Wz
         dFTaOPKx75NdWtdhApfX98VQyK4PglbrbXCBL3rKXamyTm/aYB/xJ9L3+UA1yIM6AIT4
         nsWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718343451; x=1718948251;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=delu4YQTi6u5yOUmpwf63WiLLU0nftXUSM4UoxUZK0o=;
        b=ph7rZkCmokcVv33dQK6UXOXjT9yefQ3ZlqHizq67WzdkTFk/MBUlbPHnrlCqa0YfV7
         GwvlUvCgRwxsHW51YxWA5/OkD5Adz3YSDLrdQBEfUHaSisWklU6npXDBpf00GPEdYuG8
         LQ7GNr2tyqAdFYoYShoq0ncASzu5q2TdI9z/eqX9SdMVjmwCJkuLhEG98lONjkUsS10X
         /HdWt+zjhwhNWy0vYCzA8lYTw3X3iYzPZnyi2OwjTooPzMkSZBuTXELJqK2eazqMNWyG
         7ITS7YfRIZsxYS59I56DB7iwucGXmi3m60IpJn+DemXx1gwTOGPrhZIlx4XFcYF7lTIX
         qInw==
X-Forwarded-Encrypted: i=1; AJvYcCVIDkn1VtuOKODj0E1312ZezwiVBFf5DrEpR1u/E/fjBzWioRNBha9nA5fTZ8sBYbnHBNKh/wa2M8j7vPlJhBvGWOFneci7q2itAg==
X-Gm-Message-State: AOJu0Yzc2Tibr2Ul4vpXn+56QsEMxJ66oQPJm714RAerB2T7+3+2IP0U
	jN4Ih4R+W/JvfG7tUZwoNYuqgJ+gVjc/6suFasge6V+mzuSGrPfQEojhRAEDY+/fIr5WbSyRidi
	uTmGwEiPSKDb0fBMdnKX7MqKNNSqarthYj6YX1g==
X-Google-Smtp-Source: AGHT+IGnkfTgvLete5xmc2tK01h5ZrNPidiZ2ZMA215vnuf8zbu6JKcOyWWZ8eIf4ngVkKwRVJhUDs7OVYedAu1YeOs=
X-Received: by 2002:a50:a45c:0:b0:57c:b83a:fef5 with SMTP id
 4fb4d7f45d1cf-57cbd8b9be3mr1004895a12.34.1718343451340; Thu, 13 Jun 2024
 22:37:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240607175743.3986625-1-tadamsjr@google.com> <20240607175743.3986625-4-tadamsjr@google.com>
In-Reply-To: <20240607175743.3986625-4-tadamsjr@google.com>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Fri, 14 Jun 2024 07:37:20 +0200
Message-ID: <CAMGffEmWnDGFL8cVrTLuUOkYUt2fVmjxFH=ewtKt8To436zoFg@mail.gmail.com>
Subject: Re: [PATCH 3/3] scsi: pm8001: Update log level when reading config table
To: TJ Adams <tadamsjr@google.com>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 7, 2024 at 7:57=E2=80=AFPM TJ Adams <tadamsjr@google.com> wrote=
:
>
> From: Terrence Adams <tadamsjr@google.com>
>
> Reading the main config table occurs as a part of initialization in
> pm80xx_chip_init(). Because of this it makes more sense to have it be a
> part of the INIT logging.
>
> Signed-off-by: Terrence Adams <tadamsjr@google.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
> index a52ae6841939..8fe886dc5e47 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -568,13 +568,13 @@ static void read_main_config_table(struct pm8001_hb=
a_info *pm8001_ha)
>         pm8001_ha->main_cfg_tbl.pm80xx_tbl.inc_fw_version =3D
>                 pm8001_mr32(address, MAIN_MPI_INACTIVE_FW_VERSION);
>
> -       pm8001_dbg(pm8001_ha, DEV,
> +       pm8001_dbg(pm8001_ha, INIT,
>                    "Main cfg table: sign:%x interface rev:%x fw_rev:%x\n"=
,
>                    pm8001_ha->main_cfg_tbl.pm80xx_tbl.signature,
>                    pm8001_ha->main_cfg_tbl.pm80xx_tbl.interface_rev,
>                    pm8001_ha->main_cfg_tbl.pm80xx_tbl.firmware_rev);
>
> -       pm8001_dbg(pm8001_ha, DEV,
> +       pm8001_dbg(pm8001_ha, INIT,
>                    "table offset: gst:%x iq:%x oq:%x int vec:%x phy attr:=
%x\n",
>                    pm8001_ha->main_cfg_tbl.pm80xx_tbl.gst_offset,
>                    pm8001_ha->main_cfg_tbl.pm80xx_tbl.inbound_queue_offse=
t,
> @@ -582,7 +582,7 @@ static void read_main_config_table(struct pm8001_hba_=
info *pm8001_ha)
>                    pm8001_ha->main_cfg_tbl.pm80xx_tbl.int_vec_table_offse=
t,
>                    pm8001_ha->main_cfg_tbl.pm80xx_tbl.phy_attr_table_offs=
et);
>
> -       pm8001_dbg(pm8001_ha, DEV,
> +       pm8001_dbg(pm8001_ha, INIT,
>                    "Main cfg table; ila rev:%x Inactive fw rev:%x\n",
>                    pm8001_ha->main_cfg_tbl.pm80xx_tbl.ila_version,
>                    pm8001_ha->main_cfg_tbl.pm80xx_tbl.inc_fw_version);
> --
> 2.45.2.505.gda0bf45e8d-goog
>
