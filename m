Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9739136E46F
	for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2026 20:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776286147; cv=none; b=nYDZzQuQFWZHrF6O3WRADHEJVvIOxFe/JkTY91SWRjDXmQJn9BNZ8XVpoTUdxf+LyGv4KhqRmoyo46V4ke6KwhKE7KZLTmEDY0XwK3aa2tY1FvaBoSnMNk303WwSlJNtca8rUM174M5PngP0Th+Ga2hDPxlIhrv0EikIh3qFE0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776286147; c=relaxed/simple;
	bh=bHrXc70QxC7t533dxErnfdbB5KmqcTasB15Dj3VyMz8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HXBDCh6CYH7Y3vK1zhJtEbTQLOpcdXyzkIMvwP2DNB9SyBnNbOHZ7BIIrx7QYG4I3uPopvaxkyIdIjs+/OrdC6oqYzcYGzWwP5VPE0AFS+7qqKBmAkmXBx/t/ZGQBHBR68OTFTjvq6HNGl1QxDt2epTNY3e3PpdSk1u5hGR4F3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IXbn5m1r; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IXbn5m1r"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-488afb0427eso85651215e9.1
        for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2026 13:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776286144; x=1776890944; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jh4nXPsrZyvEb8I65JwFvNZZMLaz52+Yx5lfUeSZXfE=;
        b=IXbn5m1rgHdtMWuTnzOSl0Mpb0gW6lMV9JH4rgccPhLhcIDedK6ffDDXuKDuaEGZdH
         xesOGw2L7qh9v5knItkIUXry4tqaWCJ5MicPAhNDmbltErghYGA7VTSdOWTpKUIA/VEk
         qVjglBSn4ScxQyZTDU41+S3LyUv2WAWt/9iaeBqrdomApw7lLbQ+wkESQsN7iMjAfHM6
         BvF7C7J0dxqaexK8k9Qxl/0rKeqlPL0AXVGYBXW82D38Pnp1FIQj5XCLfCxue/6xPhLu
         wrnFAjqDPkVs9wWv8njNCEquU3M5kmSeERPkDkWDKBtuQJDzYsMdln9FG+usAwX3mWqZ
         Gzng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776286144; x=1776890944;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jh4nXPsrZyvEb8I65JwFvNZZMLaz52+Yx5lfUeSZXfE=;
        b=hGfsAtlOHIa1pCfbzPTlUm17wRfxy53I8xpgYT3RwupANPKP4XKg0hjA7jcg6WsFXY
         mTsZNZ79BXsgrQI+BuR8XsRQieihF4tp0Kl+KYfZj/GQ24aazhNQpS/8vKNmvL9zqc2X
         PeVMkBzITtYn9hrVEy3H7Rt7RKDzJ4s+9FTQ06WB2RopSijANGXVk9Zi/of8Pp9mX9bJ
         q91dJcNClsZt7jMBtuTHqZr1+PJopH0lH4fBpu5BDO1gzvLF5TJY1qsQL4FvKjRKG9C2
         Qxwu09aCNR8exIwstzlrqn0bo1yVQySpN3sVI297zT8pvPVpDRvUviXnFq3Vw/z559wX
         uEZA==
X-Gm-Message-State: AOJu0YzBq1fGNsmUD78tt7jc5QCvb4PrUigxG8qKMhLSg5TzNHLBPaXG
	2qyD1MFBPjdNeZ76yjSSqIFWGss0vbE4vBUMgwKYHxpZHcjonzYObMCuM8gmpKWLJJw=
X-Gm-Gg: AeBDiesqfQcykZF+Bn9t6B9GyqcuH8VNcbsDTOxEQBGkYRQpe74iAXyq+ZQVRNxCDnT
	iYoCUQHXzHxb4mSCUAZkr+eBKyzHi1vYmm4Ymv6/PF9QoZNfugHDKKNUks/efLgfNcIL9n+EE/5
	YT7d7IxYW8K3BWGHO0I9zNl+mq8kaUv3NIBUiQKOPzJq4R7HcGWryJD9iJWiM4HF2UwIoSt/FXu
	Q9cwUF4zu7WTT3VmksqEuhSvKtcN8mR8CDVXcuWKv0vFFv2vLcROTXlc6aomxtPTVn/Ddapk+5J
	v006PCZn8GM3uiYzs+dbWGqIcsNhJknzPYzVcb4Me3RbYTGnyuZaA1iwnEKZrldkfinNx6Tj8fC
	FFKwiGWCZYzIzLDEgOELiweOjTttb1bnbqL6tEkCT/JbyEJ86O+ecPmNxyMYsNue5gV01CTU+VH
	2gFEGOBMmM0UNrEFBk1DzAaBOumAYeuseINI/LfCX5zDyx7Gw51zP2mv0T0u/YlrGnkuTMZtqKU
	oPRm/umSkmqr1YWRGigBwUj
X-Received: by 2002:a05:6000:4283:b0:43d:d037:d59c with SMTP id ffacd0b85a97d-43dd037d5dfmr14516924f8f.16.1776286143888;
        Wed, 15 Apr 2026 13:49:03 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-43ead33d670sm8326978f8f.2.2026.04.15.13.49.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2026 13:49:03 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Don Brace <don.brace@microchip.com>
Cc: linux-scsi@vger.kernel.org,
	Hannes Reinecke <hare@suse.de>,
	Lee Duncan <lduncan@suse.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 0/2] Fix SAS wildcard scan on smartpqi and other controllers
Date: Wed, 15 Apr 2026 22:48:48 +0200
Message-ID: <20260415204850.799431-1-mwilck@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 37c4e72b0651 ("scsi: Fix sas_user_scan() to handle wildcard and
multi-channel scans") modified the way SAS drivers handle the common way of
rescanning SCSI devices using "echo - - - >/sys/class/scsi_host/host$N/scan".
Before this patch, SAS drivers would only scan channel 0 for this "wildcard
scan" scenario; after this patch, it would scan all channels up to
shost->max_channel.

This can cause massive resource usage for some drivers, as the driver needs to
send an INQUIRY to LUN 0 to every supported ID and e.g. smartpqi sets
shost->max_id to 0xffffffff. These INQUIRYs mostly fail, but the kernel needs
to set up queues, tag sets, etc. before sending the INQUIRY. Also, some SAS
drivers assign special meaning to SCSI channels such as channel 0 for physical
and channel 1 for logical devices, and thus don't support "normal" SCSI
scanning of these channels anyway.

With smartpqi and hisi_sas, actual kernel crashes due to resource exhaustion
have been observed.

A lot of SAS drivers, including the affected ones, provide scan_start() and
scan_finished() functions that offer custom, firmware-assisted scanning
functionality specific for the driver in question. The idea of this patch set
is to map the "wildcard scan" to this driver-specific scanning procedure if
the driver provides one.

The first patch is a minor fix for smartpqi to make pqi_scan_finished() work.

Martin Wilck (2):
  scsi: smartpqi: use shost_to_hba() in pqi_scan_finished()
  scsi: sas_user_scan: use scan_start if available

 drivers/scsi/scsi_transport_sas.c     | 26 ++++++++++++++++++++++++++
 drivers/scsi/smartpqi/smartpqi_init.c |  2 +-
 2 files changed, 27 insertions(+), 1 deletion(-)

-- 
2.51.0

