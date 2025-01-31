Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787E016D9AF;
	Fri, 31 Jan 2025 12:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738325038; cv=none; b=ZdGE/+THETZUQmf5SQceY8q5MuGP0NYkbktuOKTXd/5fsGeMxinBLCpVUTOATIV+QB96YaUIkbfryCUICezpODVE+yurxkEp5FtTkMG5b6lQ6xJzCpOaEqRQMxYXm/BX0DJhZfzcDY7WmxcvNhRLyKNTRG7aCR637+8AulDLPlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738325038; c=relaxed/simple;
	bh=mVi0deADAwcDNYI3QfXssaRNdGjLt/FAKADsDbHcjss=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZML0oHV4Q4f5fIsmUEhl8C90X7lfiSgG50tyG5GyI+qLq9Q5meJiCXS7K4Sa4qFnF5GCstpvfVuW3d88qfMvOssoL3ovHt34EzpZgJ28CUA2PBQ+vyaEQsmXcQPo+XYkrSuBZLyUUbBvwIPJd/h3VdStRRlfGcIfAw/JTjuYuOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xNANpsRD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xNANpsRD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=toZkHOKmtEQt0GILvsU2MdLlyWFdCCeeIMu36shQMpg=; b=xNANpsRDy4fiZw8pcI16S3+fpM
	6U6jX0NI7J3vpA0NhfR9ZB6QjLTDTL+60gmHAQXSw44p2lbIGrbNxOH1GsYyhOVeEBl5THc0v0YGa
	rGJSw0oFI3veIC2GXzZiyDDJchZR30izNN6JL8nkbFly4ZG28B5vy+6dAg21iaRtDgsADrh94Hwn0
	aWDy6DV85yVPjjIM4hdKVfMin0MCT7ILFQEL8LQdWELNswPQ5+bhpRxw1SGdvSPv8lJsNjP6gXsX9
	OC+IAuP069jTa5MiQi3OtPd4A3QIKtX5Ymn1QfVYvzsX1GCiZVkrvHtdT/t+VlTo94A240kjY4PP5
	L3apPL2Q==;
Received: from 2a02-8389-2341-5b80-85a0-dd45-e939-a129.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:85a0:dd45:e939:a129] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tdpkY-0000000AZLj-3pum;
	Fri, 31 Jan 2025 12:03:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>,
	linux-block@vger.kernel.org,
	nbd@other.debian.org,
	ceph-devel@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-mtd@lists.infradead.org,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org
Subject: annotate noio context v2
Date: Fri, 31 Jan 2025 13:03:46 +0100
Message-ID: <20250131120352.1315351-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

based on the reports from lockdep annotating q_usage_count it became
clear that we need to do noio allocations in a lot more place.  This
patch takes care of ensuring allocations with a frozen queue are
done using the noio flag to avoid deadlocks.

Changes since v1:
 - drop the loop patch that isn't needed
