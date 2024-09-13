Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C361B12F5;
	Fri, 13 Sep 2024 03:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726199138; cv=none; b=loeJatSRWA3YTQs7cVjFjSrwY5bQH4X36cKM15pahu/7b6S1A7/AEW8EoxRKLQTzcvTgYQJ2WE3lMO04bh9ZnuLztoneAGbaYQBEnbW/7vlMqFdKp8zX6FDCVfyFs5ikF7maCfSQSYLDQRb1JSzBxbhB86rvemFUTKtKTWE7NWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726199138; c=relaxed/simple;
	bh=KRpuwJWBbYAlvGr9Q5A7BLOrcVJLsEoahnJiQ1lGqKc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OrFOl9IbNk5MGX3/gNZIDV7vMuVksP0O+QagkjzKNJ0FrEXbFCdRnPTxgFl8sjqgPR88BN76Bc/1PHxmglnKutilGTabYmHA0dThWCWucaiOsRzVu32vVf+5b5GbopESLUdLh8qj3l2X1mEjhiv9ZLGWeKKwv34Hm9yWxfyAj0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N85yMqF1; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N85yMqF1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726199135; x=1757735135;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KRpuwJWBbYAlvGr9Q5A7BLOrcVJLsEoahnJiQ1lGqKc=;
  b=N85yMqF1lAjBcm809t+KSd1Dk552o/84kCBs5AqLuR/A8hirdjYV8yrD
   yUwQyjTnGXsv3Z2gFQY5YtVaM6iLIZXH1rJVElhE13O3sg0JxDWWTeTUO
   ZN5O7jsRqcIlEKin94oXv7qB9z2EFacjMs+zI9AnIHfebVT6QLwbwHxr7
   IcngozKmpUdpx4FIVB4U7fPyWM7Y2GmxgCmFRUhVOrOoMtt+L6NoAls4G
   As+iidowZ7B/T1W7CD3/GBSOlwJSJXNnKBQ4yz7EmWUrWMVh4X/HD9k0u
   ZMXkZn2QKQLhCdjbl0z18a6hPCeG4OsHGytfujokaxwZ3yr00/BoiaqfV
   w==;
X-CSE-ConnectionGUID: n7+h7jGaQ9qDy6lDDKOq7g==
X-CSE-MsgGUID: 5qFIvRXdTYOgyCgckq8QfQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11193"; a="42597869"
X-IronPort-AV: E=Sophos;i="6.10,224,1719903600"; 
   d="scan'208";a="42597869"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2024 20:45:35 -0700
X-CSE-ConnectionGUID: XSPlTp1kTQqoy4tLSbvaTw==
X-CSE-MsgGUID: uiLyvUX0SS69Dhz9afnofQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,224,1719903600"; 
   d="scan'208";a="72521873"
Received: from lkp-server01.sh.intel.com (HELO 53e96f405c61) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 12 Sep 2024 20:45:32 -0700
Received: from kbuild by 53e96f405c61 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1soxFS-0005yM-0r;
	Fri, 13 Sep 2024 03:45:30 +0000
Date: Fri, 13 Sep 2024 11:45:06 +0800
From: kernel test robot <lkp@intel.com>
To: Keith Busch <kbusch@meta.com>, axboe@kernel.dk, hch@lst.de,
	martin.petersen@oracle.com, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	sagi@grimberg.me
Cc: oe-kbuild-all@lists.linux.dev, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv4 10/10] blk-integrity: improved sg segment mapping
Message-ID: <202409131138.fuzBKPCG-lkp@intel.com>
References: <20240911201240.3982856-11-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240911201240.3982856-11-kbusch@meta.com>

Hi Keith,

kernel test robot noticed the following build warnings:

[auto build test WARNING on axboe-block/for-next]
[also build test WARNING on next-20240912]
[cannot apply to mkp-scsi/for-next jejb-scsi/for-next linus/master v6.11-rc7]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Keith-Busch/blk-mq-unconditional-nr_integrity_segments/20240912-041504
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
patch link:    https://lore.kernel.org/r/20240911201240.3982856-11-kbusch%40meta.com
patch subject: [PATCHv4 10/10] blk-integrity: improved sg segment mapping
config: openrisc-randconfig-r072-20240913 (https://download.01.org/0day-ci/archive/20240913/202409131138.fuzBKPCG-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 14.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240913/202409131138.fuzBKPCG-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202409131138.fuzBKPCG-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> block/blk-integrity.c:69: warning: Function parameter or struct member 'rq' not described in 'blk_rq_map_integrity_sg'
>> block/blk-integrity.c:69: warning: Excess function parameter 'q' description in 'blk_rq_map_integrity_sg'
>> block/blk-integrity.c:69: warning: Excess function parameter 'bio' description in 'blk_rq_map_integrity_sg'


vim +69 block/blk-integrity.c

7ba1ba12eeef0a Martin K. Petersen 2008-06-30   56  
7ba1ba12eeef0a Martin K. Petersen 2008-06-30   57  /**
7ba1ba12eeef0a Martin K. Petersen 2008-06-30   58   * blk_rq_map_integrity_sg - Map integrity metadata into a scatterlist
13f05c8d8e98bb Martin K. Petersen 2010-09-10   59   * @q:		request queue
13f05c8d8e98bb Martin K. Petersen 2010-09-10   60   * @bio:	bio with integrity metadata attached
7ba1ba12eeef0a Martin K. Petersen 2008-06-30   61   * @sglist:	target scatterlist
7ba1ba12eeef0a Martin K. Petersen 2008-06-30   62   *
7ba1ba12eeef0a Martin K. Petersen 2008-06-30   63   * Description: Map the integrity vectors in request into a
7ba1ba12eeef0a Martin K. Petersen 2008-06-30   64   * scatterlist.  The scatterlist must be big enough to hold all
19f67fc3c069b6 Keith Busch        2024-09-11   65   * elements.  I.e. sized using blk_rq_count_integrity_sg() or
19f67fc3c069b6 Keith Busch        2024-09-11   66   * rq->nr_integrity_segments.
7ba1ba12eeef0a Martin K. Petersen 2008-06-30   67   */
19f67fc3c069b6 Keith Busch        2024-09-11   68  int blk_rq_map_integrity_sg(struct request *rq, struct scatterlist *sglist)
7ba1ba12eeef0a Martin K. Petersen 2008-06-30  @69  {
d57a5f7c6605f1 Kent Overstreet    2013-11-23   70  	struct bio_vec iv, ivprv = { NULL };
19f67fc3c069b6 Keith Busch        2024-09-11   71  	struct request_queue *q = rq->q;
13f05c8d8e98bb Martin K. Petersen 2010-09-10   72  	struct scatterlist *sg = NULL;
19f67fc3c069b6 Keith Busch        2024-09-11   73  	struct bio *bio = rq->bio;
13f05c8d8e98bb Martin K. Petersen 2010-09-10   74  	unsigned int segments = 0;
d57a5f7c6605f1 Kent Overstreet    2013-11-23   75  	struct bvec_iter iter;
d57a5f7c6605f1 Kent Overstreet    2013-11-23   76  	int prev = 0;
7ba1ba12eeef0a Martin K. Petersen 2008-06-30   77  
d57a5f7c6605f1 Kent Overstreet    2013-11-23   78  	bio_for_each_integrity_vec(iv, bio, iter) {
d57a5f7c6605f1 Kent Overstreet    2013-11-23   79  		if (prev) {
3dccdae54fe836 Christoph Hellwig  2018-09-24   80  			if (!biovec_phys_mergeable(q, &ivprv, &iv))
7ba1ba12eeef0a Martin K. Petersen 2008-06-30   81  				goto new_segment;
d57a5f7c6605f1 Kent Overstreet    2013-11-23   82  			if (sg->length + iv.bv_len > queue_max_segment_size(q))
13f05c8d8e98bb Martin K. Petersen 2010-09-10   83  				goto new_segment;
13f05c8d8e98bb Martin K. Petersen 2010-09-10   84  
d57a5f7c6605f1 Kent Overstreet    2013-11-23   85  			sg->length += iv.bv_len;
7ba1ba12eeef0a Martin K. Petersen 2008-06-30   86  		} else {
7ba1ba12eeef0a Martin K. Petersen 2008-06-30   87  new_segment:
7ba1ba12eeef0a Martin K. Petersen 2008-06-30   88  			if (!sg)
7ba1ba12eeef0a Martin K. Petersen 2008-06-30   89  				sg = sglist;
7ba1ba12eeef0a Martin K. Petersen 2008-06-30   90  			else {
c8164d8931fdee Paolo Bonzini      2013-03-20   91  				sg_unmark_end(sg);
7ba1ba12eeef0a Martin K. Petersen 2008-06-30   92  				sg = sg_next(sg);
7ba1ba12eeef0a Martin K. Petersen 2008-06-30   93  			}
7ba1ba12eeef0a Martin K. Petersen 2008-06-30   94  
d57a5f7c6605f1 Kent Overstreet    2013-11-23   95  			sg_set_page(sg, iv.bv_page, iv.bv_len, iv.bv_offset);
7ba1ba12eeef0a Martin K. Petersen 2008-06-30   96  			segments++;
7ba1ba12eeef0a Martin K. Petersen 2008-06-30   97  		}
7ba1ba12eeef0a Martin K. Petersen 2008-06-30   98  
d57a5f7c6605f1 Kent Overstreet    2013-11-23   99  		prev = 1;
7ba1ba12eeef0a Martin K. Petersen 2008-06-30  100  		ivprv = iv;
7ba1ba12eeef0a Martin K. Petersen 2008-06-30  101  	}
7ba1ba12eeef0a Martin K. Petersen 2008-06-30  102  
7ba1ba12eeef0a Martin K. Petersen 2008-06-30  103  	if (sg)
7ba1ba12eeef0a Martin K. Petersen 2008-06-30  104  		sg_mark_end(sg);
7ba1ba12eeef0a Martin K. Petersen 2008-06-30  105  
19f67fc3c069b6 Keith Busch        2024-09-11  106  	/*
19f67fc3c069b6 Keith Busch        2024-09-11  107  	 * Something must have been wrong if the figured number of segment
19f67fc3c069b6 Keith Busch        2024-09-11  108  	 * is bigger than number of req's physical integrity segments
19f67fc3c069b6 Keith Busch        2024-09-11  109  	 */
19f67fc3c069b6 Keith Busch        2024-09-11  110  	BUG_ON(segments > blk_rq_nr_phys_segments(rq));
19f67fc3c069b6 Keith Busch        2024-09-11  111  	BUG_ON(segments > queue_max_integrity_segments(q));
7ba1ba12eeef0a Martin K. Petersen 2008-06-30  112  	return segments;
7ba1ba12eeef0a Martin K. Petersen 2008-06-30  113  }
7ba1ba12eeef0a Martin K. Petersen 2008-06-30  114  EXPORT_SYMBOL(blk_rq_map_integrity_sg);
7ba1ba12eeef0a Martin K. Petersen 2008-06-30  115  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
