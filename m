Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D258E3AFAE7;
	Wed, 16 Sep 2026 01:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789523568; cv=none; b=nWUleN8p+y4fc89Zg1LIm3HWgKbyUZl89qDeotypIMzX57NTnJt/YBqvIHIlxzQg7bEJvViAh71mvtw2B/Bps37WfRh+hA8yHCNwUvs8nRaZUf+CiLPekc0UPX8pPWO+ytRx4BnyPRlFUpTrA8ysBpliwgrvQIpN3+JKlXjnew0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789523568; c=relaxed/simple;
	bh=fw5N7UTTOqA2ZxGkE2lphOfSgzsaoDxiIa+r4VWJT2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGsByvUOspoM1cidRJDcF4Z05zIOOrw2VOJxXbx2MY80nQRwYDDHYJ4aYNdEYfdJ3KZa120LIyz38357DkA0NK8+YxhGIRDHRKX+BDzPOlfgMz2HrFajIqHGU56cCpUXBce+ZZK6ymOUx5ylNtPRYoJ/4xVf/Ivuk+WL6SJ+PUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oOnCJVYI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oOnCJVYI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8FBC1F00899;
	Wed, 16 Sep 2026 01:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789523553;
	bh=5q5KE8fUs+8ODPhfMajWOCRm4Na5oZFgYV9W9yAhSs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oOnCJVYITmVBvRALLoaSLsGGfEfrslH4IRByKYg7ekzx56HZmO8CMFwSp/55ZGVzn
	 iy4AJy6G48kQiaaDUwP0A4okz+dlqSvCihCKwubHZ3xjcJWUpgwKZmu9zT6BRK0igb
	 XCvrZ/AwstTt634Ltrs0TPFLgooFV3Xf+k+oJfJfSKjCHYoF3AGjEVK76U/uNymu4x
	 BIA9hrN59g4pwku+2LdTd02ncTI/oiDsanYQfBldlIwMuxtChE7/7IWYRs0/VBXyWi
	 3ppOvrtJOX5OAH9SYT8YmzXvoPkTaO0ZlzMghGTea9sgirFEa9RdJud21IuoM6OtVa
	 T96e7GN11J27w==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	bvanassche@acm.org,
	avri.altman@sandisk.com,
	alim.akhtar@samsung.com,
	wsd_upstream@mediatek.com,
	linux-mediatek@lists.infradead.org,
	peter.wang@mediatek.com,
	chun-hung.wu@mediatek.com,
	alice.chao@mediatek.com,
	cc.chou@mediatek.com,
	chaotian.jing@mediatek.com,
	tun-yu.yu@mediatek.com,
	naomi.chu@mediatek.com,
	ed.tsai@mediatek.com
Subject: Re: [PATCH 6.18.y] scsi: ufs: core: Re-arm the device command completion before submitting
Date: Tue, 15 Sep 2026 21:52:13 -0400
Message-ID: <daily-reply-20260915-0008-re-ufs-dev-cmd-completion@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260915052638.459390-1-alice.chao@mediatek.com>
References: <20260915052638.459390-1-alice.chao@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Re-arm the completion in ufshcd_issue_dev_cmd(), immediately before
> submitting. All submitters - ufshcd_exec_dev_cmd(),
> ufshcd_issue_devman_upiu_cmd() and ufshcd_advanced_rpmb_op() - reach it
> holding hba->dev_cmd.lock, so no extra serialization is needed.

The analysis reads correct to me and the patch is clean against 6.18, but
this is a stable only change in the UFS core completion path with no
mainline counterpart, since 08b12cda6c44 ("scsi: ufs: core: Switch to
scsi_get_internal_cmd()") deleted this code outright. I would like a
subsystem ack before queueing it.

-- 
Thanks,
Sasha
