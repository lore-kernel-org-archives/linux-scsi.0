Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794444078;
	b=u8KhEp+WN4vXc6FEpMbHYVbBp1mRjFW6f7kOD4aEHnixq7FxIIdDMCZhtUOpGGaku/3c
	 AXUer+9k4f+K6aIiHqYLf+eEHXtMykFh/QLudQfzAHtqwUWscdJdsozJ1R2W7W41yt7xg
	 YBq6nUegGjUsZFFiRimvmk/R8BjLvq3wksUReSBiPJp9HC5y5/hEYH86W0c9Hdk9FNaWj
	 BKbo0pyxOI5aR2y6IkGz8OzyfCVB0dw0AC/sycgwNvvfvgmDTh7xqBuHKjpTWTnjLVsNG
	 4I0058n3YFSn7UPM7QlZCspqN97/0Jg8Bmz/pG7ZkOfqoHP3oau9ETl16DfAzsrLRiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794444078;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=bJizSOfwaFLzrVg6LUbmeOKVBfUrTfo1+AD+ywf1vgo=;
	b=Dvp4D1C69sG8cMf/ibOFXLB5q9EQh7CMh8rnM57Uid9ZIOgkPgTtwEj3HnIAHhhwZ5/f
	 T0zVDHC47dRcDC+UF0ROcIJHAPt9jXsrYVg5OuDCMeP5PMizjZMjr6g1W3yU5ajJAKzQE
	 XxRnLEUWyR0ogzPirJLWBUDtLKGsuvAqF5AycajjUfB66mYeDRNm1BeIjn+Wz62wyCHQE
	 9/ga5CqJZIRzvWPxt3WL4Pd3AwEM6EgaflZhnRj8pLIaV6JAbpb57YNQ4PT+xtUboQtFD
	 dh8Ll2PHwd66gi746fpxiKW2mj+YD2/FnK6iXfKmunbk7gcuR5jHkNkYAA+zwj2BeNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="e2s32/Lj";
	arc=none smtp.remote-ip=209.85.167.198
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1788606A332
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 00:41:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1788606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=e2s32/Lj
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4e778acdbc6so4456246b6e.3
        for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 16:41:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794444077; x=1795048877; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bJizSOfwaFLzrVg6LUbmeOKVBfUrTfo1+AD+ywf1vgo=;
        b=e2s32/LjJqSd4QF3avEKUsJ+6Dlb8TnWobQs+/yXGGC3sKqLbaPGdFa27kdYhjD1nj
         A24CjvAOTc0LMhLUDqSVR8DMwcwxEnuQ18QIYln9FF+P4mCkXyyz58fpVkoPXpjJQyQZ
         vDKIiM3r7rs7xFpS8imbPrS3k+IVVMYvVLCdJY6oxFAzmRq+MLyQ6cyGsDdOEEVgfDHT
         UwmqvpsE/nfShXwZ3DLMQY18/G30m+lqAFQhtWHSNvpUg7gezqz1ZcZzRTDfWMn3PHMW
         atNI3QauFSvM22voOw0GDxVystX8phe46NtCMToTqgp3vuwNBITJJJeHOarPOCi/0npx
         L5sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794444077; x=1795048877;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bJizSOfwaFLzrVg6LUbmeOKVBfUrTfo1+AD+ywf1vgo=;
        b=JfkkXJ6TIKx4pCg/oq/C5XwafNuf1+j+NZsogG36rBfvlZtFqe9r8Emwe6uIlEmJPE
         c32VZt+cfgQ/IqE8+bsNBS9pNh1Ge8GwUfRm+az5tobgk3rZd+A3B7tHFXhOvGaP0HnY
         82TL4HRmDJWib0lP3CLXKxe5i3Vb0+ENlqR77kpM8OWitopZrKQEJGRN+h65SUmqF84w
         Nv8Bs6FVvW4+IJRu5oX/SvchhdGllRzlk26/AEiQr52Yf7erI2VA5g7JaDBYdIKf5t6K
         /nxtfTpBmMcPa91kYjwFzORiFn7tPAfDD/Mwyl3jM6/cS6RDll7cp0TY9pSpbtRy/b7z
         6zDQ==
X-Forwarded-Encrypted: i=1; AL+hErF8wbWiBIaA+s+o/ar5JZGLY3i6FyS4NddVdT9+ESgXWmIBcaILSEaz2ByNrQ/XvRDiV7HDb0i0htrU@vger.kernel.org
X-Gm-Message-State: APuU4Z827+/9vY1+5Wi+KQu5Refdi/GrVD56kvFK8izjEmBU/vhOhzHa
	yGggUi02TMrrjWfv1x5TDAbQL7EjWMM9sx8XJ0//WSPnKgp8MfEFlmNbw8BQpD4r45WznLKIQs8
	OdkFQUM3oDoKEjbA7RkVrEg==
X-Received: from iocy14.prod.google.com ([2002:a5d:96ee:0:b0:9c7:75ad:5e83])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:c234:b0:4e7:3fd7:2752 with SMTP id 5614622812f47-56b96ff79c6mr4110185b6e.54.1794444076488;
 Wed, 11 Nov 2026 16:41:16 -0800 (PST)
Date: Thu, 12 Nov 2026 08:41:09 +0800
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.567.gdb80ae8cd5-goog
Message-ID: <20261112004112.3059801-1-stanleyjhu@google.com>
Subject: [PATCH v6 0/3] rpmb: Fix request serialisation and teardown races
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, Jens Wiklander <jenswi@kernel.org>, linux-scsi@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, 
	Bart Van Assche <bvanassche@acm.org>, Avri Altman <avri.altman@sandisk.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo <beanhuo@iokpp.de>, 
	Bean Huo <beanhuo@micron.com>, Alexey Charkov <alchark@flipper.net>, 
	Can Guo <can.guo@oss.qualcomm.com>, Ulf Hansson <ulfh@kernel.org>, 
	Linus Walleij <linusw@kernel.org>, Shyam Saini <shyamsaini@linux.microsoft.com>, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Jens, Martin,

Patch 1/3 serializes requests and provider unregistration in
drivers/misc/rpmb-core.c. Patches 2/3 and 3/3 fix UFS RPMB device
lifetime and drop the unregistered bus in drivers/ufs/core/ufs-rpmb.c so
regions register again after commit 36f35b8df697 ("driver core: reject
devices with unregistered buses").

Patches 2/3 and 3/3 depend on 1/3 at runtime to avoid a use-after-free
on host unbind. Jens, if 1/3 looks good to you, could you give an
Acked-by so Martin can take all three patches in order through the SCSI
tree?

Changes since v5:
- Rebase onto mkp/scsi.git for-next.
- 1/3: clear descr.route_frames under rdev->lock instead of dead flag.
- 2/3: pin sdev_gendev via get_device(), drop Bean's tag on 1/3, 2/3.
- v5: https://lore.kernel.org/r/20260914144910.931518-1-stanleyjhu@google.com

Stanley Jhu (3):
  rpmb: core: Guard frame requests and teardown with mutex
  scsi: ufs: rpmb: Decouple device lifecycle from devres to avoid UAF
  scsi: ufs: rpmb: Drop the unregistered ufs_rpmb bus

 drivers/misc/rpmb-core.c    | 20 ++++++++-
 drivers/ufs/core/ufs-rpmb.c | 84 +++++++++++++++++++------------------
 include/linux/rpmb.h        |  3 ++
 3 files changed, 65 insertions(+), 42 deletions(-)


base-commit: 0fc91e802801819a0c51d30b6eecac63ab4f85d2
-- 
2.56.0.567.gdb80ae8cd5-goog

