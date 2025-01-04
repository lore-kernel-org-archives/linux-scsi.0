Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419D6170A0B
	for <linux-scsi@vger.kernel.org>; Sat,  4 Jan 2025 22:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736029677; cv=none; b=WoQ/6NHMSjmkSJqu6IKyUBWvR8qT6dSEQHzGMuCI6cuPiAB2xqcPXB+n7s4JtiGnEIgURrJTXv9ttIKOKQNpiE028omS/mtVNW+TB6QJi19MgNl9epOJ611JwgSsFf99mBP6IqA4xqEk2f8HuORJ3Mc/J57eT0zTf6hfOiG62c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736029677; c=relaxed/simple;
	bh=dbW9sZ4K4CVni2WzfS5PIhq9YPepuP+wgQlHyfd4Js0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=AzUamZQwhRj6doGi9CUHqYcSC1NuAUJS0pwzq60U0quoznnOGT5KSWE2MUFJeCiT9t4dS9ButwBBwC+SxbtRqxdvchQtdH8/IU8gH3PTKnaJ0WFBVaSrmPqbqWTHD9jenAifmIcW855i1pZJyBMjSgpnFdGWVAA8sBq8GixQgZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xoYooiqn; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xoYooiqn"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-21628b3fe7dso181622535ad.3
        for <linux-scsi@vger.kernel.org>; Sat, 04 Jan 2025 14:27:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736029674; x=1736634474; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ydW0TG4z7XBo7HBBH7ij90+wnNI4JxxB1fs88STRyos=;
        b=xoYooiqnsEbhRX7oNLMe+4zSKtiFsQwy8/aciLwR5MW3a6ReCHKk8eZipkbBAx9V5X
         mHYHz7rcg1tUUyQ6Yqf8fi4GmvZcQbh2o/byeXJiT0EvxL88mAJvZ4zYPx1HaVPufL7z
         572+GXzuEpX+yVbDLRp7jRi3O7IR9AIjcCmnmNqZfHWp63qdaBqFhhGUDljGkfj03OLr
         DqFHc7rwsLT3E2pTPGVxrCl6xKYiB53u2lFSVi1L84K1Cnl0XM6YKWhHZ3wy1+h7Y6mQ
         /+5vIRZlags29GTRIJ+fRIdig73iwZHSd2gEIkrp7K+yhrt6woslPZ5YYeER5UNv6UHS
         aOdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736029674; x=1736634474;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ydW0TG4z7XBo7HBBH7ij90+wnNI4JxxB1fs88STRyos=;
        b=FkDhjpfp0hmLRoVZFqdTgMe+2z6UAjpkMcBj/JR9joYlPrccu2GdTddMx7Zwqc6ivu
         zrNH5ltxnCBbh+an8VScrOepqO35zgGwAx3eWuvoHahIlvwiawqnl5QpyfVDrESpw3sC
         UJaDP1g4QWoRc1v2SbYyLMUL4ENbhDMJUw03ldAw5nzlp23pSh8ZYOvXNmCqjo6kQFEp
         amTvza5WXJnX5DBwCfBqKpH4Kv2FpuCY3amGygzSWbs0YW756HUJz/jfECDYfzTG/qg8
         xDS9JKiHgsaWZ+tb3SsXxhKS1E8NFEk3jMrHvNfr0bZ5xcjwYigL9yeazh4cvqZXYm4t
         2Cog==
X-Forwarded-Encrypted: i=1; AJvYcCWUgDT3ihy1u9317ADR7y++HUV07nP3CqIovx2Xxc2xVBYhfdjst7hz5DY8+PXQFnU2Tzv1tYXbpR3C@vger.kernel.org
X-Gm-Message-State: AOJu0YwL4TjLARUiUA2CijwoNpJzQSXn/YDAv6MXBCJpJu8O8yJJ7QUE
	7TBcEf7bBA4wMHj4yEwsogeSPd6Ph5cb9i6W1AZBceWpna+oQbyRp887NTGQaeH+q6RIw5XAZ1V
	W
X-Gm-Gg: ASbGnctwrLUjDc+GseldbgyKDeRTPj8K4fBQW9E5XqP2yGWHG43A2GZAT7DqWfWLFIj
	q9eODg5vaQ5ulc9/gh/xQMAJg70zxII9pBser/YaYRnKHhVrSfggfLgNEibD/GRZ1vukqNrXznN
	SBFsxlcm99o+yZOtznwlO5WlRx559xfTafeMpO8O5jnlPL4C5Q9k1silSviUi5quMqS6ciUBFDv
	tPsrbBxjrFDD3Ms+hpZDWV/56+SUPxmEH5c18ZGHBo0JpfT
X-Google-Smtp-Source: AGHT+IF+L+86xLxNKDCy3NJpJ1Whra//RstFOL/I1FY0ppQLvIlzdnb8Hv8hv/Dxi+bSvhcBNsb4Ww==
X-Received: by 2002:a05:6a20:6f06:b0:1e1:b014:aec9 with SMTP id adf61e73a8af0-1e5e080c77fmr83798682637.29.1736029674019;
        Sat, 04 Jan 2025 14:27:54 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad81641esm28451472b3a.3.2025.01.04.14.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jan 2025 14:27:53 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20250103073417.459715-1-hch@lst.de>
References: <20250103073417.459715-1-hch@lst.de>
Subject: Re: simplify passthrough bio handling
Message-Id: <173602967287.135972.1134077263108813311.b4-ty@kernel.dk>
Date: Sat, 04 Jan 2025 15:27:52 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Fri, 03 Jan 2025 08:33:56 +0100, Christoph Hellwig wrote:
> this series removes the special casing when adding pages to passthrough
> bios in favor of simply checking that they match the queue limits once
> before submissions.  This mirrors where the zone append users have been
> moving and a recent doing the same for a single optimizes passthrough
> user.
> 
> Diffstat:
>  block/bio.c                        |  107 +-----------------------------
>  block/blk-map.c                    |  128 ++++++++++---------------------------
>  block/blk-mq.c                     |    4 -
>  block/blk.h                        |    8 --
>  drivers/nvme/target/passthru.c     |   18 +++--
>  drivers/nvme/target/zns.c          |    3
>  drivers/target/target_core_pscsi.c |    6 -
>  include/linux/bio.h                |    2
>  include/linux/blk-mq.h             |    8 --
>  9 files changed, 57 insertions(+), 227 deletions(-)
> 
> [...]

Applied, thanks!

[1/2] block: remove bio_add_pc_page
      commit: 6aeb4f836480617be472de767c4cb09c1060a067
[2/2] block: remove blk_rq_bio_prep
      commit: 02ee5d69e3baf2796ba75b928fcbc9cf7884c5e9

Best regards,
-- 
Jens Axboe



