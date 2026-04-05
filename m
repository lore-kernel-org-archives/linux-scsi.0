Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00CD3112AB
	for <linux-scsi@vger.kernel.org>; Sun,  5 Apr 2026 11:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775388589; cv=pass; b=ujCA8MtENCeOBzhZIV/JDKpjrUc/ypJL5UbzoutEoOwEqK9yFbl/pfhsTHhzhWA1oCK7Kc1bmcRq+2FOm3qhIjHXEGm4qmOX9+jxqqn4e7/it5X6P9kztHeG/BIcsLaoQiJk3Q0QMnWAwQPBteZOcSnN6zmqWkAr47J63wsiU8Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775388589; c=relaxed/simple;
	bh=DvF0YtJZCPbcobMdQgE3+ZNHa9Fjrq28Jh3rCZ4Bn5k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GX7Ee4bIFSqfpsACEy12Wwtlg5Z0/yQHJUlwwUK/UkGzqZuRXtydvfwaANRniAEUnYSi9PPhZ8kptmbgVp88NZs46cE7nMCTR8KC+4v4jqPfuAaznzR//gFIcTZrCyd5YQAeounRNtOXMpDux/W38axB915hN9uxwaR2jHVC7h0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pE95XAwt; arc=pass smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pE95XAwt"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-66e8cc714fbso1645585a12.0
        for <linux-scsi@vger.kernel.org>; Sun, 05 Apr 2026 04:29:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775388586; cv=none;
        d=google.com; s=arc-20240605;
        b=QLoc/h7ceozQu1ZgXr4tUdPRa/Z65ncIufXxjC/c4aVOLJ2m/+ANxkHSd/b55m4xk2
         8ns9TJ6lp3Q2SXO3cQ1v97tDP9KgkYh2t77J8m2avQoy3/Lw5elso+qbranWiNySx3z8
         GA6yZ8P1KG33Myjb7E1cqYS9yrXFU7gwwNeTsH0E3GZdLnV0VBcvub2fnykllaMOPoe4
         eShJsMEwHO/Ah9gD0gfrZRfycHqkDKfyE77hrPMuhaHBp20StJBoxSByZxqBwNUbplF7
         l3MprMBh6/b9tW8QZ4u7Jx+2NSZImc9HJkJml1bU3Nio5g5s75p7TDx7GP1EITvQSG2d
         EM0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=DvF0YtJZCPbcobMdQgE3+ZNHa9Fjrq28Jh3rCZ4Bn5k=;
        fh=c3P15FP9UiJxOAs+I1q3FbZ6wk1pRlWkPHeNKjLdFpo=;
        b=Ed+LzSn1fReDwI1vnEOSGFW+bkFOyk1YQCHjav1CqC38XHNF0pmotfbBvLhkUO0J7a
         a+dF8uOenS2NVPybgg5ICqX2mS6/ij1dmNjzs3jScQLc78KekZ8X6J18deUBOQtcSYJk
         2TZHAP9DKeAkhcptNGCkD+OWT3lljqldXuNQaKUEbGERyn0JmVVsJ1haR3EWgs0aF257
         cmrjzZpuK30QLQ6xssAyRV6FtkkrZcwgzl3TLaWTbhOizrS5O62bxDT5T9/f3aaOoYB3
         gf6sAieF8uYIybgjdsSaK2BUxDeHYjJjbjjYqHsKo2oUWJvX2wTmdEAhsbWiQUWZO0e6
         FuAA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775388586; x=1775993386; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DvF0YtJZCPbcobMdQgE3+ZNHa9Fjrq28Jh3rCZ4Bn5k=;
        b=pE95XAwtwxOXbJ/Z4BDWhFnqXZrLB7gEIp1M05dFOC8azSmLghypBFD5OslO0PS7iS
         qYaDO+CqoNPe9bcUOOB6BRcQUrEiD840y906gHgC+wR+Vjfydyjm6mi9YuKMb9G8HW1P
         fw/zKydgp9y0OPidnEyJO6UZLps8f2OirwXkwWcexuUhdMRpAX6W+704jzNBCaWj0l9b
         GvEo3aOywqVu6erIrdla4764jBFkKpPF0klBbJlTVqnE8pi+rdy3A/cUV33MuJYQy7Tq
         8CiMVHKDMjDrVvCVjYpEw6UJpYwuWBUwdT6GS7A98SAYwaB61Lmw4vS7EpkfxyTsxQkH
         qCLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775388586; x=1775993386;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DvF0YtJZCPbcobMdQgE3+ZNHa9Fjrq28Jh3rCZ4Bn5k=;
        b=QN/9FMGRGkDdyO0cx4zqaTiWKUmFAndWcy3MWEbtCtHewUKbgTOP7GFuQeT8ZKEJBH
         P3Dpjp7cyg7QWal+vP3NQedUQ12uLFAwY7tC/daBjhUmOWNjxXvrSwEqF/r7HL4tp428
         /YaDB1XpJljaVP6VOZPDXHmdu5YoWJbHEhu8ihzIIE1jq0iOjxYcWf3fJD7gXD6VEwJp
         wrO7L3zZO/1oAvJvMxR15Cb5aMq4RFY4a3xctpYFYsh1dTfex8M2jdQmezg6fSR2lgiV
         TBN+MNZAeOPPXusaiWvDWb7JwssEjHrNRFoORXMvERb7nldIly3K9P2GUHbLvEAxq3NL
         tdzQ==
X-Forwarded-Encrypted: i=1; AJvYcCVXoYsA7ISO0VyP2zMUcB5XOBwL4LU+BDCmntVHNmEJGu3SZjk2Qf+QfzCaWwSCsIG1OlGLjBJ4Pt06@vger.kernel.org
X-Gm-Message-State: AOJu0YxXquHF6Lbq1vr/n+yQI2IETIRwi0MzkEGmOL3IUVrrLjyR4NuM
	iglK3aNud4U+BmAJS6vKe1V2n+c9MhihH2F+0FhMBf8Gx/duif6iEkcVw15luUrzWxoq7cOgJZO
	Jo2uMXfHnrC2wMHfB/2VCqqBfpzYJ5g==
X-Gm-Gg: AeBDieu+A/996c3KxUMQYzDQyETw0IEHjXZUlhZGraLSejNT7gB6yNuVYl45j33J9WU
	gtTsov3+K9/7GBFeq0R4mNhLlnKzZ5Qg+246sHjNok/0KwffcYIBW+yno50Gctzkz2djACTlsxT
	ZKnE2g0P0KNiS+T+srafjfp4uzNNUcWU+I20cAhaGUy2cZ7RgR+7kAd4XKnz81ShC9noGBluwly
	tau1DCok2/O2fuy4rDY5tnpiaa8cDKDgB7xtNMyPHTqHTx9oH2UiVb2aQbNX0Jf+V5i1RMvxNJE
	vX897KOl3d7ZYtPwB7c0tckio82D6w0AajnLpm/3O0jVodQkyrIIR+BNUfHKusiFxu86GQ==
X-Received: by 2002:a05:6402:3593:b0:66c:204:5d05 with SMTP id
 4fb4d7f45d1cf-66e3eeded1dmr4265550a12.4.1775388586173; Sun, 05 Apr 2026
 04:29:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260403194109.2255933-1-csander@purestorage.com> <20260403194109.2255933-5-csander@purestorage.com>
In-Reply-To: <20260403194109.2255933-5-csander@purestorage.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Sun, 5 Apr 2026 16:59:07 +0530
X-Gm-Features: AQROBzCtWGel72grOiSfI-Erz5HUztph0xDvnagBcgqetrQpIdqD-KiXs-24Oas
Message-ID: <CACzX3AtoogGGYdJVhbea55+XfAuQLd4BVzsjwp9Q2R5_SugDHA@mail.gmail.com>
Subject: Re: [PATCH 4/6] bio-integrity-fs: use integrity interval instead of
 sector as seed
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	Chaitanya Kulkarni <kch@nvidia.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Looks ok to me.
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
