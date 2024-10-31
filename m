Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147DB19B3CB
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 12:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730378121; cv=none; b=QzqrBgBDlVsQYGUOr20kGBdshZGdPr0zeInypSCs21DrbGttIkPIXZyd4lDk/Vq2kGUrFMydEVb0SzC0QRau3A930hYzIFlbVff3934Ow5EFbJi4cwjHEIgvhakMd6qaswQZrLGNXDjI8VnzT+QHMkpV655rV84QUi7Ab0MCQ5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730378121; c=relaxed/simple;
	bh=HNw99ZBoCtL9gebq7HnHLHFtZ02VTCgq3uG6OiI7Lpw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NhG7a902Cmn07PYBvFILCnBHvS3WppdfHcnp/aAKNApJBea9QSdbRoh6wAlLHDQoZ8lGOiP9pfXANkj/xMScl1TN/nv4WwsZOwOpIc1S3vSwl05EYwZGCxvKhc+6zC7NTDhaGb8mxxtyaurmhGlYKeieRFNkW73OQfItNYUACKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WU8IeSpN; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WU8IeSpN"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-71811c7eb8dso503870a34.0
        for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 05:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730378119; x=1730982919; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HNw99ZBoCtL9gebq7HnHLHFtZ02VTCgq3uG6OiI7Lpw=;
        b=WU8IeSpNiAnaRF36fC/vv7+zG9kGiWFWgWmP8p3Aw6FVgF4xhmjb/fYznNZUOZuH2u
         be1x8nBg6wuJBmFMgfK7UTo0crhdYoraukbHqoqYDTb1CHJGYxwMwOCXjIgbkJTnaCAw
         D/Fi5/noZmiyrt+b3zzLhwe8CoFC2+AXpabfgw2lzxHjksb0US4ZHeirrGU5Dl1dIupi
         60yrAmVUgiz/AqDQcI5DQKjeJ88KlVhGvB8SdUdSVyk+DuYJulV6mEomv3YT5BWR8WZX
         aF0RPimWRgK/z4wdfchtSQMEsjWGgkyUsgLYkz5ldeu37w5au0EYbl0BDZy8MfTN6KcE
         f1ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730378119; x=1730982919;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HNw99ZBoCtL9gebq7HnHLHFtZ02VTCgq3uG6OiI7Lpw=;
        b=jj9V4fFIGuZqbXMfP/K3Q9tufIb17t4/nqIlaxXdl4YhzkQ61ImPDd2ZN4LgFuadtx
         /TbFU8MEudSylMurPxkv+urmelU+4ffYVi/AXCVD4XRWTv+y8mGG3BolIUG+wJLRrzOR
         eTQsJTZCrCocKLPMqjHg8Ivf8LitdGUsWB2Rbcw/7eDo0Q67qBHL1QJBMuKI2Pg54sND
         4NgPioLzimfEH5Kf0aOjMQk0hdnnsDsOYst6yGdDtOsCWfckks3FNLtxm9FcCGZTIwyB
         ZoWX0xO+LI4DIcLN/UnMnSZqZlOkLoWdJiWCbuGwuqdUuJNVxR+ij4vq3gnZd58sdn+Q
         m0QA==
X-Forwarded-Encrypted: i=1; AJvYcCXRMcg3JTe3fIhPhAS2RGfJwTChbc7Z+2TPK5sQTk59Ycw6SXz3or86RJeyJP1+XvTFa5XpyJ1wB1UC@vger.kernel.org
X-Gm-Message-State: AOJu0YzY4Fsmccd0ZyHpIFjdmPyEh/q0xyPEjznkMz4Esf/6TxFOclkW
	j1isHSfKQcNwt44XBR8/xSuGS20eP6yOkt10trajIzpVNu9Rf0i8b23Onfv8nURRnm1k22tf9po
	6MCCKcZEMveVBio03FthJBAVaOeFmigcquTmBoQ==
X-Google-Smtp-Source: AGHT+IEkKbJXyNqLSsuHdItgZxyQY+mBzja5TSh+tq+4mVxz/XjBn5K2/1nC62dW10Qg5qYRGU0KEBvvMHxYsE/WEXU=
X-Received: by 2002:a05:6830:2b07:b0:718:9989:efac with SMTP id
 46e09a7af769-7189989f002mr3434433a34.18.1730378119050; Thu, 31 Oct 2024
 05:35:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241025131442.112862-1-peter.griffin@linaro.org>
 <20241025131442.112862-11-peter.griffin@linaro.org> <b5dcd5df-7215-4679-a6be-c45d525e8051@linaro.org>
In-Reply-To: <b5dcd5df-7215-4679-a6be-c45d525e8051@linaro.org>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Thu, 31 Oct 2024 12:35:08 +0000
Message-ID: <CADrjBPoRTidJbUmC-gMDaEJRkF8iPUiGHWE89WJ2=+Ja5s1mRA@mail.gmail.com>
Subject: Re: [PATCH v2 10/11] scsi: ufs: exynos: fix hibern8 notify callbacks
To: Tudor Ambarus <tudor.ambarus@linaro.org>
Cc: alim.akhtar@samsung.com, James.Bottomley@hansenpartnership.com, 
	martin.petersen@oracle.com, avri.altman@wdc.com, bvanassche@acm.org, 
	krzk@kernel.org, andre.draszik@linaro.org, kernel-team@android.com, 
	willmcvicker@google.com, linux-scsi@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ebiggers@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Tudor,

On Wed, 30 Oct 2024 at 12:00, Tudor Ambarus <tudor.ambarus@linaro.org> wrote:
>
>
>
> On 10/25/24 2:14 PM, Peter Griffin wrote:
> > v1 of the patch which introduced the ufshcd_vops_hibern8_notify() callback
> > used a bool instead of an enum. In v2 this was updated to an enum based on
> > the review feedback in [1].
> >
> > ufs-exynos hibernate calls have always been broken upstream as it follows
> > the v1 bool implementation.
> >
> > [1] https://patchwork.kernel.org/project/linux-scsi/patch/001f01d23994$719997c0$54ccc740$@samsung.com/
>
> you can use the Link tag, Link: blabla [1]

Will fix in v3

>
> A Fixes tag and maybe Cc to stable? Or maybe you chose to not backport
> it intentionally, in which case you have to add:
> Cc: <stable+noautosel@kernel.org> # reason goes here, and must be present

I'll add a cc stable tag, as there is no reason not to backport this fix.

>
> In order to avoid scripts queuing your patch. It contains "fix" in the
> subject, there's a high probability to be queued to stable.
>
> With these addressed:
> Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>

Thanks for the reviews!

Peter.
