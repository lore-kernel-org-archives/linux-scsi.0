Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BBC82D91
	for <linux-scsi@vger.kernel.org>; Thu, 26 Sep 2024 14:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727361917; cv=none; b=Crn8822lYsaC7Fxpcvd5Gt2afmh3+pgmgpgeCHhCBJlTeJI+vMaVoXFfJWDqrwdwO5Co1WhKx3XmpKKOl6iGGXb2lnLNv30PkfCMObEgIiQt8AVl5g+Rpn+waCAjtNt/Q9CODdASMRukCm8YEBlusClhbw5X85iMbAOb11+IFX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727361917; c=relaxed/simple;
	bh=dsumOzFDfuh/PYFlQ5fBlwa0itLqF681cpqOcUvtv+0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hnWIMIqK6Y39+ZODhU1QeVKd6+1vB9iN3/RRap0yek2eSU/kgCQm5LooPACN9HBmMX3DCANJ4SDClshtPgQbT/SXJ+rz6WtKNNOEA529MSWP7R6QH8uqwKLJdNpE3hnigEM9avgiWLwyEhFjd4VDAKjYWywOadxTcFJPmjEzggM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=VeyTd9R8; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="VeyTd9R8"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2f74e613a10so17719681fa.1
        for <linux-scsi@vger.kernel.org>; Thu, 26 Sep 2024 07:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1727361914; x=1727966714; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UUk5GqFsvnt8aibuoucXH3mgAlXQnT7Fu6sM4Odfi8U=;
        b=VeyTd9R8+cruMSRIYlvO1L1twVFDeN8tss4OomfqAArVdxqGg5rlNP6/dJTdyfu6V3
         hBKl0fkg0OuRoNnW63/VeLvk9B7em36Cbcnf2Gqp0/4BJBn67uvQv+ry8hFi5yDSjsIc
         a8GEHDLtx83lBr4KcH8WHijTHKP8MtiCRHURjyDSGurE/OL6/lpPk1QxqVf8EiHx0yZz
         TNVzZ3pDHrxw7mhaAX45p5GVd9rTkNk/1N3FlqBl5y1AreZfVYwwT+srqanbuS6g/v0f
         fU5CB0OLI9I9lxOKOEvBd+ntYRVtMlLO8Iq/FKzmdsk+ivGluF7Kent+Kwap0IKHHHBN
         HYWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727361914; x=1727966714;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UUk5GqFsvnt8aibuoucXH3mgAlXQnT7Fu6sM4Odfi8U=;
        b=l/W2Xxh8WOze7WfYyRmBAYaBBfc7N5cFX7ITpeTTXAeeKwd2jA1qL/BjhpPLVnxQ7i
         doeEbe2Ji184IRcFRLhngyol2D6JmXodwfx9+ksHsDrsAQXqxtFqkvpSWQOrUOy4i/sh
         KqyyUo+UOsorOMg4jd8VWLcoIkxm5DUDx+MKCqBbt3Bsuddkj4GN+X1e2ycx/u2ZpQeT
         Kca/f6BMltRnJCmhSrSK+qowWGxIvRQFPXU6lx3hSmpjk/9yHQgv2NRkXZW4yOuRFyok
         1Ehjf/Kl1lwZFMgv7LQFseI0Qvv3i4pCr4YC2svwXr/56hoUz+U6EnvoRxHkYL6CBy7F
         afvA==
X-Forwarded-Encrypted: i=1; AJvYcCXTnXC8MtYDf1Rxhu+seVWFcy6F8RMWBsmSKtsLQo9gK6c4sfO1XGdVy8ZFxuGB9rHECorqmDu/LYyI@vger.kernel.org
X-Gm-Message-State: AOJu0YyKAsaBZnAPNZzvQqndy2UdvWiD5xZ7OVpfBMKl7jrneEVTfK6K
	uRr+o6DkAtjgSDMTk2X+bSt3kJUt2rINZ3UifzhrthrnR6UtmXOGXwNf3hjKyxpYNhpwNZaECdA
	Z9q0wYwem82hiO0MPhzUTxJrnNzR1B62tLAF37g==
X-Google-Smtp-Source: AGHT+IFBiLue3QFOk1WR26MRKOBV5299+r2MgZ52axZ/Ki/sFLcqtDTCw32+oxmnpnFn89KL/PCW6zIy0IG54nMMM54=
X-Received: by 2002:a2e:4a0a:0:b0:2f7:6869:3b55 with SMTP id
 38308e7fff4ca-2f9cd40052emr9790031fa.21.1727361913927; Thu, 26 Sep 2024
 07:45:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240906-wrapped-keys-v6-0-d59e61bc0cb4@linaro.org>
 <20240906-wrapped-keys-v6-6-d59e61bc0cb4@linaro.org> <fc780dc2-5a69-48d8-8caa-ca2ee97d10ef@kernel.org>
In-Reply-To: <fc780dc2-5a69-48d8-8caa-ca2ee97d10ef@kernel.org>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 26 Sep 2024 16:45:01 +0200
Message-ID: <CAMRc=Md3itY5N1gErL-VDAz0qW6DrHPKpXzT6kNwc2HVfvchpA@mail.gmail.com>
Subject: Re: [PATCH v6 06/17] firmware: qcom: scm: add a call for deriving the
 software secret
To: Konrad Dybcio <konradybcio@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, Asutosh Das <quic_asutoshd@quicinc.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Ulf Hansson <ulf.hansson@linaro.org>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	Bart Van Assche <bvanassche@acm.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Eric Biggers <ebiggers@kernel.org>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Bjorn Andersson <andersson@kernel.org>, 
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, Gaurav Kashyap <quic_gaurkash@quicinc.com>, 
	Neil Armstrong <neil.armstrong@linaro.org>, linux-block@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-mmc@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 9, 2024 at 1:23=E2=80=AFPM Konrad Dybcio <konradybcio@kernel.or=
g> wrote:
> > +
> > +     memzero_explicit(secret_buf, sw_secret_size);
> > +
> > +out_free_wrapped:
>
> Is there a reason to zero out the buffer that's being zero-allocated?
>

It's my understanding that it is a good practice in crypto routines to
immediately and explicitly zero out the memory used for storing
secrets.

Bart
