Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C00632F774
	for <linux-scsi@vger.kernel.org>; Wed,  5 Nov 2025 15:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762357510; cv=none; b=tF6zF55l3ts8UECbDgtxZ7zrzMjb27l3olrEaaaiirIRkXbPdlWnCrvvK3ZM9laGjO7rsXpl7oO/pPVE7olNNeHjF22x367y/wme0I0sx84G7P5gmvdL4Y4vyAJEOcM05PRZKDwLTIS1q4j3lfd/gywnJrtzAB25ySqTTGEg1YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762357510; c=relaxed/simple;
	bh=vBpIbHl5BJYu3GvhFAscHMjHAct8CImIgNJ4c1z/oeA=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=a7xdwuaaEDdHjcx2qOLpMz4oU1tLm+MOJyYUywuA4wnXeiBbxjpx0fsmSd7aBv2HWNvxd0xPCoMgkbK98I21nblnW6maMrAQWYyaZLVHm1H+ztbpstOVnyjY/4BY1neSgzQo2KZ45tzEBUO42b7LO7KvqvUaYsb1CAvc2jkqjIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oXBG7qxR; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oXBG7qxR"
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-93e7c7c3d0bso663421139f.2
        for <linux-scsi@vger.kernel.org>; Wed, 05 Nov 2025 07:45:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762357507; x=1762962307; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pmEA5UIRtFUkoJTebXPiJtfqEeDxZBhUOtjCk6lwm1Q=;
        b=oXBG7qxRAgxxpjvyoxPULOa1fgROdBp/4Z8g918iu8f5OrPjl3F4GHIx5MFNTDhIAn
         pqEWO68Dj3gmQhJr7qUItHwJwG64ld8NCI3MV7bCUWXu1dZb9kfWdGjqhLEvZ479OLxd
         7WiqKEvubQDho+R74G9Dyx22NjREEAjXzpV9A8ulR2vqMXlAUzbRrF27vJeKUN9IErWH
         nS5fM8dz6irJDPhN+oXQW2NNuh/Xd+GhLhTh5UE92ErPNvWvCwMnK0USG76HfdDLNIZh
         XCRNyUDNOSW9hHsEDGFGMI7ZCsw/O3VLkbMk72QQA/atz5Zr6aL5e+7DVF1PHSDpOj60
         NUcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762357507; x=1762962307;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pmEA5UIRtFUkoJTebXPiJtfqEeDxZBhUOtjCk6lwm1Q=;
        b=YspUksETB/+U/TQtaDOCBh/JKS6dT8x2VrtILzBsj4thr13EmQiGKf5EJuZxEadMI3
         N+4zua7okzFEiMQz3QNdnIZQEGVyQ2oen5S+ch+sCTFVrEngtmRGkwabUJ7sRDbKcIMZ
         YjtMfIjTSu/q0CruP04qOBQ+ytnbszrneEtnaQvJw9Y4PlIOenK1gAfRL8ePLZxtrCu1
         SMCb9Tc+XZtIVbPpsagO7b/T+9EaIi3u5JHmBs2YWVnHI9EM+Lp8S1G2V9X+jJku9D24
         TCbTvKhlwP4bw4Jd/NI4OMIPBFiBHNcok18mgb0GWGjGi5N4EAuQjoyHWyVDWkVJpIr1
         hWhA==
X-Forwarded-Encrypted: i=1; AJvYcCVSnKNSrdIQhwW9mWDLJzV7G/7quGSCFrBh2wrBx/Qo7RZsKJ3fvlHq7LmWRdqLdLKTC1rqehd7QGr9@vger.kernel.org
X-Gm-Message-State: AOJu0YwQaufnpyMj6DRtHFDf42qTNtnuIjXJ0HY7eRHWNpegb7c3VPoa
	2MItq6gy6B2EFxnb9w3Gw0HsFaaiwEFMpwO30+AdOm/C1q8ExWItw/aiuWT7E8THlp4=
X-Gm-Gg: ASbGnctvEz9YPAA/Z/70MnfX2UQWPxswKR9Ee1CfkpZMq9HtDu6ZVmQ8x5AJAsrKiBJ
	6afixrG8thU0x4QKMfkaZbBHvL0GKKaZyeXfHH5x1L5ZJRN5ziGyp9g578b+5JtF11ZFSk2fqbI
	6CGqGR9UP/JEL5hGrFf9GDOFDLeb8qx4Ig7UU7HdjsaIpgbSdR/erSlVHSmdTMegNxW7LtVyK6C
	PZ05wZjMz6BezI/2eDUc2jmMjM+uClcNSje/GD5gIE2rJwaUFKtYAZuNLA20GTtmA8Z/zPh2zaz
	M9mqaGhEu3TeC72nQnmz24kdCId53C6g2U/qe/UMjUYXLXw2KvW4Jz3E8KmhaQpHgw3JkzKRoGI
	mGvN1Wlp468djyI6ooaIfNCxs34rf817haoDGsWUV+q8WpAna0CnjlsylIvXkCsInZVVtXqdxHV
	KXjg==
X-Google-Smtp-Source: AGHT+IGRprlY0B/j7MFC0euD5DLU4VAIhfixS9xB+G6Pb3CIfQJOwUgjuW1G2xa98UfKd2ncVWvKMA==
X-Received: by 2002:a05:6e02:1a85:b0:433:2957:2e87 with SMTP id e9e14a558f8ab-433407d98e4mr47454155ab.28.1762357507117;
        Wed, 05 Nov 2025 07:45:07 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b72258d4e8sm2521439173.3.2025.11.05.07.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 07:45:06 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
 Keith Busch <keith.busch@wdc.com>, Christoph Hellwig <hch@lst.de>, 
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 "Martin K . Petersen" <martin.petersen@oracle.com>, 
 linux-scsi@vger.kernel.org, linux-xfs@vger.kernel.org, 
 Carlos Maiolino <cem@kernel.org>, linux-btrfs@vger.kernel.org, 
 David Sterba <dsterba@suse.com>, Damien Le Moal <dlemoal@kernel.org>
In-Reply-To: <20251104212249.1075412-1-dlemoal@kernel.org>
References: <20251104212249.1075412-1-dlemoal@kernel.org>
Subject: Re: [PATCH v4 00/15] Introduce cached report zones
Message-Id: <176235750606.190479.10317258805246349798.b4-ty@kernel.dk>
Date: Wed, 05 Nov 2025 08:45:06 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Wed, 05 Nov 2025 06:22:34 +0900, Damien Le Moal wrote:
> This patch series implements a cached report zones using information
> from the block layer zone write plugs and a new zone condition tracking.
> This avoids having to execute slow report zones commands on the device
> when for instance mounting file systems, which can significantly speed
> things up, especially in setups with multiple SMR HDDs (e.g. a BTRFS
> RAID volume).
> 
> [...]

Applied, thanks!

[01/15] block: handle zone management operations completions
        commit: efae226c2ef19528ffd81d29ba0eecf1b0896ca2
[02/15] block: freeze queue when updating zone resources
        commit: bba4322e3f303b2d656e748be758320b567f046f
[03/15] block: cleanup blkdev_report_zones()
        commit: e8ecb21f081fe0cab33dc20cbe65ccbbfe615c15
[04/15] block: introduce disk_report_zone()
        commit: fdb9aed869f34d776298b3a8197909eb820e4d0d
[05/15] block: reorganize struct blk_zone_wplug
        commit: ca1a897fb266c4b23b5ecb99fe787ed18559057d
[06/15] block: use zone condition to determine conventional zones
        commit: 6e945ffb6555705cf20b1fcdc21a139911562995
[07/15] block: track zone conditions
        commit: 0bf0e2e4666822b62d7ad6473dc37fd6b377b5f1
[08/15] block: refactor blkdev_report_zones() code
        commit: 1af3f4e0c42b377f3405df498440566e3468c314
[09/15] block: introduce blkdev_get_zone_info()
        commit: f2284eec5053df271c78e687672247922bcee881
[10/15] block: introduce blkdev_report_zones_cached()
        commit: 31f0656a4ab712edf2888eabcc0664197a4a938e
[11/15] block: introduce BLKREPORTZONESV2 ioctl
        commit: b30ffcdc0c15a88f8866529d3532454e02571221
[12/15] block: improve zone_wplugs debugfs attribute output
        commit: 2b39d4a6c67d11ead8f39ec6376645d8e9d34554
[13/15] block: add zone write plug condition to debugfs zone_wplugs
        commit: 1efbbc641ef7d673059cded789b9c8a743c17c9a
[14/15] btrfs: use blkdev_report_zones_cached()
        commit: ad3c1188b401cbc0533515ba2d45396b4fa320e1
[15/15] xfs: use blkdev_report_zones_cached()
        commit: e04ccfc28252f181ea8d469d834b48e7dece65b2

Best regards,
-- 
Jens Axboe



