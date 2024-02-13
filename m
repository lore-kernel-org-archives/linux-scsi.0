Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5E05F84B
	for <linux-scsi@vger.kernel.org>; Tue, 13 Feb 2024 16:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707841097; cv=none; b=P4Mh5b3J83byfe7PN9Q1HVn+ufc6V8gFjTunilf0byJHNJz5Rw7q08uVHuQlP4yne2h/3ltUeEItRp+6bAkBvQL7d0hBDX1Bmt+sxwt97dMEXMRA0CsmsBqKzk6uJeTaxa9MIpnsYOR0GzpY0uMX0Nx0iZESFSuEod3QYnpyBKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707841097; c=relaxed/simple;
	bh=J9rJmD/wF68ZyFDppt7/GGyUh8SL5F7pBrw8MXnWciE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XKkZvvycqvfvFq4ynxFFMmgohSxoqL88P5ggsPQuLTJPm+DpVVdXwHCepama1g7v3D6U10DxzdO3aqLwgSqbz96lnnNAgoAbi5zLawCCIzxQVXKuH/dLTfjJVZDtfKtKGi6hEpKFdWnF2yMBerLmKFiSYxyX+wX5AdERFM8nfak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fqhNGMaQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fqhNGMaQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707841094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jP6zM6JUyUuaxI80Iu/ENEz3I4paIl3LHRM8g9bJbLs=;
	b=fqhNGMaQkc6ro30/QUEF26DkNmE+bOSjp8BMfaEawbTK45czQ8FfTTqV4/OVP7nDMU9fSN
	nBFtg60ZB9XTYGwXOpVkbsFMuO9HDuDmCAfZdduPrvM+9LJi/Isk6gjleI9Zr1Y91vWoLb
	ylVa5zSJdSyTZKTlXXnFq0XnkhH14Ac=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-5WScY6JjPOezKFJgZFHuHw-1; Tue, 13 Feb 2024 11:18:12 -0500
X-MC-Unique: 5WScY6JjPOezKFJgZFHuHw-1
Received: by mail-yb1-f198.google.com with SMTP id 3f1490d57ef6-dbf216080f5so7003326276.1
        for <linux-scsi@vger.kernel.org>; Tue, 13 Feb 2024 08:18:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707841092; x=1708445892;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jP6zM6JUyUuaxI80Iu/ENEz3I4paIl3LHRM8g9bJbLs=;
        b=VKrpqmYXnvsBrQ+A/S1308vD1Z8pgOIfBwKaaEhowCgxJpAWgJ7iiWggFwbhQTfZUN
         +GKq0NbV/M/DR08rbnsuoDc0sboSvBaovLATPuD33F7lXDYefoSvs+oDYqUKbKvjuCXf
         z9yEalWS4OEVdrtGwOE79K+7pusr105ZDfhRBXf1wl1CpNGbudBw4VooIGm+0L0gAV+h
         LGKHVWTTrn1kWUxlLV3ucVQJlrU/SFIbHBxvTkoGlzwVXsxfEoKlUG/EEVauNkmMgk5e
         oihrYrSnBM+eoH6lPxlZ5HOmXAjoWplRPems+d1pV7bnvTMNU6p4EHveRQPw4dVzEloH
         Fplw==
X-Gm-Message-State: AOJu0YzPvUDq1OIycm1bZB3i7sbRufjrMGpzaWNgLKFqYZkue5WWPA4p
	Fov1o2rVJAlHV42vDSafhCdC/awzmAZrdGg/TII0QOmcSWGxw/EYLgQbUw/f9B3COJRLb5jC3KL
	FSlpc0tFL/nAzJVnwQ6n5c67g/CD/kNRFdURGdl/fYXWLpwrAMO7VT5Eb9U9Osfhp7JsV2zBjqF
	q4pYTBaSQBL09OifUrXVfR3tU8tGpMDumtww==
X-Received: by 2002:a25:97c8:0:b0:dc2:470b:887e with SMTP id j8-20020a2597c8000000b00dc2470b887emr8938959ybo.21.1707841091793;
        Tue, 13 Feb 2024 08:18:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHPnphPAHCsQf5o1AiLNqru9MTtH3wHCHuFE14130sV/d1eji49TfWEnHETDXu8Wi7wYjH6FecDFlIByc6Dx+g=
X-Received: by 2002:a25:97c8:0:b0:dc2:470b:887e with SMTP id
 j8-20020a2597c8000000b00dc2470b887emr8938942ybo.21.1707841091490; Tue, 13 Feb
 2024 08:18:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240213143306.2194237-1-martin.petersen@oracle.com>
In-Reply-To: <20240213143306.2194237-1-martin.petersen@oracle.com>
From: Ewan Milne <emilne@redhat.com>
Date: Tue, 13 Feb 2024 11:18:00 -0500
Message-ID: <CAGtn9r=KGOHNJg61dNp2+YdTmXkRFn=aH2wF_JZe3NpoSet8LA@mail.gmail.com>
Subject: Re: [PATCH] scsi: sd: usb_storage: uas: Access media prior to
 querying device properties
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, belegdol@gmail.com, 
	stable@vger.kernel.org, Tasos Sahanidis <tasos@tasossah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 13, 2024 at 9:33=E2=80=AFAM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> It has been observed that some USB/UAS devices return generic
> properties hardcoded in firmware for mode pages and vital product data
> for a period of time after a device has been discovered. The reported
> properties are either garbage or they do not accurately reflect the
> properties of the physical storage device attached in the case of a
> bridge.
>
> Prior to commit 1e029397d12f ("scsi: sd: Reorganize DIF/DIX code to
> avoid calling revalidate twice") we would call revalidate several
> times during device discovery. As a result, incorrect values would
> eventually get replaced with ones accurately describing the attached
> storage. When we did away with the redundant revalidate pass, several
> cases were reported where devices reported nonsensical values or would
> end up in write-protected state.
>
> An initial attempt at addressing this issue involved introducing a
> delayed second revalidate invocation. However, this approach still
> left some devices reporting incorrect characteristics.
>
> Tasos Sahanidis debugged the problem further and identified that
> introducing a READ operation prior to MODE SENSE fixed the problem and
> that it wasn't a timing issue. Issuing a READ appears to cause the
> devices to update their SCSI pages to reflect the actual properties of
> the storage media. Device properties like vendor, model, and storage
> capacity appear to be correctly reported from the get-go. It is
> unclear why these device defer populating the remaining
> characteristics.
>
> Match the behavior of a well known commercial operating system and
> trigger a READ operation prior to querying device characteristics to
> force the device to populate mode pages and VPDs.
>
> The additional READ is triggered by a flag set in the USB storage and
> UAS drivers. We avoid issuing the READ for other transport classes
> since some storage devices identify Linux through our particular
> discovery command sequence.
>
> Cc: <stable@vger.kernel.org>
> Fixes: 1e029397d12f ("scsi: sd: Reorganize DIF/DIX code to avoid calling =
revalidate twice")
> Reported-by: Tasos Sahanidis <tasos@tasossah.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  drivers/scsi/sd.c              | 27 ++++++++++++++++++++++++++-
>  drivers/usb/storage/scsiglue.c |  7 +++++++
>  drivers/usb/storage/uas.c      |  7 +++++++
>  include/scsi/scsi_device.h     |  1 +
>  4 files changed, 41 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 530918cbfce2..c284628f702c 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3405,6 +3405,24 @@ static bool sd_validate_opt_xfer_size(struct scsi_=
disk *sdkp,
>         return true;
>  }
>
> +static void sd_read_block_zero(struct scsi_disk *sdkp)
> +{
> +       unsigned int buf_len =3D sdkp->device->sector_size;
> +       char *buffer, cmd[10] =3D { };
> +
> +       buffer =3D kmalloc(buf_len, GFP_KERNEL);
> +       if (!buffer)
> +               return;
> +
> +       cmd[0] =3D READ_10;
> +       put_unaligned_be32(0, &cmd[2]); /* Logical block address 0 */
> +       put_unaligned_be16(1, &cmd[7]); /* Transfer 1 logical block */
> +
> +       scsi_execute_cmd(sdkp->device, cmd, REQ_OP_DRV_IN, buffer, buf_le=
n,
> +                        SD_TIMEOUT, sdkp->max_retries, NULL);
> +       kfree(buffer);
> +}
> +
>  /**
>   *     sd_revalidate_disk - called the first time a new disk is seen,
>   *     performs disk spin up, read_capacity, etc.
> @@ -3444,7 +3462,14 @@ static int sd_revalidate_disk(struct gendisk *disk=
)
>          */
>         if (sdkp->media_present) {
>                 sd_read_capacity(sdkp, buffer);
> -
> +               /*
> +                * Some USB/UAS devices return generic values for mode pa=
ges
> +                * and VPDs until the media has been accessed. Trigger a =
READ
> +                * operation to force the device to populate mode pages a=
nd
> +                * VPDs.
> +                */
> +               if (sdp->read_before_ms)
> +                       sd_read_block_zero(sdkp);
>                 /*
>                  * set the default to rotational.  All non-rotational dev=
ices
>                  * support the block characteristics VPD page, which will
> diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglu=
e.c
> index c54e9805da53..12cf9940e5b6 100644
> --- a/drivers/usb/storage/scsiglue.c
> +++ b/drivers/usb/storage/scsiglue.c
> @@ -179,6 +179,13 @@ static int slave_configure(struct scsi_device *sdev)
>                  */
>                 sdev->use_192_bytes_for_3f =3D 1;
>
> +               /*
> +                * Some devices report generic values until the media has=
 been
> +                * accessed. Force a READ(10) prior to querying device
> +                * characteristics.
> +                */
> +               sdev->read_before_ms =3D 1;
> +
>                 /*
>                  * Some devices don't like MODE SENSE with page=3D0x3f,
>                  * which is the command used for checking if a device
> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 696bb0b23599..299a6767b7b3 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -878,6 +878,13 @@ static int uas_slave_configure(struct scsi_device *s=
dev)
>         if (devinfo->flags & US_FL_CAPACITY_HEURISTICS)
>                 sdev->guess_capacity =3D 1;
>
> +       /*
> +        * Some devices report generic values until the media has been
> +        * accessed. Force a READ(10) prior to querying device
> +        * characteristics.
> +        */
> +       sdev->read_before_ms =3D 1;
> +
>         /*
>          * Some devices don't like MODE SENSE with page=3D0x3f,
>          * which is the command used for checking if a device
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 10480eb582b2..cb019c80763b 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -202,6 +202,7 @@ struct scsi_device {
>         unsigned use_10_for_rw:1; /* first try 10-byte read / write */
>         unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select =
*/
>         unsigned set_dbd_for_ms:1; /* Set "DBD" field in mode sense */
> +       unsigned read_before_ms:1;      /* perform a READ before MODE SEN=
SE */
>         unsigned no_report_opcodes:1;   /* no REPORT SUPPORTED OPERATION =
CODES */
>         unsigned no_write_same:1;       /* no WRITE SAME command */
>         unsigned use_16_for_rw:1; /* Use read/write(16) over read/write(1=
0) */
> --
> 2.42.1
>
>

So the READ CAPACITY is correct but the VPD pages etc are not?  OK.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

