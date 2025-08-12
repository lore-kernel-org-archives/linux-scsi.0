Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22C32E1C64
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2025 08:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754987295; cv=none; b=o8XWq+0DbrNpxOWsYppRiWPsxoPUxsektPP1sLxH+3/r9SNYupWVlyrWTLiKqCI4ppuJ/i/ZI3mwxaKU5DYeDwJgHOEHFVvoz7b9giwvuMNNGXljGA2NUlJSc0B36JC3SH9knw9ZPagHni3LEO1So9NVqiW7JkbmO+gbG4eyYkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754987295; c=relaxed/simple;
	bh=z0SgSvYoYu7N35u90QqnlmTuH/5fgRfZgq+2L+JKwb8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QYrKVcO497893LFFygPK+aY6N2S9drDogC5Q4pQppYS/lUOrQdzI/qJxk6ELtTl3bJeORVvWbR+BS8+SZauOZ+G/CV+oq8IcdjJRJxyXYxuzhxlMp5PCfucPpM9XfvLMRAMZEKUtJRQ4ecJc6k9e1EmcoHJBoZHaDEEUgN6wD4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zxYiAetO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zxYiAetO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=EKInauVAR3RVMTnBCTEx2FpXEBabKlEdSV908qH3xtE=; b=zxYiAetOjwUcIpLWcJ95ma3L7v
	L/Ks7soOUAJ8Ov3aBAsGNBgtbMHah1UAS0u8farwqgUimLZ2velD6Yrd4sp2BrnXBixfHsQSdhmHv
	6YwmrmJ7lZumMDEO/06zGU8+tvAO5/70a0f7D/R8CYfwEQ0HBsYv2ZzHK1C1Iw2Eo+P0lnFltXgdx
	NikFQbiXUfm2F7M0M4lglJRERuaJy72aUmFQ28pdydF84eXUpiHfnE/Ah211xRc2sY7+kQekVeFp6
	nX/J7mrVQA+XK5oe963c18P3vT4/xn6ryRKn0y3imlJk7klk1jW8N4bJBfcsMo8IFbUsG6T/AYtEW
	Ui0PKVUw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ulkMe-0000000AF1x-3mU7;
	Tue, 12 Aug 2025 08:28:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: martin.petersen@oracle.com
Cc: satishkh@cisco.com,
	sebaddel@cisco.com,
	kartilak@cisco.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH] fnic: remove a useless struct mempool forward declaration
Date: Tue, 12 Aug 2025 10:28:05 +0200
Message-ID: <20250812082808.371119-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Struct mempool doesn't current exist, and thus also isn't used in fnic.h,
remove it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/fnic/fnic.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index c2fdc6553e62..1199d701c3f5 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -323,8 +323,6 @@ enum fnic_state {
 	FNIC_IN_ETH_TRANS_FC_MODE,
 };
 
-struct mempool;
-
 enum fnic_role_e {
 	FNIC_ROLE_FCP_INITIATOR = 0,
 };
-- 
2.47.2

