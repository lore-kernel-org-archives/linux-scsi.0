Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3ED2E1751
	for <linux-scsi@vger.kernel.org>; Thu, 11 Sep 2025 08:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757579575; cv=none; b=SMEUK6F1V78JlGVV/jGt78r8BOM9wtAAsmyTt6C1bS8/Ygk6pcTwb5M6NBT8Tr3mwNehofgW49koxqDrZ3kH2nbJTdsNPMHt+ULBUDd0KXp151URyNQQQl014+dlfg6DstQKFfp/LUmY8gXJ3/QX3zZEL5MlJt33hdM0fUFlPZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757579575; c=relaxed/simple;
	bh=7DXzBkYfqzdjQm+DmIuYQj51CR1NgQMJr3Gl5XBSCjk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XezoW95jgnXLVlKdF4h11HAtvy0CeVj6lplQYhbe9rKjOfQOq5+/zrWjwnOL67czrWdl4WnngB0tEOCLUWDbnWusI2J5/a+rrgtnHGi0GJTRq46QFK5/GcZUh8tUbdaCBwCQvn+ibndMkkc8/d/EH5xioedjTdl73+pMb15g3hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A7Ra5SiZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A7Ra5SiZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757579572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QU0ePF4d16jInmmLBuNmFr5MEDXTsnd2GYHiQ58mMXs=;
	b=A7Ra5SiZskTQSvLPmpXc3VUFdX/75+DD+hJjWtTeZdOYM4nQfk0ZycNWVTXAg0hYqboHu7
	TycdNL6drBE0SKp+O0B+WUmGC7Sc0OI3o/z9Ll1h9jwGEkWVMHW/JLvedtGVtZnJZGM074
	bl0khHeTHvHgJv8/+fNKYaDpaDjYti0=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-597-Dj4yFEIjOE-OyjuiFBdRcQ-1; Thu, 11 Sep 2025 04:32:50 -0400
X-MC-Unique: Dj4yFEIjOE-OyjuiFBdRcQ-1
X-Mimecast-MFC-AGG-ID: Dj4yFEIjOE-OyjuiFBdRcQ_1757579570
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-52e090c943cso154289137.1
        for <linux-scsi@vger.kernel.org>; Thu, 11 Sep 2025 01:32:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757579570; x=1758184370;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QU0ePF4d16jInmmLBuNmFr5MEDXTsnd2GYHiQ58mMXs=;
        b=O77Tt+XbyxiMFue3dgGyQBVNOyskUloC31Cx9OM7enHj7/5HD6/bPP4+IP7sLnsTMl
         dUgwL2e3plMsqp0foIJ647KXh/AUmcbnV8tRUlK4it78kxq/5uJWqNo0bgG2L2T2Gbwk
         O8dHzd18BsgXAYN6RZFFWb093RqJEm7Y3l52Mg2G2+6wsrvvjgUpwnE8CB1qIbiGtRST
         tZOjhrDXWuX4KwaguZx6B7nN1jztGox5IqoEFhPmoc2l7E36AqGQaxzuXJyfehh2YcHC
         n2/NiDLoqaWj2PIKS/YSWbv5eGYIGpb/Sce7nKhe25mJS8EqZKmOdWz9e4X3caHx+osh
         m/zA==
X-Forwarded-Encrypted: i=1; AJvYcCVyFUAtJ+jYvK1/EBXZLWW9/DGYBo1fVR1Qn4werfZQvtqEvxfIeK0yMm3p2tkWn/xOw6wXRH8gSj1V@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7rcYaMylpQ8Pw14Dob0DVHVb0RWilx7JPlWA1fs3nXRnJLxBy
	xC0v10G5HBrRSC7XG5T/cDTn7uYhzuMJxgFRIBatOhT+1dsWinihDpaVLJNT31rhC1zvl1PPus4
	brAVgf8Usr8+C002dlmzI6llopHQX7gDgO2as+pIQWZ0gHrueY3HsaG+kU/9/DU1Dg81fhNfopG
	u0+OtagmJx2/V2numghbG6TXtvPjtolb6seu0VLQ==
X-Gm-Gg: ASbGnctdxY0gE/Q8Xi0lS5/aQRY6iCHcIu5PYmr550BEOZZ/YR518pAeq6PBg0iKFwC
	7OI0X+ju89Ba8le5pwYR9XuXuMdtLdlzOMjemiM18L7yRxAPo8UQjIPmhXKbbsVsIhZPsav877/
	yxwHJkUfq18MJbMs7I2fpMXg==
X-Received: by 2002:a05:6102:604f:b0:553:542d:d96b with SMTP id ada2fe7eead31-553542e23b1mr318280137.35.1757579570342;
        Thu, 11 Sep 2025 01:32:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF7RxGRvxB0KESnNm1fQzRvAttPjrog09VO04UKVzL9R9UVKLP144K7mjNmYBqT8Q10hQ4CoQvunkSenPeiG0w=
X-Received: by 2002:a05:6102:604f:b0:553:542d:d96b with SMTP id
 ada2fe7eead31-553542e23b1mr318265137.35.1757579569967; Thu, 11 Sep 2025
 01:32:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250910213254.1215318-1-bvanassche@acm.org> <20250910213254.1215318-2-bvanassche@acm.org>
In-Reply-To: <20250910213254.1215318-2-bvanassche@acm.org>
From: Ming Lei <ming.lei@redhat.com>
Date: Thu, 11 Sep 2025 16:32:38 +0800
X-Gm-Features: AS18NWAuamT7W0s4-N10dU_ImwG6VbrcGNE5yj2f8OBIwcY2MMcVKnBfjON6sR4
Message-ID: <CAFj5m9+8qyEjmRXJHHhZbD1cAKQReTxqahGr69PMKuy=9JMHLg@mail.gmail.com>
Subject: Re: [PATCH 1/3] block: Export blk_mq_all_tag_iter()
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@infradead.org>, John Garry <john.g.garry@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 11, 2025 at 5:33=E2=80=AFAM Bart Van Assche <bvanassche@acm.org=
> wrote:
>
> Prepare for using blk_mq_all_tag_iter() in the SCSI core.
>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  block/blk-mq-tag.c     | 1 +
>  block/blk-mq.h         | 2 --
>  include/linux/blk-mq.h | 2 ++
>  3 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
> index d880c50629d6..1d56ee8722c5 100644
> --- a/block/blk-mq-tag.c
> +++ b/block/blk-mq-tag.c
> @@ -419,6 +419,7 @@ void blk_mq_all_tag_iter(struct blk_mq_tags *tags, bu=
sy_tag_iter_fn *fn,
>  {
>         __blk_mq_all_tag_iter(tags, fn, priv, BT_TAG_ITER_STATIC_RQS);
>  }
> +EXPORT_SYMBOL(blk_mq_all_tag_iter);

IMO, it isn't correct to export an API for iterating over static
requests for drivers.

Thanks

