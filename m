Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC74430C179;
	Tue,  6 Oct 2026 02:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791254691; cv=none; b=PuZOqRtzeoebUFeNk0QyVvaF9bdtk+231gQItmod9KPpJ7UlMKyN/UvMZsnS0hv8i6Q1Fo7oPygBezDVArfigGgRIMF8sxK4wh4USsKsl7N/8XqTJI/rlJq2lzP/Z6J+6kXCqxQOmiN+APG2AhyZFmfj9mNSrQA2EOl2GaQh+XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791254691; c=relaxed/simple;
	bh=w28mzMK3TJ+8TiiTFZce0C6G3Rqi2NvyGijcQ9Mi67k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IpaOCIT7WdGH9LK69QNqJtCP/vzatQ9i5s23CkbKGmWvtEWkQp9YeIBaZqfM3NR/ZuBcOLg/viW0pkcgFJCegU/M7FnUYhBmhSh9TJNvGKoU/nZYIN/HpyD/atJcrY7TRcUjNSXCb/dJnFt0WuDE3pDWeejLB+Z/cRPEdAnUETE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TJ9hobpS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TJ9hobpS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4EB1F000FF;
	Tue,  6 Oct 2026 02:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791254687;
	bh=AXt0D4G5Kz+Mx5MsjDSOtVyEHV8+gWXuqPzvituC/jQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TJ9hobpSyznYvY9pgmQMMY25pK1RWdN1LAp/wAhDZ6TRtxSt5YuG6kW07XjMHv4Bt
	 Qw3/maVeUTszVhuqDRNv6bMNbWd5nuYyJ3k1kXM8rO+DBL4pc+4FTeeT44zsuXcKiT
	 9sFOnsVh5vkxv2i7opqb1UzVZskJBtvRLIgGyAVn3/8iXVpUNBpcR6HA87vxZBpqzI
	 R3mPAt8lmPrhpEXhnDeD6Z1LVdFDxR7AP/G5a0oNKPSs31gRIxWL7K4iYvS6L0sFxI
	 BF1+j0boPM6mTF+XQx9+72GTR9ITuUWddHtXdKzG2LRQoHvYN5RLJfAqqrt8R2TvaQ
	 MTaU8vUTDtOZw==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "Martin K. Petersen" <mkp@kernel.org>,
	Shawn Guo <shengchao.guo@oss.qualcomm.com>
Cc: Manivannan Sadhasivam <mani@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-arm-msm@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ufs: host: qcom: Enable MCQ support for sa8255p
Date: Mon,  5 Oct 2026 22:44:38 -0400
Message-ID: <179103513137.923653.15717912117243215223.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260728051104.675088-1-shengchao.guo@oss.qualcomm.com>
References: <20260728051104.675088-1-shengchao.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 28 Jul 2026 13:11:04 +0800, Shawn Guo wrote:

> The sa8255p vops (fw-managed variant) was missing the MCQ hooks, causing
> the driver to silently fall back to SDB mode even when MCQ resource is
> available. Wire up the same MCQ ops used by the standard qcom vops,
> so that MCQ mode works on sa8255p.

Applied to 7.4/scsi-queue, thanks!

[1/1] ufs: host: qcom: Enable MCQ support for sa8255p
      https://git.kernel.org/mkp/scsi/c/55b6593276c8

-- 
Martin K. Petersen
