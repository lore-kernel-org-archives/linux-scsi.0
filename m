Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794975417;
	b=IgdDsC+kqa0hq4d0otijX/lJNGfXPhtCR8y7v2KVu4phhjxJSjR4yA8wzpZW8eIMFIy+
	 9w0Bv4z5QcJ93B6p3GmRsiNHtpKp5aVRK+HcVw7S4MzmofXoZNKpnnBy49RQJ3yZjJFTV
	 2nNIDO0c/0Y86HEyEQmnEfir7fOIG4X0L/VtwzC4VzLH9la/TTnOMfn3Mxi6GhfWGktRe
	 l/rJ8F2BtORtFsH62EfxAMidCtFI4FM1hf/hR8oKG01AMHs428dcdU3llNefIxWpI6OXc
	 gZslHru6N6Wn9VI/tM83rs8ThIL6L2RPhZLEu/6pmlabKON8l+glrLX6F4LUtwSA12A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794975417;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=Oq3LdiuqHdy8uImfBD/kK6oyEaAsBjUp1yViqWDAok0=;
	b=WmALy6jyT3DSfNVNDIwVBQpqx5k5uWhfWWsAKfDJ9P2NOQfBBLIhtQU2ynDo/10MGrIh
	 qMWThlWp/34HfVQiO6uQfUQoqyjvEyhNJtRS/TatJfoV7AktqzJRD52dn97XopdcnUpfE
	 y/W19vgLPyyM/OxPiF7P0amNKJf/MGd2LSIOs01A1hqrEoeW3QMyUDGb+27vgrtvEnUuf
	 jMBsrLpShHSu0Qeg/NH0Lp1aUI3yaV9n15F3nQSKya7BBh+WxETMNmA69OLffH46HvYNi
	 LXsDYi/LoZK5R4sRJxn+fvL0wSqgxHiMDCTaRzOybnONwGIezcU1zoBxEOreKMt8aig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jsZLCcxX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28168606A31C;
	Wed, 18 Nov 2026 04:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jsZLCcxX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD5D1F000C4;
	Wed, 18 Nov 2026 04:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794975416;
	bh=Oq3LdiuqHdy8uImfBD/kK6oyEaAsBjUp1yViqWDAok0=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=jsZLCcxXjELr7n3xisfn7Nuh3C+zwNip8IntaW3wBXs6ivCfxIKCcvocWm9r5DPJ3
	 Hzm+Ir0WEmRP/JjDLKl18bniUMQtaYmGfzj78tvoObg6cizPshTNhb72IuvWrm2To8
	 P+j381ztGGUBqAvs5SK8fATNaVoy7HGNhrDSpGQz8OMWNN9kFyoD6mIAEGt0S4cyKl
	 RzUoC6eg4+mhhtr95MRy6/3k+Q+NYWqRKoyz+cuYGogJVYn8jCXpM10Gj5wXLnO0x2
	 pXvUWisV4kb/+cDggwBeI0YaUr+ir20p1uKIyg+BqfCgTdkOUCI4Q7T6eFE3Xeg6ZS
	 h+7wmZStaU1Yw==
To: =?utf-8?B?6Zmz6Iux6Lyd?= <erich@areca.com.tw>
Cc: Subsystem Maintainer <martin.petersen@oracle.com>,
  linux-kernel@vger.kernel.org,  linux-scsi@vger.kernel.org,
  stable@vger.kernel.org
Subject: Re: [PATCH] drivers: scsi: arcmsr: add path of direct io command
 for SMR Hard Disk and Tape Drive
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <CAJLrZMWK=hMYsQucDA1RGk+6oPm44Nmo63q_VHnLH6KKx0d=UA@mail.gmail.com>
Message-ID: <yq1bj7msro3.fsf@mail.kernel.org>
References: <CAJLrZMWK=hMYsQucDA1RGk+6oPm44Nmo63q_VHnLH6KKx0d=UA@mail.gmail.com>
Date: Tue, 17 Nov 2026 23:16:55 -0500
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


> - Add direct I/O command paths for certain special SCSI devices that
> do not require cache memory..

Your patch got mangled in transit and does not apply.

Also, the patch description needs more detail.

Thanks!

-- 
Martin K. Petersen
