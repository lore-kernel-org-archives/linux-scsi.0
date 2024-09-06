Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28ED1CB33E
	for <linux-scsi@vger.kernel.org>; Fri,  6 Sep 2024 11:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725622985; cv=none; b=hquT/P3DDNmHmyRR6XRL3WWWkHUZc3N7KaspWSHRDrWnQVZOfRzM46SJ6S/GYuQCHq+MzRbPNtBuVJvvKFEANMrvmem4Gi0D7638SX5da6BpCRb1krIWGAa7WERCKiQBcBT13z9tNLRRnH5+fZhZvbtLzwOk4my6OnEeNxCL9dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725622985; c=relaxed/simple;
	bh=JViiijbWVb4g87RGAEJMC4FllLRTP244oYzrs0FmBsU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=b/nAVqeNsf0OM3FGqKnUVDW1vWzwQBiEyz+c6hAHH0YTJuw2mSq679jQYlKXS/H3Z6DyUs0qCSrupvERlzNU2cEZAslNu6fne3HJfGN2oE72l9XDx5AAkT+QqH+f8L/lWBa14IQp8fuY/i3uEN5+xPAu3kUKxsrxXTHcieEAWwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=W4AzyR2H; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="W4AzyR2H"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240906114255epoutp0137b392c755319fe6f9b6c2f4d7b5b3a7~ypPQhssDF0592605926epoutp01F
	for <linux-scsi@vger.kernel.org>; Fri,  6 Sep 2024 11:42:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240906114255epoutp0137b392c755319fe6f9b6c2f4d7b5b3a7~ypPQhssDF0592605926epoutp01F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1725622975;
	bh=JViiijbWVb4g87RGAEJMC4FllLRTP244oYzrs0FmBsU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=W4AzyR2Hy8M70yPCLrMKqEGcvdfCyl6Vk/bZCepC2rvAVmlIww45lU6IwD4lBZc0y
	 omjY/6CE8ADaGXROac1I5usWZsP4xPSuAj9AUiNDP7pEhEOnWRQ6vfFRQv2E7x6SNj
	 R1XxSOiqxNHX771iaio8jE6hkEJUP1oefIagIpx8=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240906114254epcas5p1075ccb25a4fc445a8d598e7dfb0db38b~ypPP5BnHB2100421004epcas5p1w;
	Fri,  6 Sep 2024 11:42:54 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4X0Z993mDPz4x9Pp; Fri,  6 Sep
	2024 11:42:53 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	71.CC.19863.DBAEAD66; Fri,  6 Sep 2024 20:42:53 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240906113547epcas5p1f2b6f478a1804a2b1ad04b1e64b05d92~ypJBYwqDk2192021920epcas5p1F;
	Fri,  6 Sep 2024 11:35:47 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240906113547epsmtrp2c46527f2f85e1f4a907fee008346576e~ypJBXarVJ1860918609epsmtrp20;
	Fri,  6 Sep 2024 11:35:47 +0000 (GMT)
X-AuditID: b6c32a50-ef5fe70000004d97-b8-66daeabd070a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	4B.E6.08456.219EAD66; Fri,  6 Sep 2024 20:35:46 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20240906113545epsmtip20c270e21efb4bf1568fdf5e81b839430~ypI-o2OgC2799027990epsmtip2r;
	Fri,  6 Sep 2024 11:35:45 +0000 (GMT)
Date: Fri, 6 Sep 2024 16:58:19 +0530
From: Anuj Gupta <anuj20.g@samsung.com>
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, sagi@grimberg.me, Keith Busch
	<kbusch@kernel.org>
Subject: Re: [PATCHv3 10/10] blk-merge: properly account for integrity
 segments
Message-ID: <20240906112819.y6faem7p6gyf24zw@green245>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240904152605.4055570-11-kbusch@meta.com>
User-Agent: NeoMutt/20171215
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIJsWRmVeSWpSXmKPExsWy7bCmlu7eV7fSDOY9lLRYfbefzWLl6qNM
	FpMOXWO0OHN1IYvF3lvaFvOXPWW36L6+g81i+fF/TBbrXr9nceD0OH9vI4vH5bOlHptWdbJ5
	bF5S77H7ZgObx7mLFR4fn95i8fi8SS6AIyrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ
	19DSwlxJIS8xN9VWycUnQNctMwfoNiWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpO
	gUmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdsa7TweYCo6yVHQ3H2JvYPzP3MXIwSEhYCLxapZT
	FyMXh5DAHkaJ7U+7GSGcT4wS75buYINwvjFK3HvQwtrFyAnWcWTlGnaIxF5GiZ6W91DOM0aJ
	KV+PMoJUsQioSHz9uogdxGYTUJc48rwVLC4ioChxHhgUIA3MAmcZJX7962ACSQgLBEq8vPYY
	zOYVMJN4PvEAO4QtKHFy5hMWEJtTwELixLT7zCC2qICMxIylX5lBBkkITOWQ2Lr/LTPEfS4S
	j5ffYoOwhSVeHd/CDmFLSXx+txcqni7x4/JTJgi7QKL52D5GCNteovVUPzhkmIFqPq/igwjL
	Skw9tQ6snFmAT6L39xOoVl6JHfNgbCWJ9pVzoGwJib3nGqBsD4lXZ75Aw3EHo8SPRzOZJjDK
	z0Ly2yyEdbPAVlhJdH5oYoUIS0ss/8cBYWpKrN+lv4CRdRWjVGpBcW56arJpgaFuXmo5PMaT
	83M3MYLTrlbADsbVG/7qHWJk4mA8xCjBwawkwvvU81aaEG9KYmVValF+fFFpTmrxIUZTYGRN
	ZJYSTc4HJv68knhDE0sDEzMzMxNLYzNDJXHe161zU4QE0hNLUrNTUwtSi2D6mDg4pRqYOpI6
	Dtcvzjtg8elCZ5/yHPmcyc8r7XJ2HolZqf/6911+0Z0dws+EPk7ddcThntFUSR+PHV8L126a
	8D1Jpbdq4b37k4oe9D9v/r3L0kN06auMkGObw7ftkl68szAncZmiO6NW3RfTJH45h/fy9+ct
	2u1cGWByY32ev81XPZN+FRaWU1Pb9P0rmFISMjfEdt0J/WIT+r3B7pC7wP8557d2z1xSm3Nw
	yn7zkp27zAx3WRg93SclVew4K78lV2Plgsp9ie8rfaZsNXk/fS5/mXb74qlPhLQPuO1b9p53
	9v7pl7aI/ypI9pHZwWMl49h9imGGAHvR5WDzDZqpIc3Ss6+9qphf2+0q3nK4vu9h+IFuJZbi
	jERDLeai4kQAyhtlb0QEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsWy7bCSvK7Qy1tpBgt3WlmsvtvPZrFy9VEm
	i0mHrjFanLm6kMVi7y1ti/nLnrJbdF/fwWax/Pg/Jot1r9+zOHB6nL+3kcXj8tlSj02rOtk8
	Ni+p99h9s4HN49zFCo+PT2+xeHzeJBfAEcVlk5Kak1mWWqRvl8CVMb2Tv+AXY8WKL4dZGxjP
	MXYxcnJICJhIHFm5hr2LkYtDSGA3o8Tthk0sEAkJiVMvl0EVCUus/PccqugJo8T8tmfsIAkW
	ARWJr18XgdlsAuoSR563gjWICChKnAc6B6SBWeAso8SCne/AEsICgRIvrz1mArF5Bcwknk88
	ANYsJJAi8eHqBxaIuKDEyZlPwGxmoJp5mx8ydzFyANnSEsv/cYCEOQUsJE5Mu88MYosKyEjM
	WPqVeQKj4Cwk3bOQdM9C6F7AyLyKUTK1oDg3PbfYsMAoL7Vcrzgxt7g0L10vOT93EyM4WrS0
	djDuWfVB7xAjEwfjIUYJDmYlEd6nnrfShHhTEiurUovy44tKc1KLDzFKc7AoifN+e92bIiSQ
	nliSmp2aWpBaBJNl4uCUamAy2vKbrVNmmd2maoE9kjKlPXozX1uG338ddMHOxeXa1Yh2HVM2
	FXnpd0tTphfwODLa7bl15my0rcJCnYOxn7+6fty1aK/ktHVVc76WT/sbW7f76Jl1JsFq6398
	WDJx+/1WrVCfkCTdN0pMIeuc/rv2iq9rZd5UK37jg09Cc2ZuRH/1rWTr7k8Pmack9Txa+ri8
	aEKtCP/KzVM7AqXzbn+zFb0bVCugeaa3e8/VOOMNryoPGVTOfjZReFkdbwGz8vct0bPTRLla
	EzaoxXJ/DKpIL27MSLh7+N2sElmFOp6mVmXd/d03WdMSmlkrbuy+LHFWRi7n324NzYDE186T
	tbJeTZ0i05nyWbj/QfGvW0osxRmJhlrMRcWJAL9ZNBQFAwAA
X-CMS-MailID: 20240906113547epcas5p1f2b6f478a1804a2b1ad04b1e64b05d92
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----HRSYnzKNO8ONjxL1FThol40IlJ6VfYrZPjW9SDYGLJs4fc5X=_5b08_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240906113547epcas5p1f2b6f478a1804a2b1ad04b1e64b05d92
References: <20240904152605.4055570-1-kbusch@meta.com>
	<20240904152605.4055570-11-kbusch@meta.com>
	<CGME20240906113547epcas5p1f2b6f478a1804a2b1ad04b1e64b05d92@epcas5p1.samsung.com>

------HRSYnzKNO8ONjxL1FThol40IlJ6VfYrZPjW9SDYGLJs4fc5X=_5b08_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 04/09/24 08:26AM, Keith Busch wrote:
>From: Keith Busch <kbusch@kernel.org>
>
>Merging two requests wasn't accounting for the new segment count, so add
>the "next" segement count to the first on a successful merge.

Nit: s/segement/segment

------HRSYnzKNO8ONjxL1FThol40IlJ6VfYrZPjW9SDYGLJs4fc5X=_5b08_
Content-Type: text/plain; charset="utf-8"


------HRSYnzKNO8ONjxL1FThol40IlJ6VfYrZPjW9SDYGLJs4fc5X=_5b08_--
