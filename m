Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537902391AA;
	Wed,  4 Dec 2024 19:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733341912; cv=fail; b=NlURMhWjwPhjlsxyTp0hFiPaVxaelUhk8eYSiDVtEy2IVxfCsCcCOvM79ekAr60nDm/UznMCTLSb5W4+oyHeaPzQ993f0GBPRDPrE7MzlNepV4k6AIQsuL33QNRQzaGHd1KZgzG4EgCbM+63zpWtuApsiEU3h8J3ikkkHkkg1VE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733341912; c=relaxed/simple;
	bh=7hyTSUKsu7xrweZbzYoFpz6sxdScBRRc56Q9l8KDZhw=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=IJaHT5cLYnc2qDs8/CI/ryL6TN5ZkW4V1cWDUtevQ/a5qMf2ZIF+8Vh+HekBo5UMvw2TeK0/gkXXQN7UYT/5DEVHxkW9kunq4QYB5x6+GYIJd+8yP7LS9bTD0oouy+Y6uCDFohcqARAc6Kd3zgNH9514uq74L9FlKqj8L8vQaTo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lWN9wFr8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RghoDMWL; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lWN9wFr8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RghoDMWL"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B4ItqLw018452;
	Wed, 4 Dec 2024 19:51:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=vRvrJi8clwhnLsvVME
	OZ4JRX44ePPfJq/cVI1RT86fI=; b=lWN9wFr8rvbF2kTh4X1KrwRkHcZ55ugxIA
	5smheaOdsBkN7HdBOI4es33aPQELFU/4MqCIEYgMXmG/Ib2G92HqrdGhy/jewr2O
	jL+vxiItIbB5C5DZctUL5a+vR6vCTkAWU8OFhqPLbYsilGje5FOEcZ3Oj1bOcRq3
	rugQ8l7rehFCg/D+aOSArwqKIkLEx1A6u+ZtFmUwotlu2u9sXByi+5BfWYFGzSaY
	RxfBQk76TYU9ULycU+R2UXisTbkcgYG2MiPxBv+RzEKtfoGpBz+rE0GNchByOQ9d
	sIcouODqL/5ZXde6k0eeNk5EvDKW4XHmw458ifN47X73HUFBWcfw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437sa01c4j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Dec 2024 19:51:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B4Jn94d020386;
	Wed, 4 Dec 2024 19:51:45 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2046.outbound.protection.outlook.com [104.47.70.46])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 437s59xtcu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Dec 2024 19:51:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HpQs0yGw5QFgTwm+ktkpo9d5ux1hZOZzt1zqUB7mna6JFDfH+P6oO0MGAzEFXcPBU1I90Iuu0ex3Q32nHdNzzQh0WcwA0EEF1hN75iOjulE+9xO7ffyEzhGz5srJ7mGtoJKLgf0VrRUCYPVmzdYo4tGUc4Vu5YzaZSsBKvXWVlPj1lPtiKHeEy2YNM1vesXpbLW0VwFsZI+avKMxamssFPcQkILMcXN4H779gUKvViWtsvKvKsKzw42lCd2xNurcX/fKyzyT4TbdzDcwAtAZTDISmeQDyNwV+AW7MSwWeYs453ntKtczJORbsXi8E/UqzuKcTWK9QjT82dgEivcOFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vRvrJi8clwhnLsvVMEOZ4JRX44ePPfJq/cVI1RT86fI=;
 b=nYPrGoduuopPqBy6GxeJ13dazfCrcsUuB/Gpl7lEO/SeWNo68sfsuTP36Ol0WHpVgwwQVO7p2b6or00IDVOERmNG7u1LG4fz5c6g6FDDardzub6quKbS72KnAx1odT2k7VBMZ9jhGIGOmRWWR4xdsqe+dW5WKoyk7gqh3X1cyBcnJ4zxg3wsTAOhM4+xXTAl+sHd8rxhO/SfYhfZ2Q1p0ZGhOjA02WySlTe2aaKfLI6yqwtiat3zKjbQnRNuOTLbYs9dVL4TjeFI6wWOEmcl+VhkcsSlWXNXzOVhempEiK3yxicMAcEedeahVK6hHn1hSFOAfpeUGZ4itrkgRD04pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vRvrJi8clwhnLsvVMEOZ4JRX44ePPfJq/cVI1RT86fI=;
 b=RghoDMWLYAu6eoFToWeoQDsMYZWMVf+s/j6XCPj5iN1JnVCKhMBenfGBzu463QVhs6bZ+HyXXwl3iZ5Bgu/Crb7UeZuXeXMgXxJPcJZMdWQ6jvAqfH2JcYnThgHfelji4qlp+fgzMoJDnkGjwxYHQO8jiJ8EuaTQ2SRV3E6PD60=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BLAPR10MB5153.namprd10.prod.outlook.com (2603:10b6:208:330::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.12; Wed, 4 Dec
 2024 19:51:39 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8230.010; Wed, 4 Dec 2024
 19:51:39 +0000
To: TJ Adams <tadamsjr@google.com>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jolly Shah <jollys@google.com>
Subject: Re: [PATCH] scsi: pm80xx: Use dynamic tag numbers for phy start and
 stop
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241125213343.3272478-1-tadamsjr@google.com> (TJ Adams's
	message of "Mon, 25 Nov 2024 13:33:43 -0800")
Organization: Oracle Corporation
Message-ID: <yq1a5dbqla7.fsf@ca-mkp.ca.oracle.com>
References: <20241125213343.3272478-1-tadamsjr@google.com>
Date: Wed, 04 Dec 2024 14:51:36 -0500
Content-Type: text/plain
X-ClientProxiedBy: SJ0P220CA0006.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::29) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BLAPR10MB5153:EE_
X-MS-Office365-Filtering-Correlation-Id: 206b7490-8d8c-496f-cce5-08dd149d116d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8f4vINlZ2+CDPiox9uaxVW8Byc0++Zb82/l45UgZELcWODFaggY0ghJKpDND?=
 =?us-ascii?Q?lcafmuVAYBJXerRH27UqVfKY4XfGXW7iEsmisNeBDVkBEvZC2FpHvcrVsGFT?=
 =?us-ascii?Q?1IQHA33SY8dL+FyQGy9zmqB5oTX5KIfm7jNGzXg1we9tRtmLx01Ezcbx7iZU?=
 =?us-ascii?Q?ntvgXL2lqzpKJpxEVvvrlrI7z3MgxEpR83oSW4LCBGsDse4nnYq3KTlEpisA?=
 =?us-ascii?Q?ea75OJz8ZSmdVxq8Cdd/MX7NXfUS1khgplIirVuPSLc6oaLN7JsYecCWzt0Z?=
 =?us-ascii?Q?NiNtj+9xxvjTdg7/4siCszEPZPDkhEenNFoySXFKQdtJRdWElQ/VoPw81QkQ?=
 =?us-ascii?Q?bAbMqbIR3KRHnUjKGqcBe/E9L6LqkTtHrxKdArCe4gyawUQaEs8wo7y1c9C+?=
 =?us-ascii?Q?bCFePZ+cHqYu9pGqTVlrTZi1jM37uUmAbCl6ASNbFpNCBD1wK9A6lGYhuRpl?=
 =?us-ascii?Q?OoOqsQ8yMJz9l1IxFIPigIS92HowCwISvBK0vqFLp4uLyJ86/BSP2fDgCrOl?=
 =?us-ascii?Q?SFpbRzKu1ZWJuAKIWyd9dgs1goqEgcyHn8jh2stwyrts/zP7SO+lERQVmOkn?=
 =?us-ascii?Q?t7HKKRxz1NrxiqFnNFEVzATbWK2Q9amNT6iyVc3+zduqszXLAyUYb4Q4CIrL?=
 =?us-ascii?Q?fSHGN5SzksSnnAzB0EH2xiqapMbla85x5x7HD1x0JFUfQoMJRTa0pAfZhGWp?=
 =?us-ascii?Q?i9A/c4c/4NPXnUPTE218Txibo3XZsnWzpm7AFXkgnS++M745BAsoIWyhA0di?=
 =?us-ascii?Q?L83rTNeMiwSjLVNAL7JJudCtsRvSj+0Cfur/saJ53dG99Zz9BI37dppQYThM?=
 =?us-ascii?Q?RPn9ybKLG9kYmqLGVBXvCrTBigl5szaCWmq73zWovBznLHLLPrEAXmQbNqBj?=
 =?us-ascii?Q?qk5p7nTAmN8aOLMCuJg6iU4OeKmwmwMErQtsJQFTjsJlYrjaQmKz9zt0dIlh?=
 =?us-ascii?Q?vr1SvWQiDdRwOaL+ECrLi330KLauY/Us1KJV9NjowQ51yyKXNEDHr/c1tMfs?=
 =?us-ascii?Q?szvBJ9HeqctfKfqHBrQTk9+kWMhyPE3+WTE5SC0LMQlFApAsHHdBrfIzSiMF?=
 =?us-ascii?Q?aw0bX1k/qTN7OkIWyFATbpk+bE+U9uUukPlG1k2UWbuoV17lyOz0CA+SoLJA?=
 =?us-ascii?Q?9Bc3WGGdM+PHM4ZUsvZRuy+8I7aJSUP4mBRMP6x4tkon+zz0AxksGB0e3EG7?=
 =?us-ascii?Q?ScxlLVng8TlBMeNiBNpPEbRyGW3rOjlrekOdSPMUA5hdZOFylS5Z1C1bo2vD?=
 =?us-ascii?Q?wvcvXOnOIF8+EI8qurv5SICiMlUNWT1Q55lG/S34pF/B6GxSKIjwp2sBlDFP?=
 =?us-ascii?Q?HHvo+iW/+qzaQK8CwvlxLQ7mwQtz94e0LWgCtkgk8ccM9g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xvkvEHSV/p7nlsDPxBk5Qz7HomiW4niHhx1NBaOfwVs7Jwk2oIKFcM9h0fnU?=
 =?us-ascii?Q?HSNOpTrUKDW78svldLQUZXo2ZNk3dWJi1pgE/UZC/1kaG55QL06weOno5QIG?=
 =?us-ascii?Q?9Njd8vdXQ7vjDCp/bPQl5BOT4oSLWxS+lO4xYQgDE+/6Ja/9HTDPCarZKsb/?=
 =?us-ascii?Q?6wXMidfUXR86vLKUMW8e4TjFjmtmqdadbCszAT/zWf5snt/K/hVp+IHqlwd4?=
 =?us-ascii?Q?lYGDw1Rcx8CXSlat2kqzjTqpaqYCHapIIYDyX9RkKgXWZjN7MyVfj4MmtuUJ?=
 =?us-ascii?Q?JjERGNCSAUIqErK5EtKx4IrC6EtHDYHUlGOG+q6TQA8ATCm9/uiWmGkHN1C9?=
 =?us-ascii?Q?lS5VDHLHkPLY3BOy1gYTP7PGnr44tmoBoOxHwJ69r+PVnUs7ySuFbaw4xlJf?=
 =?us-ascii?Q?iyl2SpkbYgKD/un3uMzY56OA15mVJZwXSlnDkos3+FRWIF6G5l1sH+ekRW2T?=
 =?us-ascii?Q?MC1klvkJ2eDqqYUWVNA1msCHuLGR92+fG+nLZmLhARIsqY/BlkYLR/u923Fn?=
 =?us-ascii?Q?TZAemzW5vny/v1b2sLo/q5kRozs8TFH76kIOTM20rkoCqyLEqCQwwIZWVn1t?=
 =?us-ascii?Q?3fT2w7JIM2Lr01T24JeJksLGBAuOjuLTj1YGhTA95RhrXk6GtBoRO3tAZgIH?=
 =?us-ascii?Q?H1sZ/nvqVPLgJLVIIZFha3rIASr/0Wc6lSe1sOoqz5MpcoehKrQEh8GxRKUC?=
 =?us-ascii?Q?7qYwZ7VKQ80+WB7aDyKlNhfXVSNdU9VvKp1MdDlrCJYggtlq7VssErkYDsSP?=
 =?us-ascii?Q?XKZWB3bFeQiuB2ZCTD1wdvv7Z6SmYLxUYBNM+Fb+mW44VLhSEm2kpzjvzpVf?=
 =?us-ascii?Q?2ofweWnDWmwT+KGzE65qTMPiXhrnHBrzerjR4PzN5ksEpyY7VuTB8i8kiX0H?=
 =?us-ascii?Q?skyQ7V+V+PloLYl4QD/SQ5uDb0rZ4bSQWtZB4Iyk4ff4yVvaD+2o8dEQfP3r?=
 =?us-ascii?Q?H6O/VMWFfkXPcgewainkLlCVDgPjWfkUHG9/cfAR3Yd52NDuWaQi+k30r/yF?=
 =?us-ascii?Q?otq4IqCfVa7C7Au67mKvn3H5hXlhoNYXX7PGjCSSXXaoneMYmTdLplyg1iYE?=
 =?us-ascii?Q?js0fzJeWu7QFe/59D6of8r6JzGNO7Uk/VZIWQtvitKP2aFr/pU7pyQWd82YG?=
 =?us-ascii?Q?DRstJjxDtiF0AdriEYb66IOw8xc/d0CmVzJmGgitcqW3fT2+40+U5erBYhcw?=
 =?us-ascii?Q?8pvRm4kiRXnOYfk/lpIz11TJFX2NpW/+K6dIDtwjEtmxuoKU6iHKRYpzB31Z?=
 =?us-ascii?Q?jGSKxzLeLyaicYKIns9EkuHUpyNw4thHTwm46TGGLsSerrwQrbBdDsc1/jZy?=
 =?us-ascii?Q?v2+v1i2Vq70hgZD8u6FtCZGYrcvyTym7xNlevnsKp1a5MjsvbXGjlumthCtr?=
 =?us-ascii?Q?CDPc7+zWqeD8B7CBTHZ43IIAmBfA9JITh0HejskxR8sUJFl6UwFR8jQ8PKjL?=
 =?us-ascii?Q?p7Q/JX/NXDaoa6sGNT+uePmwTtJPWqXCnEhRoZbE2V5IAoNUNVP9RZxI5d8G?=
 =?us-ascii?Q?3QKduxvRtHC/NhHL10OSqXpzU3iLpGMhJioK8LYEiqHROLJ6oIOHYXZOP1FP?=
 =?us-ascii?Q?s82rrTw+qttTHkAolzwnem4h1jojoYphZ1QhXmDu7IuoI1beKCBdh+mFi2Rb?=
 =?us-ascii?Q?Tw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	o2FDcf0czFXl/qteZNULdjPPfqVCkh6aCFbCGONUD0Q86AXqfjfTWEcRnaRPWZy5cf4N1RR+oF2yWmf9gt1ftREUXh3bVC6KjHdS9kwP+DhDlicL2I5+GPKpOZVBtv36iN2kyl68GmfgOnBzbCDd5ow+vePKsI1fQP/XYECj+rKvpot+n0HN4GRmTVzcTjYTQ4MuTvSEatJuLf4U6eUwC2kTBVg+6ZzRBB5L6r7T+QUEe+xBm15cCj8l7HDh+Qe3fY5mE5ssH8y9bUPH5r5pS++iMvPE0/3eWv9pkRLSPiXsLS0CmgErNy1EpLSIBVCQIrKynMCJKaoinT/yklknk3wicp005sI20UGSYTF8HpyFoUNt9MlS1wu8tme0ABQG6Ge4xEkIGXOIvOMHjEJkHAA9dNWB3nPQV5QNLUI3WGriFPl0x/Xpcx0aeUMdlS2E+gV9NYTAf6v0ouiqeU1eOZRgKxdqBSTJ/fzw5ZQp4bNMlf5I9x6XYsT/ajmcmb31MbhhLN7jS90hplm0tTM6kaT5yHXQjEyxBWApfcit7EGsiJSrobTCRbLWHRrFz1dHTlTSbPyS16pcpcSctnx6cqcezFbwxC8uG74f9qYP3rM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 206b7490-8d8c-496f-cce5-08dd149d116d
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2024 19:51:39.2655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tz/fyh81jdUubJCWltssU7ui1ThDB6nu2kkOqi5pdFpm7swpazFjwXEpmZbP2LZo4AGVE93pyPmZ+vs3LEJQtUNMVotY+2dAqAD3GIt082w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5153
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-04_16,2024-12-04_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=715
 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412040151
X-Proofpoint-GUID: TtzSaQUOHiwyH-nFOP1EkQf08TOeGbri
X-Proofpoint-ORIG-GUID: TtzSaQUOHiwyH-nFOP1EkQf08TOeGbri


TJ,

> Other commands were not aware if tag 0x01 was in use or not which
> meant multiple commands could share the same tag number. This changes
> prevents tag 0x01 from being used by multiple commands at the same
> time.

Applied to 6.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
