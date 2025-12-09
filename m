Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E0A320A22
	for <linux-scsi@vger.kernel.org>; Tue,  9 Dec 2025 20:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765313955; cv=none; b=gzFrB3aq0O42GpiU7b/lqMiRQAzNHmV8mZyvJtnA/g8KS4+EjHRCIBPoWSIPM0KunwLo85mrEXv8lYm/zsCPwunt3Ya7i5a34Bo4NXKHPzTFjwUPYBknUpdTO4kwkkpvLcVrW1jb5qlpRV7b2JpDWLu0S0iN0OODkLWn0Bqgxac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765313955; c=relaxed/simple;
	bh=aN4om6qY58NZhyKu2wBi4ujJFkmhZjiSgUfr8y9s74I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NtH5wzoeeE/4rB6jMh3LMdyX0tmli5tf8bTdjYSVQ1oPzSLw4CU3kcK5E+5RJ49/KrYIG2mFhxieqrE722BkdIxOkNOu1KCP8xlBolaUlD4kQOCa9cBtr+6UlEEF+UBQ6k9/5vrfD3KDjVIEmWjIypgMWKAf1euXRgkQpOFqA2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=z6uKdduY; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="z6uKdduY"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dQrnF0FJWzllCWB;
	Tue,  9 Dec 2025 20:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1765313951; x=1767905952; bh=bZ9FpjCNqq6YA7uGSZrj6gkI
	3QC5sSyP6+B2LIYooTU=; b=z6uKdduYefQoPH2o/7UpnSTxWWtUQfK8ojjs33QS
	N/3n8OsIm0JGKXBt5UzWwWo7rPyZyUP0oORHU+TLKvmaczj75jsf6PO09thHr4sK
	zmVTJ9RaWp4fEWVv7J9oYCptsmORESmcQrPmaFbYF84lXLTSQ8Se90Jfh+D04exL
	JaHzi+Z+f638PtlFFDSigN1mbFNS1vSKNTb+2rYKE4EJqwwyaBgKu5QyaZwYdoaX
	oD/rJkYVPmLiE/qkdcj33V9afbSZtczQVJSmIEQ6uHe2OfvCfZBBK3cmza/GZRcT
	YLtlzfoN4JrlOCnhUScA8lPqL8SwC8eV7qRj/qqc2Wt0Cg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id jdtv89z_tCdI; Tue,  9 Dec 2025 20:59:11 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dQrnB2lxfzllCm8;
	Tue,  9 Dec 2025 20:59:09 +0000 (UTC)
Message-ID: <e4924c88-909c-4ba4-8281-184f783539ff@acm.org>
Date: Tue, 9 Dec 2025 12:59:08 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/8] scsi: Make use of bus callbacks
To: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
References: <cover.1765312062.git.u.kleine-koenig@baylibre.com>
 <59b408f6d89d402457a23564302afcbb334bc9dd.1765312062.git.u.kleine-koenig@baylibre.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <59b408f6d89d402457a23564302afcbb334bc9dd.1765312062.git.u.kleine-koenig@baylibre.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 12/9/25 12:45 PM, Uwe Kleine-K=C3=B6nig wrote:
> +static int scsi_legacy_probe(struct scsi_device *sdp)
> +{
> +	struct device *dev =3D &sdp->sdev_gendev;
> +	struct device_driver *driver =3D dev->driver;
> +
> +	return driver->probe(dev);
> +}
> +
> +static void scsi_legacy_remove(struct scsi_device *sdp)
> +{
> +	struct device *dev =3D &sdp->sdev_gendev;
> +	struct device_driver *driver =3D dev->driver;
> +
> +	driver->remove(dev);
> +}
> +
> +static void scsi_legacy_shutdown(struct scsi_device *sdp)
> +{
> +	struct device *dev =3D &sdp->sdev_gendev;
> +	struct device_driver *driver =3D dev->driver;
> +
> +	driver->shutdown(dev);
> +}
Does this patch series convert all SCSI drivers that trigger calls to
the above functions? If so, shouldn't there be a patch at the end of
this series that removes the above functions again?

Thanks,

Bart.
