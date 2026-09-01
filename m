Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0707F2FD69E
	for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2026 06:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788244748; cv=none; b=Du1qXfoqsCKqYE7TPK1SmqQJAxSPcr6kBgRa9Q/02qb26iC4qwsMA0oMd0C34/09eYj7S1LavXcgWykipNbA85g8bEjRIqUuv4efofxIhr60QYFhu2kSglPdskmVDNOWzPql6X/Ajt4Zje0Q6rg4eP4r7Kj1d87qRqO4VSq0zCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788244748; c=relaxed/simple;
	bh=QaUJqixc5p56dJUuTFjnO21Y468gXDL1Pm8qwURtvEk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=glBh98IVGRBsKwVQByNJ03+03Ep86g4FHCpUNf5TW4GuZ0cgA9qFnMguZbhvDPqIOV9EyueQPUFwjk+Hwn9kMrGzfsGbizOUQjoxRUhrOkOkYpxrVDWOzUyGqMs7jQsPvFFQG1DsoTvrdOyUQRhLkqTA0pONSyrY1SrklowJiIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=d/92eRMA; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="d/92eRMA"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260901063903epoutp021ad9a6e054d0506add2726e2a3858cdf~RHx67qCAD1577715777epoutp02O
	for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2026 06:39:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260901063903epoutp021ad9a6e054d0506add2726e2a3858cdf~RHx67qCAD1577715777epoutp02O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1788244743;
	bh=1KBKRNb4Pg0waoBINnyrSkjLe0L4GFcJudbfyIlafDg=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=d/92eRMApv+2r08JfWjv0082xwOu9VQ4BVXdERKRmPM5OaJ3ZaInc6B/Cbu0pfAx4
	 7xEgKHaMw9dP7oJZBkexiyzKj0MpnwTQehgPFqmr68s8zfMLtZLxH/gZHLh4aYYQMp
	 SOB0iAHouojMWs6foMt9thbziMk01c5LP0Ezf3fE=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260901063903epcas5p1283fffbf631d1f6e400f2eabd979e885~RHx6VQke50893608936epcas5p1L;
	Tue,  1 Sep 2026 06:39:03 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.87]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4hYx5y3c8wz3hhT4; Tue,  1 Sep
	2026 06:39:02 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260901063901epcas5p16e676dcecbc321a446034c2499f0586e~RHx4_XH6j1062110621epcas5p15;
	Tue,  1 Sep 2026 06:39:01 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260901063900epsmtip1b58195720c1abcc3c80d601c13796c88~RHx3475Z20173201732epsmtip1i;
	Tue,  1 Sep 2026 06:39:00 +0000 (GMT)
Message-ID: <bd707d1a-3af1-4d1d-b6da-ac676a9c666d@samsung.com>
Date: Tue, 1 Sep 2026 12:08:59 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/6] generic: test I/O on devices with T10 protection
 information
To: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Anuj Gupta <anuj20.g@samsung.com>, John Garry
	<john.g.garry@oracle.com>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-scsi@vger.kernel.org
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20260831064557.2577241-6-hch@lst.de>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260901063901epcas5p16e676dcecbc321a446034c2499f0586e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260831064632epcas5p4bc3e4268e46c28a70a5c6b36ee4d7b83
References: <20260831064557.2577241-1-hch@lst.de>
	<CGME20260831064632epcas5p4bc3e4268e46c28a70a5c6b36ee4d7b83@epcas5p4.samsung.com>
	<20260831064557.2577241-6-hch@lst.de>

On 8/31/2026 12:15 PM, Christoph Hellwig wrote:
> +test_dif()
> +{
> +	local pi_type=$1
> +	local pi_enable="$2"
> +
> +	scsi_debug_pi_opts="write_same_length=0 dif=${pi_type} dix=1"
> +	SCSI_DEBUG_DEV=`_get_scsi_debug_dev 512 512 0 $size $scsi_debug_pi_opts`
> +
> +	SCSI_DEBUG_MNT="$TEST_DIR/scsi_debug_$seq"
> +	rm -rf $SCSI_DEBUG_MNT
> +	mkdir $SCSI_DEBUG_MNT
> +
> +	_mkfs_dev $SCSI_DEBUG_DEV || \
> +		_fail "Can't make $FSTYP on DIF-enabled scsi_debug device"
> +	run_check _mount $SCSI_DEBUG_DEV $SCSI_DEBUG_MNT
> +	bsize=$($here/src/min_dio_alignment $SCSI_DEBUG_MNT $SCSI_DEBUG_DEV)

bsize remains unused.

> +
> +	local integrity_path="$(_sysfs_block_integrity_path $SCSI_DEBUG_DEV)"
> +	echo $pi_enable > $integrity_path/read_verify
> +	echo $pi_enable > $integrity_path/write_generate

Can integrity_path be empty when CONFIG_BLK_DEV_INTEGRITY is off?> +
> +	# fsx load similar to generic/091
> +	echo "Testing direct I/O for DIF type $pi_type (enabled: $pi_enable)"
> +	local dio_opts="-r PSIZE -t BSIZE -w BSIZE"

dio_opts is unused.

> +	fsx_run -N 10000            -l 500000 -r BSIZE -w BSIZE -Z -R -W

Is passing BSIZE correct?

