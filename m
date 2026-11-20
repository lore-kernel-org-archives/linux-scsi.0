Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795196174;
	b=5Bjk13NpGmRA9kIQIDP2Lpm76VC97C5xdqspJdsVghHTXg/3zkbnfQXUQIGEzt4Qdcgx
	 QK1PQYiw1xGRfysPOinLdTrjOzjLp9ud8t1mG5tCWiJ1wc/ahb0fI1VZ9h7BIg46QK+MZ
	 iXAs/LSLiRm9aNs7UL3tn0BXUSWbpFcZlCxg37plKfDgygQ6O8CxljmojLmyTZtZvtDc+
	 G3fBK5mhcl6h8vpScaoHXdthPSy7omnOedEfSIwxcqBydh/TK/+ELssMLztFECo8irOQg
	 MCKsMQfiGnVDh3SZ5OcPgqT1DYK5wQ3U6jJlhztEDlnHLS6+PjyF5mxDN4jWBu0Y+Lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795196174;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=t4j1ly3WXNfJQPBQkg0nca5cmccxbwv2XIZiekcyGPI=;
	b=VrmNKwq8xksz3y23uk4T3SyqHAbZbS8zBk1p+/08JHV2QVz/PJP/04Ktt6ysnFMfxHWK
	 1/Z6Dex5tSBb/s6jESJYd39urPyIxbNvw6Q0lWfS/00+5MJI1WA5LHQMUzNQAhNN1wYXs
	 mfFaQ5ZlPB7GJoDqps6bKxhxJIpILwdBMXYI+D4TMIFzTSIta5V6z6VilC1dxbkn96s56
	 0dBtkETamd36XSzmaOwm+IPCPrK2NjoP0rcmDJx8hmmuReXDPA6mHwGB+nGxn3h6lGn8K
	 O5iwKh5OoIWRXcGgOEEjNTykIQOdcjekmNsGLlz+KxY1R33QDKQ7qtnAAHeR/ViI5Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777BE60A2621;
	Fri, 20 Nov 2026 17:36:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 777BE60A2621
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EA7B36732A; Fri, 20 Nov 2026 18:36:09 +0100 (CET)
Date: Fri, 20 Nov 2026 18:36:09 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v11 08/13] zloop: add storage element emulation
Message-ID: <20261120173609.GA1206@lst.de>
References: <20261116213702.225970-1-dlemoal@kernel.org> <20261116213702.225970-9-dlemoal@kernel.org> <20261120152038.GB26913@lst.de> <ac126584-6fa3-4cdb-b6c3-ec99f75dafff@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac126584-6fa3-4cdb-b6c3-ec99f75dafff@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Nov 20, 2026 at 09:27:15AM -0800, Damien Le Moal wrote:
> On 11/20/26 07:20, Christoph Hellwig wrote:
> > I think the Sashiko comment here needs adressing - nothing in the remove
> > path synchronizes against the raw underlying device access.  Lifting the
> > stor_elements_lock critical section from zloop_forget_cache to the
> > caller and making it unconditional should fix that.
> 
> I do not think that is enough because remove and restore drop the stor lock for
> the msleep. So this would still be very racy. But adding a disk ref get/put
> around remove/restore code should solve all issues cleanly as that will prevent
> the drive being removed while these operations are on-going.

The disk is already opened and references, that is not the problem.
The problem is that after del_gendisk, another disk with the same name
could show up and use the same files.  So we do not some kind of
synchornization to ensure that del_gendisk doesn't happen while a depop
is in progress.

