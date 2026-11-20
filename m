Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795188042;
	b=w2RbRoZcYG7fICDA7B3BtGuC11OUJaxTLrNtTbMk/jMdtLAR1VjJAu0G7B7othtqbbLn
	 SVHfSxF7u/dZwmDgvZKavK2CHujlrE0p3oV4O78xotDlaU2Haz8jO4maJG0e6wcRVIPDz
	 Ktve6hGyl9nwGZJB4CKLNUs/slsg7GOfXpQ1/KYcZwsS69JSOJ50QgpFiniYBqqumDu0a
	 qYYALGtBaAwEbq6b+YTanXEpllvxK89N9kMb2ITQAEDgJPXLPvSPYF0tMn6vnzzM2R/NQ
	 MZ6oow+1dJjKvXV9/vH+TRlqVCyC4XkEhOLIq3UV7JXPszhmWt7lFqx9VkhpPZBEtCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795188042;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=VyDeYjf+ZT55SYLBrzNZoctCggOCvUT9sqW1aDnzDs0=;
	b=5Bp+t3c2qam/EJ5otvjVrVmQnomXOnE16kaupVfi8syKsu8FZ5nv+wOOJqqhKN0VOhbG
	 h3FNCBrACioeSP4o0bolg8mZ2p6PwWdwgyqiMaBjWPdYcA/ScMGm14laJeItD6Wqms1EW
	 Y4o1jtx1ND8r6aT5PRlCFwoyB7SjbrAbYEeg0C1PD47qm5weZgvdYYKz8w47Lv+BPoaOS
	 ATunysavZw7Qn6J450LF9CfV4f1/RFgStrq4vExc7O1bUxixEzQnvr4n5uBZwoqt/jKYV
	 c58lXYRb22YoDAsIlguxHZTiHHguINxkCAWR2N1ME8pcb4nh3nMTKRbbAT/FmCKVTSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5682606A325;
	Fri, 20 Nov 2026 15:20:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5682606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C18F56732A; Fri, 20 Nov 2026 16:20:38 +0100 (CET)
Date: Fri, 20 Nov 2026 16:20:38 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v11 08/13] zloop: add storage element emulation
Message-ID: <20261120152038.GB26913@lst.de>
References: <20261116213702.225970-1-dlemoal@kernel.org> <20261116213702.225970-9-dlemoal@kernel.org>
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
In-Reply-To: <20261116213702.225970-9-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

I think the Sashiko comment here needs adressing - nothing in the remove
path synchronizes against the raw underlying device access.  Lifting the
stor_elements_lock critical section from zloop_forget_cache to the
caller and making it unconditional should fix that.

Otherwise this looks good.

