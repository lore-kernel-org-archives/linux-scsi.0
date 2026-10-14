Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9D033ADB0
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 03:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791948627; cv=none; b=WoWSEuWi0TqmJDQFt8p/dlI9T41+HKVYKJe87gLSF8vDO3iFFeOS0X0/eERb2sFyhNyzL16kSNguDH+S85QcJGXJFjlfN0tDWjnl2PwlXrGOgYXcfXaS2Ie7Neydfwic6stkjykypmek3fVgYFg0+mmKbx9/QfrHI3ESHhd1MUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791948627; c=relaxed/simple;
	bh=tfSgNszeG4gKoG4p4IgN0TLJWWy4xiSmseugwowsFqE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=h4iJSAHM4eI8WbScL3EVk8fEIxarqe/i7/pMvTZXUjsOulFfNYNxL0udpjztNtDxLDIatS/Psmm89eomqQTzCSiZd2gcavWbCTEuYmbvj5UxMS9479NTy46yXrLRVCRyeVefTlD/Xc6ZUUdoPBRgL5umRN3MgC0xf2F2cGQcXKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l0EJ2K26; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l0EJ2K26"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B721F000FF;
	Wed, 14 Oct 2026 03:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791948626;
	bh=N7JEhwjaHt3D7kP7gQx7p8LyA6gLEAiBhQgldQ9Ghcc=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=l0EJ2K26OT2RwrU3dmOVeUfCCx0f5ZZHV4oTYX2+IBfjdgFFLeGDnnnaWPGvJczYO
	 UI1iNqKyslU7g2PuMTvGTsWVS1S1CRxmkd+ZnmV5CO/N9mt+lFeiqqI3XtDUlMD/HL
	 /JSGgmPtL3gsGgHA2/Nn2HXKI1gyggA+ZWO6MvSqBKhrdM5feuPLWJnTmr2QuQ9z4e
	 JJY5VTbXpuDGMnnqUXNtQy4EiHk11A5pxghspRmDqZgK9oRNgbbbky1LbJd+p32CLJ
	 AJ6RgL8AdW5N9u5gl7vNTD19S5RBaAFuxDRCN36jlBauctnU1rmg0Bw5GfdXN2ALyO
	 zBQYYuuYvPI+Q==
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
  linux-scsi@vger.kernel.org,  John Garry <john.garry@linux.dev>,
  Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v6 0/8] [PATCH v6 0/8] scsi_debug: Enable lock context
 analysis
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <cover.1791924924.git.bvanassche@acm.org>
Message-ID: <yq1ecdtez7c.fsf@mail.kernel.org>
References: <cover.1791924924.git.bvanassche@acm.org>
Date: Tue, 13 Oct 2026 23:30:24 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Bart,

> This patch series enables compiler-based lock context analysis for the
> scsi_debug driver. Conditional locking is eliminated across command
> response and error injection functions so that static analysis can
> verify lock acquisitions and releases. Internal locking helper
> functions are annotated with __acquires(),__releases(),
> __acquires_shared() and __releases_shared() attributes. An error-path
> lock leak in resp_write_same() is fixed. Finally, lock context
> analysis is enabled in drivers/scsi/Makefile.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
