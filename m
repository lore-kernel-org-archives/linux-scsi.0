Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6DB537755A;
	Tue, 17 Feb 2026 20:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771359220; cv=none; b=K1DeUeAeIxZQSgJLYpCitPiSwmUobWNHRtCCWbAnLwSXAbnqJCiHZV9J+Mc9VTCJG4KvyLbPRVvbn2nLtSN6bOY2A0LrnyB/ncw00V534iBOZSpWb09dvKHqUMo82yRIE9wZKQWg02B0/UgY/108Z5yTMzRXsKtsfuW4C7AhcQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771359220; c=relaxed/simple;
	bh=O3KNzwdv/fZolh9vEe47GHGiaeS4Hpe5Gsp1brWunUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pFmZTxLBBnCN7tpymKAiSEMH+vs2KdBatmu05L9po0HgO5QXCruCYuTpKJ48IwUMeoWp6wVXwMVkonpqIDwp3ouEfjOQMksygHRcGGIWBOxOeNJR9phd2+BvKo8a1dIw1ZGxJ2AE4WcOqYQ1sqH72WENLsrGjKwcVK51eZgQjq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=go5nyuTk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="go5nyuTk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5CAC4CEF7;
	Tue, 17 Feb 2026 20:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771359220;
	bh=O3KNzwdv/fZolh9vEe47GHGiaeS4Hpe5Gsp1brWunUU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=go5nyuTkw3Ac1hUXhYVUndWAXOiKYJtszHh1P9R2ACAHgkhM7pToXmL8alG0lOSsv
	 O5V/rrSjAZQkpT2diAPlhAmNGX3Trl7M9m1wajgozmuuRyLDqvbkdhjp7YCRFHs+4t
	 fLnQNrSexcp8U0sX1jVYnSE5x+xE9IeQuGPXZPO2JnhU07Y17XemWPGux8F+mDr4Gd
	 sYOSmkz/i24+izPybQRX23xyP8w9WMzPSKHaHKB7EoRD1Vh0lARB9Nkv9SOyfK00t8
	 wR6EElkoxYpbv95s91Ww73C7quHjPvuE4wWDOMTyNE4dc+Xart6U/p6qBcuf5QZ5e0
	 h8S6TM2IEpQ2Q==
Date: Tue, 17 Feb 2026 13:13:38 -0700
From: Keith Busch <kbusch@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: John Garry <john.g.garry@oracle.com>, lsf-pc@lists.linux-foundation.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Native SCSI multipath support
Message-ID: <aZTL8srSowTU81Rz@kbusch-mbp>
References: <69349b51-72c2-47f9-948f-f89843af62e4@oracle.com>
 <049a177d-85d6-4c9d-9a9a-f07391046101@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <049a177d-85d6-4c9d-9a9a-f07391046101@acm.org>

On Tue, Feb 17, 2026 at 11:33:12AM -0800, Bart Van Assche wrote:
> More important: what will the performance impact be on SCSI devices that
> do not need multipath support? UFS devices don't need multipath support
> and soon (later this year) will support more than one million IOPS per
> device. Further performance improvements are on the roadmap.

For nvme, we can detect if a device is multipath capable. If not, we
skip the multipath layer altogether so it has no performance impact. I'd
imagine the generic library version would similarly require an opt-in
approach that UFS simply wouldn't subscribe to.
