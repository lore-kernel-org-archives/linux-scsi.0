Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14267391822
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2026 06:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790229903; cv=none; b=I5+/O/AN2vsMLEJwxEkqtiliID0eoeAZZXFKK+7C6TbG20bvQhU+luQGrWLrAJG1i/F3FuZmAMEaoqVKVD1HuBzRYmPEMEmtV2toXwUsoYHa/0LcbOj+26qNTdLEfNPDsq96iuVNADtsOM4EZDUWn58GnRgNoGwsogCVCCleqzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790229903; c=relaxed/simple;
	bh=5hZLI/kIQpbikAHkHpMD5b6GN/lBgqrwDhltNEQCbYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xp3EkG4CehxZ94aaD0N+BqWNGbNGhWn+D7WyQh1SMoq04pShVGPyDAbHDTmlJ2I2NQZ/lQjlCSiSfGgGwDnKmEGWIRbBOAJYuMwDL8eI/OaUpPgBvIsIgfYdpqXDGP6cC2aDRB+jCUYIbsManOlXEvGg3GKK7+gaKDwtMzRv8iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LQAOdMYz; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LQAOdMYz"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b91369d18so11247725e9.0
        for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2026 23:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790229900; x=1790834700; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n0MllcKz8m82n4vcEekbO0+kdiwKRbPnFxBUUcpz3O0=;
        b=LQAOdMYzM5PHZ3Rv4IBidx0WBUpOP66/10x8GIalQlejYwKP16mFmkUwgSadrzC2Zm
         JsOKgmGo+s20Ls4/a53zC4PMnmjPzJVPzbvgCzhm+bOEjgxbqz4Rhk0LFj3ZRcjiPJoB
         FHu6nWqf0C81HW+wEY2nLhTFh9acz1xZWQ0yEoDPLQtYgRW1VChK5keO8gUuFWX2RAxT
         /VcaEZGVm+I4AJc00ySP+qmuyH8OnoYTukkijirJVGu+4+go/e5mf6wI7HEfWHggfNvF
         90pG3nq1eXxAniYJs2Wby+othan43OOSBja4OW9nzgtuyxil4sFJyYdqccuCsxRcMFj0
         gE4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790229900; x=1790834700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=n0MllcKz8m82n4vcEekbO0+kdiwKRbPnFxBUUcpz3O0=;
        b=YsCIesp2pjPyqIJecNiZg0wariKBG2GU4p7GQYQjeLq6HGsrvahdcWzdBvbWy3JJoO
         OTFnqEG6zXDVOKuM3siM55sGkOWmq3k89l04gxud8REOj0MVwmZr8TJd9SwWu0Gg7tWa
         39t6OHRpaVAxZpcrQZ7fMhfHy2Fs3QwJ4lH55bKZOPELpU7TIOWgiOrA0kkwexci0Rf1
         51GxjnzuDxaBYgTFvA7MB4cMakPa6TDAnIREXJCWlnU1oqH94PVd6C21AXbwxmbkz/5O
         L7NGavLBSKa4xIInvI7sHDKcD4WbN6a55N9Hmplik8qQacK3dMQvWBGorgO65d9Pzy9c
         usEQ==
X-Gm-Message-State: AFuF++l9mtbp85Ii5RdcgYe8fp0GcbcChsEmb9gcrZF3XzSvWxqHa+C9
	uqHpgAKFk1ZvSbXITQJqayHrXhjGWcugA2Q66Noln1q9PuyHIprZBmzg
X-Gm-Gg: AYBFou2eHqgBHLHuvn5SVa3Lu805Ql0AlGVO5K0OuoARJDRqbAt3pNy4pwg3ckAVq75
	t+CH06JGnkjaa8aQ6pvfm2SrFBPu3ds753teZHhPirg2iY66KvDWw+PRAgdkfn9FpffoiPfNKZj
	35KuCJDjqOK6wCM9XhS8mvM3h2BCOTPyJpJ8gDaXeBjDqSicBi9EQQQmfQHRuO6jKHouou/YNuF
	UFl2BZ/iNEZM8rQzU31i4uyejsC2ALUzdguIo68ISvXrpLEDr1fulfwwn3TyHlO/1IZtzjDsQ9B
	E2Ik75U1HyRzZPaFSYwfImOfI9bX0JfHKXcQWggYYi9H+aWveO+0491E1tzbcQ4hQ+bkkjfhMtM
	GGKuij5zYMRANXdp8f24JJPp1ZzwFLpNNZdMqBFG5afLwDDTVP/RkngAsml9bdlMgardfxGWLBw
	oFgM59X/0+k9sdrjCYK1FmkdryTtW7HW4pZivOcIQ9sSAc5ihjLgnE9Z9b2J5Y07uV2pv9125LB
	SdFFysyM6dkeFWhVMQFohnmg7Z2yp+EOlE=
X-Received: by 2002:a05:600c:468f:b0:49d:1df8:156d with SMTP id 5b1f17b1804b1-49fe66e6438mr22822725e9.18.1790229899991;
        Wed, 23 Sep 2026 23:04:59 -0700 (PDT)
Received: from githubb (bba-86-97-124-202.alshamil.net.ae. [86.97.124.202])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fe5de4de4sm43099825e9.8.2026.09.23.23.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 23:04:59 -0700 (PDT)
From: Ahmed Abdelhaleem Ahmed <ahmedhal@gmail.com>
To: James.Bottomley@HansenPartnership.com,
	mkp@kernel.org
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	loberman@redhat.com,
	yanghao_ht@163.com
Subject: Re: [PATCH] scsi: ch: Do not keep references to data transfer element devices
Date: Thu, 24 Sep 2026 06:04:40 +0000
Message-ID: <20260924060440.33252-1-ahmedhal@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260922-ch-dt-leak-v1-1-2b2e40bf1624@gmail.com>
References: <20260922-ch-dt-leak-v1-1-2b2e40bf1624@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

Self-correction: that Fixes tag is wrong. drivers/scsi/ch.c is not part of
the initial git import; it was added a month later, already containing the
lookup into ch->dt[] and the kfree() that drops nothing:

  $ git cat-file -t v2.6.12-rc2:drivers/scsi/ch.c
  fatal: Not a valid object name v2.6.12-rc2:drivers/scsi/ch.c

  $ git log --diff-filter=A --oneline -- drivers/scsi/ch.c
  daa6eda65a53 [SCSI] add scsi changer driver

So the correct tag is

Fixes: daa6eda65a53 ("[SCSI] add scsi changer driver")

first released in v2.6.13-rc1. Nothing since has touched the ch->dt[]
reference handling: the only other commits mentioning scsi_device_put() or
ch->dt in this file are 66167283c21e ("scsi: ch: fixup refcounting imbalance
for SCSI devices"), which does not touch dt[], a2cf8a6306c8 ("[SCSI] ch:
Check NULL for kmalloc() return") and 85bc081f44d5 (kmalloc -> kcalloc).

Please amend when applying, or say the word and I will send a v2.

Thanks,
Ahmed
