Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484BA18AE2
	for <linux-scsi@vger.kernel.org>; Wed,  4 Dec 2024 13:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733319935; cv=none; b=ZPU55xcc5e62l00img3GWPDb3jS7Pnq0iisKWXxwYVEAgZM/G5wtzW8SzxDDBXG3nj2Sr/tameXfdwrhHVDNwyP1e5Ltl+SdSuyOCGnOPVfbvki0++4vbbC/z7WUAhtdOmsSR2+yzFANSwbrDfTW7qSwZAgzlS5d//Wi3X4TCK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733319935; c=relaxed/simple;
	bh=x7Zks2UUvhFqsbG7mkkKJv6OfEMFvfDACbsVK7TrU8s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FNLNd37uReZpsaz/K3riZe5rJYcSqtHBg+kj9n/VNBfw2a7eXM1rpbC5SXxObbQV6apTpxtH/5COuojdpeYNL44XQpZBmLhP7myOEpSJD1S2jUT4eOKvwCpX7LWASFkmoGVa8D8Kw0p0SJ6k/VtM53W0OLLmrtjT2BCb6Lia5oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XEzESmK2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XEzESmK2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733319932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gfzsMKSDpksu1Ik71I0LavlaD/4ezjHXC0zfA3/Wep4=;
	b=XEzESmK2wDAG16TeBuiPYNpu9OrGFL3GZX6dUBmR7DTFORWXLFyBr/K5NY+xwbacbwPnvC
	1lE2Up22oR263S4G4vGlEFXkW7E7k0B5LtzLt4h4t64YfIJyW/pIWgyJxEOVZd219tcj+C
	ZKA07QLkIbJyGaxtcPbCd6zC8ZrRt7c=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-130-Xe_szrQlNI26btKa-dsMcg-1; Wed, 04 Dec 2024 08:45:31 -0500
X-MC-Unique: Xe_szrQlNI26btKa-dsMcg-1
X-Mimecast-MFC-AGG-ID: Xe_szrQlNI26btKa-dsMcg
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-6eede4788fbso112002867b3.2
        for <linux-scsi@vger.kernel.org>; Wed, 04 Dec 2024 05:45:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733319930; x=1733924730;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gfzsMKSDpksu1Ik71I0LavlaD/4ezjHXC0zfA3/Wep4=;
        b=VCJ8oMTTshf/kysL2D7UGvTWF3QQqgzRx3XKa8MLytJEeWYrabuU4PTbhSObzEAnHw
         hqluLE5da0+AeJfmLkplKyTPuddkK673J/GFCoy3cEraFcGnHd1oLXb16TZpW8Dqsfve
         /DUcz24zGQN/QApwL+lnjitGiMDKW7GnTc2fOI+smtQr+RFN6JkvkmAFsYrBKTin+ECO
         RbUFFMyiX2UXuWSMBLHlMWuQFWiJf35KlGMY9PDkOpMZMKe8agq1mCMVMTVfOMP3sTwM
         MvZFgBZ++WGLCGsluHbixD2XlrmPQnM/YiUm4iibdRUogGaFt5OvUxFI8g2dodwshjxU
         M9rg==
X-Forwarded-Encrypted: i=1; AJvYcCUnwy3whbDe3LZWa8SGcRT+rkDxcP1nxtytE5o5NUgm94Sh+BT0ywUa54MtbPhwP6iXT3MWCfwHoTww@vger.kernel.org
X-Gm-Message-State: AOJu0YyRrD3zlPtKmd1wN+gOzzmZYG40KQxP6L826NP1wZZg5763q7j2
	vSzSQISZhRxuyhg31jq9tqNpU+yQmWR41p2JFvXBg4a16qUEJZXjXsTHtTfKc2nkl8R1XyHTc10
	5h1Jphoj6YdRfOv5jIhfJ7IdabTpBAX2UVflv9QD68sLjH+2qMP8IZkYtnSYGMcgmaJR6gHVaUi
	ZX15H7a95fo4jYwScYKZH3womzqtlY4TE16A==
X-Gm-Gg: ASbGncvvR2MljG3bhf7XmfU4j5aqNWFn00hsCKrCd4smJpg8uWNGcV0uvPuzbQZkMoZ
	g7j6a0eEG10eU2YWmwg4EzBIueqSWIag=
X-Received: by 2002:a05:690c:4a10:b0:6ef:61b9:e003 with SMTP id 00721157ae682-6efad2f6fd7mr88309247b3.36.1733319930679;
        Wed, 04 Dec 2024 05:45:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEJh0JveXBGAfwCZPJXi92+8eFnpI5egIrMgPNGfFHIU7y+Wx98MO5YLZnKgkY4y96eHhMCpU6SnKNxWYBd6Nw=
X-Received: by 2002:a05:690c:4a10:b0:6ef:61b9:e003 with SMTP id
 00721157ae682-6efad2f6fd7mr88309027b3.36.1733319930450; Wed, 04 Dec 2024
 05:45:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241127181324.3318443-1-cavery@redhat.com>
In-Reply-To: <20241127181324.3318443-1-cavery@redhat.com>
From: Ewan Milne <emilne@redhat.com>
Date: Wed, 4 Dec 2024 08:45:19 -0500
Message-ID: <CAGtn9rncdvYQUGYVZwePccEGOnAc0FU1s5GJ6S3PSgpc-1OfPA@mail.gmail.com>
Subject: Re: [PATCH v2] scsi: storvsc: Do not flag MAINTENANCE_IN return of
 SRB_STATUS_DATA_OVERRUN as an error
To: Cathy Avery <cavery@redhat.com>
Cc: kys@microsoft.com, martin.petersen@oracle.com, wei.liu@kernel.org, 
	haiyangz@microsoft.com, decui@microsoft.com, jejb@linux.ibm.com, 
	mhklinux@outlook.com, linux-hyperv@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, bhull@redhat.com, 
	loberman@redhat.com, vkuznets@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 27, 2024 at 1:13=E2=80=AFPM Cathy Avery <cavery@redhat.com> wro=
te:
>
> This patch partially reverts
>
>         commit 812fe6420a6e789db68f18cdb25c5c89f4561334
>         Author: Michael Kelley <mikelley@microsoft.com>
>         Date:   Fri Aug 25 10:21:24 2023 -0700
>
>         scsi: storvsc: Handle additional SRB status values
>
> HyperV does not support MAINTENANCE_IN resulting in FC passthrough
> returning the SRB_STATUS_DATA_OVERRUN value. Now that SRB_STATUS_DATA_OVE=
RRUN
> is treated as an error multipath ALUA paths go into a faulty state as mul=
tipath
> ALUA submits RTPG commands via MAINTENANCE_IN.
>
> [    3.215560] hv_storvsc 1d69d403-9692-4460-89f9-a8cbcc0f94f3:
> tag#230 cmd 0xa3 status: scsi 0x0 srb 0x12 hv 0xc0000001
> [    3.215572] scsi 1:0:0:32: alua: rtpg failed, result 458752
>
> MAINTENANCE_IN now returns success to avoid the error path as
> is currently done with INQUIRY and MODE_SENSE.
>
> Suggested-by: Michael Kelley <mhklinux@outlook.com>
> Signed-off-by: Cathy Avery <cavery@redhat.com>
> ---
> Changes since v1:
> - Handle error and logging by returning success as previously
>   done with INQUIRY and MODE_SENSE [Michael Kelley].
> ---
>  drivers/scsi/storvsc_drv.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 7ceb982040a5..d0b55c1fa908 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -149,6 +149,8 @@ struct hv_fc_wwn_packet {
>  */
>  static int vmstor_proto_version;
>
> +static bool hv_dev_is_fc(struct hv_device *hv_dev);
> +
>  #define STORVSC_LOGGING_NONE   0
>  #define STORVSC_LOGGING_ERROR  1
>  #define STORVSC_LOGGING_WARN   2
> @@ -1138,6 +1140,7 @@ static void storvsc_on_io_completion(struct storvsc=
_device *stor_device,
>          * not correctly handle:
>          * INQUIRY command with page code parameter set to 0x80
>          * MODE_SENSE command with cmd[2] =3D=3D 0x1c
> +        * MAINTENANCE_IN is not supported by HyperV FC passthrough
>          *
>          * Setup srb and scsi status so this won't be fatal.
>          * We do this so we can distinguish truly fatal failues
> @@ -1145,7 +1148,9 @@ static void storvsc_on_io_completion(struct storvsc=
_device *stor_device,
>          */
>
>         if ((stor_pkt->vm_srb.cdb[0] =3D=3D INQUIRY) ||
> -          (stor_pkt->vm_srb.cdb[0] =3D=3D MODE_SENSE)) {
> +          (stor_pkt->vm_srb.cdb[0] =3D=3D MODE_SENSE) ||
> +          (stor_pkt->vm_srb.cdb[0] =3D=3D MAINTENANCE_IN &&
> +          hv_dev_is_fc(device))) {
>                 vstor_packet->vm_srb.scsi_status =3D 0;
>                 vstor_packet->vm_srb.srb_status =3D SRB_STATUS_SUCCESS;
>         }
> --
> 2.42.0
>

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

