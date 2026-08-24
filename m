Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D5A359A6C;
	Mon, 24 Aug 2026 04:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787547544; cv=none; b=spjHKx9uwMOtGcOLY4pxOJEakPcswNgrcXATldy7+hiYafwP8vok1/Y9XRn0v1Pp3lUgD5eKg1mqGnnxCRMI0dsar4Q1sKmUvX0u4EQ1VNGtbF4zi3UxXhgRFPG4jMcHtdK6pCiUatogEwo/14eoKCPBUHBuFPg4C/91wh8xNLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787547544; c=relaxed/simple;
	bh=9oLWSp7kKnOtD0wQ+NSMQIQ1ykw9RBq+9NxF27U1v4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DpKSf5rhn7ZhwtemNt1vQ6pzfdiZVY0h7GreKhtX4LMswax3LY1EpP+tzrrHVx79ak4WFfpgAyEoUTWB/FijKVmSESp9cYSzkVZejkRzn/GMSLNJ5dopcv9Wmxn5HpqcKRaHUNN2yyz4lhqdnkJltOkbSPaMP1m1IoAeYwx/5hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AEB5068BFE; Mon, 24 Aug 2026 06:58:59 +0200 (CEST)
Date: Mon, 24 Aug 2026 06:58:59 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	fstests@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/5] common: add a _sysfs_block_integrity_path helper
Message-ID: <20260824045859.GB29550@lst.de>
References: <20260821051133.1817670-1-hch@lst.de> <20260821051133.1817670-3-hch@lst.de> <20260821232908.GE839663@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821232908.GE839663@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Aug 21, 2026 at 04:29:08PM -0700, Darrick J. Wong wrote:
> On Fri, Aug 21, 2026 at 07:11:27AM +0200, Christoph Hellwig wrote:
> > Add a helper function to find the sysfs integrity directory for a given
> > block device.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  common/rc | 25 +++++++++++++++++++++++++
> >  1 file changed, 25 insertions(+)
> > 
> > diff --git a/common/rc b/common/rc
> > index 02bdb31a76a6..61a899da3bd7 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -5257,6 +5257,31 @@ _sysfs_queue_path()
> >  	fi
> >  }
> >  
> > +# Get the sysfs block device integrity/ path for a block device, handling
> > +# partitions correctly.
> > +_sysfs_block_integrity_path()
> > +{
> > +	local dev parent
> > +	dev=$(_short_dev "$1")
> > +
> > +	# For partitions, integrity details are in the parent device's sysfs dir
> > +	if [ -e "/sys/class/block/$dev/partition" ]; then
> > +		parent=$(basename "$(readlink -f /sys/class/block/$dev/..)")
> > +	else
> > +		parent="$dev"
> > +	fi
> 
> I wonder if this part should get pulled out into a _sysfs_block_path
> helper, since the code is already in _sysfs_queue_path?

I guess.  It's not much code, but it is identical.

