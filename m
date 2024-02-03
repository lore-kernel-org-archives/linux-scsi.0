Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C6A46BF
	for <linux-scsi@vger.kernel.org>; Sat,  3 Feb 2024 02:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706927522; cv=none; b=bXxy4oCBtkemhYOidr0U39HDR1TZrQDyOxV0MSVTi/f8gq3V0ghqe4DKp6/Lh0w3kuI7BCz7PYROChXKIQ6vf6onw3oyKN4xYhflfSBaynJ6W5FRPs2uxoKgcNNyRaasibmZuCSEcA+QQSdiHbEmlvGXYFQR99243b/fH6AkWBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706927522; c=relaxed/simple;
	bh=VE9m/GSqNVDE9EJgp4KIBFxMFmsdgXh+Ll5FYnOC1DA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nJZcGj45flO8PLbSqBBuBepwYhhaVUg55JRZ5S+maz5c2HGj7/x9ebTbowdgrH9VdhGNwNZ4GIb0a2Nc66iV7vTei+SSAEvDJJLu8XLavxpxY9hWArUP3MpKa72ypvZFBqIl8o+LK0EHMn9ZgSlxv3XwC0MkSPVfzPPdaosYLTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ebvZmUWj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ebvZmUWj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706927518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kuw8/+j1Nt//Q/MUwn3nOKvttb23IaQh1Moshh5sVn8=;
	b=ebvZmUWjiGDjMTfT4NIkr+QYDaFSbRJYvfGVzEX3+qeyrdkVxlSq4I8kvjyKEB1TA3oCAH
	k18m0anYTOpcsZO/hX54dUmQfMi1hbbpHFSI1fVoQLd6w3MkqPJx5gQgOuJuHBMHfdmb7k
	6+ic0n3CFRYT4Ov4v9L8MAO4PNcEJUw=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-km27BGLePqy2p1cj56-rgw-1; Fri, 02 Feb 2024 21:31:57 -0500
X-MC-Unique: km27BGLePqy2p1cj56-rgw-1
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-3be75cab163so855539b6e.0
        for <linux-scsi@vger.kernel.org>; Fri, 02 Feb 2024 18:31:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706927516; x=1707532316;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kuw8/+j1Nt//Q/MUwn3nOKvttb23IaQh1Moshh5sVn8=;
        b=b/gVYsSiZ95e+LyA7Ve8+MomHhdubWCsROSn1N/P6gDh2PkClQyrXrf/Fim6ph1fUi
         Y32wKVimLL2Q1BBMsbQEE7k3tH0aw89ltR9Ril+mGHURxGzewZfN/zLsCimLzZEGMzf8
         r/vQa6tjXFhKiWdfBLWoYo8TAZycSVjFNtm/rh11l+nGfty6hQL4ktu6Jn4yRNyNWUX9
         cuace/99wzJJJYmpu0daMoUHZYkPpThwQ/7wBdRoIb6meE+3twApcohVR48lKg/e64wP
         3TyX+XO/QNjAVNP/f3dE4r+TI99AVk2M0D1seMpm2nQSmUNzrhCERwaw7rknVc67AxmH
         tzww==
X-Gm-Message-State: AOJu0YxyScW5NG8toWQqE7NWbWXdt2QQm+ae9jmJi0fviQfGkA/ovldb
	ftyrR8WqXv3AnJHGzPnKj+I3sl/iqnO2glglckMeIRcbQXW1wIzS4PSjrVERxhOscAFQCB8Wigq
	0HHUe4a4bi+FDf4ub12VkeiUY3qxYhsZ5P9Uw8mr27PORlmSwqajE3MeV3wxSQ6yDoV8YMwS1T6
	Nn1wKL/pAh0h2a21NnSqGFVIrdYo+jvoVI0Q==
X-Received: by 2002:a05:6358:9044:b0:176:6149:5558 with SMTP id f4-20020a056358904400b0017661495558mr7448335rwf.1.1706927516048;
        Fri, 02 Feb 2024 18:31:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEJZlvcP7Lt4lVDnJO8/qZjc78xmRXQsK7zh51+WZFER4OprXxdEbm5gCazZf3FtQ4o32Qxlpzcv7RD04JlY9c=
X-Received: by 2002:a05:6358:9044:b0:176:6149:5558 with SMTP id
 f4-20020a056358904400b0017661495558mr7448332rwf.1.1706927515747; Fri, 02 Feb
 2024 18:31:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240112070000.4161982-1-ming.lei@redhat.com> <170606516775.594851.16997861687403168509.b4-ty@oracle.com>
In-Reply-To: <170606516775.594851.16997861687403168509.b4-ty@oracle.com>
From: Ming Lei <ming.lei@redhat.com>
Date: Sat, 3 Feb 2024 10:31:45 +0800
Message-ID: <CAFj5m9+X+EmiRELD8NJ41D4FYKPEonNjOoowNKb-fJEMeFzjFQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: core: move scsi_host_busy() out of host lock for
 waking up EH handler
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 24, 2024 at 11:01=E2=80=AFAM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> On Fri, 12 Jan 2024 15:00:00 +0800, Ming Lei wrote:
>
> > Inside scsi_eh_wakeup(), scsi_host_busy() is called & checked with host=
 lock
> > every time for deciding if error handler kthread needs to be waken up.
> >
> > This way can be too heavy in case of recovery, such as:
> >
> > - N hardware queues
> > - queue depth is M for each hardware queue
> > - each scsi_host_busy() iterates over (N * M) tag/requests
> >
> > [...]
>
> Applied to 6.8/scsi-fixes, thanks!
>
> [1/1] scsi: core: move scsi_host_busy() out of host lock for waking up EH=
 handler
>       https://git.kernel.org/mkp/scsi/c/4373534a9850

Hi Martin,

When I started to backport this commit, I found it was merged as wrong,
the point is that scsi_host_busy() needs to be moved out of host lock.

I will send one new patch to fix it.

Thanks,
Ming

