Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D37279DD8
	for <linux-scsi@vger.kernel.org>; Tue,  1 Jul 2025 16:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751387404; cv=none; b=LfYp02Lzst4Jqn6N/w/qClpSITH8/1iz/PfrJ7m05Ulk3mq1RYNHeiPMR6emWcpvDllXERYt02BVwReg+HZcT0yS9xkAnvFkyISbZAKwTAea6yy9FEg++hBk94v/7Rizg98QjbO4AP5RfTU4QkHtysrV5MSSXZ5qvYNnYJGuD9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751387404; c=relaxed/simple;
	bh=wFrxDDlw3PMnJ84pTpU3+oamjHqaLYc4WDE2gz4FccE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=en8ewC8ixdMvR7Kak1Rq4/VggANOYlthNsaEjQhRE8E3HLPbuttq0u6vQ69tpo2j+Cr9jy6/Laa+MrZ9AlZ7WD49FGJepCvVNADAGurk2pstCm2w3dbnYNYAsFU1nwqppTSMETpCvrsEZ3Bec5CEaw4ONHfB9MJ1oSg2NVFmL7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=09fs6eb5; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="09fs6eb5"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-876ae3f7768so193297639f.0
        for <linux-scsi@vger.kernel.org>; Tue, 01 Jul 2025 09:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1751387401; x=1751992201; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=crWwaD/7GgCUUFcWT/Llkm7dN9wwCuiLb/qh9BwJGxc=;
        b=09fs6eb5exlgCRMXs4yv7qhEYiWG/hZ5FcH/x0fmWbkI8uuqVC0MbFRBqfJwLxpRh4
         hvhQUw9cMVFTY6ocKF5kXNp9HmbCp+f4MU4QRW1ql8X1ppZVntgtBpVZrlB4oWKkUdxp
         Ze4b/LURH6iRi/eXuK7FgsVm+Xja4ONJaLnontXBtmmRp1yn1coXOHmEU71tKLw5C/jU
         8TkGU4HWKoIbkrXBuVtEhZksV21wbDiw89Y0tfPK7cOc1D50aDnAyMkEVwVapzIvw7Ra
         vetnL5bDRNo8eCl2eP/Zs5AnTlWIn1hSsnWJbWnq8ZMdra1vyD7HsmIy12PTtO8LbPR/
         VOyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751387401; x=1751992201;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=crWwaD/7GgCUUFcWT/Llkm7dN9wwCuiLb/qh9BwJGxc=;
        b=vlTUkoQ9sdNL7QL6/MTNSojqzAZckwKGlD3H9dkBMTP4b2bSCuEaNOcdJvyTqRXjf/
         7zvMxa+4gY2wd21lxee+yN6iVHXxsPHDitAkUQw7X73mukPCn40wC0fdthvEmJCPcRL+
         AR3XxzlpzsTTejt42lo2Qg5lQSTiCSSnqr/zCf9AP1s74QCcWmw6+RDl30k5qNu8JSXX
         PvUyNOoa2r+2jA42diAp7bOP4ozj6gRIfXFsL4q7rUrKfx5HPnRkv3zNK9VbScEU8PlQ
         2bWhAOPscSebCcCUPgeipfJcF3MJpsesZBdEVkQ0p3+aczIcGm8iLu8pRoSizFBHH3P2
         HB5g==
X-Forwarded-Encrypted: i=1; AJvYcCX6M/Q/Cjh1DOK22GDwVyKhf53IH+WhxDB+zlaXhmTYcRt33PVqOD8gNe5eOt0FQ+J0BxApZb9sW1+x@vger.kernel.org
X-Gm-Message-State: AOJu0YyesXV/Q9mjojRRJF8s7+QNQZNES1S4hAxhg2z9p7rK4MCViciN
	f1slgxjNzI9X5MyMsqhYgQAFNLJLmdkGJ6Ao/wXknvobT3XII8LXtBKRs414M4dWqME=
X-Gm-Gg: ASbGncsLMNw0BD1oIgBaKUhbm9lUMyXNjI7B/KUoLwxoaZEny0ZEt8gyC9WDPX17QkX
	YoJSAav1kzGWB7zkbbXftSJ1DkebVUhLNSo1YY7+PVJ+6PVgkYxs6xoPoBdPOkaHyOKFBs7WCG6
	TWEIPwiC97wWMrHTKxxjvogxQt60aDUKSQ/VQWOxtevvey7S4l2R7hko0QlOGmHjbGwYRx36i87
	9MPxuaJSHwC4dN/IKMa91EMHfJpVROe78VX0q+HT31mtmIFMFgxXo46+ORhZW4JNrCWPh766GDN
	+qWJLpz1VzU+Xu8ki2qJiaJjPjd6tFhBLPJY9gnNSraulVKU2H+Eu+pxuoobsYE=
X-Google-Smtp-Source: AGHT+IGmszV/ckQKjI/KgjT/UrAo+IhSsGcXQNmla80uKgIibrMYCCf4LgGCWJe7gTvyQW/Kg7z8dQ==
X-Received: by 2002:a05:6602:2b8c:b0:864:4aa2:d796 with SMTP id ca18e2360f4ac-876882fbadcmr2169640839f.8.1751387401311;
        Tue, 01 Jul 2025 09:30:01 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-87687b0d3fbsm236096439f.39.2025.07.01.09.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jul 2025 09:30:00 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>, Daniel Wagner <wagi@kernel.org>
Cc: Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>, 
 "Michael S. Tsirkin" <mst@redhat.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Thomas Gleixner <tglx@linutronix.de>, 
 Costa Shulyupin <costa.shul@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
 Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>, 
 Ming Lei <ming.lei@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, 
 Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
 megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
 storagedev@microchip.com, virtualization@lists.linux.dev, 
 GR-QLogic-Storage-Upstream@marvell.com
In-Reply-To: <20250617-isolcpus-queue-counters-v1-0-13923686b54b@kernel.org>
References: <20250617-isolcpus-queue-counters-v1-0-13923686b54b@kernel.org>
Subject: Re: [PATCH 0/5] blk: introduce block layer helpers to calculate
 num of queues
Message-Id: <175138739958.350817.18365520328662376034.b4-ty@kernel.dk>
Date: Tue, 01 Jul 2025 10:29:59 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-d7477


On Tue, 17 Jun 2025 15:43:22 +0200, Daniel Wagner wrote:
> I am still working on the change request for the "blk: honor isolcpus
> configuration" series [1]. Teaching group_cpus_evenly to use the
> housekeeping mask depending on the context is not a trivial change.
> 
> The first part of the series has already been reviewed and doesn't
> contain any controversial changes, so let's get them processed
> independely.
> 
> [...]

Applied, thanks!

[1/5] lib/group_cpus: Let group_cpu_evenly() return the number of initialized masks
      commit: b6139a6abf673029008f80d42abd3848d80a9108
[2/5] blk-mq: add number of queue calc helper
      commit: 3f27c1de5df265f9d8edf0cc5d75dc92e328484a
[3/5] nvme-pci: use block layer helpers to calculate num of queues
      commit: 4082c98c1fefd276b34ba411ac59c50b336dfbb1
[4/5] scsi: use block layer helpers to calculate num of queues
      commit: 94970cfb5f10ea381df8c402d36c5023765599da
[5/5] virtio: blk/scsi: use block layer helpers to calculate num of queues
      commit: 0a50ed0574ffe853f15c3430794b5439b2e6150a

Best regards,
-- 
Jens Axboe



