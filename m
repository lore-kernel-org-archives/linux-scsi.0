Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C0F204C3A;
	Fri, 21 Feb 2025 10:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740134315; cv=none; b=fXuYW31uURd3rpjSCHz3UgAQ4+cnUbT+1Xr770xTdTmp0MKNW3cE66TTlRDMe7YRw/mIorZF8EjRih358ED+JGx7STuZmme8zasg3UydSGSEY8wuIEBwgU8cW3PcprXNWLLwoyRfdt18EgjkMBQvP8hWpdMwRa0FX2FKYnNU8/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740134315; c=relaxed/simple;
	bh=DQ7fsWXnr81TGCvxwT39yv85kiLQ5gpPRFYuWpRLa98=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ke5/D8yN1qw4gIGbaA6ZDyl6HSDvgBhotT9HJFmULFJ8yoaI0vQOQg+YKfC+B9ndAWzpCglrrz3GaYKJFmeGevrm8oW62/5p9TK13ewCtMPGeQGrlXLod/QxSdc0oJ41HThIKvd8yG2YfF0F6yPCfP6MOf9dsctt0ZuY7p+Exnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yp65aKc4; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yp65aKc4"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-abb7520028bso272849866b.3;
        Fri, 21 Feb 2025 02:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740134312; x=1740739112; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DQ7fsWXnr81TGCvxwT39yv85kiLQ5gpPRFYuWpRLa98=;
        b=Yp65aKc4KpNpvLYmUC1PNRkaqm8xmbVdWbZQgQ0rEghhV0/FRFkUjflH43ZxX5m3Rq
         vfG2c1HWfW2L/z8OTG+lRbzn/11unWlJHioTfsA0u9mde0yo/asSijK6y2dRTaHhZbLu
         HeYhTHqIkbtG9qI1xM2Cl4QBwq6FtO153PNgdZibe5kbiZ95swMdXkj539bOS7Sbry1+
         D9svKHCfUuM04XYU9o0iAv7fSqG6xRElOaD0hKkqiljYLqykSLGincdDzgtb9Y2ukvAQ
         3fFcxs04tvDKyPH+ifbuWB/ZhRlkw9TSvqdpslXPncjpfjNgQIRg5rrdVydG2yScGL8O
         oU3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740134312; x=1740739112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DQ7fsWXnr81TGCvxwT39yv85kiLQ5gpPRFYuWpRLa98=;
        b=pBt60LX3DmJgzXNvtqieit94iFtfpkiK4AQVb7hh/eVmVCCs9R7kEaoJqtEm/knYh4
         aG/7yJfTFrXTM7IEijeexZBKAX2093lpqvqpqS3Q0ZOi1TH0AAk2f+MqsKNB+wGu9EeT
         RDvw4TAkPFA4UN/bODAblg3nXHYNS140mXL+v1YcKtpxLDxme60mJKwPKq2QN6hjsqRS
         D+miwlBSxDPC+aOzeLCx4FCZr7uxrXbYBI/hm3krqdJyex+LxIzXc/AMpMtbffUrspt2
         miBXtsEtsuZKZjyF//w/G+HcOjqUm13WHVfaqMWXz/PlBs+4G6rvFtoftWBDPPp9Qe87
         HHNQ==
X-Forwarded-Encrypted: i=1; AJvYcCVm3N/n8oCjTJwKKwTFMU6dxDf2aAgqAzNCRZNWDq7uMCt/638kBN/OLNPsJ+fbXu0biZ+6E3Zrz8iV1A==@vger.kernel.org, AJvYcCVxitae4Prylm++nTFo0OwZc3YZVQ7MI+mNvJ44Wseyo8rqSIG3TVgMiYVw55wkFHGDZz8YV12McY3iQw==@vger.kernel.org, AJvYcCXqA9H2WvRXyS/luZhVsLZi8t0MrOL1Tjxk4EfyECC3Qubb1oypEHC2PfY+/gzdEYhhcXlB6Nf9pUpNfQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwxfWYwxhexTNLkBit+fC11Xd3JoBW2dOJBBi/+iM2GlgNhvzTq
	flSfjGSdrfMAjn25d5lehS1l+FRoOxrrVBScXoWxJNMIli2D6Fecsd6/WCJU8jDqH7rwjUxcc72
	Qn2JvLbwPwfFdb+OFstyeMfzTwZceIJVadI6X
X-Gm-Gg: ASbGnctTGRkFBmgmPCdczqgppNYKhSCbkz+SNysiMIapL7ut5JFlkC4VMRk7JeZNxJh
	NpSfcmq3AtJZCHMsHVlhAJt8KULe1jSxRnupGQ4UFRtyHyvcUtKy7cjMcL2EJnVQEjLwVWTsjZm
	isYBxf63ZaB1+htG8ocCRLWn08
X-Google-Smtp-Source: AGHT+IGD6YiP0dN6ELvQItWtcLSNC+C4YCLGwsEEcWIRRLLW5oS18HX8IlkEy6wochtZC/R6v/sJf4VACOoM2CreUjM=
X-Received: by 2002:a17:907:2d22:b0:ab7:9b86:598d with SMTP id
 a640c23a62f3a-abc09a4b7c6mr248969566b.17.1740134311947; Fri, 21 Feb 2025
 02:38:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <f6130475-3ccd-45d2-abde-3ccceada0f0a@linux.ibm.com> <yq18qsjdz0r.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq18qsjdz0r.fsf@ca-mkp.ca.oracle.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Fri, 21 Feb 2025 16:07:55 +0530
X-Gm-Features: AWEUYZmpH0Apw5ilSxEp1rdIgRl0iRXIb7970HtruWNGBkcA04c-5zyfLHhEwZI
Message-ID: <CACzX3AvbM4qG+ZOWJoCTNMMgSz8gMjoRcQ10_HJbMyi0Nv9qvQ@mail.gmail.com>
Subject: Re: Change in reported values of some block integrity sysfs attributes
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, 
	Anuj Gupta <anuj20.g@samsung.com>
Cc: M Nikhil <nikh1092@linux.ibm.com>, linux-block@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-scsi@vger.kernel.org, hare@suse.de, steffen Maier <maier@linux.ibm.com>, 
	Benjamin Block <bblock@linux.ibm.com>, Nihar Panda <niharp@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"

> I don't see any change in what's reported with block/for-next in a
> regular SCSI HBA/disk setup. Will have to look at whether there is a
> stacking issue wrt. multipathing.

Hi Martin, Christoph,

It seems this change in behaviour is not limited to SCSI only. As Nikhil
mentioned an earlier commit
[9f4aa46f2a74 ("block: invert the BLK_INTEGRITY_{GENERATE,VERIFY} flags")]
causes this change in behaviour. On my setup with a NVMe drive not formatted
with PI, I see that:

Without this commit:
Value reported by read_verify and write_generate sysfs entries is 0.

With this commit:
Value reported by read_verify and write_generate sysfs entries is 1.

Diving a bit deeper, both these flags got inverted due to this commit.
But during init (in nvme_init_integrity) these values get initialized to 0,
inturn setting the sysfs entries to 1. In order to fix this, the driver has to
initialize both these flags to 1 in nvme_init_integrity if PI is not supported.
That way, the value in sysfs for these entries would become 0 again. Tried this
approach in my setup, and I am able to see the right values now. Then something
like this would also need to be done for SCSI too.
