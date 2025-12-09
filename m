Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F367B35972
	for <linux-scsi@vger.kernel.org>; Tue,  9 Dec 2025 02:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765249160; cv=fail; b=Pv/65iD+xHwx0X5qn/hG2X+20l2WiRz1BJ2EoOsHMAwSTxplzYseLRDr0tegnb8RfhDmzmmlvgVQNSdt4R/zBsb/BEAa8MVhpGr8JkRA2NPYIBmCYqvW8NPnhnvj044j2ha/sknDgqMvpnEeb8RQhLGPWji2gjV4vzs3EOjBuBc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765249160; c=relaxed/simple;
	bh=93eBog37+KwXGZNhyWTrDwfwdxiuw9FUxfaURT41kg4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ZJKQDU9qZlni93S+T1a9DcLGG0HSH1Hb1kDvtaH49steSVGxDPARCQJpteo2YdY9kv/DpR9F3hFVHSEzcQ5MZ/YT6Jg1Y/w+V7BjyQuxny7MXi8w1OCYt6p1LcwOVFTNbUyBUlYAmUL6m1YzwdRygLainLISdcgWczlkric9f8I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=O/BfjxAK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mwFpEwiB; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O/BfjxAK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mwFpEwiB"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B92pcNj3911295;
	Tue, 9 Dec 2025 02:59:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=z1jKf3SHyWvNdpaPeJ
	WTV9eEjcpIS8f2curbvg+t3Tg=; b=O/BfjxAKe1fCuVwFxTVYXoLVPvs54IcLdP
	QrRbcFJ0Um1KUUKUhxmeseaQg8CbdsAupOLuRFVJjtmfn+W8EhHkbmlGLmoqQy92
	4bttE6tSWuS2YoBPiArGnf0G63gOwLEwosUu6sWKc4lstZPfPqMAxmFeQFRqjI9O
	1J91y3fa6lObuKQQeQ5qxMKFYhHMgfXXd5kXlxFUXgta6g35LtHIzK4l7r3Jx7AD
	2DcVcKj+P4RS1AdgAkA7f0n6eQ1vG39ld4LEa9gBHnvYGi0SCSXIjMSnv7x20vNR
	UiywgSXpAPinqyh2JlGLQzRnsC8l5sKM4gh+EK9D8Fo35s3lpU/Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4axbbu804k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Dec 2025 02:59:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B90j8S5020798;
	Tue, 9 Dec 2025 02:59:03 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012008.outbound.protection.outlook.com [52.101.43.8])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4avax8hk6t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Dec 2025 02:59:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oaO7qUXztEkNg/uKbNaJY98dnFyE6YHLm+nmz213PW5zoh58hi1hJCKHq+JA6EimtSExJBIuMzZnhCgQL71bg9pYYdEeTEY99lDNMbKtgIUXofxJL4qUgvpmLfRT7APlIEevmH9lRqUwSEDQHvvdRnEPLd/YUHokRGqhSWzQnZlNCW3e9h2X6zCF51ravhGQN+njhtJR+yAZqB7SO9RD6thTUdGSIV5JXBcdUvDjLg83Z3/3NUJBKceQHBQKO/bh0jSn5RvXRrPiz4uMT4QxDdQAWuO+vyvgu+Suv/wnaNgK2CHkhmpEPZ2fcH1K2IKyG2AI+ea7jJWKgD7WVXLjXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z1jKf3SHyWvNdpaPeJWTV9eEjcpIS8f2curbvg+t3Tg=;
 b=dze+vvu7EEx2N0C8w1YZrlXJdnF98iMwsRD8YUqfCL409FrSqAC5iCNbNkkvRP3wtmpaNcI2IqrOaQpoywh6b+ekjxDtU+ycgSUJFWv/P+yOqhSlWbdvVEz0fCY6KqUMx7ijfKpkYmawY42HwtrLoV/QgCWAQdZkoEmXHt4FMHJ1Zx+JPpb3Rp6RHA14yg34+6LUxcjDEbS8j9u5qZJ/b675bhcgEcCOXuuCC0Qz+osOuso7o1kAZphcNB8A30FM+gEvyMyPi2v7Pbl/Ve0ymH1ZHCWEpA9iawHIcnBTnRiVAiNCGiirikjvUlE8QcOymZt3BAhXsvHYgNSczh4NxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z1jKf3SHyWvNdpaPeJWTV9eEjcpIS8f2curbvg+t3Tg=;
 b=mwFpEwiBxs5zV0MKUs7kdQMr/4Fta84oqe0h0bq+bE/mBTYqaI6H3FcjyJTdwcvaaXean8ioP+BCZ7gjM1zFBguoPIAhpqOXaFw6fRjvapalF8lBiNiZqAAuDtNTczGO0iSwRptzOg5sTmrjNjkYV3Wxg1sD2KRRvBpvd94m9Uc=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA4PR10MB8517.namprd10.prod.outlook.com (2603:10b6:208:56e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.12; Tue, 9 Dec
 2025 02:59:00 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9388.013; Tue, 9 Dec 2025
 02:59:00 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Peter Wang <peter.wang@mediatek.com>,
        Nitin
 Rawat <nitin.rawat@oss.qualcomm.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        Matthias Brugger
 <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno
 <angelogioacchino.delregno@collabora.com>,
        Avri Altman
 <avri.altman@sandisk.com>, Bean Huo <beanhuo@micron.com>,
        Adrian Hunter
 <adrian.hunter@intel.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: Re: [PATCH] ufs: core: Fix an error handler crash
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251204170457.994851-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Thu, 4 Dec 2025 07:04:52 -1000")
Organization: Oracle Corporation
Message-ID: <yq1ikegpdhx.fsf@ca-mkp.ca.oracle.com>
References: <20251204170457.994851-1-bvanassche@acm.org>
Date: Mon, 08 Dec 2025 21:58:58 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0044.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:86::23) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA4PR10MB8517:EE_
X-MS-Office365-Filtering-Correlation-Id: 591e6b6b-7d3e-40af-b22a-08de36cee75c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1lnqs+QdyhSHL9bEl63ssvygsxZ0CwosiNY1UXFhhGrWx7v04qb8EMzcycED?=
 =?us-ascii?Q?hhsRaBipdajYTBYc0psPxYQs8zI/tWBSXZdUxkwTYl1prhpk4BOUs8sRh7L2?=
 =?us-ascii?Q?EzKuiF1OejEwgA9dM5+QeZ4hDEXyzLrqUxpT34teL/u/Zyn0yhEMzgFbMWZV?=
 =?us-ascii?Q?pJN2ic8mOfyL2Lvx4PhcmSiHCAI2b+oNp2h6dUM788a+lYwsYgUyJrwRoFRU?=
 =?us-ascii?Q?y2H5fbXnJKjbKkm5MyCFYylfdhi5+u4fnhvTAx1weyKqHP4MmgIPNI+M1VD7?=
 =?us-ascii?Q?udbbL2HH3SPC6SjaTDnKZY9lDn8JUdYlcbu5VSyWpspGjT0Hacwyerqh2Vgd?=
 =?us-ascii?Q?ivhDKrBQqS85Q6hB2QZZktqrKFF4avQaR/YdxQS/RFwVAEbhrIGAtP6EglSZ?=
 =?us-ascii?Q?bcl13fQVe80H5n3eM0Y9JeLnSI6wHxvyGpD7KMgZ8Gej//jBiyxUc+K5rzy1?=
 =?us-ascii?Q?Ah9ZMGEyOV8xtZKl+EIFNp4cIFCkEAkQVssX/71Km/wn1AhEuxDROCZCooVw?=
 =?us-ascii?Q?bInUvwS8jm6zUiIIt+0p/GR2/T1s0cXJj0766MkAYQA+TvrNBN5Lw1j8E/s9?=
 =?us-ascii?Q?1QX3U1S3DsrBl/rH69x7kZTsMCd2co/t674vdeVWXYe35vl4dRSaDztMuURx?=
 =?us-ascii?Q?NtWlHarCiiraqD3cq4Mt4A0/L8XkMaJmw5wv+dfjwyyGJEHlfU79r7sfyrAg?=
 =?us-ascii?Q?ptwU+CURNXA8xe222uz+pgGjbMDCy3HlShk8V64rwsDE59EvzeFy5HkdvDLS?=
 =?us-ascii?Q?CBe/ENoWiXEkCDW8PvjPoqSGlZunC4crwDTUrexj//t1YX6y3YVrztWofHMn?=
 =?us-ascii?Q?4nArB8P4XfaMAg1bXsKL9Rl2ydRHvCMFXC/pPRnYXdgoG45d9vz/wVGkUv9L?=
 =?us-ascii?Q?Udf61zQa15I9UYnvfBJLteXYf7L759Pt/8u01AbKAjf/DtYnh7YCPt3866h4?=
 =?us-ascii?Q?4Lbtjdogt52mM6iSJg9XQKzFKHzP91fh5bz6s4Txb5vVaKDfvfFk8CL+b7AK?=
 =?us-ascii?Q?T3Qrk1VQQDAqULi2yi1OPBJea3677p815tFaqOHqR7BlDFsAce180T1FNzwz?=
 =?us-ascii?Q?SCBRDIP2W2xiWMnXaGwghUXbQiQRalo5ul3E3n5qrobt36f7/1B2Oa9H12TQ?=
 =?us-ascii?Q?TQooNO/ONvJ0dFkTImC9iU1na3opy/5a3CYvbL0ol0quoG7Bg7SjHFg0LNNe?=
 =?us-ascii?Q?E1hbGUJucpG76yDK8nR14cmQBqwUtLF3oB/Hs2lYQPYWPz+5S0NtSxWKb7qi?=
 =?us-ascii?Q?YbqQoLR31wuaxvpEUwc8CDqsAJSGIkHwurjCFhnuUxTdUkOzU2V8kyRqqyjh?=
 =?us-ascii?Q?kG01Sm/sEJj+51kP5nNypKn7EAFKx/PeKUHX0NzHHbJ/yq52WRNqnbObMHGV?=
 =?us-ascii?Q?0rcQh+Bqg13f/nNN/k13eN0yOrFrruttvxzWZ435/optvDu1ooC248n3GKSL?=
 =?us-ascii?Q?WVTf+zGZrFe5O7pYi4p0Onp06PDvZ6P2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?856winFzI4Md3IpsbUj9wZvtYSi6ge0XXcQSGntv6stJddbTsw13dZq65ZOS?=
 =?us-ascii?Q?egiNfypxSgKBbUnQ/wOEGe3vnCnZYG+tvitKRuyQUHoX2+6r57/3W6uh5qJ7?=
 =?us-ascii?Q?yL4t7YHoniSX4zgPQctITNnAZiQYOTjG/LyP2AtMxgov7k47ebUBa9vHI4D/?=
 =?us-ascii?Q?O5qhYXhWaE80agLYrJAvlYFUBX/nGfNeRXGGDgU+n03PAqitt1kB4Vt/DLHy?=
 =?us-ascii?Q?qfcynLSJ6tb3UCI9TWnMXQvzX66kmOdY/ojxEaZx3GWoDwc3lgolp64FAdE7?=
 =?us-ascii?Q?C8FTfP5Qu03S/LPyOdDyIOihAOeQ3N2/EaBTUbYfL0spwYOMetuDjw/OmSju?=
 =?us-ascii?Q?z7wU0cyqbcAmRtvak8uZTOWroPjAj/gqIZ2LM9jdhMZbZ/bzOSqVFrzROr13?=
 =?us-ascii?Q?qpaVSX8vKBZDQxRPLrRKjzj3+KTijhWdfZvrHu5gUFnj2s/TB2dN9thISUGB?=
 =?us-ascii?Q?t343vIHHH7iH4XIy2a+NR6JVltp8SbeXaKS8vY/zO0JqOaIgjdOw16/KizWa?=
 =?us-ascii?Q?U2HKn4wv/zr//ch4oG0OtWVVYq4cAcA/ZnqCfq6bfPQkemA4HfOp3cUE/C5A?=
 =?us-ascii?Q?TvwFD+aAIr3ipWDKYPLsorLBok2geeFVysBRJD5BYdvb6Yi0tCKDCauN+71Y?=
 =?us-ascii?Q?4LsQ5mJrMBFjC3et+x7pUzMLEKr73prvXU+3IO85Wn28AafiWkfX4gdWY5xY?=
 =?us-ascii?Q?nyxNd2LKrp9+1+E/XN7g1ipjSE/g1SWhAkkOlueycGZHYFEkOR/ES/pF/HH8?=
 =?us-ascii?Q?+dFgJDpNLsHrVk1VNMkIFihxSI6MNxt8b0ZXj/UIxIhzNCUbDRWGpm615fje?=
 =?us-ascii?Q?CykVzzcoSKp4rJRaWXEj5uI30UOYHxjOW2MMN979TNxsmv4b+P+7+hd/BI+R?=
 =?us-ascii?Q?ypbQwQexFUg7kVFeL6rKyA8i9IzIRNlD7wTMYWBgZADk99AENoSRtOykJ9q3?=
 =?us-ascii?Q?0GuLRTxlr1Ts6YJudP7wnP2vq83sx6G++WoEb88G/qRkvswIGV0F6vXmTX8s?=
 =?us-ascii?Q?AgYsOXgM0K8aPbP8ZhOkzJ8Tohk0CxqXg7ZqWGcHyl9tSGhQ3jIYaSZzqPLQ?=
 =?us-ascii?Q?WSsGlSH0O0WNa3FSvrQvgkKLfhVCbNwyru8T1EkW/OUC7hO+oQptuEZ8vMWj?=
 =?us-ascii?Q?Rq38LOQMTSMCV+KrTV1WaLTxbWeg8dgSAYYVkyPd+w65UHaoSs3958ys7r3Q?=
 =?us-ascii?Q?3cB9vRfEZnarzCWDE4xKtvJ5U/Qf7q149HXhN+NPVLj/FIg2pFQNGU4hPV0B?=
 =?us-ascii?Q?F6wod0ddJ/hN3l6I34VULeUvOifv1Hw+zS5kdXfHY9Jbx+Yz+K6xFwtoZQiw?=
 =?us-ascii?Q?6qiJ+bfoDZ6ch1/aXx7SZjlgaGNke9n+sOiF5CkdDxZI6Q1YSTanbS9QY4iQ?=
 =?us-ascii?Q?OAwM2xDSMT5oWXRCFF4JCfXu8esZXsqCC40PIdpMQLRCq9cQpAfiGatVLblF?=
 =?us-ascii?Q?0LxYkedg73fwJB9Dw6AbvOzESBVBkqKR/26fanMyXeD7S/j6BOzcH7TBVXuv?=
 =?us-ascii?Q?0HeV+yFUkS2znBSetOWsxLjlwFjDmK9If2pH2HWji6s7a58dgpv6EvRnBmGY?=
 =?us-ascii?Q?9kmuyXEGZbc8AT/+2CfMKw8M0PX+qG4boTy1Zq8+e/t4D+j2bSp2QOY7VFOh?=
 =?us-ascii?Q?0Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0aEaHW1TfGtVmqksCqy2yMdxQQalz3TuhI6qN4Gh2+b9CaEtdaWJiWQ5USzSOdz9iwC2CfvbgIlgP2IvaRkEYcfQvqdtuNJoH1AnIBV0vPzf6bWZGXmnbWN4hDUkvGTMoE/69hyzFmP+6ZTFwMpG6EA88aW3j5YcoFoyEl+Ofu5uXkReIUOyTVK1eIRRKtSOWO0CzoCeofNBKbXWbJFtGRxKlGGMkFsQ2Vukh9hh4F6keLvtTzsiFBe/kkMboWarZsD7/Hcj+JmeRygwKGnhQ9is8Vcq/3Z3tk7iDzP6qqG0Uz3am6qaSkDnXdbR9XLSO04wBbkXXnHbVk9ZyRDLeqWtrA5BgQ1xMTqDkkmsOLO1HZoYRdRezzjn9+GsgMdfvkZpN/0qeTcZoaCqC+yt5BPDwSEO7M+tEOvpNpsyRWO38ZPNO2dBOqbwT6+lCSEnwNsf/khYBimuqfv+aw84/A98gL4esaqbOal/vLlSn9y0B0SZsZU8n9RjoSerdACql1tngL4yWLQqXZTICmWb442SPM4NvNisFhm7TwX4kWvtmyE4CxQ22YlME700pbRNhfh/aIXMmR+Q6eOZOzrrN3nmuH13QkYwBZ2MQodp0yM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 591e6b6b-7d3e-40af-b22a-08de36cee75c
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 02:59:00.7287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WCNVxKcQ9PK9+pDcrFkfRmCglvQl1jFvRBLqQ7ENvlXsJjr6krVczToxboxAMF1QKZ9/r2d/JTNcJCCGOjMmKc+FdrGGLCx1Q1uYF+5adcc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8517
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-08_07,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=796
 bulkscore=0 spamscore=0 phishscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2512090021
X-Proofpoint-ORIG-GUID: h9pH-NKWyCjuULMYBdg8uy4WETNrFlDp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA5MDAyMCBTYWx0ZWRfX2g41jTz7crV5
 ntECdzW6veLJ45Ka/hF0ry4hLt30iDEBu6q+mSuEGQrax8DJNclxlCK6OVLXWz2EUdlbXC7nb9x
 dF186pjW7HcCe/0dQq/50vic0hvO6EV6tktr7PkuRJGLPQtiLbpNP+LaYBiMN3vI22JgTstPfrZ
 CTe5mGaAW9xqm3agr//eYfOP3czirCYrvSq4mCWuG7avI7vCyJQGYcEuqkFaPSCa3wIRkCPhM46
 cAzQC1XE2hhmb8nTTPGBgzoj7Kkd1b4VqSyp7gqUHb2/PajS6RSwZzuBxABYDh9RBvn3F9FnVpD
 mJvcnbBuMo5kpgNNEN5OI7mGKp0YlFpqVUjP/o6Ka/dg78VfjJFAHMEGY410kIxWkdpIbPzts9h
 h6f9FL88tkSYf+hH9HSz1umrKMp4YA==
X-Authority-Analysis: v=2.4 cv=TvPrRTXh c=1 sm=1 tr=0 ts=69379078 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=APdTsy1mPjVvL4qEmPYA:9
X-Proofpoint-GUID: h9pH-NKWyCjuULMYBdg8uy4WETNrFlDp


Bart,

> The UFS error handler may be activated before SCSI scanning has
> started and hence before hba->ufs_device_wlun has been set. Check the
> hba->ufs_device_wlun pointer before using it.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
