Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214B318A94D
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2024 14:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724856684; cv=none; b=Va8nio33TrjKLOuavVEKdmEyWzBL26MGnEJ2Aw37RbIYTOe3J+Ony4hiJKBJTwVPtEtn1JhzM/D0uJeZt/BofmFNFc9bLUxbRbIJUA6q4tr5FwYJcJbsA5MKo9OlgGEtmBpAiLo7yj7/DusjhZPlMfe1YFy89mlRV3N1S4+3V2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724856684; c=relaxed/simple;
	bh=rbYF9EQE6+2l/S8qLuOSkRSe2U+4urx63JdRyvn3Tq8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Q34njC8vCsPKjUzjVtVoMShZFsSjh8FlTLFg5C4xW73QGzdEPFJMbsvH/whgBHGA1UQ/nVdkrYkAwyEM7/WRVhbdwN7UeX2VOH1UHD81+TASrS0PC1qPj3HQZrSVg5578RM/TTUX9i1zWkfoPt/ixeiaBCnvo2ToQ6RX/3J/sSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sOcWWwTu; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sOcWWwTu"
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-82784c8bca5so216238639f.0
        for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2024 07:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724856682; x=1725461482; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PkBMJ6J7tx70rz6zmOA31ER4Q+skEgbVfFZ8HyWSogA=;
        b=sOcWWwTu66gx9nBISRms8YlVMHBwqLYqwrIRtkz0p/fFg5TIgNSLV/E6qlazZZvkFJ
         3g9UrAaQKqqghTbx/pTGcy+TGSCgBTXDgnxSXTvr69SgDljLZk2nvDdDhsar5BAl62xO
         OsPvhhMxmf5NFnK2nhMXKaPAy8QIvOXalqGaL74PmW/fctcQIZ8b2AgHzVWlZz1CrSG8
         I+msLL8ImwLNcgbNn2QcQQFZe/CNjPp3qL83xPpIIyOrP4xJvM2sq99Bk16+ppxbg1Us
         /S3hW7LKOylLzrwEOdGO0YpT+RIL1UmJqDiyTHTqIQAtkvypv1a5mNJsrePCtwH2Tujr
         9GTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724856682; x=1725461482;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PkBMJ6J7tx70rz6zmOA31ER4Q+skEgbVfFZ8HyWSogA=;
        b=R/y/uYgx3xsWbfURJcRM4e22nZwdITOOoqOxs03Hs3ohPF6DqjK0Z3ZQLeXvRikfnG
         V4HojdwkELHJqE/saKBsm7n58p5AfBjkZvvYreqkOeod8Ahtx8lQUG1+y7n++/fdxwVa
         rjwMnVf5OehUo4CeopdW9MZWeIRoaxKgAMmVG2kFX56kgnqRKj87W/ZJOdHUCw7BlLSS
         f/qKf5g+SvaRcryBQ/IFFZA7hdD/BLwCtv95WmhL0M4e4L1fvnyOEdqsMlN1EPVJPjjt
         uNjhOV9hL5gwm/CFDrG/xR1fCmfkRC3nFsKrpQ59EtsGL49l23wGtW6Mra7SxaiWY1z6
         CJwA==
X-Forwarded-Encrypted: i=1; AJvYcCVQ/rzefd622VM6IiiKSNk/xX+On2Z8rglz4+Jz5rRRaJxKw5lETHPZErdTcFLJLo1dYHmO3YyWmz5z@vger.kernel.org
X-Gm-Message-State: AOJu0YyVsBSRzmyHvsr9YA+TETVgCygu0a+YKf56K8gFhDTj37MSgH5B
	+zIj6/zQrYsM9IXxoeuXlu+xr8GqS2fKPuYUwa0Tp0KvbuuGJ5FsZUi0rVC7smo=
X-Google-Smtp-Source: AGHT+IGH/sM51D0GQjar03mWbJeEot9AqwANMQY365pltcRA1L8eRTcfI+pPccqJjQxvsPbCCa2OWg==
X-Received: by 2002:a05:6602:341a:b0:7eb:7f2e:5b3a with SMTP id ca18e2360f4ac-827873116d3mr2276078039f.2.1724856682153;
        Wed, 28 Aug 2024 07:51:22 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ce70f84e20sm3092887173.84.2024.08.28.07.51.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2024 07:51:21 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, 
 linux-block <linux-block@vger.kernel.org>, linux-scsi@vger.kernel.org, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, 
 John Garry <john.g.garry@oracle.com>
In-Reply-To: <20240827175340.GB1977952@frogsfrogsfrogs>
References: <20240827175340.GB1977952@frogsfrogsfrogs>
Subject: Re: [PATCH] block: fix detection of unsupported WRITE SAME in
 blkdev_issue_write_zeroes
Message-Id: <172485668128.410120.18023172929961192707.b4-ty@kernel.dk>
Date: Wed, 28 Aug 2024 08:51:21 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1


On Tue, 27 Aug 2024 10:53:40 -0700, Darrick J. Wong wrote:
> On error, blkdev_issue_write_zeroes used to recheck the block device's
> WRITE SAME queue limits after submitting WRITE SAME bios.  As stated in
> the comment, the purpose of this was to collapse all IO errors to
> EOPNOTSUPP if the effect of issuing bios was that WRITE SAME got turned
> off in the queue limits.  Therefore, it does not make sense to reuse the
> zeroes limit that was read earlier in the function because we only care
> about the queue limit *now*, not what it was at the start of the
> function.
> 
> [...]

Applied, thanks!

[1/1] block: fix detection of unsupported WRITE SAME in blkdev_issue_write_zeroes
      (no commit info)

Best regards,
-- 
Jens Axboe



