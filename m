Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC1936683B;
	Thu, 17 Sep 2026 02:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789612171; cv=none; b=ZT5tSzuIUhrpSp6DlgjGiePeTpsR/pxJEEb0tiRG1GKeQ3baNI3eqNCJ6++95n9A+MCy23Z0JREpPRrEVbQZz46grKnO6f5+wT/Oa2c2PoBQnHlLNUpGUu/ztlgotetVA+F9AUCI4Y5v0sld5jFd3Qs5k2B/21uga8s7FhPTbQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789612171; c=relaxed/simple;
	bh=ImlV07N2BfkHE6XEF/CC5u9sSY9MJIc11OVk9KiLLkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aNgZPpTcOnFXx2NuLyBoP2kROUy44rgbMfi+IQnBSWOhA5NYluFNAJg30AqcgTtjOWimSw6ckFE0PUQi+w1cQqWLoOQry419CSCIOX1mggujdgHkjmMq+TxfKsD2no652I5Rc7zYNkM53ozLapu2RPD9V/6sAPi2jeYVTASxWRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e4bUEAM1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e4bUEAM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318B61F0089C;
	Thu, 17 Sep 2026 02:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789612155;
	bh=kSny7nWYS8Kvy/lBBc8Vjc625RHCPM7rC/aub8fIhWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e4bUEAM1dLvHpxTIhqU4xPhlC9wc4NgIBf1PLRzPJ9T2GXs5yVaAycoUiJ+c4GYHc
	 WU1GPJZTUmLTqrp9lJuRLkE5j/dJ+hf2yBLmUb9vZF/cU8vskFXz1QLR4/3pe4+bcV
	 wT5YUOTCNdfI38Kneon/mFWRV6mZAEFeGUM+zRHxf+l9njFiuiCYJnFu7AnQBYjKpP
	 sUyoWcfLavuB852utqAJzdndfoI9D2ZcePpePZbqgnoUP5/K8yfE/PUrVewbFJzrtg
	 YbaRhakGkV0Xu2RljlJcO7x5tzezgvaBTiHqYYfgiDmmIKf6cu/BKbL/SeWqkE33Uj
	 LYUB8PHJC0ORw==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: mani@kernel.org,
	James.Bottomley@HansenPartnership.com,
	Konrad Dybcio <konradybcio@kernel.org>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH V2] scsi: ufs: ufs-qcom: Enable only lane clocks in lane clock APIs
Date: Wed, 16 Sep 2026 22:29:03 -0400
Message-ID: <178952247944.2757716.10567000988538089004.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909053944.2827968-1-nitin.rawat@oss.qualcomm.com>
References: <20260909053944.2827968-1-nitin.rawat@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 09 Sep 2026 11:09:44 +0530, Nitin Rawat wrote:

> ufs_qcom_enable_lane_clks() and ufs_qcom_disable_lane_clks() currently
> use clk_bulk_prepare_enable()/clk_bulk_disable_unprepare() on the
> entire host->clks array obtained from devm_clk_bulk_get_all(). This
> array contains all device clocks, not just lane symbol clocks.
> 
> Since the UFS core framework already manages the non-lane clocks via
> the setup_clocks callback, the bulk enable/disable in the lane clock
> APIs resulted in duplicate reference count increments on those shared
> clocks. The extra enable counts were never balanced by a corresponding
> disable from the framework's clock gating path, preventing the clock
> reference counts from reaching zero and ultimately blocking CXO
> shutdown during low-power states.
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/1] scsi: ufs: ufs-qcom: Enable only lane clocks in lane clock APIs
      https://git.kernel.org/mkp/scsi/c/f07317a8d57f

-- 
Martin K. Petersen
