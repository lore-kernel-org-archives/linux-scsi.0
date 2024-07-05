Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED31414F62
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jul 2024 03:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720151726; cv=fail; b=lDufjINHWl/i/EDRUP+P+qIlFZ8RTreQ4U2HNI16B7/lMO46Y+nLCpY2TmT6qoYsbE6zmKSAwjRkX1/0w6RbGgUomHY/RFH4CdhaQDWFNMCVaEB+JeExqFS/2Ewzxj0hPsFoXRkeGuYUUpYJ7pYB+sxyUfUQS5LMuBWyQ5MRXSY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720151726; c=relaxed/simple;
	bh=ZQu+9bOTkKXj9wUN6sCirG2U2qkNbXb2DAZXMAQdc/w=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=J7F0Vi5yhHVMoXf3SaMZMKDLE3aC6hn4X6AbxgBYreeS2hcm5HPolWC6iNaC86qvISBTHzuMoN5EvyJZ3XeDCCEFYgL34MUC55P/Nto7/oJELNRkTMiEbZsFBA8BY26DEJByJtvwEvqkP240joTY9PCRMYvn+fd6Ws7Sed4/VKI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JJkMZ3zk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=djdd/vPr; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JJkMZ3zk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="djdd/vPr"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 464E7Shc016726;
	Fri, 5 Jul 2024 03:55:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=Q5BLQDjPRbvtIc
	B5k/ZDjw99wrpqwi9QbMWJzG12cIc=; b=JJkMZ3zkPFYtpbwWw5zbKX7pXhoUQ7
	/8dS0OoO/mpA2dRwKazfhVJ9aqtbOJNGgFGy12kH2UszJFG60B6C3VnK3cgeM8M1
	ahpb+qYWwA8whyYF7PvLE+OxJjyk+TLtITyWeAEbO/5k83ZD2ojQtcPn/syfp6aA
	ZpsPvgdVvWZXUvYxuVDY5KFvXwKAQvR8FvZdNEUFhfUyF3ScvYM8M0TtxMCEiM9W
	5rr7NfcEKFqpePhkLs/qieKbuWE+pzqGRnFoPMIBuJVKdHchBZSmYINi2FBgndIn
	6859hW88smNXLbmZoeVzC6UnR/tjaMNJVUhqzz3QVy8pbBSJJvMcK6YQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 402attk24d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Jul 2024 03:55:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4650XgUr021470;
	Fri, 5 Jul 2024 03:55:20 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4028qh0k0y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Jul 2024 03:55:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aAGC68JoAWc6vJroyaz4U99+rvNAfV6ZIpTaReytOWFIiYtrNIC7+khP6EtmXbXr+/9tM71/Egp30rz5G4D4rlrDHXlSbgAwZnqwDcz11jedK30meDFEWDkK+xyWdz7JAZCduBWbd4ybWz09VqKpAGNwI6/w2iMRFx5nzT2tf+dYIm7+ySaZUREQIleHXgMrTumahTxwELMXm+qNgrqUDAf0LXN2xiOlbCZA+LYjgG8AruslmQp28dnX220ghW1IDCVmQDYCQs8ThrWmvznu1Uuz7skIXlInb1RvgMi4XHHNy/ROiQLNCQDiNbZSHvPiF2LKdONJegIozCX+PvURHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q5BLQDjPRbvtIcB5k/ZDjw99wrpqwi9QbMWJzG12cIc=;
 b=VbYcxMQG/ciA0uKwNp82zHRD/TnCFX6IkfLNrlS3N0HNL+OT9Oh8gl22JTkypKTgo5oCHCuPsWKHKXqPU5UKPvOiWcem0YbW9ENU4mN3Nz3o/f9hvJ97zySm641o8S5fZlnd+YaReJITDC2JigUM77BhVdDfzSprBSOTyLSS8hLKc8mk5W8g1aGjSZ6U7TX+q3hkmbSF5bOFVsm6ybW4H166IN2fr39Wj7iiwkfpKepQSN8WhYGjGFT+WYIipsWE0nYflCenJgAdHXHWrMwW/BJHecT0+egq4oU0YH64iZYRKwSOGjRwLP5vTnYHvGKE8xiaxRzT8xh5d1psYsGfyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q5BLQDjPRbvtIcB5k/ZDjw99wrpqwi9QbMWJzG12cIc=;
 b=djdd/vPrD5U7tnBRyicsc2rc4HpRhkjT4IUvzefykBza3Z6nffNB0HWZYSNmcn4inOMlp2O5dTjw6oUUJmv6DoFg/2oXhzYejntILMkDdjnyPLUvBX8FO0MyVgyFazbgm437sUy+vMr8LZ73IJlg5Z7SM/gJVv8p3usl5ADAxyg=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ0PR10MB5889.namprd10.prod.outlook.com (2603:10b6:a03:3ee::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.23; Fri, 5 Jul
 2024 03:55:17 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7719.029; Fri, 5 Jul 2024
 03:55:17 +0000
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2] scsi: sd: Do not repeat the starting disk message
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240701215326.128067-1-dlemoal@kernel.org> (Damien Le Moal's
	message of "Tue, 2 Jul 2024 06:53:26 +0900")
Organization: Oracle Corporation
Message-ID: <yq1sewo8pd6.fsf@ca-mkp.ca.oracle.com>
References: <20240701215326.128067-1-dlemoal@kernel.org>
Date: Thu, 04 Jul 2024 23:55:15 -0400
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0004.namprd10.prod.outlook.com
 (2603:10b6:a03:255::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ0PR10MB5889:EE_
X-MS-Office365-Filtering-Correlation-Id: 0694e1e5-93ec-458a-00c4-08dc9ca64872
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?Nwkwv2W/Wkq2ivkSKhHIXcgSTHCQ7cuNJnbkkz4bJ47WS+GDHL7QAeXmXPUE?=
 =?us-ascii?Q?K11Iq8EFdbS/iRylzjWBpCZXUmhaT3JX/eHsFHuePwWVxBFOLD+sXb+SpwlT?=
 =?us-ascii?Q?Ue3rHaGLzjc62Qf7wF4LZEkRFaE8mSpjaRl/cv9OfZE1ngQ8DQZBl/MOjhkS?=
 =?us-ascii?Q?JV0zTGeAFiyXxw23Yec++MDW5gOAvgfFY3wYpxxRZdj7jWv23fsMzXhjS8j+?=
 =?us-ascii?Q?ALd2XMY9wQajUV+Pw6n7IjETk2GCxHd1ypvCxndVIFNYJjoZssCBUCXy4jn8?=
 =?us-ascii?Q?TB/WsL0wFGi4hYMN8mNgQbSOOEtVqqawIUd1ImYE5IjMBBSahmHMRxQyafVI?=
 =?us-ascii?Q?bipHpM45Q6nXAhVCwn446oyPOJEtP3TvxGIVDlMSNrAdfIPOL1vg+9/Twp05?=
 =?us-ascii?Q?eAfCADkB9milD78b0sEpXq9YoZe0ZvDlSUZOIaOFHjiBSZLDzR10jOBVJRkV?=
 =?us-ascii?Q?aCBRb7eg1bU20fWXpm8VrTpJi66WDspHlqffyIJrGSdVKYyG7dkGyIwdUgjm?=
 =?us-ascii?Q?VWqQs9T5trm5GsH/1GVEtIn01Z+86MRaxwdrSJRpfqLHJi+swpasJQhsHo4f?=
 =?us-ascii?Q?k+/291UdhywJB3JW3kuzi9Jy+Qg4363YDaOrNQjpbNtLFMB5tpiLKDGUX3Xe?=
 =?us-ascii?Q?RgPIBFdhxCDTUs4lZsSeQa2zUgTxhqJyVGiw6nfTdBvuzJWf8okKie71Jvsa?=
 =?us-ascii?Q?/ccwAvj7YdhvIr1/eOa1LgRtWwcV2Mwzv6aaoZbAdAXesLc7LfqWSnIm4r5o?=
 =?us-ascii?Q?J66WzKqzlppuN6SdFJRgQic4qtxyBhQ+nJY9Sjf+e6D6cT2IOF7DNbEv3Lt5?=
 =?us-ascii?Q?ttE3mk5vuDZBzM4qGRasQhx72S2S8x1DTen5EZhZ3yIEG1LayRS2KkWbtKFQ?=
 =?us-ascii?Q?6+Pi/jsKhc6HCs1rw387t/ozh0Skn6ToMDicd62LqqWdWyteRHzQxaQlBFZd?=
 =?us-ascii?Q?0U2Z3kWSk2cG1IFon3ug3cepcyxf5RGafJlk38YCXymkvt1X6heLViUoGCry?=
 =?us-ascii?Q?KvionmQNlRhmiqKyTHXXW3PqKOKgfAwsBCczuEikZgZBvaXLNScuYBTwbI35?=
 =?us-ascii?Q?gO6XlIUKrKBT8J1HU+V2X6UZSewYj2Yt7cMWpMYV0dEl5ZOkLE/5Z/WVd56c?=
 =?us-ascii?Q?+FeGDtKaYv+HwzqHbDyooRVHXKfJs/1+/mfK7TB/0rnGl1iCzMdpz8cUypAu?=
 =?us-ascii?Q?/tsCb1veADRBOgbPxwqnRWu8ZSeQxFy8KoF6MU3mqm2fx/SPW7kV6kj4Ix+a?=
 =?us-ascii?Q?L+AaxOkGLayIfIfwCtZO0XImbBdKlDNocwKToRQdClzt5jlUpcIJp1aA7+Lh?=
 =?us-ascii?Q?pO/n60SxUl4qAzYgINMMDXJ9lUVlFcR8zCTI+ws45OZJ5Q=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?3/aWxOZw8YRosbj5Zfcm07uTJYLPeKIJv5zpUPGf2Om7OU5+ne6RO9suH9FW?=
 =?us-ascii?Q?w56MCnBNAzF88G1tW4fjGK/GFX9cKWhl8FSSgNQwgb4jMyq30bbkYnwDoWdB?=
 =?us-ascii?Q?aqsXM90EA5WXtGmAQ1kEFySvXKdEILz+kaBJwC8EkZHgd9pcFRgxK6nPYvPi?=
 =?us-ascii?Q?QML+BI7xrgKQQpfIIp7371nz8YRuTFNST6Vhd1PgUBAgHbUvVJxwbaLYYTOv?=
 =?us-ascii?Q?Rrq5fteekF12dHWxC5kbT027Gfh9RRLB4lryAwevH6XMGjLg7fDSXtWpW0sC?=
 =?us-ascii?Q?eK8RzxFfYpLX6WnUVhnENo6ZvqkSTEg9Kg071Om/3hDW/C8oa6BDG0rRamwV?=
 =?us-ascii?Q?sxAmE0LTMMtU8g74ncU2K4ce8tS87Wkj/R/wiKAbr0JlYUPl2SZhswVBwCCR?=
 =?us-ascii?Q?qBK/vN7G3CWLUT5umJj1AOq9WY0vX8aqCyUi3PjSRn70fQjcXpd3YYZCAu4s?=
 =?us-ascii?Q?A4q6VZxqyXw7P3xriulZjZjLgPhpjOj3Qe7eiiGn6X47GKZdk8yBtjbxFG7W?=
 =?us-ascii?Q?lwYh9V2ealhlqRZjiuzjkVl0PuZ5Fy6miBvyQiJbkvbyRLnz1WaZeO3g0c8H?=
 =?us-ascii?Q?N27B/V1gSU4uOxMuDcVIWnogiUeke+r/fh/uuTLyaLyKmtVf+67/Vgw0nmJM?=
 =?us-ascii?Q?KYBiggOgr7GinxKkDvhXagw3bmzBX9GEvY51RNFJOfJYbD+4v5eV5+AITG2q?=
 =?us-ascii?Q?14tjr6GanWHmGnlVUZA4/pavVrKKusQ7/SunFo25ZYB3yGBNSNfSO1z15RO8?=
 =?us-ascii?Q?LDVeBA7uMdfKfWP/kJ1Z11vFm9v6a2QOdJUjSE+ZIXT4PvA0HdxqUKfApJgx?=
 =?us-ascii?Q?CCq8TIHghL5qxrLdIp7Ei8NDeEZ3cq4uLk6Q8fTnTjYLydVQvkMaX3pt96H5?=
 =?us-ascii?Q?Khr3WYx6ShT/qUOzE31q0HkzaNEUHOS33WfQnV10IKXWQmcTZaXmx0zg/G8V?=
 =?us-ascii?Q?+hmq7AmDYHpFDhaLbEqZ9BXNB1QW6teHSbaDdfgwfxQ56/r8htde21s5JiQf?=
 =?us-ascii?Q?68uqLmON5e+Sf6joqcFlqChbNvV0BfbmqHVoRAMyMyI3pgN+r4EDRGCjv0Sk?=
 =?us-ascii?Q?QFX29G7wo/PVmk0OC+l9ejO9y9qpk4Pg7u5HiH+o6S2Bp6/iF4dr+A7x/u9X?=
 =?us-ascii?Q?dHdpSdn7y/VOqtUGYSp2VFvYLXrG3mHW132LVH0oHRW/TCw8ej/JIHLZOjY2?=
 =?us-ascii?Q?lvnrkEDaTiboNinA+WnYAoxFSPECEUA361ZqPd7wvSQzlj+mGGu+k9E7FEyu?=
 =?us-ascii?Q?FtFhjnI8vAeCP1WckpXKXfuBCxtLxhXodNRpHhKA7Hvcq6WzRxzZhAUoNy93?=
 =?us-ascii?Q?sRE30HOzJwLfNHYfp33AZhsRshJs4aW6iaK1CJZihdCFBqQF+FxG5lbrGaz3?=
 =?us-ascii?Q?IpaUbft27/02jWObbPbl5ldGDV38SN6DTJ3HZUZ0QRvnj4i4vidwnfQWDOb4?=
 =?us-ascii?Q?qDpMEFVoxQZStg9HtVy63PhY7yoCE6nJxC7harCQ2jNyb1xges3hP+AQPD6V?=
 =?us-ascii?Q?4i0v8auh0zmtw5LSyCjzl0HIUhFC3dd5A1KXa0qtWZW+cV9OQ3N10aspU1QT?=
 =?us-ascii?Q?shRPr1MfjHMb0hb7uH+ewJnLH/F13rVNK3ABmsD8x2gIbS/TokY86fLBkZ31?=
 =?us-ascii?Q?2g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	YNLhwEsvgv/aQXo2joXXASEYaOBvIKBszs30s8IBnyj/9s1oYR172LqDhvzWtmEUIuM/T2RG4CHV7AmeyfHnC1rCoHoXJzPOjauIC1c2rkFHHfHHudTr1R+g6MpukMlT6zbcC03XZLu6Uq7UlVlMuDIqR8spZOCxrWBnG8Oa/nQpHqWa8kpV3FL3DBAGYIhSuNOCP3cS5y9y+kn6lcsrcJH8MVqSvHVlrWmR+vzyMbtHOoD2nX8WWDJGY1v4NrX8HfCzTAc7hIxP+zvvqq0F5oocQWzB8CvG1G5UlLlL9G2rKXKAU7goSLaf/Pq6o/ZfrG4vjKf3Vun6s6w/wdensgcZL6RsE/Tz8CwerGwW/Zqh8hWSQ8XdvLNcJKNxQF9U9zJesQNcBteO5ldHNwkpXO1Q9D9GBbnxAXr353xkQer6xWsbtFBpPP6TwDTGSJMuQC3JFNVpbcHVe/Nb6lSBbeymRUzFEvsl9oU1Kh//LDh4MpU+ST0N5pVCNxB+ybs9ng2Xx702rc5KgZOFNyZ61uvxcKf6i06Pg20TVgoKEvUc+/ZXP9hMywrPg2RZXhtYjp8YGjVcwqeqszSTX2pNg+/rTw6YZV3G5ehL8CvWYfA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0694e1e5-93ec-458a-00c4-08dc9ca64872
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2024 03:55:17.5216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WVpGOQW+4yIb+7tqkrljWOr/Eh7bnZ2X++Tf9mzBLV7OapqHUJDMH82/E0yHhbfRMDlQ/DvctuTdcREwKWK/jBtAZoDbjN4lWMSHwAE5kBY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5889
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-04_21,2024-07-03_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 suspectscore=0 mlxlogscore=464 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407050027
X-Proofpoint-GUID: 1vbDqK8rtuLDAboJo732vB9Al5CGZ_5z
X-Proofpoint-ORIG-GUID: 1vbDqK8rtuLDAboJo732vB9Al5CGZ_5z


Damien,

> The scsi disk message "Starting disk" to signal resuming of a suspended
> disk is printed in both sd_resume() and sd_resume_common(), which
> results in this message being printed twice when resuming from e.g.
> autosuspend:

Applied to 6.10/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
