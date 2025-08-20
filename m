Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5647C2236F7
	for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 02:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755656571; cv=fail; b=HsG0felvU6I+uXlFCRdaCgaTbusHOSRqPhDsMMWS8WdJiT174s96lYuKt2t12KxMfPGrp0EVAvjkTPxIX3mKvYedySJh1mG/qAenziobTq3xswkFqf5G8MPvwaDIO9bc0UIh7UGyhQDSDuuqQwlJTzXJ7yosA5xYRKCD4ZCq6tQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755656571; c=relaxed/simple;
	bh=UngV2UZRCVD7F0vJWqiWjPFBvkL63wj+el4g5ZGpkUY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=QFDpsGKgVcmYw0AJhtLYTX4aJ/usTs7UwLoXhxdZuoDJKkIzX9aqqBy5fRj1NUsdTmNRFEOsl2VTuKKxNXkx3fqV5Dx5/mh+b40LNjYyPzCpoQP3KyAx70mVQckb/EYyMV5VD3KJSIkjDzRJ2Cb+ynukA8I2YwBqAipfBwz4Vpw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ogEGHWBQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cptlCbkl; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ogEGHWBQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cptlCbkl"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JLCHTb028221;
	Wed, 20 Aug 2025 02:22:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=kyCqdwY8/J+xVkZD2+
	PdPuXHZTGRpXbMBnQ2CsgZQT4=; b=ogEGHWBQDBNlupfv3VCn7RwUtE7s/5kavh
	u+cwJaYAumZbDzN+lNISNLiyc3YL33y5JtvCGvBtIvKcGTM+NleFkn+8B/gQOJ+c
	EPVsQQY824+CG7wZxpJzIXyqqN7Ht4MDD9jQQDITWIGAdxhLvF1/wWtg1EdBn390
	qVFVk47bZ6Dbclt1G8Wb5m6k8o4w6xsGc9nE2JXCM7sO8vA3R6UmHhJkOWA5e/9m
	25sxPsVnJuSDuITE9ZI9vuIJG2vAXekE+VsfHzRIqq/d5bS00ft8Ol+FvFm2+mPG
	VEY7Cy+p3Xq8GxaTsdm/lQF1EbYdZJEovzBgw8zW2TlmRqfWqGxg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tt0a62-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 02:22:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57K1Us3N025484;
	Wed, 20 Aug 2025 02:22:38 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02on2089.outbound.protection.outlook.com [40.107.95.89])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48my40m02r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 02:22:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kNffc4vfjKuekZbY1Mhq4NIf2xkoycjC4/xZyMpdKCvZVZpbO4aIy4RbC2/QEaMuR6F4S9kabKMcyeu/CRTUd8LVW7V2SxwCVTuJTqIfxR8sOLOUEgv1x1H/54+D0CEkuAxnw2Unf/xXbVo63srvyVBCV+6MNfKIs+Ce18gWxfqz9I1eVyBtEk9CInSAOr+zKUvlWH2E+gUDvvmL2TK0C7D9D5Mnv6feywULxlvC/tGTmbBcvv6+hjn7jHFe1Y/oRqd8wwFGlO2aKR9+Ws/TycYYJSPNwoY2BjEhPYAtxJOZ+bHitoEOmv5VgW/2II6GMndgGL5y+H06wcfD5nmenA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kyCqdwY8/J+xVkZD2+PdPuXHZTGRpXbMBnQ2CsgZQT4=;
 b=HJlXx3XV8iI1JC8Bvso8lIsm6l3pGFDpk89F4dHkFyo/2SAR8cIvuBg3EOgddZ1nsqz6oGGOOI74egi/FcqXC3xRhG7RZuXniaa/PmL8kmL0HSnuF/nF0QShEyB7qbEFDCxTb2XEiBEoaxxjkrc9+Fm6A73/OxSlidK4Ne2bbW6P/lscbGJ9RM34TxM/G95QHmco7iNZJlHduvwbBZN/8NhzAVdspEkUTPVzE8hgX6ESQCgBdI8XRiGpS9lPTMV5HY5IwiC7uoFVz7ePchDa/tonOF1rO3tWoSmULVZVimA3D2a84xh6r9KMWiYVO1GJO4HXNEMRWCBlRM6kjWdZpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kyCqdwY8/J+xVkZD2+PdPuXHZTGRpXbMBnQ2CsgZQT4=;
 b=cptlCbkl1kTsmznmvIP0Uysov03qeUzAVXT7D2mThKh65QEFsRIokz863L9gvslpB/UvlhgjMPAw9BJO0lvcQaBVOpwKTwgO8BPU3VW/skuzW62tg5M2Cbw4BqJSRXDyozsafwLX2ADzMSpRAg0+rzBlAScRJYxdLGf5rXU42AQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH2PR10MB4375.namprd10.prod.outlook.com (2603:10b6:610:7d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.13; Wed, 20 Aug
 2025 02:22:36 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9031.014; Wed, 20 Aug 2025
 02:22:36 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Peter Wang <peter.wang@mediatek.com>,
        Avri
 Altman <avri.altman@wdc.com>, Bean Huo <beanhuo@micron.com>,
        Can Guo
 <quic_cang@quicinc.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] ufs: core: Reduce the size of struct ufshcd_lrb
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250819154356.2256952-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Tue, 19 Aug 2025 08:43:49 -0700")
Organization: Oracle Corporation
Message-ID: <yq14iu2wx42.fsf@ca-mkp.ca.oracle.com>
References: <20250819154356.2256952-1-bvanassche@acm.org>
Date: Tue, 19 Aug 2025 22:22:33 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH8PR07CA0027.namprd07.prod.outlook.com
 (2603:10b6:510:2cf::25) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH2PR10MB4375:EE_
X-MS-Office365-Filtering-Correlation-Id: f72b4d02-6807-4104-0d3e-08dddf906d8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/ei2/60kPU2r9GNC1UThoxeNUtl8cz4LBcnhULxLfppa1yRNAKeiiSJszvzF?=
 =?us-ascii?Q?Lki+cnRI+++fPbwroMzZxOEB3ISIhX5sb4KtGD03Hs0RoY3fIubMI6s1qhtg?=
 =?us-ascii?Q?TFp8OFU1jD6Gw5Yt35zqsz0urU+HEuD/rNPysunotRFiROqwTH5TF9FqLTDT?=
 =?us-ascii?Q?HbZTaW0XI5qe+Ob+jXRK4hw6YpoUN2IF8Hk/HR1YnnelEesQkn6bdOd5BUBO?=
 =?us-ascii?Q?Izw7ZGAO7HU+Bk217ngS6tZC384NbEfP2qIjKFDD7XJGVS/qBZon6cmd8/1Z?=
 =?us-ascii?Q?/u0NxzApbsyR0n/Xi1u86wEEbDFpn5m493izsHVv3/SHE9MrJJBC3NWZb6Oz?=
 =?us-ascii?Q?Y2jIdVNYxa/zpugeBIaDcSqQD+tjLq5iwzUKFusz9u+DL+rapFAa3v9j1cbB?=
 =?us-ascii?Q?KAMeMrV+aQfsaKn6G+iyAI36xsi0D2NUuWbD581SvUezzcuplsFodZnb32ZY?=
 =?us-ascii?Q?lRLZguWDgf5XqGTTNZ/j1fvPYn9YDtnpVrPDd4XwFLpAd8QbGPux9ku9MEs7?=
 =?us-ascii?Q?8M/uKn8DGq2zJRIlPewi5O87O5IIBRLPOfxri3B1Wc3Upaq8YLI8Cr5fRJZJ?=
 =?us-ascii?Q?W99d/dWfQUbhRUztVQJr4gPGByFwCtEgZHhkQF9146zRVht2CKe0ne1SW4GO?=
 =?us-ascii?Q?JAf2wU/MlRWEP9/kpIYzWNcHYwdOoXUMAa927S9Az98b2ect5XGK/rvaNcXC?=
 =?us-ascii?Q?1dT/48CBep9EvZG/NvNlGdB/KASEzRq/10ygSsO66GjzRsCzsUpyl2xjRt+V?=
 =?us-ascii?Q?ZOeuhSV4Iu3wGtha3MciE2dch/d/norJasp0lw5cTTuPJfC7Saefh0dwp8SO?=
 =?us-ascii?Q?PkU5hXUL1WlQqGLTj69te/yLw3bwgCVx7v8USHKBHDDHvO3UzGNDHpKAUjdF?=
 =?us-ascii?Q?fstDa2qzC085BhvU7IpUZ2NXkWDvBW18yhCOEvLOCKGSN6LodUPP4afy8j84?=
 =?us-ascii?Q?v1ywRU9IpbXMh++fzKV8i4rcvNleP+oBtb9m4+l+6m1Dm/iWVAzAeC7qp/SY?=
 =?us-ascii?Q?b8AaTHGC5kEA/u1lRhH84A3DkeaXR2TMHtPtvO+ZpmcQsFASIAvvvErlJkQS?=
 =?us-ascii?Q?1vaEwNntHGEM0Ca/GB897EQY0Sch7h76iGZA37ZkjZXeM9Fw9UOi7phmU3Qu?=
 =?us-ascii?Q?CQPb21cNm6HVgy1ZhqdwXJvhCbSOji9zSharwI7VkEz/JPxGpX0q2+MyUosx?=
 =?us-ascii?Q?hPY1utlOw1sq7aIlQ5ELKpE1EFbg9ttkz6srltze+lynFiqlIkRbc3Kn8aIg?=
 =?us-ascii?Q?WybVz/WRtrKiKMQ042X9DAyH1OdgODAciIomuPDwlr6adI5AN5cFC3mjNcCp?=
 =?us-ascii?Q?1HaWf+PQowpNKoFn9rTvOl0GKjioQwyiRBfDlYLYnPdj8kOOOhYI2HPapmI5?=
 =?us-ascii?Q?nHK8odB2hxcoPV0spX0OfbKYGVhdDnM11n/KFzVYU6yxd8gEq5qpN7ezJhK1?=
 =?us-ascii?Q?rsgjXTJhuFU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wUQ5X5mmaFa5ZILA0TAPY7DEU8T6babLBncTrOi99aryhDrPsP4k0Y/RKe7E?=
 =?us-ascii?Q?EE8pcrQuZeSHMsTw7Wps5MT2byHj+wx65wwSsdob7nDlqzXTPBvvNk8PodAR?=
 =?us-ascii?Q?hhDZFj6kcJ3BkbOEjlVIQAmoAUxCSY5OW+5mvOp8qCnqERSvyK1hetB7NHUR?=
 =?us-ascii?Q?sT68u169FSVeY7XFrPiad7A4FUrwCtfFOgdLfayFX19wt7F9uf+LfAvCCfZ2?=
 =?us-ascii?Q?CDRF/J6dsOCF4W8FvyJB46RZfH/5x3Lu4mg4yP5+ewYlAETdx1FxnvtsrYg+?=
 =?us-ascii?Q?kZiQb7vW4fLnoR+YFxJ+2jSSojBCBSUv7SJb6ywVA+rdGfAfcVVDjgx87VZl?=
 =?us-ascii?Q?XbjeDOgvORdCxFLzxaSrcbtSAaGGdzzqJd0yzXF9n9/Zt7/XNB2ngnpvML6E?=
 =?us-ascii?Q?Vbg/bXVY/pZHtdx5+SxL6G1bHvU3QGRZPBjfq4RdZhbKCeuR85xuvNqwnsDK?=
 =?us-ascii?Q?xwoPfNOzjoSgaj3UhspUiKicJ0xc74JTy5ezbr1t8T+6mdN52upzZmxpL4ml?=
 =?us-ascii?Q?gELjBmOp8K9iy71/5XT0vbiwmQbbL6Ya0Q7MJ3VfK878eLvWyFYrVHlsW+5T?=
 =?us-ascii?Q?+nXtkNCo9xWAgWkofdH73XB8L+tB0A78eZZLeS6daCNiosc0GZDoyahQaKWp?=
 =?us-ascii?Q?iK5rEl3kKsO1gEf/iKJ0t2i/GtBl4JYfwuBvYUm9ONAteoUm3GPyG0oHMM7p?=
 =?us-ascii?Q?c+1Gs2+BPVnHF1UUkuyrYbtaZ0bc8xWUVjbansUWSewdkJLQdPYyXbK0eNXj?=
 =?us-ascii?Q?AmwUOLDLWlE53/TBzHUUj703RnBLtpFwVHl2L10OlUBWYdsXLvbFMhse0GCy?=
 =?us-ascii?Q?ghqZbUVPOPAuFv6/Xc67xUSZgFywR04vBM1f6HPQ8g1YOhFE17ANK83pjazv?=
 =?us-ascii?Q?GCPtNJgr+CSyvUfcld0l9wUn3y4s2ZibLtT92Gg9QPSy1f8myhJOMyvXtBez?=
 =?us-ascii?Q?/hvnOkndRzPSMAdhcIAVFJDws0OrLTNdNhklRX67ByALQF4bQCWYBQGJ3Tjj?=
 =?us-ascii?Q?xxS7Mmi9aJPP0aIlwZWRvjQobKhjBEb4FNZ5772XLbUnrtTjFOEIHDse0FLg?=
 =?us-ascii?Q?4sLy6yUKJhbIKSxuH/XpA88erDC33lTkVgbH0zVBbAyakcO5jJ8AVhUDfOL0?=
 =?us-ascii?Q?u/wo9ucLrd9PjK4miJ0TsZP3wjMm8yjjFd6NLL899RTXaIoRT3wmcV+HYDcX?=
 =?us-ascii?Q?U/Re3XTOXFffU4bM6GvamnyxOXtBaBIT1vjWfE1PteFTn3GbcRM1yv1TFWh0?=
 =?us-ascii?Q?qGWO6/NTQ9/ecZaoVQDbDqrRxgbA3JIMYDLnJSVTkz3atcJuSX1Q5JpSz6XT?=
 =?us-ascii?Q?zsS7vpSmxfqhydl4il7pG2h/t63wIFVSiDOMDao/Kj1t8ksREOzpG8g20qlu?=
 =?us-ascii?Q?4HBTdIX5FLq+82Kmc+VlewuR8aO363pcSOBlXTaAH0aO9wrYE6n726QNs81Y?=
 =?us-ascii?Q?l49GAL+UOQKy/flDKAdiLZTrT+kHDGPCIvL1bM8KebXC1FTPozo9V0FAOrRL?=
 =?us-ascii?Q?LBH/1Ww3XzSYs7zZljHbjOucDeycS0tg7J4XaW0XvT60j/HPvk1htQoolS8H?=
 =?us-ascii?Q?5NoTVXCN0Ao/hKXdjXXcPcCYmsnjKPJS0b9QIpMbEwc+Ix7Fi5K+Wa5r5QHH?=
 =?us-ascii?Q?4A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	u1aWXBcPRJGCik5tnKbM4pNIm5RLRCK4xlqjiV0Oh+hLmUPtZsPSQ1aM0045kK1r/VBbcOjEmLINKg7nwUWbKDfp7CAU3txC57Aje5RVm0CMU3XI5RteFArP0y+TEFE22lmOP32BqMsZdHqT2SUM4PFh61EhQ+rVF06zIjZy6hIV35RFcg2fKOeSiI72fpfpoyNNxOn2lo+dixkJ41wUmdVRPQY78CDwW2rsbMQJxTO8uhQ8Gd8PppFBAuUi1EDw7yjrTZQ4eF9KMmNy0xDAlLsYgBbS7zbhSmozhBjnE5AQ6gtB88I8HEWUfG7b+Dnfhk3fFCrmognIgQvgPWcElOZ45CdJbdPs9R1GHC0Sz3lVa1EvxZoW1dvDB5TyvRc/UbUHdIjrN8vXQ/108k8vD03keBkG9mgUdq/3BwiAZuphLtT3J3Qh4Sx3HvtcTHLY4D0X67dBuL6rpm3yb1rvMFbLbJVUviawNWALCATy7rYvBX7U+Rtqf244ANV26dLxQLHAuDCwCBE50HlakgjAUKbKSyPmjJxWUphW34VBgCDXj6v3CB9+zrbuzik91sQBWqW3zv/sETXhxNa2c51StCzEo3UeCRKXIGqIo5j7/24=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f72b4d02-6807-4104-0d3e-08dddf906d8a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 02:22:36.3929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hN81JloqNnVrTSuTmExOmGNXGhNdLZoJQdVnMOEdhfMKpAK7tRF4NcZk5o5DD7TlPBdQhn+6lWGaO85HSnQDfvpVubwQ5NT097IOZ6i9dMY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4375
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-20_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=822
 spamscore=0 phishscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508200017
X-Authority-Analysis: v=2.4 cv=YvRWh4YX c=1 sm=1 tr=0 ts=68a53170 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=CEIZDvEd9kZ5D99qYfAA:9 cc=ntf awl=host:12070
X-Proofpoint-GUID: lnEMWnBbBDUXH7JTnFQAtomku-w-dBH5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NiBTYWx0ZWRfX8bK8Yv7L0sPm
 FYAzKnLG282rKUnVfCcFWQ3az5LAHPVBjm7WgX4fTfcZL+bLUq0T/46HZVcH/LauOWchIO09kXk
 9GzE90F+1BVPEviYzI262BQe8jkAyNd34+0zRF/ZzQYxqCymu0ZwhY5slKT+HwrnA85Xp9LGOtI
 YzddPLy5LhSuDm94rGC032fl7a5SBPOj9OqMLDyel2/ZOLEDsjToCkmEFuUTCwJkp3oQubRsv+z
 FETl+U6wklNrIo+KqKdCxzEHF+aBpEa571YM6HZmYFMG0R0xul+kVgRrLQZsoEDyzYNo46tdVAx
 Zojr2GJ8lV3gtZ2WJKePMtIIMgVzG8K+9BcVXv03e2Bpq3fqXfZCHzvO/Ha8sLwP30m+pk9iPd0
 gpyeoG3ChLRppwbOAtqZGwZYo/jnmi6dIJRtk0BmYlDxt+RisAQ=
X-Proofpoint-ORIG-GUID: lnEMWnBbBDUXH7JTnFQAtomku-w-dBH5


Bart,

> The size of the data structures that are used in the hot path matters
> for performance (IOPS). Hence this patch that reduces the size of
> struct ufshcd_lrb on 64-bit systems by 16 bytes. The size of this data
> structure is reduced from 152 to 136 bytes.

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
