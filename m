Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F5E351C09
	for <linux-scsi@vger.kernel.org>; Thu,  9 Apr 2026 02:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775700348; cv=pass; b=TkiOfiAy0qMu/BXq/y5cyS27ZEgEuA7RaZ3ZBDFymTmv6gc7o/bJg2AXeptnwZ7k28kOTQtseYH9y0D+NYNLucLxDTMo/FqttKv53UjRvl8rhk+DS9WDAZxpyk0cObbUXezqK9cGE/hZ5hLY750YBoD8eZbSEhaViTfS4LlBNBY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775700348; c=relaxed/simple;
	bh=UeTwiLfBg+d0J+5G2B+h5pJ1GQXFcgWjEGVIN1kl2GE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QV1j1f0qurr67qJemERmE9hiUGeYLN5Bf/Y3IPI67Xi6P3ExB/9cTC8tzjKgM3JEpNrXySAr7rJ21ZBNoygWjxkBU4/ghKTTvuchJIg4hqFjIIlrU05cBcHA0c5ycM4Hjue9QDdJ3xRysBay00uP4dKFrVPFtgI4xxz/x/ST1W8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S8AACEqm; arc=pass smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S8AACEqm"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-2d18dfa2713so177757eec.0
        for <linux-scsi@vger.kernel.org>; Wed, 08 Apr 2026 19:05:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775700346; cv=none;
        d=google.com; s=arc-20240605;
        b=YnNQEZ5CcmvXrM7rIQp/BUkDHOjpjwwwClnAyUqa9u13ecDuUjcfC4n6fu4xd/+EH8
         9+n5CdzayvY6IOX1ioSXIPg/BlvupTVdRCEVWSJNlzNSPKQkeeyCrYZOiUdm3qRdyBeK
         HdoS3fFUKHCifj7Uq937SMhioNLB1ws8SzzmwyvtiwCUrQNSsU/ADwvpipJJanAUKSZG
         cmAE+Y/dTzNQbtg/aCY8bGUJ7b5d6Qpq97UodR0Gi6HdAQGq5T9QR7RIXQPqiYp3NKy6
         lt0Jnj43EvrlA3QfJdhRubUCqsbg4EnGW14oZolYZyMr8gwTMsrQ+NOltbtlzRFbWGaH
         lobA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SLQ9FL6B7CY5WwBy7xgt5VJrNvupBJ8idCTyKNGIzh8=;
        fh=bTyFeUPZZK/Q4IS+mSLP9LtFBQsbItgEeKYukF3O94s=;
        b=YNJdmSGXORSjuz3/OqrZsInSKcjMmidj2wiUIoKkVEJnjsnpUM+TexwGSazs2iGUw+
         f8GSAV29yEjAORjkOPiOkCoAHW5s8tORQwTq2H1/yed1yeUA8zryr/txWRGOF0n3JJsT
         V150/OpodfbWfMtiM/eYqWV48vi9LIpdLyhyvXf+SMnsvj7UYpXuKO+5iN8b5LUjbzjH
         9d0XE16FHeMBnXqHR55FtPt6J/6tZB9jWBpikBsZTjyvfaeEAotGKbekTh1tEIdl0TRE
         r0B54olMWRv5pgBEyNtkvxJMLQCPXqaomeC9SehCO1eWNIqtAaZcAgiJkhKkntrGRBDP
         4AHw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775700346; x=1776305146; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SLQ9FL6B7CY5WwBy7xgt5VJrNvupBJ8idCTyKNGIzh8=;
        b=S8AACEqmzwS8lTf10DqZ305lkXH1MmlYxMNNqeIM0394QGTSrQbHyV6SiTH4qCniKd
         VB15ebwsmN19LU4k1k3CBPK0EpnplDZyty8RpGSl4n1WPcddGJIvjPQnXeH0BZdrQ9gR
         3qhoqWkoCiSAm7sMBKzKPsvBjPfBlFOVSfe/Y/KAxdmEdOWKDgwl1g7YOTaRFu3ww0ti
         HhRf8LtnMy+8bqDUJaU4HYZ8NYaj1hWcrAocnk6zSudloyKvrAoZ3ockFJMHLOMD8Mud
         C8ZpjZRNP65r32LKpH5dNpxu1LqpKWPDFtiqkz34rX+lZ8TxKArQ3gr4AxYFtHy173zi
         ZNPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775700346; x=1776305146;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SLQ9FL6B7CY5WwBy7xgt5VJrNvupBJ8idCTyKNGIzh8=;
        b=iKtp+ZfWZl5/e25fRSZeTLUsvyJi4R/QpLh5RP6IHTV5IugIUZpvVqsWS4laCn1DnT
         tMM7W42VoyUG7CG5WLP6tDNVO6sKX5IzrINpnKX3ZlNghUQXerw2XjkOas+R/RnxqjEf
         ctlut52orAmHP2G8mSZloTVkFJZExlcxeiQI5eWYayGDjtS9XwwsjN+xfH/6E9zT457Z
         HJqHHUqETyzSAYwGZHGS2RYE2D3eMNY5n8Qln4BBZAbw8uZBOIUpPj8D6qOrew+Bsf6E
         AeOq4uqpJAa+KLV+U5CNLW6VsQOls5ICj16K/DcyuYhhGFHsJEQn7R7Io2F6dCIqaIjx
         uihw==
X-Forwarded-Encrypted: i=1; AJvYcCWBc2LIz9VzotlSKyVmRS4pMf4so/EigYzpcdLDbkTJyylEFGT//j19u0ggxYy9xmM9d7XDcVB/CeTM@vger.kernel.org
X-Gm-Message-State: AOJu0YzbeSdBYRg8+sDkjb/ae/nSfrGhaX81UFnzjaCdbmUYoxszBUCZ
	SAXOxdnaerH63Pg1LhEwFv6zGh+Y+77vWzbZShcIJSIHVQbaFFXnszCNmZZv1XRcNzuoL2dwEAe
	5xjPn1gNEOholGKT2ybu3lNMJnlhI91w=
X-Gm-Gg: AeBDies5vhV2PhmNJ6C+LEQsiT4d8GmQQwu2VvvUMIWfxCF6ee2H0Sxz4otPnG0q2or
	QyNqcsWTfPvL07/o8QBf/iwGuAaZPq3H0BfjSQaNYs1eKcz5F0+101sxPucT5Rz5/5D53dxWJDm
	9nsmBcO93oSzKyThYV24IIUtZsBF1blCYHHOyzCZyQ8o88iJfApEG8/a+UIpb6MrSI4bw0xeeYx
	HsQo0QiCQzGkS16jQS/dVanRdE095eUIw4Vwiv7PvtJ5ux+HKHf84DW7x6QRGCefCFVyk7lUeox
	wByvoEJTkfHtTMzrlA==
X-Received: by 2002:a05:7301:490c:b0:2ce:54af:778b with SMTP id
 5a478bee46e88-2ce54af7932mr6799136eec.26.1775700346235; Wed, 08 Apr 2026
 19:05:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260408073105.272255-1-tiala@microsoft.com> <2a80b7a6-2cfe-4bd0-a799-ff855df7bd41@linux.microsoft.com>
In-Reply-To: <2a80b7a6-2cfe-4bd0-a799-ff855df7bd41@linux.microsoft.com>
From: Tianyu Lan <ltykernel@gmail.com>
Date: Thu, 9 Apr 2026 10:05:27 +0800
X-Gm-Features: AQROBzBzEzYGBNkJ3Lc_cJV9swgWDuwSma-hhDKuy9WuT4xSdDRp7MADvaPkmmU
Message-ID: <CAMvTesDJv6h4kSR=M6JD5h6h8NOAq9_2qvm9kY30o-BkmWWMJw@mail.gmail.com>
Subject: Re: [PATCH] x86/VMBus: Confidential VMBus for dynamic DMA transfers
To: Easwar Hariharan <easwar.hariharan@linux.microsoft.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org, 
	decui@microsoft.com, longli@microsoft.com, 
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, 
	apais@microsoft.com, Tianyu Lan <tiala@microsoft.com>, linux-hyperv@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, vdso@hexbites.dev, 
	mhklinux@outlook.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 9, 2026 at 12:55=E2=80=AFAM Easwar Hariharan
<easwar.hariharan@linux.microsoft.com> wrote:
>
> On 4/8/2026 12:31 AM, Tianyu Lan wrote:
> > Hyper-V provides Confidential VMBus to communicate between
> > device model and device guest driver via encrypted/private
> > memory in Confidential VM. The device model is in OpenHCL
> > (https://openvmm.dev/guide/user_guide/openhcl.html) that
> > plays the paravisor role.
> >
> > For a VMBus device, there are two communication methods to
> > talk with Host/Hypervisor. 1) VMBUS Ring buffer 2) Dynamic
> > DMA transfer.
> >
> > The Confidential VMBus Ring buffer has been upstreamed by
> > Roman Kisel(commit 6802d8af47d1).
> >
> > The dynamic DMA transition of VMBus device normally goes
> > through DMA core and it uses SWIOTLB as bounce buffer in
> > a CoCo VM.
> >
> > The Confidential VMBus device can do DMA directly to
> > private/encrypted memory. Because the swiotlb is decrypted
> > memory, the DMA transfer must not be bounced through the
> > swiotlb, so as to preserve confidentiality. This is different
> > from the default for Linux CoCo VMs, so not use DMA(SWIOTLB)
> > API in VMBus driver when confidential dynamic DMA transfers
> > capability is present.
> >
> > Signed-off-by: Tianyu Lan <tiala@microsoft.com>
> > ---
> >  drivers/scsi/storvsc_drv.c | 28 +++++++++++++++++++++-------
> >  include/linux/hyperv.h     |  1 +
> >  2 files changed, 22 insertions(+), 7 deletions(-)
> >
>
> Does netvsc not need this same sort of patch?
>

Hi Easwar:
     Thanks for your review. AFAIK, storvsc support the capability
We may add such change for netvsc driver later once netvsc
also supports confidential external memory.

--=20
Thanks
Tianyu Lan
