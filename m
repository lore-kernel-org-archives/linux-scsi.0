Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA28486439
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 14:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789999688; cv=none; b=T+OfhvfAw2bLixrYx9bCyfmAGH2/7eaanzEEdeTdIqcSOwxkkJONIMI5ULejPZTI1Eiv5rFO3fv8gOPbdhmDmAsfWu9avTRVBPVwTZIVDjeuHFHUxkbsHK6gTxmlhzl5FxqAQkPIzXtpq+dU6eD/kq3VNxsYqsZLpbWEHxMZdMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789999688; c=relaxed/simple;
	bh=NHBznU/RKpQgFAQzB7weutwQS0p5qU29+fazNItsqXQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iwdaIjDaN3NhoQtO/NCX0PaJxo9QQo+miZCRUTg24Bh7S6MkUfKjE5FfsyjzOkb7xZGoqnNZKneLj+5u6qs6b1ZzDEWSx66D5i1YPm5Gccqa0thZht473RTBfpzFtWcv1SUya+ZZJEGoZBhGCU7s3CTHdIL38kGA2FdD+fmF7ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VIN/dXc+; arc=none smtp.client-ip=209.85.214.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VIN/dXc+"
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2db8e9fe9c7so41855015ad.0
        for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 07:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789999686; x=1790604486; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NHBznU/RKpQgFAQzB7weutwQS0p5qU29+fazNItsqXQ=;
        b=VIN/dXc+3mfctB58u0v6Mi2hpvvnHHwQ7Huu8Ql+dxEI7tIGv9ykgDA6ERDm/Nt2eX
         c871t6y+tXoq2KWOeUE2LBpw9B9vhLPaOYcCb0NwQ5Om7Pxlr5bawN5newyE7Pe6pR7P
         gRdmLVkziTeaPLdrjWDYemNbtHAPdbHiCkOHPPkSJsnhw9tqr2NbmgLe6L2/K+bAMstO
         fexm6ucuTBAvzDvw6s8yQfFDn84Ry9ongK+Iqc3IGha3hJAFSp1EELZEDB/hWj6Cvvfy
         Bu8i22FMqtHmp8z5f7/qlQPjZ/SjbVuoJNHarDY9dFVpIJKXnrcOJkeX2/owIuyCj4Vx
         FbJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789999686; x=1790604486;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NHBznU/RKpQgFAQzB7weutwQS0p5qU29+fazNItsqXQ=;
        b=cukDpm/8dknyeuLthM/eUu9bKIgNE+OIXm/s4McbIFg+GKgWhF4qxWFgu2tF9BH3jd
         cqJIOuDGz7JcrGW692hP4uymn55ZB9mjKsgoRJ6uRowcYuI490u3uAZHyy3jhHWZHl/7
         kGV1o2y+/P3gCGfsWPalr9a5ndzu6aKjINGkaZNDw89T3BLsCXq8wZLLEqQTwG4SrGuZ
         ZPeEujcLUOvpofA12q2kos8cqq3RAIRrK+mfzWuUxTNvjCBOjSb2dTjKYfR/PT5srfh1
         uT+C4Fs3whgSkbtnbctULmBimrNsNQMY5EpXSj4imIqcvMqh4Y7+sfnubGmM0Zw8xZz9
         Ospw==
X-Forwarded-Encrypted: i=1; AKwUvBysNc1IB/g6nnFG8BWPQyy42+3lYI4MzNU7ZrU3rr/h0XHLm+gEjgR+dCNYEEqOPrwVriKwzNCVuCE7@vger.kernel.org
X-Gm-Message-State: AFuF++kT2gghIkFgHawPZ3xonALSrajkNI1mWuA1TYUMcZZLV6Tc5yto
	PXGoZ4jK8/RJ7Y7oTkiQSZLudBskZQAdy6y7yFg7pBDyQiSPypRBy6EygD/JdIWNkJ8IwTBAgew
	wHrL15vKkUL3yA1AL0ow1KA==
X-Received: from plrr1.prod.google.com ([2002:a17:902:c601:b0:2df:3de3:9186])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1844:b0:2dd:c100:942f with SMTP id d9443c01a7336-2ddc1009bf7mr110453315ad.45.1789999685875;
 Mon, 21 Sep 2026 07:08:05 -0700 (PDT)
Date: Mon, 21 Sep 2026 22:08:03 +0800
In-Reply-To: <20260920034953.19535-1-hppiscas@163.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260920034953.19535-1-hppiscas@163.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260921140803.3210439-1-stanleyjhu@google.com>
Subject: Re: [PATCH v2] scsi: ufs: mediatek: handle mPHY power-on failures
From: Stanley Jhu <stanleyjhu@google.com>
To: Pengpeng Hou <hppiscas@163.com>, Peter Wang <peter.wang@mediatek.com>
Cc: Stanley Jhu <stanleyjhu@google.com>, chaotian.jing@mediatek.com, 
	chu.stanley@gmail.com, james.bottomley@hansenpartnership.com, mkp@kernel.org, 
	linux-scsi@vger.kernel.org, linux-mediatek@lists.infradead.org, 
	linux-kernel@vger.kernel.org, martin.petersen@oracle.com, 
	matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 20 Sep 2026 11:49:53 +0800, Pengpeng Hou wrote:
> Check phy_power_on(), attempt to unwind VA09 on failure, and leave the
> state flag unchanged. Propagate the helper result from host
> initialization as well as its existing resume caller. Keep the original
> PHY error if the supply rollback also fails, and report that rollback
> separately.

Reviewed-by: Stanley Jhu <stanleyjhu@google.com>
