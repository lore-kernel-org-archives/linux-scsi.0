Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BC41AAB1
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jan 2024 09:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706088282; cv=none; b=iYstqqbi1IP+/QlbHpJ+Rzdd7l93y+Q/CpsjITmP+oHcepvCp6nn+DY7JF96l/r9hu8/0XqnWJhzNa5EyoLRfzRGDsQE/94HIbeKJCOjq8j3vNhGlFu/YlLkeUNNvpc8IbiEJixFWiYO0dNcLtTe1+tSNJT3Vvo05cFVoZfg238=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706088282; c=relaxed/simple;
	bh=ENHkusL/eZRfFODg1NK28lUW/imgNZkaJhV5Jwpyn6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s9O8XRJL5pQioPgvI4frvIRm0wJyDOLMQRk7pgtj9idPsya/q7EA/O3jOshbvxmw1efeEbzp2iZ6uFhvPbu7sKUnmEkuNGJ2tZSsb946WQ3Ti7DFOaM39V3wevHQyAdaRzlyvoY0zgh2N8ASsqmn7P0vdTY7hxD6Xsvuw3wWc3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=U+++Qsyj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="U+++Qsyj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xroszVIXX7g4d8bpFD+TmRLtneim7iS4gcgmwuY932E=; b=U+++QsyjQJS7CkN1CiMxyH3+qH
	NKc6ZDbfzawy5FUIxkiYntzHPkZYsUaO/dN16z28zQU69Cv9mTWsNIjf/r5Bby+nmVlJzo6xqBt1m
	aZ0CFSNAnkZRzpitZKZgx/Fbd50mQZ3kDvEY6FTkRg+EYL6YulfGZqKDT/RLvzR/uxeCS2go0DEmB
	PR4WGdfhQONW7G68Xp9lf6Ge10hdoYijQNaJonccoJWh+MMtaxvaPGxDiDyceGqz3YXMAPommKJ3e
	L27FSOe7EtJ4mY/xx9uu4zlE/++1nnO5wDC/NKMoQGzyWOaufL8Ptgolu1UqwV6sk3QUe2PwCD2y1
	3RTs6zgg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rSZUt-002DJ3-16;
	Wed, 24 Jan 2024 09:24:39 +0000
Date: Wed, 24 Jan 2024 01:24:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, brking@pobox.com, jejb@linux.ibm.com,
	martin.petersen@oracle.com
Subject: Re: [PATCH] scsi: Update max_hw_sectors on rescan
Message-ID: <ZbDXV4u17fcQHwjN@infradead.org>
References: <20240117213620.132880-1-brking@linux.vnet.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240117213620.132880-1-brking@linux.vnet.ibm.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

We can't change the host-wide limit here (it wouldn't apply to all
LUs anyway).  If your limit is per-LU, you can call
blk_queue_max_hw_sectors from ->slave_configure.

