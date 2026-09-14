Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CD94756CE
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 14:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789397339; cv=none; b=gDSNkp/WQiFA1kfkT9KugLW2PTVgZeQIXjzrV95zw90ypjZ7bhFSoWC4FaS2Jof2r3/LR8J768kBY52bBtYEVUwHPZb01H8E8jmYpo05aX6KZlucx+27TyWqqPbwTkeZQEbafXT+0AV9EYEpVXhYyxn0LrDiW+m7g1r8cVwHurE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789397339; c=relaxed/simple;
	bh=quh94/AJr9y3llEvHxq0YXMZ9NlLMA110pinXcbYFtA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X8X+F3VZi27j+8HZJA9ON0A1eRAGY8CvGd/PbaKJZ9nlbNgeU8uiTGN0o6wyOENF1rCcoys2qWf4jLTcd2VisIIzaxi6Q13O+CPXwhCVuVZ9Qbk0dXcJeWCM0ekqqAuKhhADI7AGlYPNRmwBntekecsrH4iKU6RTsNM4N7o5Z4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LCnVUhva; arc=none smtp.client-ip=209.85.216.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LCnVUhva"
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-39de4e72b33so1728598a91.2
        for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 07:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789397337; x=1790002137; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=liUHSJz2sQjWxVOaA4OPu7PhePlMRZGkaLaf+qxvMtE=;
        b=LCnVUhvaS+IqM7vgKjBfQ+9o0faLLrgdZ0WIjdrn99qdWrKYFFYzE2SUleT/WM+pmY
         et8XOkBZvlWpghhkUt/hPO/MGbO/9dJ72Ih5fStTsNwbzjcEkywYiWqRxKqUDCxF70vY
         7dt/hksgexRuEO7L9I3W5ztZfPgPPrw3fZle0mPpzhKz6fpNKJQWrGDMCc8nqDDznA9C
         XA+16Md1gO2iK2F3tLuMbYFLTY26CXUDhrHCrCCW5OgHRrfdkLdUUEaQbVYph8/a8V+n
         WEeEUr3epsZN2Zkc4El76jC3IA09O8pJcZl1mpuLEsn66n4UpPoVUiNRkoXhAQllWHry
         6CWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789397337; x=1790002137;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=liUHSJz2sQjWxVOaA4OPu7PhePlMRZGkaLaf+qxvMtE=;
        b=ePtgdAoWLNGNoqS+wM0P1lVWLmbDPDRgDKkYMjl4N5vnQmrO9QRcbM+Lsjm1pdv9yi
         HVyO3jBlX549HUhVk/HKLjH+tekHO0/4lyaTG2ZPPWGCCWpWcn1PjpXvNSX989EfzsV7
         pZry3UoKcoR8DfrIcs6+AftSUufE7FXwCLaeN/s8R25QcL2r2wmlQ+S+TYQX9dvrntIw
         V6UMpDi+2qLuG0qr40j1lRrW7oqSqmGcsyUeNWrGFhlMicn/rt4+s5O45WvOMfZFeKA7
         1vHwp1RNj2/F2Obn9yVxxaGhpQ0f5NLfFRtvm1LL8+LFQfoKmynUFwo+mHBPt8rU4uWF
         W45A==
X-Forwarded-Encrypted: i=1; AKwUvBwKoOVC3gaP18UcsfRfdYsRwnTJ0SEg2AYbUj7UVuIuFwR7scXyJy/+en1h7XLV/vwCznp1qoOtRqQj@vger.kernel.org
X-Gm-Message-State: AFuF++lN2o90QnFadH6Gvqz1mygts9w+eOtq1ZgD2OJ30e4pb4bW5/q7
	M2EUOyfjCNpW0b2PzeJO45SBkKhzD+dhL0GKGhydm7SabcimCnqu9QL78eLChZ+pYyu0Nh3LOVj
	QQlZ4KxBIMzxTwO0HVgt8mw==
X-Received: from pjbft12.prod.google.com ([2002:a17:90b:f8c:b0:39d:a3bc:5ecc])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:582b:b0:398:dcef:c040 with SMTP id 98e67ed59e1d1-39dec0aac20mr5937667a91.19.1789397336285;
 Mon, 14 Sep 2026 07:48:56 -0700 (PDT)
Date: Mon, 14 Sep 2026 22:48:54 +0800
In-Reply-To: <b07b648dd0e914e2f6d10fcfd90225c1ae83a8cb.camel@iokpp.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260913033633.3159296-1-stanleyjhu@google.com>
 <20260913033633.3159296-4-stanleyjhu@google.com> <b07b648dd0e914e2f6d10fcfd90225c1ae83a8cb.camel@iokpp.de>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260914144854.931149-1-stanleyjhu@google.com>
Subject: Re: [PATCH v4 3/3] scsi: ufs: rpmb: Drop the unregistered ufs_rpmb bus
From: Stanley Jhu <stanleyjhu@google.com>
To: beanhuo@iokpp.de, jenswi@kernel.org, mkp@kernel.org
Cc: gregkh@linuxfoundation.org, arnd@arndb.de, bvanassche@acm.org, 
	avri.altman@sandisk.com, alim.akhtar@samsung.com, beanhuo@micron.com, 
	can.guo@oss.qualcomm.com, ulfh@kernel.org, linusw@kernel.org, 
	shyamsaini@linux.microsoft.com, alex.bennee@linaro.org, 
	James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Stanley Jhu <stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 2026-09-14 at 12:05 +0200, Bean Huo wrote:
> "has always failed" is not correct, bus_add_device() only started rejecting
> devices on an unregistered bus after this commit:
> 36f35b8df697 ("driver core: reject devices with unregistered buses").
> Before that, device_register() succeeded and the device was just not added to
> the bus, so UFS RPMB did register until that commit 36f35b8df697.

You are right, and the consequence is larger than the wording. I built
two kernels from the same base with the same config, the only difference
being a revert of 36f35b8df697, with none of this series applied:

  base:                  /sys/class/rpmb empty, one "cannot add device"
  36f35b8df697 reverted: rpmb0..rpmb3, four regions registered

After unbinding the host, the reverted kernel still has all four devices
in /sys/class/rpmb while /sys/class/scsi_device is empty.

So the leak that patch 2 fixes is real on v6.19 through v7.1, and this
patch re-enables what v7.2-rc1 disabled.

v5 restores Cc: stable on both UFS patches. The cover letter cites
36f35b8df697 with the measurement above, and notes that a backport
needs all three patches in order.
