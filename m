Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793239404;
	b=a+v7drj6AE2R1CvO87mv6VPA1CXWOein4fxI/qLkEdUn/2iHGsf/SPYkNISXWSi1joHZ
	 FUjgECf2oAs6Cp2EJBi3zi6Wmri+0KuJMcDkz+UybRXHmSK99eV1JXw+6sk5PG/O1TkbE
	 el6dJKvCe9ffuY+EAAFopuMbuI8aIyC/A+R+0FmGrRHrNz+Kbj/lF/qjQzeFy0KKCna29
	 Q9bwAmZe7lWs9OyQk3r/fIluULW31fBUTp/Wykz3snxKhnoXYF+LfzAuUsY1HddnSEdXg
	 UD2PDAWPUObtDVChl8FlQ3gZEBmeKoMxtYMiu71sSj/XUlt11zBvC/fmw/99WgX35gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793239404;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=46x0SvxfzUS2S8Ju4mnF2LvXDTqqZ1M4KJ6+vlvWl1k=;
	b=w2KUPWI4Dr8q6NLJfuGvEo46onWv4cRhURonBLneWHQ5hw6ZHMHk1vLxvYBdzus8VKp4
	 nqYk0TOFSSZPMBiuE+2sSSspvuj+mMuLodZcJ+lTgQQHZwnfm0vbjl6nET0qjVpKxHNC2
	 NTljUKtnSFWUStcL+7cJbw9/EIJe8S56rdCxF36crFYH4/TmWhKE+IkCcKv3CBiKQznxx
	 j6ruCwNr1NIE03/H/xYVpVZVGM1t+TUk93GVFogI5C0QgSO9tLQWe0mIBwK/1pgjZ67S/
	 cbjDbWdTA5pTmrjBJlWDCFyxdh8QFYy9jVyMYMC82MPES4H8FW7x/VyVJx3P1WAUOVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NYBbJF4Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9648460A380E;
	Thu, 29 Oct 2026 02:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NYBbJF4Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4651F031EA;
	Thu, 29 Oct 2026 02:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793239404;
	bh=46x0SvxfzUS2S8Ju4mnF2LvXDTqqZ1M4KJ6+vlvWl1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NYBbJF4Qcsj9XygzwYK7WwnyUr4dFF0Q0c03aqvOO2bI4xMd0P7XVp7aB7bgyBOvs
	 xCaUEbDx395yfzquVj6ZSO4x89xsmibg5YGsDSP2Up8vZOG8QJy0hKnnRmVxZwdTgj
	 vyuiommCBX9vBA1p32oLfXLfwg92zqLPhroEL+/q6B09dWL8LXd5QVCrW9unpwfFlS
	 1iICF5+g2nmDR8PbSkdbHmB9TE1I8tz6Ln6EEOv8A8Zs9CK90gCadBYnxX6k3hi6T3
	 6LYNQyQ68EUZjfZdJ99ZS7KyA4ts8dledd+ekzL/rGdEq0+1WjSKrOzlsA9rfva64I
	 5nqIP6Z/MOdKg==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: linux-scsi@vger.kernel.org,
	Stanley Jhu <stanleyjhu@google.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Bean Huo <beanhuo@micron.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Can Guo <can.guo@oss.qualcomm.com>,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v5 0/6] scsi: ufs: core: Factor hba->outstanding_reqs helper and fix double completions
Date: Wed, 28 Oct 2026 22:02:58 -0400
Message-ID: <179323465398.491807.1363782982253026557.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261022034443.3034432-1-stanleyjhu@google.com>
References: <20261022034443.3034432-1-stanleyjhu@google.com>
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

On Thu, 22 Oct 2026 11:44:37 +0800, Stanley Jhu wrote:

> In Single Doorbell (SDB) mode, multiple completion and error handling
> paths can race on the same transfer request when bits in
> hba->outstanding_reqs are not claimed atomically with completing the
> request. A stale bit in hba->outstanding_reqs lets a later poll or
> reset complete the request again and unmap its DMA buffers twice.
> 
> Patch 1 removes a WARN_ONCE() in ufshcd_poll() whose condition is always
> false.
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/6] scsi: ufs: core: Remove an always-false WARN_ONCE()
      https://git.kernel.org/mkp/scsi/c/cd37a69c367b
[2/6] scsi: ufs: core: Add a helper for clearing hba->outstanding_reqs
      https://git.kernel.org/mkp/scsi/c/22d14117ec18
[3/6] scsi: ufs: core: Fix double completion in ufshcd_clear_lu_cmds()
      https://git.kernel.org/mkp/scsi/c/6b9c1f49971e
[4/6] scsi: ufs: core: Fix double release in ufshcd_eh_timed_out()
      https://git.kernel.org/mkp/scsi/c/3a7e551ae4bc
[5/6] scsi: ufs: core: Remove completed-without-interrupt path in ufshcd_abort()
      https://git.kernel.org/mkp/scsi/c/7cfdfdd65579
[6/6] scsi: ufs: core: Do not release a reserved request in ufshcd_abort()
      https://git.kernel.org/mkp/scsi/c/eb2c4847a1cb

-- 
Martin K. Petersen
