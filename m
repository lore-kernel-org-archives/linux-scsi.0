Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436CA1DC1A7;
	Mon,  6 Jan 2025 10:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736161060; cv=none; b=KLPZ6KEZPdBKER6+3NOcmMcbE23CJYIEaMnvSwSgejvXuEMlxAGqldlveKCJaIZDX0ZHKtQf5qdBzrbWr7WIeT6tDuQ/0Vdf6YuiPJdHEIZqFsfmdts87GnYYhPJnKsH1DDhQdAkx1DRp1BHFFyVcRd6eO4sp4uwkz9JV3DRI7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736161060; c=relaxed/simple;
	bh=PE4GcSKp0lUdDqbIfdbZcJExRHuMRvf9+YtveZDL1nE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bxdOI5vSp/W4usjs4nYbjBuNsUt/VCUwylrprm72nuaE7Oq1Ow1mIouGC8ogVQs3sNjn2PwEjgsUoeOkibbWrn7gM3XjoifKlm8P2yGFi+wz+4ll+x9xC/UzMdLqbXF9eoE3UtfUZwtl6k9c/kAvgwt6mvp05q6uQY5QKGkCC6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7D08D68C7B; Mon,  6 Jan 2025 11:57:32 +0100 (CET)
Date: Mon, 6 Jan 2025 11:57:32 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Ming Lei <ming.lei@redhat.com>, Nilay Shroff <nilay@linux.ibm.com>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	nbd@other.debian.org, virtualization@lists.linux.dev,
	linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 03/10] block: add a store_limit operations for sysfs
 entries
Message-ID: <20250106105732.GA21833@lst.de>
References: <20250106100645.850445-1-hch@lst.de> <20250106100645.850445-4-hch@lst.de> <a461bbbc-f251-4f44-89c7-f80f72e6e96d@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a461bbbc-f251-4f44-89c7-f80f72e6e96d@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jan 06, 2025 at 07:46:19PM +0900, Damien Le Moal wrote:
> The freeze must NOT be done for the "if (entry->store_limit)" case. So this
> needs to go int the "else". Otherwise, you still have freeze the take limit
> lock order which can cause the ABBA deadlocks in SCSI sd.

That is fixed in the next patch.  This one is pure refactoring without
behavior change.

