Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D992217A2FD
	for <linux-scsi@vger.kernel.org>; Fri,  4 Apr 2025 08:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743756562; cv=none; b=hQ3IRn6c3pR4vHLnq9ZBx2mHfQ2wRtconQ2hMRU8KthSpNaA+hh2o6gkB4A6pwUqUp7UosIipZXPX7HNU266CNJpUSWpIOXxsbAqu6wPUvQF6ESeT3ifZ2+ANJWOoMa5tDYZao/hYjJ839sLBvTAtQvLrCwgJebI0h7hi5pSmnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743756562; c=relaxed/simple;
	bh=wCqPjA7/QjE4Hp2Jk2SQESyd27JweTsvZsYCaLybzkU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T69iuwlJi7UeeO8mwIzOh1ic0Uj8Lj/qX7Y+YqD6JDoqlrnM4roiuB7kx0y2ZVI4sVlyDZpGO/PuQcV0v0d3h9WusWYBMQVO3ju7DT7fzgjdHiqLGWCMfHkZ2ZChkT6VGsHbxXX5ehh71UqtTQpOshOT1XvTFyqKixpuzG0XG2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yKsowyGz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yKsowyGz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zZzHx34wzmHZMm8s54bMte0zG4TR7v4sr1bF8gRRNMI=; b=yKsowyGzB1USl25TtNkxoJ6roN
	h0MYUBc+ejyXsX4zmiFMw5OqFmDINUQJk2OyFvdLg/u4wJNAiitsJOEmpx2kUPfHsinWjHIZ0A8ME
	tuSJ8GzcCMtMFB2q9KY9UOnfqsoktYlOip/LLW0rI5LZzV4gAZu1xDTPexVgA+t21pJdD0qpYewPw
	6KaqhZp/RDg+F/5UAx+CWa4MJdBBhTWcfTUYO/aoSJrb53rSl8UQlWxQc5W5Fhku4eMkjuCyXJS4z
	aJjxY/3822f9WXdCodcSJGVY0m2uPQwjfFhHqscIELYFHgw1MgVfOFD0g8PeibnTQ9fneGeq4Mnuo
	48HJGPbg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.1 #2 (Red Hat Linux))
	id 1u0cjj-0000000BBzH-2JAF;
	Fri, 04 Apr 2025 08:49:15 +0000
Date: Fri, 4 Apr 2025 01:49:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Selvakumar Kalimuthu (MS/ECC-CF3-XC)" <selvakumar.kalimuthu@in.bosch.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manjunatha Madana <quic_c_mamanj@quicinc.com>,
	"Antony A (MS/ECC-CF-EP2-XC)" <Antony.Ambrose@in.bosch.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v1 1/1] ufs: core: Export interface for sending raw UPIU
 commands
Message-ID: <Z--dCxy3gw1a0Sgj@infradead.org>
References: <20250327114604.118030-1-selvakumar.kalimuthu@in.bosch.com>
 <20250327114604.118030-2-selvakumar.kalimuthu@in.bosch.com>
 <9c791cf0-1853-415f-a037-0578d6573e45@acm.org>
 <VE1PR10MB39363AD29DCDDD5CAFD3B6FAB4A12@VE1PR10MB3936.EURPRD10.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VE1PR10MB39363AD29DCDDD5CAFD3B6FAB4A12@VE1PR10MB3936.EURPRD10.PROD.OUTLOOK.COM>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Mar 27, 2025 at 12:05:26PM +0000, Selvakumar Kalimuthu (MS/ECC-CF3-XC) wrote:
> Hi Bart,
> 
> Thanks for your feedback. 
> 
> The caller for this exported function resides in an OEM/vendor-specific
> module, which is not part of the standard Linux kernel.

Which means it is 100% a OEM/vendor-specific problem as we never ever
support exports for out of tree crap in the kernel.  You should have
learned that as part of your very basic Linux kernel training.    If not
please have a chat with your management to ensure this is included
because these kinds of patches are a huge waste of scare maintainer
time.

