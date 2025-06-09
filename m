Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0D5610D
	for <linux-scsi@vger.kernel.org>; Mon,  9 Jun 2025 05:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749448206; cv=none; b=QHsGDDTFvCI5KOZW0oCUR9vXr5bL4/Y/PyuDMt2PiWxE0BCetL75RTIhjav0t8kZ+R8/UbW1tZOJU1mVVg+fboOQl3OogX4WZ3HTqfUG2oZig6dJ4/XPu/TerQDBnUxZ4lTzLt3auoHcqmt9EdQDpkI1BQ7xfh+DayMhCBKeRAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749448206; c=relaxed/simple;
	bh=YpAglpdL3J3egNt22NaK9wLT2khpL3E3e+r3saEVViY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dwHckefX5nBoDWJn5hzqFh+2136MrWhdXgkxXkUIgWvVo/Pn4lF/25EFL28LtlkkSLs8z8c3FkekFNnPkI5NDqpt1m4Xdk0nWdX53wd3o8mR522yBbb+DZnJ6TjSn8yDd+1/HFU/ktFiLpwh6xeA7G0pmqaXWzTBrmOVE78ftu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IhaG7VGs; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IhaG7VGs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YpAglpdL3J3egNt22NaK9wLT2khpL3E3e+r3saEVViY=; b=IhaG7VGstOnwZFdTJOcCbQFp5s
	pYagDbiUU/jApnmBdZNsMW953asC2+vkKdJVEMDePJ1lvjxY2QWE5rkEm/ocIn46AKyBVCDus2H10
	4bQaALD0Lk1G5SlSm+YMI51Blxu/H1xoDLh5UPbuKn2LekSZBgryKYbO2JsYHz9H34RK0WOKhg6gV
	RzBGvr8SS4ZrtIGnD41vObW5gxr+MBKjK3YgZw2YNr99v8a9B7v6yuRquczb/psz/1RK6TeD8LByz
	Nm8ZLKBULisvH0cbKh5zzieCcLDW2vrg8CgpS5em59lmzR2SJmn3DYePo8j5dDCk2ec98ZKG5Vwa0
	Ebahw/Hw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uOVOV-00000003Tvd-4Aq7;
	Mon, 09 Jun 2025 05:50:03 +0000
Date: Sun, 8 Jun 2025 22:50:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com,
	laoar.shao@gmail.com
Subject: Re: [PATCH 0/2] Improve ATA NCQ command error in mpt3sas and mpi3mr
Message-ID: <aEZ2C93sEiFRzGEE@infradead.org>
References: <20250606052747.742998-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250606052747.742998-1-dlemoal@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Adding Yafang Shao <laoar.shao@gmail.com>, who has a test case, which
I think promted this.

Yafang, can you check if this makes the writeback errors you're seeing
go away?

