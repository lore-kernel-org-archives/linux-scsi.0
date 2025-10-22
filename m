Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A3041C63
	for <linux-scsi@vger.kernel.org>; Wed, 22 Oct 2025 02:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761099233; cv=fail; b=MKJiyd+F4oC2Fbv4B3NWdJRosD2vN/XCI+Qd/cEwzD1lZFoA3MDE0+LLSCeWZ3Bmk/ebIamdNMgEOPivaWVVkOF6piIKckqLcfGeYpiUtVw8M6W2eO66ash4p4StygOhSE5a4dKuKV9rH7xTsb6/wW6Hx4xSSJSuWpsUMhrxrLE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761099233; c=relaxed/simple;
	bh=BU/FfgJ9qm7L8XqxAcuJuBAj7CE7uCAwoSruNc/PMiI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=LVOmaQVsqISxL5Euc5kNZp0sTwUyyfIM7vpWZCdXGvYqNbMxJsNZlMUZi0/lAIgDsLXuUw+w5Biy700DwQUbCF20tyl1CjhtIO3Z6sDm2AkglTnVayxe7xYeslIX7RElhsMBIloyI2bKWJFldzspqYbhemrMqwxfB9Dy2aWRzP4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RIbF+/TR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ejuaeQW1; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RIbF+/TR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ejuaeQW1"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59M1ZZnJ008923;
	Wed, 22 Oct 2025 02:13:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=TPysd/dlpupHAw5ul1
	8QnPcOo5bLEV5zfIMEvsE8eHc=; b=RIbF+/TR8pRhoq4wXfq4Ya3Tt9N5WW3+62
	UhkXiN1cpkmbOPol1WSyfqE6KFt2L6V4/LpChFrBfM5ooY8sRwBS+w40EQfuZ1RM
	WMAacA9fEzxFBnRxzfSDXjQ4VD0HCrHYVffxGRysFksZyNICytUAjoBeatThjjak
	+t5ExMJmGlDLrawHvf8wFoCcRr7NsDvP4gEpdgCUbIDBQ9rrFNyjseuDe8UEasDd
	OlEZUOB1KSjC06kHFIBlHu5uFsNNrowxbDpGTWktIB0wwbWV9dFkVRYdkDNEUb+E
	LtGTwkGTXCgcKhVkyeBe2NCe7Xb+rFn/l3B7Lua68Ed6bAI88Y/Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v31d6w3w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 02:13:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59M01Us4004348;
	Wed, 22 Oct 2025 02:13:43 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012013.outbound.protection.outlook.com [40.93.195.13])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bct4kv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 02:13:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T/191C9+bOtWoytg7uDqsQ+Uw0OIQC0zLWMZaDeLHgzLDznkz6Ktw2ruZXEBpWhXFJrJwDb/Fw8Ja+Th5rGI7vSKyTmENpCglt+PrFsIMVn0McKwEUVaJBzUy/fLLr0qovGZQjRWlkmgRGY2boR9cag3cy2lX4P+UkT3cG0EAr0so1/FPsxNdFR12Dn3Yau3MHW0S1Hw2qm8CzGGa9z5sTtpvpqCihFSsYa3vwhPoDPLk9MorV8vkR4vfWfDI3u4KTO6PP1H1iYlJ85biW7uvJPllnWTABXc15Q6PC1KI1Q5/sCHSGu1ZtiB0shiuKKdqoAuCODhMeQ4S57m90SujA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TPysd/dlpupHAw5ul18QnPcOo5bLEV5zfIMEvsE8eHc=;
 b=i3DcJX/wlDR48GqBkvIaKLr+i/qHqEMyApjXvBQ9zYKEJB19Dgv9Mtd0AetPcMQiSA8QiunjBxLfcGXO+LXuyl81fDb/3D1yTH1Zt9e0NEAUW/oyEfkoFYasxuIKCLPaGcivpi0N/hxeuj34WphopGZeYFu4dU2UVGSkMMx/ChyU+75D/d5LjN3P9GiHIBbz8X7J1BMcuWG1405yGWMkqv+RfprkI6NXO9h/qpFU1cc0/jqgFICzJo6CIAoLdiypYexlYSAcl0/qxKjUhEEzzU6N4FxHy8M7G4vXsagbsEKEd3DUBG3oS6DzgAvbnJEjR2dMvmb0tlUImIa7Yjc3GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TPysd/dlpupHAw5ul18QnPcOo5bLEV5zfIMEvsE8eHc=;
 b=ejuaeQW1S7LTT0x9yLqfv4jysHWe91OBpLgeuoU++9murjSMqZd/jgs99Zg600+3ymVrvggiQkUBgwQM13Z+V1aem69hNbJ9p+Nn2lcqc87xaBSmwKcs1v4rCzuTIhGjA4aGLDNq+6opVjh8h61n/EF23JUpx73pSkNU6IwKx4w=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS7PR10MB5101.namprd10.prod.outlook.com (2603:10b6:5:3b0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.12; Wed, 22 Oct
 2025 02:13:41 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 02:13:41 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/8] Eight small UFS patches
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251014200118.3390839-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Tue, 14 Oct 2025 13:00:52 -0700")
Organization: Oracle Corporation
Message-ID: <yq1ms5j4raz.fsf@ca-mkp.ca.oracle.com>
References: <20251014200118.3390839-1-bvanassche@acm.org>
Date: Tue, 21 Oct 2025 22:13:39 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0095.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:3::31) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS7PR10MB5101:EE_
X-MS-Office365-Filtering-Correlation-Id: 215403f3-1d8b-4ef2-70e5-08de11109e67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UiIwcl6KNUVn0IZzrLKWWUcBK1M6WXzgdP+cKW8g0nCFXxo5QZ1hBe938s0p?=
 =?us-ascii?Q?5FuZCjR5taDF8Do0/YLzKdj5UbE+VMGl6YfVS/hdsGqoBgK0Wwcrq8tFbPPR?=
 =?us-ascii?Q?Gy5sJ+jULTpxwmcRdUHgDomy38olGMiu7A69gtlN/q7TLZIUZRucwAcJTAgM?=
 =?us-ascii?Q?hMz1zzjx3UNZGD305k6ktbr8t9o5M3JoHCFOUyvKjd/t/k/kKhpnW2Cj6Iqz?=
 =?us-ascii?Q?cRt8p6l4EIvDnKpp61Nj+lcxB/r2947qcMR57CcVFSJmlMmut4RKds5la2RK?=
 =?us-ascii?Q?GBtTe7hXhL+6wH/iSa8Zpmk0B0cHVCbTPyBgzU5GTDP+wvDlz1p3OAmJfl5f?=
 =?us-ascii?Q?ioObLYfrGtCGKg6CV1SZpbSMM4t9bar5HoZIvHycr40MYO+i4tLeVIT0NHTH?=
 =?us-ascii?Q?YwO3Dgzt8eTuPC1KeqbWye2Z7+pT1DUSKZb6K/kh0m5X9ObvhHiSlgyOiEud?=
 =?us-ascii?Q?DKH0k68GI2yiXKY9SEvuEAsbjEt6+LA4wtONLBvsGLYc9UljBinQNfMv/rfo?=
 =?us-ascii?Q?6r+8ww75smmi15lzK20i+dz9ohDrPwRNPbOu0rEQ5wpZPt/6U7WnWs2bls5Z?=
 =?us-ascii?Q?Iy1Y4VwI3sDpPhd30PNdBaTXVaBl2TTTOVrETgUOnIXZHwzQIAPeUt0LjV2J?=
 =?us-ascii?Q?kjpzfPk5+bIkvs2MpqwRjXasIiYX7v8Efc2zo5OP49sI/UkHweNeWbwM2rQM?=
 =?us-ascii?Q?sSBIYtU8bhqw3r3FBTDAWdZUw2wmKKrl9++ba70KCYHnXYC3Dvx25agwWsag?=
 =?us-ascii?Q?vE9MgXcAGyuxruUs1s9dku5uYGbe7q8EbKXYGjWt6nxWHJVX188yeVZtvpc9?=
 =?us-ascii?Q?To2zI05WL9JhAd4LXB5FK9HmVeGiGL7m27S83PQij9s7lSp+116sVWhOObKl?=
 =?us-ascii?Q?1ouc2DSIBNuKJYOAZCWj1Xj7/Sc119e40X+Zt4n2nvvxe+xjHeCiWuI7zIJX?=
 =?us-ascii?Q?HKSNd1Q71z8naSBFefojeX8daU0DRH6a7omnfpOFrSuPsMwb+Z/QBsYIKT85?=
 =?us-ascii?Q?/dbiHWLSwf/jjDTT5F+wuAJrhsKiadSo+tUay+47FbPA2ZE9pmNA8PQc7Lqc?=
 =?us-ascii?Q?T6zeqvv7DixKR4REMWsGcs5+SP1f45DYwXsd5ucumIHD3cN9yewP+x4u78bW?=
 =?us-ascii?Q?GOLVKOeh8PP8TI80FHjWZ+2G7ucX0tisL68uaYZTTgDRLMq6A29O1pqM1j4E?=
 =?us-ascii?Q?L1BlSivcnZKgvV/l8huLZE6xNcp/7Q4HzwKFR0/y0zGabKKOb+lll9Po2u3i?=
 =?us-ascii?Q?GMCZTbHOSUs6nwjopwen17I8ZL6sgNesHcAF9Z1y5QJfML5ivPyWYUeWlZEM?=
 =?us-ascii?Q?WVHEnlAA+94X8r7Hc0ewK9/c2QqOEldCluwHJH9/pjgxxq2jmMFIaZWOSLar?=
 =?us-ascii?Q?cMGl1KusFf9pBdxJlkmWQqxR2V3Rmt9lsvEqlvHOZN5FtZrxZhyYCzrSnIBx?=
 =?us-ascii?Q?lGYj5B4qM743g8rLvt/4LEOsNUj0j8bL?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Hm3VtaJ5QYC7s346tSHA1zoxoW+Wx+kAlIqHfgEgcnYlcsbtIJ4dSoKScOWu?=
 =?us-ascii?Q?QLlcc5hl2u2y6Mtflp5KRHWo/Bo2tV8MZpJ+teoa1geZH3tWVc/turlA2dKF?=
 =?us-ascii?Q?qhO0vTR3cBOaYdDu85REvU8u1JN/0M2DL+9AVz7kQ6M4cdaor5AzaugdBdku?=
 =?us-ascii?Q?KxyNm+r/bQHF+S8Ku/4N+y6k4Uvc3lnTAkIlN/hQI6ZAphVwbl84/kdtK2tC?=
 =?us-ascii?Q?dTfqNQ5P5ylAJXGLct9OoGlTPGrqdkOYSaQKSpVVKG9dqEsK/TYzx8vu7zo8?=
 =?us-ascii?Q?I3nOkX4q5I3IZiOvZWfW1RbrB+TUlnELTHBxxEZx1/tYdI2pB/wiqZppqcnJ?=
 =?us-ascii?Q?YiRtxgUrISLznaUWWynMwsiGO6A2Dj6BCpXKtvw2fC54vwmzdiH0EQbkvqTA?=
 =?us-ascii?Q?ovwJt/zGnNW0/KDCwuuwOTd/iNLySeh+7/pNLq76CtWtZD8LTEkyE3qFV2hM?=
 =?us-ascii?Q?fatFi1lSbUDSBB9UC2lj5HiwDTr6eCvomucedmkxr8vvmW1j929eZffYDbQF?=
 =?us-ascii?Q?FFbXU51/GOCBJTpeKu2JfU8iaAUWUFyTQFhmqehahxhAd07cqgXx0+7p4xrh?=
 =?us-ascii?Q?M28s4sLPjoIsk5pfwFkRN6OpCGjXcv+Qemhsq2UsIV1MkO87On/rRVdYTgAM?=
 =?us-ascii?Q?eO6Nd4tO5fhNodC+jgceFGOaOu6dZvTBMvqYX2ry+8RVmkQ+T31YMWoi1NRO?=
 =?us-ascii?Q?X9CUdOGbKAJ+3JEiHOPr5ZMtWthEGJm0diH4U8ADRoRkM9+fYyKHExQMZzOY?=
 =?us-ascii?Q?4xCR+xaxblbVsZMYigVDj3qEtU8KHae925rLLE4XqIjRB4y4ipf1mRTjxSxz?=
 =?us-ascii?Q?WQmbrpdsAinQ6l4WQZIf4JCbDp67yiz4HS2Fyp24t9IjreWgaVY9epeLGMu6?=
 =?us-ascii?Q?VlARvdXPjPFD7x9EefvhQzvAv1GmEZz8Nha8HPUFAb1JSLAsBBoKOVYz4UGh?=
 =?us-ascii?Q?MKehSKXlxEpUQI2Q1JC4bZRuuwwQeW1jG8W5+PoBVrVdDYr+3i0CGCSjZwOc?=
 =?us-ascii?Q?vvI6Z3SBtceh4n0/v2GkNc3g7sUkKoLPAKWTEWTT1BjhGCY1MvqI5eo0l6cR?=
 =?us-ascii?Q?oyJc3Y4Ztyml8yPtqiC2z6HdijSopUXlDUem1KIM7rTZH3ZWMIAZIqDvkvP5?=
 =?us-ascii?Q?Jdq+E6AITCqnj5dZRSHgEVvdXc+Z5ht1GNkqNiBPYygRSfzjN1H0zbFLVXhC?=
 =?us-ascii?Q?RmZI+CzHJaw7AN86dfgmaI60SapP+gAUfBvz7OKC/br8J5zCSK/RXGJin/vP?=
 =?us-ascii?Q?98585MlfJ1/Q5DJU+BKMmIan1Jzd8WlIs/1LFK9PybvyVNweyIynz9EdTcmh?=
 =?us-ascii?Q?/8zM25P3wPE33mGtAJX66F/rog6KgccfCmC12+VKsK75+CQbP70m6dEp+YGE?=
 =?us-ascii?Q?yca++nUpWUlQgWDyjm1CBE1uwJDx9OZZjsQz06X7kjOTlGEQsHFdFByHWnhz?=
 =?us-ascii?Q?YEKNoZT3L2aHqBfdDy15et5Crx6iUwGOMReg8/g7RR0pDTUUNoyiNQQDJb1p?=
 =?us-ascii?Q?BPDHJPBUqPik9N3+lWXMnPRZEUfteO3LjDo7NgYMQxnVIxLVJVSEHgk3hcVP?=
 =?us-ascii?Q?9F6XmpX/Mu68zl6NH/x9QW4/eo6vIeMVJpBaCfjNUMFy0vWPug5H7jCub+FS?=
 =?us-ascii?Q?BQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FsW2UAL+ozy13AKT3hS8g+lI0hMJP2NxygFeZFQQH08TBa5Fv+9pZxu3nASfP6cjHKvgQ9+9GQiep/pNXjusx8K/X73Y9L18nolc9ZVdYHto3ubXSZ+VBKqdZG9OiJ5egNdrUhbUyyTOkI1FGlXD9iVetB3HSmvQHfoRiZjazBtePSJe3ArvZAzQi9g5k17w6PQbYjDP1dcH9UNGu99+Oq7RhjFks7d9IGlq1GURo2VtWzqJ3uYeC41FybUOvaCiQfwbM/04ecaoegBa1jP5er46+ZajpWoXdjneL5tPklC3r8+GXHkjLsxI0srzFVukrEcvJuGrZYyWjh3y4yfI7j7fSAXjYda7+DmOEckDFnCn/TM/nHHwmNBDl5Krtoty/xsF4fHVk83h26GnkvA4nlX/+vEaWunKjxmi+6nYyPv6hb9oX00/caUUxv1cMZU15ipxTjte+qwg8jF1/oe1di2VqM5agCPPOLcaGmFPaZA4MMP3FKVRPGJ4XSptKm6Oao7hTeBoByE/5ZKG5N/LQPdQSnqhfndAonJ87MpJrNBUitL+DfiMBNPZM/zSKbSh9nYWfmvsLNJfGJBznTCcDlOF1c9KNzUDPSvBZXRdtT8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 215403f3-1d8b-4ef2-70e5-08de11109e67
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 02:13:41.0056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7jX9A7bGeq9rNelTB1r7o3PB+/tFtwz67BnT/ZSV892sNUjIxb7WhIUdajagIKNmycPPbegkaVPeDgkh3nfiVhuuWNc8u/RGHeGgCC5iMX8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5101
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_01,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=859
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510220017
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfX4KQE8OrHKR43
 ivJS0Z5OgurcONqhSnCntSx/nKI5U3kztNZRJ1ckcmdXdtm8Jtgrb03ro1DC39yveetHqIaKiro
 FsuJTHOPNzsyqiJDbQT6Kr07bvTETZim4m5wypmDs9az1oo93kTWbW3JDADwUQSirMmprbn1rxt
 Prux1fU8WMG3PwAzX3LV00YVY4RIIHqjTI0i7BgHyfIXj0uFK1fVKSx2ZGXPoOTVeT73ddFkblx
 OTUULVY5+dGEGEN87hdax14sHU+ztnm29QP3/R00vAJwNRrexr1+9T/HXXGypSk3SaCZCYfTcyL
 bEVzy/1W8nfn3wjOfqYx4mzOr7YEU8yk9R6FdKCogwsoX2I6gtscR+M2uqNhKLY8vb2AVaGV7yb
 lk5EWZrmJd+O4IFKKakEF3GROIDQjg==
X-Proofpoint-GUID: 2LuB6BQSJjvmIximF5NT81WitAdn3NZz
X-Authority-Analysis: v=2.4 cv=KoZAGGWN c=1 sm=1 tr=0 ts=68f83dd8 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=G8YeUcOXE8J4SwgT9r8A:9
X-Proofpoint-ORIG-GUID: 2LuB6BQSJjvmIximF5NT81WitAdn3NZz


Bart,

> This patch series includes two bug fixes for this development cycle
> and six small patches that are intended for the next merge window. If
> applying the first two patches only during the current development
> cycle would be inconvenient, postponing all patches until the next
> merge window is fine with me.
>
> Please consider including these patches in the upstream kernel. 

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
