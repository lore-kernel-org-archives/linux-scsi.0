Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641E33C8708
	for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2026 12:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789476551; cv=none; b=qKJNzr+SuE/+DPjwX/+iN5+pe2CFOVj/EKYJQ9fKHxWvUBu1mVCS+lUC9OuVEaxghZQNfcIJ3LONHZPUpEHOl4N6n3c/l3aa0/kyHvVf6nH486CqYurN8ka8Gi/cTjLLTVmLqa8hk4xFAbVDUjV98jxxJuShV4+I/bQoBgHOD4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789476551; c=relaxed/simple;
	bh=hjF5uq4+rnXMZsq4PdMN+lhsdpK+neGjIFKdjIdf+8w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=WcNoa9KM6g7LatwdcE19KYoets1XC0e2P07EkHMKDm9r9jUKB0J1MDxSp+aPV6og3RBiDfdFQkWUCNZ0KpdiHAQs7gAeioipeGRiJnijd/A0ce4ZArF0it7bFwERd5XbK11IO0rBPWLzETjRW4LRda154YR0llxpMQp4LVlaRCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JOOARdHK; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JOOARdHK"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc4bdf8acd6so2334415a12.1
        for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2026 05:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789476550; x=1790081350; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=hjF5uq4+rnXMZsq4PdMN+lhsdpK+neGjIFKdjIdf+8w=;
        b=JOOARdHK4zBGCfoAZZPJV19GXznCctp8XRRWXg1F+REhUejU6SPsn6B8nKNB0I+mPC
         /qV/wUTsgSHCSusEuyl3LkgYfqmHOhUxDzDeEttvCiwkb6tDBY5iTlMnPXmuwslL+4Wn
         zeYBhl0PEK7wwRfXtYoqU4NlRfufvPzungXlAakwrcqtx+p16jhnnNBslkS+xibrSDTp
         tYgy0fwSuKGbFRIWBm3aBgf0z+CBZUfoXI/DW2SOKhG+TiqvELVGQvFSu6GgkbI9fP07
         gI0FJcSxgZAX/NUxT+Iis7YUtpzTuq/5OvXa/0IoK0fdpD8KtQduGZSvEsikGzcYE6PI
         x3bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789476550; x=1790081350;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hjF5uq4+rnXMZsq4PdMN+lhsdpK+neGjIFKdjIdf+8w=;
        b=UhSq3d5hyxNoInIEaS3NBGrWoszuo+1U3XsiDPJ7lPFiOQCfgxHozQyNQev28LSCFS
         o0KmALH3GRN7DYBl/O0FA5n5rXiNA28Y4AO4jWBxrkm0K0qq3k+fXI9aBw1Kb12G69hn
         ucwHG7I4hsbvhCh1/FJ52UIyLcU9EzYgrOjz1xKAHsZ0siNDEWNNiyvlskExdBCYd/sh
         Kyu6pyEXvtmYUkhp+AMLKmo+XX6ajnYwbRMukmW2j7Cu5xp7mgW0+/grXZFxvPlrHPMV
         baSnPWIdJx0eKsMuYBvywQYO9tPnlNGUN2rKb9vlTltnWNwVE3dAcgBzGOQRjMI5NyBb
         RC5w==
X-Forwarded-Encrypted: i=1; AKwUvBwJ4PnYmRHZ2kOd5yfctKYIejMLrAm85ai3Tz39PXP8Z94GZE1GTeDYitd8KCvSiwnOsA2odZ4MGV0B@vger.kernel.org
X-Gm-Message-State: AFuF++k4lqbVQxY/BvCFdf4ZkIGLUCtPv/6AALPRCq9q1Y/H8SdQIAEH
	p4P4NEbujlnl/wNEHYr3kFqEcr5IJG6XEjJH/vvr9a+hUh3VEoK0pPN3NiE7MC5Xjwc=
X-Gm-Gg: AYBFou2S0bVd5oS5c3hAjOb3xONP0XZJ50JoimCiXNddUklJJxMdW43FZLIoSvCpl6m
	/Uo5ELMPAfp5r6pQKoOXuOYiXabiVd5HlVwk+qM9W8lPXvUra+8YWM3VNxi0+niokIszwm5UMmg
	rG/ZM2kHUSsaX5NTbLRawRo4Z2ppcqchQYWmmn/56VkHgl7+G6H95VOAbR2kf9pQyn7TZT8eyCw
	q9uSPjxsoP3uySQWUQwCvOMS6R+UuNYlPOZaKo7T6YKIBQA0/1+YU8NBFVVOu5tvs3sPK6aI5Jl
	y3kq9hCd9fTdmPIjlFimxtjIwGLFKsWAMNKFlesKukbJG9mmkBueYuI4eKXvTQ2/WZR1AIM1nrq
	EZJIqxWjZpfDMrwWl6uKmZwz/0k61hN+zbaHD0VmzMSnLwsAK/S2RH5BIH+cHUWtxyRr9+X0B7n
	rz0B2UcAMNqvvL425XiQfLEKtpZpGqiYbzDRfcBiINMi0iTAmXZkHnN5yu5RCEbnzZx0K46Q==
X-Received: by 2002:a17:903:320e:b0:2cc:864b:539 with SMTP id d9443c01a7336-2dd6c5eebcfmr170674595ad.6.1789476549474;
        Tue, 15 Sep 2026 05:49:09 -0700 (PDT)
Received: from [127.0.1.1] ([240e:b8f:91e2:d400:ec2a:b15e:fef8:70a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd48ae3cacsm52866095ad.26.2026.09.15.05.49.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 05:49:08 -0700 (PDT)
From: Liang Haowen <nbg2974@gmail.com>
To: Lee Jones <lee@kernel.org>
Cc: linux-leds@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, sashiko-reviews@lists.linux.dev
Subject: Re: [PATCH RFC v3 1/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED
 driver for ROG NVMe enclosures
Date: Tue, 15 Sep 2026 12:49:06 -0000
Message-Id: <202609152112.ReplyLee0910.lhw@gmail.com>
In-Reply-To: <20260910093232.GO2133376@google.com>
References: <202609012200.RFC0.lhw@gmail.com>
 <202609012200.RFC1.lhw@gmail.com>
 <20260901145204.2BF551F000E9@smtp.kernel.org>
 <202609032000.RFCv2-0.lhw@gmail.com> <202609032000.RFCv2-1.lhw@gmail.com>
 <20260903122408.3CA6B1F00A3A@smtp.kernel.org>
 <20260903161357.GX2133376@google.com> <202609042000.RFCv3-0.lhw@gmail.com>
 <202609042030.RFCv3-1.lhw@gmail.com>
 <20260904131503.355C41F00A3E@smtp.kernel.org>
 <20260910093232.GO2133376@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Understood, sorry about the threading. v4 goes out as its own thread.

On the three sashiko items: the naming one was a real bug, the LED
names now flatten the sdev colons to dashes
(asus-arion-0-0-0-0:led0), so there is exactly one separator again.
The other two are false positives: kzalloc_obj() has been in
include/linux/slab.h since v7.0, and blk_rq_map_kern() takes four
arguments on current kernels, called exactly this way from
scsi_execute_cmd() in drivers/scsi/scsi_lib.c. Details in the v4
cover letter.
