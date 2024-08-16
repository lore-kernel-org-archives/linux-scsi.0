Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD4954645;
	Fri, 16 Aug 2024 08:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723795570; cv=none; b=Q1YblVfcTt0b0NC3ZibjLbdQcbN/GNAfbWiQ8dbx1veV7SeCB5YBn1BVaC1g4zJrEKyESjqOipMZe4ylfcESH1pPs2TBl75KjdRuUfd2rLXNznpayLOfgRgjhleMfb9+Va+4vgfi7iDuHPZjpSGYkMgTDtFljH26wj5Wq8ndXz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723795570; c=relaxed/simple;
	bh=hgdxFFy0q5k/ccA38yLeF8xfJUMeCXr+VYFt7vzRdgE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=amMJq18yZwfGLMXo5AKiYKqdv++DZiAzMGdgz1IgfSy6yCd3v4GPU0x2WbG6RTu8sYHfF9G9Xbfeg4Qv6ns1rlHdmHZuXj35Mb6BjDmq0JYV7S5jwZqzTd5WiQqBnEaAsyYq1c8rsonP2KIKd4NZ/lo9+kSdch1mTE/H2KCNjgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4DCC0227A87; Fri, 16 Aug 2024 10:06:04 +0200 (CEST)
Date: Fri, 16 Aug 2024 10:06:04 +0200
From: hch <hch@lst.de>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Chris Bainbridge <chris.bainbridge@gmail.com>,
	"fengli@smartx.com" <fengli@smartx.com>, hch <hch@lst.de>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION] critical target error, bisected
Message-ID: <20240816080604.GA7249@lst.de>
References: <Zrog4DYXrirhJE7P@debian.local> <yq1ikw1qg49.fsf@ca-mkp.ca.oracle.com> <whnt3t5fqae5pujt6fkg5xu6mqxc2x5llbmq6q2lclfuuafbqx@tzj3dzgb7ury>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <whnt3t5fqae5pujt6fkg5xu6mqxc2x5llbmq6q2lclfuuafbqx@tzj3dzgb7ury>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Aug 16, 2024 at 07:59:52AM +0000, Shinichiro Kawasaki wrote:
> I also observed a different but similar failure symptom when I ran f2fs workload
> using a zoned TCMU device. I found that the trigger is the commit f874d7210d88
> ("scsi: sd: Keep the discard mode stable") that Chris found. After the commit,
> the device has unexpected non-zero values for the sysfs attributes
> queue/discard_max_bytes and queue/discard_max_hw_bytes. I found that Martin's
> fix avoids my failure symptom also. With the fix, the failure disappeared and
> the sysfs attribute have the expected value 0. Thanks!

Btw, zoned devices in all relevant standards can support discards,
despite it being rather pointless.  So we'll probably want to fix up
f2fs to handle that case correctly and not issue discards just to be on
the safe side.

