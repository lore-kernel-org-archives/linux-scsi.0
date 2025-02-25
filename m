Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B075920F08F
	for <linux-scsi@vger.kernel.org>; Tue, 25 Feb 2025 20:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740515443; cv=none; b=sTmTAWfJvU5uVfqWUnQacVZ3acXHhZKyOr1MF3vdqbeDv3EaZxHb4trE/n6sW++lr6Pne7b3RRhlIlUzYwGP+Daf8AtIx7sDusFaGTrBWTufylM0bQrXIncaKdUcwAnBr8hsaaJE4FnrtiuO9WxlPMxJFENIvd7FU02b5JfHLoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740515443; c=relaxed/simple;
	bh=2mVGB3ONfKEx7GJ+S6y95LCKLGj9XhJhILt75fQVfOw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Bra3v/73L7ymHO9qXqaFivGv0Eug6gMIwSkjeX2HGd2p7Qs5I3dEb4GCQX2VFAGgYq+/95Kpg4cgtEIM7wejlZbXkS4TSncun4C1/hFabuJZb9qffhG53eAnQs5+24ihE0BTaqzex6FxI+xckXA5X8pEeuDtE9JKfGFj83htfEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QDk/Ac62; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QDk/Ac62"
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-855a095094fso164914739f.1
        for <linux-scsi@vger.kernel.org>; Tue, 25 Feb 2025 12:30:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740515440; x=1741120240; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pLp9Ea62UroP9Hu5zCjkj8kz5zOw20u3Q4aJrEzL0tk=;
        b=QDk/Ac62IhNXGzKqngYdxZCSXbG5x8xmDSsbPgHkPXGRGhqIjqDGUiGjOIbLEotfcn
         se3HyG1DX3SZks3sHjaY6okoeRFvBB28UNNWCtKlmSS+QyAwGicvJqcauIZFVZXiYKQU
         GgzXL1VOQXUMriHNRAZrFoShny2wIC/1+jmbs9w9ym9u1Gc8Z0PCpMhRpodbcGwM+P4G
         uwqOS3GH+wGHNc+y/i6iy5FR0l3xZ4BM2o5/R3ldtNz9Ln85GoYjxESZTB5rcK8ul0rU
         mXkT0l3LrxssCkjCIwxLzbEHfq1DkRgLLy3fvpgeykTgkFbAUQqMwfGga9Lhpd3vXWDD
         W+JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740515440; x=1741120240;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pLp9Ea62UroP9Hu5zCjkj8kz5zOw20u3Q4aJrEzL0tk=;
        b=aIvC1RmeDTNFWOsPdREEgXekL21aQu9tB/A/aGpHAjlaZj5Ip27JXRDgoa+Q8rTzKF
         jCcqejfwtd7oNmmX74xFjVgsaSNo6yq9f0nlwMQmcT7c3ozwrLH0UBKqTlspgwsg8jdf
         /pDPpVuTrx1RCf96/DsHeNmprOIvB3TA9zSSctefHN7PqK+PTypLXXQ989WTS9YScBjq
         Mw1gtl/NxosvYlj8VZozmcDua90nkyka9GOz8Tvd3IjLauZRrRHSAPjte28vkekekDPX
         3V9/80s/rExNkUmMQ6tk7AjX0QFDI/Ao3evvAHmIyjogaKqZiNjko4JK6mBINgf+FTo5
         oMow==
X-Forwarded-Encrypted: i=1; AJvYcCUyK8WIx34Sp9OVhIwLJtbajztrt/CbOfr1eWG1QQpl9Dt76zsO/HVcgMIL9zypjGFhjhoA+1+PpTQv@vger.kernel.org
X-Gm-Message-State: AOJu0YxN4HnD3Cjyye1C8y36al7RFdRnXFAUR+gdHsQDZSbKSjEO/oku
	+uxoIrUbTsKlGNKL6IYabbCKwTPhJAIo4nLEEXSZUaXlkSECEPdp4HbSdTHUcHs=
X-Gm-Gg: ASbGnctTcttPPC1SNgoHsZTKM9QW0qJZLbazxx7GuVBvQ7umxwf1BGJ5a4GCR9r5aoV
	vO4zrVQy16Fvws6pq1+fcyF1CuMSbYglCupoomjIv1h8HXKh8e+mjcZU+Gwg3P008xkX5tkZR1j
	E35O0MSlqMGgXT3fGt4wahWlN50i9G4iT286PKPxZxF9QAvYhIU1ghbL6V/llSjs5WVh6SkmC8U
	atWPacysJpCKDtPn4v6aWrV4iqGE8y/iozV1MiJJs249C3nGd3sApzLoii9ogibB4DbhNewFppj
	QJ7VJLZhdJcp0C1H
X-Google-Smtp-Source: AGHT+IEI1HpA9fGHJ1GdkYmfu92FscKbuH3o9L2lVKiqa4D5puwjeIXVc4djLm6mFSVg2XH039gtQg==
X-Received: by 2002:a05:6e02:b2a:b0:3d1:968a:6d46 with SMTP id e9e14a558f8ab-3d3d1f40415mr9808255ab.6.1740515439644;
        Tue, 25 Feb 2025 12:30:39 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d361ca3896sm4764255ab.53.2025.02.25.12.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 12:30:38 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Yaron Avizrat <yaron.avizrat@intel.com>, Oded Gabbay <ogabbay@kernel.org>, 
 Julia Lawall <Julia.Lawall@inria.fr>, Nicolas Palix <nicolas.palix@imag.fr>, 
 James Smart <james.smart@broadcom.com>, 
 Dick Kennedy <dick.kennedy@broadcom.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
 Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, 
 David Sterba <dsterba@suse.com>, Ilya Dryomov <idryomov@gmail.com>, 
 Dongsheng Yang <dongsheng.yang@easystack.cn>, Xiubo Li <xiubli@redhat.com>, 
 Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>, 
 Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
 Sebastian Reichel <sre@kernel.org>, Keith Busch <kbusch@kernel.org>, 
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
 Frank Li <Frank.Li@nxp.com>, Mark Brown <broonie@kernel.org>, 
 Shawn Guo <shawnguo@kernel.org>, Sascha Hauer <s.hauer@pengutronix.de>, 
 Pengutronix Kernel Team <kernel@pengutronix.de>, 
 Fabio Estevam <festevam@gmail.com>, 
 Shyam Sundar S K <Shyam-sundar.S-k@amd.com>, 
 Hans de Goede <hdegoede@redhat.com>, 
 =?utf-8?q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
 Henrique de Moraes Holschuh <hmh@hmh.eng.br>, 
 Selvin Xavier <selvin.xavier@broadcom.com>, 
 Kalesh AP <kalesh-anakkur.purayil@broadcom.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
 Easwar Hariharan <eahariha@linux.microsoft.com>
Cc: cocci@inria.fr, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linux-sound@vger.kernel.org, linux-btrfs@vger.kernel.org, 
 ceph-devel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-ide@vger.kernel.org, linux-xfs@vger.kernel.org, 
 linux-pm@vger.kernel.org, linux-nvme@lists.infradead.org, 
 linux-spi@vger.kernel.org, imx@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, platform-driver-x86@vger.kernel.org, 
 ibm-acpi-devel@lists.sourceforge.net, linux-rdma@vger.kernel.org, 
 Takashi Iwai <tiwai@suse.de>, Carlos Maiolino <cmaiolino@redhat.com>
In-Reply-To: <20250225-converge-secs-to-jiffies-part-two-v3-0-a43967e36c88@linux.microsoft.com>
References: <20250225-converge-secs-to-jiffies-part-two-v3-0-a43967e36c88@linux.microsoft.com>
Subject: Re: (subset) [PATCH v3 00/16] Converge on using secs_to_jiffies()
 part two
Message-Id: <174051543709.2186691.13969880655903967909.b4-ty@kernel.dk>
Date: Tue, 25 Feb 2025 13:30:37 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-94c79


On Tue, 25 Feb 2025 20:17:14 +0000, Easwar Hariharan wrote:
> This is the second series (part 1*) that converts users of msecs_to_jiffies() that
> either use the multiply pattern of either of:
> - msecs_to_jiffies(N*1000) or
> - msecs_to_jiffies(N*MSEC_PER_SEC)
> 
> where N is a constant or an expression, to avoid the multiplication.
> 
> [...]

Applied, thanks!

[06/16] rbd: convert timeouts to secs_to_jiffies()
        commit: c02eea7eeaebd7270cb8ff09049cc7e0fc9bc8da

Best regards,
-- 
Jens Axboe



