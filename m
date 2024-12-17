Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6D214A609
	for <linux-scsi@vger.kernel.org>; Tue, 17 Dec 2024 16:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734453442; cv=none; b=GyJ0ACgufI1Rj69VF5y+8s+yenZEj57xT7nuvsBIO+jjrQ1Hn60Syr1fJzoUv2t4uQoTKJ0kYY6flHmI4MJH1Wk8wead24YMRjxC0tsh23EtipcXFnulhex5o/bNBNFxmKcqVRKHsoK9bWP56Yz2TnS1cbJ6SOrkTj0TWEQc9YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734453442; c=relaxed/simple;
	bh=1ATu9wgaYAQKhmswVhuoVZ2QLTUdUkiXPcR6R4v8PvA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=L/FPcXf4knjcMMq/TTVy+J3/QmWAqMPPNHn7Y72uGYIcJ9obVXIj/t6rc3qLUgti7bK3oMSD3kOW8QxLCS0SN5Uu1dQGn9frkvW1EzcrA/on0WRVKZxU4pGPh9NnpOzp62hNualFG9WXFT9G2LeDDk9R8EYmLaPLAb9Cr9UiGpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YkvrTB0a; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YkvrTB0a"
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3a817ee9936so19113725ab.2
        for <linux-scsi@vger.kernel.org>; Tue, 17 Dec 2024 08:37:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1734453440; x=1735058240; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eLXAYiyU1iqMID7+HfNyBZxwgcF9EMYHiTYuuHxkZvc=;
        b=YkvrTB0aNwKvR4xRlDpztlOMbeGYbo4Ym1ToMR0mUwdkDj9J59eG6lLIA1luzDT1tB
         Z5GvUBO1asaMNLI0vh6XMq1oB4V3MfCWBl/JHIYoclfd+hNwEc42Rdgt3mXOMwUuCX8p
         tcBlcLxeNkR/iMJHOTsg1OMzMJoXJwFVVKKstenMMcC9lnXvKFNoN9VgWtXaemj0AF+a
         vTx/aA/pm+I4h7s9Rbw8T0mbO47cPcDl162FZsDTchFamGnzW2OWUeMtxLq32eb0xIa+
         7i58HBGU0nE0yB0+R7qBns6wt3VAQldTcQL2mJ7HitNLPcK65E5mSmkcazdPuJtJUjB6
         FN5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734453440; x=1735058240;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eLXAYiyU1iqMID7+HfNyBZxwgcF9EMYHiTYuuHxkZvc=;
        b=AuJ5yR3dvDAqX3CJMHZEbZ0maKwdf2/kfFCOQptJeePUrOozHQUrx8HNTpfLgMXP0/
         +pAe3AKixWsniQnKk7x+7I6qE+9rVqExvzAJlCQp9ggEReT2ofTsZJ634/9ieoU/uEnI
         OcC7yyPPEkxjObxC5e35d2jLTyBrGx4cutB1L9EGPW2aaexdPf+g6b8YaD9DMPGNqg1Q
         n/7INBTk94KPx7aVabmJrCcv3ASYiJW7BozplZJPJ+qxaP6Lzznm97IYU/WTfunBwV0H
         YaCzhJOwa9JMICYn0+3Z00VTaio05xFWtZg3YNup/0kXskPgEcqJDb1kJiTKBPzKKq3C
         Ze+Q==
X-Forwarded-Encrypted: i=1; AJvYcCX8xTjgTuS2HHZ9KbV52+KAgda8KqU437P4jlMt2sEZLO9JAdOvZ+r9A9ajZTNSAGJJdkpGJl/+FAbk@vger.kernel.org
X-Gm-Message-State: AOJu0YypdBSwINotT1GLla2GHBIwt+5aae+Hve3J2UlDknry80Darmcl
	PUNuT+qs+RAT36B8RIyHBU0YIpp9fQ6BO5i6vu+Aiuw9RxnM60T6Mo4f0XW0wAM=
X-Gm-Gg: ASbGnctgUx0E4AIhNaNcdFWiRmoOKLKaBGeW6lmIYVXIC+hypNtR5u2/sszQ4T863Wa
	Fs9pX0kKVyR4qDguUAHwQ2+OextRHVcsSiyYh7PVZSq70WLLBDmtUI4wbEnB7Uz3bfONu7t2W+8
	SXm849gTcc3WNwgKnSMwClhya/7BG4bCgGhZyaUXmrbyYUk9PszQ+hSYa8ziUsoqb0v8cVCFnOM
	cpBrH51wBeNZBVaSBuNzx8yy7mIZ/tRzfxF0c5N/wzncXc=
X-Google-Smtp-Source: AGHT+IE/HVlmxcalHVFA9B+15PGcwD/7VUAayQaHnmJ8VTv9HsAtDcrPfDzLFsYJKWRCm33fWsrd4w==
X-Received: by 2002:a05:6e02:1d11:b0:3a7:708b:da28 with SMTP id e9e14a558f8ab-3bd8b195aa9mr912455ab.21.1734453440010;
        Tue, 17 Dec 2024 08:37:20 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e5e0a3de5esm1774339173.51.2024.12.17.08.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 08:37:19 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Bjorn Helgaas <bhelgaas@google.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, 
 Sagi Grimberg <sagi@grimberg.me>, John Garry <john.g.garry@oracle.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>, 
 Daniel Wagner <wagi@kernel.org>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-pci@vger.kernel.org, virtualization@lists.linux.dev, 
 linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com, 
 mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, 
 storagedev@microchip.com, linux-nvme@lists.infradead.org
In-Reply-To: <20241202-refactor-blk-affinity-helpers-v6-0-27211e9c2cd5@kernel.org>
References: <20241202-refactor-blk-affinity-helpers-v6-0-27211e9c2cd5@kernel.org>
Subject: Re: [PATCH v6 0/8] blk: refactor queue affinity helpers
Message-Id: <173445343855.487134.18283101203931240403.b4-ty@kernel.dk>
Date: Tue, 17 Dec 2024 09:37:18 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-86319


On Mon, 02 Dec 2024 15:00:08 +0100, Daniel Wagner wrote:
> I've rebased and retested the series on top of for-6.14/block and updated
> the docummentation as requested by John.
> 
> Original cover letter:
> 
> These patches were part of 'honor isolcpus configuration' [1] series. To
> simplify the review process I decided to send this as separate series
> because I think it's a nice cleanup independent of the isolcpus feature.
> 
> [...]

Applied, thanks!

[1/8] driver core: bus: add irq_get_affinity callback to bus_type
      commit: ccddd556cfba3db6cb4d45d9f7d30c075e34808b
[2/8] PCI: hookup irq_get_affinity callback
      commit: 86ae920136e7c6352e7239a459544b0eae57613a
[3/8] virtio: hookup irq_get_affinity callback
      commit: df0e932e866b5cfad8cedafa0123ab0072a665ce
[4/8] blk-mq: introduce blk_mq_map_hw_queues
      commit: 2b30fab613e2ef54ae4b3fbb238245a29ba2a285
[5/8] scsi: replace blk_mq_pci_map_queues with blk_mq_map_hw_queues
      commit: 7c72e20573d0d350c7c087289e7b7b605100651f
[6/8] nvme: replace blk_mq_pci_map_queues with blk_mq_map_hw_queues
      commit: f0d672680e0b383b14add766b57db60c4c4acf92
[7/8] virtio: blk/scsi: replace blk_mq_virtio_map_queues with blk_mq_map_hw_queues
      commit: 5a1c50296039ca32a22015bbb9696d6a96514947
[8/8] blk-mq: remove unused queue mapping helpers
      commit: 737371e839a368007758be329413b3f5ec9e7976

Best regards,
-- 
Jens Axboe



