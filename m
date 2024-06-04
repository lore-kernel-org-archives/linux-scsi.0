Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58468140366
	for <linux-scsi@vger.kernel.org>; Tue,  4 Jun 2024 21:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717537018; cv=none; b=mhyvt9uw6QopxhiQQV5rSxhNnVdry93QGzM5ge2QsJ5nuggriEWKdz8S/VbkyFAtl3wtlHjzJ9tMH02THAIrpDHdDtoGZptB6I4M2oGXH/vvoe0rsMKb8ELHVPXuKf5RcyW6cek7ysFWGkWQ4u9pnS8x580y2uaS3O+cm6YPBNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717537018; c=relaxed/simple;
	bh=puURQERLz94FvLYH0q5wN5Talh2uyai7H+JpiHakSng=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=OxysBtdZzZM/K1Bpz9dzd5KWAQmR5pJtzIFvmpFxK66T0izpA1zas6/qEvJ/RpbbhThn86QqoRm9Q2AoFHQA8bLkyOQxWNJj2SjTydsiWeJG7BFHL4C/zN8pt9Xv4U0+MgLw5c25o21hHqcaA4SviyGIg6EsVdg2Pbnnf9gSeRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=YegoshYI; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="YegoshYI"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240604213653epoutp04dbe6745ee791a80a0aa9e4f6f8f5148a~V6tBEik450571005710epoutp043
	for <linux-scsi@vger.kernel.org>; Tue,  4 Jun 2024 21:36:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240604213653epoutp04dbe6745ee791a80a0aa9e4f6f8f5148a~V6tBEik450571005710epoutp043
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1717537013;
	bh=ZOURbzj817Ck8l65RqPSmAdFu0hk2DTkht+Sl/K8/YY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YegoshYIYS4GFjGsDR2gZPuUdyrYv3zpaws5ZTpXPQyDgTT8k/mYnVxPkBHNRaarp
	 yzan0FacH1R6Z9GkR0QNTZS1FYGwtwZlgdokXF2zd9FdGj07bY8JsF790iYs/l02nN
	 tQfOdJVCMBWT5gZhklfJANE4BmFUyVM7e5CFVIXE=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTP id
	20240604213652epcas2p41b25d900b665f8045e387d4a59043299~V6tAIryoA2070920709epcas2p4l;
	Tue,  4 Jun 2024 21:36:52 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.100]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Vv3nv2gqNz4x9Pv; Tue,  4 Jun
	2024 21:36:51 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
	epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
	7B.85.09485.3F88F566; Wed,  5 Jun 2024 06:36:51 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
	20240604213651epcas2p4efe082091c09022288bfa9e81eb95c6d~V6s-FRE5R2070920709epcas2p4i;
	Tue,  4 Jun 2024 21:36:50 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240604213650epsmtrp18a39f0b3fe0652e0756a8867beaa7b1c~V6s-EIj6m0909409094epsmtrp1i;
	Tue,  4 Jun 2024 21:36:50 +0000 (GMT)
X-AuditID: b6c32a46-f3bff7000000250d-be-665f88f33f62
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	AE.6A.18846.2F88F566; Wed,  5 Jun 2024 06:36:50 +0900 (KST)
Received: from localhost (unknown [10.229.54.230]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20240604213650epsmtip238d5c32ce68339930b7ee089e9839371~V6s_2a-En2204322043epsmtip2v;
	Tue,  4 Jun 2024 21:36:50 +0000 (GMT)
Date: Wed, 5 Jun 2024 06:25:20 +0900
From: Minwoo Im <minwoo.im@samsung.com>
To: "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>, Bart Van Assche
	<bvanassche@acm.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
	<avri.altman@wdc.com>, gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jeuk Kim <jeuk20.kim@samsung.com>, Minwoo Im
	<minwoo.im@samsung.com>
Subject: Re: [PATCH v2 0/2] ufs: pci: Add support UFSHCI 4.0 MCQ
Message-ID: <Zl+GQGK9d3AvrEEz@localhost>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240531212244.1593535-1-minwoo.im@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDJsWRmVeSWpSXmKPExsWy7bCmhe7njvg0g1nnBS0ezNvGZvHy51U2
	i2kffjJb3Dywk8liYz+Hxf2t1xgtLu+aw2bRfX0Hm8Xy4/+YLJ6dPsDswOVx+Yq3x7RJp9g8
	Pj69xeLRt2UVo8fnTXIe7Qe6mQLYorJtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0t
	zJUU8hJzU22VXHwCdN0yc4AOU1IoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKqUWpOQUmBfo
	FSfmFpfmpevlpZZYGRoYGJkCFSZkZ1yYsZip4BBfxfqNB1gaGD9ydzFyckgImEi03vvD0sXI
	xSEksINRYtbF10wQzidGiR1XnrGCVIE53bcDYTrWvpjJCFG0k1HiyZZHrBDOc0aJe1OvMoNU
	sQioSHza/wSsm01AXaJh6iuwHSICixklZn7dzA7iMAu8YJRY1zedCaRKWMBB4sius2DdvAIa
	EltPnWWFsAUlTs58wgJicwrYSrzfup0ZpFlCoJVDYs3rTUwQR7lIrLkHchSILSzx6vgWdghb
	SuJlfxuUXS7x880kqJoKiYOzbrN1MXIA2fYS156ngISZBTIk7j6YDBVWljhyiwUizCfRcfgv
	O0SYV6KjTQhiiLLEx0OHmCFsSYnll16zQdgeEq1n+5kgITeBUeLut4oJjHKzkDwzC8myWUBT
	mQU0Jdbv0ocwpSWW/+NAEl3AyLqKUSy1oDg3PbXYqMAIHr/J+bmbGMHJVMttB+OUtx/0DjEy
	cTAeYpTgYFYS4fUrjk8T4k1JrKxKLcqPLyrNSS0+xGgKjJqJzFKiyfnAdJ5XEm9oYmlgYmZm
	aG5kamCuJM57r3VuipBAemJJanZqakFqEUwfEwenVAPTpGL/51/6Zh3OSpA0FtdZNN3LQPb7
	te0dhm/Xajyr3+QZfmXbq/0KyXwPTyXPv3CE/+LWAgPJmclSb3QufJFpkDSL/F/uq/1YKqHE
	9smJx7uU6k60idpnyD9OfPpe2iP36/1utpnnL34OjuZlmLqiOmY/W3VawZ4/BTctri/3Xpbc
	+O+6fHEg3ym7iqDDLLfSWh5orOt+cv98f8O8DccM/RV/i3/cvGxlqSaPzpF7r1sswnatOG72
	fZXU8suzt36y/pDpeKYh4fdMK1XGtXuPnlC1mJ/UV5Fcst5jxvedJfePv545damu5XKLyCdK
	J/dkMnudm8SzQvFkk0LMUYEj/lIm6ourT1Z8z/960+fRPyWW4oxEQy3mouJEAENwSn4vBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsWy7bCSvO6njvg0g2XHTSwezNvGZvHy51U2
	i2kffjJb3Dywk8liYz+Hxf2t1xgtLu+aw2bRfX0Hm8Xy4/+YLJ6dPsDswOVx+Yq3x7RJp9g8
	Pj69xeLRt2UVo8fnTXIe7Qe6mQLYorhsUlJzMstSi/TtErgyDhybw1rQylPxfPkS9gbGs5xd
	jJwcEgImEmtfzGTsYuTiEBLYziix+PhuJoiEpMS+0zdZIWxhifstR1ghip4ySvSubwFLsAio
	SHza/wTMZhNQl2iY+ooFpEhEYDGjxMMPc8EcZoFXjBJzzp4HGyss4CBxZNdZZhCbV0BDYuup
	s1BjJzBKnLrUzgSREJQ4OfMJC4jNDDT2z7xLQA0cQLa0xPJ/HCBhTgFbifdbtzNPYBSYhaRj
	FpKOWQgdCxiZVzGKphYU56bnJhcY6hUn5haX5qXrJefnbmIER4NW0A7GZev/6h1iZOJgPMQo
	wcGsJMLrVxyfJsSbklhZlVqUH19UmpNafIhRmoNFSZxXOaczRUggPbEkNTs1tSC1CCbLxMEp
	1cBkWh/qfyHqmPHVirbjuTs8X2Sd/hEQd+uIjEDBqxrGjT+2dW1/I8Zu82oFz93zYhmqB76s
	VDGwkTqncUnj48vH0v0+Li9/8l8wnGDh/9D50roq0xRr78xZbqu/Xe8R/tV/NEKwUG3Gma7k
	fPntBj0GFqxXfqxOrhKpLRU7vf/iZ5UtMyq+vWveqbTru8ej+FMLS1TTz5YznnGMeXZX+6/E
	xOmSn2YHRj/M4rtilvit18eodFVIevmMmZFW5dzldcVnZGcILhbiYNli5yLzbKpFhOMaO/2q
	yZ1tk0UfVbw4OLXuiv/+M5/T8x0y3YMleeceuz+1JoBl8ZeoHVxvePOqLEy/7n/I0K7+y9un
	fI0SS3FGoqEWc1FxIgAFnQfg9QIAAA==
X-CMS-MailID: 20240604213651epcas2p4efe082091c09022288bfa9e81eb95c6d
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----CGP_Yo4KSd1.GMH1id3MjqccfDy5Ep7f4Yd1jhLawOabyReQ=_4cbea_"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240531213424epcas2p16d7360e12d310c9f299d449e66af07b3
References: <CGME20240531213424epcas2p16d7360e12d310c9f299d449e66af07b3@epcas2p1.samsung.com>
	<20240531212244.1593535-1-minwoo.im@samsung.com>

------CGP_Yo4KSd1.GMH1id3MjqccfDy5Ep7f4Yd1jhLawOabyReQ=_4cbea_
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline

On 24-06-01 06:22:42, Minwoo Im wrote:
> This patchset introduces add support for MCQ introduced in UFSHCI 4.0.  The
> first patch adds a simple helper to get the address of MCQ queue config
> registers.  The second one enables MCQ feature by adding mandatory vops
> callback functions required at MCQ initialization phase.  The last one is to
> prevent a case where number of MCQ is given 1 since driver allocates poll_queues
> first rather than I/O queues to handle device commands.  Instead of causing
> exception handlers due to no I/O queue, failfast during the initialization time.
> 
> ---
> v2:
>   - https://lore.kernel.org/linux-scsi/20240531103821.1583934-1-minwoo.im@samsung.com/T/#t

Now the MCQ feature of hw/ufs has been pulled to QEMU [1]. You can test this
patchset with [1].

[1] https://github.com/qemu/qemu/commit/5c079578d2e46df626d13eeb629c7d761a5c4e44

>   - Not separate the newly introduced function from the actuall caller in the
>     other patch by squash the second patch to the first one (Bart).
>   - Rename ufs_redhat_* in ufshcd-pci.c to ufs_qemu_* to represent that it's
>     for QEMU UFS PCI device (Bart).
> 
> Minwoo Im (2):
>   ufs: pci: Add support MCQ for QEMU-based UFS
>   ufs: mcq: Prevent no I/O queue case for MCQ
> 
>  drivers/ufs/core/ufs-mcq.c    | 23 +++++++++++++++++
>  drivers/ufs/host/ufshcd-pci.c | 48 ++++++++++++++++++++++++++++++++++-
>  include/ufs/ufshcd.h          |  1 +
>  3 files changed, 71 insertions(+), 1 deletion(-)
> 
> -- 
> 2.34.1
> 

------CGP_Yo4KSd1.GMH1id3MjqccfDy5Ep7f4Yd1jhLawOabyReQ=_4cbea_
Content-Type: text/plain; charset="utf-8"


------CGP_Yo4KSd1.GMH1id3MjqccfDy5Ep7f4Yd1jhLawOabyReQ=_4cbea_--
