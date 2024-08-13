Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C618F12E48;
	Tue, 13 Aug 2024 01:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723513371; cv=fail; b=XmPIT1Ea2615TwaY4QY4YKQ3zwHitc4t0KYqFBXy1hIsa0B0l9HdQlVrXLgc/HQ9HdlWVZ+Q+v8FAzFd3+EKT9h64OfcRkusYWPrAS6lBpJYRpfzs4TmyTEkFgCGgKil36TRDWQfeMXP/u+S2hX0hX1kD2TYVj0EYVXY8+YjRpg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723513371; c=relaxed/simple;
	bh=AJOv/FIwyDsT01aFeMnrbuvpvmRD5r/rCtEQYaCrf54=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=rOVE43cjQwA4WUwejVoa0Bv+WAWCxNb5Vsrn42DKTnWdIVZ+IF90pPJpXrm8SB3iQqI3yVXtJcVVOVXcS26YZqcc/oB7uLaymC/Xb6JgIb+yiblU1D7DAHmfTPK8fedrwInRTeiXdFDx53tMeGPxV1upNVfSRzBG9mmpMbhu8y8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kqJqXYus; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PgtSxwGH; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kqJqXYus";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PgtSxwGH"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47CL7JLl011549;
	Tue, 13 Aug 2024 01:42:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=yRerTv0o27P9DzIiuote3gwuHUkXv+9HA1EtVNn0qcM=; b=
	kqJqXYusBOglE1M+urfEdLfSa1S8txV+pY1SsvJR1P20h2m1ByJctQye9Blpb47H
	cQCWPDreldyifDCI/P+N7uxhJyGr5H8ngRnSbb3NuG0FoNJ22VBtI4e1jeS3/Df3
	aPYvOGNFloPfB5+l9PLclzDGviAVG4PyixMm5OTHjN5K6C2xK/Wa9MZftbWNqcGy
	xBbWEIpDGh2qRi/o051eDUm3hs3JieDcMHFF0a2Y7GlgDp8fXuUIRXwTH18zDVR2
	R46MqKMTPHj94IApwlThU1GZ+b9gHt3ssxrwiMqFqlK6O9vzigFm9KwW/nig27yO
	LOvAfPu7fFPBH2+PIvWbhA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40wyttcx4a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Aug 2024 01:42:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47CMZgB5010679;
	Tue, 13 Aug 2024 01:42:36 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2045.outbound.protection.outlook.com [104.47.70.45])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40wxn7wfb5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Aug 2024 01:42:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WQAqp5Q4gO7HFNQ6ObE27VGr/DcR6T2rTCcVEADTNhELaCmC6yGdAuf14Fm6DZqPT4EH7q35DCgoJ27BMivMohqcSAq+ol6AeeLZA0wuBGun0JJf4Kel7xVB97lP1hyO7xMW2ZbmVtd/D4tFmBVWsfziCFAvechVN9AkCsJxtwYoWRfSrPIAz0eEspboLQWcud1jXEIqWRupLcF+h4iMybHIlGxnhLgAIWqk+Rs9xmCG2Yh6Re5beRkAHe6NR7PMik+InIUTt3j2WeU4XGBfYmxKg1efLebUOgXH7T1sFgPyHn1uTKE8m1XaBKHhzl215j5l/60yguX+eAvuaK7DZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yRerTv0o27P9DzIiuote3gwuHUkXv+9HA1EtVNn0qcM=;
 b=Kr7/5HoXvucll+X/qMrLqo1ohE7qvoY4dDNuABUkRBJL4bjQsFXsE83khcKr4aB5DtojRX1zK58nyjLK3NPxEEF13TGRMwyQIgNoZxS2TvgWx4kHMWkJvec9jWtUlq9MC1q4Sp/Py2qX1Q5ANF9Q6sbSdXdFVEsmw88P8gEwnHIRq+FWedlIaXyRY7Jyv6sXRdZHRdjFRUj+veyxGzykdu6LHyqURlT4okeQf2w2C2Lsci6e+O6Ax/lK2KcBc0PKR7cja12EAsiQYlDp2A14TbgA5KwjhCq1b0Qqc6vhwx2/ofjYgcdWm2243yA/SR5bZMLG6qz9qSHOKSmk+6M+lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yRerTv0o27P9DzIiuote3gwuHUkXv+9HA1EtVNn0qcM=;
 b=PgtSxwGH2F6rFlVAMK9MPAlJysoLj3KRrNHuDKVGVZRmqtez7DFFRWWDrYSpcDq7VTTMxKIaQ5ZG8uISxreFawsDA3tOMB60us+KfqdEDtXIRiCTavszOmlfUGkZObivPe7avLAeWveVW8urgnVxwfgIT0Z6GOgZsxjT9FK0xCQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH4PR10MB8001.namprd10.prod.outlook.com (2603:10b6:610:23f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.15; Tue, 13 Aug
 2024 01:42:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7875.015; Tue, 13 Aug 2024
 01:42:35 +0000
To: Breno Leitao <leitao@debian.org>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy
 <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani
 <suganath-prabu.subramani@broadcom.com>,
        leit@meta.com,
        MPT-FusionLinux.pdl@broadcom.com (open list:LSILOGIC MPT FUSION DRIVERS
 (FC/SAS/SPI)),
        linux-scsi@vger.kernel.org (open list:LSILOGIC MPT FUSION
 DRIVERS (FC/SAS/SPI)),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH] scsi: message: fusion: Remove unused variable
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <yq15xs5xkta.fsf@ca-mkp.ca.oracle.com> (Martin K. Petersen's
	message of "Mon, 12 Aug 2024 21:39:53 -0400")
Organization: Oracle Corporation
Message-ID: <yq1zfphw65a.fsf@ca-mkp.ca.oracle.com>
References: <20240807094000.398857-1-leitao@debian.org>
	<yq15xs5xkta.fsf@ca-mkp.ca.oracle.com>
Date: Mon, 12 Aug 2024 21:42:33 -0400
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BYAPR05CA0104.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::45) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH4PR10MB8001:EE_
X-MS-Office365-Filtering-Correlation-Id: 964449fc-063c-469b-54a1-08dcbb3934af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eVZqMU14UktLbUp2MXdWM1I1NS82RTlGQXpzN3hmWWhlcTJEaGhHcXVUUTUw?=
 =?utf-8?B?Q1pMOTlpaDVmdUNXUnpUMUVMcmFkY00vTTIwMnU4dlZRMzlKSU5zVUM1eUJB?=
 =?utf-8?B?emVQYkQzQnR2SWU0dW9aWENhY3NtVVRONVFBRkZXRm4vNTExQ2ZIVG5CQm1X?=
 =?utf-8?B?TTRJdjZ5MS9IaWFONklXY1Btd2JHR0JxcFk1cE9mNkdNdFFCZWRRRlNPYlFC?=
 =?utf-8?B?eFA5bjhLZFFIV0FNaDNzcGxjdWdvRVFJZVFMWlFBRE5XWlVMekFURm5oYjhz?=
 =?utf-8?B?RWliUTBGSmVmQVVyZGQwdm9ybzdVdGphaEtTMmtUQUgvR0RjelRGb1lwNkdx?=
 =?utf-8?B?MUJqVWdCQUtCZ200UTNJRFdqL2k3MjB0ZWE0QWRGYjMxRm04dGk0MUhNZjNI?=
 =?utf-8?B?bnJSY1ZOc1dZMDVtRW52akVOV056TW1VZkN4TVFFQmJaWXArUzBNRGhXQkZJ?=
 =?utf-8?B?VXd6UXFoWHNWbzBhdVVLS0Q1VWVHT2FZQThPNTBiUVMyVnRKcU5lcVZONUZp?=
 =?utf-8?B?cWhoT1NOeXdGWkZzUDR6dEc2ZEdDUlpEcFh1Nm95ek5WZEREQVI5anlmWDUx?=
 =?utf-8?B?ZnFoRWVZUXRCKzZnQkwyc2VoNWtNN3U2amJ1Y0xsNEFzRzVkbnBMYnp4RVMv?=
 =?utf-8?B?OUdoMGRqYjJOTGdOcEE3b1VnYWg1QXZjdnlOZ1RsekcxODEzMWxDZ3FMMlZi?=
 =?utf-8?B?ME5qZU8zMmlCTFV3MmxMbndsZ2grZ2wrNndWREc3NDNPc2l2bzZkRks2c3Ry?=
 =?utf-8?B?T1ZNVE1rTTZ1YlNjaVg3Q3hiVXg1bXgzSkV3a3A1WkkyeVM5TEUxK2s4bDNy?=
 =?utf-8?B?MlVMenBzZHpXUGpmL0dyRFQwSW5JVDhINEJNb2F1VTc3WHVZS0VIeDl2VGJu?=
 =?utf-8?B?NGtiMHp1dHh6Szh2ZlpjenAzTFNIcGM5K3RTUXBkNVZxTHFHaVAwbTl4alU0?=
 =?utf-8?B?V1phcFQvNDE1MkppRWpJRWcyWVd5Z1NaTDJTZVFpZDdUeVJoaGJKdWNOWFJ1?=
 =?utf-8?B?anVDaldFWGhDNll1N3kyajBEVmJFbnFSM3BTR2J4Wk52M3FiQ0xWY1VmZWd3?=
 =?utf-8?B?TG1rN1Y0RlJSNU0ycDRGcDhLZUJRdnFCakNKOTY4bmNpeXZsd3RZM3dKUnNn?=
 =?utf-8?B?bUxYNUp6MVE4aGwraWI0ZUVnMGhERlk3cGJnSUNLMXd5RHFxTVNYbC9uRWFB?=
 =?utf-8?B?R2pLS0J0by81SVo1Qk9vYVUzK1FoRnRTckNvSlh0RWZaWS9pUVo3VnR5UnQ3?=
 =?utf-8?B?UUFET3owK25Zc0pUdDBYcDJRUktlNTJBMU81ejVZTXJPWWZna0RDR2N2eGVM?=
 =?utf-8?B?aTEwd0xSaFhBb3hpM1VNVHZLUUdWZnNTc3BGQWVDbE1VSjIrYklyTzZFRDhh?=
 =?utf-8?B?eFhUNmw0S3diQUM3TEs1TmVzMFMvY0NnSEhSbTEzdTNHbVBCYU0vamhVZS9D?=
 =?utf-8?B?RVg3YUVDQjNOYmY1MzBNQjV2ZmxlKzk4b2srN2RKeGxTVjdYS0s0c3d4azZU?=
 =?utf-8?B?WGdjekdIeU5uenZVcm5BNXpDTmdXUHpUZ0hsZzd3NHpOV3JVSU9CTXBxT1h3?=
 =?utf-8?B?WW5qOFd5NlYycnFtcWdIay9kdFF0Q0xOVDlwVDc5NDg4OWt0ZmtRRHlHNnhH?=
 =?utf-8?B?ZklORFBzWUhzMW5DbjhuMGROK2QycUo2ZGQwMzBrNjFJNnBMeE1MaHdxck5V?=
 =?utf-8?B?TWo5Mks4OFJtWHUwc2EwczNnQUdCQzFwc0hiOHVpZ2Z1SGtOa0d3RTMwSGZ4?=
 =?utf-8?B?OXE3S3NwSVZPdGNEVHovYjY3SjZYUFQ5QmpYVWsxUlEzMVBRNHBycXppNVNw?=
 =?utf-8?B?YUlMaENWVENWZWt4eU83UT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VXNiYVMyRWo0OWd4QWZkUkZHZWRHZmlSS2l4bGNpR3o0eTJmeHEwQkNMcStT?=
 =?utf-8?B?SnFKUk1CVnJWbWYrQkRxK3V6NnNuSEVPRG1XSjlHN2VPd3BKeW4zZW9raStC?=
 =?utf-8?B?UGo5VXZkYzNpQjVIQjNzS25qcHJ5YXF3WVB5R2ZNekMwa1dOVjJFZ25OdGtQ?=
 =?utf-8?B?eGtXdVdxL21wSTdMOWF0UzEweDc4NHcySW1qTWhTdG9OclhjQVk3TVE3Ujgy?=
 =?utf-8?B?L3RKS2lVZmpQc3hEV3Uzd2RlUXVqcTRCT1l2UncyQmJMUWI3bEJJTzAzeVdT?=
 =?utf-8?B?UEQvTmtBNWZDbGpaTVRXbjdYVXV6dzdEZEpWeXdKcXFtQ2NQemRMN0Nhclpu?=
 =?utf-8?B?UTFOU2VUUmxDTDBlTkp4RTdwMHZzNmpkazNvTThndFlYTDBzYTBrN0JaYitN?=
 =?utf-8?B?UWlBcWhxK0lSNHdOM1RKMEVkV1VVR01sT1kyVWQ0N0VZY0pKWmd3TC9GWDh6?=
 =?utf-8?B?REFyQ3Q4a0pYcWU4d2J2eFhKcWVPd2NoejM0d1Z5UU5mM2lzamR5TklEY1hN?=
 =?utf-8?B?S0xiNlU4Z2o0RFhORVJkd1IvYVhFN0diLzZwMjNlblFBUjhzRG1EOS9BSko3?=
 =?utf-8?B?aW90RCtFRW9Ja3dWQS9WWlF1WTNLSVp3SXlZU2pwalQ1MWpHOEJkUjFZV2c0?=
 =?utf-8?B?NlRKSXZ5SWQvZ3hhT041MG1INDY5YitlT29XdjVJNjBoWHNySE1NR1Ixc3BH?=
 =?utf-8?B?c2ZSYmpsTDIzb0p5RENEV0t1MHJPR204TDdiZlM5NTZjaEJoVFdVOVZRWHhn?=
 =?utf-8?B?SE9Kb1lOczBzb3NZWHIxTklJSGEzVWxtazlOZFpBUGhXYnlGWUUxM2VTMkwv?=
 =?utf-8?B?WUwzalhBMS9vcy9mc3BVNVhVNmhsOU8zVm5xQStWRE5lR3E5UTIzc1Y0bito?=
 =?utf-8?B?dVZFQjNab0hvYmFrbUppSzRsNHdRcnVmVGJKVm9NekZ4SGcyQ0l0bUowRzBq?=
 =?utf-8?B?VlZTZmN1RlAvcUdwZGFDRU1GRjBUd0s3L2VSNWIraHF6NVg1TWgySWhKRWEz?=
 =?utf-8?B?NU84eEdCeVZRS0lUSlhXYU9DTmlzRVpiNGE3RTNHaGgrYnVoOHBWK1ZNMlJh?=
 =?utf-8?B?dmMzcHFONXdPRnNLUFl1VlRjYW5jL1laRktxSWVaN1BZL25Kd0tMRTR1OSs1?=
 =?utf-8?B?cHZMQ01ReEx4Rk40djZRVzNkdVlPK2RHUCtZbjhVbmJKRlYyWDFxSW1UMEFC?=
 =?utf-8?B?dnpBWEw5dXVFc2xoeWZXZVMwWEpGUi8rcHdBb2ZjR1dGalpkbW40UDVJem94?=
 =?utf-8?B?NXZEMGE5WTcrVXFiYW5zRnNpWGFha1c1NUxWYm5kOE1uWGJSTjBRc2xEUVFI?=
 =?utf-8?B?Z1krZnpDc2xNVGF3aWVxZmZhbFk4cXZCRmN0d1o4aEVEOG5HZnlja0gxQis2?=
 =?utf-8?B?TVhpS3VuSDRGOGFSTzF0bEFML2d2cmlXejNZa0wxNTZ0UW1kekxic2RIL3Rq?=
 =?utf-8?B?Q1U1REFhZGU3ZW9GWmlYY2Jza1dSM1U5dDgySnJrV3pCYytoTlNLc0Rkak43?=
 =?utf-8?B?UUk1cEpDRTI2UDhwMkFmSGtYVmRUdzdaZW9OLzBIOWZ2RDVZOW1nTDVtcWp2?=
 =?utf-8?B?cGNwRk80Vzc2VXdtTGtYTkVGSlF1a2hPYWFqQVFiT1ZDd3YvWEphekg5em9u?=
 =?utf-8?B?czdyRXBGQWNpZ3RQWUpDODM3dmFaK2JvU2VPT2tCdndURVBSaXNCWFNVdUlN?=
 =?utf-8?B?RTBERTIwL0VUdU80Sm83QnJqVzR2N1dULzNoRzRlTWM5b1U3aXJYQjFrOHpj?=
 =?utf-8?B?aHpHWWcwSW15Yk4xSjFmYSttb3FhNktYbHU1SlU1REQ4bDZERU9YTnNUODFH?=
 =?utf-8?B?OGNXWEF3dXdXRGhreWFuOHFGSkxPbHVDd2F0VDRGTmpZeTJwaGcwT3dQejBy?=
 =?utf-8?B?NGJ6UitXSDZlbC8xRGVIT1hHUkNSNHZML2FNektHa29iaG9SQUhMUkI5TEVF?=
 =?utf-8?B?OERmS29iREN5ZitUZEd5L2dMTDRnc3hhQWRESURDMFlacHhRRVlPVGZsL2lJ?=
 =?utf-8?B?SHRiVE9MOWZHajRncktHWVgyQjZZVmpvOXQ4eVNRZmZjTXcreFFFNGJ0MDFv?=
 =?utf-8?B?aSs1alorMFh5dFV0OHRJOWM1Rm1sYnRJcG9pcGhaTUJseS9XVnJpbkFPa3FS?=
 =?utf-8?B?a0dpS2NLS1BzM0ZGb2FRMnRMRWVTZFZOazVML2RlVzJGTXVVVkdGRFBnWUM1?=
 =?utf-8?B?eWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2AvwMkPN8sQeBXg7ZYq6p1n1rP1mGHFAQkwRiynN+QSxzdqivULOu6kCfdJideVuNMmsDxRkbqR0B7WM4lh2cUdvETEpV9oubIhXux1ZdnAJUrmnCaPYLGEuPDHvuj8TeeFCibLKIzUkMbn4kwqv6ekdjlXROKJCNHX4AAA6gkeO11z3zNL+Q8jreJlOeTZyQzWeer3kgLtscnc11WjF3UCKKqhrUYkp+lvk9jiGDn5Rudq1bvOT73LyjYFlhtPunGo/yl0YuRG8x+Brv/YHhQLXsr0lB+F3NXlf+/XrAC7+ODJadp+BT0J5qOZmk28on3u2uZ5F8dbnAOxULAKqImYaC6kDLT6jkWvJx09E0ESJQ4CCWPXunvwmNeF+urL0t5Erlva8+KI3ffYk3jeWpoZIKPTALPiFrCJC9p6ZWbYQbDswIPiovDvfZPD3jmVyeMAVtu3AyZLz2BQhz36eC8Deebk/UApPtxqzWIrYtkhVmmNDzkpnsuD+PVlYq6h8jmO3zZO2LrFqIfEX+YCkpJZIl4G1v+HhyIMxu1p4LaKEzgxz+UvpJwFSEj/R6aFiOVI7veeKJnFyDy5/e3NAt+vH7hijOJyw0TEF4IIapao=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 964449fc-063c-469b-54a1-08dcbb3934af
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2024 01:42:35.2027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qNCfaDtSUD7yUg09XcaxiH2jZ0u3zHxiKueIV/f9MSeB/NZxIypK0JfMnOZhfbTEwfPgqts5HlFia8V7RmBl4gK/ekn7EiSCIMupmtzP9AY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8001
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-12_12,2024-08-12_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 adultscore=0 suspectscore=0 mlxlogscore=860 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408130009
X-Proofpoint-ORIG-GUID: w-C9UdXthDmSJzxktpEnyzUrJpuZSEgy
X-Proofpoint-GUID: w-C9UdXthDmSJzxktpEnyzUrJpuZSEgy


> Applied to 6.12/scsi-staging, thanks!

drivers/message/fusion/mptsas.c: In function =E2=80=98mptsas_reprobe_lun=E2=
=80=99:
drivers/message/fusion/mptsas.c:4235:9: error: ignoring return value of =E2=
=80=98scsi_device_reprobe=E2=80=99 declared with attribute =E2=80=98warn_un=
used_result=E2=80=99 [-Werror=3Dunused-result]
 4235 |         scsi_device_reprobe(sdev);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~

Dropped again.

--=20
Martin K. Petersen	Oracle Linux Engineering
