Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793409632;
	b=MlrGJ8jwEN9e5+Oj0OCe4GBXLEMIVltX0S/H/FKAzqAstyTDkJjXOar4OlNF7EpPUNTJ
	 0ohf51/PMiknBm39plTQDGttx1k1THpH9SHCcTKGpx1L1A7e/L/PYFp3aCwhfNiKVCSWO
	 54aEaLKfLyrQpaUmJ++ATNi0dUHn6sO2xn+FTr0y/Y60T6t8ldBy+N+wsU1FJ67d3feBV
	 IHRLoZ99h394j29saTFtH9imv5ZzQzKr/upbAcwbVTXGP7e8mGb1BdwehPJThZbkOaR6c
	 TwIsZEy0/r3MCjnGGGKL4GVKuepVZi7d2vVwLl3Cwq0ROHJ3pnRd2wKucYzTcw0qEkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793409632;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=g/mIYz9yNu0EP8DJIxEGgKpRHzU7Io6XjfgeUAhM67o=;
	b=jWwzizxaEVNNr4oVr/sMiUd474ZXYlT2fQkb8dV7W1XKRctDiFWXCz8l3dbQvSkBlnTB
	 4/U1gKXU7VtlgO7ISIfp4rLSPE4hOVxQ/CoOITOJc9BlHnZf6cIZR93rnCTlPviSj8O3j
	 SmpplKf0HghH4+cxMkEJolXzk1idAdAfsuJ59mnZaogcRZSsxtiJe20x1d3f4Ueahhckg
	 ulBxEz1qgSICsRoKjp+lXxZBsMyZOfazkN854Uuc1fcOoUEkFuOlRLToM8ShgZHIwCTno
	 3FjUvdtLdmbN27QLqbnLfAOtzR3Sd0lzKZS0zm46AvlKOIJrfoPnfFprJAfTFh+giFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CGK6U2Y5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290A9606A31A;
	Sat, 31 Oct 2026 01:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CGK6U2Y5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721081F000C1;
	Sat, 31 Oct 2026 01:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793409631;
	bh=g/mIYz9yNu0EP8DJIxEGgKpRHzU7Io6XjfgeUAhM67o=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=CGK6U2Y5Ugp8o3/MO4GEgIshjU2q8c6LaDTcTgz09tDS+CCVgU3uJXXmcfMZ/7vGy
	 upJqFvUVtPnLX+s1yfd6d2gbOYGVnnb4q+oxJ+ABrU4GqYYsQ3kg8e5gQgx+C8Mnyt
	 YN03P5udssYVr341itW21usJLOTDGefmB/QDMfasZlMU0E+n56KE+wu0Wnr1cZY5gW
	 PADlsyxCxlcfpaZV1q2MQGgDyykTcxB1SIzTRcvlKLAQFfL30HclQ/87/WPr4CewMO
	 3xJ0YBOSL4iHo8iNNyDo2RuGWkmdm03RR9GbHD774Sbq/QYvQE+/sw3KmYDLvn20KB
	 5HZRnMOYAkzxA==
To: Yuanhe Shu <xiangzao@linux.alibaba.com>
Cc: mkp@kernel.org,  linux-scsi@vger.kernel.org,
  target-devel@vger.kernel.org,  linux-kernel@vger.kernel.org,
  stable@vger.kernel.org,  john.garry@linux.dev,  ddiss@suse.de,
  hexlabsecurity@proton.me
Subject: Re: [PATCH v2] scsi: target: Verify the iSCSI ISID is NUL-terminated
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261026124138.2708365-1-xiangzao@linux.alibaba.com>
Message-ID: <yq1h5i23bvm.fsf@mail.kernel.org>
References: <20261026044632.1738901-1-xiangzao@linux.alibaba.com>
	<20261026124138.2708365-1-xiangzao@linux.alibaba.com>
Date: Fri, 30 Oct 2026 21:20:30 -0400
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


Yuanhe,

> iscsi_parse_pr_out_transport_id() returns the ISID of a FORMAT CODE
> 01b TransportID as a pointer into the PERSISTENT RESERVE OUT parameter
> list, lowercased in place and never NUL-terminated. spc4r37 Table 508
> requires the field to be null-terminated, but a non-conforming
> initiator can omit the NUL; when the ISID ends at the end of the
> received buffer, the pointer is not a C string.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
