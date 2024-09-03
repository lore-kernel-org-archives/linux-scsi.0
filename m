Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698F62A1DC;
	Tue,  3 Sep 2024 15:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725376126; cv=fail; b=h86+QsF6gJF7ZscVd8fefU00tC3ZqfFJpVS8CyzoLb/VAZQNkaiAVqwHlkKfL0ZwTjKN0s8/gAgShqxYIUn8oLgnHoPjWAhBLjE/Nt5/q2veLgZxOptzEVx5wotGG2Nh7QuO/y64YRyjYRX2IJpwdBDoPKZAEPI72gG89OlOGCc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725376126; c=relaxed/simple;
	bh=uFUcIH1mxHbWtQ1NWzSW1d7YNITH2v3ky5rCBe3aUp8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=co/7Ej8BUD3BzKKTnC85C1Lym5B+xSbdOaCyGwBHA6QHkqwS4/KGovBV5cbuTm3SI01m91OvDk3IYEn9hGiCHqC6TIW2cJa2j2lQZIPCMJTp9CmgFQmmyFrPYgW1jWw1SarIolfc4huVQkoY/ClgQahP2DITw7c2a+rFOZL8v8Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DR5WOH3z; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MKMYZ2B9; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DR5WOH3z";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MKMYZ2B9"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 483Eonsv016382;
	Tue, 3 Sep 2024 15:08:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=ZwuElY6cPraMbfOb4ODQTnyC6NGt8UEKPTW5tHUTjWo=; b=
	DR5WOH3zafDBpGh1hJUZ1QmqvBinvTwiLKb2OXAwlwrw1jSr2ie+OXEgweBKiwoe
	q/KRIO1hQgQ3OCgGiP+qKO0ySZEMsJh76dQELzwAg/lnXt/lhuOghFbO93/fATWg
	T5jjI0K1rMu8/2A+F33K3f0KTxGpq6bTg7FSrCme4MPLvrMO6De3j/wJYMuAQqyU
	OxAVaKzHcHR6+mA4D3hYNgnC7w6+EgPJ31azlulyxwKHSltp6SxvRfnj1lEzMAqF
	TYTbt3IizVoIu8GjDKmI8bdyJ5F7m6sytr6C2Ee67HEcYEnaNC8jZPCJXm9ZcU7t
	vLo9oOu/lWI46f1/LKMu9Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41dvu794td-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Sep 2024 15:08:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 483Esjlp032636;
	Tue, 3 Sep 2024 15:08:21 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41bsm9151j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Sep 2024 15:08:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A2lhPthW1F2kC5Ic4T++OuyDYWkcJ5qyMfx0SryFhk6zo7TSVrxvneJ8wlPhr5/p+0rnhPCGGZzhsAqFeNK33muyCRx1Q/7MhnEBXmvuyhpeF/661CBbhbdkmGy371YFKmLthyD+DNV3v6cCH1avdeERgR/lnKAv9ggpRrx4BeibKcx/bE3/Y+xUn6Ugg6J0i0ZeEu5Lwc2W1TrLzMKFaeR5JRGHxInErjsX/hLr1aB2RbBdc3kmH2OIYkzyL4y9ZP7qDmCpZrK8WhRtKeIHgAk+rLa/K/T9F2EnXTUEvJP9s2QLeWccOiRWoDUS3/vMQDHmoOo5UIh8drIhCYAjZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZwuElY6cPraMbfOb4ODQTnyC6NGt8UEKPTW5tHUTjWo=;
 b=sJbKTRU+EMP5+kuzotZGEjJl4ysOjAYWhmuQ27xqjbVlXAeS0gk8fSg+k8kKOAt7oqQ34sdQngVbf+fsdNCNH5HbdwrightwDzbROezWGkA7CMV9v1Mj0J9r1Nndt7ShJo3HZMxOR2tPUnnghK7sHdG4SP4vYdrOjrGNhPuUhn7OcRGH6G//d+OjM36YCq9Ig2Cf45r4iyaavMcz9nYMfmrzrvnfoYYROLi+FA/yQbjfseyFvq7YcPv6bc7dSmLUeeBB/hQ8enBS0P9Jnp/MoHpP2byZ4e0n44Q1gtUsQ9MflcHkYkg5GoJCpfZNxgZf2Yf3PcoTG+AA3U3iQbPJjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZwuElY6cPraMbfOb4ODQTnyC6NGt8UEKPTW5tHUTjWo=;
 b=MKMYZ2B91A/4vYOuDjvg+WaI9OxDTyzKw1pM5lnQQae9M6gmuxC1N26ZeLLANH2q/Q09gsJoG8FM5oLXi4F4gsznTT0L9Q6zutdgGOdZyEAJ1hUTsVEIxSDt9OvG3Bf+IuWr2NRarGZ26N/iXVkLb7rDsfwBi+oWaP9gahpQ8CA=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by LV3PR10MB8105.namprd10.prod.outlook.com (2603:10b6:408:28d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24; Tue, 3 Sep
 2024 15:08:15 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2%3]) with mapi id 15.20.7918.012; Tue, 3 Sep 2024
 15:08:15 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, kbusch@kernel.org,
        hch@lst.de, sagi@grimberg.me, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC 1/4] block: Make bdev_can_atomic_write() robust against mis-aligned bdev size
Date: Tue,  3 Sep 2024 15:07:45 +0000
Message-Id: <20240903150748.2179966-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240903150748.2179966-1-john.g.garry@oracle.com>
References: <20240903150748.2179966-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0007.prod.exchangelabs.com (2603:10b6:a02:80::20)
 To CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR10MB4312:EE_|LV3PR10MB8105:EE_
X-MS-Office365-Filtering-Correlation-Id: bb6a53c5-dffe-4bf6-9f3e-08dccc2a3c6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QBec7ed/aap4nKeBTOLx4haXTP8brEqsX6hgzooRkos1JmyGtL+Bv6IS0LVf?=
 =?us-ascii?Q?3oOjL1H/0TmzpxTyCHRJEiLya67aSwKuLjnx5Ppj0G5JzbLNBtBrJToV5bsO?=
 =?us-ascii?Q?/NnSFgFn0NlIVuiBkI1ZyC6qvLRay9Q8vZxpC5YM0vTBr3veiGAswqAGIYnt?=
 =?us-ascii?Q?s7ax6uQuQFiALNJNGfn/ahVZIWMH5YSNgl0n1WCPvw5Bs6XpdZr9r8FsIFHz?=
 =?us-ascii?Q?UmozOPzJH7J5tr7A5a8GgGZIz9A3HIgSrCKeZrZPwQWWuC5aY+KHJJE4jnJs?=
 =?us-ascii?Q?GvP78EShlM+/tlBAZ45mmNRS2TLPpbZcH9noLG4MCUJYD77LOsrb1FWt0wP1?=
 =?us-ascii?Q?2HxEJoBmT6AK7Z2s/n327LzDeNu5e03MK9neb5CKdWBiBX6ivYdAdodDlKYO?=
 =?us-ascii?Q?OLCJYydAhqJzUSxUaLV9xNAcMesMQOmX5akg7Ye2mCvosbiOg0JSL7PEZmr7?=
 =?us-ascii?Q?i2qybm65zog/LjlPO5aVO2yFoQmL0+SvnNNexK4GIW0IrClWG78Ns3VFJYr+?=
 =?us-ascii?Q?Ydm/fALEC70oY/P/Us4ac3o9c4008SYFU6bxQ8EF0u2PHTGJAQD7e+SXbtFs?=
 =?us-ascii?Q?Eb4oMI4f0dMZ3trNrsr6If+SgGZYdFHQPq8If0Jnh6M/7w4WzMfHz98iEEDc?=
 =?us-ascii?Q?cf+v3JKn4P20Y1RMyK5D5pObEyWWHBfZ+TyKgSoL1bxFkIHoG0G4m00LQvFJ?=
 =?us-ascii?Q?XjtAwsoIZEtOjV2Pdc2P+gHyI+AOm4Q3qtym9ikU1escCxhsmvPxS/464K24?=
 =?us-ascii?Q?09FQZyF999huVBssTWitIVbGXcgE8x4JGZJHtLBLOCgp5HD9sBVF6N+nKsZf?=
 =?us-ascii?Q?A7Kopy8tmEuTjV8ZsKUugfa0GSkY2zK2zvceXagaTW2orLFz6pRsS2wxpiCe?=
 =?us-ascii?Q?pEs5XobmOR65EHpdS3c/j1FG+Jcg2i4rTHArVHjzT5X0h9H3LCXOi6DqqOhJ?=
 =?us-ascii?Q?1iy7QTv5Zd76/IaxL80JVATrWDR+XZX2bVH+/Mvwf/uOKNiAVzcMwCpBwzu/?=
 =?us-ascii?Q?m1vD0nHxK2C3GnfmL87p+P3fmJqIHJ6L7y6axy6yu8RqKNyTZ/NyhLa3rVqR?=
 =?us-ascii?Q?sgNxw5vq6VUB4qvsN4iEXF4Sx7jdTfxzpvA6fRdEN41A82OMQNdlYd1Tji8i?=
 =?us-ascii?Q?ux3l8Xzdk2bW0RJPsyNhLaGCkmSQ/J1u/UK4ue3o1diYN5WrAERQdG5zAzej?=
 =?us-ascii?Q?l+dTzzMifDVCOFOUybZJUITtyya5HXqTVkgX+Fc1+9UhNSUlXpZNBICi2mWm?=
 =?us-ascii?Q?HB+B6m+yBCrr3fLGtBVaolosXB/pydJii4CS4Ok66eTzEabQL4/KEn/wBjaL?=
 =?us-ascii?Q?G+09qcrLcMLyDzj3n+O2G4AUau5eUGUwTSWLLmISISi+/Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/fHXPWuc77n5ZXtsZPq+n9R0eIQfwnFlFuDhVN5sSyjFev5p5IjvoXcqPtYh?=
 =?us-ascii?Q?m/+cOAOSCKlKiT6At1ccQo/u721Kv/S9nao3N3wQUn36UuZ43r138e7YYd1z?=
 =?us-ascii?Q?S6XaIU79q71ARdl92j0xF3QZlSF6hfnjF01/2KPwmvH/Ido6GVf8g3KmsmEf?=
 =?us-ascii?Q?5ETu5pYh2ihleiFBGZdxyioBc17awl5c19837PiSZKKERsx6ykAuaVqUGxTP?=
 =?us-ascii?Q?mT81TgUa3Ln/jWHhGHyctwTquGtwHDR2FzeDydmrXT+1K7I0s/1kIqowxAcV?=
 =?us-ascii?Q?inwgoCjyg0brw5tW/15AChOu8OkWgH6iaZOp/27lEPT9hKmyFoo+19i7lqni?=
 =?us-ascii?Q?ShBzuByxCILNKFfIiiUOie6xCzibZ2CTGP5Rw9IgRby/IZeitJ613WbVtYOk?=
 =?us-ascii?Q?ALGBJ46EAIU74eAvNt3L2ZSQSgdIosGXWKzLYuZyazY14L2c6CjR4UiUUiye?=
 =?us-ascii?Q?SUXD64MPIHX279lDdDgToCXBoGkPVJ15Kk5nJsf7zllN2sVLd1/BTjhsXTCP?=
 =?us-ascii?Q?hvx9A5cTTMvEc9H0xCVqKGmybuWwytiurfQJ/h6a1Adir86TZ5FsVn0gjXa4?=
 =?us-ascii?Q?PdBnXoac4wbuLp+uIF89u5/rkAvxS4mjpqpIM36aEYm5vcNvafIEQ2BimZmp?=
 =?us-ascii?Q?vaBSb9fDWDYl//XXIh3XmpiFnBlMLO4BijKG9yho/ZML/gcyyx2DiKtoFRbL?=
 =?us-ascii?Q?usgj2RWjs5QrI2etYkpxm3mk6rQQwaQH6S4wHl2BUaw0E7O+dW7uyfNXrLGF?=
 =?us-ascii?Q?rEywDiCu6ladhY3ul7I1/HWeIFh1LgVxQhKSHkcEopmAlXjgq5Tef2ZiFQdR?=
 =?us-ascii?Q?JSjHMo/aPY11eGTlesQKy2OANnFkPtCNu/YWLSAVkxUZ7fZm+XZoiJwXNXKC?=
 =?us-ascii?Q?szdo0OloOmzeAPi4/I7NoCRXR/DpLRuRrlVSD4Nm28YFKe8azEDFpOcqDKun?=
 =?us-ascii?Q?YXSFi638Xig+EfGNM1M+aybJjkHh6hjoQRnn/QH0L5D2bMgbakDV/QHdhitb?=
 =?us-ascii?Q?44BmSH7fqAIM3725a/Eaj5Ld64M+uat+A1q+KXOENrSmUYcX7NYnLsr6huNq?=
 =?us-ascii?Q?tPf/VhELVjh7G0h/DgTHGGf0GcSIrJSY+VmIu9xHnx7IZyiUpHIbYeczPuc4?=
 =?us-ascii?Q?UNx/OMUWQfh5OgocI8z1wc6VdhlrP8bc/W0f1YF3MZvsiyJL/gqlL++yZfx6?=
 =?us-ascii?Q?mEVEgnwXpO+r4BP2of2GzMcgK7/cbM1VaQOdRQbHkJDT+odK8K/k3IV65rx8?=
 =?us-ascii?Q?iJYmln4Rcmqm4ogaEci0ADoMgOr4eEqU3i9KWfjlA84+M9gwVNLBmNWOgQl2?=
 =?us-ascii?Q?EP+azOY5y4a9H0GmhVFfwRkvwqCzL2eWNkryIyUIZk0fsR2AsmBVMvC69lJg?=
 =?us-ascii?Q?lIi2MQGlZrEd3H0ZbG1MwuXZMgvVrrq0J4OnlnTQxa5b+wQYus8wLYZjOHL9?=
 =?us-ascii?Q?uzka8bohTidlfZwwJQsw6IwETCMmEmE6gaVWHifBqS9GA8K+BgwJmjroAyyg?=
 =?us-ascii?Q?jhat3zGwnWHblvjh9tobAUNdEnZ8c1c/FtZga6ze2jbvedawdc+cPUNqHXNO?=
 =?us-ascii?Q?mmlNaMRkAOAVduA4P2D1ERjLRC7EHm9fuu2vzdqxcm2QiRh3RGhVPfANg/R9?=
 =?us-ascii?Q?aw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3Vj91614anYD22Tmunw1KRdnzCFd0rFJUBtt2mUOD/M0//QjLsw1MDjfVklgZy+6+tN5xWiONEaRe6hJmqU20GVLpK0KN5+MgJ5ZjqiQSOxlvPLCaHwQpicfV/b/biBmSxEirx5cQDBs4oBmQvxk9McxxsTdwGXPgyuxN5u3UDmggKSqNYE46zq5/f9n/WMZdYk3L64vTCULZ90RQfIXPjWTTzjWOtBj+GY13H5DCLYaFBVs8ekee/tZSTXCkvJdcBu2TkvN7Mup0SSsIbrlpjHq1w30VeQ0DWTeXmiwOOS6v4tr8O6Epkxy0uHYrKFpLNX8rhmJ/489/YhqoQIdsuwOhmJ2yV9UZU+36tuIoJa8fRrQ1ITfVCE1FctpmVYGpFvp0eb4wNeKxJytxeCLacVP9TxbF2Q/S/2i76slRyssySBEhK8iINHE96WhD+sdbRqBLA6NK4xBG/KLNQ+FSS4kyMdrhzYDiNcseTygOYbWKyisvGMYW4lgXOAWzft1JjjRZdZY31dR8Hf1R4Evq2XThhFf0v6dGpZBiJxEOq7UFTZYKzeFQI0UheQnTHG0KZcBnP26SIOlHEIveeiUSwTV8PNnf8cRYMlrCgd2i6A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb6a53c5-dffe-4bf6-9f3e-08dccc2a3c6a
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 15:08:15.5172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aSmtSurPeDqbPh3gKXPp73Mry675ygLCsDgJK1z34NXxk3ZHkbEWmFFAakTIpILNnWF68W/TJ/HKZA1TXB0Iuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8105
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-03_02,2024-09-03_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2409030123
X-Proofpoint-ORIG-GUID: n7ACQSY4gxbBcpRgTfIodtD4ENouFjRx
X-Proofpoint-GUID: n7ACQSY4gxbBcpRgTfIodtD4ENouFjRx

For bdev file operations, a write will be truncated when trying to write
past the end of the device. This could not be tolerated for an atomic
write.

Ensure that the size of the bdev matches max atomic write unit so that this
truncation would never occur.

Fixes: 9da3d1e912f3 ("block: Add core atomic write support")
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/blkdev.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index b7664d593486..af8434e391fa 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1662,6 +1662,9 @@ static inline bool bdev_can_atomic_write(struct block_device *bdev)
 	if (!limits->atomic_write_unit_min)
 		return false;
 
+	if (!IS_ALIGNED(bdev_nr_bytes(bdev), limits->atomic_write_unit_max))
+		return false;
+
 	if (bdev_is_partition(bdev)) {
 		sector_t bd_start_sect = bdev->bd_start_sect;
 		unsigned int alignment =
-- 
2.31.1

