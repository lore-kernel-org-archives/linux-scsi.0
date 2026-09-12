Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3999A29B78F
	for <linux-scsi@vger.kernel.org>; Sat, 12 Sep 2026 13:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218980; cv=none; b=uwOAF6ME0vyy2MRAPupbg3WU7ZWYN+eLXb32+z0kBWOa/V5dChGvTvngukjsdptaBHNeYz8C1p6wbMrv2PF4nDP+35KobcKmdWVrK98G2SCPgxy0S5E6tWnnELbMEmdpK7FAH/AjP7LyKS1HnWw2UhdloGMEHGNpy5boBvBLakA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218980; c=relaxed/simple;
	bh=HvysXsp8YIkOmXS5CAmLVs5KFaoAs3hYXoJHWlT4mD8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mTj4QfgVPOFp+kvlrDSUejL4r9wgSKTGuATUTQvAmMB0iO4028Rp4eoe1f6fNPMM7bumBqAYeelhVCJD3gJiAS6Cww/qiW7+CaKj/oQU/nR15PzbuRVDmEMGSELiR/EzqinD+77Br/tCiSGuGb/gg6G7wjPPkSpXu4oDV7byaqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iwk243SM; arc=none smtp.client-ip=209.85.214.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iwk243SM"
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2d6fb956002so21738115ad.1
        for <linux-scsi@vger.kernel.org>; Sat, 12 Sep 2026 06:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789218978; x=1789823778; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HvysXsp8YIkOmXS5CAmLVs5KFaoAs3hYXoJHWlT4mD8=;
        b=iwk243SMnc5/PyWmyXrrAKUl1RQl6tuKj4kv0pHzrvSEnPD3RjESDlnvjDoiCdB86U
         veWMJX2SX++Ts6CghLspgc92vdo7Xxu+eRyN96G841wviq8K+oQBBd5vvFAiF3jyDKKV
         AI9c0HUU+C4KbNexWkIMZnYWuEVF/eBrZKcFONR4hPzksIl4a+89+FmL0H2ryRbSLHrV
         62rhliKwX63yChuFwVKxmvg0Vb0UWeNjU1Wi427zzHscyZcrsdXicruyFjYkd/Bee8N2
         m9p/0Nik3wLf/ptecMiPoTIDo+9A7uh4L0LPWh1Es5Y538WAXl+JNzvQyXTF9iVI7GFj
         d0kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789218978; x=1789823778;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HvysXsp8YIkOmXS5CAmLVs5KFaoAs3hYXoJHWlT4mD8=;
        b=HwmAJE9s1pbM6VZ/DljHHa3WzYnKHTfGG7bPGMlf0ARcE3c1C53W98OWPXutwOBblm
         37lJODVPhLT4RicbuTiVoGBV3UMQVnm8hE9P6RauRTf2IFHcvdJiqehGPK1cMgpwRnub
         tobhaejKadFvipaIdLsLnryHFt+mden3G6BYReTnMM1GbhTEDThCntkPR5w3KcrchUMI
         IKie/RPB9FDaXuHoIFOsFbsMNWy4ZCjNDkfUdCjGJnVfoiXnGEVLgVVuSw6zZ8WxuUH1
         dMW4Z7APRKoNfux+YfjojZSggh+Y+Met4rq6Oh0PEszVHXoBvDDt/cZ9jIfz6dmQPFK3
         4+CA==
X-Gm-Message-State: AFuF++nMyTbqGy6e74kNMNhTPLEON/Ic6PGk+WeryhqkLHdqsPyq1mDo
	8Q4AyiscJ4s1kxoWIwW26i8I0zjpdLKHAqfNLdCFHRJKPgkyW+VbbgshUTemfpLcdJJ++takQmx
	aSTS8+ZUCL0E+Z7cH8edfyw==
X-Received: from pjwo14.prod.google.com ([2002:a17:90a:d24e:b0:39d:c293:4b7])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:58e4:b0:398:9c0c:7c71 with SMTP id 98e67ed59e1d1-39dbc70b960mr5437689a91.24.1789218978259;
 Sat, 12 Sep 2026 06:16:18 -0700 (PDT)
Date: Sat, 12 Sep 2026 21:16:16 +0800
In-Reply-To: <20260912100325.4835B1F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260912100325.4835B1F0089A@smtp.kernel.org>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260912131616.2301278-1-stanleyjhu@google.com>
Subject: Re: [PATCH v2] scsi: ufs: core: Quiesce SCSI devices instead of host
 tagset during error handling
From: Stanley Jhu <stanleyjhu@google.com>
To: sashiko-bot@kernel.org
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, 
	Brian Kao <powenkao@google.com>, Stanley Jhu <stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, 12 Sep 2026 10:03:24 +0000, sashiko-bot@kernel.org wrote:
> Will this loop skip devices that are in the process of being removed, leaving
> their request queues permanently quiesced?

Confirmed.

The old code unquiesced every queue in the tagset, including queues of
devices already being removed: a queue leaves set->tag_list only in
blk_mq_exit_queue(), which runs after device_del().
shost_for_each_device() skips those devices instead, because
scsi_device_get() fails once a device is in SDEV_CANCEL or SDEV_DEL. Their
queues then stay quiesced forever, and sd_shutdown() -> sd_sync_cache()
hangs in blk_execute_rq() with no timeout, since the request is never
started.

v3 takes a different approach. It keeps blk_mq_quiesce_tagset() as before
and only unquiesces hba->host->pseudo_sdev on top of it, so internal
commands stay dispatchable while the logical units remain quiesced. Clock
scaling and ufshcd_pause_command_processing() are unchanged.

Bart's Reviewed-by is dropped from v3 since the implementation changed.

Thanks,
Stanley Jhu
