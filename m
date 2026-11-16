Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794832362;
	b=eRuFCtWCPdQ/9QpWYQ7MpxxhgEe5D7H0xO3Vbi6iVTQTLENZI8cN2WyG7H0GMtuqOpdH
	 V7GqoxaRtEqzpVkMUbfC7cnXgI4Ili0QY6PeSWV1aXOmYyEK3m9BAK0z+mJLfGgtEG0bw
	 au93EuN18xHfPWqI/21QydLQw4Nu4mJozzZ9dFa+jkVQ1BQnHqDjdk/RFusA6dp+DpQMo
	 VFzkJKV1gPirM1cu3BlOHXSSzG2SGS1mEXE0YBsV/VvMeCGuCIXetJbUUe5gIHmAkOlya
	 fAlnK89BXBCIZzLe3xN9+LR7W1xE/3K3lw5UmhwsF1WKHycWRUWJGhzMIUf7jBl6O5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794832362;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=Wu/xs78+R9EraA3QMxPnHPyldZGerV7oz+0ABoAixkI=;
	b=qBC1GEDwwky2pdg4zxCYxYH1lyNKQvgIkBYsYJEBIkpyUDeqzJprb8Yg89gpEW5hsSDd
	 m/O1wGv+GrQxmXV61JmNOOmJDmLMOUskc229pI2Ie7bBt0qBiflVo+K4I+mTw4Vd4XQhm
	 JBtO7wWAdQ5q7fa4iHuLsvbRGk5Yy0hsfVv3Zrll8RuwYiGCyRKHN+nLQs0yFaDpxo8no
	 s062Nmm66SED7bFBvXTVQkeB6Cut599pDHm0U/8AGDGcKqqxFo66Pp84rSK8W5OesKGHq
	 odReM3VIFHkgluixlFRMa0nuV/9kOj6rujetSmlnTlegiK3rfOBGA+qHy+ATSXmWWFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OMiQvMwb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3CA606A32A;
	Mon, 16 Nov 2026 12:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OMiQvMwb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E96D1F000C4;
	Mon, 16 Nov 2026 12:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794832361;
	bh=Wu/xs78+R9EraA3QMxPnHPyldZGerV7oz+0ABoAixkI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=OMiQvMwb1ijrWwKM0Yd3tH9V+K9XzlPKixQYRFrqxU4MTVmP9aERcqm51o2XyQRuK
	 xzzvrtzDv5Rld9rBLvb3SiDX3JcxB2AnoekZ/j5fNVQDY5YIB4HfIw5cNNWRDb7V6M
	 wbecA2nbywBhlSCPYoLWNLZOqLirT4TJ1iS7ncNejoEioZ9WGKU6WL8e48TeG0L4nh
	 pu0ZQk1plVZQ5oV7cLz8rzp2wkti6a4onqf7u5b0xqHEr/jUwJ4UKf3DztLGO8Zslq
	 CqgZIIYfm6DdxhhHqfP3wgZCrVNr1h4ivuriMU6T7rTO/sgM5Dg2khmjrti5CnHSbB
	 QW+xx4Qp7zD9g==
From: Leon Romanovsky <leon@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>, 
 "Martin K. Petersen" <mkp@kernel.org>, Yong Liu <pkfxxxing@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, 
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, security@kernel.org
In-Reply-To: <20261113083848.1517595-1-pkfxxxing@gmail.com>
References: <20261113083848.1517595-1-pkfxxxing@gmail.com>
Subject: Re: [PATCH v5 0/3] RDMA/srpt: Fix command initialization and read
 buffer disclosure
Message-Id: <179483235872.1361005.12065062548973022416.b4-ty@kernel.org>
Date: Mon, 16 Nov 2026 07:32:38 -0500
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
X-Mailer: b4 0.15-dev-18f8f


On Fri, 13 Nov 2026 16:38:39 +0800, Yong Liu wrote:
> Thanks for the review and suggestions. This revision separates the BUSY
> initialization fix and the target core control-read buffer fix from the
> SRPT descriptor validation and read-tail clearing fix. Together they
> address the NULL pointer dereference on descriptor parsing errors and
> uninitialized target kernel memory disclosure to an initiator.
> 
> Changes in v5:
> - Move BUSY command initialization into patch 1 and explain why the
>   target_init_cmd() return value is ignored.
> - Clear all control-read SG entries in target core in patch 2.
> - In patch 3, log inconsistent descriptor lengths and zero the read tail
>   with one sg_zero_buffer() call through the command's chained SG list.
>   Remove the SRPT-specific DMA synchronization.
> 
> [...]

Applied, thanks!

[1/3] RDMA/srpt: Initialize commands before returning BUSY
      https://git.kernel.org/rdma/rdma/c/fcce7700cc48e7
[2/3] scsi: target: Clear all control read scatterlist entries
      https://git.kernel.org/rdma/rdma/c/1ecb732b4524d3
[3/3] RDMA/srpt: Prevent uninitialized read buffer disclosure
      https://git.kernel.org/rdma/rdma/c/317128ea4f21c9

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

