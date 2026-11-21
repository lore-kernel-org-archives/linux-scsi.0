Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795229614;
	b=cxsZMzAoELp+gPFjSinn9H0XxqBvRlvRcCZDUcr8snal4oY9lDaGxce+F0MUVnOcFSrX
	 85E+v8rpQgFUWzXCYF9aPbnyASiuMsEJWH8NAymFyIuyECFpiE9LN6uZI/K1utrixtLiI
	 wLbKhwwWSW7DtZVO+yIQIzrFFq0KG1Gvk16Zr+oPvw/HErWhnb4cqmXWnY70KbR80aqEV
	 TWhgBQ1K4Z5S44dYNcHwGweogk3nEepJ1KbXoEq7xWh+o5/QKv+T4hlByEd2iBBeqOUcI
	 RX97dWR0w/JLfnZNuZu0PQM0m8f3h9MF5iKcIQCH66g9pSy0SGQf/TgVXgXL9ZWFZVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795229614;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=VOogIc/Dpq7Dw4DTrtW+n8CQDomP9SSN07IrRa2/91Y=;
	b=OFvXzZ1asKHOu9n+7pFFtqTMDiZK/t22KlMVjvApV6APH1GkdGU9nDlMsHx4UoAgTwc/
	 I9V1tJrH9JH8d3SdSRQLun2E6MHwqZyvUP3UztOuX/5Ij+9Y5Ul97ZEOHaafW3fkLV4g1
	 owPKDgxp+1xbp+oukAfd5qj6+aMWbPoXVwAuYcuv2YhdAExEZu9aVy8BXXYoXyW9sSlL+
	 ZBUbU24el56VCzEEm4+lIoGv60DvEEGJx5Wmvf41Liez9hJBg+WEgnGCuonOQShr+sNBT
	 zy+KZPGUcihnrdQ+L6TRUVn0W/LdWjamTDhFXp5GlhN65YPpifNEs8HfRAXQNKubgUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ex9j+UPW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA485606A6A6;
	Sat, 21 Nov 2026 02:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ex9j+UPW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B534A1F000C0;
	Sat, 21 Nov 2026 02:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795229614;
	bh=VOogIc/Dpq7Dw4DTrtW+n8CQDomP9SSN07IrRa2/91Y=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=ex9j+UPWFQV6p137WOKfIda2XJfB+kist0vEE8FYMrb7xzkBaXPUYbamlr5+0iPFD
	 ILif9kbR2QW36TKMLx5Z6H34ACWT4WnuWELIyigJn/J/YSgz/mVkn1ceZ+rF/saumF
	 +EqzNtOXi2VhRoXOc4q0Eq767LZ9uHSQ2CppBwCurXmmZ6wiaVQLab3KC5l29fwmo4
	 9Qi4Ra8862ZIqz7m93GnOy11A84Lg7KtEnQxvOK3fflXKL7CDHTNTAOdFDXpOV4fZs
	 IN6w8gYroK9jebVbtEv+WaB1XfeP3xHVyVRS19NiaK0slv+UcHTdANzdFtklCEMuuy
	 HbTbwgPgBQcBw==
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>,  linux-block@vger.kernel.org,  Christoph
 Hellwig <hch@lst.de>,  linux-scsi@vger.kernel.org,  "Martin K . Petersen"
 <martin.petersen@oracle.com>
Subject: Re: [PATCH v13 10/13] scsi: scsi_proto: refine the definition of
 storage element health
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261120210651.580511-11-dlemoal@kernel.org>
Message-ID: <yq1v75qnbdt.fsf@mail.kernel.org>
References: <20261120210651.580511-1-dlemoal@kernel.org>
	<20261120210651.580511-11-dlemoal@kernel.org>
Date: Fri, 20 Nov 2026 21:53:32 -0500
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

> A disk may report the health of a storage element as being within or
> outside of the manufacturer's specification limits using a range of
> values for the health field. However, in scsi_proto.h, we only define
> the start of each range using the
> SCSI_PHYS_ELEM_HEALTH_WITHIN_SPEC_LIMITS and
> SCSI_PHYS_ELEM_HEALTH_OUTSIDE_SPEC_LIMITS enum value.

Reviewed-by: Martin K. Petersen <mkp@kernel.org>

-- 
Martin K. Petersen
