Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A06819B5B4
	for <linux-scsi@vger.kernel.org>; Tue, 25 Mar 2025 22:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742942770; cv=none; b=Agv2dU8nYZY1b1ta8hsYzLxTQmvZLxd3cp0KM+Gf1Ibi55eZorJaNFeuFbv5+kb5dZmygTReqb1gAAzYKKvl24Tjz0RZERLP29AradC4SqgioVltQvp9sAoFID/Cgchpg+Q92ZXNNELLpAwuGL6kiG97LkTfzogbS7SQHkqAD1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742942770; c=relaxed/simple;
	bh=LFuGkiM9ffisFPD0hCsCPTAitMkUb0839lSXekafNd4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=twJ/mbJMrEqw7MCtsIKhtVB41jdtzAzc7AAYgqj+olwYesdXLTiVO14s33FOaHe+IQ+wH9rnuaTiNvE6MnqSBwU0WvbKrvML5zu16sCVN9MDEM3Ww2aPUjMEmOHDsaJ/eXhCzEIo53Z/61wMiB8Ex/eWeDuOMATlO/Tel9/9+LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Vwk1JnqO; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Vwk1JnqO"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-54afb5fcebaso340579e87.3
        for <linux-scsi@vger.kernel.org>; Tue, 25 Mar 2025 15:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1742942767; x=1743547567; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SAwmlZpuDbs7qwh0Ik10nJh37s6ABqb9FDC7mLOiz6c=;
        b=Vwk1JnqO9wZtca//dWhNZRgkrezXIk4j9yX78eyjAk1xGcKpt9mdGGlH73UKQfWbZT
         uXuf/7/h3AgxO9JTy940tWVUnR1rua2A1Nf000kAs65uoi2kGIrF5hoxBo6J2ztUBJN4
         nXbbRHDx7GdtVad2W8wLN0E1Jcu39a4ONjblvxq58UopM8YkSAKaDhAT5ZmZUp75Wb7m
         yEeyklURpOU47YNLabHOidv3oPuToUSDfHD5JK2EBDZreBD+wsIz1IKMChu4TzscfKXG
         HGMGhTU3sTWSITYKZ2PjCR7W0FO6FckjuWt7Yx6X+gkqU+EcW3tl4GPLjgl+eHPkuxOe
         cXkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742942767; x=1743547567;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SAwmlZpuDbs7qwh0Ik10nJh37s6ABqb9FDC7mLOiz6c=;
        b=La8/rfoiFdEPGM3EQD39TCLf0QbQPtL3cRkrPUNxAas7G2IX5Xh3bBdCuABHxMoyYT
         JF0eJCGBahkg6BfEz1P+s/3hXLxtq0Humq9dQ3AtFkptaneixq7X5DaQTELlZ+VE4ss/
         dQ5ty+jo/MSIvUn927n5ejQdvpFYYiKCvKrSeRTlG3JqFHkR8yPSBqfNm04uoB4fIRpu
         5AwjDWdMmmavOJt85lmvMYpB2xlscHbb3ovl07DMQYBHqEFkip+rnDEFEFg6TDcA0BYk
         NcPtP/B9t9wY7rnVzTEieO8UdeHm6ARI0bErTSkjFdiV7HdPILRDwoA0rcIUJ4Wpby+B
         vb9Q==
X-Forwarded-Encrypted: i=1; AJvYcCXU3NRLJztV6DWxZ651dC/CnUbsSljykA6fs9dgZy9iq3ZGqdfjAAXjaZknqsnmf3IwMOaxCDZU8rbo@vger.kernel.org
X-Gm-Message-State: AOJu0YylSkr116r7neek6L03JSVqnesvOFUUUYkq+/bHcbQ9YgOnklse
	eCtTlMGdq8G4hrc26r+fXAkkhAWvd+CV1Ig1wCBkSdwW9M5oG2fzZHllIF4/a8JliHbxFqi3HTq
	B7JcYvUjiSJqHE481vpMkDWN9X2GUrtGJZSpdQQ==
X-Gm-Gg: ASbGnctfpCAo/aqyv1ApL9bYHwG8Ipr8rohU5SBH4u4VIm6qpBxX2B8QU1cyKz5rse+
	jSXFsmo27kS2a/8hbbom4H3BUEZ9UwOs6KJ8J+IoNGQ7EO8ZBirKL1u6z2SEPTolr8oONdpH8xz
	JOlDi6fD1myaj78/EbsH1zlDXbCpc=
X-Google-Smtp-Source: AGHT+IFYzydZEj2fz/i0tU1T3OS07zzuv8IDba4Nc6rzvF9LHv9El9Hl4DHgl/VGvtYmPD3zw7EBrgD8/3x8yNhuG30=
X-Received: by 2002:a05:6512:3b07:b0:549:8ed4:fb4c with SMTP id
 2adb3069b0e04-54ad648edecmr7413799e87.24.1742942766608; Tue, 25 Mar 2025
 15:46:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250321223319.109250-1-mwilck@suse.com>
In-Reply-To: <20250321223319.109250-1-mwilck@suse.com>
From: Lee Duncan <lduncan@suse.com>
Date: Tue, 25 Mar 2025 15:45:55 -0700
X-Gm-Features: AQ5f1Joq2D0jcm-hkyGJgAm-A-fD1lcV8QsSlFQhKMAybra3cN6QydyRqtES99g
Message-ID: <CAPj3X_VXx-yqiBnMTDPza=Y+8jQp-=jM_ktSJVKDYjC18QcGcA@mail.gmail.com>
Subject: Re: [PATCH] scsi: smartpqi: use is_kdump_kernel() to check for kdump
To: Martin Wilck <martin.wilck@suse.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Don Brace <don.brace@microchip.com>, 
	James Bottomley <jejb@linux.vnet.ibm.com>, storagedev@microchip.com, 
	linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Martin Wilck <mwilck@suse.com>, 
	Don Brace <con.brace@microchip.com>, Randy Wright <rwright@hpe.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 21, 2025 at 3:33=E2=80=AFPM Martin Wilck <martin.wilck@suse.com=
> wrote:
>
> The smartpqi driver checks the reset_devices variable to determine whethe=
r
> special adjustments need to be made for kdump. This has the effect that
> after a regular kexec reboot, some driver parameters such as
> max_transfer_size are much lower than usual. More importantly, kexec rebo=
ot
> tests have revealed memory corruption caused by the driver log being
> written to system memory after a kexec.
>
> Fix this by testing is_kdump_kernel() rather than reset_devices where
> appropriate.
>
> Fixes: 058311b72f54 ("scsi: smartpqi: Add fw log to kdump")
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Acked-by: Don Brace <don.brace@microchip.com>
> Tested-by: Don Brace <con.brace@microchip.com>
> Cc: Randy Wright <rwright@hpe.com>
> ---
>  drivers/scsi/smartpqi/smartpqi_init.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpq=
i/smartpqi_init.c
> index 0da7be40c925..e790b5d4e3c7 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -19,6 +19,7 @@
>  #include <linux/bcd.h>
>  #include <linux/reboot.h>
>  #include <linux/cciss_ioctl.h>
> +#include <linux/crash_dump.h>
>  #include <scsi/scsi_host.h>
>  #include <scsi/scsi_cmnd.h>
>  #include <scsi/scsi_device.h>
> @@ -5246,7 +5247,7 @@ static void pqi_calculate_io_resources(struct pqi_c=
trl_info *ctrl_info)
>         ctrl_info->error_buffer_length =3D
>                 ctrl_info->max_io_slots * PQI_ERROR_BUFFER_ELEMENT_LENGTH=
;
>
> -       if (reset_devices)
> +       if (is_kdump_kernel())
>                 max_transfer_size =3D min(ctrl_info->max_transfer_size,
>                         PQI_MAX_TRANSFER_SIZE_KDUMP);
>         else
> @@ -5275,7 +5276,7 @@ static void pqi_calculate_queue_resources(struct pq=
i_ctrl_info *ctrl_info)
>         u16 num_elements_per_iq;
>         u16 num_elements_per_oq;
>
> -       if (reset_devices) {
> +       if (is_kdump_kernel()) {
>                 num_queue_groups =3D 1;
>         } else {
>                 int num_cpus;
> @@ -8288,12 +8289,12 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ct=
rl_info)
>         u32 product_id;
>
>         if (reset_devices) {
> -               if (pqi_is_fw_triage_supported(ctrl_info)) {
> +               if (is_kdump_kernel() && pqi_is_fw_triage_supported(ctrl_=
info)) {
>                         rc =3D sis_wait_for_fw_triage_completion(ctrl_inf=
o);
>                         if (rc)
>                                 return rc;
>                 }
> -               if (sis_is_ctrl_logging_supported(ctrl_info)) {
> +               if (is_kdump_kernel() && sis_is_ctrl_logging_supported(ct=
rl_info)) {
>                         sis_notify_kdump(ctrl_info);
>                         rc =3D sis_wait_for_ctrl_logging_completion(ctrl_=
info);
>                         if (rc)
> @@ -8344,7 +8345,7 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl=
_info)
>         ctrl_info->product_id =3D (u8)product_id;
>         ctrl_info->product_revision =3D (u8)(product_id >> 8);
>
> -       if (reset_devices) {
> +       if (is_kdump_kernel()) {
>                 if (ctrl_info->max_outstanding_requests >
>                         PQI_MAX_OUTSTANDING_REQUESTS_KDUMP)
>                                 ctrl_info->max_outstanding_requests =3D
> @@ -8480,7 +8481,7 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl=
_info)
>         if (rc)
>                 return rc;
>
> -       if (ctrl_info->ctrl_logging_supported && !reset_devices) {
> +       if (ctrl_info->ctrl_logging_supported && !is_kdump_kernel()) {
>                 pqi_host_setup_buffer(ctrl_info, &ctrl_info->ctrl_log_mem=
ory, PQI_CTRL_LOG_TOTAL_SIZE, PQI_CTRL_LOG_MIN_SIZE);
>                 pqi_host_memory_update(ctrl_info, &ctrl_info->ctrl_log_me=
mory, PQI_VENDOR_GENERAL_CTRL_LOG_MEMORY_UPDATE);
>         }
> --
> 2.49.0
>
>

Reviewed-by: Lee Duncan <lduncan@suse.com>
