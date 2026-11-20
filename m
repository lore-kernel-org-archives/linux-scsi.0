Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795197906;
	b=SdukC+CiBTqQOkCIN0TVknltzx99nQRJLow6EFOaVf6Pv8wDQoIeoa42FQp37nBuR0Rs
	 gxxgBz5ETPhEbCp73Z4VP9uTOwKkZ6PjtEuC03u4JdGc07+NclYoOSbqXMtcttro5P2OI
	 zrZ9J7u2Xc3oPliMi94+3b9Fx2CxAFbcjYHvaRdAjrCoJDqmJV+uJdiqtigob5x+cFHlD
	 LVceQIhS25RZQF7xOPEiZO5D53MEUpoltwZ9iuULolubZm8G/nscGRD3aIrqcj8yZr4yq
	 vJR5pzmmxk+ezIlutRKo5WUlaF5jE7dck6408eI2SvhgmvF2Uj2C6fA/9lgLBij50bQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795197906;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=TV+ndjB6kD/fXUGkTTVfQZ6BpqYm9zK2BcubZNKV3/A=;
	b=CTZhLlS6gOT/6pDyubAbGgptbgAIQkIUZ1Tw0rIIGxHfv+I6xe2D3DZUkEq6mAoMNul7
	 OqvW2WSGSKUEvMwGIyVGqbuPeDWTZOPIxBqZRvLFokoKsqB2Mfxrpk1T/DyY5H7X4kxht
	 iUUHxA+hxPvPmWEW9kVF1hWXWuW39yN1FydOXmzSnpRy5xKGGYmyIOzkWr5U/IVpzXk7s
	 4lnJRNSdGXGAylcL4a9sCszOiNBj5e4yWN3gecXxw6hrQCCamjnQ7YosJOsPDqfDoNEmr
	 4KGWrVL3iGCdUFKfG8YFa0oKxgr0AjVwSYnFER29Zx/fsv6nvTYOdcSCp7rEmqIZI6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53C060A5BD7;
	Fri, 20 Nov 2026 18:05:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B53C060A5BD7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 337996732A; Fri, 20 Nov 2026 19:05:01 +0100 (CET)
Date: Fri, 20 Nov 2026 19:05:01 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v11 08/13] zloop: add storage element emulation
Message-ID: <20261120180501.GA1810@lst.de>
References: <20261116213702.225970-1-dlemoal@kernel.org> <20261116213702.225970-9-dlemoal@kernel.org> <20261120152038.GB26913@lst.de> <ac126584-6fa3-4cdb-b6c3-ec99f75dafff@kernel.org> <20261120173609.GA1206@lst.de> <82e0ce43-73cb-4374-8761-22c178a29f05@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82e0ce43-73cb-4374-8761-22c178a29f05@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Nov 20, 2026 at 09:51:41AM -0800, Damien Le Moal wrote:
> Hmmm... That can actually happen regardless of storage elements operations
> because we do idr_remove() with zloop_ctl_mutex() being held, but before calling
> del_gendisk() without the zloop_ctl_mutex being held. So we do have a race for
> the device ID being reused, no?

There is a race, but it should not matter because del_gendisk quiesces
all I/O through the queue.  

