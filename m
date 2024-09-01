Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE40748A
	for <linux-scsi@vger.kernel.org>; Sun,  1 Sep 2024 13:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725197826; cv=none; b=mXfkOu7mn5FrEX1y6HDgkuvLiHUuUnhglHJWe1YcAC9RknWQBMAckrDBtqoN/VJ5ojKHJZyEJpqxEm0/kBHj4zUVrxR/JLw8KA7MpHn0BtH1uoZx9JUydNVkJ0m0160LPF+PSnzAmLnp6FNnjQUWgjksWzgzf6IepV/8Q0BY/e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725197826; c=relaxed/simple;
	bh=avtj2fGrA4i+1UZ34kxMsAWqmYzOBuKkn9XB/hMqOG8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AZeB9TEfJvyEW9dH9NJ2X6wZEdFmMmDrcLPresFSJuCmBgU2DxpzHQ6DTafl9bqT6I6rvR+AluQD3/ZUjg/MA1xUZRoxt+qhg8Mfykr3fKUlTE+O46nMSwPMkAmysHXo1anVE5JSVr0xIbSjRi+mYcVwF9RpO11FhmeahG1uGkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bUj94/tP; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bUj94/tP"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5bf006f37daso5304572a12.1
        for <linux-scsi@vger.kernel.org>; Sun, 01 Sep 2024 06:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725197823; x=1725802623; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=avtj2fGrA4i+1UZ34kxMsAWqmYzOBuKkn9XB/hMqOG8=;
        b=bUj94/tPjdC6m1J4DlCiU74rLbBHemPusXykVduKnL2FAysDQ6QtvWRCxZzS/jlpVP
         kbo88HADXtuXgYfZiEjvkiccnjF5Jin0ysQ8P1eIKKoTrdv/Toyd8qJxtUDkYzDElYjK
         hojahWtnCOVMMdKql24TGZTaQulggUd37ll54mpobC7+V7GFNSDo+A3WkEYDLLG3iM56
         d7Jnq25Y/XQP8oG8QJHfO4si6Jlrbc8IwJtu8i6tYAkFGBXqjT27vVG8mQf5PqGBuuSX
         9DjMi5ok9YOYg/Kfj118TuhG4d3pnXMtWoaFif+J8upRQ3sYnvQlRisZJiwqdA51Due4
         F+Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725197823; x=1725802623;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=avtj2fGrA4i+1UZ34kxMsAWqmYzOBuKkn9XB/hMqOG8=;
        b=Ut3BOcTItICbuKmjvyv6ur+rDSw/UxbOqPhbpskI87F2el4M+O48FWwalkGVNzXU3p
         tJlBIglGzWJm+0gcT0QicH5kGssCqeV/DYz9mWaCedsmH7oo3nSP/6KvfueiLzYi6Nol
         +HkbBMvE7ciBEemP+1TP+eocJl44F3LFiCThmtB/wDtSD/sy9MCFuQaJcEvqibVwhIGu
         8lZ7h+lStmyFKan6RyMkFctd1VlP/jbzUFhjZQUb+f7oFIDUK41x6BJ4HiChaLxMRUVh
         b+06jyi2acswzrQcE0QKFJdBH+yXOkWSgY0lR5m/4WomDYm1A8Tx1yPOZnX7L8h2QbSd
         tyfw==
X-Gm-Message-State: AOJu0Yxowaajk//cnjYKIdiIBdLJj2rbRdyEtTx6VLc83Tgl6+AEkLIV
	lXxsczDlOzefyKxjhe+DBFPV20EDmcd0W3vPVRJpCyPCH22uECvs
X-Google-Smtp-Source: AGHT+IEfzQr94Vni2E1yxsYjDKolOieBOkEtUct/o8ZKVBeMOarlpuuUyR9g89ROf/pdZU7Fq1G+SQ==
X-Received: by 2002:a05:6402:5110:b0:5c2:467a:185d with SMTP id 4fb4d7f45d1cf-5c2467a1d6bmr4067904a12.0.1725197822088;
        Sun, 01 Sep 2024 06:37:02 -0700 (PDT)
Received: from p200300c587387573a65f3c64b00236b3.dip0.t-ipconnect.de (p200300c587387573a65f3c64b00236b3.dip0.t-ipconnect.de. [2003:c5:8738:7573:a65f:3c64:b002:36b3])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c226c74184sm4301093a12.32.2024.09.01.06.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Sep 2024 06:37:01 -0700 (PDT)
Message-ID: <071d970ec412f311ba1b1a2c0ffdad040ee503b7.camel@gmail.com>
Subject: Re: [PATCH v3 4/9] ufs: core: Call ufshcd_add_scsi_host() later
From: Bean Huo <huobean@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	 <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Manivannan Sadhasivam
 <manivannan.sadhasivam@linaro.org>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, Peter Wang
 <peter.wang@mediatek.com>,  Avri Altman <avri.altman@wdc.com>, Bean Huo
 <beanhuo@micron.com>, Andrew Halaney <ahalaney@redhat.com>
Date: Sun, 01 Sep 2024 15:37:00 +0200
In-Reply-To: <20240828174435.2469498-5-bvanassche@acm.org>
References: <20240828174435.2469498-1-bvanassche@acm.org>
	 <20240828174435.2469498-5-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2024-08-28 at 10:43 -0700, Bart Van Assche wrote:
> Call ufshcd_add_scsi_host() after host controller initialization has
> completed. This is possible because no code between the old and new
> ufshcd_add_scsi_host() call site depends on the scsi_add_host() call.
>=20
> Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

I don't understand why the first 3 patches can't be combined into this
one for easier review.


Reviewed-by: Bean Huo <beanhuo@micron.com>
