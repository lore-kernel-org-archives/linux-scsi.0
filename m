Received: from mail-pz2-f39.google.com (mail-pz2-f39.google.com [74.125.228.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8377E470421
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 12:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790338937; cv=none; b=Tw7P5NyLmdrq9zaiiGMZNGHXsTOJQ13jZXbMGIiC400p73pEM4Flg3z7w3T2DE+Q/SO/ByjYRB5eB94AalznUkvuQoT7U34dvN/+egSCSugMxTMUKRamAKSCfReEnZ7kiS36L2+DFT1P7RrH+p1k6xH5TOU9kK9fmv+W6aTML/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790338937; c=relaxed/simple;
	bh=s/PvtkNVZ4YIzTo0qHBPvGUkdcNJ0VSkXZVSnkH2sMo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=qafA+Az44Hi4smP70ZJ75f07J7qrbSQuFbp1tTjki4rzvrVIeRgDczjOvKVaINNtnjwh9J+3vv+3TCq9L+SSVhPH+BqUn9PpLA1bpj6sb199GPg7O3ZhKADKiFDllSFiCQXSNSdsBhNjFjMTvhC59j7OWRTjy5DNdqpu30m+mcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nz5ctX+J; arc=none smtp.client-ip=74.125.228.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nz5ctX+J"
Received: by mail-pz2-f39.google.com with SMTP id 41be03b00d2f7-cc78d59bb02so165413a12.1
        for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 05:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790338936; x=1790943736; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=uwHCeFBiFb/S6cPK4uw5VdO3mz9Lko0oibblDJPiB/Y=;
        b=nz5ctX+J3OVKx9MQBql1lE5Qn2CiS7jpv2Q0gsc2lC8rBtTZv8dmYJbXctRn0iZfW8
         yAGJXiJccGPyrSUenWrhoyhh2RGMNpaTfxwBU24+/LZvQnCFQYLw7ppah3SHy1zc7Ygm
         tLxPEBtplx7u3yn/+WcTu6zsNAfrjp8cKEqJ/srcsijmfAbtXOxThmzuSFxQH1oK0yyx
         hEBJ1ex1u+rcKTwQ+gz7fR8ltZJYXJMGOT1XISNV53BcNyylkbQVMiS8UlKdxjY6IZPf
         VJ+U6Rvp8pgbtfHlj4jxlQVF4s7WTORAodC1XpAlgZ1wkI1ni7P7zZIe1BJ2fxuIuru8
         Z5xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790338936; x=1790943736;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uwHCeFBiFb/S6cPK4uw5VdO3mz9Lko0oibblDJPiB/Y=;
        b=wL90PwRN7sf1rb9a9mjOgq6DbFnLjzZytsQmRJ8kzPqdi6cpLezTlRbQ2x+aAOLMYB
         1oz/bvEcggK9KRfH4BdByZOB2LThmMEk9AnRujAP8I4M30Omg0DuQ0ciquk4+8Ce3lRl
         OLj+9zjog+3MHdb/bJdCVg0MCFhfbF7b1Znk8VHDBJ+Yq4BdmXFhe25DifgLYef+nzNU
         Hd3ZNkrCMiVsXw6Mhr620+C4dtaAm3yV1SE8jU1ikmgmxavrEufVWq8OFuOSgIiH+zVP
         s0PVlQXj5UEI3/hd/03lo437kpCPK9t0xa7umq/ILCrjghdMHnhV5YK5tJvDolWVtcJM
         louQ==
X-Forwarded-Encrypted: i=1; AKwUvBwwGxAwqn3PHIdRBt+lMHZwCaQKP6ulr8HySq8pVOjFRPt6vbYcHgs4w4aCtdMMiqKXtUCYFrEz6cYb@vger.kernel.org
X-Gm-Message-State: AFuF++mJfyikguCCVruvqYOhywN/tmauoyXSioVIjt5TX3YsN0CeOC4e
	FKSIVs82HqwdY/rh5Fm4Y7Pz3AYTK19MHnAkGyYgNDCWnBJyJ4eLFb/x
X-Gm-Gg: AYBFou16jP7UL5lcNsaWXpdHR/r0rTB6s4dwgEoO58sK+60nViFEV1jnqVz1kigeeQ7
	82i66fgvjBBQD3MRnvhCZ7WGKxL75s1Ljbfcyga5eTLQgxnVx6EzAjWeZE2SiSYhrpZo9pYYhtf
	OmOn8cWgxQ+kq9HVoRq83qq+Rqd0fVjKYm+DQJRLvablpOOlrQa3yvDl7XTPIhq/Vz3167KRGRm
	PR/88a6kV9MMX6RkY7ROUioVHOEZVA6LafdLD5ZOKp+yqYEpYLeFJX93L1GX67FrxTjR1vlLNFm
	3euTPVOigyr5o+yJTG4JOQFfrbdTRZckEU0FKrApf5+VSDUocllPbVGUzhhnsCuf/upDX0fkG+6
	0MBHW+re1z/VqOK5TCt4V+E+FZyaI1JwD5CCqAhziy7ZtiYN5/C5aeeHSLY6ARlZAftz7x7Ir1Q
	neNF4GBSQmrHgFgtPRbkWncsWEWkstdgLeFYuiMFkEWWfmV+NcLcJ+TXbY2Zw9Xi84YIh3l9bDN
	a5iTpIn
X-Received: by 2002:a17:90a:38e4:b0:3a0:b223:6830 with SMTP id 98e67ed59e1d1-3a0b2236c1dmr1533648a91.7.1790338931135;
        Fri, 25 Sep 2026 05:22:11 -0700 (PDT)
Received: from [127.0.1.1] ([240e:b8f:977f:f400:ec2a:b15e:fef8:70a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b9feddd0sm1229303a91.2.2026.09.25.05.22.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 05:22:10 -0700 (PDT)
From: Liang Haowen <nbg2974@gmail.com>
To: Marco Scardovi <scardracs@disroot.org>,
 Denis Benato <denis.benato@linux.dev>,
 Ilpo =?utf-8?q?J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: linux-leds@vger.kernel.org, Lee Jones <lee@kernel.org>,
 Pavel Machek <pavel@kernel.org>, Martin K. Petersen <mkp@kernel.org>,
 linux-scsi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
 linux-kernel@vger.kernel.org, Armin Wolf <W_Armin@gmx.de>,
 Hans de Goede <hansg@kernel.org>, Derek J. Clark <derekjohn.clark@gmail.com>,
 Marco Scardovi <scardracs@disroot.org>, Ahmed Yaseen <yaseen@ghoul.dev>
Subject: Re: [RFC v7 0/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED driver
 for ROG NVMe enclosures
Date: Fri, 25 Sep 2026 12:22:03 -0000
Message-Id: <202609251958.ReplyMarco.lhw@gmail.com>
In-Reply-To: <UuqOxFagT_OBL0l5ZYtfKg@disroot.org>
References: <UuqOxFagT_OBL0l5ZYtfKg@disroot.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Hi Marco,

I went through your SCSI version in PR #17 against what the hardware
told us while developing this series. The class layout fits the
device well: the ENE mode register is the hardware effect offload,
and direct streaming as table write + apply-without-save matches
what the controller does.

A few things our hardware testing can add:

- ene_write() maps the caller's buffer with blk_rq_map_kern(); your
  call sites pass stack buffers (colors[12] in direct_write). That
  is the VMAP_STACK DMA issue Lee caught in my v8: the payload needs
  a DMA-safe buffer in the device struct.

- asus_aura_brightness_set_blocking() will never run on the current
  LED core: brightness_set_blocking is superseded by the fast-path
  brightness_set there, verified with a test module on 7.2. The
  callback to use is brightness_set plus deferred work.

- The firmware effect numbers from register probing here are
  1 Static, 3 Strobe, 4 the rainbow flow (all verified on device);
  2 looks like Breathing but was not confirmed. Your mapping sends
  Spectrum Cycle to 4 and Rainbow to 5: on this enclosure 4 is the
  rainbow flow, so those two need on-device confirmation, and
  mode 0 for OFF is plausible but unverified.

- If the class core serializes the ops with led_access, sysfs ops
  cannot race each other, but trigger events reach the LED core
  without that lock, so a trigger-driven brightness update can
  still interleave with an ops sequence. The device ignores a
  sequence that loses its leading MODE write; one work item owning
  the sequence, like in this series, closes that too.

The 12-byte block write to both colour tables in one go is verified
working, so your direct_write shape is fine once the buffer is
DMA-safe.

Whatever survives your rebase, the verified SCSI core in this series
is yours to reuse; happy to rebase my side onto the class once it
settles.
