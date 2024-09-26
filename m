Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D61E17BEB8
	for <linux-scsi@vger.kernel.org>; Thu, 26 Sep 2024 21:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727384806; cv=none; b=ntq+n+fg/3OGpfHGTtWlxDeVj/IneoOQYGS/oY595uigxUPWKStvV17HPeUdofQ5QSPoUwVDJez501JKLJ2or5yGRFB2DkCH2TqoML3KaGissigQmLTkY1HT6BjfOEJcFcJeo7tcM3rv5KbNsdgIraYgkME4XwVOPWMlz/YPkKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727384806; c=relaxed/simple;
	bh=ch5+iBGaw/2ffLgiPCfp4ozJUMzC3FKP8c2t5iqB/DE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KJkQc45X/JhpqYYQRAfF1oXrihz21kNqNFYK/S6NKrD7Qeu1jSZChgN67DqimfWg28D9FeWLu6g3f69w8Rxxw6DGFBXLRWBW6rULHz/JXcprGysBpyYD9qzEYzolkeL7M6d8qWKpvDHoGD/7J5+ygHNMGTFQY6fgiRTQw6lLsbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OTo+YcbS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OTo+YcbS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727384804;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ch5+iBGaw/2ffLgiPCfp4ozJUMzC3FKP8c2t5iqB/DE=;
	b=OTo+YcbSgfBYL/l/ex57WeQXEbfyYB7xtd8u5gM4yXZunu7LfsyW7aDAKlpjS5H5eyRgA8
	9HQ5DGg7INxQ2tl55r/HckVGXfijIJ78gdqgptGLBT6Exrg8G2aslOvflCN26BHzfag1nU
	B8Tjw8vhCMFrdcLvElXZU7a1iIM4zjc=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-66-gS4RTB7PM6KHBF8CVx0fww-1; Thu, 26 Sep 2024 17:06:42 -0400
X-MC-Unique: gS4RTB7PM6KHBF8CVx0fww-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-6d7124939beso28333357b3.2
        for <linux-scsi@vger.kernel.org>; Thu, 26 Sep 2024 14:06:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727384801; x=1727989601;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ch5+iBGaw/2ffLgiPCfp4ozJUMzC3FKP8c2t5iqB/DE=;
        b=Y/BoQWhGfpsHd0pAsOluMlgS9UxObDrufWvEizDVZ35O4zvjHdTCHgybQPzWHENfgc
         z6E2npWlQ3Lah2d9MzyD2RDHA6qrkDzk/PwqJtbJGEF+VTKidWFxYAYvt8oVciwGJ8rn
         EYyXIvUiFZWFYUTramA2zy0vfSE2IZwlGvb7jP9zRdMi/K90d1vrMoEGmtn9757k7RhX
         GeNS/utjm3nOM/YemZDU/dO+166kkjzf8q8ao6YFotZ0WKSfBlguX4LPoCZq2dZ5+aaL
         TYVmcGeZWDvZjKQ2VaYvKPtF76a9G9RhRMyvxaCqHYHhKVdXkwhvd8EpIk0BjBNvM/+o
         FOzQ==
X-Forwarded-Encrypted: i=1; AJvYcCWQVXJISyAS0utyTpTUjiG3wIDTBJJzmoO9+FIuM0dC2NVl0PoP/Cx0R9jIOP5a7iDTUhgc8jMN4NOx@vger.kernel.org
X-Gm-Message-State: AOJu0YyVV/OfjmJSdvXlA4bTG6/RzsHR9CT2C3a19V9h7SM2gKnRDFq4
	nUW+balP3Z95/9FJ0noWQEhIVnKJze9zQLG1TdospoUXcqtm+GxQvMEKu4/VnKCeokPF1KXStxC
	5OwQy416/UjmHVvC9wRbYs15uoux4xxSIZme+RBJ62njVZmItVf7POegvTSpSDFDoajDT1s/oXr
	uwEZLaoa93CdnJXvE4VB0+M/4UBizUrzI5yQ==
X-Received: by 2002:a05:690c:2d8a:b0:6db:c6ea:6eb9 with SMTP id 00721157ae682-6e2475fcc2amr6445917b3.45.1727384801481;
        Thu, 26 Sep 2024 14:06:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEXplM1kcQqDkPBtGHK6kaeMWQCymbbiWMPbCdOFn9PddwqIGjoib+GUHGaioBCTruVph7g4gdiW07FEWXvFvQ=
X-Received: by 2002:a05:690c:2d8a:b0:6db:c6ea:6eb9 with SMTP id
 00721157ae682-6e2475fcc2amr6445817b3.45.1727384801229; Thu, 26 Sep 2024
 14:06:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240917230643.966768-1-bmarzins@redhat.com>
In-Reply-To: <20240917230643.966768-1-bmarzins@redhat.com>
From: Ewan Milne <emilne@redhat.com>
Date: Thu, 26 Sep 2024 17:06:30 -0400
Message-ID: <CAGtn9rm0bXF0JJMhgypwK46DzWSR=w9QWx1mECsgE_yOH+vxPQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: scsi_transport_fc: allow setting rport state to
 current state
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, 
	Muneendra Kumar <muneendra.kumar@broadcom.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, Hannes Reinecke <hare@suse.de>, 
	linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 17, 2024 at 7:07=E2=80=AFPM Benjamin Marzinski <bmarzins@redhat=
.com> wrote:
>
> The only input fc_rport_set_marginal_state() currently accepts is
> "Marginal" when port_state is "Online", and "Online" when the port_state
> is "Marginal". It should also allow setting port_state to its current
> state, either "Marginal or "Online".
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---

Both scsi_host_set_state() and scsi_device_set_state() work this way,
so this seems quite reasonable.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

