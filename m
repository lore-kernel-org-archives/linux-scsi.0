Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317443BB21
	for <linux-scsi@vger.kernel.org>; Tue,  5 Nov 2024 02:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730774033; cv=fail; b=Y19s8JXcpe0K3idOjEKg7TY9OtjISRW0f7vik/j4KYJyTdRzgJ+9RCYIc05RWu2JVikXQCVMaf84kpTJ3TAs9QvUgep7ftLQQcpeyqdpVmkYuPQHYXCazAgxRDxSqHtbrVlS+Hx6QZo5tzhkRqtM3wnOk34eIuxLrpPEp8GfI7A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730774033; c=relaxed/simple;
	bh=lgbtaY54zAXY8QyAmdwHL2B8eQ4R41ts3wwYfIYNDtk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=fp/AFLPPf3KT/arG4vhSVTdKrZNwy0/6zoMg7sOvc4hOMwI5fX/Wt5UoeGzBw1EgWZCE4vDtP5qnBxwIniWxWzwxJ/uuBMm4P2uX5cMr/DxmQuWGTy+3P6eTT3bdIpkNZUiCAkKLB9mhkxiPva5oSkW7Qx98+5OObGS+Z1lkBDM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PBmJgfFf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Gk+nt6l4; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PBmJgfFf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Gk+nt6l4"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A52MrhO024580;
	Tue, 5 Nov 2024 02:33:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=kyulmyifEO3Jk3CXEK
	qM1ctEwctWTPmP2nWRzWnzT2M=; b=PBmJgfFfLkNSv6ZCfxncH7KRIM75yptS0m
	so/RNRI6G7+tPLbRFNFo9QvG6wp35NBMPGHuc1qxxyxGU7seyC2LaZU6k5iJPtjS
	+2lr/mf6X1VlFVxs4hrePBaQo3Skx3xvxdweFg8ms6vtVhQv+PE96ievZFBYLIFP
	BoASu1k8SG9PdtEMACTTLF9Yl/kBTYFwONLOz+24vpwORzOkn1LOcV1tpig/6Llx
	waUc6Yt68O0br/VtOe6vA/Zt9KPl+6pUMEULOztoVrOeH2F/5oOwCqwTjDx9Uk4P
	GIjaFe/JCWIkVnA8riv0pG2+7JZmvxQLFwKsXAp5iNkKC1iAPOng==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42nbpsm8k1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Nov 2024 02:33:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A4NEAKL036847;
	Tue, 5 Nov 2024 02:33:30 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2042.outbound.protection.outlook.com [104.47.57.42])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42nah6g2jp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Nov 2024 02:33:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bf/mNyzRVCaFRfh3lOplldpj6W2MmeKSTJM0Pc9Ag+jiy1polLA6tc17rLxxmMelfHB93fDifVrGgNGny1ACVxqutWzJ8reB5ftKAFSl2qt2VTuipYUDJsyQRENELWYasD4i3waKrIvm/wDeI2kXDmXvpFBv5FaicaQNpMwspbvUUWzy3mIPqSvqLpFrvAT0q6HoPWs7N/p7GM5F8IV83jLavAUz8VSQDLoROFT3JFxqYKVGV8+grtlpFA9pqwtPHKTPpyZJkR6CDRMsZhedEC6U4Md/WYVWquphhWa/FwiCWxDUlF4/MWNWeEVN+4kvn9kRg5EG0dUmSozhhhQdtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kyulmyifEO3Jk3CXEKqM1ctEwctWTPmP2nWRzWnzT2M=;
 b=laGN7oyLGKgOiG8cSLJN/3mrFw9norrlz1KpjunbxQEar7Q5IhjOYpXAA8AZm98YgXXL7I5IX6mj34ALgOwzxoWhrcabv6EwOPKiLj/kPrTlzpUDA82q1EgDFsKzCBBlF93iYrzNaHHR/YWFnIpCNarBFz4VSQ7XMrxbhIwA98ZzbMMGaVQzxMOdylj/n4va9zXhdzzq9ALec8I60yTZ/iQuE9VqpNRGQpUnGwdaZfRkrQmfuzdeDhNm1WIMWVowvcV7zD7O4UQzqKDk+nXe9q7II7QSUCN2BEo4lATBt7xiSEddQpzaoNLp4oB+oiRJMytE86uoX/KnzVsrubWPMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kyulmyifEO3Jk3CXEKqM1ctEwctWTPmP2nWRzWnzT2M=;
 b=Gk+nt6l4+FmQfkUab3a+iZT2EMBRtyP0SyVGEowVDsed8lZkYiSnROlhW+k3eMM2N2/t8KIQE+677W3recCSWprmesKPN39GFVQe3hOMw2scS6qXZU+21giZ+HrLZFhtqydHqQDwuP7eWlMESMsGfPh4kH3NoE5oftQzqO2gxn8=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by SJ2PR10MB7736.namprd10.prod.outlook.com (2603:10b6:a03:574::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Tue, 5 Nov
 2024 02:33:28 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%4]) with mapi id 15.20.8114.015; Tue, 5 Nov 2024
 02:33:28 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi: sg: Enable runtime power management
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <40e8ff4e-9ffc-4658-ae1f-69ceee5593cb@acm.org> (Bart Van Assche's
	message of "Mon, 4 Nov 2024 09:25:17 -0800")
Organization: Oracle Corporation
Message-ID: <yq1o72u4dgh.fsf@ca-mkp.ca.oracle.com>
References: <20241030220310.1373569-1-bvanassche@acm.org>
	<40e8ff4e-9ffc-4658-ae1f-69ceee5593cb@acm.org>
Date: Mon, 04 Nov 2024 21:33:26 -0500
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0060.namprd03.prod.outlook.com
 (2603:10b6:208:32d::35) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|SJ2PR10MB7736:EE_
X-MS-Office365-Filtering-Correlation-Id: 664f9787-da5d-488e-6fd3-08dcfd423b1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PfyGxdCrHnJlHuogiytbZbMIfS9Ka0MHQZwjee31gl+ORSf4lA2liKDz8m6I?=
 =?us-ascii?Q?vb3OIaSlh6l8aye5x7joQ6not4bPyOpjmDzcldaSMqyJkj8pfuI1TzZW0uGJ?=
 =?us-ascii?Q?XD9JxkGtj7G/JoD6FusecTycc31gm6bFqP69BLCRfkiP7ibJUNKGLa3du7I0?=
 =?us-ascii?Q?PSS+tN6KxZJ7oD1XVaS7zTRYRtY/QSgqBj795R/Lvz1DWB6GNYxep+6771X9?=
 =?us-ascii?Q?RU77h5WZUmCLb0xzGxxbh7iCbOziSUbkPVzDprjZysse2dFnuezpNaDn8Rgh?=
 =?us-ascii?Q?7RD1QYJFV9J7BK3E/n9f8QS5CUvHUutvNWQV5cnHToUzqA7ssxKfonUVISDF?=
 =?us-ascii?Q?6oH/ntw230mVqnKqLV6RrS00jAubE6W1rqYUhH3qBnmVK/Fa+6c38qMXva9Z?=
 =?us-ascii?Q?DeeuTHLqcYMkmLgBvTIIx0x2oFqkqblz52GHmK3UUuvUQed53+wdj9BU3d4I?=
 =?us-ascii?Q?JKTlu+ZjiVEWWdpPfZu/2lacHcSYYIVeH4Xam56WgdrKl7fVipNZlGWfisBC?=
 =?us-ascii?Q?7AQmhWuwBIUjEKYWrRwTtPrBOCkyX0lYHvSuVDowbGEDxaZrDYZPUWCJ3q8Q?=
 =?us-ascii?Q?wDy2Wtmt0T7z8Rv5vFSeI99xULRyI8F1oHk8Trl+BIh4iYsPB2qHza6hPicy?=
 =?us-ascii?Q?pyRXOrttS2SKj5b+EWnrEzxhFMI00A8vrnNb7/GpWsFLSB3Jqiw7y/7PSNDU?=
 =?us-ascii?Q?8CJ1DFp+uGYTNm3LV3gskESJHwitURNiRAolZAE7KeRbVuUIEz1KbVo4WKkb?=
 =?us-ascii?Q?Vk63PrKfPPWszujmkURdkBSrAbXTGqzBF5WO97X6kiAdhscQFLdc/3iOn+d2?=
 =?us-ascii?Q?Cv7OGmQjbWhZVzhD6bCgBIOyXVGSslhI2NjIf0b6MiKZXJEUGLGwk3s8bjY1?=
 =?us-ascii?Q?yK4QjRV/DD7WWVop/WbIcROtLPSqzTU7k71dLWdv/1QUlIJVg4oqMg/jJWbP?=
 =?us-ascii?Q?oSOQWxcGgo+Z6eMRTacOjkBjsSjZwyVKk+T2ABzdkZmZX0GksDWOpHt5bayb?=
 =?us-ascii?Q?O3/C173krlyiBUs++aAD6dXtjRyN+qegR4Fr/U64wxZznIClodoJzxHx9/jB?=
 =?us-ascii?Q?x994Lqr6XSshccozOje+nedN5QUCuZo6h6/h3NoR/p1HHhx9Ko6p818wu3Ls?=
 =?us-ascii?Q?rdRlBs6pFng6X6Kzmqc4uRhUrcPGq3gus6I2ZvHYUY9llHoIwEhltqcLSXJw?=
 =?us-ascii?Q?Ep1AG/og5aWbrHHSrCHJn0ByBJ0kvow5uDpoURggv4wxx8pw+lX64JDpC8QU?=
 =?us-ascii?Q?mpElPisuYJc/U6k5oSN1of8TsFS718eQ0606Z+gH8m76mFKvlcHCMvAnvSp2?=
 =?us-ascii?Q?8SNMD7VMIWy4wcY8AucJlXrH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hZD+l0W7PxgAuO98ymtYlsRxx53XcbEaNphxEfKuzVWqnMgaXZu4O/cRr5Yq?=
 =?us-ascii?Q?W/Z9aNIbrVRvf/uR6ZuuJCpqZRDPX3AsjLU4AKifyn6SXrQ5IsVMh24gG0Y+?=
 =?us-ascii?Q?IzPUVdEr2Eu1L8G5kI3kFlTgpUqgwMz4zZ5A+Mz5QMeA5gdZ0a/zdFp4GEAU?=
 =?us-ascii?Q?wtbrY5D+J/OwDqhIAUu6DGdrQTmMdzq5nkpzG+5N8HlOoXMuUi6VbbJhK2H3?=
 =?us-ascii?Q?6kBFILwLORNYsFjo1DFLb7gcVsbyeMvhZYQVrzVnsPT5buDD9Gt4EGpTtvoQ?=
 =?us-ascii?Q?Vm1HY0gAZu5dSbgH8y0gzJwGCktoC4DGFcbXKWssx7pOlCJQX5Eve5nTkRVu?=
 =?us-ascii?Q?flK+XziJOuAFdStyCocF3vZBhPdvUFRJX9IE7bK+ydz7a04/q7PcjIyfQ+2c?=
 =?us-ascii?Q?pmLk6b92d9uRmK02rLCVNuQXmZ6EcMAh3eTKbH1czdL5fY+y+bM/Rf3iPaCB?=
 =?us-ascii?Q?nACF02C/Tlg6bzJeiH0xg3kMCYDaF0QHL/Dzt8SN62f7819ZWmO3Ltjm0VdZ?=
 =?us-ascii?Q?HB6AcVZWmwSbzn6bgJ9ahi4n1mXz207n/+iIWDCZlvGD7ZA5n0AOGlIDm+a3?=
 =?us-ascii?Q?uAvMIuHm1FqQr9qYc3G3e4MFnH5yKptYUjNAB9adMFB+efP+Fl7qy7ANHhBl?=
 =?us-ascii?Q?QJYInW8HJlNiUwMIfBgEixXuRi4MVAS+QdOackygy5e73E1vKxMhEZBZHR4H?=
 =?us-ascii?Q?GWTzDALOE8ccXZzPTO0ZFWZiBDjCKxXauH5+pRyYs/etu60tsHy2/j26UuHX?=
 =?us-ascii?Q?m4T+7NqRt5BKOphWYF4QSTBTUKSUGHycDlio77WLlCgRTFl1HKAdw9lnDfO4?=
 =?us-ascii?Q?qOJDm0j1aPvUMYKGiL/APb4nyftTeQ4TVGo5oNjKfw2wgryvJYLQDKE+TpID?=
 =?us-ascii?Q?3BUzWs06LKAzrlmVNOCIQdRDZTgQStKy2L/hzioBMuFNXdu4h1bbcTCRjuLd?=
 =?us-ascii?Q?lHD9Zm5VORNa1nZtsIANg/ImoS4N9fHd8K255MIoVlA/W7vdhTIXkWfSdkix?=
 =?us-ascii?Q?CoyXhkAtm86uwQZUDacHEbJbe1+26dLt7uH3wa8tm+nao/LzbCauselrKB6q?=
 =?us-ascii?Q?NedKQBkPEXW0clGieC704xIA9Ohs+R4ZmaJvE1ZZt60eoIFv8Z8dxHYOXSYX?=
 =?us-ascii?Q?V4SUUkjkCMAMMGqRKBQDRyxzdbSz2cVHByBlxACV4xHvreh01MG4aRYkknYU?=
 =?us-ascii?Q?8Vvr3ULKHb5ej0k6ez4CvLj4sRo8HYKChytbvZYTamkmzlPz5jNoWTaOqmsi?=
 =?us-ascii?Q?vHytCD5sQPS2LaXCuz35PPuO3V3DV1ADg6y3oPAn/NXHGdlp1+/jfzca4gOZ?=
 =?us-ascii?Q?JQSB2MyG5nvpaB26rZwz8N3K2qAfbfkdbjW/Ir8SAUSp8RrMLGGOHYQcD/a2?=
 =?us-ascii?Q?B5YFtu1LuqBORf8m2SHUIPVqFkjsUaoC9ygsjddKbDZaRG/PYV4GGUTRQS8l?=
 =?us-ascii?Q?XjO14XcI9um4Dzm0MFx7pBlZufMSpopGbG2Ty7oNxvqvA9gmmgIFTyEMc8aU?=
 =?us-ascii?Q?n7C2vMikOAsJMIe9w+xIYsBesfGzzXE7EhG32ptGfPbEZ2WmDQf4HSZcYoyw?=
 =?us-ascii?Q?Z6abJAbmW56Eazxr1cJMkwpQBX2BQZMILaqicARYlQbz30dE5436y3ZxJY5L?=
 =?us-ascii?Q?SA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ujACnpv0LXn26TAnY11mvfkGRmMybVKAuKx3UnxOZORjnuirGyBPPuSRsz8RododF93iWXIVWP3pxXNb1hNdP50IJDrr5gGLnEdmCMFugfggCsOrDT7vct7cdcPwCnv7iz/TOdyFnensv4CZJB0FDELgDDIvzrt9w76wNDq9N5yRgfXWb6MTyjblXH8ZjlN3McvJI7HQ66BQwRaoITfNJlbu2KniL1abaOQyYF57kP6F/6RBX8hgVjnhrW2hmv9ZbPx7DTG9SRCb/6HZjZ8pw9tLha/rSH/NctwvZGGg4WoUfvL+KNz7MLlIHwdguM8uag1DQ4Uqq9cAQI2rbC2/ARogVd/y1Sej789W8YVOwLbx9GNolIcCKX9pVNGDa9cZkLhcakkxBUa3gJ0xDxlNzbOz2FpGOxkRxs6e3TCfONEjko4E1miGtOj5vhY9/Ke+SdR+qYr+15+eHkvC3i1oqbYQJHOOk6/AaPdpdY8iTHFh6pfL3/jOCjPcvg1cVos2vD9NcRJlSoSCKdCMQFPPX3PZ27srzPXgfD271XT04b9nMtBYAplnV2zKC6qPtynYvPr61kTByXPxFT3lOhcHn0jlOX4onNTmyGYj/3PS4dI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 664f9787-da5d-488e-6fd3-08dcfd423b1f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 02:33:28.2232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5m9h5F029ZOIZWo/oAbaScGe9ZV9ux8iWY6uj6t1eL2hb6vzUmKToZ11TlEMHJJedHMhsn0Sj9eS5llo1VRAjVybViYOEZmUOMbpKKj4xJk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7736
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-04_22,2024-11-04_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=873
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411050019
X-Proofpoint-ORIG-GUID: AIdvT4apRFut35ORfgshu_epaZzuLCz8
X-Proofpoint-GUID: AIdvT4apRFut35ORfgshu_epaZzuLCz8


Bart,

>> In 2010, runtime power management support was implemented in the SCSI
>> core. The description of patch "[SCSI] implement runtime Power
>> Management" mentions that the sg driver is skipped but not why. This
>> patch enables runtime power management even if an instance of the sg
>> driver is held open. Enabling runtime PM for the sg driver is safe
>> because all interactions of the sg driver with the SCSI device pass
>> through the block layer (blk_execute_rq_nowait()) and the block layer
>> already supports runtime PM.

Applied to 6.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
