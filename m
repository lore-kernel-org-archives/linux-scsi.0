Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A40634A78E;
	Thu,  3 Sep 2026 03:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788405036; cv=none; b=C5fymBxYanfW9fk8CdiIsXJRnxf5oSgNHo718doLmwY+oIktyZWMjHZy+AunL0rMb9qDR0hrwUw7NQYQhHLu5gnCySA2yW0zSuZzr0daqRdDdkRqJcZLhKT8BQlYp+4ARc8kg+PUktXb3jitbLm3G6YOdY9vk7UL+LS+3LsnkmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788405036; c=relaxed/simple;
	bh=FdXTAaIO7afi6UsDnJ05hbLhOunhiJyJdJ38fxAyWbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LTrfLl5qeeW7RgBzG+v3htOctRFXcKR7ehGEHgi4GxAJCvnRoOOIO+jX7BhUvOBU9IgtHaOdw427d7sxBg0jj4sLN8iNuM+aFd/QBsuTpUDvU4T03QPnP5kcRguli8dLPaZUYDm8kTI+lzQJEiwQAUvoMM2HgahYBkmc/obIf9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EHA3NNJX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EHA3NNJX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9889C1F00A3D;
	Thu,  3 Sep 2026 03:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788405034;
	bh=NmGixf/D09qOF0QJqH/OFXP2x+U7Bo574CERUanQJfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EHA3NNJXj3lDf5BGNC7yBg63fCHPmITE6WPEW2l1MD/IFjLE62e9XSOx+NNDEKBn2
	 bH42kJQ5d977R1OSREsH7mTa4/U/WDiYjtSxEb32EZu4uj3yx/ZTopPVymGG1QW5g2
	 +fieWXr5sjwcPB26goGg4tDObrZhWhufwv78QlU8LtEjlm+MwNELogb0Dg/3sehlIr
	 qA76vG+yA1XXHJSGlIJRfPCKY9KHuo6hFPsBLeXrP3kYxPXfDtoITnekI2BwXuPmee
	 YMaJ8hOkb7ewARbBQnsBYXtsStDm4IgxCJnh4rjsFzT4IWGDwZt9rp866G2HFTSiI9
	 dGmTH0jRkYLig==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
	Runyu Xiao <runyu.xiao@seu.edu.cn>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: Re: [PATCH] scsi: pm8001: use rollback index when freeing MSI-X vectors
Date: Wed,  2 Sep 2026 23:10:13 -0400
Message-ID: <178840472581.670675.1923164666862903776.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260824113618.2239100-1-runyu.xiao@seu.edu.cn>
References: <20260824113618.2239100-1-runyu.xiao@seu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 24 Aug 2026 19:36:18 +0800, Runyu Xiao wrote:

> pm8001_request_msix() unwinds previously registered handlers with
> free_irq() when request_irq() fails. The rollback loop uses the
> failing index i for every iteration instead of the already
> registered vector index j.
> 
> That passes the wrong IRQ/dev_id pair to free_irq() and leaves the
> earlier handlers installed. Use j for both pci_irq_vector() and the
> matching irq_vector entry in the rollback loop.
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/1] scsi: pm8001: use rollback index when freeing MSI-X vectors
      https://git.kernel.org/mkp/scsi/c/3f92a6454516

-- 
Martin K. Petersen
