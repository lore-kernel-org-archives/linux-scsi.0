Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B510F1442E8
	for <linux-scsi@vger.kernel.org>; Fri,  9 May 2025 01:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746755591; cv=none; b=JtLCh35ms7nqRjQaeYs2C81EbtcpuSe/w2CI6syRe53/iSdg9/CdRIr+Zog8Hp+tt2nx85kyF06mqEBSLxPbHlabpBapDbDspkkQozk5Htxg6S3iD7D40gWmhRLfSy8DfI2sWqlQJTtPcrhmm8yxpS4opprXDJC4Z2Ai0h+smmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746755591; c=relaxed/simple;
	bh=W0277QswbfWZl9S8ljC9qBK1GXArubsUaBeDAu81Sfk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=slekTLXxEL04tq/jKDztF4yyxClsfD1A12bZShJWOW+AbS7js9ybXtqlQVqPrN7bpnBD016+ZL+v92Bh8L0eR2frbepXjZqBNCx0E9WthMqJukznAIutytR1gOWkZEceTFyPBdY244nDNbI6wUTL4l3coRVmzzFu5f5OElQMl2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OEC33M8W; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OEC33M8W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746755588;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W0277QswbfWZl9S8ljC9qBK1GXArubsUaBeDAu81Sfk=;
	b=OEC33M8WjTkUNeIw+PcXGuzfY7LcAI1iJjAfEzb2KOo6gPeLbPdRvElv87lkHI/nUjS7uy
	7uLlEFaZcdqZs77BINvf+Ou5DO25zV9u/DmkrTtSIhxf7uyGtx+3N373f+GllNCYyxrMJf
	nYsZATUSrltGaAYKuEobe7IWwAqIwJU=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-503-LMT1uKaJM52iJgrwLH1oEw-1; Thu,
 08 May 2025 21:53:03 -0400
X-MC-Unique: LMT1uKaJM52iJgrwLH1oEw-1
X-Mimecast-MFC-AGG-ID: LMT1uKaJM52iJgrwLH1oEw_1746755581
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E6632195608A;
	Fri,  9 May 2025 01:53:00 +0000 (UTC)
Received: from fedora (unknown [10.72.116.120])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C6DE719560B3;
	Fri,  9 May 2025 01:52:48 +0000 (UTC)
Date: Fri, 9 May 2025 09:52:43 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Daniel Wagner <wagi@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Costa Shulyupin <costa.shul@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Waiman Long <llong@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org, storagedev@microchip.com,
	virtualization@lists.linux.dev,
	GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH v6 5/9] virtio: blk/scsi: use block layer helpers to
 calculate num of queues
Message-ID: <aB1f67PPDlxlXXpa@fedora>
References: <20250424-isolcpus-io-queues-v6-0-9a53a870ca1f@kernel.org>
 <20250424-isolcpus-io-queues-v6-5-9a53a870ca1f@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250424-isolcpus-io-queues-v6-5-9a53a870ca1f@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Thu, Apr 24, 2025 at 08:19:44PM +0200, Daniel Wagner wrote:
> Multiqueue devices should only allocate queues for the housekeeping CPUs
> when isolcpus=io_queue is set. This avoids that the isolated CPUs get
> disturbed with OS workload.

With commit log fixed:

Reviewed-by: Ming Lei <ming.lei@redhat.com>

thanks,
Ming

