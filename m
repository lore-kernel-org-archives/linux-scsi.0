Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794196554;
	b=jcWsV8Yrme3+J947bHq/4dD5gD+LSP4iY9d3vH+hY7DiVfJBe6uZ3BtSF5NAXspLLCCd
	 TpCaxumOVx06a6EzlOF/oETuZwBhBVYHHbe7Wv+ijiU/l/VX98z2EKelxLoWvCFrgodbJ
	 YnWASt04IFg+ZRqkeEedqz8GElu2diSTOj/gQeCG7UyasTPAyPuzdnX+LEgzHnwJmPMiu
	 8ybU05BWzRhIxbXCzPwnE+gqzELi5JMWPPRa5kBL6vxpc0KaXhxLhewnTVhgExIDbVTbp
	 XEvEja8L39bj2xH/OpPnb3tX/IggP/cW0QC2fdiWfTZcssOFEx+rzepCe5fCsK5KkGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794196554;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=NdSfVFMRHW5pc7uIkSecBA8BWEnrgdl+JmAF/YPp61U=;
	b=JoZ7cs0lIbDi1p1NAjOT3Z937pfyd/HD/dKTmFvhVz0qg+RaX7LCGd4Jmq0/1L5SkfYT
	 THfvSo221hP2Stz9cwe+lvNO4j+0c1EzCHxDnmXzV2rfmXVTaouaO++oTuIlQ0MIWBBWu
	 3vDVBlYoUO7ArYR5sl35co4b+1veUz8PR2fBwu080GPQrPeD5Al7yoix70O7p8AEaFbYX
	 RD18WLzQmlqSF7L1yQDjvRnmh0zpQLM8ZnBtUmE1GrCdFBIFr1CQ77c6C9lGJ3eN7ojWi
	 yHrURLsEpAwH2W1Hv3F1t0zfBFTcXiT8tq/oMBju6Ki/4vG6OG6WKaHjWYHpvPkEW/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Oh5aTe8L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A50B6082BC5;
	Mon,  9 Nov 2026 03:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Oh5aTe8L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541BA1F008BC;
	Mon,  9 Nov 2026 03:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794196554;
	bh=NdSfVFMRHW5pc7uIkSecBA8BWEnrgdl+JmAF/YPp61U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oh5aTe8LxHpE2Mi/csfxTpk9IKApjDwttaKyyPYWFBBZdYUASg6HABzXzjHMt676P
	 ZHnyqfJPN8CFwXA8+4BHQqBb750Nzvik4NZOQqZC62K6ysQi53FW7L7gya8Je7vI26
	 LXErGn0OGMvjvKOB2h4bJXWme560ePsdnOSL9yILHsTFdT8Q4WeN0lxIvsvy/H+EU7
	 Oxjk70DqI77Zrf4bueDWJcINRhqDEMnZTni7J+gnqh5sFLl4LEx/6QCiPzITvvI8NT
	 bk7QyLJ7wVeQz0C+CRn9BE9TaEmh6Sm0huuxTvcVVGO1PTGSQLFN4J2Sf5eADM+bFx
	 adl8K6dDxLl5w==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Boyan Liu <yymhvert@gmail.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	co+4a4f9998e2b4b490@bugs.sh,
	stable@vger.kernel.org
Subject: Re: [PATCH] scsi: sd_zbc: cap zone report count by buffer size
Date: Sun,  8 Nov 2026 22:55:34 -0500
Message-ID: <179419615238.1941224.12734102484668812583.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028061651.110435-1-yymhvert@gmail.com>
References: <20261028061651.110435-1-yymhvert@gmail.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 28 Oct 2026 14:16:51 +0800, Boyan Liu wrote:

> sd_zbc_report_zones() limits descriptor parsing to the requested zone
> count and the device-reported ZONE LIST LENGTH, but not to the number of
> descriptors that fit in the allocated report buffer. A malicious or
> malfunctioning device can report an oversized length and cause
> out-of-bounds reads while the descriptors are parsed:
> 
>     BUG: KASAN: slab-out-of-bounds in sd_zbc_report_zones (drivers/scsi/sd_zbc.c:256)
>     Read of size 8 at addr ffff88802c8d2610 by task kworker/u8:2/37
>     Call Trace:
>      sd_zbc_report_zones (drivers/scsi/sd_zbc.c:256)
>      blk_revalidate_disk_zones (block/blk-zoned.c:2354)
>      sd_zbc_revalidate_zones (drivers/scsi/sd_zbc.c:566)
>      sd_revalidate_disk (drivers/scsi/sd.c:3898)
>      sd_probe (drivers/scsi/sd.c:4101)
> 
> [...]

Applied to 7.4/scsi-fixes, thanks!

[1/1] scsi: sd_zbc: cap zone report count by buffer size
      https://git.kernel.org/mkp/scsi/c/612293fb469c

-- 
Martin K. Petersen
