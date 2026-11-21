Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795229413;
	b=XMorOBs8C8WX8rwHc0tBZ6v3Ox9fEaKwSYBVidDCsMoDak4QmQLfrqSPMQz5Cy+NWrmS
	 BSdCWMMiAHSDQD+HPdM02jQjbrsLLI94rD/JGnUD81Q1hgoNPUDICFderqpYr5T/bFUVE
	 Imv0CHDQ72SSYT6pu8xT89JJ/raFrHPkZ1CB/Z+RV9Xz1DdTSDmrnehffos99KNQhDde1
	 z7hwu50bTMZAZml5yMHkHRr7SaRkDOs9CMFPTNiK+0tlHpdcZoGpCNVOsrP5v2oIse2TR
	 nhvl1MT/MVfxfN2I/6Yy7aMEhSOXHLg9n2GPjMkDdVe4pMOS7hVcNLYUyevCkNrzcxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795229413;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=Pwu3CQ/cGG5Tr/ofaVQDLTe5+ihkqNRTGlUINRg8AQg=;
	b=TTYPYJjz3e7BnuLheIunfzPG748KCTxKnY9loZvIO3Ru3AcwXELtTaMIEhHFsi8raO/Q
	 RazWpoznUNTvSqgo+6CiNbFQq2NsciTR2zwl8KODxQ0Mg+rdS2PSESJVrekQDl2g9Idht
	 72AaxxtSnVJRlHdffgBrxxaHtO76aKcgA+DK69C/0m98aWIELg473fGfzCYKmz6U1MVSn
	 I1pC9SKpdu8kwt5P718v1OQqOO7b3JQYX+f9mJxU3hsiMyCTyx0TBvfhx2ZWQxgor2Lgc
	 P9GmphbwP0hod0V6fHVBSmS4UVQAWBI4KcHSfgjkKQrMqeW9vT41FsJfQfsH6zFJLAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OnU3meTc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B9F606A6BD;
	Sat, 21 Nov 2026 02:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OnU3meTc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EEFF1F000CA;
	Sat, 21 Nov 2026 02:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795229411;
	bh=Pwu3CQ/cGG5Tr/ofaVQDLTe5+ihkqNRTGlUINRg8AQg=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=OnU3meTcD69Etb6syp2g+PbUcc7cVfcrrh7LTBsd8k+z5la5701MaiZ7rpIJzmRx3
	 qzWKOTU9Mh5hK7CkTDCeezaIbwKzAj+CkXgdwp0dDhj+0ag6Nkv22kr9ovRQQCHZJz
	 EI5XCflFjX4k6qYVZPDOmzVeyF/WsdPkedp9t9Jl49FXdZzmr/RIfrwYlJaqdwuTBW
	 ibaGii8GnaGAQNN59BaGfWXNRxwdaEVnJBeK+XRyGt9a0vPKP+38Xcdnuy8DudCJ24
	 Aj9zearFkW3f/HabbRFCwyiibsIIZ577UlISZOPjoKU36Y6PitdvMUoPlWPT4POyjE
	 ePq+wXfBJqmYQ==
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>,  linux-block@vger.kernel.org,  Christoph
 Hellwig <hch@lst.de>,  linux-scsi@vger.kernel.org,  "Martin K . Petersen"
 <martin.petersen@oracle.com>
Subject: Re: [PATCH v13 03/13] block: allow dropping all zone write plugs on
 revalidation
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261120210651.580511-4-dlemoal@kernel.org>
Message-ID: <yq1cxryoq4a.fsf@mail.kernel.org>
References: <20261120210651.580511-1-dlemoal@kernel.org>
	<20261120210651.580511-4-dlemoal@kernel.org>
Date: Fri, 20 Nov 2026 21:50:10 -0500
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain


Damien,

> In preparation for supporting storage element depopulation, modify the
> function disk_revalidate_zones() to take an additional boolean
> parameter drop_all_zwplugs to force removing all zone write plugs from
> a disk hash table. Removing all zone write plugs is done in the same
> manner as for a capacity change, using the function
> disk_drop_zone_wplug() applied to all hashed zone write plugs.

Reviewed-by: Martin K. Petersen <mkp@kernel.org>

-- 
Martin K. Petersen
