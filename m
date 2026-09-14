Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645DF3DAAAB
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 14:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789397336; cv=none; b=pADK3kWh4Ze0kp2UNRUWGgG/kWnfmPjcqRbA7v8kZVrQfwIgbz8mwqcGH9bNrk4QaQtGzVm5f+D+3aZ6O3M7ftV0qlymMtrbSMj1WGN0rZacIJ8gqfLOgwufIQ7oW6RH9Nip3lSK3y+lb9Npk42/ahX7pAZpv0Hfe5G5zm81yS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789397336; c=relaxed/simple;
	bh=1XAHUwjh6zUEXQ3bvhPhcRYD27b50yX9tdUAkDOts+o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AQwWsaTMQYKIC2SJXtPAsp5puqtZGsBUsaOGgGDCSgvKb48ZAz/QmA5paAWBfqQNiT810VkgEIlfpdSAvQaH3zB+xP5e4YuM2CLWBg5o1JjyhS4EiLWRYqC0TZdxsz7QG8bZrSclCF7EHFy83W9HSUn2xVSi28i0oM0nactIIQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZHp+DMEX; arc=none smtp.client-ip=209.85.216.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZHp+DMEX"
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-381250979d5so3763915a91.0
        for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 07:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789397334; x=1790002134; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1XAHUwjh6zUEXQ3bvhPhcRYD27b50yX9tdUAkDOts+o=;
        b=ZHp+DMEXvmSaOoDradMCGJm68rbJ0zekWk2X4vBxUnYktiPmuTJHfU2BuYgmyh+ZvR
         GV9IWlyUe5kX0czZwJNkg6XvAR4MqN846Z0Hb1g8wnVFl4HlW+qPfRSnvykhhF9d6sJ5
         aCuRNM4rQtZJ4dqqlItM0F2JhbqCV7m8q/8IDcsFBogGmNxkjo39b6uAOWAlk4EnkEVN
         U0ohdqxE8GfQGC6R2RYnx1JqtnmSqEtrk+A5GXnqvEPu88gHfZZ3/aps4nBk0+mrIEt1
         FXg7Pf1h2eteBI8GN34m0nH/InaiAMi2uysEkSw/LGlnGKKBY25PDqt9hLLty1JNlvwc
         RdAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789397334; x=1790002134;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1XAHUwjh6zUEXQ3bvhPhcRYD27b50yX9tdUAkDOts+o=;
        b=dt6chEd9SffUyxUSRnMnCJ+eoYRKvfep7A0xfu4LfMDcPTtUXdIPzhGadCtIiTnqpa
         o2NXmJQNHhDRTI0xzkovJambFtbd5wjW3bKxTMecfHHbx5J3xuTpulS9Fi49vw/1f9EY
         DZilAW5WHS1sQW7hMNjtQL+1llqftgVLZKpm6Ta7o3aZz9aTC3bcf0T17LF5O0Ezi7Dt
         a3zib5WYBTNaPnGbiAB11SWUCk2O0aOeBybn+cfE0rfv211Anfw6wv1YVXTaYZTN42n3
         fBQXlDYE0jC1A2y5uA4aMf1+dJASwyJgxByhwt7PJESTtALT/o5hWjIIvXTnfLsdw/mh
         Wayg==
X-Forwarded-Encrypted: i=1; AKwUvBxk1j46Fxe8VQ9dnwmlQ2SuDx0lNOpz9P/yTuxBhLmv3TFVAl2Gqac13QAMNOv15rxxdvywHxSMyBZu@vger.kernel.org
X-Gm-Message-State: AFuF++mHy1DPdCNnCt8SX+CkOSq2otT4H/40zR7igR2W6RNc2P6vhZ31
	M2n4K0Xt/bvjYS4GOkCSsiVdJOQRu1nd66wawSMpw62O9yDob1kYRpLBs9zMe9BlmOPlXx/bpiV
	XZ8Oc2E10J6Z2INSP+T4CBg==
X-Received: from pjbbs11.prod.google.com ([2002:a17:90a:f20b:b0:39d:93fb:c298])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:e7d2:b0:398:c0ad:711c with SMTP id 98e67ed59e1d1-39dec08d844mr5799298a91.15.1789397333949;
 Mon, 14 Sep 2026 07:48:53 -0700 (PDT)
Date: Mon, 14 Sep 2026 22:48:51 +0800
In-Reply-To: <b1fccd35bf35abf384c31bee6cf3040e02051755.camel@iokpp.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260913033633.3159296-1-stanleyjhu@google.com>
 <20260913033633.3159296-3-stanleyjhu@google.com> <b1fccd35bf35abf384c31bee6cf3040e02051755.camel@iokpp.de>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260914144851.930983-1-stanleyjhu@google.com>
Subject: Re: [PATCH v4 2/3] scsi: ufs: rpmb: Decouple device lifecycle from
 devres to avoid UAF
From: Stanley Jhu <stanleyjhu@google.com>
To: beanhuo@iokpp.de, jenswi@kernel.org, mkp@kernel.org
Cc: gregkh@linuxfoundation.org, arnd@arndb.de, bvanassche@acm.org, 
	avri.altman@sandisk.com, alim.akhtar@samsung.com, beanhuo@micron.com, 
	can.guo@oss.qualcomm.com, ulfh@kernel.org, linusw@kernel.org, 
	shyamsaini@linux.microsoft.com, alex.bennee@linaro.org, 
	James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Stanley Jhu <stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 2026-09-14 at 11:55 +0200, Bean Huo wrote:
> why uses list_del_init(), list_del() is not enough?

It is. Back to list_del() in v5, and the INIT_LIST_HEAD() that v4 added
to pair with it is gone as well.

> every entry on the list has rdev set, so this check is not needed?

It is not. list_add_tail() only runs after ufs_rpmb->rdev is assigned,
so the check can never be false. Dropped.
