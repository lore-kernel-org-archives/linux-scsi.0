Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54662136341;
	Fri, 15 Nov 2024 17:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731690571; cv=none; b=GcuPEO+oWt+CaHVjxGug+cbpHfZYU8MNv+eRVB/S6GadZ784EL1gex3Gp7v/lxNQFIxegd+TIAD7wcFXSaKbV80JpDbFVYO1+WMrv9rEycSffljWek3HPOAv/msHoNx1gp6uQ4mLKAFykPdv0jCdivPlpoT6iGsVI5LdbpMbAsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731690571; c=relaxed/simple;
	bh=vrXlIM1xscozSL3RqPFyS8UPkhzcID1hKEXIpaO1Oe8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dn2oVAYmyDnYZyeLhR6RXkWdRbwpSWAJiCJDK9vh4I/enU7krBstDAB64W0sqKZTeqM3iC8T/lI2kWV6Ar3UTbiNdYnvW4C+qRNykitGcuVBG4LIUcOb0LtN0d8G+F2Pr3msU7okkNmHlfgguWsxamlLSG/CooDuv9vSY1pbPIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 278A768D0A; Fri, 15 Nov 2024 18:09:25 +0100 (CET)
Date: Fri, 15 Nov 2024 18:09:24 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: John Meneghini <jmeneghi@redhat.com>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-scsi@vger.kernel.org,
	Chris Leech <cleech@redhat.com>, Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>, snitzer@kernel.org,
	Ming Lei <minlei@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Jonathan Brassow <jbrassow@redhat.com>,
	Ewan Milne <emilne@redhat.com>, bmarson@redhat.com,
	Jeff Moyer <jmoyer@redhat.com>,
	"spetrovi@redhat.com" <spetrovi@redhat.com>,
	Rob Evers <revers@redhat.com>
Subject: Re: DMMP request-queue vs. BiO
Message-ID: <20241115170924.GB23437@lst.de>
References: <2d5fe016-2941-43a4-8b7c-850b8ee1d6ce@redhat.com> <20241104073547.GA20614@lst.de> <d9733713-eb7b-4efa-ad6b-e6b41d1df93b@suse.de> <20241105103307.GA1385@lst.de> <643e61a8-b0cb-4c9d-831a-879aa86d888e@redhat.com> <41cf98c3-a1de-a740-01ad-53c86f3bc8a5@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41cf98c3-a1de-a740-01ad-53c86f3bc8a5@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Nov 15, 2024 at 03:05:21PM +0100, Mikulas Patocka wrote:
> Note, that if a database uses buffered block device, performance will be 
> suboptimal, because the buffering mechanism can't create large bios, it 
> only sends page-sized bios. But that is expected to not be used - the 
> database should either use a block device with direct I/O or a filesystem 
> with or without direct I/O.

And, as pointed out in the private mail that John forwarded to the list
without my permission if we really have a workload that cares md could
implement the plugging callback as done in md to operate on a batch
of bios.

Also not building large bios is not a fundamental property of block
device writes but because it uses the legacy buffered head helpers.
That means:

  a) the same is applicable to file systems using them as well
  b) can be fixed if someone cares enough, but apparently no one does

