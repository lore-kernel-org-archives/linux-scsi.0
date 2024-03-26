Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087941E481;
	Tue, 26 Mar 2024 06:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711435031; cv=none; b=H8nxL0IxD7q4qaxywD8ryqD//a8xyW9VIuM+OHUzKemRTo73sWSd3JhKK+5v38FsQIavDPNY+Wk4csY1vC2kaVUE6zV+LTX6El01ErXYO+2v5KeZcvMFcBlDAAcLl5LiRZLPnQZtJGbG/t39n4iHhPWi1Alp1/bZisLEOurOZQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711435031; c=relaxed/simple;
	bh=3JP1CqEqApwltEmbjWTFsr0gBD3EFkWz9YuXIANfkSk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n7M5CJRH+1bs/7o1MFVtv0/DoXGr8WcPw9pq0FZ6xPLlMye1SsI14an9WcjOT9B4j3tYYQRDiIc+iT+eeF4iJCbP/o4HFBVkGhUaedqeaPbUVP8t2yO32g3OgqYiI+1Gk+6liX3XYp7GOiVBmWH+gmOM4q42jc7wjyH7jxc1y50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1F35868D37; Tue, 26 Mar 2024 07:37:05 +0100 (CET)
Date: Tue, 26 Mar 2024 07:37:05 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 03/28] block: Introduce blk_zone_update_request_bio()
Message-ID: <20240326063705.GA7696@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org> <20240325044452.3125418-4-dlemoal@kernel.org> <20a3af4a-3075-4abc-8378-d55ea84a5893@acm.org> <0d3d0d81-66e0-4c7c-82dd-024972946666@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d3d0d81-66e0-4c7c-82dd-024972946666@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Mar 26, 2024 at 08:23:19AM +0900, Damien Le Moal wrote:
> REQ_OP_ZONE_APPEND + RQF_FLUSH_SEQ is not something supported, and this patch
> series is not changing that. The reason is that the flush machinery is not
> zone-append aware and will break if such request is issued for a device that
> does not support fua. We probably should check for this, but that is not
> something for this series to do and should be a separate fix.

Btw, I don't think we're even catching this right now.  Would be great
to have a submission path check for it.

