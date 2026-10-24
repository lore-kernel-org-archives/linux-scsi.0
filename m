Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792810103;
	b=lChFUwL8dN4By7AplrI66f7p/ISEEFKNI24tT644KpljyeOBTfDBDjjMLM5xkult5Whw
	 j3lqhw8fIjCzXj4Al9EADA0u+JJ6yxbBiqv3JVR0iPRjtV9agTYd0HsgNmSLcyd5VG/V1
	 xso0/SjPu3rotWCgBmJ9+AbXNPA/Das16ZcoXViev1BOuqzPTsKir4Yd5F5smoScw5Drg
	 93ez1CQzkjPHuzmf9ClqhY/fMorfcLR3J9VjUJr73H+f/H5cB5LhugGDzBsiEfScswJ+n
	 PS6eaxy3EH6r7Jy/aI5AMop9SnGZ3qaoZZzxGUvWbXyWOQ1O7bFlb4POG3Q5r5XIHkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792810103;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=aY7L4zQZONVWe8GQfjIX3wABqlw3CVUOAfDFqsaqk2s=;
	b=hoFOq4iZB02I/fYHd6c2nTntEpUO8Y7K67Rwidc3edT2YJfH8cmX8VoEmnDEViUQ5Ps8
	 MSM/MImpUbr2tgdZv44+8EcF/c/wPZB3BlhN9LvLQPCjMecbMlj5VXsNLAMsRK9L4BlMZ
	 1e+Qc2Zvl9da3eSCexY6uq/gOoLs/joOb2wgc/WIgjbz0Wih6frgEIhDaXKLXRmgkj+fn
	 hjeepzUvZMvSOCv7CMHRC9mT0p2eCZB3n236dSb1eH095UEt3M6kM10dAwLmpa0K3FQao
	 Wqgu894SZQJTVAe/MtGZChibBTLxu7elwBmu73QRqW63abKlda3lBPdcC/+H94qc+Tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YkouPNOA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B348606A31A
	for <linux-scsi@vger.kernel.org>; Sat, 24 Oct 2026 02:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YkouPNOA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39371F01825;
	Sat, 24 Oct 2026 02:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792810103;
	bh=aY7L4zQZONVWe8GQfjIX3wABqlw3CVUOAfDFqsaqk2s=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=YkouPNOAWg09rkDXw8baPhHtVOypFMKa9IOnqe13l94pA15EqFfzJ2QuWbFTRkbmn
	 w730c4jRVYMwPdrGPcHp95+JzvoiiS2KNF9jbbdNNlu7yusAC4QcSCdOfk4wFQZobd
	 zeBaSN82dkyyYTNXs9NiighK93uJXOJTRcSdrJuU4DO90SvRZhz1gRJ6K+F3W9YsPK
	 ly+Yh0Zux6YqEfx2kheRW04J+XPvMEhWoJx4o3muawHFg2EydvLX/KLyzCoaWlWDlh
	 /+I+Tm6MDcKywq8xP4PzECwZ8zp+eSnEz+NGBd37Z1j09FYfm+aGBTBSX4RjJwsYlS
	 t7MG1fskO/JJA==
To: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
  "lduncan@suse.com" <lduncan@suse.com>,  Chris Leech <cleech@redhat.com>,
  "michael.christie@oracle.com" <michael.christie@oracle.com>,  James
 Bottomley <james.bottomley@hansenpartnership.com>,  "mkp@kernel.org"
 <mkp@kernel.org>
Subject: Re: [PATCH] scsi: libiscsi_tcp: prevent R2T range check overflow
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <DB5PR08MB100629CD3750FBF71475B5224FD982@DB5PR08MB10062.eurprd08.prod.outlook.com>
Message-ID: <yq1pkwz95ld.fsf@mail.kernel.org>
References: <DB5PR08MB100629CD3750FBF71475B5224FD982@DB5PR08MB10062.eurprd08.prod.outlook.com>
Date: Fri, 23 Oct 2026 22:48:21 -0400
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


Ratnaker,

> An iSCSI target controls the R2T data offset and length as 32-bit
> values. Adding them before comparing the result with the SCSI data
> buffer length can wrap. An R2T with offset 1 and length U32_MAX then
> passes the check for a 4096-byte write.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
