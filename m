Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4A712DD8F
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 14:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706712932; cv=none; b=U4cW+cjuAvYKUpNmUhB7rY6wB3WVrVCIOidAp8FyENyAuXikvFHaKwVzWq2nSOGNyyY91+suh08jyJtKs1VAyRWeGWybTNls2LQwJWEZdTHCdZ2k8AC8Or6hUk/i6xpJLPhjBxOBCT6nAVMhy8ax/xRLwWuLuzj4SWizTtcbGzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706712932; c=relaxed/simple;
	bh=l029VUoP9sdfGzPV4OqDoPzKyZc8gckM1T7bd+dSxYs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=G08Kc9J9Z4V2rHPDfFlIyo0S2ZXtnwcgtIoKbhTbr8KDpGchQW4sWzHhAMBQFjET9LwMgE/KYKIf7MWA5sqFJW5Y45FTlpXacT5LetNkpFptfPq9foDuLeMSIDHDV010ZrzXet9wY7kMoK1+u/VkMLhK2N0Xw7zDEh9aPgimo4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=vdtNY3zJ; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="vdtNY3zJ"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240131145527epoutp0235714a66264e02b6e33631e254f1a8f3~vdl2A5DYI0915009150epoutp02m
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 14:55:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240131145527epoutp0235714a66264e02b6e33631e254f1a8f3~vdl2A5DYI0915009150epoutp02m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1706712927;
	bh=l029VUoP9sdfGzPV4OqDoPzKyZc8gckM1T7bd+dSxYs=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=vdtNY3zJMbMgMkpAp8mXD47CTc1eMyIrvOnPvTEKN5uyaHNUxQhca/jeDghAIA8rR
	 b/DZAizwkcqppqaYbg7w1s6KfS9vjQZ2NYVSLY1Twj0aieLRnNXTpydqJjrsNjzidA
	 t7dVMcYlnRqNJZD5Cau9wdHsXh2y2ZxgNcioHfVA=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240131145527epcas5p3feb305630f7ac17bf47361f51ea903f6~vdl1b_fdp2531325313epcas5p3u;
	Wed, 31 Jan 2024 14:55:27 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4TQ4pP3Pt7z4x9Pq; Wed, 31 Jan
	2024 14:55:25 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	85.8E.09672.D5F5AB56; Wed, 31 Jan 2024 23:55:25 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240131145524epcas5p1a1031555f7c80b85180a4390648b591e~vdlzQqCYF2721727217epcas5p1d;
	Wed, 31 Jan 2024 14:55:24 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240131145524epsmtrp1cd139dffbc40a08cb2848f0bde7c6861~vdlzPREWW1296912969epsmtrp1F;
	Wed, 31 Jan 2024 14:55:24 +0000 (GMT)
X-AuditID: b6c32a4b-60bfd700000025c8-02-65ba5f5d6cc9
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	18.9A.07368.C5F5AB56; Wed, 31 Jan 2024 23:55:24 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240131145522epsmtip14abd4dfa12ec622d0e526d75319ef2e5~vdlxgMGz22257122571epsmtip1r;
	Wed, 31 Jan 2024 14:55:22 +0000 (GMT)
Message-ID: <1a9678e1-aca1-5feb-51d8-92cc519768c9@samsung.com>
Date: Wed, 31 Jan 2024 20:25:22 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
	Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH v9 05/19] fs: Propagate write hints to the struct
 block_device inode
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph
	Hellwig <hch@lst.de>, Daejun Park <daejun7.park@samsung.com>, Alexander Viro
	<viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jeff
	Layton <jlayton@kernel.org>, Chuck Lever <chuck.lever@oracle.com>
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20240130214911.1863909-6-bvanassche@acm.org>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNJsWRmVeSWpSXmKPExsWy7bCmum5s/K5Ugy+3hC1W3+1ns3h9+BOj
	xbQPP5kt/t99zmSx6kG4xcrVR5ksfi5bxW6x95a2xZ69J1ksuq/vYLNYfvwfk8X5v8dZHXg8
	Ll/x9rh8ttRj06pONo/dNxvYPD4+vcXi0bdlFaPH501yHpuevGUK4IjKtslITUxJLVJIzUvO
	T8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOlVJoSwxpxQoFJBYXKykb2dT
	lF9akqqQkV9cYquUWpCSU2BSoFecmFtcmpeul5daYmVoYGBkClSYkJ1xdc0VtoILTBWvm/ez
	NDBOYepi5OCQEDCReNWb0sXIxSEksJtR4sen84wQzidGie7fi1kgnG+MEq8u3mLvYuQE62je
	+JMNxBYS2Mso0XImEaLoLZB9YDYzyFheATuJL5N0QEwWAVWJJ7sdQMp5BQQlTs58wgJiiwok
	Sfy6OocRxBYWiJKYenQRM4jNLCAucevJfCYQW0QgTqJ11iuwg5gFHjFJdK29xAYyk01AU+LC
	5FKQGk4BK4nNx+9B9cpLbH87hxmkXkLgAIfEnoMn2CBudpGYcnoJM4QtLPHq+BaoX6QkXva3
	QdnJEpdmnmOCsEskHu85CGXbS7Se6gd7ixlo7/pd+hC7+CR6fz+BBiKvREebEES1osS9SU9Z
	IWxxiYczlrBClHhIrJ8nCAkoYKB1Pd/IPIFRYRZSqMxC8v0sJN/MQli8gJFlFaNkakFxbnpq
	sWmBcV5qOTyyk/NzNzGCU7GW9w7GRw8+6B1iZOJgPMQowcGsJMK7Um5nqhBvSmJlVWpRfnxR
	aU5q8SFGU2DsTGSWEk3OB2aDvJJ4QxNLAxMzMzMTS2MzQyVx3tetc1OEBNITS1KzU1MLUotg
	+pg4OKUamOyj7L6u3iO7vHXPJW8P9tO9H2Q/rGvwVN9547Z8/fPffJXTXNi1eqPLty/mC2Yy
	kvequ3T1nKu50GGLuDx20ZCsR9e4PHmL4manaS+sYP0REp7wf/Jb5UBO8Uc3T6ZH8l09uinC
	8HDbRL3bRfc6Ouz8hVfelIvm3rb2uubGzwu8JP9u5Gk+XmeyTe5H2NaG1BNMmg+fb1farp72
	OF/7uu4dN7mfjKmKirUOp88xsYrc6rG05ZrZYcvC3qC7P78oOYQlxErw2daYZWelDzftrV8/
	Ybv0xw17z2SrbDITCfO7v/SJ15Mank0efXZHZn6d2fTa1clp0jzBR2+eit/WsY2+My+4n7+t
	58ys0zcslViKMxINtZiLihMBh6PQfk4EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsWy7bCSnG5M/K5Ug3sftSxW3+1ns3h9+BOj
	xbQPP5kt/t99zmSx6kG4xcrVR5ksfi5bxW6x95a2xZ69J1ksuq/vYLNYfvwfk8X5v8dZHXg8
	Ll/x9rh8ttRj06pONo/dNxvYPD4+vcXi0bdlFaPH501yHpuevGUK4IjisklJzcksSy3St0vg
	yri65gpbwQWmitfN+1kaGKcwdTFyckgImEg0b/zJBmILCexmlNj83BkiLi7RfO0HO4QtLLHy
	33Mgmwuo5jWjxI0Jb1i6GDk4eAXsJL5M0gExWQRUJZ7sdgAp5xUQlDg58wkLiC0qkCSx534j
	2CphgSiJqUcXMYPYzEDjbz2ZDxYXEYiTOLz/Bth4ZoEnTBKbt7eyQ9yzl1Fiyi8LkPlsApoS
	FyaXgoQ5BawkNh+/BzXHTKJraxcjhC0vsf3tHOYJjEKzkJwxC8m6WUhaZiFpWcDIsopRMrWg
	ODc9N9mwwDAvtVyvODG3uDQvXS85P3cTIzjytDR2MN6b/0/vECMTB+MhRgkOZiUR3pVyO1OF
	eFMSK6tSi/Lji0pzUosPMUpzsCiJ8xrOmJ0iJJCeWJKanZpakFoEk2Xi4JRqYEqb1zrxL9f+
	5ctTHh62+R/nedYouVI0wSrKuMNQ/fSy3exCxcvVHLd03jw+VX3H00aXW+dT7KQ/nXzCunBV
	WZLQtp0bvE8In9B+u1Xr199PZk/5X6R4fPk97526/foL/Sb7xE7qrefdyDWz2+H++n2BtrYM
	s/c8O2WQ/PyFwnL/frnW2cvDGJ/s7b5qHTgznVfEUG6Pc6ey5YObU+VXM148b6PvdyFkdh1r
	y69im47b/lse37PSe6MUwvpWrchW5GDWg7bjteqRIZZpPqJMx036jqlUvI5itT1jq1lcsOtk
	ufuuy/8EVHN3H2aNlJn4Kl2QNdE04csnGYvjs5eu8I4XSJderzh3BdfmWUW1+kosxRmJhlrM
	RcWJAMrSHowrAwAA
X-CMS-MailID: 20240131145524epcas5p1a1031555f7c80b85180a4390648b591e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240130214958epcas5p25f8c63678746128e6aa51e5be656d3cc
References: <20240130214911.1863909-1-bvanassche@acm.org>
	<CGME20240130214958epcas5p25f8c63678746128e6aa51e5be656d3cc@epcas5p2.samsung.com>
	<20240130214911.1863909-6-bvanassche@acm.org>

On 1/31/2024 3:18 AM, Bart Van Assche wrote:
> Write hints applied with F_SET_RW_HINT on a block device affect the
> block device inode only. Propagate these hints to the inode associated
> with struct block_device because that is the inode used when writing
> back dirty pages.

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
