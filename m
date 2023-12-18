Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6462C101DB
	for <linux-scsi@vger.kernel.org>; Mon, 18 Dec 2023 14:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XXHRQPHz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702910483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FM/rOjSoBQXvaGR5kOAQHBZhXTmgI+di7aDdBeNVtbc=;
	b=XXHRQPHzj83MoGhoFcI5cwi39pNPNu1MW5w2vvEcF8PaZbeZBfuYAeIvRbZEpqwZ+Ljt0c
	Z0ezGqx6wEAq2h1DdqPWwxQwCf7yfiwNtLOsZQrmQu1b/OLtHFYYOvZulO9WKEeifT+4dd
	r9SRnWcbNCYmquMMdVRGTde6wnziZyg=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-UmVIP2RgN9qM7CR0lSsBcg-1; Mon, 18 Dec 2023 09:41:21 -0500
X-MC-Unique: UmVIP2RgN9qM7CR0lSsBcg-1
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-6da4fbb91acso523542a34.1
        for <linux-scsi@vger.kernel.org>; Mon, 18 Dec 2023 06:41:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702910480; x=1703515280;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FM/rOjSoBQXvaGR5kOAQHBZhXTmgI+di7aDdBeNVtbc=;
        b=YvzsochmXgecJ+e8LdDiaF35bU+vgRiIyXoyk/lLgPbDZqnrO6DNa5EJu2PE4y/My/
         pYsySTYK6Ta7R5LP8sY09wBE31U8Xhx4Yc5Pk+Gzh+l2oNvDjC0EbrnI9cjr3XF5WqiT
         xha4UGHHX1kiYM5mldVhlmThD74ZxW4CDZaMLiIeY5SVEQOAszRyfQ08GHdWTnf5UJmZ
         Kg2FZS7TmDFRAqsJUs3+xjclPxkOLVRt4sLGCZ+nnYYcpLwwMbDUPZEACN7k+K/NTXRM
         kUMw53CX8Zr2OUrrDX6Rd1fHZGcGx+5HCxS4lST+zo7M718jsvoBjjkiQtFL/tYayb9j
         zokA==
X-Gm-Message-State: AOJu0Yxnth7eOk85nK+BNoL0D5K/70vsGXt7OoQ+bxZZgK8pSDBEn9Qa
	25ZNru1VlNzhaggmI7L47tg1bs63c4uDxjDBPrisu/ZOeU1337dngPUKWHhII5osMERPq+s8wq8
	VcBw8HeabOsR43x9kSdeAK/T28OvpWcGD4KCO4w==
X-Received: by 2002:a05:6830:43a5:b0:6d9:d4d0:4927 with SMTP id s37-20020a05683043a500b006d9d4d04927mr31607504otv.1.1702910480720;
        Mon, 18 Dec 2023 06:41:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHuZO6ohAOjpUpKXxhOi0nXALIR8OosUBFd5MFseInS+5HlyZZVrhOElPO3kQh+gk1aSUrIQ48ogXFk+YTf/PY=
X-Received: by 2002:a05:6830:43a5:b0:6d9:d4d0:4927 with SMTP id
 s37-20020a05683043a500b006d9d4d04927mr31607481otv.1.1702910480442; Mon, 18
 Dec 2023 06:41:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231215121008.2881653-1-alexander.atanasov@virtuozzo.com>
In-Reply-To: <20231215121008.2881653-1-alexander.atanasov@virtuozzo.com>
From: Ming Lei <ming.lei@redhat.com>
Date: Mon, 18 Dec 2023 22:41:08 +0800
Message-ID: <CAFj5m9+KV-96tJ_7LScuSftB4SSjxD1PK_M-QBzkxzG6vXeX+A@mail.gmail.com>
Subject: Re: [PATCH v2 RESEND] scsi: code: always send batch on reset or error
 handling command
To: Alexander Atanasov <alexander.atanasov@virtuozzo.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Bart Van Assche <bvanassche@acm.org>, 
	Hannes Reinecke <hare@suse.com>, kernel@openvz.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 15, 2023 at 8:10=E2=80=AFPM Alexander Atanasov
<alexander.atanasov@virtuozzo.com> wrote:
>
> In commit 8930a6c20791 ("scsi: core: add support for request batching")
> blk-mq last flags was mapped to SCMD_LAST and used as an indicator to
> send the batch for the drivers that implement it but the error handling
> code was not updated.
>
> scsi_send_eh_cmnd(...) is used to send error handling commands and
> request sense. The problem is that request sense comes as a single
> command that gets into the batch queue and times out.  As result
> device goes offline after several failed resets. This was observed
> on virtio_scsi device resize operation.
>
> [  496.316946] sd 0:0:4:0: [sdd] tag#117 scsi_eh_0: requesting sense
> [  506.786356] sd 0:0:4:0: [sdd] tag#117 scsi_send_eh_cmnd timeleft: 0
> [  506.787981] sd 0:0:4:0: [sdd] tag#117 abort
>
> To fix this always set SCMD_LAST flag in scsi_send_eh_cmnd and
> scsi_reset_ioctl(...).
>
> Fixes: 8930a6c20791 ("scsi: core: add support for request batching")
> Signed-off-by: Alexander Atanasov <alexander.atanasov@virtuozzo.com>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

