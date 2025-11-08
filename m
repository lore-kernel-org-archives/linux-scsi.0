Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3F622F74E;
	Sat,  8 Nov 2025 17:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762621902; cv=fail; b=V/VIIx0gSfngmYJ8j9tFB5G3rIsaY6HKBChJFDOs+k7vNxwmmYll1RZA3A83ePChXKBszshNUHX8md9QijWZvBNzx6WyRRTFLwQNvzYAb25hUUHQY8mSv0wYHW/O/JCW0+YJmTTUPWSnYZO8gxIRDJ7CBjvxF/9synt1hV3dzZ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762621902; c=relaxed/simple;
	bh=+NI9IL6/khUwcGJhdE/j9DM1du7NgVfed3YMFAWmaIQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Qg3gZVe3lWgPiezSq83wU+TBKJgOlZWVXx8WjLcf8xLsmxG2RtbdXYWK1w+5yPus9qOdpIEa9wVxl30W9w/Fs9WAU0p6MS4vdzqhKsHMujg6t9mF30c2heM2Yaf93a64ekVCJFVyeLo7yPmnAhI5aujA2wG1ipeSd3Mk4s1Gcck=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WvntA1Cz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=NEEYbjil; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WvntA1Cz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="NEEYbjil"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8Ft8Hk009413;
	Sat, 8 Nov 2025 17:11:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=T2T9Ds1seR6GfgYaol
	K1hoHeyCZHeJRe84B54j0GLnE=; b=WvntA1Czw1odr8BlW5aIosfh4r41rK+0kV
	SZTbfWWr6FMbos6D9EPC7T36BRgue8r9UD/9X0qL7SYPcMbxcQKo6imz3TBckklZ
	nHaYo6QgMPqoCPg6XHPDa55sbY/OT7XtB05YojcS6rZITaR14XfDJAdkGPYvPAMZ
	XgJkHVq3Ak2ERW6RBI/i50xm1Iic2W9KJSb8OK1ZBdv0w5UC2ViJ1vS/s2NTBwi2
	EkssZzBdk9dEYYu9kxLYxBmdVa8qx4V3hVgv+AzUve/zeSGg57Mx/MpRMvuxZdXb
	pIoKE7lfzl7bmdJITqsqNrupOHocFx57C+NpgeY+VJitDhygUB8A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a9vs8gnny-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 17:11:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8GsJCL012741;
	Sat, 8 Nov 2025 17:11:35 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010065.outbound.protection.outlook.com [52.101.85.65])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vaa6u2r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 17:11:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gk+yjC//gLgoAa0SJpNwImRTeuzy/mqAk+zswFAvLodXt27m8yWM63j4zNMu2ONfOsov3k59XM4etxwon7s3u7hzebNwQGZMVqr+HKT/pPpTpqIysB/zHL6Frk5U5T+3uAtlUug+oqgg/dQ+mGRb7w8JRIu8OjHXbes+hGfZiCmj5L2JP22/+nKp3kMpytgGVDaiiDVdb/Tb7P4m1A+AEMfVGX7w0cEVi0Ei5roffx0hBBknAuS3+DwLDowWQjXz8oefQ6ByMdboJmYy9JACRGSlKDgDqgyervlx3KijXyFaxX9z8iR7iql3DDVcWIWDw6KCe7FLhvb9h4T+bCN48g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T2T9Ds1seR6GfgYaolK1hoHeyCZHeJRe84B54j0GLnE=;
 b=ZwYcuWQVn91bBWhfdzjKiaZXId9miSDZbOa1ppNdz9/YHne6+0l9/rMvURARbWyHEx1bD9TWJvLvJGaA6kOFFhZy/KwPd77mnMKXhtoO3G2e77DUAD4EB0x/1qDwc5648sX2j6mmb1uvxixR78ft6MTpEfT2qD5/ZTypzLE2Y5s57sd6Hi+3jgXLTdcw5cKOfemf8hSaYG67wxG9NR1iTFvXcl4fjMF0JJg1t1sKLakPoXbzFSLGJZITTl2MC+HWRuoOOL1pGgWZYXQNqQuF1FNEXy7F54NecWTmbrL52AITYQsjAf67yDL626yaz37kODMMfQu5sWQtQguJ4FrQAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T2T9Ds1seR6GfgYaolK1hoHeyCZHeJRe84B54j0GLnE=;
 b=NEEYbjil86WmcJw033rbPNivPchsdIVOkfTwT95nbuB9SH86MzpqqL73VyImF2vugluzaO470f5bi6yJGlLbs3/S4B3dNlEWPULESGWPkQoPaTTnigwINFnGO/hfQzk83Dg0aOL35r+bEhwp2FSrRHvEbqWC+QJ7Kz2oDHHrXec=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH2PR10MB4391.namprd10.prod.outlook.com (2603:10b6:610:7d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Sat, 8 Nov
 2025 17:11:31 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9298.012; Sat, 8 Nov 2025
 17:11:31 +0000
To: Haotian Zhang <vulab@iscas.ac.cn>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: stex: fix reboot_notifier leak in probe error path
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251104094847.270-1-vulab@iscas.ac.cn> (Haotian Zhang's message
	of "Tue, 4 Nov 2025 17:48:47 +0800")
Organization: Oracle Corporation
Message-ID: <yq1ms4wjvpk.fsf@ca-mkp.ca.oracle.com>
References: <20251104094847.270-1-vulab@iscas.ac.cn>
Date: Sat, 08 Nov 2025 12:11:29 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0007.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:85::25) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH2PR10MB4391:EE_
X-MS-Office365-Filtering-Correlation-Id: f1cbcf2c-37ff-4504-e869-08de1ee9dce6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dWdcnrF4S5XVlX/jQ5nB56rqDTN14rt4aMKo14+s4tZ+2JJV9rGmAVYsPgT8?=
 =?us-ascii?Q?aNeBpH+6VMRhMtbSEFyGVNLFP27/eh99pTIf2jkieXZ+evL8D0Il0u0N7xbn?=
 =?us-ascii?Q?Gewmf6+UZ71W/XR4aNNuzgIK4FsOYZCOK6kKtFXUHdofPzIFTHaEmG3KA3tT?=
 =?us-ascii?Q?coRkJPZ6QWSlsrFdFPzU95yKys+HZpjhhLNlIZUrh08ZK5d9tqZCr0OMtsxj?=
 =?us-ascii?Q?FgliYaVsKQKhWqHppazCFHuuKo5Yg2r3lxhIDd75pC+bkPo7PJtXxseh+bkZ?=
 =?us-ascii?Q?ThbTA5nE9uVpFxKE4K4W/4Xq249/qqH+hsxmnMMVubegXovo0oq7/q48tFL5?=
 =?us-ascii?Q?IdzdcuGFXOKBSZNEzutU/VGnVDj5oEutcZ4YD9jx77m3ivL2IGqx9fvM5+yr?=
 =?us-ascii?Q?8K4BmHtJ4ASkshGZ2vIDbFGrWwOcDsFIRunb+860Ev/F+1rwLiXyfWtkD0TP?=
 =?us-ascii?Q?GFgI6n/gm2it8yvAtaK49QNlRNB0DOIEL5flaymHDGAqxhdOYNgsSzqKtivY?=
 =?us-ascii?Q?85poChbr6woglAtR4lCuEAWwz8KmqQ0TtPu6PVaNoASCaZpRgqqLuOcjDFsH?=
 =?us-ascii?Q?o5kZw4T9SO2GN1osC32n0TURwL7k7i72R+1D4PPZkM1Dq1XNXq148ofvbeHi?=
 =?us-ascii?Q?oetxzScWsjFAxQZK8jJLqGkGBH9ocaZazsSd7rvDip1sk9TVrMQIr6EIZO6h?=
 =?us-ascii?Q?cOQ3rXKbalQ941YvOZAXlU0bfrM2AvStrBRuA27BWrb1ZLLsjCAT+bcMgoGb?=
 =?us-ascii?Q?IeVtncMCYkPFHpTEaMuf9EaBje+bWsiPxsfFWsfv0lXLlI7i4lBRRdkdvkG7?=
 =?us-ascii?Q?JepRIKjIO7GoTiEgXU+7mUN3EZRfsawRJQoG3GLjADfSEIt1vk02Qm24TCZt?=
 =?us-ascii?Q?/DQl2CbuBfHHQX+WVLXBmtHCoXmfohAJkBsYPX6kklhyOssuXmVdiN155TBS?=
 =?us-ascii?Q?hywZmwUClDa010uRu9XoVtHXNAZ7j2SeTwPfxZvSNnnShbBgbUEiJ/Qzib/D?=
 =?us-ascii?Q?LoACnPnQ7Xt3rrbMgyLn+bMWhAcBZd5u6ChWffAYUWcJia598zR+vhCTLq7T?=
 =?us-ascii?Q?9HO3CSr0CQRMLI7duENuIRUeUTgn58nMIljSkjURAw5z78EfmB9qx1mNzBbs?=
 =?us-ascii?Q?cUSXOt75Hg502Bus1b+Ucdgn/xHHxkSc5pwSQ0IQZwNvFhZJLw+vw2fOrcEK?=
 =?us-ascii?Q?jgZhxj1XRzujO614SCtEq1nKLG5vSMUUSXgziDkzvOrtVagyC/zAk0TEfLkW?=
 =?us-ascii?Q?8oz54ZF0Y/Z9Twa26+uFzpVlNYHclCBHl5rf18BjmatsuWQ9HB7Tv9k4sSJG?=
 =?us-ascii?Q?+K2ueMMWH/BuowsgXdIw04WJoxsBC7VuKdmQmqRWXna1owNIuB2Ei6qqiI/k?=
 =?us-ascii?Q?iDnBEibRsxB0yKJx+Cu5WhmzvZaDNEfKq9gdj69WN0VKLSnzyr2Lw2IwrKIf?=
 =?us-ascii?Q?RYk/ChuEGmpPOMTk18DygqcUARqgAX/g?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZF1mNr/z8+sBR8y9sQ+W99GNVKHDQaIpcREkNOIC/PZ76RkX8J3aNJUkJizU?=
 =?us-ascii?Q?Av2R+eP78YjLZUJgEiJzT6nY+D03BhG0mqzj5TkatVD3yTBSS4ewr8LCZIui?=
 =?us-ascii?Q?zwj8b7BLQO6zYK0VtdfzIEVFQNw/Qt6yLDN3AswKUL+BpivF0RdmuOCIEuH9?=
 =?us-ascii?Q?ASTF+U20StwT7FH3HKFoUlkqvNsnV63yds67qe9LFT+6zInyFG1Zh+R6NAsm?=
 =?us-ascii?Q?FFk0CC7GsxclUqYprnfba9tub1IkY/DppCY8iMuGMbOMB0IxpOBI1K1LCA5H?=
 =?us-ascii?Q?lwYYzhPM02hVbcbr/yojsn2L1F2UnvrpMUWHTBl//doKfWGJ/ZWPs/2a715H?=
 =?us-ascii?Q?9ALr6R6t+vtHxJmrhLBO+cVzbHSsyrtgsa3hny40zE7lNHC8G2OEbBEOVkus?=
 =?us-ascii?Q?s+FQgUA3AbZNDNn57/NgQuyGDuftply2xPHx4uTGDZw06XsGlD+RaQxqAeot?=
 =?us-ascii?Q?R372RyoSWVR5kg1vXHv7JsaYkzyTtlMqhxAmq4WA0XuKRps4J0bpHYIjbOtz?=
 =?us-ascii?Q?QwTEk+QfUAyWDqUF5TGTqucrfRDnb1Ps6p67LQ58OuyWUg545EI+iRhQN2xq?=
 =?us-ascii?Q?N6MhfI5A9AWOBn3ZwW/bO2DlprOJBcVxV8Z1cc5NgGIPFDpTWNCiRh4vUhCJ?=
 =?us-ascii?Q?SGSlrmG6IIHOP587gGs12CCUYEPPfv+iBrmanJIRA69f8W1PiCk+tGPw8lIx?=
 =?us-ascii?Q?JK69a9Zv1pgoTEvAgUKJc+gA+VI4E4WPwe7+1LE5A7cp5DmsHcTmHAdtjkoD?=
 =?us-ascii?Q?XbOG8BtsQDE9ALfVSlWxlAC5e5nzcxVKv/0ugTge92DfS5wFEFYIl7st2SdY?=
 =?us-ascii?Q?lasS89ham51GQI4Dd3pNDqfFI5eB6NbH2kBtJ6BWfyoxDg0jSSCWrV92Eqoy?=
 =?us-ascii?Q?NNzmlTF2UB0dcKHN6dpoOx9c+mRIYj0NmzofqMc8MoTFlHqqL+eLXefcZHiW?=
 =?us-ascii?Q?d+jj2OgMu9OdTatEwTUxDNtSkOBcVY3WglAWKth/v5fdyU3Eg8/6UbDUWV0g?=
 =?us-ascii?Q?4QLj5uVLktX76npYaTryQeWkeXo4k8R1+BLUOQbVseODTgMk9NZ2R2YoZpd2?=
 =?us-ascii?Q?HwNFVktbADYL9w34oLXF17bZqJgY8I42423ld08HKX4gk26XeQeeLCbwJLpW?=
 =?us-ascii?Q?2UpYJrI3DUiP9PkhX+JJpE2n9J89XXE9hkC2vSpdDZtjNPx6v6ExWf79SKMD?=
 =?us-ascii?Q?uali9jEn87emzohO2yREJh8gAKlgNi8JHRcBBLME5aWwEFC5/0hkGM8H2S1o?=
 =?us-ascii?Q?wOUK8IhJscaW8Dner2dusxeOFEfVFSWXkcecOIaOgzcSzua0JoZ5nmkgZdMN?=
 =?us-ascii?Q?vTfUIg4BiJ55xD9h2fNzdl8znWfYU0WmMokU5JJ811QQfm80d+sno0086JQG?=
 =?us-ascii?Q?7m4yr4mTtqWdRXUq98EIzJCwnXBWgtR55KzTR2aUwhMDSl4Z1unw2AJ5ybJB?=
 =?us-ascii?Q?Tj+FKvIK34q/z5tiAMTelovuVRg7uKYUtESyh5i55F3z9SLmCwFETIm+JzbW?=
 =?us-ascii?Q?RoyudVM3ZKA2WEN0xADWux6h+YpqBs52L8B08VsvrWM2PckpbQrBtqPKS8jN?=
 =?us-ascii?Q?4Qyhiw09E9/A3gy1WDUUxjOJ9YJxNuqCUn/wk1a4u6mURumWbWoIRAobUuV+?=
 =?us-ascii?Q?iA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OJKowZomvektR5PoQ2ZVUHkX2A01Z9g/n8d9rPT4+7LrnIBbGL478m268zYv4IgR/D0xoehEfT+Fc4OWKxEvZPZeI2wKhngaQQyO+uIUKdrGMThh7ezDxEW52G2axKswLbjbF8YLuXXi8ORKaZgiosmUHbAYrZtqO9ZhzlUp+VF2OI7C9+6YY9H3dF2h+83RBeVHhWjVRu3JKERLDJ4aic2AyeKuEytk6ehgVfclzmY+y+z5NxR3uhYQm0TCYRRTBpHcVeB3WS67RgP5HWeJlhGCCMCQM4wixBjFv2gzF0Oww5LzI2E8THTnEuUHmY8Qc6rP7WaR4+Zl6EQm53MIm29ScfHtHoAKZIythenwfBOKMd9ocD1Svt+yT2fR5FN+DTmAOjLI1AqNz1oG1Zjjn+0CPvSFCaBveSBCZ8xj1iGrj0pVttWjoBEHDDGb/gJUAHWOjmGC84q5FTOfyDsDQEyv1hE01gehCPNu3wo4tXTowRIj9Z5RF6DqA6magqu0BYVT7t5Eo0XCazqgsd6dM7e+EbkNp20Fv8kAPRE25mVvGQDGtHS7cgjW9/YPPwyKo6KDbJmW6/lwuT04CFyVaMzseNWc/qVi5N6jcCQglU8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1cbcf2c-37ff-4504-e869-08de1ee9dce6
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2025 17:11:31.6571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5YrgFqCAVZP0ozE+fUZeZgmHxhU+SJMEux6CBZ7ysVg+IoElwPgcfm6siDeB1NyxlJKnwWasvWTYdB3TWEs6JMiet15NVpPgzdTbz4g3Sg4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4391
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-08_04,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511080138
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDAxNiBTYWx0ZWRfX2eJNJqDyQggu
 lHxkn5QHa9Z79LZe2bL6uYygFCEpAtRqPdQ2E1q+60HHXhWtRPnXtR8jhwTb0nhuCmbwIKIqj1u
 A6MEs/6ycGXG2sRkSHoyz6q6FFirem39rEB3/O74wiHGPPzjJSjLagjLW8sGHURWB7k+njunRWK
 hFKCzxAWGepEv5aIEqnwRn7iAnjN3ASD8a7JLmddW8DICeuPdVxJaa/J81PAfRgFrhKBuftbGj9
 v7yVXOkMs5eUqNVDzIrjSeytZVpOH6CAbuBPZhfTWoT+21rqCqThFSssvVZ8sDTgF2EXfQc3Ex2
 dlFhiGHlNcoVQWToj5dnqeeDcMKISzqAtNPUDtXeuyDP/zl0Brdao/v4n2gtj/GUd5ekJkhL4aQ
 IHdVvlps2L3u0fh4YUJMkfr6Nq96ekKgC06pCkvsDw3AKlNbt+0=
X-Proofpoint-ORIG-GUID: tecd9_kicQUnq_7yS5EdXSsufZMiWl9f
X-Proofpoint-GUID: tecd9_kicQUnq_7yS5EdXSsufZMiWl9f
X-Authority-Analysis: v=2.4 cv=eYgwvrEH c=1 sm=1 tr=0 ts=690f79c8 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=APdTsy1mPjVvL4qEmPYA:9 cc=ntf
 awl=host:12096


Haotian,

> In stex_probe(), register_reboot_notifier() is called at the
> beginning, but if any subsequent initialization step fails, the
> function returns without unregistering the notifier, resulting in a
> resource leak.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
