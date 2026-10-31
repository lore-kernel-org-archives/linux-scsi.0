Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793410827;
	b=kuhV+/RaK/qnfSs9Ip4QOgEmzHbGsR88KqmxBWqv4aTwswbuD3EoJsFdT9CbQYaFwdYH
	 d9xu13LuD2G9b5lSR0irKpZHhQAjRLhJOZX6z6Ha/+18yJLwmzh/90po3wmotB70rQXKF
	 pxJWAg3oAfB9++LDtmEaROs0+TAyXRbAak8npqs56sccmqZR1z5Y9hIafIpSbuGa61e3d
	 yj+Q9n5zgcdp4Cmpj8IcSDYKcC9js6RXAbPosk2A7tC64UNoHPWGRTYZxUeOAgppScolJ
	 qormpCQL/9EFyNUH6xw9T0POt98fEvQ+X5LBp93kcOVtxH/RwdCYX+w55CCQxu99bFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793410827;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=zZjxsa0LSifeGK+Jmivu9RulGYImhdvbNfYOKA2qzx8=;
	b=cnDfZUfFlV9swyOLMrOvtSSd4ZckrMdc5QqqZEfvkCg68nbmdDGqHZHh9zEhWk8eVZbL
	 krAPaQXAvW24ea5npMkyykX0tSEX6/V9+15Pda9hi8oU/GWBKVnJpVprjJBaJAqa03gAg
	 RD8tU/mTPNRFgk6ir8a/VNgCLoozzjE2gUvavI/axoOb4jqLRBRF09k/Ojs0G7s3GBVAr
	 2gJEzojmJ0AKgLNIFO7QQ6gLqC+WlvDZXYLm/G67K/YhY+fkO3JohDuNqJFdJyG007FKq
	 HU7fP4d7oJRXasMlUZ2VhICGjEdzGV2wC1BQ8g2m0tvhM26P2a5USwY1IHvDevh3TQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z6oXofTU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F46B606A33F;
	Sat, 31 Oct 2026 01:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z6oXofTU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766EF1F00A16;
	Sat, 31 Oct 2026 01:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793410827;
	bh=zZjxsa0LSifeGK+Jmivu9RulGYImhdvbNfYOKA2qzx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z6oXofTU43ed3wUcfHI8ZZm1cthROX+9LFiHyvW6fiwdij4YnYgrfXPt64K+qJAAe
	 3mawsgf0bv9QVWipNTE3+Qb/uRkDbtRr+AaFUvqqJq79vsy60mY9KJc0WMwSkHHgHf
	 XYde/l1fAzQq/ur5eAQuU7/T2gSBe/ZtS70VZkEh4i7YbrZ5oH7xlDEuiHuWMR6fot
	 ryxPhGvBUOiMDoH1ob8t8f0fYBuMHUMKS9ZjuNHaB5xPXd0Ny6Bmgk12qyW7row+3W
	 EsYQNtw6PPRfAD2D0mCGvVYr38vNVTgxZ8GRPNR3YKfcO58KcPJL6m45bRwZrvm4dQ
	 VY56x1kc+h05w==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Giuseppe Piscitelli <ooonea@gmail.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: core: Balance the pseudo target reap reference
Date: Fri, 30 Oct 2026 21:40:12 -0400
Message-ID: <179340755631.952351.2187048231241062717.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261027100859.1031135-1-ooonea@gmail.com>
References: <20261027100859.1031135-1-ooonea@gmail.com>
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

On Tue, 27 Oct 2026 11:08:50 +0100, Giuseppe Piscitelli wrote:

> With memory allocation profiling enabled, unloading scsi_debug reports
> allocations left at module unload. A stock Linux 7.2.11 VM without OpenZFS
> emitted the following on each of three load/unload cycles:
> 
> [    1.644665] drivers/scsi/scsi_debug.c:8863 module scsi_debug func:sdebug_add_host_helper has 1024 allocated at module unload
> [    1.656260] drivers/scsi/scsi_debug.c:1261 module scsi_debug func:sdebug_target_alloc has 16 allocated at module unload
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/1] scsi: core: Balance the pseudo target reap reference
      https://git.kernel.org/mkp/scsi/c/8a832fb632da

-- 
Martin K. Petersen
