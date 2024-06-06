Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E11113B28A
	for <linux-scsi@vger.kernel.org>; Thu,  6 Jun 2024 12:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717677278; cv=none; b=u1hTPzT8rhdwiwjfFKaqCRLjVW0QMkVxg3hZlmxYN6KkZ2TBpjlnNgvEve+YOQJNHArAsWAnwMy0ED+CYPq18LWdKW8nxzJNjal3xhgb87Axzveai/amoFRUledEF+Cx/eyH7qOMFszkkbWjRD3mXcvEZ9/0QwxxgiscVwhQe0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717677278; c=relaxed/simple;
	bh=k1VJ4O7MSHwZH7QIDU/MycK/WWKrDjxDPXUCQA414Fc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SafO/oNpmG/SNqjw0ojPr16fUSukEZKfHh0Mf7aJmUfNpXyiEbR3wOyXjq1HAFIW+oTR/QGG2oZ2ksV5jNDDjmy+ndt5eHdpDTaBWXfT+gHS2h6hpYnLNUKiLLIGly50atCfTktYpjP9s8HIiWzYu2e+rG0Dw/J3+skXS9bb6Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qERcYebo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qERcYebo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=k1VJ4O7MSHwZH7QIDU/MycK/WWKrDjxDPXUCQA414Fc=; b=qERcYebolU3r+okqINyErxbzfV
	jqwvUOjPHIkejUmRI446fJBphnEKfrsTKipLqvWbzi604H74JR+UOeu3CMkk6Z4412DU/2NzmJ409
	xoYRdHub2BUcdsEdmTst2FTtXKZGRFC1pAPruC53XUJvlZEf9IeR4as61qjXqYtG+6ukoyDPhIp91
	9Zb0YG7ge6+dWOeScrbD2Y5p+MccE17P/43U84J96WikDzNf/L9T80HYl4RznoUmP0ERd3rX5bNSG
	q9zd8l3UkrQu0kmFnXet7mCV4hCTXbJbOnbpkiINkDoHb9Zh47ReDJ0Ze2CfS0r8E4sY+ALVDOou8
	qsMss3lA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sFCKB-00000009iFq-2KXz;
	Thu, 06 Jun 2024 12:34:35 +0000
Date: Thu, 6 Jun 2024 05:34:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH] scsi: mpi3mr: Fix SATA NCQ priority support
Message-ID: <ZmGs2wZDO9ZTO0s4@infradead.org>
References: <20240606054749.55708-1-dlemoal@kernel.org>
 <ZmGB6I1OQ5TZOHAn@infradead.org>
 <a61c0dc6-40f3-4e01-9657-eadbf3a50c99@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a61c0dc6-40f3-4e01-9657-eadbf3a50c99@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jun 06, 2024 at 09:14:46PM +0900, Damien Le Moal wrote:
> "also" ? your previous point was not about this function ?

No, about all the attribute boilerplate code.

