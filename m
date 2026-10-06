Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228072701B6;
	Tue,  6 Oct 2026 02:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791254639; cv=none; b=txWWG6Tx5QAHi42Nje1SHDXa6NwjhS0v0AlXg/MiHbXc1T5k8xvGmMMY3PObnE4sYyb5Fhgymm6wfDA+bVJ0UysoflAF8i2N+afES6PjjdLTYjcOojtfMZtB70vR4otRHo1+az3gAxMYlc4V3s2gA7ANxjbPmvfcyJhnHt+kxNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791254639; c=relaxed/simple;
	bh=BhBxjCTQUhz1J1JefVBh4zQP7012IvEMUOOrVXj+cyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UR7qNZv27aFdK3lDYpZjcPYTMNKczdS0bLI7FJZcc80gLcpEYf2+nWmu3hY8aY+loE5XBalHPgwsDKatLg+QSyTgOdyarO/6lIr02IspSN3I14hTUbBJkIlzy2HpIg+mTgxnXD4thS0krkYSHwYOa6vRclM2vElZ1Xf14cxswhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vr/W74TW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vr/W74TW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC721F000FF;
	Tue,  6 Oct 2026 02:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791254637;
	bh=KdCI/8Pa596kw6LrDUYp0zQczc7jyC3zzOo9ndxUAGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vr/W74TWrFENp3aLxo7AuZjjErXiH2+0W0V0Lu0J9zqVFBQoNADaYalmSvKVyZQb+
	 jzi3kuBJEnY2uITzjCJTZJ6u51Yh8ez2xJ+iVcqxhyat8K0fdV+NBZjxcSaxdYure1
	 Stqz4p4gw9lw+CnwEWuOFs+KixNYdr2opqK83IES5pvIlgdfp5G7ewya1Qmg3r6/5V
	 RYF94HnZeqq792R2fDx5ycYwJSXkgXAfZ2dJURhVXhPPhvrU+0lcM9lQ/5u2zY8/3w
	 XEOTU3gy/Rlob8Y1Ux/2M0b/Uk4Q1WOoi8SkFbXe32y2SsUid6/tYloeEP9ogzOIg7
	 hc61zv5vwpFzg==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Ahmed Abdelhaleem Ahmed <ahmedhal@gmail.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yang Hao <yanghao_ht@163.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] scsi: ch: Do not keep references to data transfer element devices
Date: Mon,  5 Oct 2026 22:43:50 -0400
Message-ID: <179125457807.2089616.3760307783518369288.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260922-ch-dt-leak-v1-1-2b2e40bf1624@gmail.com>
References: <20260922-ch-dt-leak-v1-1-2b2e40bf1624@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 22 Sep 2026 15:46:46 +0000, Ahmed Abdelhaleem Ahmed wrote:

> ch_readconfig() looks up the scsi_device of every data transfer element
> whose SCSI id the changer reports in READ ELEMENT STATUS, and stores it
> in ch->dt[]. scsi_device_lookup() takes a reference, and nothing ever
> drops it: ch_destroy() frees the array with kfree(). ch->dt[] is read
> nowhere else - it only supplies the vendor, model and revision printed
> in the same loop.
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/1] scsi: ch: Do not keep references to data transfer element devices
      https://git.kernel.org/mkp/scsi/c/27c0f718d3b3

-- 
Martin K. Petersen
