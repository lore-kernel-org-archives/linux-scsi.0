Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E76B3B52F5
	for <linux-scsi@vger.kernel.org>; Thu, 26 Feb 2026 15:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772118575; cv=none; b=MdNCKCx6BYtFhTpcshNnFMxC6vJyEoXxqGUatCUQvJuhNFcyRBgug05RH/b+XUTUyVs8/SnxDAoBtqM0/l9Anm5H0HQnXQ7AlOFCB2ox6JkvmosplHLrQvl3f+RX+VywEVfKzZ1XPfOaESlrRMAkD441MZ+bm4NnfUrFU62REzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772118575; c=relaxed/simple;
	bh=yWGbhzxUV7TgieGa+6j31Gytmp3g1m5Mo28yAmv2JjU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZQ6VAz46yf0Hi/bEaNEfd4X2cW4Jpix+zGWJFlpKIohFGBDXMcAXOzpUYKyeuQsTFpKVtgjqQgRKdMtvzZ0IAoXk29hl2qVWsr+SaVrSDAsUZS1sB4OdtCIB3z6bsOTQq8tlfRqrT0BGUaS4TWus+QllsMSY19h8zGv01hSr21s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kER6+M97; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kER6+M97"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622F0C116C6;
	Thu, 26 Feb 2026 15:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772118574;
	bh=yWGbhzxUV7TgieGa+6j31Gytmp3g1m5Mo28yAmv2JjU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kER6+M972ifhcTg/lHW10mDgV/Cxt4JZRKTGZg0FupaemYizRSEKU84DN5IGd83BC
	 ku0QbRr3zzkBLBF/vAiK8oaVaqBs4iOpLYzaWkiPvX6AREcAcTvfTWKDn1dXg0erRM
	 F9u+0UbihnpHC0EPUEH7ZBIR6qtRD8gKCDWyn9BcFr/YNtGoZrkHLKIebmigqnpI9a
	 pjI+oOIdoAMAW5nkQOiGtE4aETM9ZB4ZhPjycHN2DB0JluRlcJLcWA8dmGBY3QKoyZ
	 WXCGT2qAPhAH710ZRhM3xK9Cj95midWpqqpDP35R54O09S4E6F3jtucvk4EyB5XiIJ
	 wvhLCsgl8sjdw==
Date: Thu, 26 Feb 2026 08:09:32 -0700
From: Keith Busch <kbusch@kernel.org>
To: Maurizio Lombardi <mlombard@arkamax.eu>
Cc: Maurizio Lombardi <mlombard@redhat.com>, hch@lst.de, hare@suse.de,
	chaitanyak@nvidia.com, bvanassche@acm.org,
	linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
	James.Bottomley@hansenpartnership.com, jmeneghi@redhat.com,
	emilne@redhat.com, bgurney@redhat.com
Subject: Re: [PATCH V3 0/3] Ensure ordered namespace registration during
 async scan
Message-ID: <aaBiLNe0O6R9-Lmv@kbusch-mbp>
References: <20260225161203.76168-1-mlombard@redhat.com>
 <aZ9sjbZ3CEW_1rW1@kbusch-mbp>
 <DGOQMFJJ6K5P.3KLF45WQT2SAS@arkamax.eu>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DGOQMFJJ6K5P.3KLF45WQT2SAS@arkamax.eu>

On Thu, Feb 26, 2026 at 09:07:10AM +0100, Maurizio Lombardi wrote:
> With your proposal, if a user has sparse NSIDs (1, 10, 333)
> then he will get /dev/nvme0n1, /dev/nvme0n10, /dev/nvme0n333.
> On one hand, yes, they are "more stable" and more meaningful too,
> on the other hand this breaks the assumption of contiguous naming.
> This might not be a problem for the mainline kernel, but I suspect we
> will have people complaining again that the /dev/nvmeXnY enumeration changed

The bonus of using the nsid is that it will always enumerate with the
same name even after you alter the other attached namespaces.
