Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A867625B098
	for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2026 02:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786674055; cv=none; b=VSV0X7Hx+UxROnL3+dFUvyBb8lL5+XslpRS22dWrRNc2rb7cPO/nFmiKBmW4TbMvwSgDVxnxuVawBD8gewHHcoK4gYbj65di/0RyQzrwUH/8z2RlIwyOl0wA3D99ICkmza98PmMvuzuxJtiU849OzSFiOkxFD5JlK3vLOpYclis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786674055; c=relaxed/simple;
	bh=v3X6lv3TPvoIPwIz+ywHxnd2Ur/QWo30D6nNDjSn23Q=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=ogMfba7hJommpjbtIb6Mxtmmo26Q5aSslJEjbKYY4G9pvWFUceFbmnl+MIW9ZrE1BJHPLLVhIFev188mI3uB6QoB/k4MgXtHuets+H8MQbYfiVaHNzWvnbg8BWAnaxGLrZPSPJTHBVkCYosa9qYIcBs1kkWb76tLxMXIWfoCwWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jjg67Mix; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jjg67Mix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0851F000E9;
	Fri, 14 Aug 2026 02:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786674054;
	bh=ntKqZaw/7dHIJLQ6Ro0Sf7Dv1RnpOJ3zbkKO++yUb7k=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=Jjg67MixF7Dgzw2Kq5lgBOyV2aXc4dXRBlP6VaM1otZJY7yIwPmrwEI7xhugwVnWB
	 xvRT76Ue22zHdhsM2cJOrZFOMDPvMyjB/cgNK3bNZuJ6bMOmF/AFNvZXeht6nIf/WE
	 ivEOSOpgXcXxkAa3dN77w+uJM0yRpXiy4bFuvn3Uv73m2zyAty+BoDRer3d5yzb5kw
	 89QiQOi2iOQ4HUYDE/1qRl78ZmiqmimvLQPCeklhxS0vYzFlgPIj9Qh60poy1/MTh8
	 YAIRGHIuMVCThLgZZKs8K83sEd1x2Q7HDx/7YxySEV+AgMUGbGPak03RUvaPYk71Z+
	 ZhpmZ13rQQcSg==
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,  John Garry
 <john.g.garry@oracle.com>,  Marco Elver <elver@google.com>,
  linux-scsi@vger.kernel.org
Subject: Re: [PATCH v7 0/6] Enable context analysis in the SCSI core and UFS
 driver
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <cover.1786142946.git.bvanassche@acm.org> (Bart Van Assche's
	message of "Fri, 7 Aug 2026 15:49:45 -0700")
Message-ID: <yq1fr0htpcb.fsf@mail.kernel.org>
References: <cover.1786142946.git.bvanassche@acm.org>
Date: Thu, 13 Aug 2026 22:20:53 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Bart,

> This patch series enables context analysis for the SCSI core and the UFS
> driver. The advantages are as follows:
>  - The compiler (only Clang) verifies whether the lock and unlock calls match
>    what has been declared via __must_hold(), __acquires() or __releases().
>    This is useful for catching locking bugs in error paths.
>  - Support for __guarded_by() is enabled. If a member variable is annotated
>    with __guarded_by(lock), the compiler will issue a warning if that member
>    variable is accessed without holding 'lock'.
>
> Additionally, a patch is included that suppresses KCSAN complaints about SCSI
> host state changes.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
