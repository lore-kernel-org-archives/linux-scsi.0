Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794977378;
	b=f553uQFTFTm+UjZs8hu/UJq9pHWQtFsSr6khJVfiMnhLEtjlDQdwskdY5MjeXHg0r7vz
	 l+131fEKa5RV1CXDMrdPZV9pAxK+ABRPS2fMM1mYaeJ+CcIg5D9B4OOzaU82jtbkum9qy
	 qdQLQux0iLhRqdwiSJHcGx/p8BY56oQ5R/r7b9xqCVT0DoRFebe7XLo6cASybxoSl999Y
	 u5L/cPBCPOYHIT4FPfYftye8/FZUDn+OTZAZtZWQ3Ro/s2OkJEBi0QdySF/kBgvow81EA
	 bVhh/QIwB0PANNDOH3154PsFICQaT47+10jVgmgcNKxFnug16i+sW1weR7Rm0GkusAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794977378;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=fgpWZZwE7NSYEWRtNq7ZlfOjQQLjUSuAxIrdzbkZGnM=;
	b=3mzl70CYKwuIqotfV9S8wCgdYIZX2vnvRMhNyU4kqPsE0dYclFcdN7pqE3WcHBHjpqeI
	 QwFyBLG1GaCeaBlCtz5dB3Uhxy91d/U6q3zcI4KLWEOW7UtzxCnMhyX5FHDS44dxuK+nU
	 8Dr887gUUFT9SvnQw199UpZw9QPCZjxZ3caH6feDewf4B9FvxnB6IfQ9wqPifBrD8s1s6
	 34kNAqQ93xnr41xvU8JlKx0xcwhxfOUsYIvzwTqOEj83eSzVz9oXvxAK7DhvdnzuAiFoN
	 co32JJdfBAql96Qf6+6kY/d6ebK4fiEpXMbffjcl8XEc7Tos/HU964seTv6P5GebMBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="M/Z28yIl";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F57A606A33F;
	Wed, 18 Nov 2026 04:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M/Z28yIl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296341F000CA;
	Wed, 18 Nov 2026 04:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794977378;
	bh=fgpWZZwE7NSYEWRtNq7ZlfOjQQLjUSuAxIrdzbkZGnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M/Z28yIlfN/dW/5PR331Wua2qc0cdeLPcRWT0tXAUOvYBYQ8TpNLvxL+c0cpqRWSH
	 eHcG3AYvBCosqnjT5iimqL5FGdOtGM831xCM1QUfyl7jLvNarT4e9j3biL9E5ySZPS
	 DGvRDjG4tfRaGE/Bsg9m41DxTGwCESe5hGGmZXcgiJPTSQ1cndFofXtpUHJq9a3PtC
	 YDeBPmcW+L4jikcpS7Zs+W0m87xJ3/Q5RU+KRTecgyDPsYD6V9uUdwOuyCRnHMFiEF
	 vKyOIurIZco6ae4ixatC3cSDYBHTv/+P10mBmsfbDWyeROV9wTP0oWz6HylVOwx4KQ
	 0AAid/iSAxT4A==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Stanley Jhu <stanleyjhu@google.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	sangram kumar yerra <sangram.k.y@intel.com>,
	Rajeshkumar Sambandham <Rajeshkumar.Sambandham@amd.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: ufs-pci: Check hba->vops in system PM callbacks
Date: Tue, 17 Nov 2026 23:49:25 -0500
Message-ID: <179497726103.2093762.2048107205167410263.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261111084853.3530107-1-stanleyjhu@google.com>
References: <20261111084853.3530107-1-stanleyjhu@google.com>
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

On Wed, 11 Nov 2026 16:48:53 +0800, Stanley Jhu wrote:

> ufshcd_pci_tbl[] defines the Samsung 0xC00C and AMD 0x1B29 PCI IDs
> with .driver_data set to 0, so ufshcd_pci_probe() leaves hba->vops
> NULL. Both ufshcd_pci_suspend_prepare() and
> ufshcd_pci_resume_complete() dereference hba->vops->name without
> checking hba->vops:
> 
> 1. System suspend on an AMD 0x1B29 or Samsung 0xC00C host enters the
>    PM prepare phase and calls ufshcd_pci_suspend_prepare().
> 2. ufshcd_pci_suspend_prepare() evaluates
>    strcmp(hba->vops->name, "intel-pci"), dereferences NULL, and
>    triggers a kernel oops in the suspending task.
> 
> [...]

Applied to 7.4/scsi-fixes, thanks!

[1/1] scsi: ufs: ufs-pci: Check hba->vops in system PM callbacks
      https://git.kernel.org/mkp/scsi/c/947d8e9a4d1e

-- 
Martin K. Petersen
