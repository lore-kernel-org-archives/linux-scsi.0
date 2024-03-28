Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DC3130AC8
	for <linux-scsi@vger.kernel.org>; Thu, 28 Mar 2024 23:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711667127; cv=none; b=k5h1euZcv8rivMvMKWfotCuS43kaA2xx0mpJU1e0BiE4o+c9y8eFS2Cb1GIKWYgC7o9U/eeqO8e3dXdu1a/ipE9iRtEWE0wFG8HrUhv7kOLKhMFPQ6DGqtvSW8MdJvC0uvJCxhH6zcMAjmfT/+czoH73DOSkbk/GR64PnfOK5xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711667127; c=relaxed/simple;
	bh=RR1NsxYBYOM1Y/zktRAsa3HBsBJLbkk3BP9brZN7qiU=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=OnWz9vFWQnTSVRP5KvE73VMWQ9XeJeE8c/fWosrJw8aqyCeTNCOT2F6FXtqt/b6ny2kIS1Gh3XUoTvx7zOIxzW7yySgB7N/CgGFRjgss8mVED9Hxvuc7cRFBj4uYIzlPs0YVXFsfsR/KWA5CSYlqlmObTrqv2swPhYhaKZlJCPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HC5F4SHx; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HC5F4SHx"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1dde367a10aso2501845ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 28 Mar 2024 16:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711667126; x=1712271926; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jH6cSamYqu9y6NrHpddafX7jLWVjJSO+MIjSmesZ7SQ=;
        b=HC5F4SHx0PVrsYo9NkvV3tOhpzQfQ4P5rknALL4vGdDJRSmsFTwMF6JFKTtt5/wd8S
         VfawKGUJor73v9387DxzGorNIXB8GVXMETbUz4XKsS+4Qjqr+Sdwx1XoHzm0sdg5vYFX
         pDpydocDNalgAf0jbCnsNVTPxQmYbIa2iIQr9MCKkr6x7XeQD4QjXalNFpxbr8Dd/Z4w
         S07K0idKD40g+9unlGMldfJi4NuHWgZamPB7Y4pH24E5LHqlDfbc/UY5EH7rnEfSy1cg
         4pD+d2H4u0JU2idy3Gm4eQ4vqTwJ+LUmsMKQvfwnPxHzuRe59/uQjn0QrM3jomJvY1DG
         qwuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711667126; x=1712271926;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jH6cSamYqu9y6NrHpddafX7jLWVjJSO+MIjSmesZ7SQ=;
        b=G5Ab9+o/ieDiili9dEHtpyGYMIDUOq9n1o5PXCpxD7oju/+DwtYCOK3bjOTCAoW3Dv
         sNoQeHvi0Ds5Ici8AvPEhH8nRaI0nA75CiAghs1lNiAZvh1C0kwzEuTdZmCKsH7LAMPW
         pBTsSKfx+PBHZRVYaVaJ66wkO514W7WWujaGv6xlwWYHAp3VovovujBqrUpDG+z/T/oh
         4DW9kqCWy1Gi4hOsT/e6NuTmyrkAKBsaTKb5H1XQQpLLjmoC0efNXVTdGJk8rOaWMfA2
         f8SVcd/JczLRRQJmRnrSksOn9WwcqfS6XnuxIlh2BfXjrTGh2x+++cVQZa4GCC3m3xeK
         5iVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWVeGFQ7+7CGKn1Wf+GsdcxfV0QocLkSDXqQfhmI6b+JOc7CeOllWaFf87inTMrCaRo9qJnFOmuNBoQk+K+yhTcWy/0ojlKh6G73w==
X-Gm-Message-State: AOJu0YzRB2m4LT0AOMLbSrNVJe/Px9UL65IzSL0XD8PH4Rb2KHuQP8M2
	w/T5McXQs/Q7+XeJymnsQmd5zyZNig42oDIGeEwA4Wx/VksOWy/cZBlulrOyHok=
X-Google-Smtp-Source: AGHT+IFz2PM05uHbkjHCxEwx7ITQmcuHmP+Q9onJ6IDFb8FdZ5M8mwUFVEVXNdLv1bOXS14zB6XpZg==
X-Received: by 2002:a17:90a:77cb:b0:29c:7487:43b8 with SMTP id e11-20020a17090a77cb00b0029c748743b8mr839839pjs.1.1711667125810;
        Thu, 28 Mar 2024 16:05:25 -0700 (PDT)
Received: from [127.0.0.1] ([50.234.116.5])
        by smtp.gmail.com with ESMTPSA id cx18-20020a17090afd9200b0029d7e7b7b41sm4013902pjb.33.2024.03.28.16.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 16:05:24 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, 
 "Martin K . Petersen" <martin.petersen@oracle.com>, 
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>, 
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>, 
 Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>
In-Reply-To: <20240328004409.594888-1-dlemoal@kernel.org>
References: <20240328004409.594888-1-dlemoal@kernel.org>
Subject: Re: (subset) [PATCH v3 00/30] Zone write plugging
Message-Id: <171166712406.796545.15002324421306835511.b4-ty@kernel.dk>
Date: Thu, 28 Mar 2024 17:05:24 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Thu, 28 Mar 2024 09:43:39 +0900, Damien Le Moal wrote:
> The patch series introduces zone write plugging (ZWP) as the new
> mechanism to control the ordering of writes to zoned block devices.
> ZWP replaces zone write locking (ZWL) which is implemented only by
> mq-deadline today. ZWP also allows emulating zone append operations
> using regular writes for zoned devices that do not natively support this
> operation (e.g. SMR HDDs). This patch series removes the scsi disk
> driver and device mapper zone append emulation to use ZWP emulation.
> 
> [...]

Applied, thanks!

[01/30] block: Do not force full zone append completion in req_bio_endio()
        commit: 55251fbdf0146c252ceff146a1bb145546f3e034

Best regards,
-- 
Jens Axboe



