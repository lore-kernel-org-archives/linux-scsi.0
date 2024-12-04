Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF472391AA;
	Wed,  4 Dec 2024 19:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733341899; cv=fail; b=GfQAVqlD9XxNcK7meHAQAvlvkGMvsakqR1LTPE31CXnRcYBwOxjtg77g/RhbXEpZbNlYbKV7rlvxl3r06klwHnrkLwdZ63F+MwVyq6zwHA2saUdis8W/pHX7YjcRVgOqvibljvqa7UpzoZ069fs8CZyZgnYoIOE5s3Pne5qZPN4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733341899; c=relaxed/simple;
	bh=ThE0CWu17Ag4g1hiY21ZDscI9thz8/J8+U+3yf1fMFI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=f1QOzFyiVqDj8qoRCw12+WRfBGZyNJZ2e0YBPOjK908ugtZXjfJiF7QQOmjBoS+7/wG1vbB92M+QFrXlTOyDwXqgZ/RONhhicB2TDYViuYmapJ4oP7++hZUHXAy4oXELs5PVo+7OfbRgXBkM9dpANTgdxWDZqaGBEIVpNXd2rAQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=j98Ggq9C; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dO+OEF9k; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="j98Ggq9C";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dO+OEF9k"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B4ItpM4011912;
	Wed, 4 Dec 2024 19:51:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=poJuwJryIEKy4ZYhPI
	wVmRuhv+4WJMupc2cEo+qpj8k=; b=j98Ggq9C6vtgFmNhtdG+XVfphT6GW+mTiD
	+Lc9PsePbiw9YpBO3W2c/skYaOMG1kb9RXXUQb8XdX/ebN29wbYPmwBbqTsQQVa0
	G4sIauQsG1BPX47JXGinxEWlEbY/tnrqBzJi/F1501x5r545LgOpibGpMdBDdlRf
	zGmS/RKP/GUEzUksbhkK080r3h40wwHTaaDMgxpzPeeTY2KBbx2kf43EvTbNq/Qs
	VPkaHqv2jz0aBI8n5Lrcszo7QpmkHWjpD513399SlZVfuKMwjeFfm6Mnco3nzDJr
	hnIfnHTUdz70TDnbjAwkA0xDjHLrCvod3N+Gb6k+BGFdR+wEuK9A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437trbsdm0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Dec 2024 19:51:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B4Jh66d001418;
	Wed, 4 Dec 2024 19:51:32 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2044.outbound.protection.outlook.com [104.47.70.44])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 437s59wy0g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Dec 2024 19:51:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZNlfpd5kgivn1fh9NTfv2aOwpRyI0XIyfK3eDJyLSYecUFm+G3JsnktTv3KK2/rErng1x2Do4bR+QVZB3y+sc1/6DwRTCKb1ZNvbQVDJMDvWmrKZfxUYouIiX00Cl/UsVYNEKy88+L6KHKt9zTh33eYWc8/kQOpCYM6OPY+fuGoyHYEzQbubK4cSrWbdsXSrWLRIPvBv8nk/m/gIQ8D1DEyFdarAM/48Vz8b1F8CNo6KByA+ls/Z7n5XiAcOgkKuko40wdS/Jh8GZTlqNOrHWtUNAtAKrPRqBOpgWjeNW8T3Przkxgdh1ufDeXsfYmQY/WnWmMOUhPLT1X1nq6iwsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=poJuwJryIEKy4ZYhPIwVmRuhv+4WJMupc2cEo+qpj8k=;
 b=cynACb8lQUG2+6b4VXHOgrVOUWyeE9LmyFCpOKoj7SS3BqO5MQtRFPqJD3hcQtJt/W6sHSe/drESeCt5Qp0K/8y9jvvWwDDKAWYEI7RJSAvcFa+e4lw62nGt1eao+p8oabbeBJqVKdPUi9SodcAsCpRAgPgfcyzERVbvrUq/gsqkgRr7/zkqP6HxhKzZfB2PefVcqwETwbpAIXMXt2eI5zXNochnt6lbUjAJcWZx5I5dK7NEcVOAr6gJzGQYUxxeEWkBdn6/5ePpBZzbsfEF5o/u1RtsU41VAIVdsZXpRwVSdV4wVpKuHbEHt09NA1AV7PHwcVLdTX3dS3ilCfon0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=poJuwJryIEKy4ZYhPIwVmRuhv+4WJMupc2cEo+qpj8k=;
 b=dO+OEF9k9638IaU4Xu62pHsc3Ujt3/G/FftTCYjl7Qq9++FXAvTzDhDPFhNBqh1L5Q4Xwa3b/m6k21RJP3AmoDeW7N5GQPnc2392GA0g19rd4nTeNHMggy1kSP3s6IkH/M+/o4jUEk3m3+6tDZi/Uka91Zu9yftu7DS1EhMppXY=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BLAPR10MB5153.namprd10.prod.outlook.com (2603:10b6:208:330::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.12; Wed, 4 Dec
 2024 19:51:25 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8230.010; Wed, 4 Dec 2024
 19:51:25 +0000
To: TJ Adams <tadamsjr@google.com>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Igor Pylypiv <ipylypiv@google.com>
Subject: Re: [PATCH] scsi: pm80xx: Do not use libsas port id
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241121194915.3039073-1-tadamsjr@google.com> (TJ Adams's
	message of "Thu, 21 Nov 2024 11:49:15 -0800")
Organization: Oracle Corporation
Message-ID: <yq1frn3qlam.fsf@ca-mkp.ca.oracle.com>
References: <20241121194915.3039073-1-tadamsjr@google.com>
Date: Wed, 04 Dec 2024 14:51:22 -0500
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0189.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::14) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BLAPR10MB5153:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fa3b2ab-2cb8-4931-7177-08dd149d0902
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xdjeM7BXN/UkOIvHVfr8sFDOkGQLlOkNrer4RRoDwx3TNfuIEIYqZ0CB6E+x?=
 =?us-ascii?Q?YGsjdGWPuHlmoNntw2q8mkPKR0lBwwNFDxpc0dNxW9O8kgFQT1ChoG80s/+J?=
 =?us-ascii?Q?xIGEJfm9OKykQFIYsc/lxwtDD9oi1H59GZoCXEanTf9tuIw4LP1GbrUFPFFe?=
 =?us-ascii?Q?gAUHyW06Rd94FhfTPLfs57BfhYQ740w3ErErtj+n3qCJ/4MNEKkk5GnXYMad?=
 =?us-ascii?Q?lHXmrRJaWkpRFQsCNGFHoRu7kOBHAndKNF2InSF9E0FwtmK7/W7UMW/87kkY?=
 =?us-ascii?Q?RMFWqMNgkayacIuxneDoZ1/Ee0iIOiO3xHjyvMLv2yyuyenJ3fYTmXYaEAue?=
 =?us-ascii?Q?9yOf428OCNXKaWXFO5/V9bCjwfq9KfbKFMecS+53rOl3kvo1dGCQ6FuJOXwh?=
 =?us-ascii?Q?yrTcr9A/ZrIh6al72VL1OCDAuzM5pH7rWFWJ73b8DeeC6AO8McKca4Lu4ucP?=
 =?us-ascii?Q?JIsUTwS9DeRfLgtcWwZUK4XJG+FySB6DhI4ErqvktZxoSeLCTdJ5jKCyoKHF?=
 =?us-ascii?Q?9OoRSjFa+KTHqZ+aFpDQLaf/1t94TkG7CjrjBtuWT0aVml4fFBsR4rY2BEMX?=
 =?us-ascii?Q?Ci/3uSylas3EpcbKbRj8gyXUtJPDkHoesxINGK9CYEjsIj13ECAkn+rRo1pi?=
 =?us-ascii?Q?PXF2cFbh07YSc7PGGX8Jb/yWiZWydlCUWfE4yWe8NtCj8UU+KjAJtI1CYwVe?=
 =?us-ascii?Q?4Q7lEGxwthXxzsjR4ytzWQR+4VKJk4lRJQLWBAAubA8fxDijeAnm0Xd9qFAJ?=
 =?us-ascii?Q?TDFNf5E9aIzhrzWkNJiN30QlOIT3tDArptNPhvN05rl0/9QohkREoMmEAtRd?=
 =?us-ascii?Q?LR4W5fKrYUaGSNu7MbgBBHibMrSxI7dncbtCPdyAKohVUT8NRd5w8PHveFv7?=
 =?us-ascii?Q?K2YlGfk/qor7dZ3jDmx9+fzDic9IOUDi+bMZrPzEz71yDsl+8lj31v8w6yTv?=
 =?us-ascii?Q?QvhrqjWLdT7TjIXIcGJlPRZ8SNUMcLcDr1FVeX39OsnXOXu8ncu+Bdn0Oy5w?=
 =?us-ascii?Q?y46nCld5VRIYUw+DGgBH6w0rvr0QbL7HqkLRCIgSRnoe00VFMhbdVvajavAO?=
 =?us-ascii?Q?NwS5S4J7v4O666RMV1Mp6ooBMz+D1cG+o+wRSgx42IYseEqwCMGNIf8i/ASW?=
 =?us-ascii?Q?HNt4B+Wvwaln2Hxxg+ScoQfeGltFpBM7LrOP/AOxs+lpnksYmRMkqnroXmjg?=
 =?us-ascii?Q?dKVJ4foUltQEJE0LGTgVzTUfXs1DTeGfELHHtnPyILpenS2FktknPYrX7Equ?=
 =?us-ascii?Q?tTmfFMKSNhSD/cXBoqzmZsxU2dpFxL/XtiloHC7BdumNiEqnqy3ZJIvyFyH8?=
 =?us-ascii?Q?meGZk2vkT0KKtQL3l9X81ggPnMXwfa9jc435EIssv0kIOw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DSACokGo/x7WIiu05Ydef17uz2l6gEOmEyjZB9aWn73nc30p7Vi4RxKSiVc8?=
 =?us-ascii?Q?wjeRfd0qpvcnE9LQTBCIhfXAcAewReTSJ76z10p5kaKvCiXSjnq9gsA+YxcA?=
 =?us-ascii?Q?OVoi/JMzl4kzOVsEhkeia5qCk6E6Vy7SQCyDAPGMZjkAICLg6xUJt6J5TVJZ?=
 =?us-ascii?Q?MqLLyfBAIGGY8Aty4YvO2s9p1k0F1ahLndMRz9KNc5ugjCFi5WG6qPgfP34v?=
 =?us-ascii?Q?g+FV3LLNc/TDY4eVnLXmJbu4Lm3ZE3sCEtEe9TfrfmAdWV0tSzcyAjjZ44dH?=
 =?us-ascii?Q?1WBPD6HCpEwmKSNT+a6qeYD+Vo7avLPPjCk2Z3D1YpjsIrA4PZKYWKGGwOFz?=
 =?us-ascii?Q?anrSWdeglj2LZzi2wnixS2Idh2f+X++RYvMrqpakAycMOEn/943shwelEwjD?=
 =?us-ascii?Q?411d0GFdJHPEXeCDQ1bKG50BHtGP1l8GyNAR1IrrY3IY/jg5aLEVOTlcGAIB?=
 =?us-ascii?Q?zRmeqkRNrAt/x1j571jZpsdll/EwOrHeXiBp7f6J/Ph6vnw8g7b8tHmqmqcr?=
 =?us-ascii?Q?6tvqnDqRaz5HRJD+v68aI0bVmMcN7xLA0XtJEg5ngnkOD+YMbefN3slDrV0i?=
 =?us-ascii?Q?ZSiMzqHDt85h2JRsOQoDBWT+dZz1WeOSxmKHhRgJMaw+q9sHciWiAcXhK/dQ?=
 =?us-ascii?Q?Oc4jpTcq53MKuBmw1y5yy2OBem6OluuZAkKNu+H54GJb3kqSVCJ5Z4j7amys?=
 =?us-ascii?Q?o/EaY2gDDwE/WZl7kmrXB7WMyv2KSDOWiROLygYV6vIdeZGCwf5VopM8mZd0?=
 =?us-ascii?Q?EoLyE2cctxa1GF+AJDJyPpqfaKWqoovdY9jf0nIE85yPVxSIca+5CrlArFBF?=
 =?us-ascii?Q?g3e96WrCg5DWOcohPuaLCM3maYHG8/0ivEvgjj6GoaGEB1ToLGMnU9sIZN+k?=
 =?us-ascii?Q?aZ7w08QHFkb4UnOgaNlDY/CY1LSgxjkgVqzhRenejGxPq5SPpy7afoHj5w0N?=
 =?us-ascii?Q?eb2vjLBaZrTn0AQdAWSbI1tawteVglhX3OXjv73imhwMjoNOHKl+9ZBlII7i?=
 =?us-ascii?Q?cLOcEgyNzAiEfE2w539MWftoemK8D0wkZGAvvqRNsi1ulDdnxFSH/L4kVqmD?=
 =?us-ascii?Q?o2T9yBa2vGj8DAHeWDD3CyOyXV62w3SmIFkene+An2GBOH0mxVUkedKCVG8X?=
 =?us-ascii?Q?CGp4D3whFKATCvMPVTcIkvBT0EKhkgifB1Cq/5pSMHS6YE7gcSxgPPYhHSvt?=
 =?us-ascii?Q?RAA8DHpics6fzwl4n7yU+CBu0BkXs+aNuJ/VSZ03FbdY24S/wUqP8CXUdg4m?=
 =?us-ascii?Q?KWKfqFvSrYc3HP2CxGU5+SbcGpWtsCkqMDQRryIC+rq+Dj5/VfNM8DZxelj+?=
 =?us-ascii?Q?ao+B+DbDVPlMSwDF8e26RnLFgbSK+0h+oqXDzOdKHgK0WcF0PCo20DvL5ZbK?=
 =?us-ascii?Q?3Pov4M5HV7POYQIOD33LP+RUd5AnVJdzP23rruJ8HD8Sf1xGKRutgprsYg+Z?=
 =?us-ascii?Q?UyRlYrZduHclAloPBzAQ0mMAjisvt1MwXEaLLMyjnpntWaKN8FprZGa5dkWg?=
 =?us-ascii?Q?nhKP0sZnIfqG/Xz/bftCQ1s5MtLMBuiUv1Vup7kr41PoNNU22veX6iT5Zyrs?=
 =?us-ascii?Q?tNOfPfiiV+ikMeLBe0xg/gt5oxUlomgdFiL05zSRhbTlfFHW90m7Aq5XafQA?=
 =?us-ascii?Q?1w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VDYuueJqqTTmYBHZrpwUkU1k+wc70Yurdhc6pbVzjRDCOdEmv15VRxhxR2ow4QnNcXF/gJWmEmeFVXHDIm7R1J/q1eKK91RKlDEeka3bEzilKjSrgR2TjFRAXK+UsX6EgoVyKDKGZWXxzAVDC6WDMQ5dw2i4kJdNgagPSSdnMgMMQygRmDJgYjwJqBCPC/gSs9oeaDMIwXQ/D1HBvwhn7TPlPLgc7sdA/RqSGpatCcN1r+HqI0IbryX6stkWWiF8plWWlwk9C04K+67ZgvbBQFvxvzcsXDehU7G19D8gyn53hi+J2T83bpP1QctfWy6ke3AN5DCFlT4a13/S6U+eWscCpYwpADzE4al4ZOSrczpEN2hohNrDSe1hHEWeDC62wJ6vaAI+si+4Cc0k9/vhWn6KwLYL2eXlFKV+0L5E2FL+BH5OI8BGu0CB0KaSrxgJX3ZPfKUGDpg0Ywp8lNfxXSuofTkFYuozHHbuctmvkJNKYX0YddxodYpyBN2zp7S8+GhBHUTFEQiGGHq9XAz0kcTm9eYyMlDI8F2z8ioGvk+TlUOG03XIz9qB3gzKf8d9Wq60qC+uUDGiBj7O9gaU+zlbBTjBtrR5OAMVXFe/6Yk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fa3b2ab-2cb8-4931-7177-08dd149d0902
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2024 19:51:25.1490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ojhsAXdPnpcQc5P236lE0k72bbWmKDNRHEvVg+arnEkCY7qMK67T8W0PM0jsSUh3ry3jpPLfHolK1Bs1SOubDDFJppeVBb8VM9cKXyVdlZQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5153
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-04_16,2024-12-04_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=620
 bulkscore=0 phishscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412040151
X-Proofpoint-GUID: ghHFFuWWcWeV_JhyrKWVOEaXiBOw9u9_
X-Proofpoint-ORIG-GUID: ghHFFuWWcWeV_JhyrKWVOEaXiBOw9u9_


TJ,

> libsas port ids can differ from the controller's port ids. Using
> libsas port id to index pm8001_ha->port array is a bug.

Applied to 6.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
