Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6B98632B;
	Mon, 24 Aug 2026 01:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787536566; cv=none; b=NtSgevTwaRIldP8xiwshLe3HaeFKPXtLFjfbPaRdSDuXhzrMBiZDHDqvP/r0SM6G94yYNP+aQ7yCKmbGwHaNUe+EVUSO4J32fJkaEy9iIRUuP42gqBy+ZkPmHI6gvusBzK7shkzHJHsDIfScisO+gYjFI/R4wocxk+lVcaNgT/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787536566; c=relaxed/simple;
	bh=7RoQnSXGfebxoTp5pc5pOMbf3GzP9ndwNOpDaRq75XA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=pzW6Qi6SH5ggWJ1UNe+tAF/sjRylYljd1h39oxtpEBspC8VkieabN6URst6lQTvGgNBihkmQySOBP8bCZ2DQmPmSG2eRwBdYUJF+7FsyETHOzR50EunecBWNpDZt/MmJmvPxJvsJfGvARp37Dzd6as0TRq32yPYehToVCI2dhd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PuyFhW/x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PuyFhW/x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF88B1F000E9;
	Mon, 24 Aug 2026 01:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787536565;
	bh=aMzs4D/q7/0KMjIwGisoPPQa1/K94ZiehzWN7g9Hd7k=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=PuyFhW/xxAArKI6B5+ChS5dcn0BdV2YNpBu9is4ECRiMp3L8FpjOtsfSWAiQsrK6i
	 QHGwTM3yDX76YGwN2grkvXXaOmtiE51x6AtAXzyQH8yyHX6qkO4/5a59u6HlMgd+B4
	 q8KaDqKDEDBbGxCpzUzGamDmQTXJ8TqhzOKlDUjAbWb6S+k84qEIuKFCYkc5b8ctXF
	 3Rdh4lpIqMCwuTbWbMwlwemTP6Nh9iEiQcfGdMy+WJaLgycoZwWjSbxcMaSTgr/uUS
	 y/ObjOs2aJiOFluHDs24Vi+OCA74fIo0r/R5Fm1QZ8+nSDY4mAcPIrEtjXg3Xpik46
	 9M5EW0Cj9i2pA==
To: Linmao Li <lilinmao@kylinos.cn>
Cc: doubled@leap-io-kernel.com,  James.Bottomley@HansenPartnership.com,
  martin.petersen@oracle.com,  linux-scsi@vger.kernel.org,
  hare@kernel.org,  dlemoal@kernel.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] scsi: leapraid: fix firmware log mmap lifetime
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <20260814033845.2971706-1-lilinmao@kylinos.cn> (Linmao Li's
	message of "Fri, 14 Aug 2026 11:38:43 +0800")
Message-ID: <yq1tsoknuxh.fsf@mail.kernel.org>
References: <20260814033845.2971706-1-lilinmao@kylinos.cn>
Date: Sun, 23 Aug 2026 21:56:03 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Linmao,

> The firmware log mmap path has two related lifetime issues. VMA clones
> drop Scsi_Host references that they never acquired, and device removal
> can free the coherent log buffer while mmap is still setting up a VMA.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
