Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A307E16DC31
	for <linux-scsi@vger.kernel.org>; Thu, 27 Jun 2024 12:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719493109; cv=none; b=rsz1DOeGzZbAsGtQRYbcbXyc5Bdv5X6NdafBJfGaNfAlyIZBxa+l3ryZoZ0bykGz3ySEK5H/nGcpup8mvrF6p2bGWzef9mrGXoUWVnRSRHloMe8kF9pKp4jR7NB2HsJNx4nu6xDPApQNGYSwbDnlskkvnRwNs52XqcUpXulwS+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719493109; c=relaxed/simple;
	bh=RxFOVt9GNWRoKX7RUH27pJR6RMxyH9lfiUGs2WIQm/I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tkreemx0PgfDkInnto6h4D8cBQoL5jTWFlkM/cTI26Q8Fyz5QCZJ4ZiE0B8nVC+vAt2qCKfC3xo9vJijzBcsn5Y0/HjLUWtNHWwuMeGbDJtE9NHif5rGBJGbWjE4QCPYkEPIvUZSwSUdiWISmhbtRQX1O1gH8YvrM2YWkoTzN/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=OEt/mEjV; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="OEt/mEjV"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2ec6635aa43so40620491fa.1
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jun 2024 05:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1719493105; x=1720097905; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0N2iZiNlp49IZkJJcDv0wlbzgt1XXwfX+LFY1eB15C4=;
        b=OEt/mEjVLy0gyj+IgiTmIRP01laVHld71Ydn9PFt2y+41FRCcSDnfceX3EjBUFQbjs
         6lRofjxiEvb4L80oTcrnVp6qMme4lhx02oRa1kyk0OU+8PhJnI+zR3RAPfH9tS+Ru542
         tnZo2wsFxp+mNFoINN9SLnqLWIeVHiJ3WKMgIM+NWToSjLS27pvtiCj8U/BJlp/GWw9T
         PMoiTdksAT6RqXKOsdIZYXu5jI/kZVl4W0OuBREiuflQrXKkJur1lVJUmCvdEj/WosK7
         j3W7MO9SeI44Bh5aiM++rda0ZvWCSaR48Z/HSXBc/Jq6iP3HPWC05VMynnLjnkGJ2pqs
         ngow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719493105; x=1720097905;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0N2iZiNlp49IZkJJcDv0wlbzgt1XXwfX+LFY1eB15C4=;
        b=regA9HACjCr+IZrv8URfi00wW65VXfQWTCBxoSBCTNbrJHGeS9yIWZCfYRr4g4/BCp
         en+8MXCjTH9XVt6kIJsxANhKoeIh0nxSilpTv1R/Ri5fwVGgVHyVBFuINMQmKd6dW48Q
         cW7G27D5TYbXW479JE1ysmZlRiBDp6iXzLyx6sNQvGQ/VMuOerskU9XCMi0XCyF/t9BI
         C3Vd/PuT+XkcltDcDMPK5S5YMSNBNTzKuwtDdYDqHJEpsw7kGwwPwOFDHS7PgFbYk8yJ
         9KBGopdv1KB2a1mqjXYC71xk48+A0UYx/r5ZROzplSC2wrdr1gb6Al6Ymh4elmEG+VbJ
         VlEg==
X-Forwarded-Encrypted: i=1; AJvYcCWGcxKh0IiJMIMRzPevuTTeY/yNcGaaawM3KBU+docM6Veg+Y/nF1DA1wdZCRUyNpwQ8BpXNGvfA8rQbAjDoMkj6ptA3a35COSe4A==
X-Gm-Message-State: AOJu0YwxjEpY8ZBFRmBh1HqFwofpzp8q+0fldY1sn3+A+eD+ONCh0irv
	VdwyKtww+M79RH4NByy1PYn+IlYVE9raP5ZBhed4z/XO8p/irEefxG36FvNvKEQECDLZgzhkb3J
	m6py3YDbUw75851JH0zQK0T3qZPUs8LjAsXKtUA==
X-Google-Smtp-Source: AGHT+IGsQdAA5QdKM6jgB8eC89jmAAv4tPd6AoteaUpyE1wW1TXDNm78S4nvaY4fg95ZqoYupUjqBwqtknGrSZclrSU=
X-Received: by 2002:a2e:a167:0:b0:2ec:4ef4:199a with SMTP id
 38308e7fff4ca-2ec579fefbemr89117481fa.43.1719493104834; Thu, 27 Jun 2024
 05:58:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240627124926.512662-1-hch@lst.de> <20240627124926.512662-6-hch@lst.de>
In-Reply-To: <20240627124926.512662-6-hch@lst.de>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Thu, 27 Jun 2024 14:58:14 +0200
Message-ID: <CAMGffEmvEF5gZszQ+Dkp80J7qTU8ddWMBruW+csSR96pSVrgpA@mail.gmail.com>
Subject: Re: [PATCH 5/5] rnbd-cnt: don't set QUEUE_FLAG_SAME_FORCE
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>, 
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>, Kashyap Desai <kashyap.desai@broadcom.com>, 
	Sumit Saxena <sumit.saxena@broadcom.com>, 
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, 
	Chandrakanth patil <chandrakanth.patil@broadcom.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Sathya Prakash <sathya.prakash@broadcom.com>, 
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, linux-block@vger.kernel.org, 
	megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
	MPT-FusionLinux.pdl@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 27, 2024 at 2:49=E2=80=AFPM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> QUEUE_FLAG_SAME_FORCE has been set by rnbd-cnt since the initial
> merge.  There is no good reason for a driver to force exact core
> delivery, which is tunable for very specific workloads and not a
> driver setting.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
en, I think it's fine, we still have the option to set it via block
sysfs interface.
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/block/rnbd/rnbd-clt.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/block/rnbd/rnbd-clt.c b/drivers/block/rnbd/rnbd-clt.=
c
> index 0e3773fe479706..c34695d2eea7fe 100644
> --- a/drivers/block/rnbd/rnbd-clt.c
> +++ b/drivers/block/rnbd/rnbd-clt.c
> @@ -1397,7 +1397,6 @@ static int rnbd_client_setup_device(struct rnbd_clt=
_dev *dev,
>         dev->queue =3D dev->gd->queue;
>         rnbd_init_mq_hw_queues(dev);
>
> -       blk_queue_flag_set(QUEUE_FLAG_SAME_FORCE, dev->queue);
>         return rnbd_clt_setup_gen_disk(dev, rsp, idx);
>  }
>
> --
> 2.43.0
>
