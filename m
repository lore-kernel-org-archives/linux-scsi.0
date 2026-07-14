Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD92379996
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 10:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784025687; cv=none; b=M22wlLp0OPFMSnQOAMEox4hF1180ngrxmUFWmnPtoOBTJIUMgbJeU2DT2hzqWAeQY9TMJDeExxjCP9J5vV9wYOXJHeC2KpeH2DA5glfL7hxIU3xk9LG6FmGSFdJ1hEQYCxxfap/OS4l6ngm9TifA91xZAOLixwGY6jAnc4UzPPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784025687; c=relaxed/simple;
	bh=Hmer6O8ixkOYBpOdirHDmOA69XMUPNUsIsxSFWK2mwc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b2Bjm4ndDQAwk+ePDr8MtJsy0m2Bf+Zlco4mPCTx88AEd5fDkaM1DPiM9dOL8e8YzNnvZoCWYYSku4KewGUC/c75BetKQck1eeeqff7z0pYbCdwb1tZ8Ls7qBoxwHr13jmenlJKo7t8+tRO17x8BUjO90fZPxESvlqqaqNNmk40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TuL7pCPX; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TuL7pCPX"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-493f4638f4aso7122775e9.3
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 03:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784025683; x=1784630483; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C3onKJ41QXoF98KPvyDMLDZXhrz3S4L6F+Htl8lWjBI=;
        b=TuL7pCPXrD16jLAWQBNzUlyBqQgUAvJl/Wm0/TjOHXlHzCi34YfAHC8SS8S0g37FB1
         sNT5wW5kRp7el4UB/z4zDL/Ahq75cGzcVFnUAiLZJTMSFiLjy3vJ+y5WMKVfnGL4dFwg
         BB+1VLwl8LsVYEuky6lRq3ie8oXJNW1sPtas6w7cSyBtRVq0zCKvsoP7qw0+FODWOGay
         hvHzrS0NJTwtY6aJAd20hGwU39WNmrTu54DqHoVuQCF1G3IePTSUz30Oo+32eqhX7VhU
         4ATynuuTtxq2jpgL32Rg/bsCEl6cpKvnV9Q1iyXqb+cq2lmJnVUjq6dp+Z3PuE1juMBO
         mnMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784025683; x=1784630483;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C3onKJ41QXoF98KPvyDMLDZXhrz3S4L6F+Htl8lWjBI=;
        b=qVLJfk6b3ansyjVepscQCch5KlSL+FPhLqd46qP65HIYK3mY4CuiQ+/GcKIldq8/vo
         /ecS8G/A2bnGjV9gG3bNkKhB9BNhtNf1oqIAloydckcZKI3Cu8HnJogfsIr+no77APAp
         1ORSqxXbLyKRNreaLyECGHre/bXE6yi14xly2f7qsd5MUKmR6hUD7lAzAJddGJ+y7uz/
         YJgu6c1y7HoqhOpHYOgy8E/hNIuL4aCldt9d9QyMtLYPDtF0kIgzZu3/zM7eSEj6aimU
         2qFVIRtDdJwA3SnVT5urd6ShJYN5NZE1CiODgGoulWYGqYEmiOA8HIw3o5JvUWC5pB5J
         Mkqw==
X-Gm-Message-State: AOJu0Yxzm10gHxQ5bdZNGpE8p7Gj7IIBGput0cZErk3X20AypCpY032w
	Eyf4DhG2DeyRrMV/fV9m/4L+SXlPcDBGizJtE9r96svXO6eda9tkVW7AItX1NLTcVsA=
X-Gm-Gg: AfdE7ck/eKJ0uAPXWMDYOm5d+Dz0VNNR7KjQmWOSOiAv3h6uqVhmH9gqQFFo3TEpWm2
	S7N5ruP0LZyoZKliToz5O9tXraqTcu1ffA/xkWEKEqCsTa4IPw11Z4CRSUxYSaKjwvhyqI99Q6X
	ZhpzX8roag+/77FiOdCpxi28mZl/UcO8kOkuby+kIGlHwBhRGeWhLRhnRIfOrJJgGOu5ebFnmVk
	GvwhMi4nlxNY2tELP5PzLpWI46HYZ0goshjzBJz5DvTgufWtoMnyufBSJZ+XAV4ywQXpRx8jE/H
	EQXbZln3GR+fOoxavRtpELGCD578uxnadpBWQ1BdXmXqmqQEeqlqZ6lelkaD4w3/F/c6bKC57Pn
	mVAR20bKlqxlApj9jhDLkJDEcCjL8LnOId90y1C6ygHQVkzH2YtEvsXFTpE0H7gOd9FIlKlKg9s
	0S2vubMhEUWh136Ju06+EBfYvT0TDdk8T3kEGUIfAwvuWBWw==
X-Received: by 2002:a05:600c:1392:b0:493:f753:24e8 with SMTP id 5b1f17b1804b1-493fed59338mr114651775e9.6.1784025683275;
        Tue, 14 Jul 2026 03:41:23 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4950a2e8f07sm60831755e9.7.2026.07.14.03.41.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2026 03:41:22 -0700 (PDT)
Message-ID: <7456c002-2427-4070-bfc5-6c23fe820e8d@suse.com>
Date: Tue, 14 Jul 2026 12:41:22 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 56/56] scsi: qla2xxx: Update version to 12.00.00.2607b1
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-57-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260714095353.289460-57-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/14/26 11:53 AM, Nilesh Javali wrote:
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_version.h | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
> index 9564beafdab7..1c0b01d70350 100644
> --- a/drivers/scsi/qla2xxx/qla_version.h
> +++ b/drivers/scsi/qla2xxx/qla_version.h
> @@ -6,9 +6,9 @@
>   /*
>    * Driver version
>    */
> -#define QLA2XXX_VERSION      "10.02.10.100-k"
> +#define QLA2XXX_VERSION      "12.00.00.2607b1"
>   
> -#define QLA_DRIVER_MAJOR_VER	10
> -#define QLA_DRIVER_MINOR_VER	02
> -#define QLA_DRIVER_PATCH_VER	10
> -#define QLA_DRIVER_BETA_VER	100
> +#define QLA_DRIVER_MAJOR_VER	12
> +#define QLA_DRIVER_MINOR_VER	00
> +#define QLA_DRIVER_PATCH_VER	00
> +#define QLA_DRIVER_BETA_VER	2607

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                                 +49 173 5876786
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: J.Jaser, A.McDonald, W.Knoblich
