Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793849031;
	b=JqSX+IRCn7Ea/efWgKKprNX6U43J7VGhuA3ZhtxDhB8I/mCmR2qzVfPle9AzKSk3w9m0
	 CkOeTq+hq8GBbq+VOEOdkWrYO2jz4L0j6CN/9Tn01PH1KL9QC3Z0+A8LJAw7Mp2uvV/YB
	 Nx8hVpFTIXM06fvUDykf5mXcToKfNZ3wt7bXa2G4sQOjGxiqS64DzYDizLvrBmjEfkvqb
	 isufKhI7JwWm0eO80OAFfw3WJ/mW/5O/fJpLaabl78qgrNDwIJxfeQVlGcz2yyWrCuzU3
	 MWL6VhdP3qIvmZyWmYe/90KmiBccL7FANVE3lx0PtPoxVlJtUOLVBqfd/noGpKkuaig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793849031;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=mIk5VhBNepuksZFeyzjzGMSh3zqdxjJnepD62bUDK80=;
	b=juZhlqvDlEhJhk/+e7Zn5pp+KwxjQdCzlpcKtl2qtUdVqYXDIHqfQm8bbUbzXSp8NQFm
	 //79TzElncm3Dn6Qy/nqY6A8Md+IUngQCp2eQPkgMgH7U6EQNmJSTdQSbASj+F9Z2zMED
	 wU77GV4FQlbmnQgEU/NrtK3CW0jTWqm6mqjG2S9Ddm9k+3fYCU2ksxt+aruUIYr3y5bV8
	 HAzKdjQSzSidfisXQ9NOnZpPY8mV5cS4OL3ep+MrIW342mXg5LucoqHK8s3TxrAtNRhSg
	 5dKNaCaGeDp0XFVONHcLjdNwxtYfvSpKF+AeSlaTg8VdihiEKgnbmQTV+1pjPnxmtdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HgnCBHW1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B59606A31B;
	Thu,  5 Nov 2026 03:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HgnCBHW1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789251F000C1;
	Thu,  5 Nov 2026 03:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793849030;
	bh=mIk5VhBNepuksZFeyzjzGMSh3zqdxjJnepD62bUDK80=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=HgnCBHW1LyIjX3UR38PqIl3Stf20fgHU2dftsXKzmTGefDm/2EP1EJqrczu9GN0sv
	 J+KsXc/jCvPQThv3QZ2ZBXMWxUuQq2VDijdxUuqj0EMPnLCtVwKK3PrLug8oqBtLYe
	 yga9i+WjzAJFqRy7ZDvIhKhl4t/EEHgBprR91rzcxJZ9lsIH2+nTzn/MB3X5f64AX7
	 1TaQrHIgVEKHAOBjVUP3oeAghF0iAAYfqJWGGQOpFnAKqeR69Sc0zLutXcqe0VhMv/
	 e8qzA9KHaxw3R5zZvVhetOWu49f7VJKssSCHDZ3VlXVygsCP3d0d+lstKcE4ej62ls
	 Ybk9n74ipw1HQ==
To: Stanley Jhu <stanleyjhu@google.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,  "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>,  Alim Akhtar
 <alim.akhtar@samsung.com>,  Bart Van Assche <bvanassche@acm.org>,  Bean
 Huo <beanhuo@micron.com>,  Can Guo <can.guo@oss.qualcomm.com>,  Peter Wang
 <peter.wang@mediatek.com>,  linux-scsi@vger.kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] scsi: ufs: Fix device management timeouts and
 runtime PM errors
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261029040003.2100003-1-stanleyjhu@google.com>
Message-ID: <yq1pkwkyn9f.fsf@mail.kernel.org>
References: <20261029040003.2100003-1-stanleyjhu@google.com>
Date: Wed, 04 Nov 2026 22:23:49 -0500
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain


Stanley,

> This series fixes two problems in UFS core entry points that issue
> device management commands or touch host registers.

Applied to 7.4/scsi-fixes, thanks!

-- 
Martin K. Petersen
