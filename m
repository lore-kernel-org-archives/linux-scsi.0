Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584252032A
	for <linux-scsi@vger.kernel.org>; Fri, 14 Jun 2024 16:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718382224; cv=none; b=nlguE+qbQQivyBzvZ0lkaf1zmhs4mzT/bL8Vbsa7+d00/vAptjuYBcH6WZPSi4KbpQ0jnOyZFCIMp4R/665wam6vkBiOVkTDQcW6W2ZsdvDrl4er5QfZawcHO5g3ezm9b6pWl5ysL07rwrRK9ZxmQ+ElHvb4Z/x0Uyg80AbUnhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718382224; c=relaxed/simple;
	bh=HZ41Gql5aJt7BwrUTWs3sJtFjMM4tWyXduNZXZ8PxKM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=I55ou+jKft4GP753WIqCVQ2JYM1212ql4Q2vSFg6d+sfGmMYyzOq9UEC34gOY3Td25Pt1NZy1d8V+6RUkncqvl3WFie1WvnBlcPptdxv59BVpatH0v1SHxuz0awzaMjsQybg1mXzsZP8PiXPth+sLvIdOkcoHskZ/Dj2usYf6kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fnn26j4m; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fnn26j4m"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2c2d2534c51so399593a91.3
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jun 2024 09:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718382222; x=1718987022; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qOsdq+Rd2jD/oYTlQL4Vcr47c5ELyE1/1jwJx8ny+zc=;
        b=fnn26j4m9gsLVxX2s6BtefQmg0/n12mcjasgx23uaFOh/aFQkIpoxGihTUJFFNWqVq
         9ZFyNU3d7HkS7zXJWhdkONUF4IieHmjaD/6mb2vwROebWk3ABbWmzt8uX8/XM2fPyPTJ
         WH0LZL0V1DsS22J0q5zm4+Y88L349yMyk/4DLG+Ehjsh+P4To0rc5KuDPYJuAnmMC24s
         47siZyE2YLHxyi6e+WC9yZEzuSXvloXn2SYcqB9506Zc3qxq/kWtIGSzaSfhBB7vHs+8
         iQf/dPj40UnzYbQ7sh70oFkiB8aMP0jo/Kl2abZDK4QP2himYi2of6FNTtpXwUSyEKlG
         2OXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718382222; x=1718987022;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qOsdq+Rd2jD/oYTlQL4Vcr47c5ELyE1/1jwJx8ny+zc=;
        b=nnQOBakXzep6n0VPvx8H0yRtTrmmb/j6gRgBCEzKwWdKD4Mm+cheBlmzGNiJuS92ex
         TFfF7L+3dZVlFgtVxa1m3NI5TEQJYb8pcMteVd0E54GOT7cT7nIVpya3V62zysSgfKmM
         25OLIsSkaQJw02jrbKcB7aqokUcEs98snrV8yersIfOUVanShBlZ2jEuDGq9KKpJdVUV
         KQfFVy9ypVTTNnmTtyEQqLJwrSaGgCrtYFLweVZcJKu4NOL3TSAqlwkwwUxd+ckzmaXC
         SKBPHRQPIpdUQTDOu+wSQNhadE5XSSM8dmUX9fQ1uaIDKIdymHztpL1q183cfqkzwtMu
         Y5GA==
X-Forwarded-Encrypted: i=1; AJvYcCU/MhvpsdQV7wcoDL0GfG1SHTchZTmrAWPsqkhZ0Tj9YTl5UHTN6HhJeVHWdK+ipg750rm+GnByLjF1jpb7XNUqntkI6Wdvy9Itdw==
X-Gm-Message-State: AOJu0YzpgRNXLyNlUyQ0Ob+fWDgMYeyuiqsmjEr2iZwUfAd8BQIYYIKv
	AjNxEu1L0LX9k9zjWbWooReiaBpokrdFhAnrRihM3PjGrwJ8/r7pnqFoRApCN8E=
X-Google-Smtp-Source: AGHT+IFzZlkOeh7ub8gHV6v3rJ7EdBnks7HtbNFvAppAM0NMs6uCGvh3Ey3eFD0Th7n1FGRILE+Uqw==
X-Received: by 2002:a17:90a:d313:b0:2c4:da09:e29 with SMTP id 98e67ed59e1d1-2c4dbd431cbmr3209949a91.3.1718382222558;
        Fri, 14 Jun 2024 09:23:42 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c4c46701absm4112038a91.40.2024.06.14.09.23.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jun 2024 09:23:42 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Christoph Hellwig <hch@lst.de>
Cc: Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Josef Bacik <josef@toxicpanda.com>, Ilya Dryomov <idryomov@gmail.com>, 
 Dongsheng Yang <dongsheng.yang@easystack.cn>, 
 =?utf-8?q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>, 
 linux-um@lists.infradead.org, linux-block@vger.kernel.org, 
 nbd@other.debian.org, ceph-devel@vger.kernel.org, 
 xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org
In-Reply-To: <20240531074837.1648501-1-hch@lst.de>
References: <20240531074837.1648501-1-hch@lst.de>
Subject: Re: convert the SCSI ULDs to the atomic queue limits API v2
Message-Id: <171838222101.240089.17677804682941719694.b4-ty@kernel.dk>
Date: Fri, 14 Jun 2024 10:23:41 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.0-rc0


On Fri, 31 May 2024 09:47:55 +0200, Christoph Hellwig wrote:
> this series converts the SCSI upper level drivers to the atomic queue
> limits API.
> 
> The first patch is a bug fix for ubd that later patches depend on and
> might be worth picking up for 6.10.
> 
> The second patch changes the max_sectors calculation to take the optimal
> I/O size into account so that sd, nbd and rbd don't have to mess with
> the user max_sector value.  I'd love to see a careful review from the
> nbd and rbd maintainers for this one!
> 
> [...]

Applied, thanks!

[01/14] ubd: refactor the interrupt handler
        commit: 5db755fbb1a0de4a4cfd5d5edfaa19853b9c56e6
[02/14] ubd: untagle discard vs write zeroes not support handling
        commit: 31ade7d4fdcf382beb8cb229a1f5d77e0f239672
[03/14] rbd: increase io_opt again
        commit: a00d4bfce7c6d7fa4712b8133ec195c9bd142ae6
[04/14] block: take io_opt and io_min into account for max_sectors
        commit: a23634644afc2f7c1bac98776440a1f3b161819e
[05/14] sd: simplify the ZBC case in provisioning_mode_store
        commit: b3491b0db165c0cbe25874da66d97652c03db654
[06/14] sd: add a sd_disable_discard helper
        commit: b0dadb86a90bd5a7b723f9d3a6cf69da9b596496
[07/14] sd: add a sd_disable_write_same helper
        commit: 9972b8ce0d4ba373901bdd1e15e4de58fcd7f662
[08/14] sd: simplify the disable case in sd_config_discard
        commit: d15b9bd42cd3b2077812d4bf32f532a9bd5c4914
[09/14] sd: factor out a sd_discard_mode helper
        commit: f1e8185fc12c699c3abf4f39b1ff5d7793da3a95
[10/14] sd: cleanup zoned queue limits initialization
        commit: 9c1d339a1bf45f4d3a2e77bbf24b0ec51f02551c
[11/14] sd: convert to the atomic queue limits API
        commit: 804e498e0496d889090f32f812b5ce1a4f2aa63e
[12/14] sr: convert to the atomic queue limits API
        commit: 969f17e10f5b732c05186ee0126c8a08166d0cda
[13/14] block: remove unused queue limits API
        commit: 1652b0bafeaa8281ca9a805d81e13d7647bd2f44
[14/14] block: add special APIs for run-time disabling of discard and friends
        commit: 73e3715ed14844067c5c598e72777641004a7f60

Best regards,
-- 
Jens Axboe



