Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444BF16132A
	for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2025 03:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763607750; cv=fail; b=GxrSWO4DCfJcXpiN1JX7XwsIV7Y5P+dSPGGg9qEELTYMY5CXqwhk9d3p9qzGhuhHmFXlnFaXMohaiiPLnaEFkPDtZVT/B5Wxb/3BI7iRWz9ILvdRJjAIptAZFWWGRrSM1/2ck9zaAQV7xI0Fc4GeOqTot2/R2jjHd7L5bzg8rcY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763607750; c=relaxed/simple;
	bh=wm0btcrVKdZxzT5U+B8OZXXGcLs1cOTZpkyeFRmwAyM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=JuKB5l/bzG30+/Cb/VgSGfkjwGWW+W8kEfbNahqOqb+H+8k9faCnVxND6QzFaNRHaQJDtctSCnQOVI2vmaiD4OHpKszgQYIKWIq+6og3e2I9oo+2PxWjiOJyPxjJddCgJVDaOukHDTR7wUXRIxdvUXkqLaIrP+vTgKob7kMUQhA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RSmVH+ri; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vZRJaDD4; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RSmVH+ri";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vZRJaDD4"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK1PJp4010189;
	Thu, 20 Nov 2025 03:02:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=+VUF3mv3Tsn+OSoE6D
	OI9IuiuEMhB3k23BB9chLFRvk=; b=RSmVH+ri8rZ2E8s+LkEOfx6l3IEXJ/c3dX
	IVHrvYjZFLTLF3OJHKZT+X4kjMfWD4ICi91UFIB4h2XMki8f47DQBVdu1usJq9wV
	BBSyufZV5ZDCMz9XuqcjNjnhVUwCi/wJqdEUmJA1heKufK/ag1h1lh8JlekJtb0r
	RpUIMEZwiup/IjmDqqX8RJvmjwphLOlrw1O/hAlEI0zlYCSqaKA7pHhNk0DsoQ1H
	vGqxAXscoosgDTHdW7dYVRnxNJ88dOUFp0EQKNSrsg6/nRkyZhxkduTQM6whmFsW
	WE9aLdvOOCMrAGFsKK5RoQflo2l3XyAxxsy20lwlXkhJLe4V7DiQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aej8j8b6y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 03:02:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK00Qin004341;
	Thu, 20 Nov 2025 03:02:15 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010047.outbound.protection.outlook.com [52.101.193.47])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyb7asa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 03:02:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fqYGHW2heCN/PcowtP4oEOxvpqrUXXerhe55AKLev/B5KZsRMUIeiw7L6Gv3yinZzvHzUiixB9TTc2zXgcSfBhlF27UxXgtg0QU0LS7onwGq38vm55jkS2Z1zDVCSQXEmCBah+UPesyG/LRr3gNkFWlqRa4UZEND8utlYRow7kH1GTkHsmf8kk/R67U9na1uC+cIBWdQZH9xhjdiTqkt6GAB+eiLbuQ9nJkdUR4r0nT6EQSDvjx8VUCty57bVkp3xFP293Lkk391mAGix3pIAizUN7wxn4ggtqwPDUUuqFwlkXYWZvFHgdfqV+QAaFiTC67SHNdfEMCy6awflU3jDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+VUF3mv3Tsn+OSoE6DOI9IuiuEMhB3k23BB9chLFRvk=;
 b=wIigH5D9Asa9bgzpVh6sPabssHLvVu+5XMKFt88wpRxfn3hSuMORtgf2lUMF65jjiRYFW5rZEfTjaZhi8NBAZnmAZ95k06yXsoS/+xloJ44mGTwtn8VauImDeHK9GqyP+9oaydjMbuQrCwDyt8Lw8vyFTkQFM7VT8N7/r+GrqThGXNm6j772N6eN0GtnSvg+6Zr66NKmr0yJfIpaJSdRroUlueFRqzYi8eNfqnBbw4QFuGlhoq8BRbkvoLTmTI0kOfNbFlDPPtCYDLKUNI5WgeDaoviGQOIcpwgeqBCNrwsxNMeiO+R+Y+2u5yTHLoWa56+exbq1MkfGeyb6FjrJyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+VUF3mv3Tsn+OSoE6DOI9IuiuEMhB3k23BB9chLFRvk=;
 b=vZRJaDD42aN8x/a7Oio8QALSH/fOCwflIH+pxBN5yPMWPREe/Naq/P2FPCCS0bQYKKgHw4WhhcDfrRxqVnQjxpkZKwMJWKYWWVNBANChitZCE44vS5TQq1XSQgWVlH9w2/c2LWwkScfMAaPGymrujm6MmJHkP2DT7MFBWqddexw=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH4PR10MB8145.namprd10.prod.outlook.com (2603:10b6:610:235::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 03:02:12 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 03:02:12 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Peter Wang <peter.wang@mediatek.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Matthias
 Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno
 <angelogioacchino.delregno@collabora.com>,
        Avri Altman
 <avri.altman@sandisk.com>, Bean Huo <beanhuo@micron.com>,
        "Bao D.
 Nguyen" <quic_nguyenb@quicinc.com>,
        Adrian Hunter
 <adrian.hunter@intel.com>
Subject: Re: [PATCH] ufs: core: Use scsi_device_busy()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251113235252.2015185-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Thu, 13 Nov 2025 15:52:43 -0800")
Organization: Oracle Corporation
Message-ID: <yq1jyzl9zkm.fsf@ca-mkp.ca.oracle.com>
References: <20251113235252.2015185-1-bvanassche@acm.org>
Date: Wed, 19 Nov 2025 22:02:10 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0155.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:e::28) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH4PR10MB8145:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ef81e45-45e9-4111-3b76-08de27e133b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?a7mX0+JIgVoZrBqF2Am3biKXfC3wQkTFyqBrqKswqQPDYgWMY/fv8Scffee9?=
 =?us-ascii?Q?u74aEhJepP5lyZL00Lni/ZbIBlQQzyauE90s3j5Qi875AmqZr3AGxYqAHvAP?=
 =?us-ascii?Q?OEw3nS0dNAU2bRIQTGFaD2ff1QQQpSkoyxtUajyp5dt4of2LwEh2xds86TPv?=
 =?us-ascii?Q?E9sMzPjFmGvCpAGqFChug4qZck7+Xbn09Gmlxh3W81VIJ/7SDFHFSSMvspUL?=
 =?us-ascii?Q?W3n1GvucByWCnNxOzpcdseyog34odvb2sD7lUThGOEJ11Tl5g7JO9ynpKnC0?=
 =?us-ascii?Q?1uaRwkdMKccilZ1V8Ww1Jq7QYIGgO1bkCoenAOdjrFsdMIlCHdqWO0HQsA9z?=
 =?us-ascii?Q?PgBGhyoaqPD80SsXf/5lnfRFM6JqPueP8PhErVwlh2/0eYzNeJPy4mizL5JH?=
 =?us-ascii?Q?4R1n8pfyDtlIukp3/nVdFeoKbIFhBV9iKWYfbF+WDzr32QlkLXSqqWvq7TsX?=
 =?us-ascii?Q?jtpTL69hTDGJFYviHES0GngoWa28obj2GkZzPD8bKe6RD773j6/9CWeO4IdK?=
 =?us-ascii?Q?D3yqrxB/4Ob16pyCNGqBVc2pNUlhm9O27KFU2i0AVC3AC09TeJ47xz1TJmwt?=
 =?us-ascii?Q?qICs9afCkHCRHhhUjhj6swTq8REX+5cxkUBlK+tiykjO+oluiT/mPb/3mls4?=
 =?us-ascii?Q?/DCFsfh95Wcs1tuG0TCo7WVwACsauUVoAK3pnQBhJme++a0NzPr+kXm7wo6E?=
 =?us-ascii?Q?95v5tS7C9kmOr20VIElr5S9nftpg/N8AwCp3ebu5TdSj2LdoHF20/6ib7s6W?=
 =?us-ascii?Q?eHlYdh9QadvrPB+RPXDIXDmXMTMW+5yCmbSoahCa09OYM2OzP3Mrn8ylCVSU?=
 =?us-ascii?Q?Ruv+cTYTg+AXQGs+lBfFFccw9gcCbVuYRerckKX/QkdNKoHL0ysuaJZS/mDb?=
 =?us-ascii?Q?MjDWfahlk0ZU3ZpRZgYUEQ73n2wE3ofQgVIuZso+8YpcpWPlJd/FrxL6nd6k?=
 =?us-ascii?Q?sLesqQzdr/rof1LTkehYFCcIfBqPY1yY66ITkqfD4JzzWHbplIPTnBtYvT3z?=
 =?us-ascii?Q?CZYUVXU25QqfRUrWqKL0aIoiXmnWwqWusUT3aZVnI8z8oGqJcC7A7jOr7Lru?=
 =?us-ascii?Q?yAVOuyxyq+pVkOR6VUkIcKvbfjPBsh3ZIb3staUC/8vkeicLXyhqdC8G5MfQ?=
 =?us-ascii?Q?M+F2IwqgUn3Y9UNKkjbNhRZ0ROLipkWemCLkKda2rM1ZPcKt81gUPtRXrNRP?=
 =?us-ascii?Q?DAyB6vMD5Y7rTHTwdVg4JPhmTVQEPLf5Z4GnMYVj8E32w+KCQDn3JkAJrWAs?=
 =?us-ascii?Q?bHufHz+2JzTZBUf2joA04sacO2tyZJ6zCEbpBb51hTh4v9NFQurBTB9bRw5G?=
 =?us-ascii?Q?kB8VV+1Tmt0oLFwLQOnXxLin544NNA6TWQGlQ1BiBMY7q7xPf03mZL7s5W3q?=
 =?us-ascii?Q?VN95QwgGCBosMF7tuwp0+mmQPx1g7Qn703Hpc1BTM0FhvCMytcH1SNJSwSIE?=
 =?us-ascii?Q?+QjL3PQFLs73Aue485TLS7HCwebMaODv?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Tfnf6I+sidzW5CUKFu8wYtGsTnE1oKEtQkZyU8Bl5xrdiNyKZxV3bZMKiN6x?=
 =?us-ascii?Q?N0TYFK86JKY43ey9dy5z7EoDVvYPqx50K9iMv0E+Z3SHfwtrKOca5RXlPF3Z?=
 =?us-ascii?Q?ShySYdXKiakzvMgcXE6N4UBTSrLL3DrzeOPpOaUzV3AUYMH7hotyVyj7JT4o?=
 =?us-ascii?Q?xseDq7ZzSUyg+XW2uzGiHLyVlMJlO6oI+t/3HOGA5u8m+6nyvcDLtfNrCJtR?=
 =?us-ascii?Q?FGIinE31XEoIPyeP7BD2EATgHtxybyxNjSv2dD2I6QC6kct6n1d8DiecIMd0?=
 =?us-ascii?Q?oAqxtRhE979F7f7yWe5Q4biKvVTV3pXyf2bcSD33mosSSnJlUzxUxVWbdTqv?=
 =?us-ascii?Q?pRrG2zsm017hcKU4OARTgZixoe49JLiFo5P2OZ/Dpgz14nNPOh80fKJa36B0?=
 =?us-ascii?Q?9Wz7RajABBhx+qzCr+P8JTiwBWtMLsNqksBXEQhyrbKHYcTdz8xW9O7d7ksB?=
 =?us-ascii?Q?inurgbgbFPLKrkzQRZVeHKo+wUJLcc6JvPBdbQgkTLWt9fMO9VhVndUAUJZy?=
 =?us-ascii?Q?YDYfyB6VTJoPXRlA4CJ3GpXCO0zpDkNekoutgXLfR7YoaB/6FRJQNKZ5n4w1?=
 =?us-ascii?Q?VfugKmPABfvsKWUFWTBDWSfrQqYBWb1+Fy5QJyfUK38Sl9iMWgnqvObkjLZq?=
 =?us-ascii?Q?/bT2QYQgakQ83l15vLlQxhvohRK7ujzBxTrot4MkZEtqyE0XyWB5E0szDv4n?=
 =?us-ascii?Q?8pCtLJg9MJYD4uefX4kK1wj67FkJbmS+3b1/R89nQzrfPk/lO428C0jAPBm1?=
 =?us-ascii?Q?lItd/jciyl9VBQ/QxFu2F1lD/tuoYIrQTxvv+P5yR26w0jJXYDUnSj0fUE4t?=
 =?us-ascii?Q?qoJi8GUrUhdwPm1zYM7j1DUTcMsvae/9N6roHrZM0Q5iUBZNZZDdW0390h9N?=
 =?us-ascii?Q?g+ddEcYBNTwPB7qXeDS22U38W3fCbDK7a5kn1QOqzJF0QfSuugSRo+QTLS77?=
 =?us-ascii?Q?Lfa+Qg7sbAzrp85M5vUZQEPgsAxZmsK/On3UV+ztEyuaXv1QSdcIgq0glyOy?=
 =?us-ascii?Q?dQ7AVlICSgxRXwRHzWrBQSUeSkaVX5eih9Y3uxlka7jVSW8D+xW+BtRNfW4K?=
 =?us-ascii?Q?1VY3Xin9VRGf5baPOOi/1RG1Cl4CdY6+RTyikHLE5BKGZvYwwGJhsaHWmRzR?=
 =?us-ascii?Q?2Dbvy71GuYAZ9mPKGHWUzS1mQle4V2hb2mcddcUbphrPiBgRui2V/8sqMeTD?=
 =?us-ascii?Q?TD/mRiFbyGIPST940EcSR9qu6Oi+feeOnjvVctH52BKJenl7llSSwAXPILUM?=
 =?us-ascii?Q?8ks6hGCDfQ5utVsI8ghz/Z9SxPGzw37bhUU+59uAobIvZoSHjdCMkL0fdxYw?=
 =?us-ascii?Q?i97KZUQ4fph+KwGp0RvAdMG3dgUiddCzRbEoYvDvFejLPRd3bUf7NgKL/AZL?=
 =?us-ascii?Q?GRa1I/uQrJcYASzQEq+I5/hvPlY+KfLzvSUDQEaqpYNGWBCrAKauTLRVBT4V?=
 =?us-ascii?Q?ihnBMJqsm/nBaK9zeIRecipKJQ02zbIfG2mg7B6f25eQSLh3ROu8oC/165jW?=
 =?us-ascii?Q?Slv/lfFmeAxokS0fvG8ntbYJaHkavoLKPIOnbc1fACxMTkZyLBfT1jUGSV+S?=
 =?us-ascii?Q?ByhCGBjM8Z+o+8YPMWomyZoMQxUyE4Q0ZWQK3ayBbIsQ/dTmGAR7M7BheDj3?=
 =?us-ascii?Q?bg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	W8+g+q4fCms6ry6ey7E5gEZFuwFNq/ZhSFVjFXjHNel+Iyq/jbu4qDgHXVjJ0R+qwyqbQx+SNx7kG1eWDEBoi0v3G6xvXYwRjJT6dBdbJZdZxe7ag/mDHNB622i8ujde4QFoUbN1gOcbBVWfkQ/+A8MmnyBut7oiDDq29MWKcV+Av4/DVAgznEJz5VzpT1qfQV3V9OD7r+dszLmOMTRCyHjDyUY30Fi39QgNYDv8whqeNvdvxZ/9DiT4VR7eWXSau2qjOJsvcLkWbGh31QIGQwZzVRBPALOQkdacff8Qg7fWaVo0HeIGDdvmZr2Yq43tFE8g5rduowNUsp3TyaGUr5V3MEGlV2KWECnc2tDpI3CHVzlqG2Dxrf4OUs5C5ZusZX2o4EHA2LT7h1C/vmudEO30jTGpzeEoIQeAYauloRAFPc8VYh6F8CufXfQEajHNIgLYGi5QmxsyR1E610I/GrSueX31NHq3eqc5HmpupT4HXyk/w6b4D0hBmbMMalNiztxq9I0hW4Qj9sfaVCCQARBaw6VTxRmTfuPLfGMoF26TiialW2F6h0koHenzPyOoJxNEOcTXZDvWO6gPMlPEZqqMQeCukzwzRu48xamHpnM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ef81e45-45e9-4111-3b76-08de27e133b2
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 03:02:12.2766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p+UitD98GiGYEZltD6oBEWsiXDQ/Cbybxn08kwbJs+gXwFe3AcNqqRf0cUMXYN5ufJCbqOF08/uUuEGdjqC2WzeR3Rm4JXc4lfnNhskBg1I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8145
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-20_01,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=897
 suspectscore=0 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511200014
X-Proofpoint-ORIG-GUID: QuxntRkjaRgOsgvNx53bWefXNdpUTykK
X-Proofpoint-GUID: QuxntRkjaRgOsgvNx53bWefXNdpUTykK
X-Authority-Analysis: v=2.4 cv=I7xohdgg c=1 sm=1 tr=0 ts=691e84b8 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=APdTsy1mPjVvL4qEmPYA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX4fhj4CaT12fj
 ZVDw2dmHTvTtc20lCzX6mbLsBX455v3CM+61Y8u+p1UoQFmfRul7l8jq+Ivgksh0PsMUMqyT3dY
 JuCITstLXgVfD5tQxsSKIlImLKSux6gm9JZLgb0+Jm3rkktPXt+Y2O43vbgZ7R6y2W2f6ovbkgi
 Wy7x/pzLN1zG03VYmhypTGJKv59tmvzN1ZNCHbPTr/zti/5u2Odb+dUpJCnsWpS3kkRgg3e5EeQ
 bSRuuUgWMp0pdOltfnAXkD2HSlerHuQGwmA09OpGZOWBCmNxUCil4lzcqllTGB/yl7bVRSQY+QR
 4NO3kVkA4djP9QlUHyk5OxMO173Q9mp/iD4v53bF3Ut8F4xmDnue7Bnb3sUa1/kT6mVFgJTrWR+
 AFzeRruUcZ9OIfDBjUvaeww/yPGpuw==


Bart,

> Use scsi_device_busy() instead of open-coding it. This patch prepares
> for skipping the SCSI device budget map initialization in certain
> cases.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
