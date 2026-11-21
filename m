Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795229560;
	b=J0RBbkzGZafXh1oem7C3ENPfxUpecmDHesxCH4LRjRkEBtIzxGwDyUTmRP5QmFgQ8nuA
	 /eGAaeNG0pNK4OkaAjyCelodsHSOSuI2s+Y8ZhRtW2fjJuEuNgw16Dt5z8q3nNDtG8zHf
	 6qHa3LkbXoNp7b1NHzIuOq0Fg2AwDjPnLkw8LH/6B3Wr8LTaml0Zf3kpErF15pMhV+hw6
	 L7nehClTOFybrfbh71UZCnWw+2Fqa4gIYtGk78aLA66wvFSC0Dh1bYMJtkSrqsl88Rapv
	 fDtrz/UvdoeOeikaVmBe6TrAmcL67NrE9MWKaYm5RzHXioxAyRDWphna3M2pCAxVebQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795229560;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=zsaxmoDSgKvpjkh5EBd0Po0WYgCf7xC94gkK5JoU+6g=;
	b=N0JjXoKbI2PIcuvpLnJEpzrXarxfz8bLkwtBMcbOvxAjy+Dhu7pX4ZZF/UYe02atWoR0
	 8gUjhVOB9Xh8mG0Q3bd0tvR9zvC90Wqh3ie+NwHioHpSFGJhVskxD4dJgm1FfE+PM7wY5
	 4RSZxOE+oWLIg8FDy+rmThMkLbyF7PYDIGTZRRW2tWAwEsLOPdQ/f4oGlqmrvg8jiHHA3
	 65r9cpD1M8NalfZKyunUTT8mZ1XOw5UE4MZWpsxEI8a5jbrzsrwqD4muGYmxMgZGqMFsG
	 5dGEnHQpSDGapPr10mL9henvGV854sg1sAl1+HTDzkUptxa1zIu87/Fry5D2ctrsmDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DYyPEBzJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482AC606A69F;
	Sat, 21 Nov 2026 02:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DYyPEBzJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E5C1F000C6;
	Sat, 21 Nov 2026 02:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795229559;
	bh=zsaxmoDSgKvpjkh5EBd0Po0WYgCf7xC94gkK5JoU+6g=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=DYyPEBzJff5ZRjUp4S5ieNo2XSm0WUhFu8PDR0PaJBYpjgSiBFvhtCF20oiQ2jdqN
	 1VI1SRcjBy5GmeXVoWln39JKLZ0bcvxgyOY5+26S9rp2+ZaSdUCF8oxoyDZ4oIyfCV
	 hy5Dxakk9rIB9y3VTauzLhgSCrGPwU/3L4LcsVBSU2ktz8WAolTxXGNtQMw2RuD+Z9
	 dlmWrzC0SQX18Cx0I4gWR/Hi7ROD9Z5l1Z2PuYnj8dWHopGE9JbOAdTgSQQ2BuYWLQ
	 IefoMeHi8UYkdbLLFfch3m6ln8hJ7lGAkZa/rSrCcwJr/bFNQykiN6yco/RXyy/NtD
	 lqbKihWWC4Zww==
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>,  linux-block@vger.kernel.org,  Christoph
 Hellwig <hch@lst.de>,  linux-scsi@vger.kernel.org,  "Martin K . Petersen"
 <martin.petersen@oracle.com>
Subject: Re: [PATCH v13 05/13] block: add storage element management ioctls
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261120210651.580511-6-dlemoal@kernel.org>
Message-ID: <yq11p8eopzs.fsf@mail.kernel.org>
References: <20261120210651.580511-1-dlemoal@kernel.org>
	<20261120210651.580511-6-dlemoal@kernel.org>
Date: Fri, 20 Nov 2026 21:52:38 -0500
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

> Define the new ioctl commands BLKREPORTSTORELEMS, BLKREMOVESTORELEM,
> and BLKRESTORESTORELEMS to provide users accessing zoned block devices
> directly with an interface to the storage elements management
> operations of the block layer.

Reviewed-by: Martin K. Petersen <mkp@kernel.org>

-- 
Martin K. Petersen
