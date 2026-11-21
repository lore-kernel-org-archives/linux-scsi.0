Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795229700;
	b=jhXbdv4Eqm6tQSrLRGiskI7Mvz9K83QnuYMiAziQSapxOSDdUaccljl0bPT19mz7YsEE
	 hYF5orRjVg5coDDpkJYkSS7Z0ZJcJRDKiomujfwArfYgB7U7bFYLIdzwrLus6rGzXCZnA
	 GtzFtVUvvqpniMbNl4ktlqNH7URvQcgUuybkzF9g7IF+yU584NQxw94CtTFkH2cKXTOKY
	 +vkRYAHudcjtj3KGjCPmtZy7AGS945Kiw+WYn6Y05A14XAWGcklmbDdmCqiwWrXOVh4aL
	 zOYpNNhLdQTf4SB14rhjfrFpCBsJiX7uPmi6cNd5GUS7cDuUgdyhUJQLRrXELjBzUvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795229700;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=tkbpDAsujcNK1egTtNJMaOtNekKRVZ1368G84H0QJJM=;
	b=wTMm3ubDn40u2to+XtGZ27Zj/Hxg0x/xSARVtwGar5a4ijDQIPfhT4iGuY2L4eyh8Sqa
	 +2pGDGbzpr4wdZovz6P3VL2LvmqF+r3v21absM3othTRJxxKO7i0FAXt8IEEZjvwazTtE
	 I8CtAShqDVu9W+NcxjfsdRQSnx1ol/FcLJjxzI4IjrP6XAvwB4mYvKJ98lifAMs+X4+UM
	 qbWQlir0BHwqsboNreir4UYMU+sBfwIZ6/yoOEQh4PjAzp004SFBVlOAaGalVvpfuU6tC
	 ZwANPDo3I6FM6Zu0nxOEKCbuG66s7saOV2C5pYwkBQ5soSc4lw27adgpEd1ZODBbymg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qg50+h1k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383EA606A68D;
	Sat, 21 Nov 2026 02:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qg50+h1k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72661F000C6;
	Sat, 21 Nov 2026 02:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795229700;
	bh=tkbpDAsujcNK1egTtNJMaOtNekKRVZ1368G84H0QJJM=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=Qg50+h1kAsSA/r+dXi5ZAQ9ATL+wklyMu4xDxi4bFVx5aulRZgv+qywC9Eou5GCsA
	 feWhmCC8/LJI6pXvostTJomGAY7zF9dkQdOdEnBZuYS4f44tmCX89u58YJZGXh6jH2
	 RQ6MP6mNgZUpO0rMCiAcIsMbB0DARd5rR9f9wrKIim9i4NLNpIzHluyE2sKqDhRMkz
	 YHEdNjZYn6ixdatM1ZMhi1SvXOjs9vqQsPzZfuq9Pqpd7jOpmkG5oGLc0oaLduyKio
	 EjgMe3vla2cFTTAholGAlVmyAPrRDyl26TB0jzPVt6YOJcr3TkMu5iMMOhOYVf3rFy
	 OWtpnozw74URA==
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>,  linux-block@vger.kernel.org,  Christoph
 Hellwig <hch@lst.de>,  linux-scsi@vger.kernel.org,  "Martin K . Petersen"
 <martin.petersen@oracle.com>
Subject: Re: [PATCH v13 11/13] scsi: sd_zbc: always revalidate zones for
 disks supporting head depopulation
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261120210651.580511-12-dlemoal@kernel.org>
Message-ID: <yq1pkvynbbe.fsf@mail.kernel.org>
References: <20261120210651.580511-1-dlemoal@kernel.org>
	<20261120210651.580511-12-dlemoal@kernel.org>
Date: Fri, 20 Nov 2026 21:54:58 -0500
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

> sd_zbc_revalidate_zones() skips revalidating the zones of a ZBC device
> if the zone size and total number of zones of the disk has not
> changed. This is to avoid the sometimes slow report zones for the
> entire disk that blk_revalidate_disk_zones() will generate.

Reviewed-by: Martin K. Petersen <mkp@kernel.org>

-- 
Martin K. Petersen
