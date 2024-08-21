Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C4113B297
	for <linux-scsi@vger.kernel.org>; Wed, 21 Aug 2024 21:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724275666; cv=none; b=EbEZ63maDaveddMryHyMINo3AfBzAfg7ULY46p8uXF5gJvZ5fb0AoS9sZt2fegkgNGXOqr9qcqBbr0Wb8Ik5fy6GI4s2TTFo8dvlgRQyCXuPETqoN6tUUAMbPV0yP7Y8hYR30INMi2t1CmlJ2660zhkxGi4VRnyTRnv/RDyEVtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724275666; c=relaxed/simple;
	bh=C4Qg9ozUNOwBREpg/H7MZaH4i/ngSF6+/YUz/Eveifo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YtNdPELmS3pNPy9kmVDhq/SOAq3CpZNvUO+OxL8PrsMTT7Gx8+EI2rgguMDT9kkhFs2S3x40V04q10/TBHzke5XWSJHbveuzIELbQLuQRbTyi2brN2DNylZNLM2kobZctRpwXCoy+QjGYu6rCgJyrf2ClgBHAIbiWZAjPc/h5qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ez5JCbyS; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ez5JCbyS"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2f029e9c9cfso1315451fa.2
        for <linux-scsi@vger.kernel.org>; Wed, 21 Aug 2024 14:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724275663; x=1724880463; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=C4Qg9ozUNOwBREpg/H7MZaH4i/ngSF6+/YUz/Eveifo=;
        b=Ez5JCbyS5xswwH0RWrlEfFHa7bsB1JR4/mezk6jslpT+VpPc9VWzp06uP8bX7EkCVG
         X11mFOGF3dNL+v9eKs/+bd9Xro8VMTimj3OqyJEVbeXjTlWB7ySRMjnSvfq2AfV2+6UM
         wkXJz/PjjuD/08WlsA3jMNHdKz+BNLjr095Ckmf/BHQYpCMS0fFz2qVzHIqPr7iM3F7y
         jR3JrmfWKpYGshG7T/BiQH6j+jEsRP8ZI6l2GtDY80NLJERM2SYyPcnmKlxw5YCrPlpN
         TCYN9mDNAPhktYrvKwgf5mXQxzdkRFnmVdZ6ftvd8Np73S+pgXATAMr1QmuUWXY0xbaW
         5COw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724275663; x=1724880463;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C4Qg9ozUNOwBREpg/H7MZaH4i/ngSF6+/YUz/Eveifo=;
        b=mA35ONspCzyhrLAnMekSWw7X0ZJS4kfYrSwfENDUi/OCHf+vivJTDES9D+BhguomWo
         l4eOsL8N66CY8fwfQqPCIy4AsZ7W36N2DGc3ZYOUTxKbiPCyFUWXGGbGtnGVCouOnbra
         cZvY1bmibRdPMkJ6IL+zrIaYBxsuWY4ZBvGd0C/Xd71X9hkwmXV+tRIqmZpMAZ9k+5GC
         TF+amh/8UQU7AvOdbMVDZyzXwSeUATE7GgbnU23E1UTYHI8F5gaF2WHwfHl1tvGVLcqD
         WA9g8agS7UezMAG19U8j0xlVNlU6ApMS6gUHQNtZwYoOPkhN0cs+oTYV08wgasPdzcon
         0sTA==
X-Gm-Message-State: AOJu0Yxi9NhRXwiX96QW9n60emi/dXiK2OkjU05GL5cbZIUNFjcVgzh7
	YpXroUh9g+NonIcyA8f0VvB1e9GayfiHVh1V0Qrqb7DMRpypxOYO
X-Google-Smtp-Source: AGHT+IE7jgDH+xTByD+JDEAz2CT/vIg4L42ANqbAybihJKAhfk0jcMkQZWuszMvqmFmRv3wBRwk4sg==
X-Received: by 2002:a2e:bc06:0:b0:2ef:17ee:62a2 with SMTP id 38308e7fff4ca-2f3f8846ac2mr29215861fa.14.1724275662600;
        Wed, 21 Aug 2024 14:27:42 -0700 (PDT)
Received: from p200300c58710ea38238d6e8507432297.dip0.t-ipconnect.de (p200300c58710ea38238d6e8507432297.dip0.t-ipconnect.de. [2003:c5:8710:ea38:238d:6e85:743:2297])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a868f220244sm13233866b.23.2024.08.21.14.27.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 14:27:42 -0700 (PDT)
Message-ID: <7e7f22dc6e73f6b1871f00032517bfe5b3a7d13e.camel@gmail.com>
Subject: Re: [PATCH 1/2] scsi: ufs: core: Make ufshcd_uic_cmd_compl() easier
 to read
From: Bean Huo <huobean@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	 <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, Peter Wang
 <peter.wang@mediatek.com>,  Manivannan Sadhasivam
 <manivannan.sadhasivam@linaro.org>, Avri Altman <avri.altman@wdc.com>, Bean
 Huo <beanhuo@micron.com>,  Andrew Halaney <ahalaney@redhat.com>
Date: Wed, 21 Aug 2024 23:27:41 +0200
In-Reply-To: <20240821182923.145631-2-bvanassche@acm.org>
References: <20240821182923.145631-1-bvanassche@acm.org>
	 <20240821182923.145631-2-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2024-08-21 at 11:29 -0700, Bart Van Assche wrote:
> Introduce a local variable for the expression hba->active_uic_cmd.
> Remove superfluous parentheses.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>

