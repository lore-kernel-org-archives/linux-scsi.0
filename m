Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40BB1F9F73
	for <linux-scsi@vger.kernel.org>; Fri,  3 Oct 2025 14:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759502435; cv=none; b=NeZdWhOK8NKsuJT+7aNIjST2pxaV4qzPuII2WFZtBnSC+spNaZUNr50NAhBEHOeB7bJ3Efwe8cYOBGrDkJNfj5JtL1vgL8k2uk3889eBCmCmi7zRURaQDbbo96cSXLPVmx5HwJpFo7TyuRYX2KUOLzkkFDqUeum32YDdInvj8+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759502435; c=relaxed/simple;
	bh=ot/cpg+jxf94IYkHm8mFun5FNMuOJAsJSk6tWNS6iRs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MBpSnrKGdaW3nvWZZ1Yl3N+LL4Dg1+3ggpW9twcoIvWq9hBLr1CY1Ev+Fhx8ZRB+RP77T9g77sZsOScBf/bg1s6dMk7azvj5fpLMvvUWlh3ZpGKL432IO9hUgVjtG+dgNJyQyehz3cgj8dZvvDOPg/RfBFsgyXqkjO0ZXRkSCt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PdDxLAde; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PdDxLAde"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759502432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bFwqPgURC+wa1hFmqiL0z3QnRzWKgx5F9ZGjFyeZH4g=;
	b=PdDxLAdexg7dzW4gv10Rtk4QuYF/IyAvBag/ISFYLKjj/aKzd7bS6t1/4reGTBzZ1tGKpn
	g+YyREZ5FbGeAI2ho7cfjF2aOEEBY8oPtUgK+1F/Hl4hQRtOYhbrOyb+ZtlOxQTrIiFnrC
	wJ52ZcZyjjk1Ky1gZsjDNQZcmdlncDI=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-oDyX6a_qNTaaWQQSywuk6A-1; Fri, 03 Oct 2025 10:40:31 -0400
X-MC-Unique: oDyX6a_qNTaaWQQSywuk6A-1
X-Mimecast-MFC-AGG-ID: oDyX6a_qNTaaWQQSywuk6A_1759502431
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-6352a642093so2729125d50.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Oct 2025 07:40:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759502431; x=1760107231;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bFwqPgURC+wa1hFmqiL0z3QnRzWKgx5F9ZGjFyeZH4g=;
        b=En2BCUIjnWHAJfqs6fcKFxtLjc1kcAoVxplRFhhfhIVG84yBK5+Xr08fbX6LSrIQO/
         dbno0n8OhiWXJo63miOFoj8pdqAFuI5pcjZjSfzBeglQQ1mkU3gzqipt2z1jlFoU9/FP
         MhN3bh7YothWgcYKRNXtfaWhyuLPI+ZF86o7mwUfB0xnMP0LGJls+285bRNV/2k2FT/W
         mbFQNgghV0CbXHxqXEiMdHxmoOidlXnM0v7cU1m5YFYS+vVIHaFcgvgXJBy8p8OM8dQA
         nj1tnCNns+t7bQVu6S3Wn5EKuxTFOOzNdzxmg5uwU2VESV0XqZ9lZqtBIjL8BmT+ZWUv
         Wz3g==
X-Gm-Message-State: AOJu0YxZlZknZPgp5H48CfzY/6fHY1/xfHzuZg4PAzEpcogmgvXQ1VxN
	XlHkubwHvbVID9iB578yQBHXZpUZSF7EaMIBZYWNoL8UxSJKm1vHI06Ba4G9DcBXR5N0HbNHzxS
	+BVs1tnV4hlEawvkcNgk47R3vBJMX18qFKtycVdu9fA2DlNLQQokustSgi7sm63iuoSprp+2r1k
	jp4eilCsHWCpQssJF/84eWSXwmcxWYmGP+yPsNkQ==
X-Gm-Gg: ASbGncsdtF4i12pgzJOUEFMGiLVaqW5hxmdmTX29xqLxIpgdl5MtIzE3KUmFGao+2kr
	zm5jq0lZJ4kmWoHYDQgw2iXx7ACrLBXenYz9Id25ABNR36kfiZrHdLuF84L8EweYVETvQ3t4KjY
	seKz4ruXu684Bsi9R9UftawoZnZro=
X-Received: by 2002:a05:690e:2144:b0:636:1409:9b46 with SMTP id 956f58d0204a3-63b9a0c06fcmr2138515d50.27.1759502430770;
        Fri, 03 Oct 2025 07:40:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGV4qFQO5EcViyb5NoOl7DZW+shETavos+Fj/I/IkHArMw9FbNVs1qupt59ot7ii8OghA+mm5yN1n6pgaIyMrE=
X-Received: by 2002:a05:690e:2144:b0:636:1409:9b46 with SMTP id
 956f58d0204a3-63b9a0c06fcmr2138490d50.27.1759502430149; Fri, 03 Oct 2025
 07:40:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251002192510.1922731-1-emilne@redhat.com> <20251002192510.1922731-3-emilne@redhat.com>
 <8f250e77-5069-416d-9389-9c3e99535dbc@kernel.org>
In-Reply-To: <8f250e77-5069-416d-9389-9c3e99535dbc@kernel.org>
From: Ewan Milne <emilne@redhat.com>
Date: Fri, 3 Oct 2025 10:40:18 -0400
X-Gm-Features: AS18NWAd-bjf7Hl6knQ_-rgr05W9I6jqPhVqLLzR9GASV3kuuzo9vCaXB8VpLu0
Message-ID: <CAGtn9rkZX-C7DgaMCABsF66RVGomQeK1RyRW5knLPsPEzvajOA@mail.gmail.com>
Subject: Re: [PATCH v4 2/9] scsi: sd: Do not retry ASC 0x3a in
 read_capacity_10() with any ASCQ
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, michael.christie@oracle.com, 
	dgilbert@interlog.com, bvanassche@acm.org, hare@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 3, 2025 at 12:24=E2=80=AFAM Damien Le Moal <dlemoal@kernel.org>=
 wrote:
>
> On 10/3/25 04:25, Ewan D. Milne wrote:
> > This makes the handling in read_capacity_10() consistent with other
> > cases, e.g. sd_spinup_disk().  Omitting .ascq in scsi_failure did not
> > result in wildcard matching, it only handled ASCQ 0x00.  This patch
> > changes the retry behavior, we no longer retry 3 times on ASC 0x3a
> > if a nonzero ASCQ is ever returned.
> >
> > Signed-off-by: Ewan D. Milne <emilne@redhat.com>
>
> Doesn't this need a Fixes tag ?

I don't normally add a Fixes: tag for things like this, since I don't know
if any device actually returns a nonzero ASCQ.  (I think either you or
Bart asked for this change in an earlier patch series, which is fine.)

-Ewan

>
> Other than that, looks OK to me.
>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
>
> --
> Damien Le Moal
> Western Digital Research
>

