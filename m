Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6A13376A8
	for <linux-scsi@vger.kernel.org>; Wed, 15 Oct 2025 16:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760547596; cv=none; b=SJ3iviN3IcsmgtlbdnB/XoUDKRqh81jP+blFtZFPW7T6fL1mXNaBNGgIyLpCqqirpji1tkdtpUNpWNvCNsc4ymYCie+2wMoilCHT/6NlpSMdmEpfe6o4Naa4LK8VQW5+oFBZQZaGtN9IWjS9LlW+ah7SbzY0c9LBlZOcDhfu2yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760547596; c=relaxed/simple;
	bh=/KFPaJyfP7d2zYz74RkPmAcqS3EMyToEVNeZsuslS2g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Uo2qVjwMYGP1/ZeT8csB3vgjCOTdzH+5KuEXM4epdTH8WHPL/3o1FwNgZgZfaGjX514FlsIZhU8Zp1c0YcU1usnoUh6GzNgjdxZkDgtS3jNmttCzjYX2y1RfUI03rNNQ2spEJe4sJQzE395MSlLbRDaq8MKVL8dJFJZMf0dHs1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fIL2BDa9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fIL2BDa9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760547593;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/DT69RdMW8l2tJZPu/XhlgUH9uuCU8dDJala8kOLfic=;
	b=fIL2BDa98BLWxFnlUKrUppDWGQ5MWbBwQ0YXBPm2/V+Ru4CzipNq6OZ1Te0rOUkrNogzdr
	uhk1/5KlNqPNNvfU5TVchw74YQIVmxNtiDcOG4eTGTYgs8p4csVP3sQH2DkA1yfIkUWQuK
	UjkS7cxV+2sAGdK1gZDamZKmx3fAAEg=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-76-pamO1Nz_PLWxS5YeKu9fHg-1; Wed, 15 Oct 2025 12:59:52 -0400
X-MC-Unique: pamO1Nz_PLWxS5YeKu9fHg-1
X-Mimecast-MFC-AGG-ID: pamO1Nz_PLWxS5YeKu9fHg_1760547592
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-76d7efdbac9so19322317b3.1
        for <linux-scsi@vger.kernel.org>; Wed, 15 Oct 2025 09:59:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760547592; x=1761152392;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/DT69RdMW8l2tJZPu/XhlgUH9uuCU8dDJala8kOLfic=;
        b=pUNu6Nmc/hMCgJZQTmNPQKJHkimCWfKev+91MEhsHyZ5vL8m6ADxT4f1OYZKOp7dJF
         03TzYTH45kTBdqwxDB5baKMgQ+K4SATnDOTNwZs3XKQ26xS3cTVNz3nVFOXLDOXrV3aT
         amvSYQv5nLy+MEVp8kVp0/sw5Wx4tdCSil8NHYtGKjZzByME3aXWxTBveywH0nRagboz
         +U/3psUSZRWBDYohpBe8JaCdQli7beLrH+7B1ArHgdKDKL9/SMPpW+/as/Jm8qeGSrLp
         R+DTDKvzGrTuBQUCprLZCKWeGwDaKFo+4+wtGmLY4OxwNkBwfm5bBIZ/fgqEfQlK6+Z/
         JLDg==
X-Forwarded-Encrypted: i=1; AJvYcCUFNTb7y6JPwSdBFmcjW15J8USjdh+cuRKaZDrXra7b48c85Sb6xENFPHXZvw8RKowwO6bgyxLvM6I8@vger.kernel.org
X-Gm-Message-State: AOJu0Yxi2e2ESce/xG7Nzczr1ovvdA44SNgh2wu0J6rzksV+RiCK5hUB
	hacNKzMb1MT+ukK/RgLC8ONC6+s7kQDGdCrUjl7fciY0iOzR69GVaVyoL8wu8xEvogkqWaPGmId
	pOqZvlHxXXtgKDenR0tRX3MM8wK0K4nzKTwKVOmQX+S//y4nsZeR+HsS7rimnylzgqlLVchhwsf
	IjMtRILc2cwoghKIJDKXrdSn//JI2QzM3c2DSRtg==
X-Gm-Gg: ASbGncutDLc57hzX2XjTfJAipZqLglRo1ibl6393h4ruTyaDBrOdAb/fy3SgGbBaDak
	tVCk4IyZywSNE0bWaFelIJlE+dyRAvh0OPjpwB0M0Qv9WoMVdWZFM+u3ohh+/yY65BGoELR9eGN
	qjB2Pe9lJaII1dTwYGfH9PMA==
X-Received: by 2002:a05:690e:d8b:b0:63e:99f:4392 with SMTP id 956f58d0204a3-63e099f484emr405636d50.16.1760547591622;
        Wed, 15 Oct 2025 09:59:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGlD/q+23qR9Uz9QsP5784CZYzeqdiOmhq2wlFj/dA2OJkfpx70aFZENbHiPZRd5sydPz/ur+Cegc/WrL3S1zA=
X-Received: by 2002:a05:690e:d8b:b0:63e:99f:4392 with SMTP id
 956f58d0204a3-63e099f484emr405614d50.16.1760547591161; Wed, 15 Oct 2025
 09:59:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251014220244.3689508-1-bvanassche@acm.org>
In-Reply-To: <20251014220244.3689508-1-bvanassche@acm.org>
From: Ewan Milne <emilne@redhat.com>
Date: Wed, 15 Oct 2025 12:59:39 -0400
X-Gm-Features: AS18NWAPvh1ji3fRimk4UzfDRLNYIFysY3KrosbdHi8znF1XnmQgcy-Lkv6MyrI
Message-ID: <CAGtn9r=j-ea96uGaGfZAFJegSCKrmd2V980XuKGze35CMM6Fpw@mail.gmail.com>
Subject: Re: [PATCH] scsi: core: Fix the unit attention counter implementation
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	=?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	John Meneghini <jmeneghi@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 14, 2025 at 6:03=E2=80=AFPM Bart Van Assche <bvanassche@acm.org=
> wrote:
>
> scsi_decide_disposition() may call scsi_check_sense().
> scsi_decide_disposition() calls are not serialized. Hence, counter
> updates by scsi_check_sense() must be serialized. Hence this patch that
> makes the counters updated by scsi_check_sense() atomic.
>
> Cc: Kai M=C3=A4kisara <Kai.Makisara@kolumbus.fi>
> Fixes: a5d518cd4e3e ("scsi: core: Add counters for New Media and Power On=
/Reset UNIT ATTENTIONs")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_error.c  |  4 ++--
>  include/scsi/scsi_device.h | 10 ++++------
>  2 files changed, 6 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 746ff6a1f309..1c13812a3f03 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -554,9 +554,9 @@ enum scsi_disposition scsi_check_sense(struct scsi_cm=
nd *scmd)
>                  * happened, even if someone else gets the sense data.
>                  */
>                 if (sshdr.asc =3D=3D 0x28)
> -                       scmd->device->ua_new_media_ctr++;
> +                       atomic_inc(&sdev->ua_new_media_ctr);
>                 else if (sshdr.asc =3D=3D 0x29)
> -                       scmd->device->ua_por_ctr++;
> +                       atomic_inc(&sdev->ua_por_ctr);
>         }
>
>         if (scsi_sense_is_deferred(&sshdr))
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 4c106342c4ae..3c6c8e3995c3 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -252,8 +252,8 @@ struct scsi_device {
>         unsigned int queue_stopped;     /* request queue is quiesced */
>         bool offline_already;           /* Device offline message logged =
*/
>
> -       unsigned int ua_new_media_ctr;  /* Counter for New Media UNIT ATT=
ENTIONs */
> -       unsigned int ua_por_ctr;        /* Counter for Power On / Reset U=
As */
> +       atomic_t ua_new_media_ctr;      /* Counter for New Media UNIT ATT=
ENTIONs */
> +       atomic_t ua_por_ctr;            /* Counter for Power On / Reset U=
As */
>
>         atomic_t disk_events_disable_depth; /* disable depth for disk eve=
nts */
>
> @@ -693,10 +693,8 @@ static inline int scsi_device_busy(struct scsi_devic=
e *sdev)
>  }
>
>  /* Macros to access the UNIT ATTENTION counters */
> -#define scsi_get_ua_new_media_ctr(sdev) \
> -       ((const unsigned int)(sdev->ua_new_media_ctr))
> -#define scsi_get_ua_por_ctr(sdev) \
> -       ((const unsigned int)(sdev->ua_por_ctr))
> +#define scsi_get_ua_new_media_ctr(sdev)        atomic_read(&sdev->ua_new=
_media_ctr)
> +#define scsi_get_ua_por_ctr(sdev)      atomic_read(&sdev->ua_por_ctr)
>
>  #define MODULE_ALIAS_SCSI_DEVICE(type) \
>         MODULE_ALIAS("scsi:t-" __stringify(type) "*")
>

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

