Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE37386;
	Thu, 28 Mar 2024 06:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711607809; cv=none; b=WX8lHZvj+FrF4fZv2ghsU+qxYVgQV+cXu48A4ljT7/2GBNfFl/pnUxp2l/hoACeD9HyrqplUl47RvsK0cf0izr1z1+lXKMZJBcyCQVBlX1zWpJIzevnymxkFIySdvAIr5+uqioPQZV1amw4adAdfpkc0Qndz8T/o+B4Ac4PyOdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711607809; c=relaxed/simple;
	bh=ea2by/qeZT2l6ppuo3THkAJCJQiBcyLHkCBFfTWqsN4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=djjITSyZyweLrgcBm3Ff/K6OlGoL3y6im+PKlGDj7QXsi6ZtqlI4nt7GUZzV/G9rjNQ8w3aUt1D0eqgaY9wDWCKirLkm0srHamgC0UQVJoFnVoY6EkfMLIzBttDChO/UMv/c+gnp3NPl/voroEcV+ZMYHnp4wfXPGaxQ1A2yAM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FxaDDeOa; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FxaDDeOa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=h4MAWcCbj2efFunFuP241C6fJdcqGNqHSuM51ikvYgU=; b=FxaDDeOa8hTBN4jqG/Z62cf5gF
	MlqOVS7S+oBcY21wNFslpOBgiL4xj93n5yeLZk7otVAqstqbCskEQP4h/v8Iv6p1t1fCFg5PG6kO4
	aSZ/pK56frZVSHZQmIUQXfZrDybwWk013Yx8xDxpuxThQLsS1vlS5IR9Hx52AQ6kyFnRth01TiJIf
	SzxUl2gFP8QHffaBEPDnFXWBQSP8+G4C0TY3kpQLEt5HBlVqZjRaEZkeKDztmUvAasOArMGlvK5kd
	oAmr0esHsJYVkfvq7tmFuRb4VsiCoUAmwSnVIc0QCq6BIse/K09F4EwmC+ALkYeGrJ8jmCWiwK3IY
	ARWZljQA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpjNV-0000000Cjm8-36qH;
	Thu, 28 Mar 2024 06:36:45 +0000
Date: Wed, 27 Mar 2024 23:36:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yihang Li <liyihang9@huawei.com>
Cc: john.g.garry@oracle.com, yanaijie@huawei.com, jejb@linux.ibm.com,
	martin.petersen@oracle.com, dlemoal@kernel.org,
	chenxiang66@hisilicon.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxarm@huawei.com,
	prime.zeng@huawei.com, yangxingui@huawei.com
Subject: Re: [PATCH v3] scsi: libsas: Allocation SMP request is aligned to 16B
Message-ID: <ZgUP_ZhWPxHQwZvl@infradead.org>
References: <20240328062657.581460-1-liyihang9@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328062657.581460-1-liyihang9@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +	u8 *p = kzalloc(ALIGN(size, 16), GFP_KERNEL);

No, a magic undocumented 16 here max no sense at all.  See the
discussion on the previous iteration.

