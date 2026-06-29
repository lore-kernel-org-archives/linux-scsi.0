Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D331F3F8248
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2026 08:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782723232; cv=fail; b=JxtIt5UuIOxx27GvCHdeTkfzr6v8I6RjAi93L96GqsS+G4iM5kFy0Wv3cIq4nHIhULrZcoENFZP7m0ADzOSkFFNt913uXFV/WAhYSTvCGiN9zIKBZuSOCUisaJXIuQvB1WFzY2cpFP+KUq2mgQfjp20JsAY8Ymc+QbyMkr+PRNc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782723232; c=relaxed/simple;
	bh=33j18YrRZQTL03CX9GekYg0hb/rA6Nvw+Rr7/VxCrUw=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=AF0LqyXo0os5x6npq8qyLlGpTJsBYAQ+Dxali9Wr+HShBfa3EOTkRgVjI6fFscU2wue/3nCua2j26W4O8wgIUaEskaImgON/Vz7WlcVvcYKIF31SWswq+unX7Kbou2ZusleW2YC+wZKygHRLSokz3MvfaDsAn1BC7gs1yozwC+s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZW5yk3f1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=b3Qxdagm; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZW5yk3f1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="b3Qxdagm"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65SNjoXN729419;
	Mon, 29 Jun 2026 08:53:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=5DRgzCAhPJ/79jW0
	Q2+cBu+zEUVvvlhJNvSlx/kJPtk=; b=ZW5yk3f1ga7Yt1QeewCUrmq3C1Y+UDFp
	z7WvRIDcjryom6cXSNorONH3PP0bvJeQuj5VYjnNjwgSwImwHVPNnRuzPcHDm45k
	0w5QYSSrZVHbFHAP+9ptvSRvsRXpWwbbpVF1Bs/stEeIO91xLJDh6Lk6tp9xNpr7
	0RYaNVjFRS4wxIITLMUgp57XfHutBb3oMdH+c7XMNjkRTVQzeffh0jLhOyZGTMMR
	vmPMfboIPwI1WKRbkDr3+sUKZiY/mAs3OVlAFShdb8WAdUzQfsiiCtuViiFHFe7b
	h6TIvkElLkgOi5lLqsdm8mmeEfh8OrAnDFHT8GJZmWNwZbZ9ymFYGA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26mk1swx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jun 2026 08:53:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65T8mXBx027958;
	Mon, 29 Jun 2026 08:53:36 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010057.outbound.protection.outlook.com [52.101.85.57])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f24yp4qr2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jun 2026 08:53:36 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AyaVFGBP8Kq5uTsxS7UrFWXvIoReuJm4xrLPSC6Pg+f9KljlRt7QRM/QIavl87cqf/UTWKgqCvV+4WdHWsDW61UJ1Mp2vwfDtYB1t2ZCUxMxTB4+ZyV/eBnDJxOTFdsIIWBw+piU+INUb1z/Emoqx54ktzE6M+XZiupT9HKHdpddtbX6vFzXw1at/nYAENrTXeYkPDQnLRAkTh74dSDZnLRI5+2ieKFQRDYFVICe1I6d6ZeCcp+nqisgxtGVRUsyqOeIpd8y0xUumUrMArnABKWBVuj8C6LKC39l3TzWC9e0vsGwMQSR/o5X5Nq6tQyCYFvs5+9EKHAvMYubM0d4bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5DRgzCAhPJ/79jW0Q2+cBu+zEUVvvlhJNvSlx/kJPtk=;
 b=slUTEdsHaJf55yWLVcZ3vHFJecVTuP2zCBmVQ/xsWDaMoI4MTh+xg0ucF+vAB6Bz/AMYbbnU7LuQtx2C9YnOIzKlpxWEhJCOuhl6MuL4N5lwgsQEzpFB4xhOmOgI82QO1Vd5MOW8MonniG05hb//a4kmCrCU3FAvczqDdXTA3YKlstma9gHsSXAQm5O0UVCwCk0W8nh6SRHPwpi128BkZwduDMxXDxYG4qLtxfQZoprcYRWg1SFP0bpD+AsLWrmjDdn4RPzktm75RyhYyU0Xdkl/TKLO36fDyvaSXmWEjbA7k5KJP0Uszoucsjt0KneSXqH96PAeBKKHBQL4mLvkXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5DRgzCAhPJ/79jW0Q2+cBu+zEUVvvlhJNvSlx/kJPtk=;
 b=b3Qxdagm4IKPNAGdOyWFb+OdtCuHAx5pHHKgrX3iUdo5u5vJxxPe8BxkVBgt9BXuV37aONHoI+6t8kqG7jv93bLtIXfChJ5KuU1UXpSeRMt/kLg/Pz7QxrmpVbB/enPa9IKavHBKaLlzfJVylIzeHbKHO35+bdJ+n+NKSJjfUx4=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CY8PR10MB6586.namprd10.prod.outlook.com (2603:10b6:930:59::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.159.19; Mon, 29 Jun 2026 08:53:32 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0159.018; Mon, 29 Jun 2026
 08:53:32 +0000
From: John Garry <john.g.garry@oracle.com>
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        m.szyprowski@samsung.com, robin.murphy@arm.com, hch@lst.de
Cc: linux-scsi@vger.kernel.org, iommu@lists.linux.dev,
        ionut.nechita@windriver.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH 0/2] Drop SCSI core dev->dma_mask check
Date: Mon, 29 Jun 2026 08:53:08 +0000
Message-ID: <20260629085310.2298552-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH5P222CA0005.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:510:34b::16) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CY8PR10MB6586:EE_
X-MS-Office365-Filtering-Correlation-Id: ba7367f2-12ad-4eee-9cd9-08ded5bbe5bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	tE/dvQjsLhidMYJCiw7Svv/ExQYXxvAvzWW7qcpk1v+1G+g9sSiYZ5tWXNcTHjc/5WbNa8PVaMwc03RySGlq6a+yYlGqFu+idCzNKTmWa/ZaNQJ0K8iCP+jhamR1CDvrif2ToPdT2ngeTNyNOcd8RGSSxW0GcVh3rVsC7HTXRqkpfX2c9hI0P6pyDB/FISrXP3hT2FelaHnkU3hOwVLdk4lSQqenVVfRmJ8UeZRNzbhLj0pPjXIKDtpb5PrWTq+lgfXyyaIRqyfhdNqvA0WOvkVUa8DCQE9CrVLzjMX72I4ebH6ba1vExbWT/bPbsYwkGGf2kNi7UrLSEWFFlTSo5jZWVjKwJh2+CG2wGmtQwjrLlvLDQc0kzlozVqbmUSOutxd9RMtfYSuqwwal9S42Rtqkw7fSwW7I/iSS5KN+BpGzRtoyk9kZB44zLoDbG7yiQZQO/eBzYwJbOb6BEojl+PK19j1t8HJM6XRruAA5s6tScVLmkRfEGkM578Ld8hE1aPa7HRgQD3J+AvXb+IuzvGQBejkL70Rz/JEVf9PYU0X1tXZmjCRar6UVq7TpFHqaTYdFEY4v18zkWPEbDI5Pjk6y5w4s66zEGtLMZ51qAprmp2zokukIsJBREus2yTfFjHWy6J9+cb5Un4x9owrPl31PvinYTsh7uQTL1ecX6SM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?P7mHUFKz8oaEU6pWXfdv1Q6OnOOk87T5jqZ3BWDJa57Ylr7J5vUT1ZudGUYi?=
 =?us-ascii?Q?vNqnxsFkzbFQmG2I0XxuotJV62V3pztAi1BkEzARkrRms9975tXXthwQUUSb?=
 =?us-ascii?Q?Z+IKcViNYP7UatHBBz0WV8IFtSkhqWjDkaBbOpezgJ9gc9RJcvSgCoJwV8my?=
 =?us-ascii?Q?bWIhI5BVQNMPWH+gg/D6HQeou5JuSVjbQVhhe6pIpfWY46ZTS1Hbz+xZ9uiw?=
 =?us-ascii?Q?y7y3kR+td3Y+CgCRUIPL2CojgAdtpW+zsv9I+euuoFeltTZW4QmrIdK9yZa6?=
 =?us-ascii?Q?TkVnjFi8NzSi87a2peCAV1kDSTju1e/6jh857Owjy9WuUBSQ02Q6OvxX+koM?=
 =?us-ascii?Q?ZzEGK9eVZrb9h+W9xmg23Vyp4020eTqj2Edbp/HwxmNWQzHaWxhZTIFKO/C3?=
 =?us-ascii?Q?peoB9quE2HqyLaPVtM9Zy/LZ37yNIVs2a8AiS7Y0OQwK8S1sO+r3MlZBO4zK?=
 =?us-ascii?Q?6bB43T41pJ4QUqICGLcby3AdFJiS8okSrnfIomVRP2NvbSaV6CweEctcgd3M?=
 =?us-ascii?Q?NOD7Nis4N7oViGsNCnzNRktr9p96H+IYFYPbXIi/sSY5a8janE+cWDSvnkPk?=
 =?us-ascii?Q?E009z3zLCp4povYYPdV/b3U38bN8XR6j8zVwXI8Zsgf2/lE9nWhHIEZLL/Xf?=
 =?us-ascii?Q?LYN1cIKODjWX7NIBdykgrB/mDvwPg5UbW3z3RFT7FnWcBNa33/tckTh2v6Jg?=
 =?us-ascii?Q?teD1vw3uOQa/+pw2y9MCWkvXlg/zeFPRLGWaKRJgLMJPjmJwaUQbgbwmd1ky?=
 =?us-ascii?Q?F1MVllPBw06qBLM+L4Qnd03jHD5Hx/bgqWKFR3735K8O0Vr5AkO+oPMJPyh7?=
 =?us-ascii?Q?npd2Uf2pFQf0evawdAFm+vpkQDR2Oqy0cFXRj0onSvoxGwTgeoDfaPQU4Uu9?=
 =?us-ascii?Q?QFB6gra4+jaQwZPoxpRyt4+jTLI2U7eM0DWFkkmibIWsmYkiWm51uZKQZ7Jx?=
 =?us-ascii?Q?4jDOcMNiZU82Frl4KcTgreZSmid2yaxUHNXi2/fp6YhglMLtmfzzkE5V1v5C?=
 =?us-ascii?Q?aZwwbO9TmxbSVNTYgafCA7UQfxE0HIpbW4Ou9v/fMRSDElaoHfxAM8eumfZb?=
 =?us-ascii?Q?YVJsc4thB/dsRiUlcbig9SAdI0BRuFNmZgNQNhh25hfXFVSwZDaIIyFl2LA1?=
 =?us-ascii?Q?c95Gj1U6/yhqejFeRm0m91FHWghsnhT39Xnv5ecq+kYbM3ctTCAwA7jdZdNd?=
 =?us-ascii?Q?uzE5Na6XplcyE6k+QwRWcKHMs9rDVufI3oNL1QU0OnnX5RJt3wA3nbtWPz9M?=
 =?us-ascii?Q?6p4h6klGCUuwaUJ4vR+WBSzKNAUk5O0oZpzmP718OCaDcvsTxoSXpXOgS0PF?=
 =?us-ascii?Q?QuOTkQy+MrA/BvPvZhSr7mU2GCbErAx9bzC45eOqX6s0dL4AMGcsXiv9mfF3?=
 =?us-ascii?Q?pX1fvsRiqlc7K9I04/PC0iurs77yaM+Difr8zPnJZH6Fkmz/Rx+jZnpg3Urg?=
 =?us-ascii?Q?uu3jVcirzwZvj0ajcIMFTRNm/aKYtaYL2wo9Qu46C7bRtHvVLtnwGIjrwx/Z?=
 =?us-ascii?Q?/+DdFyLsjCM2vSfnwB9rBB3eRHmR4/bfhhZImfMr/CE23VWCk20yk0KyJAA/?=
 =?us-ascii?Q?dxVPtO/CRUp7SEgldMV2aoSay684BFTMS2psGtPfEiILJ5/ktKC9elGzcinM?=
 =?us-ascii?Q?EdH3nJzXrwwmjVOKGCzUp3CiEdwqVNI5ogDPmpTH1ob/RULpeij5+gslEIOj?=
 =?us-ascii?Q?pf32W/qjDLoAbvnhQxKAq5cr2BDwrVkq7b9E68W5mugzKlEf5YV0CSLMPMqr?=
 =?us-ascii?Q?C034oIr/7w=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	SS12VPu53LViy8r3gU5X4Ia1fjGIDAsj2OQjGqaBYzePUrDazBI6Zy+DN4A4RJsJftW/DNl19LbShFjpkPzHrP/DjH6i7s7wVxBizgQXxJr/tJ6eM68erVjb4lCcTFrTbBEGgnrPlzZzTYUuhGYVWZBeTaRKKU219bR/jWQDqhzCJheJ6xJ6Tw5loPJP5rZlrn9BOe69L55fZlDoJu6ciom6v1YRP4lc9mSNhxSXerKWMXe1EEwGLcDCx+EHduxgU2O3wIumiDpSHQ5X8Z373ujgjY3Sw9Vg8UgXCpxrWv6NQrT5ZAfIgPwh+KJY2tJiPX2dITrgY8VpAqUq8vXXJA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cd8jo84wK8/9iPGF50qMo5FpaSLFDUqWz/z0Po4QsGRFMavAiefTVWJuvhzR0uXkQqbLS7Lbwhe1bGsKo25jqKBqnD3jn8XkvLrFMxbQZpxjSfFr1Co9bfRArOYGT38Oav4bxWnmqjcBYON/ywa5Qr8wmPoUg8ki405A9oAtxlzN6HbIICasGCrojEKld6PEP1pUWAOnOKVqo3STg3W3ZZ8Is+sU3stYrNBi84riElJJkDOPSRn08kGk2bW7Z6Sx7Da7WOMO6qrNoj1LMAkOTysnN0s8pujxxQW9lXuNhWHpTqKHNDiec48UcuUASEEmKFjtGAp65H81rcroDni6ORzDfMyy4kSjN1O40dGBeSeRo3H6TuhgJ/nmVJS+GVFXlJ4x7IvNvyxvIaugjvmhLNGnhNCyjqzHcwk01Pgg/RVQLjsOzYETbUyhNQGf4jad6Yd4aPpqTUAXhtqDW5x89kKBl5xXUP5HJK7+IMgI7YoXmApmHHUMXKKUn3N6lb6pWHwVkS/W2jiihloIVVm8KTIM0gjR51oN9STJjm0yv7mujo7HljOUqDM3Oa0XN37JAK1gOhwF0aNU7vLfj+qib5UExd4CFS2kI4hlU17J9j4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba7367f2-12ad-4eee-9cd9-08ded5bbe5bc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2026 08:53:32.5146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vUEdtCv+mmd7slj9a29tsXA8eUNikukNuhx8ng93M0qQ3nTKVPq8LXFCN44TxPWmiroiB6CbJ97DTt11LVouQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6586
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-29_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2606290070
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI5MDA3MCBTYWx0ZWRfX76DnuxXloLVQ
 d7CjtudR3+eNXrXSs8/Dd517gB+NxhAoFkBGQ/WQ7o4hfkxCsq6kgv/8D36/NyYUztYQiZMPu9Z
 kcJ6IaR6bVf/PTFbl1eDqx3YsTYH2vhf8DFAzl5YV813PEG9n8CT
X-Proofpoint-GUID: 22ahtV8jStAEGwOjzXlLqEFiUZJhruif
X-Authority-Analysis: v=2.4 cv=OKwXGyaB c=1 sm=1 tr=0 ts=6a423291 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=LqJsMp3YjEtyBFJYW1AA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13723
X-Proofpoint-ORIG-GUID: 22ahtV8jStAEGwOjzXlLqEFiUZJhruif
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI5MDA3MCBTYWx0ZWRfXwPPY2fRV3Rdz
 8MqukWN0mncjBUWwmjJTN4hPhIVI87EKYri7nCa1WPeIk2H3kAHKDZxWgtb0e0ht1JdjEpKMaXE
 65bvQhCzcaCQV3NDD+LZvUAnOAARMnK0Cn7LV1z4jzCCQXbGJu1x7lNSJX4roy9YqP4XAPDFL29
 IPXovo4A8hsi9KX9Bk3uNxLR+PvUliN2D/wzWY3XFSSLBtWbyYPBcD+XdtXWUe3+m361IxtRmO9
 /n+tvnrO6oUHwxQVr+ZGUQsewBzIIiRtnLtjHm/ubYmn0HAgZc71zQPBukLwhmWFs2eIb8Hwd62
 XA0BuDChV36kMDdeYKKg5jQocLt45aPF0pA9E3r2wEg5YonxhAfc0J4P4SXBYVyZGaQTTMgVh6x
 2zpaIplBQ3BBiACjSMpB+LCdJU/juKj6BhPKsaegDnHCQK8w6VOQw/0KaH/RaHxEgsI/7yWAli2
 swkSJneseke1cVzMY9h4s0O1WEXP8tJWqLykQdZc=

In commit be8fcd4a8217 ("scsi: sas: Skip opt_sectors when DMA reports no
real optimization hint"), the check for dev->dma_mask prior to calling
dma_opt_mapping_size() was dropped.

However, it is not safe to do so, as dma_opt_mapping_size() ->
dma_max_mapping_size() may try to dereference dev->dma_mask.

We just don't hit such a path as no SCSI HBA driver which has
dev->dma_mask unset would use the SAS transport.

Fix that issue by adding a dev->dma_mask check in
dma_max_mapping_size().

The dev->dma_mask check in scsi_add_host_with_dma() can then be also
dropped.

John Garry (2):
  dma-mapping: make dma_max_mapping_size() return 0 for no DMA
    capability
  scsi: core: Drop dev->dma_mask check in evaluating max_sectors

 drivers/scsi/hosts.c | 6 ++----
 kernel/dma/mapping.c | 3 +++
 2 files changed, 5 insertions(+), 4 deletions(-)

-- 
2.43.7

