Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2B314E2F5
	for <linux-scsi@vger.kernel.org>; Mon,  2 Sep 2024 04:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725250684; cv=none; b=FKtAvUY1PiRKtIEjdm7supnDCHRR7L8vOQjiv7C9DyoojskDis/Zyh7kYUMNDQ6ALHTTSdNVdCJvN7hYAyg0waQJwF9FNJHrjif7Xws0ZgI6WhOULR8d/ukPejGQPjBmgHXwdvnjyonjc+4P4m74SpP2WsGRBp7S4yjeNhGq3S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725250684; c=relaxed/simple;
	bh=MO14LUIF8qfg6JN0ScS8++cgfVvw/iIUC0YhSNYWRP8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=hSX4ILOqU0Smch84+COzJMpeB3VdPDAVkX1FwZWUsug5SuLHAxQ3ngrtGJxoLdNhYCUnNUIyPO1jkcQ/DaMfVc5P0NPJ5psWtsrkDUJcOVhvOSQEWv+K8Jj6aZ8M9mHpI+STuLF0TrLyoi+mifoSUiE8f5mVZ/ofLxCVgfbGh04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=tt0npxQd; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="tt0npxQd"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240902041754epoutp023cf3d6193856ebec248d30f5b5235e44~xUljvkvbv0946409464epoutp026
	for <linux-scsi@vger.kernel.org>; Mon,  2 Sep 2024 04:17:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240902041754epoutp023cf3d6193856ebec248d30f5b5235e44~xUljvkvbv0946409464epoutp026
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1725250674;
	bh=Isa52YVDhPYr+/I4lVZk60xROWfiWI4E5z4qj93hrCU=;
	h=From:To:Cc:Subject:Date:References:From;
	b=tt0npxQdfiSqjS4+S3WmWLQw9kaPbiQOnLr3UUOQ0V5+OPtNC7e8fElyn54JqbuHR
	 Bz6Be+ZQadG7J8nfLMczS6A2scgO009yRNsj9bmPG0m72CVeHzxv8L1ykhNtpGINoe
	 gx4X9cRNvg5W/s7xM++N/7vr//JuGy1ZarqSSJ1k=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTP id
	20240902041753epcas2p2d2c82cb32ec3fc4f4bb49e93df19bd30~xUljLefW91585315853epcas2p22;
	Mon,  2 Sep 2024 04:17:53 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.98]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4WxwTX4vNNz4x9Q7; Mon,  2 Sep
	2024 04:17:52 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
	epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
	D3.F3.10012.07C35D66; Mon,  2 Sep 2024 13:17:52 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
	20240902041752epcas2p12a06fa12d412aa6ce9a03ccb588abcf5~xUlh4nUzS2159921599epcas2p1w;
	Mon,  2 Sep 2024 04:17:52 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240902041752epsmtrp1c8d51b8d4f900d844185b0ab7f507e33~xUlh2pkVv3022030220epsmtrp15;
	Mon,  2 Sep 2024 04:17:52 +0000 (GMT)
X-AuditID: b6c32a47-ea1fa7000000271c-df-66d53c707abe
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	4A.1E.07567.07C35D66; Mon,  2 Sep 2024 13:17:52 +0900 (KST)
Received: from rack03.dsn.sec.samsung.com (unknown [10.229.95.126]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240902041751epsmtip2c8e7ed1acf4c1fea5b6fed398b042cdd~xUlhoDYLT0320303203epsmtip2K;
	Mon,  2 Sep 2024 04:17:51 +0000 (GMT)
From: Kiwoong Kim <kwmad.kim@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	huobean@gmail.com, alim.akhtar@samsung.com, avri.altman@wdc.com,
	bvanassche@acm.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
	beanhuo@micron.com, adrian.hunter@intel.com, h10.kim@samsung.com,
	hy50.seo@samsung.com, sh425.lee@samsung.com, kwangwon.min@samsung.com,
	junwoo80.lee@samsung.com, wkon.kim@samsung.com
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RESEND PATCH v2 0/2] scsi: ufs: introduce a callback to override
 OCS value
Date: Mon,  2 Sep 2024 13:26:44 +0900
Message-Id: <cover.1725251103.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.26.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGJsWRmVeSWpSXmKPExsWy7bCmuW6BzdU0gw9NyhYnn6xhs3gwbxub
	xcufV9ksDj7sZLGY9uEns8Xf2xdZLeacbWCyWL34AYvFohvbmCx2/W1msth6YyeLxc0tR1ks
	Lu+aw2bRfX0Hm8Xy4/+YLJb+e8tisfnSNxYHQY/LV7w9ds66y+6xeM9LJo8Jiw4wenxf38Hm
	8fHpLRaPvi2rGD0+b5LzaD/QzRTAGZVtk5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hp
	Ya6kkJeYm2qr5OIToOuWmQP0i5JCWWJOKVAoILG4WEnfzqYov7QkVSEjv7jEVim1ICWnwLxA
	rzgxt7g0L10vL7XEytDAwMgUqDAhO+P07NcsBedZK3avP83YwLiLpYuRk0NCwETi3LfD7F2M
	XBxCAjsYJZY9nsgC4XxilGjZ/pANwvnGKHHo7VtGmJbWpS+ZIBJ7GSXm7G2DqvrBKPGvHaSF
	k4NNQFPi6c2pYFUiAi3MEhc2/QJLMAuoS+yacIIJxBYWCJM4MnkbWJxFQFVi7qZPYHFeAQuJ
	d/8XsEKsk5dY1PAbKi4ocXLmExaIOfISzVtnM4MskBDYwSHRN38z1EsuEr8uf4BqFpZ4dXwL
	O4QtJfGyvw3KLpZYu+MqE0RzA6PE6lenoRLGErOetQM9ygG0QVNi/S59EFNCQFniyC2ovXwS
	HYf/skOEeSU62oQgGpUlfk2aDA0hSYmZN+9ADfSQ2DarEewaIYFYiXezN7JPYJSfheSbWUi+
	mYWwdwEj8ypGsdSC4tz01GKjAmN4tCbn525iBCdoLfcdjDPeftA7xMjEwXiIUYKDWUmEd+me
	i2lCvCmJlVWpRfnxRaU5qcWHGE2B4TuRWUo0OR+YI/JK4g1NLA1MzMwMzY1MDcyVxHnvtc5N
	ERJITyxJzU5NLUgtgulj4uCUamBy/dyxMfioug6XxulnK7TCdatVV749E9q/5AHrtk5voVPX
	AlxZL8lt+s6ywnvp2coTDbs3dbHW7hAX6/rZx+80W2rfm4dfzzP2Jt1Zt9WEpVFFq/S5hIJ6
	u/lOw2SxK82alddZX8x1ZWkuKTbaqrbtdm2QnBh/q4LM7X0Ki5leG5SfWvswlM3sjVnf3GTu
	sD2uHKKeT5frzLB9oD7j/Du1+7dOO09cMf/1g5z7kRq2+vcKEsK3tbHxnvoyZWsx51GOv+7X
	7k9K/fCygKG6+svDycoszicMtB8aLhBbEmfasiBf+6hZgkVOW8g6MxONI5FOW75n80z84mZu
	HNG9bJ/o2fy4xCOGT5717ujbbqzEUpyRaKjFXFScCABwgjpsWQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsWy7bCSvG6BzdU0g1nTWS1OPlnDZvFg3jY2
	i5c/r7JZHHzYyWIx7cNPZou/ty+yWsw528BksXrxAxaLRTe2MVns+tvMZLH1xk4Wi5tbjrJY
	XN41h82i+/oONovlx/8xWSz995bFYvOlbywOgh6Xr3h77Jx1l91j8Z6XTB4TFh1g9Pi+voPN
	4+PTWywefVtWMXp83iTn0X6gmymAM4rLJiU1J7MstUjfLoEr4/Ts1ywF51krdq8/zdjAuIul
	i5GTQ0LARKJ16UumLkYuDiGB3YwSb073sEMkJCVO7HzOCGELS9xvOcIKYgsJfGOUWPFJG8Rm
	E9CUeHpzKliziMAMZomGzq3MIAlmAXWJXRNOMIHYwgIhEnOfrGcDsVkEVCXmbvoEFucVsJB4
	938BK8QCeYlFDb+h4oISJ2c+YYGYIy/RvHU28wRGvllIUrOQpBYwMq1ilEwtKM5Nz002LDDM
	Sy3XK07MLS7NS9dLzs/dxAiOGC2NHYz35v/TO8TIxMF4iFGCg1lJhHfpnotpQrwpiZVVqUX5
	8UWlOanFhxilOViUxHkNZ8xOERJITyxJzU5NLUgtgskycXBKNTAxhrVm3DxTcfeT2P9V+zpk
	BaewyM/t7Ko6XZIoMzt3AWuggGffz7PqZr6MTqH+W8xZZMp26Mdrnz4b42kWOLVCUNKOr2Uy
	9+ovX86+PhXsw3mhwMjr65qGhVoMHWzvTeS/zea6tMfOpscwZ1nYLcv2r7kWe1Ij3+/IPrbU
	OTQ2/cbuNSEBWnXTc06tS0/60t/Ud8X0wFaXm1p5pR9mhDu9mHakWj3jl1B/b/TqrKrpe1dN
	Nlw0Q71sgfKuL18FvrJVLttYNLX923zVadtEH34UW8iguy/5dcxt1WOO1xUcFLUnqSQyzZ7C
	2ue5dFGK3/rQX29dZ5bd3RkgGff2aEFM0O+MMG7vXXwfHvEvMVZiKc5INNRiLipOBAAnjQu3
	BwMAAA==
X-CMS-MailID: 20240902041752epcas2p12a06fa12d412aa6ce9a03ccb588abcf5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240902041752epcas2p12a06fa12d412aa6ce9a03ccb588abcf5
References: <CGME20240902041752epcas2p12a06fa12d412aa6ce9a03ccb588abcf5@epcas2p1.samsung.com>

I send this again adding more reviewers.

UFSHCI defines OCS values but doesn't specify what exact
conditions raise them. So I think it needs another callback
to replace the original OCS value with the value that works
the way you want.

v1 -> v2: fix build error for arguments

Kiwoong Kim (2):
  scsi: ufs: core: introduce override_cqe_ocs
  scsi: ufs: ufs-exynos: implement override_cqe_ocs

 drivers/ufs/core/ufshcd-priv.h |  9 +++++++++
 drivers/ufs/core/ufshcd.c      | 11 +++++++----
 drivers/ufs/host/ufs-exynos.c  |  8 ++++++++
 include/ufs/ufshcd.h           |  1 +
 4 files changed, 25 insertions(+), 4 deletions(-)


base-commit: 3ba963597d19d88eb06b50af8e8757abbdc9035b
-- 
2.26.0

