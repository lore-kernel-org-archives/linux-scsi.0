Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4F73CF02E;
	Tue, 19 May 2026 07:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779175354; cv=none; b=ZTAlzBJhrhOVps9v0lvOLKyU8ZhfxaCRy3wHAg+j/6yeqyL5jkP2LtygBLKK3Uk7mFPX0vQs6ikAHeWJmKI5Rh/A33HJqjX0THulk+k+b9y+SR1ETtAzyuRZqxD7YNWrZHfsKI2ebeSv/bmNOVCt5n5apeWAPD735HRLYdH3FtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779175354; c=relaxed/simple;
	bh=IlDToBN3uhyB405WtijoB3I8CE1tdtWe0zyZY3cKK2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I1PInZn8XXCfvc0zkTSkgxn3p+GdFXJrM0t3q0OL+hsffmKxMr1KbWQQkrksx6a3Ks5XrjYYKqT/sDkwDhqRY37uoJRuZ62OiD4GKoJjMcMup6QLuayWRT6Fp+6+hPLnPHrkTuzR3d9Ik+OSB9X1d/jqd5b3hbi3s0xdSCP0WBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 389D168CFE; Tue, 19 May 2026 09:22:30 +0200 (CEST)
Date: Tue, 19 May 2026 09:22:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	Shyam Sundar <ssundar@marvell.com>,
	James Smart <james.smart@broadcom.com>,
	Hannes Reinecke <hare@kernel.org>,
	John Meneghini <jmeneghi@redhat.com>,
	Bryan Gurney <bgurney@redhat.com>,
	Justin Tee <justin.tee@broadcom.com>,
	Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
	Kees Cook <kees@kernel.org>, linux-scsi@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: scsi_transport_fc: widen FPIN pname walker
 counter to u32
Message-ID: <20260519072230.GB10436@lst.de>
References: <20260518140945.2751273-1-michael.bommarito@gmail.com> <20260518143706.2808177-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518143706.2808177-1-michael.bommarito@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

> v2: drop the redundant cover letter shipped with v1.  A
>     single-patch send should not carry a cover; the lead
>     belongs in the commit message, which the patch below
>     already has.  The v1 cover also carried stale drafting-
>     time envelope markers that should have been stripped
>     before send.  Apologies for the noise; please ignore the
>     v1 cover at
>     https://lore.kernel.org/linux-hardening/20260518140945.2751273-1-michael.bommarito@gmail.com/
>     The patch hunks below are byte-identical to v1's 0001.

Cover letters for single patches are not required, but totally fine if
they add value.  I don't think you needed one here, but it also wasn't
actually harmful.

