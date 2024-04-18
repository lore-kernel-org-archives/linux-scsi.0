Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9218B15FA9F
	for <linux-scsi@vger.kernel.org>; Thu, 18 Apr 2024 14:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713451898; cv=none; b=ie4mtp8BYejbDSxGI9YnQ+k1hr8h0HXmq6h1rmR4WZ3diqjhVbtA2onY8DKJjoS/UyhFNudYX2U36bbGgIm3P0Hy+8WWGeAnebvswz+TWAKL+/UIG3pr4wnZcJ/3GvcGjpsXxnFl1Sa8cT8PIMjgWy1djk8lpQ731yzJoKlwTng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713451898; c=relaxed/simple;
	bh=QHN7K+OJp/cElN+N77LN+vultTNDJou+UzSDI2WnPVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GeJCxpO+ddkrUxg9K/cpPNr0du2UlIM7qhFKyc9aUzA7M1da0rxlfrNBDl41xScIceOnEesV+hDJ43WdtsB5LltTof/zWAVRMWsrmpl+WsP8KDVjYJuKsBKbd0Pt+8EXjqLyx0bknMSW/pw5iZA/hmOMBNTs0dfYNbpw5uiGQYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D0C8E68D05; Thu, 18 Apr 2024 16:51:29 +0200 (CEST)
Date: Thu, 18 Apr 2024 16:51:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	James Bottomley <james.bottomley@hansenpartnership.com>,
	linux-scsi@vger.kernel.org, Martin Wilck <martin.wilck@suse.com>
Subject: Re: [PATCH] scsi_lib: Align max_sectors to kb
Message-ID: <20240418145129.GA32025@lst.de>
References: <20240418070015.27781-1-hare@kernel.org> <20240418070304.GA26607@lst.de> <5707dfc3-f8e2-4050-9bba-029facc32ca9@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5707dfc3-f8e2-4050-9bba-029facc32ca9@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Apr 18, 2024 at 09:42:06AM +0200, Hannes Reinecke wrote:
> While this can be fixed in userspace (Martin Wilck provided a patchset
> to multipath-tools), what I find irritating is that we will always
> display the max_sectors setting in kb, even if the actual value is not
> kb aligned.

The problem you are running into it exactly a problem of pointlessly
inheriting the value when we should not.

Other secondary issues are that we:

 a) should allow the modification in the granularity that we actually
    internally use, that is sectors
 b) apparently some drivers still use the silly BLK_SAFE_MAX_SECTORS
    limits that is too low for just about any modern hardwre.

>> Note that we really should not stack max_sectors anyway, as it's only
>> used for splitting in the lower device to start with.
>
> If that's the case, why don't we inhibit the modification for max_sectors 
> on the lower devices?

Why would we?  It makes absolutly no sense to inherit these limits,
the lower device will split anyway which is very much the point of
the immutable bio_vec work.

