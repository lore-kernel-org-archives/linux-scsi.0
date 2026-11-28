Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795835786;
	b=se+ahecno45Z8aNADEe3R6VfNltXnpVipP2AG3c5dMzwNgG49/KM7XpOaySlAqfoR6n0
	 xkklj2PmKh9sfbVDgQ63wsM1/pCsd3zEYzDQwZ5Swl9E3CMfugWm3CKcbKioc1ycBYpzP
	 DtwYBA4EFtjvVMhv7rdFXDBB5bv9x+1VpksOVaVZkKAn9jKbvsnUgiyIv/z2WCwXklM/c
	 yDkEmne3rVGuPG1wDzEdM/sO94JL0+UVFuRjcg9Ugah7uN3FRfp/8b/v8vDYuKnECvlib
	 N1o0CKk7QcO7fif5ke+Pa5wZxrxeHz3e+S2R6bYXOiBRZgsUskipM39tS/tWXhdKLyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795835786;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:In-Reply-To:References:Subject:Message-Id:Date:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-Mailer;
	bh=yvCt1gdskx/Y0jOYT6LmJ91002gzEPa4iXQSvGo7T/w=;
	b=OZlFF0h3XjVlFdsGmvCev3BGpMX33Lk/h1DdFE+60ylkMClGhC4dvSmsPQ5fa2vWyzaw
	 99sKRiT/MMxx64HYe0c3K7EUmmFtn9oyzYp2RycuXTvXZULbDZVcBgNO6OJPg/c7Pg930
	 6OmPcwklATkiO2YGrj64QypTHug2XBEvI9nmPtvaHrq3fnUpmwpcJkw9QhYoOEhQCp6Rv
	 ukIsQHcfs8J08d00cW9TLOAUJFGf7ncpPdBr38t5VMAJUD7irkc6/9nvfXowXQs97tYzG
	 BM47n2z0sM0o+l0l1ooVQAu/wXHAitSpzZdYJWKirpzNAkixzMSbvshYtwQ7zGZaNzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=kernel.dk;
	spf=pass smtp.mailfrom=kernel.dk;
	dkim=pass header.d=kernel.dk header.i=@kernel.dk header.a=rsa-sha256 header.s=google header.b=nDu9lVQt;
	arc=none smtp.remote-ip=74.125.82.170
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9ED606A31C
	for <linux-scsi@vger.kernel.org>; Sat, 28 Nov 2026 03:16:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E9ED606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.dk header.i=@kernel.dk header.a=rsa-sha256 header.s=google header.b=nDu9lVQt
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-38431138772so11441551eec.1
        for <linux-scsi@vger.kernel.org>; Fri, 27 Nov 2026 19:16:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel.dk; s=google; t=1795835780; x=1796440580; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yvCt1gdskx/Y0jOYT6LmJ91002gzEPa4iXQSvGo7T/w=;
        b=nDu9lVQtkryVMSZeb0kvkG3170q+2QAclKnT7mGciWVBndJFoBkISt5ECqvVgW73f+
         B/vFwxyyKwhlV/gQgdeagWaouoK+N4XfZ3HG8dQKeH8wd1YMEO0Rzhse4hHitkp1akBY
         QJhW2MEUGaOntTblnwaQfAyXjLSN+xCyLcIUCkbjCjTxnZT7kAoPlYaPNJ+zfoE5DNI3
         xyCeQm9M8YzfUWZ2yvdZ6D0o2vD3AMrSk2xswASGN36o28s3OR9bAqFAF4UIk3diU3FB
         xRCpKv7cmR6Xgp7A+UhcjpweZ0ycwJ2kTP9cO2OqeNaG6yxXfwsw0tl63k6cxFVyHplD
         FWAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795835780; x=1796440580;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:to:from:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=yvCt1gdskx/Y0jOYT6LmJ91002gzEPa4iXQSvGo7T/w=;
        b=mG5JKe2cwzI3raTIm7vCH2EtX4pmEBG9PUfrHwEF78Zty1tIN5aErPd6MNS5C/pwoX
         a5exysvZ2Jsmhr3QPWCVhfgNaO31SUnMgbCjq57Nq3kX9vhFmJfG1vvkWOeZV6Bnc7w/
         WZWznFjokqYaN4cWrHGxwfuD6TlQ44GSnkYteB3l9iM+jpfZUlGLm0E0dLP6FkJfPYHk
         Mvbxo0PozCA5oJAgdJj0lrfJpuDrQDQOljrjP5s64o68hMaoxqbW52SJKZGMzOJ+dDJK
         KzRcBbQ0TLQj4EhfkSnP0B+d79KibvyvM2NyJRAY8OATYhhDiKQNz630U6BLV9ZBH5DN
         PwNw==
X-Forwarded-Encrypted: i=1; AL+hErERI2LAqfEskm0eXy9pSu9cfqVeRMlOyuTNQWsemsa9j6c+bJ8ymPpJpKePwCkq2mVILWU+LjgwHDub@vger.kernel.org
X-Gm-Message-State: APuU4Z9KhnV8RNpv+D37qJP/6JjET83qXBsCsJ8jqwk3+lEIV/tx3BS/
	fQqha3LKMat7ZZ/H+SxUBl2VgK0gSp2aBjcQCVeMKpnSdrLyE7SeXcQhl7bzLYWHvwO21H8GZa3
	5MlGLXpA=
X-Gm-Gg: AZFdTZdeCR4XwYpgIqSLiMVlq8AhaoNPdb25UyjqRIv/TFC+0wu8VVmyJM3A0avw82o
	fRN+NVvwKF6dnBsaVgpupQ/fh0AVH9rSEHUALqAxt6cIjhhy3lT8KH79MnbOUOoI0RA9f7XrrEi
	iEdIZDWx29HQRmBf0Qwq9w6GzBYJjLX1dM29EJLuPJGF7spXTg1+bNZifrjs3g4deS8wo/f5YWc
	kKoU5TeTsBhwadBZt+Nw6nsmss3iitAbHwOiLHHYJCveXdwP2C48susi5bdIL4bjO6d+/g2i3SQ
	qtghHOQ7lR729EKfWCTwUCCKx+oIKvYLDp5ji30Tu19T/UfOqFvBKKNOwuRW4xRfx9GkW89mc1n
	10KEh1a2xWOsLqseQB4Y8oVmIvvw0FphR9A+SQpYLXwyN/xqVkvbKMorodFzdVd7ZRyYn0ABcVO
	ekt0GHJhrlcziYWF9iDa99ahjNdkNSME6hTLcwN3PAqLGVYwBQwZvsRUUIlNpYS1KNvp6VqNaS4
	YEyD4udQvz/CSz/2sx2B8Jxi+hqkYWCdmFGXYaTZnMCClbZuTBo0+20a0yfVKRPxTZC1miwo0zp
	SlAtjIbT1RGG7snj2xId7u4D9D3xy/+U3lvtWn03ZTbrQtqzOTR3CjxguqnK/x2j8JefNLKH2P1
	tJuFZKaG9smb/JZFVGJkc4eY+yoksShnojgdydxRgmQIjiCW7rqmCMrjikKxtmUW475r/GQ==
X-Received: by 2002:a05:7301:e103:b0:385:496e:80ac with SMTP id 5a478bee46e88-3856fe59334mr29203520eec.8.1795835780240;
        Fri, 27 Nov 2026 19:16:20 -0800 (PST)
Received: from [192.168.1.142] ([198.8.77.135])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-386c7c62a91sm36623124eec.17.2026.11.27.19.16.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 19:16:19 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, 
 linux-scsi@vger.kernel.org, "Martin K. Petersen" <mkp@kernel.org>, 
 Damien Le Moal <dlemoal@kernel.org>
In-Reply-To: <20261120210651.580511-1-dlemoal@kernel.org>
References: <20261120210651.580511-1-dlemoal@kernel.org>
Subject: Re: [PATCH v13 00/13] Add support for storage element depopulation
Message-Id: <179583577931.94675.15322542567681929533.b4-ty@b4>
Date: Fri, 27 Nov 2026 20:16:19 -0700
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
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Sat, 21 Nov 2026 06:06:38 +0900, Damien Le Moal wrote:
> Jens,
> 
> These patches define a new set of block device operations for generically
> using from the block layer the storage element depopulation feature of
> zoned block devices. Support for this feature is added to the SCSI disk
> driver and an emulation of this feature added to the zloop driver.
> 
> [...]

Applied, thanks!

[01/13] block: introduce disk_zone_is_offline()
        commit: 0f485d3ca937c4ee689cbe8ed91820baf3e2a87c
[02/13] block: refactor blk_revalidate_disk_zones()
        commit: 66c66cedc2cea679210879a30c4b79c760fc3884
[03/13] block: allow dropping all zone write plugs on revalidation
        commit: 0de926d244f23fa9fc88dc93874fc9366be291cd
[04/13] block: introduce storage element management
        commit: 5848abdc4e80e4690ded2dbfc0d1ec4b24513c87
[05/13] block: add storage element management ioctls
        commit: a2333b0f548a23bdc63b440311344da3caf4064e
[06/13] zloop: fix ordered zone append handling
        commit: 506dba8f5cd91b9cb8a113f0ef18cc8f27616ac2
[07/13] zloop: fix zone reporting consistency
        commit: c61ee1e7f15161a1a4a870c2d417685bed77db14
[08/13] zloop: add storage element emulation
        commit: fbff47f53afd4c9b2697f3e92f5c73cbd7538872
[09/13] zloop: add degrade_element control command
        commit: e0ec1629c269bad515d88398f4b2a474d4416402
[10/13] scsi: scsi_proto: refine the definition of storage element health
        commit: 9bb8df1a44f6c52d4360bd93f9e3076d422058cf
[11/13] scsi: sd_zbc: always revalidate zones for disks supporting head depopulation
        commit: 926c932a9e1483b4d5a1a058c147e4d18ff14be0
[12/13] scsi: sd_zbc: define storage element management operations
        commit: 4745c9c7b359dd27e5a256da81b69a4a42bd673f
[13/13] scsi: sd: fail read commands to offline zones early
        commit: efe346b1854e230970e2aebf734d916bdd28ea57

Best regards,
-- 
Jens Axboe



