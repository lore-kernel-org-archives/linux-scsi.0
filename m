Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4A93C81B5
	for <linux-scsi@vger.kernel.org>; Wed, 19 Aug 2026 06:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787122735; cv=none; b=BgEoP757hByy/kj0SrLwORstflsB6OrW5Wwr7dvebFAJeyyrwEH22bNh7ZqKfPyhYqL3mLrKRWbv8h81fncsEuWTCJV8IpoIUoWUXT6fYOuxA0ua63F58YuZq6A54yqBe2ixjhJFqRp0PFD/c4p01tCd0scRZL9qrM5GdA0A4SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787122735; c=relaxed/simple;
	bh=RAdBuHlxGzBX+EqmAk35Z0H1pMUQsn8118359kTsrD8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RHLbueW4kTHcgOrUM4reU41BTuww07WTIwVxH68zLXCldnCt8dG7OtoEkj06IgB2QH3GvTuABXypwiT4j1t4qy6CYUE2WpGPHWCeq5CcZE1jpByMSEfrM5nTC3gAC0q416UjFsxvR0ZhU1yRz1RcnX21t9sNzv6Pmq5Ej0C/3Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZFrYhaCm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZFrYhaCm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=MMYPLILCLkBIU1tAm6h7jKO0yYOOUI8i0AZFSOrIRHA=; b=ZFrYhaCm4Zm1t82MIffXDbK6D2
	kRsKDSg7tX3ZPZWEoE1TwfxCZgeNQW8Br6+9wXg++tfTV1Ol1bnYhzTVtsK5IjJqT8+inIrdrfF0f
	yd3C3YQk0zLsuwlYav235uAXah5fhcxxfSo9MmeR94bgHh7jq1S0ZNUG+2Vs8o1liT8fU3ntcweUD
	RV7lzK32nr6hqvGwGKyH+/O9kkhbbL+MWXEwJWP3kNmFmpHxYsnLDMu3QjEw5rFz0g6uBeaEcg9IA
	r1X9hFHTJ7GPCzeet//BGmKDP9cGgfUfAeRcL3AfKZ+beyudByhHHcE5UwURSU87UmZ6j/2lV82kF
	0kuVN9+Q==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wwaGC-000000098uW-3fR2;
	Wed, 19 Aug 2026 06:58:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org
Subject: scsi_debug: add support to corrupt data and/or reftag v2
Date: Wed, 19 Aug 2026 08:58:44 +0200
Message-ID: <20260819065850.1358861-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This will be used for testing PI support in xfstests.

Changes since v1:
 - use match_int to parse the  reftag_adjust option
 - don't bypass error cleanup on parsing failure
 - allow to corrupt the entire capacity
 - set the bug_if_fake_rw to devip2sip to false
 - fix the check for unmapped LBAs
 - require DIX for reftag corruption injection
 - make the kernel messages a bit less verbose
 - add calls to sdeb_data_lock and sdeb_data_sector_lock
