Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795664107;
	b=3kXzpuOxlprbmHDVU1MANjV9fq7MZlshZwTiO2l9mx2HBJijytVAchEPC0mGhLXsgaSI
	 eCdXfN+FA8jXnKmpTSTYS7wcdapvUPjEWUD9WYDogUKrDZLc/fLcVpsGMbOh2M0ywo+v/
	 SZY1iMr9Z0ZgO00clNCYnruhwFkYD+bgJ4obYYk5Jx2TiqftY/Us2Pgk0Shw5hJphKFy6
	 XfDDMC+sLTZX07lhe3r3MJvfOHGLlAnVTY+EqGVNpdvjZV80hF9e+EAUL4APO0y84iK0C
	 ZNWHsLgib6PJ86kJQPwmfn/k8TmTxv5Qc1FjHQ7V6dlfHy5yuQxr7v2jKDjNL6BUdqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795664107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=eLTl/g4KujQMDMJRE5SGlmdd6FwGilnbsGquUL596h8=;
	b=hrun/wRpFAEoyjLxgzl4kN2cg7aGKxpkEZgTOxX4bS/06Xiogt1C6YJB3riqYpzARNCn
	 0Kz8mvx2ZjLblQE5TVBy915e6CkLWN+/LZqY+2R0RkR8zkUFfvafvE4goX7hdqKID2MtU
	 IKHxVi7OMHJpackoZYpBnu8nLmnLUH19bfpHOoIvacE/sGlha2thevoASbdjiDvCAY3MB
	 jz1KzvpUBjY1QGHjDbd0Xs2Y2uIWkwGtpldHTlETDb4kusnxmKk2HZZcPdRWObCuslvPZ
	 S63/gh/uYCnU/lBTjuWO5ScjIdsT2JNL4NkfxyySQ2Ks+kiGp0ouGqhm6hHQjZC3fbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wydd6obe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F96F606A681;
	Thu, 26 Nov 2026 03:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wydd6obe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE961F000CA;
	Thu, 26 Nov 2026 03:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795664107;
	bh=eLTl/g4KujQMDMJRE5SGlmdd6FwGilnbsGquUL596h8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wydd6obeDDnnMoBmCABx2tOj/QAl9LEtPWVxC6KCxmRoq2Zfo39bzAZFDFlpXTkBQ
	 lE0gq+czLOXL2f9HZC9aI3ka322E+OX/LZf2qqFl4gzX9sAq/OT6oDfzBx0f/LNTji
	 zK34mvlgh1kqHlbGFKO0lunn2Zd9kmzwKNRxQo8r/swKtUy43e4tJ9tLD8IB/lL5Ej
	 3OssgYLpb+L/Mipg1+E0z8813fKvtzIpjHADZph4bxvBMyT1NB/wQ+c3jsrD9Od+XA
	 3S19iSmE05BHp0KpQaIk/BQo+CfVzNlHJPSF8v/bKCY8to+BEmVsmWlZCwhtsW16To
	 ISKSQSEbgaeuw==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Alim Akhtar <alim.akhtar@samsung.com>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Pedro Sousa <pedrom.sousa@synopsys.com>,
	Arnd Bergmann <arnd@arndb.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Stanley Jhu <stanleyjhu@google.com>,
	Conor Dooley <conor@kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K. Petersen" <mkp@kernel.org>,
	Minda Chen <minda.chen@starfivetech.com>
Cc: linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH v4 0/4] Add StarFive JHB100 soc UFS platform driver
Date: Wed, 25 Nov 2026 22:34:50 -0500
Message-ID: <179566062780.467514.17583582227952888451.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261112075616.118436-1-minda.chen@starfivetech.com>
References: <20261112075616.118436-1-minda.chen@starfivetech.com>
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

On Thu, 12 Nov 2026 15:56:12 +0800, Minda Chen wrote:

> JHB100 is a Starfive new RISC-V SoC for datacenter BMC (BaseBoard
> Managent Controller). Similar with Aspeed 27x0.
> 
> JHB100 contain 1 UFS 3.1 interface and using Synopsys designware
> UFS controller/unipro/M-PHY. The ufs-starfive.c contain JHB100
> UFS platform driver, unipro driver and M-PHY driver.
> 
> [...]

Applied to 7.5/scsi-queue, thanks!

[1/4] scsi: ufs: dt-bindings: starfive: Add UFS Host Controller for JHB100 SoC
      https://git.kernel.org/mkp/scsi/c/11a756096813
[2/4] scsi: ufs: amd-versal2: Make PHY register DME attribute tables per-call
      https://git.kernel.org/mkp/scsi/c/454284cf3f39
[3/4] scsi: ufs: dwc: Rename amd-versal2 read/write PHY API and move to dwc common file
      https://git.kernel.org/mkp/scsi/c/b65d9e54e5bb
[4/4] scsi: ufs: starfive: Add UFS support for StarFive JHB100 SoC
      https://git.kernel.org/mkp/scsi/c/715aa02a2de9

-- 
Martin K. Petersen
