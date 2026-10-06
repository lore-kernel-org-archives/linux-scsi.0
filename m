Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26BC2E738B;
	Tue,  6 Oct 2026 02:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791254684; cv=none; b=b6EMaSOMvxZomhrxX3PNjvBuHrsRQGauAbT0IonyCIREPZonZmkk9noI9kG+lcOKQ+NQixLcaLicdJyLxYhFuU1fZ8G4GXxNwcwUD8jjipYxs5bAAFHLBEq455Oo10fIDC524CfHYUBxL/v0fOnRuq6tOarwhgPy1kbJxXFwlyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791254684; c=relaxed/simple;
	bh=bEXmDZMK/oS14WYfbRyqYg2z+D69YwITy3ckG7ic9gQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BbBE19gJQEHryjQ58Ig24o8XfLrOklF51ALLzHHkMnWc2m1511mubXKowFfY+FbhrosZQx96HxPyoznfpGyLGQHfY4tp1xpIXjb+uaitM8RHQ8gPBGGIn0Z7dtODQqzvr1gi8fN0UDJw8z+2XmncOiKHS2+PwzcS3HVm9tl17xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FJXuEUcf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FJXuEUcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593EA1F000FF;
	Tue,  6 Oct 2026 02:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791254683;
	bh=RKjbqufc5djRheEJf1fwVOMblBRNUPLqDwO4cRJjC/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FJXuEUcfEcrDbxggK8JpIw1KLpS+/2c0+moS4fZXsUfk1T9EPj1OJPfnmwjAKxpl8
	 jfvM0CXpsgP9NzMy0e31r6xJYU8YS+RCIZ8/RW1meX01chxshrOHRvVAa2idAq3EfR
	 CZwdPXW9FIF3g8eZF/pw9lpQOm77vHVFzdSpB0YsQNRMexcSpHz3fyC3MlOi1GciZq
	 GZSPhJf9Hpd/Vt/2yzRsxN+R743biJgbh1gubnQxsHeQv/W/er74ZE2SvCTguakdQe
	 PC0Py1oZsaJpsVFn4A/o3nODfHhId4AWRH/nIeXHxduJdG2SEwc+Z2EmlGiVyz0XYi
	 sIlyXNq/tomww==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: oliver@neukum.org,
	aliakc@web.de,
	lenehan@twibble.org,
	Fan Wu <fanwu01@zju.edu.cn>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] scsi: dc395x: sync the waiting_timer before freeing the host
Date: Mon,  5 Oct 2026 22:44:35 -0400
Message-ID: <179103513126.923653.2100454327544429280.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260911020544.42966-1-fanwu01@zju.edu.cn>
References: <20260911020544.42966-1-fanwu01@zju.edu.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 11 Sep 2026 02:05:44 +0000, Fan Wu wrote:

> The waiting_timer callback re-arms itself and takes the host lock.
> adapter_uninit() currently stops it with timer_delete(), which does not
> wait for a callback already running on another CPU. The final
> scsi_host_put() that frees the host (and the host lock the callback
> dereferences) runs right after adapter_uninit(), so a concurrent or just
> re-armed callback can fire after the free, leaving a potential
> use-after-free window.
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/1] scsi: dc395x: sync the waiting_timer before freeing the host
      https://git.kernel.org/mkp/scsi/c/0b1a79f2791a

-- 
Martin K. Petersen
