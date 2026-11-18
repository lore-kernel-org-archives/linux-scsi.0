Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794977423;
	b=KjPMP9BCZiKy8orEqCyxEz1yJy7AYM/nWRCvnQRTdGUPPFVik2DEvTNKV9RaKa5mZwv5
	 yzlugl51NlqBRdTI2ehTj3gzlsf5WiN4jPmNE7FXm9Jy/T82v8u+8TokGgCjSz7Ngl3Kb
	 A1QzqJrF5HdsiCFROhuxS0s2MdXcqULxeD/scuG7Jht9B30GFl8S+TAPZ0yqb0U5DhuuH
	 gCQ32v15jLx3ISmtwHnGvH8LeWqQVJlxOqokdR1ciidytGYx2u0hba4D6XArv+xA6dSPh
	 eNvndt1u8z5DSdvu060D+099uiWoXwFZ1f0gbdJ8eZ+Wu+STdQ8VrbW34wHtzAdoiKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794977423;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=MIV9srjPHzTkegh/PG57Bwb60DDBsjNI3s8UowdL/iA=;
	b=PJmhJ9Nt/2Cir7tvMqoP3lqTMsstzGu9Q+BfxAkSIPrUJnys5s0Nt0N1raVb6/A1wdmb
	 C6ML+uXxDYc8Z5j6FFqKolqXY7X1OO7Hxlih7+sWVCjueNOVHvAp8BTb3qPRNFTNjgOCT
	 vYDthhg2PNJoIzqtYlSnadO9WQX68MSeSq4NGYqcgxCFrp3VNoeXaagN4xmu/kPlYKDhe
	 H2Lqnt2frtsHwI2/faxLqRH/0DAbo2GYAXrTn1Q6j2fT8w5zEeHSXQiZut/ot/4ob62u5
	 zkxCM5wQqsrpzs2DdiI1XMf68vNnFLdnOKC+X1JOKNotU4FN3WiB+aQUKa1bmW1gx8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QKccE5pH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C3E606A880;
	Wed, 18 Nov 2026 04:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QKccE5pH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494CD1F000C5;
	Wed, 18 Nov 2026 04:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794977422;
	bh=MIV9srjPHzTkegh/PG57Bwb60DDBsjNI3s8UowdL/iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QKccE5pHvMdSkMWzspRGLWZX6SAHTCle3+vUHEdIFykWPF3ihx+25V5u9wigkoGje
	 /uGq8d9Ae0sGV5ToqV6QwgpEyB4E1eGC14HqY2kV1ia2BnFkqELlr9lvFXtC7jssmT
	 5B2cuPPmGz+KqZ7c/u6m/URx+nrab4BnDWFSQFOSGVYNUtK64EoHM4D2/Q8RFmQrpr
	 cSjKFi4cscwli7dyjW8+xVlJtiQBdku6fBulXITdWOEmmdnFXqECJhhBwTASADh0AU
	 HTlF6RE4GBvke6chQ3El1Oeo/P50SJ+FtOEaRBf78eKThHShYHbyeii68NKQgY/EFU
	 E8V547RjvHLpA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: james.bottomley@hansenpartnership.com,
	linux-scsi@vger.kernel.org,
	shao.mingyin@zte.com.cn
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: scsi_devinfo: return an error when the proc write fails
Date: Tue, 17 Nov 2026 23:50:13 -0500
Message-ID: <179485091821.1479907.5364803904547309993.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261031222133489hI-BEIDpFMxrtlntnLiFb@zte.com.cn>
References: <20261031222133489hI-BEIDpFMxrtlntnLiFb@zte.com.cn>
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

On Sat, 31 Oct 2026 22:21:33 +0800, shao.mingyin@zte.com.cn wrote:

> proc_scsi_devinfo_write() calls scsi_dev_info_list_add_str() but ignores
> its return value, so a write to /proc/scsi/device_info always reports
> success, even when the string is malformed and no entry was added.  Users
> and scripts then believe that the quirk is in effect.
> 
> scsi_init_devinfo() already checks the return value of the same function
> and fails the initialization.  Return the parser error, but keep returning
> the number of bytes written on success: a proc write handler that returns
> zero for a non-empty write would look like a short write to the caller.
> 
> [...]

Applied to 7.5/scsi-queue, thanks!

[1/1] scsi: scsi_devinfo: return an error when the proc write fails
      https://git.kernel.org/mkp/scsi/c/787fd1429b36

-- 
Martin K. Petersen
