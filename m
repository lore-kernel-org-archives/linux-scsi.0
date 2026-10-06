Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6EA230C177;
	Tue,  6 Oct 2026 02:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791254692; cv=none; b=U1AYsV20VZRW7iC+kDmkkg46c6yRAXkFdVWLBfC1v57NjDpYY1jDHizzxcOGsDfI55HyW2twNbrREBrucjfzuSRdA6FB7AHXehgGo79yYcKLqk9j/WQveoR3JVVKyZWC/83hyZ8bzqGhZOjMMz5jp5ZQHV2vOzGFr9oBsAMc8fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791254692; c=relaxed/simple;
	bh=5rPDoDxAuhepOCMF96ilzM9EqQGLOxqt2hYo9CMP7J0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KGklDHfxbLiNpfuNMWR9n86aZqqznNx4qCL1Y7uI2HHdokymdcj9f39dxyOd4VHdBMJPtkodoTH07enKoyk9WByrF6Si8fw27krw8BBR2lQpj25D8OACVFPFhiwz7g1UYWhQSQInfuwicAnxCKM59YSyG3cKe4nz0IdNZDC51JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fZiAqMm4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fZiAqMm4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9C81F00898;
	Tue,  6 Oct 2026 02:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791254688;
	bh=x2bvWSh2KszDgI5OWMXVd/n1XLTrHunok5k+khSRlF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fZiAqMm4myxTtCoqtoZHuaAhip+PnB0p+QsBmAfdSXPPA1K7afbRNNnRVJ7Zt0nf8
	 llLVqOQFtHzwMBunCkCf8k/EKhIk6pLsflmjhE48Mx1S7CBDZ7AE/uL6H3ldp0MFKJ
	 vuhSHVHyPx3JoWFifBMJRtYD2Pj0+88NrChJL/uWYMZPparmJjTeUF/M1T7JoeBANj
	 SUa1LXUlbwmvUmA0onwFqDpmw/YOV2SJD1Ch6FuJPZaQO7aOmz6xAFoZkN8JrETC6g
	 5SuFVkjBwGpLYiWewdLkQv4DBDISrGNviiLIZdwxc7KxFUzhILKxzOGVnBMvsNB/8O
	 aJkHKPKvyjVnw==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: James.Bottomley@HansenPartnership.com,
	Stanley Jhu <stanleyjhu@google.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bvanassche@acm.org,
	avri.altman@sandisk.com,
	alim.akhtar@samsung.com
Subject: Re: [PATCH 0/2] scsi: ufs: core: Handle devices declining optional Query IDNs
Date: Mon,  5 Oct 2026 22:44:39 -0400
Message-ID: <179103513129.923653.17451486318686411265.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260911024319.1346706-1-stanleyjhu@google.com>
References: <20260911024319.1346706-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 11 Sep 2026 10:43:17 +0800, Stanley Jhu wrote:

> JEDEC JESD220F specifies that a device which does not support an
> optional Query IDN returns QUERY_RESULT_INVALID_IDN (0xFD) in the
> Query Response UPIU.
> 
> The driver maps every non-zero Query response to -EINVAL and logs
> dev_err(). A device declining an optional IDN is spec-compliant, so
> this reports a failure that did not happen and keeps the retry loops
> resending a request the device will never accept. On UFS 4.0 parts
> that omit the Timestamp attribute it repeats on every boot and every
> resume.
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/2] scsi: ufs: core: Fast-abort unsupported Query IDNs
      https://git.kernel.org/mkp/scsi/c/d1fa5cea5dcd
[2/2] scsi: ufs: core: Dynamically disable timestamp on unsupported devices
      https://git.kernel.org/mkp/scsi/c/00eec343c730

-- 
Martin K. Petersen
