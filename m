Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA6D175AB
	for <linux-scsi@vger.kernel.org>; Sun, 19 May 2024 20:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716151815; cv=none; b=IycxT6y9cucRz62Bp2gosmtRced2GkE8l2A9n1zb43cu+iOiKTz/30r9tFloLHS5UqQGZfnW7Xjah/cdEovnVc5dSeWtlbApGlkmORUT0DJSmYc7waSiOed3JYedgdWRsUIb6CtZcyTh+bVH8E/wPNeP8S7OQ1WPU6Ax/i6b4zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716151815; c=relaxed/simple;
	bh=VCwLXB8PxzERbMg7Uw6PUxEO8FqWUx4CHmtg5hRTk7I=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=HBB2k3713AM1DGeYGuZ3VGzeiqzyPCYzgXYpaL4hOvkFyP/ZeqxExScqqDOSjtlqFigOB5ZuwzIOgOzwC2bXBbDc4Y2KR0Qe6ajcfczEyV1XR1WA+b7PFqAiJ0vMKxRgAi90nYFf5H4JKqSi1znYVHPh4hC/ayrh7q/4DrOo71E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=j3OO0z+t; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="j3OO0z+t"
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240519205003epoutp01b728185384dc292ab571bbeb2cfee7e5~Q-vkOCgQW0517105171epoutp01g
	for <linux-scsi@vger.kernel.org>; Sun, 19 May 2024 20:50:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240519205003epoutp01b728185384dc292ab571bbeb2cfee7e5~Q-vkOCgQW0517105171epoutp01g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1716151803;
	bh=ZKVEx0Lq8LLMANM056f80Wk7YikwX/VGXkSZeMFK5l4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=j3OO0z+t7hobRiXrMYMhK7x+qXGS31rAjrLeAiCF5MC32geaiKNHrlsY+Bz62WeqG
	 XOyr010BGsn4CWHCWaKDlRSmo1+8jmYNPaGJtYWO8f+rMAPQEAtYu0eH9HcuIdeLZA
	 wOg7XSIsgq19/eUQLRuy+ZHWqrCxEJdaWquxd0sM=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTP id
	20240519205003epcas2p131efc018e8974ffd7bdda65584145345~Q-vjxxXLU0877008770epcas2p18;
	Sun, 19 May 2024 20:50:03 +0000 (GMT)
Received: from epsmgec2p1-new.samsung.com (unknown [182.195.36.99]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4VjCWG3Bkwz4x9Pt; Sun, 19 May
	2024 20:50:02 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
	epsmgec2p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E9.E9.19141.AF56A466; Mon, 20 May 2024 05:50:02 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
	20240519205001epcas2p319536d42c4837c0fc7e19da0550e308c~Q-vh_KNTj0558705587epcas2p3L;
	Sun, 19 May 2024 20:50:01 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240519205001epsmtrp169dd51e56b8016ef66cbad675323aeed~Q-vh9CMmT0448704487epsmtrp1q;
	Sun, 19 May 2024 20:50:01 +0000 (GMT)
X-AuditID: b6c32a4d-b17ff70000004ac5-a0-664a65fa0bee
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	5E.5E.19234.9F56A466; Mon, 20 May 2024 05:50:01 +0900 (KST)
Received: from localhost (unknown [10.229.54.230]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20240519205001epsmtip11d0873e86be594e3d72d453c4884c86f~Q-vhxKvfi2600726007epsmtip1H;
	Sun, 19 May 2024 20:50:01 +0000 (GMT)
Date: Mon, 20 May 2024 05:39:04 +0900
From: Minwoo Im <minwoo.im@samsung.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Joel Granados
	<j.granados@samsung.com>, gost.dev@samsung.com, Asutosh Das
	<quic_asutoshd@quicinc.com>, Minwoo Im <minwoo.im@samsung.com>
Subject: Re: [PATCH] ufs: mcq: Fix missing argument 'hba' in
 MCQ_OPR_OFFSET_n
Message-ID: <ZkpjaHaGOWMZ++di@localhost>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <2450470c-b449-48a7-9fb7-aa363cbe885b@acm.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGJsWRmVeSWpSXmKPExsWy7bCmue6vVK80g3/nBS0ezNvGZvHy51U2
	i2kffjJb3Dywk8li6f6HjBYb+zksLu+aw2bRfX0Hm8Xy4/+YLJ6dPsBssbBjLosDt8flK94e
	0yadYvP4+PQWi8fEPXUefVtWMXp83iTn0X6gmymAPSrbJiM1MSW1SCE1Lzk/JTMv3VbJOzje
	Od7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoQiWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJ
	rVJqQUpOgXmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdsa+w41sBbfYKuZsKGtgvMDaxcjJISFg
	IvFr3h4gm4tDSGAPo8Su2VvZIJxPjBIzv3xmhXNObtnKDtPy88RLRojETkaJ0x2bGEESQgLP
	GSXWtiSB2CwCqhJzlt1nA7HZBNQlGqa+YgGxRQQ0JL49WM4C0swsMJFZ4syc10AOB4ewgL/E
	lHv5IDW8QDV/VsxggrAFJU7OfALWyylgLXGr6yRYr4RAL4fEz7e9UBe5SDSfXcwGYQtLvDq+
	BSouJfGyvw3KLpf4+WYSI4RdIXFw1m02kL0SAvYS156ngISZBTIkDs94ygIRVpY4cosFIswn
	0XH4LztEmFeio00IYoiyxMdDh5ghbEmJ5ZdeQx3gIXHxxGQ2SIgcYJS4OTF8AqPcLCTPzEKy
	bBbQVGYBTYn1u/QhTGmJ5f84kEQXMLKuYpRKLSjOTU9NNiow1M1LLYdHcHJ+7iZGcILV8t3B
	+Hr9X71DjEwcjIcYJTiYlUR4N23xTBPiTUmsrEotyo8vKs1JLT7EaAqMnInMUqLJ+cAUn1cS
	b2hiaWBiZmZobmRqYK4kznuvdW6KkEB6YklqdmpqQWoRTB8TB6dUA1Od7fz/kZW7HS48aStl
	+KA3gb8seLPk3Off5/2z/nsrSkhs54OCDQ8VT5j9/Tilumk3i3nnldRo/foZO3hPN8UZXeFN
	25i667Cu4runCzWq4z9wn7y33qhi1mY7Hh7pxOut4g/fz5/M8nyW3vRty28eijD4feWttvQa
	97MsjVdXlBg7bjw6OeRqZ/I/xa+WN/eodt3S3+zq/irbLSHzXgyfluOV4Iv3nJeaTDEQEG+/
	lMf4/vfGo+x83tde/kk4r/XB97LoLbUF/2Zo7489FFYrtmtXqI5RRvbLey0T02U/rfpzcefa
	KT7rFqy/9WslZ8EkKe7eru4VZ7w+1GzwjrK+Z1Otfq9ygn/ZieqE2dqLlFiKMxINtZiLihMB
	xhXz4jkEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsWy7bCSnO7PVK80g1cbuSwezNvGZvHy51U2
	i2kffjJb3Dywk8li6f6HjBYb+zksLu+aw2bRfX0Hm8Xy4/+YLJ6dPsBssbBjLosDt8flK94e
	0yadYvP4+PQWi8fEPXUefVtWMXp83iTn0X6gmymAPYrLJiU1J7MstUjfLoEr49rXb+wFc1kq
	lp5xaGBcw9zFyMkhIWAi8fPES8YuRi4OIYHtjBL/fuxnh0hISuw7fZMVwhaWuN9yhBWi6Cmj
	xOeXm8CKWARUJeYsu88GYrMJqEs0TH3FAmKLCGhIfHuwnAWkgVlgKrPEja27wdYJC/hKzN5w
	CczmBSr6s2IGE8TUA4wS3w/MYIFICEqcnPkEzGYGmvpnHkgDB5AtLbH8HwdImFPAWuJW10mW
	CYwCs5B0zELSMQuhYwEj8ypG0dSC4tz03OQCQ73ixNzi0rx0veT83E2M4NjQCtrBuGz9X71D
	jEwcjIcYJTiYlUR4N23xTBPiTUmsrEotyo8vKs1JLT7EKM3BoiTOq5zTmSIkkJ5YkpqdmlqQ
	WgSTZeLglGpg6rNk2W7S83vXj6gj7le54j4IPPk4mbfb7t1/1yAVA58HfPp6JVGdwqaSOV9+
	bmZ1a9GoTWPdoTl17oMoX3UnFt9nOTP/NWa8YjP/32Okabxdcl9pwUqR7VIL2ZsTDu04ylpu
	F9kzJ6KmMMjCJjXndotsc9HviytZLqRdrczVXs7inBXr63602yZlAUNMd/vkHTtdkqds3GU6
	+TyLzsH0Wfpl09Yq+Aaphl+qqkmP9Lr64wrr7cRZZ2TtkgrYVJdzPp77TV1o+S2nAw83FEqu
	5tCYez/+qPn/w6KzO9i23Cw7OX/mkhb1FJ2vikbPGjp3Wqy9zsm3qTtw1obbPvdmS0/nMRZ+
	ecN7PueUO2+UWIozEg21mIuKEwEg/UqU/AIAAA==
X-CMS-MailID: 20240519205001epcas2p319536d42c4837c0fc7e19da0550e308c
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----18bPhOHZ4t-_CcSgAyEj2-9JxUxziaFjkQ7CDPyIhvGVJv9g=_1a241_"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240516032553epcas2p3b8f34d03f32cccccc628027fbe1e8356
References: <CGME20240516032553epcas2p3b8f34d03f32cccccc628027fbe1e8356@epcas2p3.samsung.com>
	<20240516031405.586706-1-minwoo.im@samsung.com>
	<2450470c-b449-48a7-9fb7-aa363cbe885b@acm.org>

------18bPhOHZ4t-_CcSgAyEj2-9JxUxziaFjkQ7CDPyIhvGVJv9g=_1a241_
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline

On 24-05-16 08:03:17, Bart Van Assche wrote:
> On 5/15/24 21:14, Minwoo Im wrote:
> >   /* Operation and runtime registers configuration */
> >   #define MCQ_CFG_n(r, i)	((r) + MCQ_QCFG_SIZE * (i))
> > -#define MCQ_OPR_OFFSET_n(p, i) \
> > +#define MCQ_OPR_OFFSET_n(hba, p, i) \
> >   	(hba->mcq_opr[(p)].offset + hba->mcq_opr[(p)].stride * (i))
> Since inline functions are preferred over macros, please convert the
> MCQ_OPR_OFFSET_n() macro into an inline function.

Okay.  I will prepare v2.

> 
> Thanks,
> 
> Bart.
> 

------18bPhOHZ4t-_CcSgAyEj2-9JxUxziaFjkQ7CDPyIhvGVJv9g=_1a241_
Content-Type: text/plain; charset="utf-8"


------18bPhOHZ4t-_CcSgAyEj2-9JxUxziaFjkQ7CDPyIhvGVJv9g=_1a241_--
