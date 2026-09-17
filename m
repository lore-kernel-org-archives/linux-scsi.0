Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996C438A72B;
	Thu, 17 Sep 2026 02:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789612141; cv=none; b=axbXnS4N6vzD9icxSU++2xdoMtylYuKxGU3cPTJXUcJrTDwcpaiNv2UEP16ggidj9FWx2s1W8rr0c7cXS8WCNo7RNK/Gc6YAGL2ar01qMCYlz83v5yqCpISZIzWh599wzpBidRRg+c0uu5ElmEgo2O/KGDnPJD+2YqnP69EBjkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789612141; c=relaxed/simple;
	bh=WsD8zl3iXTmEm1/KwB+INPIhCoRehrc2QI0nlvuxviA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KOiNwYp5bVp3KZhL0WMCN85lQCmNtMANrOkpaXBLaWlBDn2n6x/8Y6RA9nOREVmFfGeessCSm8MezrcX2caSI6TtkSGTpCW60mRi/I52lO9XY+eNVxdeux1+lqMLIrSBfFHIl7qTJA57fETWwBpGXu74waBbGtGaTLNCffzj+3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j9/7N4Y/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j9/7N4Y/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E121F008A0;
	Thu, 17 Sep 2026 02:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789612122;
	bh=t2ntrMd+tb53D7PQoi8Mary4EBGAAGmNqvhrJt7x9hE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j9/7N4Y/kWNB2FOJrDCuXBmLm4oI5F9G2YsmDYxksozopXBVJMMgt6fZxcV6ubaeD
	 Qt8AWM+2KMHdis4ARnCRhaSvPteS5Sj3PXmOGXIRONVevp1YE/rU42yEx/F0fGLIL2
	 bZWaK4uXmn13WzFDWEF6c3egfSHny6jOHTMkQI7VX932x79GzScSDab7QcoUtH2tRY
	 SNxuwsJBOOF2GmqUgYHeNp3d/Ri44lcRXXu/RuXWOJVgo4PcRypJ7QjSB0C0lkk5rW
	 FiQGlo6GRsHPQpydQlz3rG95kKJ/Pm6hUQb4xmpS9YD7i56Z3VKaCogeJ6Tp+cgzBG
	 k6ySJh/1G2LIQ==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: lduncan@suse.com,
	cleech@redhat.com,
	michael.christie@oracle.com,
	James.Bottomley@HansenPartnership.com,
	"Martin K. Petersen" <mkp@kernel.org>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: open-iscsi@googlegroups.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] scsi: libiscsi_tcp: check the data direction of a Data-In PDU
Date: Wed, 16 Sep 2026 22:28:23 -0400
Message-ID: <178961190593.3672510.15844038034708517496.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260801133635.1986706-1-yhlee@isslab.korea.ac.kr>
References: <20260801133635.1986706-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Sat, 01 Aug 2026 22:36:35 +0900, Yehyeong Lee wrote:

> The Data-In branch of iscsi_tcp_hdr_dissect() resolves the ITT to a task
> and copies the PDU's data segment into that command's scatterlist without
> asking whether the command was reading. iscsi_tcp_r2t_rsp() in the same
> file does ask, and rejects an R2T for a command that is not DMA_TO_DEVICE.
> 
> A target that answers a WRITE command's ITT with a Data-In therefore has
> the initiator write target-supplied bytes into the pages that write was
> about to send. Those are the caller's own pinned pages for an O_DIRECT
> write, and page cache pages for a buffered one.
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/1] scsi: libiscsi_tcp: check the data direction of a Data-In PDU
      https://git.kernel.org/mkp/scsi/c/bce07e2f37b5

-- 
Martin K. Petersen
