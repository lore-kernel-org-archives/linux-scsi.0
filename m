Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE90F38A711;
	Mon,  7 Sep 2026 05:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788760132; cv=none; b=ghkVRiAuLiYhzRS38oVUX1PZFf+LeYTVJtHIB7EiSEdqIvenEdCdRcUfdOxTRWmE1ZTnd7wEQXtXO+rgsmPdPB9V6A3AvI4SJBvv4glf3J28+dsZ39WadBbK+iiaOPipxv55/oO+5vf2kvoG/hbRGQjR1YnlA6xUHJfYpCYZ24M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788760132; c=relaxed/simple;
	bh=04HejevVMX34Fluhb5ID4GDuQAgOAqs2zOo81wxpI3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jmSp8MNrX2W8984hB3nLnoM7ug3Tlt31/Bk0c131B5yvVoK7XCWLx1qkWDcdZ5UyIzJIZU44X5xKd3mqxGH1aiSoZnZ9QEn/HB0XujesLtNbaT1lCZje6nPQgaqMxOnDU9/xrM49u4jwQnAEquFpqTI51F5Ci8Q5aGvVHiue+AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 271DE68D05; Mon,  7 Sep 2026 07:48:47 +0200 (CEST)
Date: Mon, 7 Sep 2026 07:48:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	fstests@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 5/6] generic: test I/O on devices with T10 protection
 information
Message-ID: <20260907054846.GB31481@lst.de>
References: <20260831064557.2577241-1-hch@lst.de> <CGME20260831064632epcas5p4bc3e4268e46c28a70a5c6b36ee4d7b83@epcas5p4.samsung.com> <20260831064557.2577241-6-hch@lst.de> <bd707d1a-3af1-4d1d-b6da-ac676a9c666d@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd707d1a-3af1-4d1d-b6da-ac676a9c666d@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Sep 01, 2026 at 12:08:59PM +0530, Kanchan Joshi wrote:
> On 8/31/2026 12:15 PM, Christoph Hellwig wrote:
> > +test_dif()
> > +{
> > +	local pi_type=$1
> > +	local pi_enable="$2"
> > +
> > +	scsi_debug_pi_opts="write_same_length=0 dif=${pi_type} dix=1"
> > +	SCSI_DEBUG_DEV=`_get_scsi_debug_dev 512 512 0 $size $scsi_debug_pi_opts`
> > +
> > +	SCSI_DEBUG_MNT="$TEST_DIR/scsi_debug_$seq"
> > +	rm -rf $SCSI_DEBUG_MNT
> > +	mkdir $SCSI_DEBUG_MNT
> > +
> > +	_mkfs_dev $SCSI_DEBUG_DEV || \
> > +		_fail "Can't make $FSTYP on DIF-enabled scsi_debug device"
> > +	run_check _mount $SCSI_DEBUG_DEV $SCSI_DEBUG_MNT
> > +	bsize=$($here/src/min_dio_alignment $SCSI_DEBUG_MNT $SCSI_DEBUG_DEV)
> 
> bsize remains unused.

_run_fsx uses it through the (somewhat odd) BSIZE substitution.

> dio_opts is unused.

Yeah.

> 
> > +	fsx_run -N 10000            -l 500000 -r BSIZE -w BSIZE -Z -R -W
> 
> Is passing BSIZE correct?

See above :)
