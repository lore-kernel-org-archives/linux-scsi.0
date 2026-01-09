Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB03129BD90;
	Fri,  9 Jan 2026 07:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767943326; cv=none; b=CCYm5we230/vGXCO13PHrcBK9H224X0WxJjWiD0c9x6yRwF/teC5pnyXetjcvaWjNMDuzi7+/iSAKIoA/ry0w5bjrGk+utMAEvb1hk/KEF23XIY5S17juO1yHNak6/7x8rFjk2Z4DUHSwAz7H8Kaq4XcSNkNKjZDSfD7mJmWdeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767943326; c=relaxed/simple;
	bh=zH2GJWF0fCizfHxl3esgRoe5b+xHc7sddGOvmJZGav8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VWwoz5xXGDlNlTxVDibwmCOwgIaYI3ZmqcNojCJelXEn4cb0qlCbPWTB1lvhOzu0eh3lWtNoqWIRZ8x1My1fjLyIzpplCGIQ/yJteogmb9S2V4zJ6YmSrYxCT3yUAtoD1jcoLCJ1uVdA/4rHlQHDd7Gr+95Ui9SkeXRPB/tc1Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Vw8sq8rH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Vw8sq8rH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NMzimGoOv+rKn2oM+t8BloBzWTBJztk6OLZPGwl8CFU=; b=Vw8sq8rH7VgE4ydyCFddtbp9py
	S9tdB8bQPhMh+LzBGtsGKyqanJgeiOUwQU/PK9nj7WiC3HNbciS96FO1Cf60VxSKxvXgGfA0bUErB
	8FyMHmTEGT/1N+onNTvrOzLxYQcYu1IIFITTr9kNSC21OxPsPN/CboCOXQ/UbF6uK35LEFOFN4pM4
	5zDiTQww3LAZ65fUFOIwmNd5qeA/VMX1jhw7sB/CjoEYwWxrEJYwgiND0bnXBd6/hiegZoIiVRceQ
	qwEusqIefy9GSDknfDL9wGt1UfT6RMMkOfAyCT3E5QUmmazLncPRI4AezBr9UKM7L/DJY67B9LDzP
	K4QfmtkA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ve6oj-00000001hOH-3dhQ;
	Fri, 09 Jan 2026 07:21:53 +0000
Date: Thu, 8 Jan 2026 23:21:53 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, James.Bottomley@hansenpartnership.com,
	leonro@nvidia.com, kch@nvidia.com,
	LKML <linux-kernel@vger.kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>, riteshh@linux.ibm.com,
	ojaswin@linux.ibm.com
Subject: Re: [next-20260108]kernel BUG at drivers/scsi/scsi_lib.c:1173!
Message-ID: <aWCskbTyA18x-JyT@infradead.org>
References: <9687cf2b-1f32-44e1-b58d-2492dc6e7185@linux.ibm.com>
 <aWCYl3I7GtsGXIG3@infradead.org>
 <aWClEA6KuLP6E1cP@fedora>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWClEA6KuLP6E1cP@fedora>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jan 09, 2026 at 02:49:52PM +0800, Ming Lei wrote:
> Unfortunately I can't duplicate the issue in my environment, can you test
> the following patch?

This fixes xfs/049 for me, which was by bisection test.  I'll kick off
a full xfstests run once VM capacity becomes available later today.

