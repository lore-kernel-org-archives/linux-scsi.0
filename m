Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793408566;
	b=QMzyu7RwErutXp0+EohfsKVVnll+OWQGqgHF+44Sl/DN5kSqVhwpElNGUpB4z/2XnMtU
	 XwyRsluti6Bdw8myMsVe4hzCOQTPsn8GOpHPReWzWPvl/CKaE6v5SIwHHJAZovSyBqOAB
	 chWPq8UCbW0UltfXhor7Sbh+p/D8CVqOpN3dwcUXmwqgw6z5pJwiZmRLwvEGerWNRZslL
	 44Whg12pJ/Atlpy0C8hdSGpwGGKvaKXkLKei8Ci8DK42pqFke26+gIv9JN6C87iJ3FCuO
	 dunbMxbPE7pSbVpR8K9zLqEKybc4Fzt8Cz3SyNGCVcJCA5TsIM2eqbXQrgLyvEkdHqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793408566;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=N5/xDtL3YYs00CHg4e7X43HoZI7jsWI3yy/IEVUURD8=;
	b=Ac3SWN/NhJbcFrqOycO1EliWVOFb6GgK8d+wbcIYO5H9/GmH2hYy9RDOXF8AtEMpIJPV
	 I10UjDtiI/BHKzrgHORowJhZkjzRs7r+0rB6cAV1oRn1TAZ4LniLV0HYoF8PDHY/5JUbU
	 BtHP0ElPdj7bCILDEi1l9rF3iKY6MEUUdvZavwdlm4/Qm9k3Yb06xAbHHf0KSuNT8IhZl
	 JTKhcbzVK6Trh8FdU5vaFrfb6em2EZiAzW3vuNH0CkjE7HLDKgYx0UcTv151BsrYgHgDk
	 Vny7b6fQkCdfG1+KDEXExfE/ako7Jg9t9VGR4zKFRNU/hSlb1YdO5DUzJuSwKdDXHMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LZ7iv1tZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9CE606A31D;
	Sat, 31 Oct 2026 01:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LZ7iv1tZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08451F000C1;
	Sat, 31 Oct 2026 01:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793408565;
	bh=N5/xDtL3YYs00CHg4e7X43HoZI7jsWI3yy/IEVUURD8=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=LZ7iv1tZWln1+WFoELcoy0tP+/ZSFlkxpA4936RiK2Y1/dZ5uE/Znuch7pc9ZK1UE
	 Yefhn5qFIrmdcQr47KN5BnNoVcd6zjW0VycBFvgGsB2ECsrl+BhEJMsI6PDXN0QWTU
	 X3JScPC/b4MJ+aJFQBgiXJKF9blQfB+j0vv1Ej8Pr9+IuanN5dGES+IsIqH8V/d0Qo
	 S+ppwf86iGWGa+m2jrqAuuIXOJiNvIse+TlyrzY1dL7PRmCpSHuK8brhifcxk+GzMr
	 kd4z9UBN+rGNhdZGSV8OWIjh0dDpvv7lmk0kIJHwsXyHZ6RP/xmDB7lvjey1Of4o9R
	 ds8H7qsvhvh8A==
To: Jia Jia <physicalmtea@gmail.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,  James Bottomley
 <James.Bottomley@suse.de>,  Nicholas Bellinger <nab@linux-iscsi.org>,
  linux-scsi@vger.kernel.org,  target-devel@vger.kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] scsi: target: validate REGISTER AND MOVE
 TransportID length
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261021094334.198599-1-physicalmtea@gmail.com>
Message-ID: <yq1se1m3cnr.fsf@mail.kernel.org>
References: <20261021094334.198599-1-physicalmtea@gmail.com>
Date: Fri, 30 Oct 2026 21:02:44 -0400
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


Jia,

> REGISTER AND MOVE has a 24-byte parameter-list header followed by a
> TransportID. A 24-byte parameter list with a zero TransportID length
> passes the existing tid_len + 24 check, then the handler reads buf[24]
> for the TransportID protocol identifier, one byte past the received
> parameter list.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
