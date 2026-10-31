Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793410821;
	b=DSkuiUST1cEcWkI7JGL2ynAO497cLQONlmpu4XmJRgL/cbPbAy3DWMa4Z4gzev9Am34F
	 SyuhXni/6+xqUh+w61Cd2E/JZJ03yULab5m11kubBB6rCjjgDVL4xMYWnBld2gZx/2YKh
	 mUCFy8EJcFD0gB6uMgV+0ebkdwYh6Vfc+pZA9NWeme2j6fdtaBdosRJ/DwzoZcY8OAB3x
	 Yxnk0Dxb8tIZ+G3g5CA2CZoRewuqoBNNQO1bvR4TImEXYGJEO6LG/2FDzG6AtCdQka2WP
	 enuhK4iyHSFh7LyurktQLu4GVT61Fp6/yCmS7SkhPglPDW34iQX7G+d9djkFMciMY2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793410821;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=cYECWHK3rCJvgT6Ofm6tWbKtlacbnOfxxCe60el77tE=;
	b=x/ULNzAZ1h/KZGWCzsplNZHAWLlQZZF8ahvN7Ux3UEnGYbV8jbaK/F6I8RDIgfGnlhLr
	 xiilMQfpuazXzOtqujWHcHD+z4gHCo8vSgwD6SafcLuqtE9fY9FYQtu6Dlw0ZEJpZXpbc
	 cNuZ7YWhHZryAXcc54Fr2kuzKMQJFLBw+s4KjY/eFfIO/Ap6WZ6DkNnvBQWYtsYYgpiF2
	 k45C02mmJnG3BZ6yuAUZDwFxYDxGYoWTDgw785KE9E3//Yg50ZX41rLiQ00NkKACexUFV
	 SjEbsVmo9H2BeZhM4ZEImZTGNtQojTjm9gK6J9qWEsNFGUNzODeY6TlFHwolvSreKiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BE2Bktj0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD82606A31E;
	Sat, 31 Oct 2026 01:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BE2Bktj0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352511F00A02;
	Sat, 31 Oct 2026 01:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793410821;
	bh=cYECWHK3rCJvgT6Ofm6tWbKtlacbnOfxxCe60el77tE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BE2Bktj0cqd5hRWFHydln72toMiCH87QG21VifgNn574fQ+tIfJOJ71mBERulGj34
	 2TNLaf5qMySi6YQTmecWw8M6ZPuLSLKJ9ZWo8GncPkYm9ZiruQ6AniMoUdPLfsjrK6
	 cWWx46e42jL9WV0fkNspHDtwzFOJjMoZSn4AiFGiy0FfRLkxBXF7vsqhajEJ3NkzOe
	 p+SXplwa4Fmivws4hVsvVpuppn+K+E7+Azkc/LgpdAFbXyv8Y60u9jDJ5WPufHJg88
	 jHlu5+obmj/9O8FlD+jFkKaFaIqrnz3TARihHiln+0U1rt+S5J9wLKgjsSWPAQm/lU
	 +N2DGBNyVSMVA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Hannes Reinecke <hare@suse.com>,
	Andrew Luebke <andrew.luebke@gmail.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hannes Reinecke <hare@kernel.org>
Subject: Re: [PATCH v3] scsi: aic79xx: Fix NULL pointer dereference in device reset
Date: Fri, 30 Oct 2026 21:40:06 -0400
Message-ID: <179340755629.952351.3503175521575838483.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261026172032.749756-1-andrew.luebke@gmail.com>
References: <20261026172032.749756-1-andrew.luebke@gmail.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 26 Oct 2026 10:20:32 -0700, Andrew Luebke wrote:

> Since commit c67e63800446 ("scsi: aic79xx: Do not reference SCSI command
> when resetting device") the device reset SCB has no SCSI command, but
> ahd_linux_dev_reset() still sets its residual, and ahd_abort_scbs(),
> which completes it, sets its status. Seen on an AIC-7902 when a failing
> disk triggered a device reset, which killed the SCSI error handler:
> 
>   BUG: kernel NULL pointer dereference, address: 0000009c
>   EIP: ahd_linux_dev_reset.cold+0xee/0x26e
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/1] scsi: aic79xx: Fix NULL pointer dereference in device reset
      https://git.kernel.org/mkp/scsi/c/f057a8bfeb6f

-- 
Martin K. Petersen
