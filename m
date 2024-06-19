Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E883917583;
	Wed, 19 Jun 2024 07:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718781397; cv=none; b=hq4iHU5tiGfKMtpNHnHVBUAYo73JNkwzhmNS3jT2kEX6GrQwZL5uNQDMG6Ejr9PJqHdCYlTeHKOo/CUds+pQJ0vFdmffGKLBWiePD4ZV8Rr0giK8xv2gBV0eum5Abo+kEGuZngYqEkZMv5gmzCRgkust/yGxGxQvf4j0oIc+gcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718781397; c=relaxed/simple;
	bh=aKQ3KlE10PbBuBBETB+H1l2YiFhZgrzhPf6P+vroeDY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ScWZmJXNhDSQNmuZZtxEKo1ROTkbZ9ZUD53yLGGpc+6VCCag+qPOAg4/esyYF7d86ZpU4cGaLi7GltsTTkZcqFUJj7yRdImm5RFNAHPv58l0nyUNbJQSyqpEphFzyvOhuRGZ/aAyvc5mIVTrYZBqmHNuAQ84xCzXhWpRG7Vu6UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Q3m5UzES; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Q3m5UzES"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=aKQ3KlE10PbBuBBETB+H1l2YiFhZgrzhPf6P+vroeDY=; b=Q3m5UzESCm42kczfh0sQ34e+u2
	a8ioGsuEkLt+vHF9yMUHwHGoI4cC+CYQoLxT3pSWqhZuZGj13RybKOwN4gdHLuqd98/b6xXtRCVCR
	oGqMANK/dWp1DBecbqYD8U3dpBRyFHwlFTka9GVOOQKqRx8y7r2SZTev9+m+QnZbooQLqtm/matJQ
	DHcLv/b2qR8ZvWMwYNOXhgr+tBsU1Ddr4q5hzC0NLt09m6cLDVV4w+0Tb2o6ecoQJakxGUXS+Ttfa
	BrzZmS31ppTWCqe7QV9kKhlVW5WI+DCJvL1MqGjnjhIKs6lxBXt52Hdclxv1NHogVdv2uV7OHkeVN
	CdfQZmSA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJpYZ-000000009uC-22Ll;
	Wed, 19 Jun 2024 07:16:35 +0000
Date: Wed, 19 Jun 2024 00:16:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Li Feng <fengli@smartx.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: sd: Keep the discard mode stable
Message-ID: <ZnKF06SqXHWA9Dlk@infradead.org>
References: <20240619071412.140100-1-fengli@smartx.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240619071412.140100-1-fengli@smartx.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

(note that this needs the for-6.11/block-limits branch to be pulled
into the scsi tree, which Martin agreed on, but which hasn't happened
yet)

