Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795142455;
	b=ycqAZ2xx5R79Sz7bMAaHpCIs2elhOaGsfv2AFYJ2/xdG0btQQ3FoN6vMktq1hspqDAew
	 uJNSpmOCgDB7Y8YqigHzHXEI61KvQXPNlV8Q2HIafmKhhDGds8ajPyQTLSJ00uUub5E0v
	 mQLRENqQEiJgaY1PxTBwscYeezxxdYUxO3FJHTTXocZLRBw+M+qx2SJX/2m3768jFfvoF
	 /5qp86ynk14xCWi/QlcsdFBLZ+L0LuLGUEkcaBqDa3XVR2Jx/iuRxihPGv3v+465cWtmh
	 gxl8PZ2GrnzjXjLihXEw4EX+sxzd2FrrttDGqPoRrs7D1K4lj+ju9RwZTQtm8ig/pCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795142455;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=hAEdMwxCUzAaZtBXyW5XFwGot7FvB4zIUpnv3kn0wko=;
	b=CmMSVtfKEk+wnMDg8pTQvieeh3zC2hVViGCXNCTGpLWGt7DeKKGr4O1vBkr7kKzNZDax
	 hApR+/+Tv5iOYHR098En22oS010CuQG2B/GVYqUqRW7tEL5OWlrjO+9HSbpRwoex2XnFq
	 6nn09JkMRMd64s8qe2QrF2TynDb0zbno2p80EGxhKLfMCClp/vJqzvhNkkVSayf26ep+G
	 ST0kd5cKaien3seS+9tKd7UpO6i5EIpl/pQ9sFq7m3SJA9xAB34/tBV8gIp7O5NTMiRJn
	 wkWaOxCVa386tox4VEvFD5xtvNF6u6lExNzhB7AtfkDahZvXN/zwofSeJJlkdhGxPJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fVkeT50g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADAA606A320;
	Fri, 20 Nov 2026 02:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fVkeT50g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC12A1F000D3;
	Fri, 20 Nov 2026 02:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795142455;
	bh=hAEdMwxCUzAaZtBXyW5XFwGot7FvB4zIUpnv3kn0wko=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=fVkeT50gxqKvLbzz0MLSUvRqDKDUdM103Fr3gKQ0z8uPXn6rpQCDCqFhsnIXoUcun
	 YJVQQWD/bj3JUrPl3grnWAhkJvn2OJ1gVzS26qu9qc9AYAvi7o/8aWOmpMQHuWoO+h
	 6OqXjGVuxYKqx930eye/4naVYSFHXTiuYbIWIiH7CHMa1iHAdHKALRJx6fZ6nzjFWQ
	 5ikLBephgF3+Offwq1ekjq1GIkJi+42glrfwbuiHDfCGE25aMq8t5MCRgBvQ+h4LGj
	 lepZfdXQsEaM2qYEx2gUhxLwTEGk8SAPkl8WcnndWbPTWogmAnHDmoTvSDBfLQA/Ix
	 DvWcIz876dVJg==
To: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,  "Martin
 K. Petersen" <mkp@kernel.org>,  linux-scsi@vger.kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: wd719x: Fix potential firmware buffer leak on
 probe failure
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261116-c29ba55625-scsi-wd719x@mail.sdu.edu.cn>
Message-ID: <yq133swql76.fsf@mail.kernel.org>
References: <20261116-c29ba55625-scsi-wd719x@mail.sdu.edu.cn>
Date: Thu, 19 Nov 2026 21:40:53 -0500
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


Guangshuo,

> A failed chip initialization leaves the coherent firmware buffer
> behind while probe releases the host. Disable the RISC and bus
> mastering before unwinding the failed initialization, then free the
> firmware buffer along with the other internal DMA buffers.

Applied to 7.5/scsi-staging, thanks!

-- 
Martin K. Petersen
