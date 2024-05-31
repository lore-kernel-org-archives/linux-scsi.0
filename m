Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01F97BB12;
	Fri, 31 May 2024 05:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717134903; cv=none; b=skx/YAjQMNPlkG0NCoTA2XhzUIzPE05juRDDNn7b17nJM3Kp/UuX4RWX3GBl2oQdIBwOdFAZMUdMOPWl5QxN7dSgfezpIl81/IJk6utAwG4XtnREvHMl6lSbC+Zd/2NrE+CHSclVGdTlyQNbfLwc1kqtS+B3nFcMKMCdBpuO/xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717134903; c=relaxed/simple;
	bh=chPSGR/11YkWOFauxo+0E/vjNh8ogei45o7Ss1ekzEg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KT49w9xCol6VRcFR6QkEZsm4WsYdIT7dxZk+rYzGPQMRGlWAo4c02vUlSsdbfHmsMVyAJGtucRu03mCU8VI2Tt2OzqUfHzUM8SmZqKXHuiOCqSMyKipPtXsqdsLC1KNQ8IeetCcKLukvC69RZaSIiBeq4Kl/5g7Uz8RVEPd1eMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D3CD568BFE; Fri, 31 May 2024 07:54:56 +0200 (CEST)
Date: Fri, 31 May 2024 07:54:56 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	Roger Pau Monn?? <roger.pau@citrix.com>,
	linux-um@lists.infradead.org, linux-block@vger.kernel.org,
	nbd@other.debian.org, ceph-devel@vger.kernel.org,
	xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 02/12] block: take io_opt and io_min into account for
 max_sectors
Message-ID: <20240531055456.GC17396@lst.de>
References: <20240529050507.1392041-1-hch@lst.de> <20240529050507.1392041-3-hch@lst.de> <CAOi1vP-F0FO4WTnrEt7FC-uu2C8NTbejvJQQGdZqT475c2G1jA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOi1vP-F0FO4WTnrEt7FC-uu2C8NTbejvJQQGdZqT475c2G1jA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, May 30, 2024 at 09:48:06PM +0200, Ilya Dryomov wrote:
> For rbd, this change effectively lowers max_sectors from 4M to 64K or
> less and that is definitely not desirable.  From previous interactions
> with users we want max_sectors to match max_hw_sectors -- this has come
> up a quite a few times over the years.  Some people just aren't aware
> of the soft cap and the fact that it's adjustable and get frustrated
> over the time poured into debugging their iostat numbers for workloads
> that can send object (set) size I/Os.
> 
> Looking at the git history, we lowered io_opt from objset_bytes to
> opts->alloc_size in commit [1], but I guess io_opt was lowered just
> along for the ride.  What that commit was concerned with is really
> discard_granularity and to a smaller extent io_min.
> 
> How much difference does io_opt make in the real world?  If what rbd
> does stands in the way of a tree-wide cleanup, I would much rather bump
> io_opt back to objset_bytes (i.e. what max_user_sectors is currently
> set to).

The only existing in-kernel usage is to set the readahead size.
Based on your comments I seems like we should revert io_opt to
objset to ->alloc_size in a prep patch?

