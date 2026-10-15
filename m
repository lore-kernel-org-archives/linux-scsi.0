Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776E120E023
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 00:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792024161; cv=none; b=jfqZMc4k5JTwUD4J4ErYsUSlUkdzDSrM8Qm59E9d5zORoEOnWAbFykuuD7aeCKYeepGvUlUYPJ3O7nnWs1ffT7TmW0mJt+W2AT9LB3h24zaF5y8DnODBR6g4a8AN3sqzZByxvs/6aMIzerhqg/ITvrqUlPe9Ya3BtrdqzCIc15M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792024161; c=relaxed/simple;
	bh=f76zHofrV1WBOoj/9TaADqxCXwdrkgkj4Qe6KWAap2s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NrShxCstujCu3HUAF3uLYaJVKTzDsUQcds0SSVvYbkX583mwVJiwl2VDNQD295S/69nifoK5hdxsjgHVx7f2udfzcxabi7NpbwtEYSCxWBuv9JodZgJsPzinbW6CuNdlsFd5dzO8i7zktxkTqx5LjtdCFm+xyWXpCLa37RlRgnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xa/8sQZQ; arc=none smtp.client-ip=209.85.216.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xa/8sQZQ"
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3ac450b74b0so3067746a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 17:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792024160; x=1792628960; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f76zHofrV1WBOoj/9TaADqxCXwdrkgkj4Qe6KWAap2s=;
        b=Xa/8sQZQJJ6UPwsG+/cz1af0F9Afh8NNHo35pUzLGCU7OLiJ19HHmbTHSHDxJ7jC3W
         zLbIP5n2WHBY+LRwDANkxfCBlYOtoS6nlvTvy6SOpU3fXicAlfT9B445tGY8FDTJTho9
         JON7B2p4m0WkCfp1G1pd2HkqkPm2GuR8YlDG/sB9hM1oCnLFMmnv0PIAlRsrx1w6jZIn
         7thtaj9niB9JoNdd2S0txLmC0laIyXumrO7WFd+ZF1W7u64ARb3Pd3GF2Q7VCF9TBISc
         E4tiykeyghWb9oIytPWW1RNrYEYYhYxMh+pGqWF9ryekIP9VvlJMrC2zjDRz9qrYCCE9
         IiwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792024160; x=1792628960;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f76zHofrV1WBOoj/9TaADqxCXwdrkgkj4Qe6KWAap2s=;
        b=Re1oTc2f/Z+sasDPXbOIYUVgUdKFeyOapy9hll9Z2MsBnxOjgBUe9juIxIj6HYU9RY
         RX3KN2Eos25nxZ97H2uNLJ1KbaUUQ42yUohAE9vRvucThPf1Kuo04C4tHj5e9Ajct8JS
         bEEf5Un3hEXbveywzPBpFOWldigAMFltnQ7BOeWib+mguFCephCk8PNVmp9YzUFF8rDE
         qeVTggZynXJd7UgCqK195IGFSemtlq6se3ApVfRjDdU6cpVn/HFK5hx91Sm7b/zI5oA3
         iS4Gpv1ozp795UmWB9Kfnw/EI9jPO0JRPqqQZ5rKyJtpP8c1pMWwoqAqkFNv7xSMha8L
         NrlA==
X-Forwarded-Encrypted: i=1; AKwUvByVETWPBIQZYp3R35ZnZizVZSpraEUu9IVu+SBfJ++3skr5Cd3nOkjECflzbYNC61nV4FPm46eUeUHG@vger.kernel.org
X-Gm-Message-State: AFq9FYJDqR2EAm4K+rjEXzzaSKv/0vqZiBkgKK5w4wp27ivUXnZWczZE
	5S7q2gTaFd3bf16gDvwDHHy19yHC+oD1P/6Saz1F3lCbpx+UBBUJUEA2jVo+fDFJybb0DR2Quga
	YQOzn2eml018YcmKMNBReRQ==
X-Received: from pgbcw1.prod.google.com ([2002:a05:6a02:4281:b0:cc7:6c9d:d39])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:538c:b0:3ac:80dc:f406 with SMTP id 98e67ed59e1d1-3ac80dd0135mr2341643a91.50.1792024159608;
 Wed, 14 Oct 2026 17:29:19 -0700 (PDT)
Date: Thu, 15 Oct 2026 08:29:17 +0800
In-Reply-To: <sashiko-outbox-169538@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <sashiko-outbox-169538@kernel.org>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261015002917.3469020-1-stanleyjhu@google.com>
Subject: Re: [PATCH 1/3] scsi: ufs: bsg: Validate request_len before accessing request
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K. Petersen" <mkp@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>, 
	Brian Kao <powenkao@google.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Oct 13, 2026 at 10:44:34AM +0000, sashiko-bot@kernel.org wrote:
> Later, ufs_bsg_request() sets job->reply_len to 104 for RPMB replies,
> which configures the block layer to copy 104 bytes to user space from
> this 96-byte allocation. Will this leak adjacent heap memory to userspace?

Pre-existing; fixed separately in bsg-lib:
https://lore.kernel.org/all/20261013132708.1669415-1-stanleyjhu@google.com/

> Should this error path instead call bsg_job_done(job, -EINVAL, 0)
> and return 0 to ensure proper teardown?

Yes, done in v2 (1/5 and 3/5):
https://lore.kernel.org/all/20261015001855.3450573-1-stanleyjhu@google.com/
