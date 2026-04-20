Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4DF39B966
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 13:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776690727; cv=none; b=NHqTTNpdwrWKbClZjsInxUxhkonmWjgK5HcM0pqD5wdbf1A1p7gujXKbIPSw8XGDwny3hkcDZ4UISYGxfeVzrkqenFz5XF4Smbr0w3DYiLLrZtlx4nNeaOi4hfPh+/XD/Xrirzx5dGZOs6FjAzuk4+rpJS6RJ62YapNKZeBJ348=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776690727; c=relaxed/simple;
	bh=unTlZmvymtrAosC1gc38VchUcqWpH3KjnweqTsHal+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOzKkDZr3whwP+keyZyqOmg9yLUrHbNwVMBYw0GyBEChzldnXvqz1G5MlHCqOIGdRZ3YlKm4/4fpr5qDpGKx1F+c0opSRBmb7lvvEGfX2nAXhgddcAFLj6kJ1BF51Bn6b3iMuaJBy8/cXYCkVYa0LCbEql7ZFApRcXKqcuCFafY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UShMC9sP; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UShMC9sP"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-43fe62837baso1810217f8f.3
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 06:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776690725; x=1777295525; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CD9/SaQbaCJB7OvL/7Y9DGnFoX5Sh5QHuy91IeKetc0=;
        b=UShMC9sPKIXAABkt2mxYVW3M3DS441d3L8BNgNeqUm8wTqC5qurMYG1DGn//6WVfuw
         gKhEL5iwKPVEjK4R+/+OpdX1Nj5vw4jVwusZ+SIHuJj3z+jsezJJjs3pNgUz/+LyqIlN
         XfszX3TksYhJpeLydcJUbnh8TbkHOIHZ14fkcq2UXA3qGE3MeRvOIrzAzGHU39uzKtjw
         kg6a0Oy+QGLODZIbK02gStk7xI9QGC9AhL5rPl+hRBfOCfIWYgq7PmZkzBTPhRSTlozZ
         RCdHPtmh7cFllmFCOdtrZflqEtcZCOEzuvoeJA4kbDDVwARqzqIlN1gMoauTc+tJ59QT
         Ftpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776690725; x=1777295525;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CD9/SaQbaCJB7OvL/7Y9DGnFoX5Sh5QHuy91IeKetc0=;
        b=MlK2RYytLRWsHhOVMNFnEsQRJpJcnVPJRDVlRbfHK2yTaZb8Bk9l5rzUub5momiYW0
         18DXafGgTg8ULWvGW4tIB5vnMv1mORBGj9avNV4rwxlHhsm08+9PlBj0t92TR+Q9PNt0
         w8BLA1wDYj9OP3XWaZ6OMeS5xJldKLIhbnhZdbffTOi65Ykd3TwJzeh3ikUk5Sqk4BGd
         vsu3zqKmZcDaWwTlSlYnh2guyrNipwQwW63vc6KoWJBqmYAghQjKKxsyttCXO0lonvvE
         xU5BdWDrv1YDZMMtZ9xQjaHb1MFCxXLYXGp7Vv9Pv28zlKLDbp5sH4nQZ9J68FAfRrUC
         SScw==
X-Forwarded-Encrypted: i=1; AFNElJ+K0Xlfg1wR5Jals1P89RbHsutHbrHVECesZ4BMmSaHqlcvErZM6l4yawVQXAI0FJckuh2JxzCOf3Zi@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0za5qsWWi6S2GpSfifaouNGfJnU3zmO4wNaS/oC0PyfdNg9bH
	TrtWfkdtl8n6AJgb8vBX1vkXo9Mw9oNxzS1umyMNGXw90Uqu0QpAKftO776sw56DynM=
X-Gm-Gg: AeBDievKaJnLLsXyCUz67zXbNE86OA3QO4cFj2bQ2UoD4ETsxV9YOpLjQARnEirkdsb
	bqWCdC9wLCoUsHbHOQ4Z7F4VDAjOWam+iFZB73g9zrrbci6zK9aEhsxkn1UR/oKQ1/ehsgG6+N0
	3QByEDg2rK/XA8CuNCLMPTodPGtaw4MzeH0MDMJ3bv77V+YaK8MrGeBkHuNiqS9GO6rzL898rhk
	yJ5kr5mvEZ4N4EbTz9d1k5WzektiFllzsirWz0VT6HGgqp82B7/Cm8SyBrDBQxJCuNxHEk3lTzP
	GT037jcQxvgqy+AHr5frkVBaRbHobtFsPxw8DP0BbZ8HDNLWu9L3tBNKUyLeSVwCnRVNA/XQnxk
	y9pxPJoqe0lqs8uX4765Sxo3UcYUyLCGV3SPC99npwFxphqyBoH0mvxorqXtDY75bctP89ZEHXm
	rYGjTKMOqQ6Rh4qAcP9+clpS+K7An4Kg+ofJkj9zg8Y4RzpQme/A==
X-Received: by 2002:a05:6000:25c4:b0:43c:f52b:8003 with SMTP id ffacd0b85a97d-43fe3dfd332mr19870492f8f.36.1776690724775;
        Mon, 20 Apr 2026 06:12:04 -0700 (PDT)
Received: from linux.fritz.box ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e4d112sm32580385f8f.29.2026.04.20.06.12.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 06:12:03 -0700 (PDT)
From: Marco Crivellari <marco.crivellari@suse.com>
To: atomlin@atomlin.com
Cc: James.Bottomley@HansenPartnership.com,
	MPT-FusionLinux.pdl@broadcom.com,
	aacraid@microsemi.com,
	akpm@linux-foundation.org,
	axboe@kernel.dk,
	bigeasy@linutronix.de,
	chandrakanth.patil@broadcom.com,
	chenridong@huawei.com,
	chjohnst@gmail.com,
	frederic@kernel.org,
	hare@suse.de,
	hch@lst.de,
	jinpu.wang@cloud.ionos.com,
	juri.lelli@redhat.com,
	kashyap.desai@broadcom.com,
	kbusch@kernel.org,
	kch@nvidia.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	liyihang9@h-partners.com,
	longman@redhat.com,
	martin.petersen@oracle.com,
	maz@kernel.org,
	megaraidlinux.pdl@broadcom.com,
	ming.lei@redhat.com,
	mingo@redhat.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	mproche@gmail.com,
	mst@redhat.com,
	neelx@suse.com,
	nick.lange@gmail.com,
	peterz@infradead.org,
	ranjan.kumar@broadcom.com,
	ruanjinjie@huawei.com,
	sagi@grimberg.me,
	sathya.prakash@broadcom.com,
	sean@ashe.io,
	shivasharan.srikanteshwara@broadcom.com,
	sreekanth.reddy@broadcom.com,
	steve@abita.co,
	suganath-prabu.subramani@broadcom.com,
	sumit.saxena@broadcom.com,
	tglx@kernel.org,
	tom.leiming@gmail.com,
	vincent.guittot@linaro.org,
	virtualization@lists.linux.dev,
	wagi@kernel.org,
	yphbchou0911@gmail.com
Subject: Re: [PATCH v11 03/13] lib/group_cpus: Add group_mask_cpus_evenly()
Date: Mon, 20 Apr 2026 15:11:52 +0200
Message-ID: <20260420131152.243488-1-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260416192942.1243421-4-atomlin@atomlin.com>
References: <20260416192942.1243421-4-atomlin@atomlin.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Maybe I'm missing some background here, I noticed group_mask_cpus_evenly()
is called inside irq_create_affinity_masks() and the "numgrps" it is this_vecs 
in the latter.

Looking to group_cpus_evenly(), seems it is possible to have this_vecs
equals to 0, indeed this function return NULL if numgrps == 0:

>488 struct cpumask *group_cpus_evenly(unsigned int numgrps, unsigned int *nummasks)
>489 {
>[...]
>495 
>496     if (numgrps == 0)
>497         return NULL;

Without it, I guess the kmalloc() in `group_mask_cpus_evenly()` will return ZERO_SIZE_PTR:

>+struct cpumask *group_mask_cpus_evenly(unsigned int numgrps,
>+				       const struct cpumask *mask,
>+				       unsigned int *nummasks)
>+{
> 
> [...]
> 
>+	masks = kcalloc(numgrps, sizeof(*masks), GFP_KERNEL);
>+	if (!masks)
>+		goto fail_node_to_cpumask;

and this value is then passed to `__group_cpus_evenly()`.

Should this check be added or it is not needed? Or maybe rely on `ZERO_OR_NULL_PTR()` ?

Thanks!

--

Marco Crivellari

SUSE Labs
