Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982BB51A127;
	Thu,  1 Oct 2026 13:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790862771; cv=none; b=oFI5xXBZwlTHBUaE7ze4GIL36oqFSnqZ1G0yTrOPjN+NmC890/N73RJWJf2ZmH5Y/yCk0AeFcy/MM4Zl/okIh4oYBzgwgcFAfhjc5+wEHpTIvfbC9rXtK07TMuzcF5pCfOxSnsQpdn12XNFIZoE0050jJHiYeQy7FVA/wGCAS5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790862771; c=relaxed/simple;
	bh=XU2wuKZeWAvpPq3kobbsvRuw7oo6O90onnwNfKQsOBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gy/N/Q/kNXbPLqew9TM1yuqFuQT69umwTzWvDgYl7dVUImFGNcf52wq5Wr4a18Qrd62lyLgr31HyLWXWlUN7vBavwITp/t+s1pxalxBXpliAMYBOn9LdH2cvUqrz2E49PRZnxrZ4HxLDoFGuv1EqIETA31EoKfEE7BNjKoYrohU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DEbt9lV6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DEbt9lV6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56251F0089A;
	Thu,  1 Oct 2026 13:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790862767;
	bh=zyLFSqOjQoPPiUwlvecs+4oH/DxVxBAbrITLp9N7bzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DEbt9lV6lJUmyhOOhHDvCmU/0bsBNN47ZTXK5A1d1blgTHVLULTsiBcsaNpHk2jES
	 PS91t2Alw8f8I7+oBBbNYJBI1nG5XJmasZympbP12A67B/mJH/JAWYYlUFMkAQ92ZR
	 6CzzNsIN0paNHPJ85hFZpfi7DuFO6BjgzVs4/x4/bcyasLxmv3iM7M0Nb0ZN62Gf5a
	 rul//8gVhT/ksKsjthDKaRI0afeL/HK5tcaqRWDtV4jApL2EgxACgsJ4QN4Nbf0WqX
	 sBcgG+8PpUtu8IkdjB0KPh3a3yjG4mX4H7lq4hzWK+XGF2Tyl1jbJ/VY+wa0TxYGoR
	 0T+ucIfAm2Aww==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	James Smart <james.smart@broadcom.com>,
	Dick Kennedy <dick.kennedy@broadcom.com>,
	"James E.J. Bottomley" <james.bottomley@hansenpartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Paul Ely <paul.ely@broadcom.com>,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com
Subject: Re: [PATCH 6.6.y] scsi: lpfc: Handle mailbox timeouts in lpfc_get_sfp_info
Date: Thu,  1 Oct 2026 09:52:18 -0400
Message-ID: <2026-09-30-1-daily-reply-0014-lpfc-sfp-info-mbox-timeout-6-6@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260930024505.96440-1-artem@trailofbits.com>
References: <20260930024505.96440-1-artem@trailofbits.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> [ Backport to 6.6.y: v6.6 predates ext_buf and uses ctx_buf for the SLI3
>   raw payload. Restore ctx_buf to the saved struct lpfc_dmabuf before
>   testing LPFC_MBX_WAKE so a timed-out mailbox's late default completion
>   sees the DMA descriptor rather than payload bytes. ]

This isn't safe on SLI3 HBAs. When the new 60s wait times out, ctx_buf
is pointed back at mpsave, a 40-byte struct lpfc_dmabuf, while
out_ext_byte_len is still 256. If the firmware completes between 60s and
the 300s mailbox timeout, the SLI3 interrupt handler copies those 256
bytes into the dmabuf. That is a slab overflow, and lpfc_mbuf_free() then
runs on the corrupted virt/phys.

-- 
Thanks,
Sasha
