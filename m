Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A4F283C8E;
	Wed, 19 Nov 2025 19:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763582336; cv=fail; b=qy67BdZJoj0Kx69zJ3prVvo1Fxj/FQJXxXqImB3QdyxsJJ37tkLQfUgt1AJtVBCPZJ+bIiokb6lT8qDh17ueD9bhxbMAe4HpaptZ0wRiFQ/mIz910ugGLLLJsUcFoCJZGaZCBMpv1xMRcCsIkAJMaKDek6upLj0feHNfR1PqpqA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763582336; c=relaxed/simple;
	bh=ridPJeUP9RSXupu9AwLDxvTmkr3GuZREf2VDZn1AXLc=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iiGLSRLX/xXw/dpjYRbaw8VCepw+MGn3jTcUGvkU1DpGdDSylGX0PbLrgVjwbTnQPuQCcSFISJNyjlGAmt7nN1gAGicjlc/jt2hw6llDW0YyshgbyYYRrDDaiCAHgezquz+ElasXKey8vtfeRCMz4ibfnsANCx0GGblk7VWN07Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bZ2yaIZL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Cml5yBIg; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bZ2yaIZL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Cml5yBIg"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJJCOlA026839;
	Wed, 19 Nov 2025 19:58:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=FHhmAf/uy3Xt/lNZMd0r0+PBTA0bW8BmGILUA4IRdWI=; b=
	bZ2yaIZL9tPIVJf6FA1dT2Rw544soPcZILhKrSezp8kV5/JSAjWDxKb4za4kqqSX
	xHxnlHhE69IOMR5MNqHOz0psOaV1D6M3a9hb2IAIceGqb3FUivlQvgGBZHkquPSb
	+5t0T/7VDL3RWpW9fCeO4/kal3OkIOX0J6KmkH/urw1tBumym9MbTnBemeS/x457
	x/lS8T7JemjSRpOlqp9M2nBPtxm7q8zBopqS8wJWOxJRp69oGiqDigwF+nWOzxsZ
	j8AVzDOhgq+CSG8bdj51kUL9IaPTgAaS7IlOLB+nRmlXoGcaJZxAD+0Yjkj9C8Mm
	kQ300q7tmJj962OQwiYlxw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejd1fq5b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 19:58:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJJrq6C007164;
	Wed, 19 Nov 2025 19:58:50 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013025.outbound.protection.outlook.com [40.93.196.25])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyb3e5a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 19:58:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UNB/BZB/mcLWTpWg9zxtGvOpxAISTzuFNX3kxOyFGLFXAAPg7Q6FuaLP0bSOm6Y6fNbEMHrMs8HEaTkmVIQdLiTkeupQ7vhYWe9i3VJxWDwrxIDEtL8y78YP66lz7t8avQ4HYukC7BIltY0a2fMVL0cuBqDqX3RB3PJI3qzLUVrAfoq5UHrX3nub3O+3nC14pNxsUIm0+hP6Wtr8DQkX8TjSeXRn2xBtUXZtkGdrfK3OqC3Ucp++WD31C6oDT7vPACab+YuGp+QFM+xW8GuWULHSb4dQg42gC2y5sxIzCMoYmBtL6lopACYIdtNtJtl4/f4anX5+Zh924MLxL2ZHvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FHhmAf/uy3Xt/lNZMd0r0+PBTA0bW8BmGILUA4IRdWI=;
 b=XgtjKAQUyfWckYo9fU2YdQF680ovam85TKreZCd8wfCdcnem7LpyZdI/OpUy/gx2QklzL2bdxNNljJ8CRAog43WhPeSGjUCKMB9D9bRpG4TF9SGse8Lg5HdLZ4PXlXeBOjwD1f4NFcG/0kI9/kdz32o3NaXgabs4KrJHSahMU7h+Fli/uBYEIY7CbYrHHDdI87Tm3DsYVBRtOmRWEHVjnX8LFIwWcDWfRL1rSMh7kOPi260s8VVBUeGI+IUIoAuNFwQJpU6ZnnitGBGj2aGAinj3fQaj6w0g0vcVajBKRhbiJ063sJ89Bxwct3UGfDQ1rXL+wlbPT3HdGJplB6S6+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FHhmAf/uy3Xt/lNZMd0r0+PBTA0bW8BmGILUA4IRdWI=;
 b=Cml5yBIgYa0llfrYq41eQKEAV3VLnf5oYgBTiAR+FelylCjZJ5XTungwrrpGPScs0XE1ri6A1FtUmg4OcokDtnES3EUVUGQqbQvA0VhOQrgu12poigrrAvvvhW56bsfbsc2a4he6ZR426T4ivsdFQz2rCdJruROEmTDGRWfwAwc=
Received: from IA1PR10MB7240.namprd10.prod.outlook.com (2603:10b6:208:3f5::9)
 by PH8PR10MB6501.namprd10.prod.outlook.com (2603:10b6:510:22b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 19:58:42 +0000
Received: from IA1PR10MB7240.namprd10.prod.outlook.com
 ([fe80::6ac8:536a:b517:9364]) by IA1PR10MB7240.namprd10.prod.outlook.com
 ([fe80::6ac8:536a:b517:9364%3]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 19:58:42 +0000
From: Gulam Mohamed <gulam.mohamed@oracle.com>
To: John Garry <john.g.garry@oracle.com>,
        Martin Petersen
	<martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org"
	<target-devel@vger.kernel.org>
Subject: RE: [PATCH 6.19/scsi-queue] scsi: target: core: Add emulation for
 REPORT_IDENTIFICATION_INFORMATION
Thread-Topic: [PATCH 6.19/scsi-queue] scsi: target: core: Add emulation for
 REPORT_IDENTIFICATION_INFORMATION
Thread-Index: AQHcV93yoglogjgHLU6Wmr1ZRWkltrT4ha1A
Date: Wed, 19 Nov 2025 19:58:41 +0000
Message-ID:
 <IA1PR10MB7240FA764470DDBC324840E898D7A@IA1PR10MB7240.namprd10.prod.outlook.com>
References: <20251026191309.34968-1-gulam.mohamed@oracle.com>
 <b3c28b7f-503d-4e83-b4c2-b756150bfbd9@oracle.com>
In-Reply-To: <b3c28b7f-503d-4e83-b4c2-b756150bfbd9@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f3e58186-1c1b-4537-900b-8707ad116850_Enabled=True;MSIP_Label_f3e58186-1c1b-4537-900b-8707ad116850_SiteId=4e2c6054-71cb-48f1-bd6c-3a9705aca71b;MSIP_Label_f3e58186-1c1b-4537-900b-8707ad116850_SetDate=2025-11-18T14:50:39.0000000Z;MSIP_Label_f3e58186-1c1b-4537-900b-8707ad116850_Name=ORCL-Internal;MSIP_Label_f3e58186-1c1b-4537-900b-8707ad116850_ContentBits=3;MSIP_Label_f3e58186-1c1b-4537-900b-8707ad116850_Method=Standard
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR10MB7240:EE_|PH8PR10MB6501:EE_
x-ms-office365-filtering-correlation-id: 76a32597-78c1-4d9e-ea46-08de27a60a15
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021|7053199007;
x-microsoft-antispam-message-info:
 =?utf-7?B?ajJyREhlYXBjWSstY21MbGtZaUtiZ3Y5WmhmN1lVNGJxeE1tKy1kdWNHbkwy?=
 =?utf-7?B?MHNwbXhRWk1ZS0Y1RVphZFdRZlhGREJWMGZQRDFvcXYxUHZnVGpjam1uM0Yv?=
 =?utf-7?B?SXRITUlmS2ZRY0VPczFibmltNmhZcWNrSERSY3lkU0NPOXFYNi9KVWw3dzFR?=
 =?utf-7?B?b2JHdmV5QVBpWGt1bistUkltWEJyb3Q1Mistc2QwS1JDQ1hlcWJ6cnpjUXV6?=
 =?utf-7?B?djFvV0lyR0NaN2k4MlFhMTVsaGFERW1LeWI5Yng0U3V5RThZKy14dmdzNmM=?=
 =?utf-7?B?MistdVdMdjhVRVU3a1ZtY2FlbXJkMG1MUk9xU2tCaEdJcU1MR2QzQzBROThz?=
 =?utf-7?B?VEFMQTFsdy9iY09XWTNFYTZsUURQL0VzNUlIQnhGdE9CZzgwZFU3enBJeXRm?=
 =?utf-7?B?UVR2NHNFWDVSNzhtMjRYTVpETm1Iam5GVVhVN25ncTVhcHY4Y3d5YkxLUjV2?=
 =?utf-7?B?TmU1cVZlKy1OVjEvWXJRM3NOckhpUE1ZMFE5aHRZcDJYUlZIeXBscmQzc3BY?=
 =?utf-7?B?b3VmYVlkcXNQa2FiSDI2TGtWVGpmRG1RL3JQRi9RTG1zRDdMSHplRkRyTlNF?=
 =?utf-7?B?aXcvYlhlV294bFE4Rkx6U3FVZFlnY1dQZWxOclh2NTlvamtGYkltU3c5UDJ5?=
 =?utf-7?B?VDdwc0tiWWpFYSstRkpIVGtPMkpQYWd2bXZ2b3R2NEFPVWI3NGNFdHovS1o4?=
 =?utf-7?B?UW95Y3NjSTF6U0xOR05UUjVXQ2FJQ2lCRUF6V21wZUx2MVR0OHBKT1hCb1pr?=
 =?utf-7?B?Wmw2Y2FFRjZiZjFWYSstOHExRzhVeTFCQ0JnMGs1SXdrMU5BYmVSOUdVUTNX?=
 =?utf-7?B?c3BVbFY5YTdBcmlPWFJPdkVJWklZcTVUQXVvZW9XQWsyWHpZS29hMUhRa3lX?=
 =?utf-7?B?YUNXZVErLTZYNlVkMUpuUHlpUlo2bzJBbWR4M01iU0huNU5JUFB2Q1ZQZEU5?=
 =?utf-7?B?bHNFWWFkZURRdHV2N2w4bGxZWHBrS2lMSTdyVTRLM0o3VnB5QmVQRzdxbllL?=
 =?utf-7?B?Ky1QQXVWWXlBVHBmdjk5dGp0dlMzRDlmUG9PTzBDUjhCeTZscWhvbmF3S2Ry?=
 =?utf-7?B?UEVOaWJWdGZGVXJQcDNGc0paNFdsd1NpdkZ4clV6V2t2UUEzek9jRE1XaVNx?=
 =?utf-7?B?NVRacHZJdGhZVVZieURTV1NoVUdQdTNwNDhVVDc4VkU5em9hZlBGaWx0TGlV?=
 =?utf-7?B?dGhwcjNvaDZwQ2RzWnlDU21LZzladkJwQ2Fwa1RZVkRldFowTFB1dVE5Rkky?=
 =?utf-7?B?aTlBSmZJcDVQak8zMTgwSlhLUncvOVFpT3hxeWRDRzZkRjUxUk1kUjdZMDV0?=
 =?utf-7?B?MHV3cVY3eSstWG4ydGlvUlgvZDNEUFN4ZFE3d3owbDZjcjFOWVVTaTgyUWxz?=
 =?utf-7?B?UHdTUUxWU29PcmMvVGpINkJxRWJ1NnlLbmtUYWtIZWt0N0xyWE1UYnEvTlRz?=
 =?utf-7?B?bjdsRjVrQ2xzdzE1UC9iOHBQbGNBaHdpejZvL1dlOFp4SHRzSEljQjlmcVRT?=
 =?utf-7?B?RS82MjZkcjZpNkNXT3ZVNXpyVVFYeElSM0taTUxBNjdWd1I1a0tYWDI2NmF1?=
 =?utf-7?B?NTN5NE5qdG1MeTdJR2hPUU1tYm1PMWtIY1RHRWQwUWtjb0tCVzlwVEhEUjEv?=
 =?utf-7?B?SGgwQ05WKy11NHRYKy1YL1lJRCstdDY3RThFQkY4UVp2ZDZCYXVEdnFFaTN5?=
 =?utf-7?B?QXl5aTlmRDMyb0s3Q1dxYXZhcDlxaTRka3dzUkw3RVVuL3pIbSstYUVxOTVi?=
 =?utf-7?B?SmcvT1NZOFBMVWhwakwwTXFRSFV6YXJtWlNhVVkxVVYrLS9JR0hPcUZPNmhw?=
 =?utf-7?B?NlZWZFFCNlNsQ2xYQklXa3dSVEdwWGVEZk8zbHBXTmtOYVF6dnMySzhYc2Nn?=
 =?utf-7?B?NDBsUEpnMlA1ZU93YmtiVUpLUmpGR3I2VzhHZzg5cysteDdDTTJ3N0cwVXVT?=
 =?utf-7?B?bmdkMmFEcUNPVzJ2YVovMSstdXlrRjdMUHNJdVRyRkRmaFhLeWhnNGM2Y2J6?=
 =?utf-7?B?a2FWYm5uTXBUVUcrLXB4L3F3TXI0YkgybTYzQUMxSlgvdlFSVVY4RXRhUmN6?=
 =?utf-7?B?TVd1cTdyQ3o3Vk9wSDZyZ21kREJIdistWHF0Lw==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR10MB7240.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-7?B?OFBOUUZ2Ky1NVU01SmFUaCstY1BXczFZanFPUTNHNXVyaCstdzhDUm1KN0RX?=
 =?utf-7?B?LzZ0QXdNNHl6UmpvQTREUU4ybi9ROVBWbmxJOFUrLXc4RUVMbVdkbWVGcklB?=
 =?utf-7?B?M0tKMU1IZkdQQ0gzYTdvL0tUWUpQM0RWSkptY1dJVjhteDkxblQ3V3hKWVR6?=
 =?utf-7?B?cWZQcy81aDNVN3pVQ1VBN2JNZllHZjd3UWRFZWZ5RVNrankxTUc5eFhYRnlY?=
 =?utf-7?B?VVh5enBhZDhpcUwzaTNlaFVPMlVxaENjZ080UUN3enN1d2dwMS9BeHdVYUtG?=
 =?utf-7?B?U1VvTGMvREZrTGhtVFIrLTkwR0tWeUN2SWFOcFZ2ZEJYWVFUSndvY1NtRGRN?=
 =?utf-7?B?ejJQSnZ4ZHQ3UGdGL01MZ291eGxiYzBCRkRsYUc1S0dxL3MzeXZDc1l1U2RS?=
 =?utf-7?B?QWduMlhFalp5clh1UTViMHp5L1VlKy1DYnZ4Qk5MTHdQT0xyYTNQUzM1a0xK?=
 =?utf-7?B?ZnQ5V0E5T1RubG1LTzVRam0zdW5vZzR5a2hBVG94WU1XaHVFKy1yd3dRVzdo?=
 =?utf-7?B?Ylk5eHBkT01XTmtEWTBEbVBDNXovT0xVWnkwQ0JtMk1rSnhQZmpwU0dscGJV?=
 =?utf-7?B?YUxCWFVuWFRNWTJFcmc2S1Njb3NpcG1nbHFOL3JrNEhSLzE4SlZSUWZ2OWN4?=
 =?utf-7?B?cEJBYUFra01POHBlRVF3RzdiaEJldkpwRVVjL1B6SmNNekdIOFBic0J2NzlC?=
 =?utf-7?B?anNWVGtGVGFWdmtpVFlMY1lhL0hDSmZVYUV1Z29MSUI0S1FNdEQwTzNIbzE3?=
 =?utf-7?B?OTJ5NWtsYmcrLTdnNjBDT080WTU5U0pGbmJORXAzc28yazlZcFVOemR0cEQ0?=
 =?utf-7?B?TGpyZDIvMUJwT2xMNDR0TDN4L3owc2FNcTFoTE5OL3A0ZWtOQjd1VVprdUxM?=
 =?utf-7?B?VDQ1emhRcFRWVHpybVZiclFjRFdxUVpVYWNqb05vYzZGSG5Rcmd3UE91ZDA4?=
 =?utf-7?B?aEpxaWhaTlprblF2M2ZEVFlWNTJ5cTBvTDRkbUJYaHhSZkRURENKS0c3WXJ1?=
 =?utf-7?B?Mko0UXZWNjVDYjR3ZGIyazBLTkUybDl3YWpvZkJWSEk1NUxCeGwyVTQ5Mm9w?=
 =?utf-7?B?c0ZBKy1xNU9Ba3AyMistakFiNUpMSk56YVZlWmNnSmMva200VGV5Qkh6VlZo?=
 =?utf-7?B?ZjJqeGNBamIvMm1aT01ubXkrLUh5dkRGRzhxRnZNR0o1a2doYmllVUJKSU1H?=
 =?utf-7?B?RGRBbTNRRHNnaWt1TlRaSkkrLVRuUURQWGdNVVJOcjZ0SUR0cmJoOG9wckt3?=
 =?utf-7?B?alpJd1dFNGlNZU9TRUtycnJTOThtaTNtMVFQL2l2enNPRVFZd3FHZ1QwSUk4?=
 =?utf-7?B?WjFzeHArLTc0RW9kVmJWR1c4MDh0aHpmOVhvSk5pUE5GNWZSckdJNlNLZUZ4?=
 =?utf-7?B?YS8zeTJac2xCTVJnc2owSTFTRk84QW5wcThBM1kxKy16UWlQY09kTzV6VG1J?=
 =?utf-7?B?NzduVDFzYXF4USstWnIzQzFQd1hKdmZsdmMxd2dqb1JFZ3JrekxDc3pSclRj?=
 =?utf-7?B?SkJhZzE4NlZyVkgvNEV3dWxNRGNJSmkrLU54UzJPaW1iQTliREtyYVlYY0Vu?=
 =?utf-7?B?TGFqKy1Ka1NzSUxOQ0h6WVRBaG94WWtwbXVMbVp6bzlZS3FCdFJ0ckE1Nzlt?=
 =?utf-7?B?S3I5ODhPYVlycVJibDJ2L3RBNnZZcUpvbzQ2WE1yMDZtbE1lZ1RBWDNjQnZS?=
 =?utf-7?B?Z2IzYVJLdzZ0NnFreW5EWW5zWTVWNDU4RWNDa29WKy1lcEFGYldUTEM1YjJZ?=
 =?utf-7?B?U2VaTjRGZWlQbWJSMGovZEE5UDgrLWMvek9lbFVWOGFkSFdudWtHTEVKTXZB?=
 =?utf-7?B?dTIyVEtMWWJMNnk5bHZvTVd0UkQyOGc0MWRnQjFaOWU5MlF6TDdHMUs3c2Fw?=
 =?utf-7?B?dEFVTG5uRmg4T3ZiUFpXbGd1YSstcU80MTRtS0Jya0YzZ0t0VTdoRlNxSlVu?=
 =?utf-7?B?dnViei9rSzhqOERyaFhybGpPY29SVlEvaG0rLWhqaXNUaGh1THYzRTBXTldM?=
 =?utf-7?B?RnJWZmMxYzlEbEZOcWNwU2wwc2lnaElBOG1mWnpvc2dsSDllMFY1MTRlWUd0?=
 =?utf-7?B?MWRtdzN4bUhrdmpscjJFRVZaTGZGcHJ3alRKTVJmaDUrLW5JcWtLMEhHOFRT?=
 =?utf-7?B?Mm5oZHJBZ2E3VG1mTnprVzhsMEdacXRCWEduNjN6WXgwb1NCSFVaOHpiQmJ5?=
 =?utf-7?B?QzA=?=
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Tlhc1NcPzS1MtuG/jd3u6kxP3E8sxB8ayneXx3f7j2bhPDjpR0ojOUNjy2cRW3zlXmHwMs4nUDnrrxXitalOE/yZ7RgQJg3SE0AbGO+Yt5mRBrBVmlGftYqZy4VrcRACgtax1QtZmmMXNjd1tAvPBy9TOseDlAKnXDIC3hExtC0YyvUIoAI7nJAarNg+EpwBD7IWgFKCMxRBizkr0exxbcBCmiQmfT0f+W/2xy/x5lQnljZGsE38hPHYUJWfeZg7OaPEeq/4ywAs7PyCGr3KcwxJ2NHELHxhGM3sVziuLV7dIJOEk7LR9cAie+sio8CvzzuEKRB5D0rrX+y0MUMgqyg6PEDWWwJedqaIQGqx4ELzCf6eHa/oKnwzR1ms3m2rVJnWNrWdvwuefrvh+qlutjAx2nx582Asw4is/Qmwhexi58ty4LyZEIjfTEADdR6vewCUALNFicmHH0baAMssVWrHAq/az0XoQczTE8oblJSfJQNfpzHqygJQypIp9pZC7VdFW5nL4cSYrsPq2mgqGxBMGPN370PMTVXkmH9OtdIeXO1rBgf3QTUpNSj1fVxI3imAnI1YZ3cyKxW71EQ/pU1c9pQNPTKRE/OcnlQDdIY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR10MB7240.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76a32597-78c1-4d9e-ea46-08de27a60a15
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2025 19:58:42.0292
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3sCWoRj1X1qECCGl9n3A62phnrZUOpQKcBv4Y3tJaoJeWzZxX5Liv7LhDRl8VIJU9Vq7uHxuT/oKC4nc5Vynrqm0qMjrD5vgsYB0Wx8QNZ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6501
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_05,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511190157
X-Proofpoint-GUID: WVRltW47_1W_5IuN85rju1oD54bh4C1A
X-Authority-Analysis: v=2.4 cv=Z/jh3XRA c=1 sm=1 tr=0 ts=691e217b cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=wzW8d0FwaosA:10 a=YU3QZWNX-B8A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8
 a=mQvHCebiAAAA:8 a=CMrjcFoCT8Tabl-4JdsA:9 a=avxi3fN6y70A:10
 a=wsrb8zZI_WQ3QAEBCXTy:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfXzPSGXIFM9p2W
 v47Fcc/RMag2AolzUkorqKX8j+CxXTb5cOs5KEhg7SSWkBqvvIVeyn6Y0EH3NeOZth1Ok9bJyP+
 Qdf+2anZC8g1C6+1yexqbBuPIvjUHYgfojvRFTnTirnqkV+QpARiXzG0m/xASUHwSmwrDQ4t0iN
 KytMTRyYagkYwN3VH829kV7/77/oUNcXEJjtlK3VsQVPEHVPgvrsvqyIcX/zrDux+tBTL8ewMA5
 7qcytrx7C9rwWZIRn0I/m+HuK0kZbGlqBWh05fk6lD/ENLKdLCNx4qxzQAvoVkGGL5t2yn07hPs
 5/QQtFmEXE8Pv4T3WFQegA2fEd7VmNGuXc78nIw0oqvP9GO4Q6cLQIQyR552DQqZnWdmkv8ifck
 rTjf3SjkFc0s1842VNDDrhf6R7zNyw==
X-Proofpoint-ORIG-GUID: WVRltW47_1W_5IuN85rju1oD54bh4C1A

Hi John,


Confidential- Oracle Internal
+AD4- -----Original Message-----
+AD4- From: John Garry +ADw-john.g.garry+AEA-oracle.com+AD4-
+AD4- Sent: Monday, November 17, 2025 9:49 PM
+AD4- To: Gulam Mohamed +ADw-gulam.mohamed+AEA-oracle.com+AD4AOw- Martin Pe=
tersen
+AD4- +ADw-martin.petersen+AEA-oracle.com+AD4AOw- linux-scsi+AEA-vger.kerne=
l.org+ADs- target-
+AD4- devel+AEA-vger.kernel.org
+AD4- Subject: Re: +AFs-PATCH 6.19/scsi-queue+AF0- scsi: target: core: Add =
emulation for
+AD4- REPORT+AF8-IDENTIFICATION+AF8-INFORMATION
+AD4-
+AD4- On 26/10/2025 19:13, Gulam Mohamed wrote:
+AD4-
+AD4- In the title, why +ACI-REPORT+AF8-IDENTIFICATION+AF8-INFORMATION+ACI-=
 and not
+AD4- +ACI-REPORT+AF8-IDENTIFYING+AF8-INFORMATION+ACI-?
Sorry, this is by mistake. Will change it.
+AD4-
+AD4- +AD4- This patch
+AD4-
+AD4- git grep +ACI-This patch+ACI- Documentation/process/
+AD4-
+AD4- +AD4- will implement the REPORT+AF8-IDENTIFICATION+AF8-INFORMATION us=
ing the
+AD4- +AD4- configfs file pd+AF8-text+AF8-id+AF8-info in target core module=
. The configfs file
+AD4- +AD4- is created in /sys/kernel/config/target/core/+ADw-backend type+=
AD4-/
+AD4- +AD4- +ADw-backing+AF8-store+AF8-name+AD4-/wwn/. The user can set the=
 peripheral device text
+AD4- +AD4- identification string to the file pd+AF8-text+AF8-id+AF8-info. =
An emulation
+AD4- +AD4- function +ACI-spc+AF8-emulate+AF8-report+AF8-id+AF8-info()+ACI-=
 is defined in
+AD4- +AD4- target+AF8-core+AF8-spc.c which returns the device text id when=
ever the user
+AD4- requests the same.
+AD4-
+AD4- It would be nice to a mention a spec reference for the command.
Sure, will include it.
+AD4-
+AD4- +AD4-
+AD4- +AD4- Signed-off-by: Gulam Mohamed +ADw-gulam.mohamed+AEA-oracle.com+=
AD4-
+AD4-
+AD4- Generally the code below looks ok, but I'll be nitpicking a bit...
+AD4-
+AD4- +AD4- ---
+AD4- +AD4-   drivers/target/target+AF8-core+AF8-configfs.c +AHw- 55 +-+-+-=
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
+AD4- +AD4-   drivers/target/target+AF8-core+AF8-spc.c      +AHw- 82 +-+-+-=
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
+AD4- +AD4-   include/target/target+AF8-core+AF8-base.h     +AHw-  4 +-+-
+AD4- +AD4-   3 files changed, 141 insertions(+-)
+AD4- +AD4-
+AD4- +AD4- diff --git a/drivers/target/target+AF8-core+AF8-configfs.c
+AD4- +AD4- b/drivers/target/target+AF8-core+AF8-configfs.c
+AD4- +AD4- index b19acd662726..ac78a106e0f3 100644
+AD4- +AD4- --- a/drivers/target/target+AF8-core+AF8-configfs.c
+AD4- +AD4- +-+-+- b/drivers/target/target+AF8-core+AF8-configfs.c
+AD4- +AD4- +AEAAQA- -1726,6 +-1726,59 +AEAAQA- static ssize+AF8-t
+AD4- target+AF8-wwn+AF8-vpd+AF8-protocol+AF8-identifier+AF8-show(struct co=
nfig+AF8-item +ACo-item,
+AD4- +AD4-     return len+ADs-
+AD4- +AD4-   +AH0-
+AD4- +AD4-
+AD4- +AD4- +-static ssize+AF8-t target+AF8-wwn+AF8-pd+AF8-text+AF8-id+AF8-=
info+AF8-show(struct config+AF8-item +ACo-item,
+AD4- +AD4- +-           char +ACo-page)
+AD4- +AD4- +-+AHs-
+AD4- +AD4- +-   return sprintf(page, +ACIAJQ-s+AFw-n+ACI-, +ACY-to+AF8-t10=
+AF8-wwn(item)-
+AD4- +AD4-pd+AF8-text+AF8-id+AF8-info+AFs-0+AF0-)+ADs-
+AD4- +AD4- +-+AH0-
+AD4- +AD4- +-
+AD4- +AD4- +-static ssize+AF8-t target+AF8-wwn+AF8-pd+AF8-text+AF8-id+AF8-=
info+AF8-store(struct config+AF8-item +ACo-item,
+AD4- +AD4- +-           const char +ACo-page, size+AF8-t count)
+AD4- +AD4- +-+AHs-
+AD4- +AD4- +-   struct t10+AF8-wwn +ACo-t10+AF8-wwn +AD0- to+AF8-t10+AF8-w=
wn(item)+ADs-
+AD4- +AD4- +-   struct se+AF8-device +ACo-dev +AD0- t10+AF8-wwn-+AD4-t10+A=
F8-dev+ADs-
+AD4- +AD4- +-
+AD4- +AD4- +-   /+ACo- +-2 to allow for a trailing (stripped) '+AFw-n' and=
 null-terminator +ACo-/
+AD4- +AD4- +-   unsigned char buf+AFs-PD+AF8-TEXT+AF8-ID+AF8-INFO+AF8-LEN =
+- 2+AF0AOw-
+AD4- +AD4- +-   char +ACo-stripped +AD0- NULL+ADs-
+AD4- +AD4- +-   ssize+AF8-t len+ADs-
+AD4- +AD4- +-
+AD4- +AD4- +-   len +AD0- strscpy(buf, page, sizeof(buf))+ADs-
+AD4- +AD4- +-   if (len +AD4- 0) +AHs-
+AD4-
+AD4- Can you just return early if len is too short?
You mean to return before we check +ACI-if (len +AD4- 0)+ACI-?

+AD4-
+AD4- +AD4- +-           /+ACo- Strip any newline added from userspace. +AC=
o-/
+AD4- +AD4- +-           stripped +AD0- strstrip(buf)+ADs-
+AD4- +AD4- +-           len +AD0- strlen(stripped)+ADs-
+AD4- +AD4- +-   +AH0-
+AD4- +AD4- +-
+AD4- +AD4- +-   if (len +ADw- 0 +AHwAfA- len +AD4APQ- PD+AF8-TEXT+AF8-ID+A=
F8-INFO+AF8-LEN) +AHs-
+AD4- +AD4- +-           pr+AF8-err(+ACI-Emulated peripheral device text id=
 info exceeds+ACI-
+AD4- +AD4- +-                   +ACI- PD+AF8-TEXT+AF8-ID+AF8-INFO+AF8-LEN:=
 +ACI-
+AD4- +AF8AXw-stringify(PD+AF8-TEXT+AF8-ID+AF8-INFO+AF8-LEN)
+AD4- +AD4- +-                   +ACIAXA-n+ACI-)+ADs-
+AD4-
+AD4- I think that this can all be a single line.
+AD4-
Actually here I followed the existing code style. Mike also wanted to restr=
ict the columns per line to be 80.
Let me know if you want me to change this.
+AD4- +AD4- +-           return -EOVERFLOW+ADs-
+AD4- +AD4- +-   +AH0-
+AD4- +AD4- +-
+AD4- +AD4- +-   /+ACo-
+AD4- +AD4- +-    +ACo- Check to see if any active exports exist.  If they =
do exist, fail
+AD4- +AD4- +-    +ACo- here as changing this information on the fly (under=
neath the
+AD4- +AD4- +-    +ACo- initiator side OS dependent multipath code) could c=
ause negative
+AD4- +AD4- +-    +ACo- effects.
+AD4- +AD4- +-    +ACo-/
+AD4- +AD4- +-   if (dev-+AD4-export+AF8-count) +AHs-
+AD4-
+AD4- I would check this before any of the string correctness

Yes, I think its good to do a check before string correctness. Will change =
this.
+AD4-
+AD4- +AD4- +-           pr+AF8-err(+ACI-Unable to set the peripheral devic=
e text id info while+ACI-
+AD4- +AD4- +-                   +ACI- active +ACU-d exports exist+AFw-n+AC=
I-, dev-+AD4-export+AF8-count)+ADs-
+AD4-
+AD4- I think that the following is better, i.e. keep fixed strings on same=
 line to make
+AD4- grep'ing easier:
+AD4-
+AD4- pr+AF8-err(+ACI-Unable to set the peripheral device text id info whil=
e active +ACU-d
+AD4- exports exist+AFw-n+ACI-,
+AD4-       dev-+AD4-export+AF8-count)+ADs-
+AD4-
Sure. Will change this instance. This also I followed the number of columns=
 to not cross 80.

+AD4- +AD4- +-           return -EINVAL+ADs-
+AD4- +AD4- +-   +AH0-
+AD4- +AD4- +-
+AD4- +AD4- +-   BUILD+AF8-BUG+AF8-ON(sizeof(dev-+AD4-t10+AF8-wwn.pd+AF8-te=
xt+AF8-id+AF8-info) +ACEAPQ-
+AD4- PD+AF8-TEXT+AF8-ID+AF8-INFO+AF8-LEN)+ADs-
+AD4- +AD4- +-   strscpy(dev-+AD4-t10+AF8-wwn.pd+AF8-text+AF8-id+AF8-info, =
stripped,
+AD4- +AD4- +-          sizeof(dev-+AD4-t10+AF8-wwn.pd+AF8-text+AF8-id+AF8-=
info))+ADs-
+AD4- +AD4- +-
+AD4- +AD4- +-   pr+AF8-debug(+ACI-Target+AF8-Core+AF8-ConfigFS: Set emulat=
ed peripheral dev text id
+AD4- info:+ACI-
+AD4- +AD4- +-             +ACI- +ACU-s+AFw-n+ACI-, dev-+AD4-t10+AF8-wwn.pd=
+AF8-text+AF8-id+AF8-info)+ADs-
+AD4- +AD4- +-
+AD4- +AD4- +-   return count+ADs-
+AD4- +AD4- +-+AH0-
+AD4- +AD4- +-
+AD4- +AD4-   /+ACo-
+AD4- +AD4-    +ACo- Generic wrapper for dumping VPD identifiers by associa=
tion.
+AD4- +AD4-    +ACo-/
+AD4- +AD4- +AEAAQA- -1782,6 +-1835,7 +AEAAQA- CONFIGFS+AF8-ATTR+AF8-RO(tar=
get+AF8-wwn+AF8-,
+AD4- vpd+AF8-protocol+AF8-identifier)+ADs-
+AD4- +AD4-   CONFIGFS+AF8-ATTR+AF8-RO(target+AF8-wwn+AF8-, vpd+AF8-assoc+A=
F8-logical+AF8-unit)+ADs-
+AD4- +AD4-   CONFIGFS+AF8-ATTR+AF8-RO(target+AF8-wwn+AF8-, vpd+AF8-assoc+A=
F8-target+AF8-port)+ADs-
+AD4- +AD4-   CONFIGFS+AF8-ATTR+AF8-RO(target+AF8-wwn+AF8-, vpd+AF8-assoc+A=
F8-scsi+AF8-target+AF8-device)+ADs-
+AD4- +AD4- +-CONFIGFS+AF8-ATTR(target+AF8-wwn+AF8-, pd+AF8-text+AF8-id+AF8=
-info)+ADs-
+AD4- +AD4-
+AD4- +AD4-   static struct configfs+AF8-attribute +ACo-target+AF8-core+AF8=
-dev+AF8-wwn+AF8-attrs+AFsAXQ- +AD0- +AHs-
+AD4- +AD4-     +ACY-target+AF8-wwn+AF8-attr+AF8-vendor+AF8-id,
+AD4- +AD4- +AEAAQA- -1793,6 +-1847,7 +AEAAQA- static struct configfs+AF8-a=
ttribute
+AD4- +ACo-target+AF8-core+AF8-dev+AF8-wwn+AF8-attrs+AFsAXQ- +AD0- +AHs-
+AD4- +AD4-     +ACY-target+AF8-wwn+AF8-attr+AF8-vpd+AF8-assoc+AF8-logical+=
AF8-unit,
+AD4- +AD4-     +ACY-target+AF8-wwn+AF8-attr+AF8-vpd+AF8-assoc+AF8-target+A=
F8-port,
+AD4- +AD4-     +ACY-target+AF8-wwn+AF8-attr+AF8-vpd+AF8-assoc+AF8-scsi+AF8=
-target+AF8-device,
+AD4- +AD4- +-   +ACY-target+AF8-wwn+AF8-attr+AF8-pd+AF8-text+AF8-id+AF8-in=
fo,
+AD4- +AD4-     NULL,
+AD4- +AD4-   +AH0AOw-
+AD4- +AD4-
+AD4- +AD4- diff --git a/drivers/target/target+AF8-core+AF8-spc.c
+AD4- +AD4- b/drivers/target/target+AF8-core+AF8-spc.c
+AD4- +AD4- index aad0096afa21..9fa84202ee4b 100644
+AD4- +AD4- --- a/drivers/target/target+AF8-core+AF8-spc.c
+AD4- +AD4- +-+-+- b/drivers/target/target+AF8-core+AF8-spc.c
+AD4- +AD4- +AEAAQA- -1963,6 +-1963,18 +AEAAQA- static const struct target+=
AF8-opcode+AF8-descriptor
+AD4- tcm+AF8-opcode+AF8-report+AF8-supp+AF8-opcodes +AD0- +AHs-
+AD4- +AD4-     .enabled +AD0- spc+AF8-rsoc+AF8-enabled,
+AD4- +AD4-   +AH0AOw-
+AD4- +AD4-
+AD4- +AD4- +-static struct target+AF8-opcode+AF8-descriptor
+AD4- tcm+AF8-opcode+AF8-report+AF8-identifying+AF8-information +AD0- +AHs-
+AD4- +AD4- +-   .support +AD0- SCSI+AF8-SUPPORT+AF8-FULL,
+AD4- +AD4- +-   .serv+AF8-action+AF8-valid +AD0- 1,
+AD4- +AD4- +-   .opcode +AD0- MAINTENANCE+AF8-IN,
+AD4- +AD4- +-   .service+AF8-action +AD0- MI+AF8-REPORT+AF8-IDENTIFYING+AF=
8-INFORMATION,
+AD4- +AD4- +-   .cdb+AF8-size +AD0- 12,
+AD4- +AD4- +-   .usage+AF8-bits +AD0- +AHs-MAINTENANCE+AF8-IN,
+AD4- MI+AF8-REPORT+AF8-IDENTIFYING+AF8-INFORMATION,
+AD4- +AD4- +-                  0x00, 0x00,
+AD4- +AD4- +-                  0x00, 0x00, 0xff, 0xff,
+AD4- +AD4- +-                  0xff, 0xff, 0xff, SCSI+AF8-CONTROL+AF8-MASK=
+AH0-, +AH0AOw-
+AD4- +AD4- +-
+AD4- +AD4-   static bool tcm+AF8-is+AF8-set+AF8-tpg+AF8-enabled(const stru=
ct target+AF8-opcode+AF8-descriptor
+AD4- +ACo-descr,
+AD4- +AD4-                                struct se+AF8-cmd +ACo-cmd)
+AD4- +AD4-   +AHs-
+AD4- +AD4- +AEAAQA- -2049,6 +-2061,7 +AEAAQA- static const struct target+A=
F8-opcode+AF8-descriptor
+AD4- +ACo-tcm+AF8-supported+AF8-opcodes+AFsAXQ- +AD0- +AHs-
+AD4- +AD4-     +ACY-tcm+AF8-opcode+AF8-report+AF8-target+AF8-pgs,
+AD4- +AD4-     +ACY-tcm+AF8-opcode+AF8-report+AF8-supp+AF8-opcodes,
+AD4- +AD4-     +ACY-tcm+AF8-opcode+AF8-set+AF8-tpg,
+AD4- +AD4- +-   +ACY-tcm+AF8-opcode+AF8-report+AF8-identifying+AF8-informa=
tion,
+AD4- +AD4-   +AH0AOw-
+AD4- +AD4-
+AD4- +AD4-   static int
+AD4- +AD4- +AEAAQA- -2266,6 +-2279,70 +AEAAQA- spc+AF8-emulate+AF8-report+=
AF8-supp+AF8-op+AF8-codes(struct
+AD4- se+AF8-cmd +ACo-cmd)
+AD4- +AD4-     return ret+ADs-
+AD4- +AD4-   +AH0-
+AD4- +AD4-
+AD4- +AD4- +-static sense+AF8-reason+AF8-t
+AD4- +AD4- +-spc+AF8-fill+AF8-pd+AF8-text+AF8-id+AF8-info(struct se+AF8-cm=
d +ACo-cmd, u8 +ACo-cdb) +AHs-
+AD4- +AD4- +-   struct se+AF8-device +ACo-dev +AD0- cmd-+AD4-se+AF8-dev+AD=
s-
+AD4- +AD4- +-   unsigned char +ACo-buf+ADs-
+AD4- +AD4- +-   unsigned char +ACo-rbuf+ADs-
+AD4- +AD4- +-   u32 header+AF8-len +AD0- 4+ADs-
+AD4- +AD4- +-   u32 actual+AF8-data+AF8-len+ADs-
+AD4- +AD4- +-   u32 buf+AF8-len+ADs-
+AD4- +AD4- +-   u16 id+AF8-len+ADs-
+AD4- +AD4- +-
+AD4- +AD4- +-   buf+AF8-len +AD0- get+AF8-unaligned+AF8-be32(+ACY-cdb+AFs-=
6+AF0-)+ADs-
+AD4- +AD4- +-   if (buf+AF8-len +ADw- header+AF8-len)
+AD4- +AD4- +-           return TCM+AF8-LOGICAL+AF8-UNIT+AF8-COMMUNICATION+=
AF8-FAILURE+ADs-
+AD4-
+AD4- isn't there a limit of 512 bytes for code 10b?
Earlier I kept this as 512 bytes as the userspace is sending the size as 51=
2, but Mike pointed out the range mentioned in the specification.
So, If we see the Table 61 (Table 61 +IBQ- Identifying information types) o=
f +ACI-spc4r37+ACI-, it says 0-256 bytes for +ACI-Peripheral device text id=
entifying information+ACI-.
Let me know your comments.
+AD4-
+AD4-  +AD4- +-+AD4- +-       id+AF8-len +AD0- strlen(dev-+AD4-t10+AF8-wwn.=
pd+AF8-text+AF8-id+AF8-info)+ADs-
+AD4- +AD4- +-   if (id+AF8-len +AD4- 0)
+AD4- +AD4- +-           /+ACo- trailing null +ACo-/
+AD4- +AD4- +-           id+AF8-len +-+AD0- 1+ADs-
+AD4- +AD4- +-
+AD4- +AD4- +-   actual+AF8-data+AF8-len +AD0- id+AF8-len +- header+AF8-len=
+ADs-
+AD4- +AD4- +-
+AD4- +AD4- +-   if (actual+AF8-data+AF8-len +ADw- buf+AF8-len)
+AD4- +AD4- +-           buf+AF8-len +AD0- actual+AF8-data+AF8-len+ADs-
+AD4- +AD4- +-
+AD4- +AD4- +-   buf +AD0- kzalloc(buf+AF8-len, GFP+AF8-KERNEL)+ADs-
+AD4- +AD4- +-   if (+ACE-buf) +AHs-
+AD4- +AD4- +-           pr+AF8-err(+ACI-Unable to allocate response buffer=
 for IDENTITY
+AD4- INFO+AFw-n+ACI-)+ADs-
+AD4- +AD4- +-           return TCM+AF8-LOGICAL+AF8-UNIT+AF8-COMMUNICATION+=
AF8-FAILURE+ADs-
+AD4- +AD4- +-   +AH0-
+AD4- +AD4- +-
+AD4- +AD4- +-   scnprintf(+ACY-buf+AFs-header+AF8-len+AF0-, buf+AF8-len - =
header+AF8-len, +ACIAJQ-s+ACI-,
+AD4- +AD4- +-            dev-+AD4-t10+AF8-wwn.pd+AF8-text+AF8-id+AF8-info)=
+ADs-
+AD4- +AD4- +-
+AD4- +AD4- +-   put+AF8-unaligned+AF8-be16(id+AF8-len, +ACY-buf+AFs-2+AF0-=
)+ADs-
+AD4- +AD4- +-
+AD4- +AD4- +-   rbuf +AD0- (cmd)+ADs-
+AD4-
+AD4- is it really ok if this returns NULL?
I think its ok to return NULL.  We just don't send any information. I kept =
it like this because I don't see any information defined by protocol when t=
he memory mapping fails.
Mike, Can you please correct me if I am missing anything?
+AD4-
+AD4- +AD4- +-   if (rbuf) +AHs-
+AD4- +AD4- +-           memcpy(rbuf, buf, buf+AF8-len)+ADs-
+AD4- +AD4- +-           transport+AF8-kunmap+AF8-data+AF8-sg(cmd)+ADs-
+AD4- +AD4- +-   +AH0-
+AD4- +AD4- +-   kfree(buf)+ADs-
+AD4- +AD4- +-
+AD4- +AD4- +-   target+AF8-complete+AF8-cmd+AF8-with+AF8-length(cmd, SAM+A=
F8-STAT+AF8-GOOD, buf+AF8-len)+ADs-
+AD4- +AD4- +-   return TCM+AF8-NO+AF8-SENSE+ADs-
+AD4- +AD4- +-+AH0-
+AD4- +AD4- +-
+AD4- +AD4- +-static sense+AF8-reason+AF8-t
+AD4- +AD4- +-spc+AF8-emulate+AF8-report+AF8-id+AF8-info(struct se+AF8-cmd =
+ACo-cmd) +AHs-
+AD4- +AD4- +-   u8 +ACo-cdb +AD0- cmd-+AD4-t+AF8-task+AF8-cdb+ADs-
+AD4- +AD4- +-   sense+AF8-reason+AF8-t rc+ADs-
+AD4- +AD4- +-
+AD4- +AD4- +-   switch ((cdb+AFs-10+AF0- +AD4APg- 1)) +AHs-
+AD4- +AD4- +-   case 2:
+AD4- +AD4- +-           rc +AD0- spc+AF8-fill+AF8-pd+AF8-text+AF8-id+AF8-i=
nfo(cmd, cdb)+ADs-
+AD4- +AD4- +-           break+ADs-
+AD4- +AD4- +-   default:
+AD4- +AD4- +-           return TCM+AF8-UNSUPPORTED+AF8-SCSI+AF8-OPCODE+ADs=
-
+AD4- +AD4- +-   +AH0-
+AD4- +AD4- +-
+AD4- +AD4- +-   return rc+ADs-
+AD4-
+AD4- I don't know why default clause is required and not return result fro=
m
+AD4- spc+AF8-fill+AF8-pd+AF8-text+AF8-id+AF8-info() directly?

Default case is to handle the incorrect information type. As of now we are =
using the 10b code but in future, we may need to handle others.
+AD4-
+AD4- +AD4- +-+AH0-
+AD4- +AD4- +-
+AD4- +AD4-   sense+AF8-reason+AF8-t
+AD4- +AD4-   spc+AF8-parse+AF8-cdb(struct se+AF8-cmd +ACo-cmd, unsigned in=
t +ACo-size)
+AD4- +AD4-   +AHs-
+AD4- +AD4- +AEAAQA- -2405,6 +-2482,11 +AEAAQA- spc+AF8-parse+AF8-cdb(struc=
t se+AF8-cmd +ACo-cmd, unsigned
+AD4- int +ACo-size)
+AD4- +AD4-                         MI+AF8-REPORT+AF8-SUPPORTED+AF8-OPERATI=
ON+AF8-CODES)
+AD4- +AD4-                             cmd-+AD4-execute+AF8-cmd +AD0-
+AD4- +AD4-                                     spc+AF8-emulate+AF8-report+=
AF8-supp+AF8-op+AF8-codes+ADs-
+AD4- +AD4- +-                   if ((cdb+AFs-1+AF0- +ACY- 0x1f) +AD0APQ-
+AD4- +AD4- +-                       MI+AF8-REPORT+AF8-IDENTIFYING+AF8-INFO=
RMATION) +AHs-
+AD4- +AD4- +-                           cmd-+AD4-execute+AF8-cmd +AD0-
+AD4- +AD4- +-                                   spc+AF8-emulate+AF8-report=
+AF8-id+AF8-info+ADs-
+AD4- +AD4- +-                   +AH0-
+AD4- +AD4-                     +ACo-size +AD0- get+AF8-unaligned+AF8-be32(=
+ACY-cdb+AFs-6+AF0-)+ADs-
+AD4- +AD4-             +AH0- else +AHs-
+AD4- +AD4-                     /+ACo-
+AD4- +AD4- diff --git a/include/target/target+AF8-core+AF8-base.h
+AD4- +AD4- b/include/target/target+AF8-core+AF8-base.h
+AD4- +AD4- index c4d9116904aa..c9b5edcce1eb 100644
+AD4- +AD4- --- a/include/target/target+AF8-core+AF8-base.h
+AD4- +AD4- +-+-+- b/include/target/target+AF8-core+AF8-base.h
+AD4- +AD4- +AEAAQA- -108,6 +-108,9 +AEAAQA-
+AD4- +AD4-   +ACM-define SE+AF8-MODE+AF8-PAGE+AF8-BUF                  512
+AD4- +AD4-   +ACM-define SE+AF8-SENSE+AF8-BUF                             =
 96
+AD4- +AD4-
+AD4- +AD4- +-/+ACo- Peripheral Device Text Identification Information +ACo=
-/
+AD4- +AD4- +-+ACM-define PD+AF8-TEXT+AF8-ID+AF8-INFO+AF8-LEN              =
          256
+AD4-
+AD4- as above, I thought that it was 512 bytes
+AD4-
As mentioned above, protocol specifies 0-256 bytes
+AD4- +AD4- +-
+AD4- +AD4-   enum target+AF8-submit+AF8-type +AHs-
+AD4- +AD4-     /+ACo- Use the fabric driver's default submission type +ACo=
-/
+AD4- +AD4-     TARGET+AF8-FABRIC+AF8-DEFAULT+AF8-SUBMIT,
+AD4- +AD4- +AEAAQA- -347,6 +-350,7 +AEAAQA- struct t10+AF8-wwn +AHs-
+AD4- +AD4-     struct se+AF8-device +ACo-t10+AF8-dev+ADs-
+AD4- +AD4-     struct config+AF8-group t10+AF8-wwn+AF8-group+ADs-
+AD4- +AD4-     struct list+AF8-head t10+AF8-vpd+AF8-list+ADs-
+AD4- +AD4- +-   char pd+AF8-text+AF8-id+AF8-info+AFs-PD+AF8-TEXT+AF8-ID+AF=
8-INFO+AF8-LEN+AF0AOw-
+AD4- +AD4-   +AH0AOw-
+AD4- +AD4-
+AD4- +AD4-   struct t10+AF8-pr+AF8-registration +AHs-

