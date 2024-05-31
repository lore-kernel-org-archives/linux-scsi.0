Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58AA6200B7
	for <linux-scsi@vger.kernel.org>; Fri, 31 May 2024 21:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717189532; cv=none; b=tRhyT2/qPjhBAibdrWirJinrvVyVoDzQ8jEDsLDMn7E0cswbtHB/frXGzsqYewocjU3YA0FW8Nhm3nQroPWKtHa24DYTgBsmNCvcbOMAstAXxVcW6FTgi6UWUE5VdgwcuMOGZv1fq4kwvvdcDIOwnbvEjqJJ+pRDMBgK6QTIbsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717189532; c=relaxed/simple;
	bh=9Kud6uzvuj0hnJN8KHr7WJrJqsGZFdiigr5ZDDXvWDU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=oXJ5Krjc8NhaOKybbTXo3FF40CHff9gtiAoAa/zLK+ujbw4WXH6iCzRq+R50nzqg7/Ri9SjOGri9vKRPU0gMnt9Qd6/+9CYm8wwqpudljEK4NWx4m6PKeqbwwzzY7aYz+hWaoqfyEZDTS9gBrXePmMElPiAa0RRcP3YY13cCPYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=f0AmkXmS; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="f0AmkXmS"
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240531210526epoutp01ca10dfd932c8e0aabe1a13d7b1541ac6~UrsbXpMWZ0726707267epoutp01R
	for <linux-scsi@vger.kernel.org>; Fri, 31 May 2024 21:05:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240531210526epoutp01ca10dfd932c8e0aabe1a13d7b1541ac6~UrsbXpMWZ0726707267epoutp01R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1717189527;
	bh=T/Yvi9n3cu2buoY4RtAZnVN2Z9u40bwEUvEisKol0Qw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=f0AmkXmSxE5BEPlJwpQH5rHrxjneBjPrYiCuUXhYqSe4X4fKFuBrVSFfKIkY/0hdO
	 +FjdFIUcnT7HGWI7Y4CKys0kpgZ4Pjntz/JV1jHhK6G+GkqSfrfOPMDMW9NEH3Z/ph
	 EefTTExjGOAni5DWcoHfdqg0At4SBjqa4kmSEnr0=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTP id
	20240531210526epcas2p136b08261a04c99836ea70be2d1f39504~UrsayI9dV2297922979epcas2p1p;
	Fri, 31 May 2024 21:05:26 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.91]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4VrbHT4648z4x9Pp; Fri, 31 May
	2024 21:05:25 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
	epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	2B.31.09848.59B3A566; Sat,  1 Jun 2024 06:05:25 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
	20240531210524epcas2p4f37dff4362ebd7990da782ad8ef1688e~UrsZXnXQH2270222702epcas2p4J;
	Fri, 31 May 2024 21:05:24 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240531210524epsmtrp29fe616e5481d3e7d27acb10f73213112~UrsZWvw0I2325523255epsmtrp2k;
	Fri, 31 May 2024 21:05:24 +0000 (GMT)
X-AuditID: b6c32a45-447fe70000002678-03-665a3b95c6d3
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	39.56.07412.49B3A566; Sat,  1 Jun 2024 06:05:24 +0900 (KST)
Received: from localhost (unknown [10.229.54.230]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20240531210524epsmtip1c6d5bc1ca098a501f26eed5017cb3a0b~UrsZKP0sG1393813938epsmtip1i;
	Fri, 31 May 2024 21:05:24 +0000 (GMT)
Date: Sat, 1 Jun 2024 05:54:03 +0900
From: Minwoo Im <minwoo.im@samsung.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jeuk Kim <jeuk20.kim@samsung.com>, Minwoo Im
	<minwoo.im@samsung.com>
Subject: Re: [PATCH 2/3] ufs: pci: Add support MCQ for QEMU-based UFS
Message-ID: <Zlo467UhZ2aAMV0A@localhost>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <6052a799-88c4-4efa-a59e-d560a091a5a0@acm.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLJsWRmVeSWpSXmKPExsWy7bCmme5U66g0gxvdMhYP5m1js3j58yqb
	xbQPP5ktbh7YyWSxsZ/D4v7Wa4wWl3fNYbPovr6DzWL58X9MFs9OH2B24PK4fMXbY9qkU2we
	H5/eYvHo27KK0ePzJjmP9gPdTAFsUdk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW
	5koKeYm5qbZKLj4Bum6ZOUCHKSmUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslVILUnIKzAv0
	ihNzi0vz0vXyUkusDA0MjEyBChOyM44fuc5U0MJW8ebvNJYGxn8sXYycHBICJhKTzmxh62Lk
	4hAS2MEosfTMGhYI5xOjxKZzv6Gcb4wSm3dcZYVpuT+hnREisZdRYv3h3awQznNGiXVb7zKB
	VLEIqEj8alkNtoRNQF2iYeorMFtEQEPi24PlYGOZBR4zSSx+9IgRJCEs4Crx6tFysGZeoKKz
	6/4zQ9iCEidnPgFr5hSwlnh3dBbYagmBTg6J3vu3oG5ykVh/+RkzhC0s8er4FnYIW0ri87u9
	bBB2ucTPN5MYIewKiYOzbgPFOYBse4lrz1NAwswCGRIPTv1ghQgrSxy5xQIR5pPoOPyXHSLM
	K9HRJgQxRFni46FDUEslJZZfeg21yEPi2ee10AD6wijxZWUf2wRGuVlIvpmFZNssoLHMApoS
	63fpQ5jSEsv/cSCJLmBkXcUollpQnJueWmxUYAiP4OT83E2M4HSq5bqDcfLbD3qHGJk4GA8x
	SnAwK4nw/kqPSBPiTUmsrEotyo8vKs1JLT7EaAqMmonMUqLJ+cCEnlcSb2hiaWBiZmZobmRq
	YK4kznuvdW6KkEB6YklqdmpqQWoRTB8TB6dUA5OviZnyyf8lO94ZyC3MKe+Ze6ai8G2Q0Prj
	/D84lV/ls0tyBGw8f9B2R8NM9yMLY876+9255nXuWIvTb1l754y8UyzrJl36xyVlo3q2qcVz
	xlGtq1eeMkSK8kvlf3PkNXx/ZGFu5FmudTdenXrw8bD1z6RfSzfVcQtPVNNM53u87ei/aZfe
	sqb8evfvpmLjNc8fxgt+3JqvcOrNnKLtGvyPYh482aIVoGkgpusQaxZzetnMF3MiJxpIGB0z
	++IkIuZa/Veupm89T8xhp/3HWnhPKTJ4z7+vYlOXpvj+Q1PuYtuVdx22ql7rOXCqpe6K3WLf
	F+b/9q/uvS12ifHXXM2Ftx4dv+wtWMFnEPHO6MtEJZbijERDLeai4kQAdLXIrjAEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsWy7bCSnO4U66g0g73ntC0ezNvGZvHy51U2
	i2kffjJb3Dywk8liYz+Hxf2t1xgtLu+aw2bRfX0Hm8Xy4/+YLJ6dPsDswOVx+Yq3x7RJp9g8
	Pj69xeLRt2UVo8fnTXIe7Qe6mQLYorhsUlJzMstSi/TtErgyHn3oYiw4zlwxq0OygfEWUxcj
	J4eEgInE/QntjF2MXBxCArsZJc6t2MYMkZCU2Hf6JiuELSxxv+UIK0TRU0aJXTObGEESLAIq
	Er9aVrOA2GwC6hINU1+B2SICGhLfHixnAWlgFnjKJHH951qwdcICrhKvHi0Hs3mBis6u+88M
	MfULo8Sa/nmMEAlBiZMzn4BNYgaa+mfeJaAiDiBbWmL5Pw6QMKeAtcS7o7MYJzAKzELSMQtJ
	xyyEjgWMzKsYJVMLinPTc5MNCwzzUsv1ihNzi0vz0vWS83M3MYIjQktjB+O9+f/0DjEycTAe
	YpTgYFYS4f2VHpEmxJuSWFmVWpQfX1Sak1p8iFGag0VJnNdwxuwUIYH0xJLU7NTUgtQimCwT
	B6dUA9POjp+X//gLnNZc9eTVXsEXfu5XLVd5vwidbLjVVyVTa/uj30frAvfpiV7f8T/Ujv3z
	kaytBfE+/HpuT7Pi1ZtXRBzZHCyxZlXrsx2c808/7/m/8YXnxEv74xtEL+cJWyf2XMtYqG18
	zPSLyxMDo9xtZoEZ+bpqPtt+8f97/+rJqyfSuksti6Xfz/G7/5RZTa9lgYiiBfcE1ZjetNsC
	51P3eWyQtHw4hXVdV/6VG6rCdXcubmT8nFj4soz9YGrC+x2vPiuUl39jmPpg8xwGsf/PHXV6
	3y3kMzte+Nx2Fif3u4uqTyYdVVKwq3c4s3ibC+cy2ZxW9zNb6wIdSqYwBEVIzPARkXfy2VfA
	KOI5TVuJpTgj0VCLuag4EQBhQbGh9wIAAA==
X-CMS-MailID: 20240531210524epcas2p4f37dff4362ebd7990da782ad8ef1688e
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----He.yNZkzpBak.xuDKC9auljxNssTvAfbOgKyc16DCg-DQrdx=_28dde_"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240531104947epcas2p30506632eb56025711dfb5768e2f77154
References: <20240531103821.1583934-1-minwoo.im@samsung.com>
	<CGME20240531104947epcas2p30506632eb56025711dfb5768e2f77154@epcas2p3.samsung.com>
	<20240531103821.1583934-3-minwoo.im@samsung.com>
	<6052a799-88c4-4efa-a59e-d560a091a5a0@acm.org>

------He.yNZkzpBak.xuDKC9auljxNssTvAfbOgKyc16DCg-DQrdx=_28dde_
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline

On 24-05-31 13:16:40, Bart Van Assche wrote:
> On 5/31/24 03:38, Minwoo Im wrote:
> > +static int ufs_redhat_get_hba_mac(struct ufs_hba *hba)
> > +{
> > +	return MAX_SUPP_MAC;
> > +}
> 
> Why the prefix "ufs_redhat" instead of "ufs_qemu"?

I thouogh I had to use the same name pattern as ufs_intel_* for the name of
vendor ID of the PCI device.  I will update it in the next version.

Thanks for the review.

> 
> Thanks,
> 
> Bart.
> 

------He.yNZkzpBak.xuDKC9auljxNssTvAfbOgKyc16DCg-DQrdx=_28dde_
Content-Type: text/plain; charset="utf-8"


------He.yNZkzpBak.xuDKC9auljxNssTvAfbOgKyc16DCg-DQrdx=_28dde_--
