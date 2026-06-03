Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55A4332918
	for <linux-scsi@vger.kernel.org>; Wed,  3 Jun 2026 01:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780449515; cv=none; b=TgBgrbDZ/aJ8i0bNfdA3oCn5/ni3vtCLekSnAgc6q42ZDPEsq4dKwiCZvy0JOfPPM0fC+A/mRxBo99IAFKXnhNcS3muusC89VgaTwoxzzm1c3f/QY3kNN+TTLu/LJldRVuFNsw9Vmqj8/k4A1n+d6uVQG6tBPA7wIEYKLlwdbOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780449515; c=relaxed/simple;
	bh=FYtGGL1/9gkaKBayFjF25MuXIkqbjMbsLb0OuzhZ39c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ox2OaRtrWjcHKog+WmB0KeX/8I1CU6odTWQ+gi8LnZXHUWPLFJsM34OXpIqd7GlBFyFr66o4/60gdklmf8I3hqbDjkVD/7tu8j0gBaTn0kylz/X+CmG//g1+5f/NQ5AWdk/sSjfgJDsXbzPiiAD8Jis52477N6Xnopz10OZuDJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=ZkKxvjoN; arc=none smtp.client-ip=74.125.82.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="ZkKxvjoN"
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-304ec41197bso5167129eec.1
        for <linux-scsi@vger.kernel.org>; Tue, 02 Jun 2026 18:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1780449513; x=1781054313; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3EsNGXVMOKbz2/CTTFi3e9ysbX77gnOD4T4woSqkD40=;
        b=ZkKxvjoNnsiQ3oocd1WiPfXb9HnxKcWQnLgPrs1cQrxsaIyHTzZCNGX1ydjURbJ2Y4
         6l05uZ7RTUynRU0AZ/2xfUGwYSFHTst/hlvVMdGIjVT3jAC1mAJfxdckeaeGyk0YElsZ
         vsKV9PqaKb4lp3LaYiDP6zjKVXcnbbpwt6vT+B5GknjzrfLAMDqntINCDFEzXgWaGzPB
         B2WBV8F1BZX3AFgXyFWO+seVtMjU8OJUnYTysM7ZneK9gg7URGT71awnxTO/un5iUHBj
         tmIFC4QK3ejtMPpgi3wqqcmZXx3nLu/uylqlxzhhmDj3pJVWDk6npt067ZxRF0jzXq54
         PJcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780449513; x=1781054313;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3EsNGXVMOKbz2/CTTFi3e9ysbX77gnOD4T4woSqkD40=;
        b=IJ37WK5s3dqoaGxXf4jGylZKudxLCCpvUns9JZPCxO7dLr95pgduBj3tGf8ibbMi/d
         dCRIadh6DkmWMh6F2k7RLBf+mByNYgpmlvoc4+eYL8H7gB77B7YsRDiIbP6tWcuiW0IA
         QFOJ9a3+jZdyf18u5OXTtIvc2I5XNzCHorgrU6oQ+CKmCGDPrQFQwh+XsPuzGzAbm4Lt
         xXn15W08kQP9qWS9J4Gjkiv6ziwBvLLMxvfHn9cW34FfqNUf8lGFHhSAM9FRCkLrexwa
         jPmMvmVkPXgL+g6dh2KEP2U2lm7CQSm6L+vN1ilr8/8Q/Xnn4dYFqH345qPIDI0wzDBm
         da0g==
X-Gm-Message-State: AOJu0YwxLDbfi7CLPDIf7ZEdqmYJYdkMjjP0CT7kO4CHhQt2WEIQtnYj
	ITx2qs2a2YVaOiSDLWTdDqQ9jgvhfnIsxkh32MdAJ4BB+sMpocg8wqHWcecD0ZPE0+g=
X-Gm-Gg: Acq92OHeIEz/+T4b3K3h/gBuZBO5NQdnN//gwvrdScAI7SizKM5ptlXmAZvUue5ggEA
	Q2ZqF499e5b/SEZPS2jvrvbv3FMMNzvF9Rfrhaz9iTa0I4h2Nv5HKpOSpvyHUvSrWpCHWPSBRd2
	nZF/yQ30QlAPaXl9snfF1PW92ComaSuIsWMD4L7QHv2YLszJC7gq+1DXXf/8pBDK2cJCk8On2ri
	IsRRULZmHABHJkHX48/7YpCDDZYm45Ng7OGL9zHOqikrvm2PshCzLehR1mEsRBG4Fh3SMbRGdNN
	hjtL+6ubbgNSaBK5q2DfYXXbJYuD0t+kXs1TcDe5SSET0ylzx4MH/dbnmWDaxzeJCwtQfp5Ivwx
	h61bhwUzdOl+VdaBUzn/q+E0J9/1JZx9RE10B5qxzyfej1PsnP6QqL3NJ/CaOdcQ0k5Xa4hx0ER
	HA0zLN1XTYp/YBSLvbbtRsTUwul0tAJ5RplklLD0jXJqG5WRhHHxpaKdoaWkHdXw/VODwwNSmIY
	iHStKNMq/rootJw9xJvOZZnvrGB9bc6PJvMMb7tvx6aLP7B4RrIH5AQMwZ2xovdoayjfaKEZawu
	yrDIAa1oCvFCsTnXVTBPOR8X/qOwcjnnMck=
X-Received: by 2002:a05:7301:578b:b0:2dd:8ac2:9f7a with SMTP id 5a478bee46e88-3074fa65b7cmr559766eec.11.1780449512720;
        Tue, 02 Jun 2026 18:18:32 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.117])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3074df64eb9sm859631eec.25.2026.06.02.18.18.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 02 Jun 2026 18:18:31 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: hare@suse.de
Cc: linux-scsi@vger.kernel.org,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	bvanassche@acm.org,
	krishna.kant@purestorage.com
Subject: Re: [PATCH v4 2/5] scsi: core: Add scsi_update_inquiry_data() for updating INQUIRY data
Date: Tue,  2 Jun 2026 18:18:19 -0700
Message-ID: <20260603011819.74466-1-brian@purestorage.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <f08a3641-3ff9-4a80-bd20-adc52d802de7@suse.de>
References: <f08a3641-3ff9-4a80-bd20-adc52d802de7@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 6/1/26 08:44, Hannes Reinecke wrote:
> Hmm. Wouldn't it be simpler to do a memcmp() on the standard inquiry
> data? Surely we should reprobe if the model and/or vendor name changed, no?

The function already updates vendor, model, revision, and all other
INQUIRY-derived fields unconditionally before the reprobe check -- so
those values are always current regardless of what the reprobe decision
is. The question the reprobe check answers is not "did any data change?"
but "does the driver attachment need to be reconsidered?"

device_reprobe() tears down and rebinds the driver. The two things that
determine driver binding are:

  - type (byte 0 bits 4:0): selects which upper-layer driver handles the
    device -- sd for TYPE_DISK, st for TYPE_TAPE, sr for TYPE_ROM, etc.

  - peripheral qualifier (byte 0 bits 7:5): scsi_bus_match() only matches
    PQ == 0, so a PQ change directly affects whether any driver attaches
    at all. This is the key field for ALUA unavailable state handling.

A vendor or model string change does not affect either of these. Triggering
device_reprobe() for such a change would mean dropping the device lock,
calling device_reprobe(), and re-acquiring the lock -- for no reason, since
the same driver would simply re-bind to the same device. That sequence
should only be performed when the driver binding actually needs to change.

Checking only type and PQ triggers reprobe exactly when it is needed and
not otherwise.

Thanks,
Brian
