Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4802E1739
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jun 2025 16:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750781599; cv=none; b=VjfUcFCHsSgM60hgXW8r94NV9rfbxNxvV1934ziS1dvyQSl6G3ovVFeACR0yyGgvQZuJamUlHB/kwrXh88uHcPLl4RUecAJnRCitQ3hvYGzHvjJzQ1w5giWheoWINaA0HiNBQR/eM/jVxtAKYoC62zys019M6fkwndhK1gICJx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750781599; c=relaxed/simple;
	bh=tYG5jTcIc6lkYrhz7J10TtWJVbsSBH0IkVNYKqBZoK8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AaUAseYQJSMCSrXQqky1FBIhctrm0zf2UthFDxvBu57HIsVvgn2Z3BieIbY74uyQOxNXxaJOhK30vdjjYD/Fzzv8ZxIq/8t8lNOZxoditgGkGb26CocuQXZUHd/u8OJ+crkGbUKUEhHhk+V+d60C4pi6Uibx+kNrEgBCQOV8aGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TvBKYg0d; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TvBKYg0d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750781595;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x5R79lIc79qw+LwnY8ZeG/QCJ7Vln6rRrb23eTtbbts=;
	b=TvBKYg0dHKQH6RXZYwKQWvDns1jm04lRZElZy36Wfvh0TE1HzvDpjUg5uuM+YK2ZPn+1Jl
	EYlGd65jwz5YrH4nS3SBC2lDgtGx1Jg89xKrDeGERJxzMe/smzgo78LWF/1ZxQeukaI9/R
	Tm3qpTxWtoOgwsVVug+hBDOvcQKnJwQ=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-141-Kmsb53x3P-irLUtwT_NJSQ-1; Tue, 24 Jun 2025 12:13:14 -0400
X-MC-Unique: Kmsb53x3P-irLUtwT_NJSQ-1
X-Mimecast-MFC-AGG-ID: Kmsb53x3P-irLUtwT_NJSQ_1750781594
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4a43ae0dcf7so11631351cf.1
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jun 2025 09:13:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750781593; x=1751386393;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x5R79lIc79qw+LwnY8ZeG/QCJ7Vln6rRrb23eTtbbts=;
        b=bH9Kd+diVew8fAKAV4czPmqWLk1yLHhyaZzSpIzAq5Jz6fVRY2iANqJAyDkjSuokQh
         QU6/ZMb0CEYsj5Y4EtSN4vc0LopZpMPxTl50MupEaMe0MyqmJSnQfF7UBGImAZK/cC+y
         aRa+/1hWy/XyvtyQrKFRWdpA7FpqoOq9UotEPVziR8qsHKpDvfpoXOa0JDt7fQJZFWSq
         gwCCS+XFRHAEIwF23wRaI30n9FGBeze0f3fn7lgCH1nSLkEF9jS5PPqjtk7otqV8qRHh
         7VIwgn/JM6fN9ZzCNIgmA1zD8RWCxVWkC2vTgwhQagecbRz2l2i2MkYF3ApSQxkj9xdF
         e4vQ==
X-Forwarded-Encrypted: i=1; AJvYcCWwZeUP2arE44f1f+jIjNgOANONlTHrnDhWfvXaNSdVYNqQg5kih3LmOvgV/n0oDRrhxuddulcZeevg@vger.kernel.org
X-Gm-Message-State: AOJu0YxTQdHG+rHdBcm084fn8nF0rj6qPhjSOXfevkn7WeEoWf4cIkTx
	wI9qjh1xy9kKIUxBgAQXuiBZMCygFllPgMGYVfX3cB3i0C7ZZ8iCNJInr1lWYnPphztWsJVboQq
	Kax9fIb1tELySpZRid/WYsAKlA//HgqhwaMQjjE3hFt/yAyEmvuHFIow8EFuACPE=
X-Gm-Gg: ASbGncvRFe2KrIXlrnTcqlKpjv/0KikMQ1Ch+mrJcpa66MaXHSNrtIwCg6G4+ZFPQGF
	orQ5/O69wcLUY0OhOzHwal9qSyIFtNpe6tMJ4JBMGT4LY0+XYUT9bifmlGqFbzngtm+k4KbY85O
	trd5elDkDKv5G8S2omjlstEN1R+CuqrjWj87ux4mumFoVfdOJVIVFjq81XVMhEQ6Ha6cljG1Yyh
	uzAcUw8lSoKNcjqgQT3aYHnbmFnx2mjcv7/5KS2/Ll4Y8YPe2zG4yW/BCfvs7kF85Ki1bFdcVGk
	59VXc6urRKCI3RIDfOiAJ/3ANQtvQ4fDDACMKLubKKH5UOgNxzP/dg2ZmflAIzU+hKeZlRSi5V0
	RFQ2sBwk31Un8AuKO
X-Received: by 2002:a05:6214:20e9:b0:6fb:f10:60e with SMTP id 6a1803df08f44-6fd5e0c0c8bmr3725246d6.40.1750781593506;
        Tue, 24 Jun 2025 09:13:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGCm31O5u32zNkqCRW8pO6mkfdRgGmr0pw1SUCu9UJ/KjZ0LHdt89nkuXO+YjDtpESggATGMg==
X-Received: by 2002:a05:6214:20e9:b0:6fb:f10:60e with SMTP id 6a1803df08f44-6fd5e0c0c8bmr3724586d6.40.1750781592875;
        Tue, 24 Jun 2025 09:13:12 -0700 (PDT)
Received: from syn-2600-6c64-4e7f-603b-9b92-b2ac-3267-27e9.biz6.spectrum.com ([2600:6c64:4e7f:603b:9b92:b2ac:3267:27e9])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fd0945183dsm58565886d6.44.2025.06.24.09.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 09:13:12 -0700 (PDT)
Message-ID: <017f14924a49b76148fb4cfd9c6107d423e6cb2c.camel@redhat.com>
Subject: Re: fix virt_boundary_mask handling in SCSI
From: Laurence Oberman <loberman@redhat.com>
To: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen"
	 <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Ming Lei <ming.lei@redhat.com>, 
	"K. Y. Srinivasan"
	 <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu
	 <wei.liu@kernel.org>, "Ewan D. Milne" <emilne@redhat.com>, 
	linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-block@vger.kernel.org
Date: Tue, 24 Jun 2025 12:13:11 -0400
In-Reply-To: <487a4646387595383bf8ae24584c5b54ec6aa179.camel@redhat.com>
References: <20250623080326.48714-1-hch@lst.de>
	 <a665dead67bf4f3432cf1bddf29d2c573ab71673.camel@redhat.com>
	 <487a4646387595383bf8ae24584c5b54ec6aa179.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-11.el9) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 2025-06-24 at 12:11 -0400, Laurence Oberman wrote:
> On Tue, 2025-06-24 at 10:21 -0400, Laurence Oberman wrote:
> > On Mon, 2025-06-23 at 10:02 +0200, Christoph Hellwig wrote:
> > > Hi all,
> > > 
> > > this series fixes a corruption when drivers using
> > > virt_boundary_mask
> > > set
> > > a limited max_segment_size by accident, which Red Hat reported as
> > > causing
> > > data corruption with storvsc.  I did audit the tree and also
> > > found
> > > that
> > > this can affect SRP and iSER as well.
> > > 
> > > Note that I've dropped the Tested-by from Laurence because the
> > > patch
> > > changed very slightly from the last version.
> > > 
> > > Diffstat:
> > >  infiniband/ulp/srp/ib_srp.c |    5 +++--
> > >  scsi/hosts.c                |   20 +++++++++++++-------
> > >  2 files changed, 16 insertions(+), 9 deletions(-)
> > > 
> > Grabbing latest and will test tomorrow and reply
> > 
> For the series looks good.
> Same testing shows no corruptions on storvsc for the REDO so passed.
> For SRP initiators generic testing done with fio and passed, unable
> to
> test SRP LUNS with Oracle REDO at this time.
> 
> Here it is, enough reviewers already so just the testing
> Patches were applied to a 9.6 kernel because I needed such a kernel
> for
> Oracle compatiility.
> 
> tested-by: Laurence Oberman <oberman@redhat.com>
> 
> 
> 
Nit, fix my email, dropped an l should be loberman@redhat.  com of
course

