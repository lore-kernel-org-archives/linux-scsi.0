Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C22255930C
	for <linux-scsi@vger.kernel.org>; Tue,  8 Sep 2026 14:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788878195; cv=none; b=JCohCxgiilbdvoTrpPD1spuopdGpI5kLljXfmVqo/NA/B13yjNtnOoYHFcSjvULcvKR9vVR+aluGaCdnjpEoYjIB/okDoiSu3fHvm9rBM7vNteTrJjcrlGIXZ0f+E/yqRhfaFioSAB6ZyVHG6xF2eBhUNdY3Evr9KEPmbnMhZRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788878195; c=relaxed/simple;
	bh=uCQv/JPbj2UAl1fUOP3Qo2PfyF9548XXIZUCrJEouDg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=MzzpKfVbOdYvL5LoX7kYPlfDlgnOaZaSuRA0F3vpiIzQwfl0xIRYr0kAuns0RBNP4AB6DyA+IR3p44RYeAANtezWWdDTL15XsPFInsBZQ2CPoN4wd579/GavCXXwLhaSHqd/1NvydrBr5j1WsU/bjemxw8amoc5ZcV8/XihiUh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=P+rH3BBQ; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="P+rH3BBQ"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260908143617epoutp0273e692819d4601dc9057b57f11ea46ce~TXzlpPi_m0558605586epoutp02M
	for <linux-scsi@vger.kernel.org>; Tue,  8 Sep 2026 14:36:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260908143617epoutp0273e692819d4601dc9057b57f11ea46ce~TXzlpPi_m0558605586epoutp02M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1788878177;
	bh=x5eQ4QWvTQMMsZQPhCLPBfxlH4gL0gok2xTNYH4eMJE=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=P+rH3BBQ52QQcZUTvB2qERaSxfdVos6YczXTSEROpmQR8uAYSpjLrN2eKFtxIVkdv
	 /xBcMzcEci/o9+n1SxZgrCxgGnoScKpiFQ3KOCvLtTMx9CfFbVie3iJasXePJg1C60
	 Jg2ScVdNWxySEL7ED9MQih2UVakvmgH3c2Mu4Ysg=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260908143616epcas5p450e3cbd323cf9f442386b3e09f16bf0c~TXzk0_xXj2415024150epcas5p4I;
	Tue,  8 Sep 2026 14:36:16 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.87]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4hfRMM49Yfz6B9m4; Tue,  8 Sep
	2026 14:36:15 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260908143615epcas5p494e0e1c946cc898dc276b444e2dabd4d~TXzjwbXaM1445514455epcas5p4c;
	Tue,  8 Sep 2026 14:36:15 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260908143614epsmtip2bff5a6122f5cb969c39203afff00ee28~TXzitZ0wX1706617066epsmtip27;
	Tue,  8 Sep 2026 14:36:13 +0000 (GMT)
Message-ID: <bf8ef20b-44ea-42ca-9629-fe75056491bc@samsung.com>
Date: Tue, 8 Sep 2026 20:06:12 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] generic: test corruption detection using T10
 protection information
To: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Anuj Gupta <anuj20.g@samsung.com>, John Garry
	<john.g.garry@oracle.com>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-scsi@vger.kernel.org
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20260907075822.749818-7-hch@lst.de>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260908143615epcas5p494e0e1c946cc898dc276b444e2dabd4d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260907075913epcas5p424ad3a711f971e1664c112eea4ba34bc
References: <20260907075822.749818-1-hch@lst.de>
	<CGME20260907075913epcas5p424ad3a711f971e1664c112eea4ba34bc@epcas5p4.samsung.com>
	<20260907075822.749818-7-hch@lst.de>

On 9/7/2026 1:28 PM, Christoph Hellwig wrote:
> +	local phys_sector=$(_get_file_extent_sector $testfile 0)
> +	if [ -z "$phys_sector" ]; then
> +		_fail "$test_name: failed to get physical block offset via fiemap"
> +	fi
> +
> +	local dev=$(_short_dev $SCSI_DEBUG_DEV)
> +	local debugfs_dir=$(ls/sys/block/$dev/device/scsi_device/)
> +	local debugfs_file="/sys/kernel/debug/scsi_debug/$debugfs_dir/corrupt"
> +
> +	if [ ! -f "$debugfs_file" ]; then
> +		_notrun "scsi_debug corruption injection not supported"
> +	fi
> +
> +	if [ "$last" -eq 1 ]; then
> +		echo "adding to $phys_sector" >> $seqres.full
> +		phys_blk=$((phys_blk + (128 * blksz / 512) - 1))

Maybe you want this to be phys_sector and not phys_blk.
