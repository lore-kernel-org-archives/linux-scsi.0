Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31517156C6D;
	Wed,  5 Jun 2024 20:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717617949; cv=none; b=ct2V9KVC3ctEoN602385De4tUNVzjEU4SPaWlqrF9nC18NIZRAIckL/J83GJHmaG9Hhkt6nBQSZ/MvjmrNbfypUkFOXTHrhaWiiHxllHYbKouwHusPvw5s35CeESvZYrhCBicAVtPIkgWTb/OdBQUyQoW+6mmDI5Vs29EkVz4dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717617949; c=relaxed/simple;
	bh=WIESEa30dZ/hQw4soSdWvR9FvT6kULeFPhCVwwSmx90=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NL4WKlciv/g1DtCSKCoIbd4p4fUySGrY0o11HHziMa4AoDDUVfjYVLV6JYxPKCL/liY6fTV4H+pTvPR2XgOVNVg/tk5iIZNLjaZ/oN/DCRagMfeELGGwFQRfXvcIhQ/5FkNIw7pGPgvFjjFQKgrWLHDN5Bnn32prgtnP7UD0YXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ib4C/EYZ; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ib4C/EYZ"
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-250bbae0ff6so89851fac.0;
        Wed, 05 Jun 2024 13:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717617947; x=1718222747; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q2sovYnnLqu3ePNoGdykaYCzoGX/KrvirZkk+6UfwMw=;
        b=Ib4C/EYZYlPAUrGxUSnApAlreoDKQr7Lt9y0VFlcUqpTKeO9S2bkczC8zfGHxT2iDz
         TNw1bNa1lveSpSnVMi4mpD86Ct1UGN6wEgoCTGZMmI08XHMmG/mWqaG6EpTOKLTUdd0X
         0lVY3kEey4AG5jysU4Xr36dymRNTNZih8GFX1jesufkGH1lVEPRWBh1MENgh4it1Yei/
         g7IyDREitdINhMWDzXZFAUYpGsUBWZAJ/pFsXQhw/pJ+Xl7obgRxI/v3h/MpTFjbvPxI
         RPQ5KCBInDQk1Fn1uloYwPOR9vQaz1AszKtjCGrUlo4g4kIyoJLe5GiRK2O5YnEgDzwo
         uwDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717617947; x=1718222747;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q2sovYnnLqu3ePNoGdykaYCzoGX/KrvirZkk+6UfwMw=;
        b=D8R+eiGyZrqgwVDGpIBuUe7jyTF/AuDbMSOpFTGbOELs7fn+e2NSb7XkjIE6Nbn0LN
         xgYdmi6E50P47jN+okbnr58xXmp3t9e9vxQulAM0cZxapDJQhm/qL8b+TTkm5DbEyjpE
         1EjyiHuEu43Ry+CYtPLjILznVnQbaY8WLJrIH6ODJFI5ubXCJNNueWMc5t82PgUBTRL3
         CqEMjJ4At67OTfKeXS4hrZHwLNkFNaOJ5I8MVxYO3yuLyrdm2Halo2X5WHKGsATo1ape
         a7wB8GKyueb3ZfxZjNeYDzamD6K+wB70j3glT6AMth4oSJ1oF4ZOJ5pWiSXdvJnUbtss
         ohVQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+Z69hKLq94264v2YjBPS9oQIPj+p1fkTK9ltryHr7EgDJvdB+xkNp4ggBnvSj4UpmGgZPcObBIoUmzs9cJtPgFWnvMOLItFJ3NpRRMr0R7fpfFyNvcxtaqmAQr8rz7ovTv98rBIu7A+iAC81I8lL2zJ25xOEFwmZ2eRT+awlSsyYiZw==
X-Gm-Message-State: AOJu0Ywjm7QRaw4d30kvndCBQ89CAE5SNGvV/AjsAzOPmraGB2jqbTm5
	0YqJEeM0sNlWPLZeG3R6fYpnKYFfU2D6qJn9v80rL+p5cz/ielKgrq/G8vlRGIHs8/0pUs03aQK
	Y4Cg4puH2sM/rzH2om0C52b/XQO8=
X-Google-Smtp-Source: AGHT+IGyVhO7rSQAoGDSB+vjloBrx705BG5D6fs1Cr4EcslfrxplrQUigFncTawwbH2U8MnF7SOq8ImGhCk8Gp1b7A4=
X-Received: by 2002:a05:6871:738f:b0:24c:4f83:48da with SMTP id
 586e51a60fabf-254407aeaf0mr366594fac.16.1717617947176; Wed, 05 Jun 2024
 13:05:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240605063031.3286655-1-hch@lst.de> <20240605063031.3286655-5-hch@lst.de>
In-Reply-To: <20240605063031.3286655-5-hch@lst.de>
From: Kanchan Joshi <joshiiitr@gmail.com>
Date: Wed, 5 Jun 2024 20:05:20 +0530
Message-ID: <CA+1E3rJn3uNfkoFtm_am9qwQmwWvhu3nPVMaM63AJ2GBdxZTmQ@mail.gmail.com>
Subject: Re: [PATCH 04/12] block: remove the blk_integrity_profile structure
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>, 
	Yu Kuai <yukuai3@huawei.com>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Keith Busch <kbusch@kernel.org>, 
	Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>, linux-block@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 5, 2024 at 12:01=E2=80=AFPM Christoph Hellwig <hch@lst.de> wrot=
e:
> @@ -446,13 +446,14 @@ bool bio_integrity_prep(struct bio *bio)
>         if (bio_integrity(bio))
>                 return true;
>
> +       if (!bi->csum_type)
> +               return true;

Changes look mostly good, but trigger a behavior change for non-PI
metadata format.

Earlier nop profile was registered for that case. And the block-layer
continued to attach an appropriately sized meta buffer to incoming IO, even
though it did not generate/verify. Hence, IOs don't fail.

Now also we show that the nop profile is set, but the above
"csum_type" check ensures that
meta buffer is not attached and REQ_INTEGRITY is not set in the bio.
NVMe will start failing IOs with BLK_STS_NOTSUPP now [*].

[*]
     if (!blk_integrity_rq(req)) {
             if (WARN_ON_ONCE(!nvme_ns_has_pi(ns->head)))
                     return BLK_STS_NOTSUPP;
             control |=3D NVME_RW_PRINFO_PRACT;
     }
