Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE6B3E480;
	Thu, 28 Mar 2024 05:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711604818; cv=none; b=BwXso7h9DYw38CQNLoED+3SbZ5gcf0bjZF8qc8SMSSdtQUkXEeg3sHVFPsaznAbfKNp5lKIwfb9Mpy0u7FSduH7Pc+0mUaEIeW/imokwrC2Y0+vtww3wRstY+LTCo8J8Efry569q7ir3s1plYoFsjCXcYdcKt4tTE95K/KMhAIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711604818; c=relaxed/simple;
	bh=muMnSag/kuaHFWY1PHTvI0HMNN1AaoQyDfmrMpVSfu8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LpbBOSPLThO/e1PHkY7j8Pvz3VZAgYpDdwQr8CChNgIiRrN4BD8PUU7b3f/17+GjnaAzGgXoSIuJtEIq1FRj94s8ttzYVwK8WpxL3qA4eLF+MCMcnX3ZrQQyVHnDrde9GqbCcc5RzpQC9I96PrUx4xZKhZpiht3XL75X0ltVEN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6119C68B05; Thu, 28 Mar 2024 06:46:52 +0100 (CET)
Date: Thu, 28 Mar 2024 06:46:52 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH v3 09/30] block: Pre-allocate zone write plugs
Message-ID: <20240328054652.GA16237@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org> <20240328004409.594888-10-dlemoal@kernel.org> <20240328043016.GA13701@lst.de> <714d0cbc-be4d-4aa9-b200-73c6caaa1d18@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <714d0cbc-be4d-4aa9-b200-73c6caaa1d18@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 28, 2024 at 02:28:40PM +0900, Damien Le Moal wrote:
> That was my thinking initially as well, which is why I did not have the
> grace period. However, getting a reference on a plug is a not done under
> disk->zone_wplugs_lock and is thus racy, albeit with a super tiny time
> window: the hash table lookup may "see" a plug that has already been
> removed and has a refcount dropped to 0 already. The use of
> atomic_inc_not_zero() prevents us from trying to keep using that stale
> plug, but we *are* referencing it. So without the grace period, I think
> there is a risk (again, super tiny window) that we start reusing the
> plug, or kfree it while atomic_inc_not_zero() is executing...
> I am overthinking this ?

Well.  All the lookups fail (or should fail) when BLK_ZONE_WPLUG_UNHASHED
is set, probably even before even trying to grab a reference.  So all
the lookups for a zone that is beeing torn down will fail.  Now once
the actual final reference is dropped, we'll now need to clear
BLK_ZONE_WPLUG_UNHASHED and lookup can happe again.  We'd have a race
window there, but I guess we can plug it by checking for the right
zone number?  If we it while it already got reduce that'll still fail
the lookup.
