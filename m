Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC8B256C64
	for <linux-scsi@vger.kernel.org>; Mon, 10 Feb 2025 16:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739206501; cv=none; b=efTwTKti1IPG7IYcesoA043wxp8DM2epQKa1ZmEFvg7a95xZ7SZc5P5AfszlNQVY8sNdTJBw9o9NCMuxNStqRg/8HklKW9PYg5GcCwk/f51BHRsP7RcwNYrfPrlNRL2yOA3g2+rczYlRIZoJO0LLbFagQmIAJU1ftqzhg/qVbvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739206501; c=relaxed/simple;
	bh=wZAt1whlXvPo2Q1b3Smutb7wMRiPUZhVkP2+sI5mmfE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=lVGwKqbgxm44Us/MIfG+sVT6CQqEweebbxwH4Aq6vG7leoUoSb4jBgriRimZ64Dql6hCpt5Pi7OVjsjeCkC7N3oz7wLDqTbDo3ys/yVVtYDCoiq2n3i/Rk0L2lettiboV2pnu3W9Oc9Dqx8YX/revYwdezG7vcVBC9pzk53N1FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=EEK2NvAK; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="EEK2NvAK"
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3d13e4dd0f2so28808755ab.3
        for <linux-scsi@vger.kernel.org>; Mon, 10 Feb 2025 08:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739206497; x=1739811297; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8PMYtp94b1is643OuACwo/j12Ah7BR/XT3SC/e2pDuM=;
        b=EEK2NvAKPWynbUphfQLW3JALxZk3eTEAgOt7UDWFhkD1ggey+S+1IlA22MoQc9Rfur
         Z9rOOBIF9ss+ERLQmTbob8SdCB5UI/Xjai+s7g8fHOV+zsnlsXEHXtm13z1tBcVKLzpk
         K6WCLIXy3HnpE/7AXnPrvt/2IC4IQCzqQESz1i7brXXNnvcm1nbh0bq1wXyZAc+aWbzW
         7VnEJzB0RID2nQyvAD9LURFTfGRCh/M+OI7r9f7h3LMDMcEaUWQyYCtdN1y2w+0wPziw
         sYAJVEd6d3+PudbG/zJ6hugV5P7mmuHVgr8Ny4IXRaAY4LmhLl96GNZkNQNbXzNQDmBx
         BcXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739206497; x=1739811297;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8PMYtp94b1is643OuACwo/j12Ah7BR/XT3SC/e2pDuM=;
        b=eH/Kv4VxucYW1bu5Ut4TuAMX1o9JUi7L4gD5E7SvkGIMZoslZD//Q0EFMTTGOhea6M
         387TCJKgBRyzXt7xpRJ4bXHL2wUxEqFe8cdF9c+0T6NgsVmX2C1RV55KTNU0+4HcF2YI
         tA2oSDotiZiqN8/J1ut60lo5bF6N5kHNy2lZNV1OJThTMIujgZC/NxwhQB0rflkoBkMi
         85CU0SwfLkRTQnzkocwLTzWl0nTkMpG4cm61G73aHVeTsKgdEPCqv1oDb0SnXTnk27sL
         05th33nk0pu5B8DHuebaTm8GEbKy+/ku9Fw2Uy8m7fER673uLDGHkQXBYpGRox+HIGdl
         wGEA==
X-Forwarded-Encrypted: i=1; AJvYcCUWvBNQ9VkNatp/53Oiipg6joFxrTUZPWvO3Owxyd+gKGv0UVTOkLOCGAMOtzM+bgAJwEsVQ7gCcEFd@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6x+clfYFsA9pQWC7Ax/++jgS51qXR/v+Ef8qc1FRtSNIeWCK3
	8+O1F3A9UNfypwfJxwvUqKsXEuLoPPpTn7Om2K/fTyxvw0A1UKTr/1lClP3LQis=
X-Gm-Gg: ASbGncvgsqLtrR/UbyDjzDHbeETzXsiDqDBtBRqaLLKIUxDfOra4faJtEVEt4oiE0qN
	4VqRNXTA96HG6ST9X+6iaxztjl/mzSCx5MmIH2e4kWubCxxBIMLpdIRSb2ruuEQYMxg/RzPRifM
	kYX1qEsYQYg8DNs2KqjOW4ezdn2Uf5AbJ2kE18KkMm1y3AWn5Bm7+CESyPVeyyEkFpE5OPyWvoc
	6ehGlszZwqlQRRbzNhh4fODVQmrkBMHcheWB/zClYvUMz3vTofqsYQoZZ6J0GA/1ayVfz49Ruh3
	ix4MhGQ=
X-Google-Smtp-Source: AGHT+IEKwKkbjlM00wUkqD43ricuqMhdM5OtDdfTR4TyublFdzI2jLfPM5oMenNdauctjvOXP8xpKQ==
X-Received: by 2002:a05:6e02:1aa2:b0:3d0:1932:7695 with SMTP id e9e14a558f8ab-3d16e494554mr5686395ab.8.1739206496700;
        Mon, 10 Feb 2025 08:54:56 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ecdb903a89sm1796514173.70.2025.02.10.08.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2025 08:54:55 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, Bartosz Golaszewski <brgl@bgdev.pl>, 
 Gaurav Kashyap <quic_gaurkash@quicinc.com>, 
 Eric Biggers <ebiggers@kernel.org>
Cc: linux-fscrypt@vger.kernel.org, linux-mmc@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, 
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
 Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20250204060041.409950-1-ebiggers@kernel.org>
References: <20250204060041.409950-1-ebiggers@kernel.org>
Subject: Re: (subset) [PATCH v11 0/7] Support for hardware-wrapped inline
 encryption keys
Message-Id: <173920649542.40307.8847368467858129326.b4-ty@kernel.dk>
Date: Mon, 10 Feb 2025 09:54:55 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Mon, 03 Feb 2025 22:00:34 -0800, Eric Biggers wrote:
> This patchset is based on v6.14-rc1 and is also available at:
> 
>     git fetch https://git.kernel.org/pub/scm/fs/fscrypt/linux.git wrapped-keys-v11
> 
> This patchset adds support for hardware-wrapped inline encryption keys,
> a security feature supported by some SoCs.  It adds the block and
> fscrypt framework for the feature as well as support for it with UFS on
> Qualcomm SoCs.
> 
> [...]

Applied, thanks!

[1/7] blk-crypto: add basic hardware-wrapped key support
      commit: ebc4176551cdd021d02f4d2ed734e7b65e44442a
[2/7] blk-crypto: show supported key types in sysfs
      commit: e35fde43e25ad725d27315992fba8088d1210b01
[3/7] blk-crypto: add ioctls to create and prepare hardware-wrapped keys
      commit: 1ebd4a3c095cd538d3c1c7c12738ef47d8e71f96

Best regards,
-- 
Jens Axboe



