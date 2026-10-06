Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74FB30ACE3;
	Tue,  6 Oct 2026 02:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791254640; cv=none; b=ADodsIH4Mtpy3gaEgaE4QX1LeBRkMzdUD7tsmt24MrNNmWXI9279TV0EL4dpueVq4R7GaEbe6AYXkBtXIuesZrLVjNtaeiUwKRXxWWpsfWJ+8WkxsuwAQvrYKjwYNxOoJbDdEyMC56BbAexyhZsJo9ANZSlP+PxkaUsTxhvEMVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791254640; c=relaxed/simple;
	bh=b36blXo+xW06v25tBInroolKbDSYSdxIUYCRaTPGSTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hh7bvKYJH2RLEOwreEZ1auNbT2YOuUi2J1S42uE8g4j9Q39YH6h7eu/RvhOBnYvXaQLqSah0i7RgDxLClkKVsfNcpM4SjmSLqgzNOolUnyPwW+SJjM7/kDgUwe4Q7Na4161z0eTORKfqui0m4Dgvh29UlwrSYg4ITBJ+6GlIyKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SAF2AiqU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SAF2AiqU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005811F00893;
	Tue,  6 Oct 2026 02:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791254639;
	bh=3Dxub2OIKlJbgbQwnT0clqTj/0Io9aNg27HTao1ESOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SAF2AiqUeS9WRFiufDP4pIYM9g5LxvnLUCxi9scPLYPoGoP9vFBe2ZGNdfMZD/Hk4
	 q9y7uOLhb/vtl9OU0jfb7TrcHmkwGpS11zkDvKp6z5i96rA9Pe8aBxG0E8R5uS9Er8
	 TzUJ5uTieVDMFoAyuQ+uk6ZL3/nDFUPB0+3kJ+z7dTx6f1PyhIBwB4H+liFswYTU+L
	 bSoD/VZFk0M4nZ8eG0erNz6Zn2gOa4LnZUqQHE3PuHXH+/6/XuDt84xC7Wpaqnw89i
	 ffudlGArDdKARbIJk/Avu5dL/R6nNZZOoieuQv9wcz8gvNg0Q2dBJBlZmspjcaDq4b
	 2/YCwLeuSYFiA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: peter.wang@mediatek.com,
	Pengpeng Hou <hppiscas@163.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	chaotian.jing@mediatek.com,
	chu.stanley@gmail.com,
	james.bottomley@hansenpartnership.com,
	linux-scsi@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-arm-kernel@lists.infradead.org,
	stanleyjhu@google.com
Subject: Re: [PATCH v2] scsi: ufs: mediatek: handle mPHY power-on failures
Date: Mon,  5 Oct 2026 22:43:51 -0400
Message-ID: <179125457805.2089616.5429696204542801966.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260920034953.19535-1-hppiscas@163.com>
References: <20260920034953.19535-1-hppiscas@163.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Sun, 20 Sep 2026 11:49:53 +0800, Pengpeng Hou wrote:

> The MediaTek helper enables VA09 before powering on the mPHY, but
> ignores the PHY result. A failure can leave VA09 enabled and publish
> mphy_powered_on as true, so a later power-on attempt is skipped.
> 
> Check phy_power_on(), attempt to unwind VA09 on failure, and leave the
> state flag unchanged. Propagate the helper result from host
> initialization as well as its existing resume caller. Keep the original
> PHY error if the supply rollback also fails, and report that rollback
> separately.
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/1] scsi: ufs: mediatek: handle mPHY power-on failures
      https://git.kernel.org/mkp/scsi/c/78e04810542d

-- 
Martin K. Petersen
