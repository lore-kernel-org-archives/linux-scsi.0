Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638632A1BF
	for <linux-scsi@vger.kernel.org>; Mon, 24 Nov 2025 14:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763993184; cv=none; b=LnqDoxsU/XDK7IF1WshVgkQtRlkK9nwVTPZ4X2V+VIAF9juDkbkzo1DTgew/iREuGucTRMgZQzneoSzLGtAQAGUdAjiEUlvW87oKsVjhLmZVWVn93XgUkkVKpkfDfHYHQtoG76vdeKY0hp0e3TL4RNMp7zSZtUjjshfBBh66Zfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763993184; c=relaxed/simple;
	bh=BOa4kWpiZx19GJH2tdDfI/0yMWCSj2hujRnRycK24Gc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pWPQbvXxilTQaMtCUJZOckjl8wT1vdoslkAlv/S+N3U7QBg41Pmpdn5Crw24ITJiryiIVcdns29RvyYzh5viixo2XLEe5t8pqzf58GtJcVF3kNtDJi9azi/HcaSFFOoZMfyxOdgOf7CuGK5vo5tNgBKHcydidYIl+bv5R3I1+Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rnlAIN+6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rnlAIN+6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZEVBHy0fEL+xY5vrQvsZzAJ42eit5HH9XPE2JQfY6+I=; b=rnlAIN+6TCGuJwZ+U+Z9bdLSio
	k25Yo/nP163FLWN71Ty2bz2SXgLG0glLtDgNDoad/Si9BTBjxrOv5qnqiidmc6XwbUrguWQLwcZ5r
	6lDr7iOpXLlx+IFYyJ4labi54l5WMHVnRpWz3k3lrCGJivYd5P5Fs3/Q/BYTX+tBbeHNnOnNpqSzK
	2r7YGm482/PzSo9wXGWPeaepCiVXh2XoexdaiIhVIU3dOUUAlIOOs7Mrz+AGfrRg/Z1uO0chvT/hC
	fsyZN5vpfPYeSywuuPk88tOjaZVGrS1kNNWgD5jDO09W1vmdd/Ti2jc2tLNzT2HGzhJCTcA1I61eE
	cjSc56AQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vNXCu-0000000BoOM-2q3k;
	Mon, 24 Nov 2025 14:06:20 +0000
Date: Mon, 24 Nov 2025 06:06:20 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: "Ewan D. Milne" <emilne@redhat.com>,
	Anthony Cheung <anthony.cheung@hpe.com>,
	Takahiro Yasui <takahiro.yasui@hitachivantara.com>,
	Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	SCSI-ML <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: scsi_devinfo: blacklist HPE/DISK-SUBSYSTEM
Message-ID: <aSRmXAQPSMHQXLCV@infradead.org>
References: <20251004145459.58259-1-xose.vazquez@gmail.com>
 <924c8c63-904f-4da4-afdb-5ac5de403dca@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <924c8c63-904f-4da4-afdb-5ac5de403dca@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Nov 22, 2025 at 11:16:47PM +0100, Xose Vazquez Perez wrote:
> On 10/4/25 4:54 PM, Xose Vazquez Perez wrote:
> 
> Same here, any problem/drawback?

The could be asked the other way around.  What serious enough problem
are you trying to fix that warrants bloating the devinfo lists?

