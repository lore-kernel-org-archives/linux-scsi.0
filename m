Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264B131B80D
	for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 17:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776793355; cv=none; b=khS7/41A6YorkolEy0yUtitZ1skbAT6XOESQoNtfNH4CZxTplv2c4iZjkQ3j/E3rNIHt67OcvPxIbOkG8bIOpvYfT4ufeUbI4ZRkunQtevmAcayU8hWakfHadbJVenWDTY5lRms8XKPotCgoejbYleHAyjUHJdZJVyuSGLwbtOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776793355; c=relaxed/simple;
	bh=xJATjN6Fuwnr8BeTpGcZXWk0twhjlloBcBnA5HcNlpA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=a3HOXKKOZHcjSGVC1B60AVTCHTyEznuZY2qUIPErmX/xd/4IcHI8mcuo4JoFbDjV/yTk3GrCyOEBZvrqJ5sCD0y2LKZUeM2XmpwGyDaqWIn1Lb7bKFVRtKMrOKF3Wz4Bv93J4r45zwqarmpxNx2w+1/+M0A8xzIrA+84J3qrz1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=wtKTaoeQ; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="wtKTaoeQ"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7d7fdb922a5so4014700a34.3
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 10:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776793353; x=1777398153; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3cUwwhS+ho+RIyUTmSQCY6Uc+4lk8WVXRSh362LsgZ8=;
        b=wtKTaoeQAyncEz2rI1bnrDka/f56+BznR4xav42FZ5oFtglE4In5zD9cxXa34EGp1D
         6MvOUaLpMpWMNmRu4lq+sU1/z7UWpErJK+GcGfgFJvLlIsiSG+u38gaG7aGxPlv82Rbs
         l1nZEmPSIuPGlDzVQR3mGVmWANQvv85BMFSmPnQx4VBcEcapu4PdhoZ/q8eqEQh9su5X
         KYy2HBV+Xs8Zv6Q6/GljrFIXSqP+QjytzzwxY77CY3Rv8fH8EzY8hjYK80xvDJNxdK0v
         arRZzn+2UPfgaGmgUlXOiiadR7UC6O1HlfCcGZ8UXim5mz1C0VLhyBs/zz6atzJY6ai2
         46BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776793353; x=1777398153;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3cUwwhS+ho+RIyUTmSQCY6Uc+4lk8WVXRSh362LsgZ8=;
        b=PYkbo1+enc+EzhrAmqXRDQF5gWRn08KgLKhM4kGj2HYM8I+UIf8r8aX7+A82M81TGO
         Xs2lg+toxzyX1Uk3RLIBivXHjlCnRg1mTTYvWQSs1QkD13ALJY1gfdFOPHFBMXK7UA6t
         aual1KaJhIZGrkMJ7aReT5c3CVsGc4wLTSUMY5hmF/PfPbzQ4cF6mfRzSR4Qo/Ge3lYJ
         8mnZtFHv8U3Tt/qexw354TIOJtRWVIQmXiWcx5yu+7WXETiEuGi1t1mWdCUvOQ7PTOqo
         c4JKTljM/rMQB2uw4Lrj2DLNiTurgHQ6R2kVJQHM8ZDuzO21xqa+ca5mqdtRG9VgQ5iM
         YirA==
X-Forwarded-Encrypted: i=1; AFNElJ8r2Y10ML5tqnylB1uwNFr5KlWpCcqyDW2THIXgh5YHGEnJY04Dt4j9GAu2QEGpSvCL65psaRHUnbHW@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6kn9AgUZDsXMdG8V0ELFNs8O16VQizc6qzYWzkWvu9kyzkM/f
	VMmkTChQ3p7suEADtCJHrh59l5MxW7XESGBtsXQozwsAi26D7nAdUbuaLAg8KSf9rXwEfxxiuPe
	YZajG7Wk=
X-Gm-Gg: AeBDies83PLgl0OG4o6YB1YDxKr1cGthfwK63MH4GCto+Pe2aC0rXg/47HzbqWugiKV
	Ers9Du58889p2MCGOAIm/NiCPwR5dS4r9ojDLGN5M4cC1pWUBk/rMFm7d8avDG1yFvVYs4ACR6l
	Wn2D6tGI2vhZvMV//bliPhRBf5ugZHwkWe5DgqYB25YiLXAM4oPJoA1OtYS7cZtD0ORVSKcij+P
	sDb2JUsQJ4fGU2+NfcZQrDmPmPzG4Zvl2hj68MlBYEBgDg6m91T68HC4NhpHfzqATIpBPIn17H7
	g9RQORQ5vAHI8LK9XMrcnmPvmDCNI8fEufv9VobSQPGicVlaV2w1sIlS+aOuHqZtk0APV4J/mGy
	PenRugt9UM+PtuFVR5TB4XYFUXdpU6cDJ57Ox6Z6C/9oduISCMbl9jtkSGorgi/ktvoGpIO9GaO
	lBFZhGAbRNcFuC/TOymgBJX1ifZoPth1wAj7NKG5zcsXJS95NOzgCYOZjGvylMLTYDZtFNuJVCj
	chucZmHqtREng==
X-Received: by 2002:a05:6830:6617:b0:7db:c162:992c with SMTP id 46e09a7af769-7dc951ca5c3mr13028278a34.16.1776793352993;
        Tue, 21 Apr 2026 10:42:32 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dcc5b138basm4947556a34.3.2026.04.21.10.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 10:42:32 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Doug Gilbert <dgilbert@interlog.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Christoph Hellwig <hch@lst.de>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, 
 linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260415060813.807659-2-hch@lst.de>
References: <20260415060813.807659-2-hch@lst.de>
Subject: Re: (subset) [PATCH 1/2] sg: don't use GFP_ATOMIC in sg_start_req
Message-Id: <177679335205.642963.2140693135718044919.b4-ty@b4>
Date: Tue, 21 Apr 2026 11:42:32 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Wed, 15 Apr 2026 08:08:06 +0200, Christoph Hellwig wrote:
> sg_start_req is called from normal user context and can sleep when
> waiting for memory.  Switch it to use GFP_KERNEL, which fixes allocation
> failures seend with the bio_alloc rework.

Applied, thanks!

[2/2] block: only restrict bio allocation gfp mask asked to block
      commit: b5129bda5bbcceea5b2589c8248d39f77660aa19

Best regards,
-- 
Jens Axboe



