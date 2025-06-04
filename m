Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3CF23DE
	for <linux-scsi@vger.kernel.org>; Wed,  4 Jun 2025 02:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749002466; cv=fail; b=MHJRo2qFof3eJaWZHMLixM+dgXXePHL3hUpEkz6cDvX2o8s3AvLD5jOpV5xyS75l1t1vDIntE7kY1TMVeIlmUfhea6osn9BE0Mv32ONZ10U52sgsdKi2j93wMYUJXPbj+hJ0imC3IpJGttxrWoMs3HJoPQx0mv2jckFzmJqdJz0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749002466; c=relaxed/simple;
	bh=/uSZ13bF1aVP99Vl+HY5icGJZY2/qOej8fql63LrnMY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=R9r1fUqnIowBvQEO1QxQeFDxkAR189MJWdCpskmDDWBZLkQAyFqV+3ogQEZNFpQiwITMWfYabv8/UBAyQM29th+S99LTB/ZE/2kiAX4BwD5Rd+ENeLV5tvbPNieogQ4fzPQ5IoCGr6n82lpCg+enEmqlKQ3HFJ+C0Miq6lG8vvg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=A3fHkw5/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nRDRQekj; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A3fHkw5/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nRDRQekj"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 553MN0Hc027661;
	Wed, 4 Jun 2025 02:00:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=R1r51KmugrIRzrQnIN
	nLRc7X2TbIMbr5ve0zmybF5lE=; b=A3fHkw5/CXL133mrcTTZUE0WPwf4gewwSa
	zxQZLRn9bhLw1NRCUtp27LmjU6lhucdsjo2PIilEF6n5R3D3yFbrewTOKMldawzw
	v3ZHkbWVB+PbuqVjkLMsVJ27lzXYQULoYeLXjTfMnXuqxGlzBP2HvD2aN8zr/SJK
	LaNNV/QaLKeoUVESa50JPm7CmBTH2ekkHF7FXLTG1Em0ZyLMHU6j38cHtvBDqmyi
	ROdqLUuP/vYowpzmCm6LcrQ/kv7ADjTC0cc92hoWEJ1o/lM1UyLAceebaWj2+40M
	2ykIpu2Ybj20Alp8MsZdMLqMkfFhZMJG4rsSUlY4paTX3R+72lDg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471gahb3w5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Jun 2025 02:00:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 553NPDTE016187;
	Wed, 4 Jun 2025 02:00:42 GMT
Received: from sj2pr03cu002.outbound.protection.outlook.com (mail-westusazon11013026.outbound.protection.outlook.com [52.101.44.26])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46yr7a610e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Jun 2025 02:00:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T4nZOZLy6fy2JkdeObzRD5QNXobxAKfRrWL8OePIJNsT+UtYfzE/1iLtchHGdVGbZViCTRvjXaw/16QWj5LROLAE5rsAOVHf0PgprA8g3bhCMAU1tukghcHNZX7578oYWBxszwoBjULZQs6cJ/gbR6tLXBKaJR5HTTaBGrrvU43hr2Od8jgt7elULJ/RTxVUhW/HuFomHjSz+GvDteZx+3uUJme+RsnvAq/M/mMB2qJHrR44MFzbuCZz+C+P+aKEnHRIBTD82r7ov3Lq/enIk6F7n6+SLkYWi9ic6wRuWeF2lls4WIfaZVHVwx3cdI+2BJqDQbxhTEU3YGWYkfRZSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R1r51KmugrIRzrQnINnLRc7X2TbIMbr5ve0zmybF5lE=;
 b=n3Mn8NG+66wgJ01gGz3ZouWBnu3ksGGnoD8O18Jw4CbK/cuZdaMlqiR2Z/8BTSlsgdYxv9XMGhpuRPQRodLRR3oSWyFUDmAmrIhmWgRVyXAlR4/TJkh8TSjPm47lSQkUAEt5GSnD4JC/fYvpWYGcgDAeBPZuYc13x/VjvMe4ZOrra2aA5VVel2HKyVrnlD76BD6QZF9JnUKqm/m/+KZuHpz7fjx5avr5e/eQ5q/bRlydn06sUBjVKaBW0W9/mSgHyESRbWCWs+X9Zh3ZYP+uYmMs/DNc1ChrbaiAxt2PbJ/yv68FDEGUTk/WZc7+9zWV92ctHEoY9FaEIXgLWnyHIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R1r51KmugrIRzrQnINnLRc7X2TbIMbr5ve0zmybF5lE=;
 b=nRDRQekjX7CCXoid9s/2FmFG1bHztjZmTJh1vHR+63WKjXMUo19E4UQ2GXbuXcahcgTjlN1AnALcfJVgW6wWF3HG83oRZBChsGsYLMb2lyVQTEH05BKtDp3eZXILQ9xOcJFt5nlgy60izbKPeRuesAWDH+KZHbzcq880ukYPryU=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ5PPFEBE40EC96.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7db) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Wed, 4 Jun
 2025 02:00:39 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%7]) with mapi id 15.20.8792.034; Wed, 4 Jun 2025
 02:00:39 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Sanjeev Yadav <sanjeev.y@mediatek.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Matthias
 Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno
 <angelogioacchino.delregno@collabora.com>,
        Peter Wang
 <peter.wang@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Manivannan
 Sadhasivam <manivannan.sadhasivam@linaro.org>,
        "Bao D. Nguyen"
 <quic_nguyenb@quicinc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH] scsi: core: ufs: Fix a hang in the error handler
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250523201409.1676055-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Fri, 23 May 2025 13:14:01 -0700")
Organization: Oracle Corporation
Message-ID: <yq18qm8e05n.fsf@ca-mkp.ca.oracle.com>
References: <20250523201409.1676055-1-bvanassche@acm.org>
Date: Tue, 03 Jun 2025 22:00:37 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0512.namprd03.prod.outlook.com
 (2603:10b6:408:131::7) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ5PPFEBE40EC96:EE_
X-MS-Office365-Filtering-Correlation-Id: 74d10fcb-296f-4aa2-4b41-08dda30b9a9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7m3Y3tsSX6BHs6qfWBlQGdPiJumuQaXDPwepng+G6x4nGRDLqnxoTjY8ZOLw?=
 =?us-ascii?Q?TaDfnmXtOfyWHZE6geYQotPOzacFVoHXHDzyxuh0dY0IqEVU6IQyOl9amDNk?=
 =?us-ascii?Q?b/4YIlzYpu6R2ahO9FwNVif31DeKGvyz+haAW9kt4LJgqY2mC+2Mvq7gTxN6?=
 =?us-ascii?Q?c5XXI1uBRhksaX/ATgzflp0kuVlgi3+gLohCNjEsRGnMW+CMLDgtAlXBzSMZ?=
 =?us-ascii?Q?o+mOPnD2iPR9J8+Uc5tP2O3mgOalj4dorDAhybeagn5RMiji9Op5/xMFXWro?=
 =?us-ascii?Q?HtSN3zTaRezlFkJx4UdKd8t0d6pOZe/WODbe/CPUbiG+0Ne+PxLJCjVnfCZb?=
 =?us-ascii?Q?+A3R6692WLjF83G8iK0sDm1/8iWc/L1iKUowMeMYmUgco60sr9huTY/swCtj?=
 =?us-ascii?Q?Dz6GAldffJhsvW/OaefI6LBYLKoGWUKZUlKRvFms7B9ddNFJN8CC/MUS6seR?=
 =?us-ascii?Q?hbr2NqlL9CFgEjKGhw4ZdV2w0QfdhOaqxAI8awT81fyi86SSq0h8UOJvCnmA?=
 =?us-ascii?Q?nefk5SbqzKxS5sDkVJugJcNd3eddvMMQHoa0VFOykvRdTfVASsC0PFfX2dok?=
 =?us-ascii?Q?pklNMn6ffYoZCwTXWSyBllZ+fNfNcwza55+rVY4BvCdQ1nRBPRkmB7qC+Sf3?=
 =?us-ascii?Q?sYfwMGt9etUh/AqrgUBTMbTEolihHpjCsfQOXyCoTpwPKeKrRo5aRPf/4a5n?=
 =?us-ascii?Q?/LUp6BPqiYDO60TBkXpTtxfwGbd4//RQG988GpqpAEdNAtEPxaVdrioOjeiO?=
 =?us-ascii?Q?O5cpOZwOj/uskCfrGDHbSdxdm9mFw0Ji55FPQl0k4+gXvOxEgE5iYU12UoWw?=
 =?us-ascii?Q?q6drPOtcW0sDXo5PxtsVcmy0HtORiKl3oOo9dXphb8GzfLoOap1+DynvC51N?=
 =?us-ascii?Q?djEW+eDkoC10eDxz3q//hcxtrTxUdvlak1hz7hD5JcPpdEfTBVNd1lCDjqnL?=
 =?us-ascii?Q?Xl3NcJNSDPKNmvYmW6iSpnXtM48NAq5adf1A2fqsRz865Yv6uE14Z/FT+hYe?=
 =?us-ascii?Q?fkbkYOKwOvM/HlB0g7/klfnmQs1M7uOUafGsDhO1vBKR/zBjSzTZq8rzzEzV?=
 =?us-ascii?Q?JVNDe8infUwGGcRWa98wiQqlA9UyzGGumuDku/prrb1B3i2cnlcr9eGEmTRG?=
 =?us-ascii?Q?o8D4TUprTvBZHeIz1oN6/ksxZFmz9a9tLWXEnnlm19PHu7uAtGAmx2WOsw7L?=
 =?us-ascii?Q?siydkjmQJPavufbf4ihhwfwDpijY+Hg+KSQnUmznwsKm9eHbiusJZ0ZbnS8q?=
 =?us-ascii?Q?TCdNnZ+o6uF9EiykrihWyDzL/1Zu4bVUrvVjKweb+dPXirajEjmfqPYnDLYY?=
 =?us-ascii?Q?B+3yrqcd7ktxn03lz+6X4aRkLasbAVnMTyegpxZUUXNcxqJrSULWHE/baXKz?=
 =?us-ascii?Q?uekbT+hS3derFDUBtJLv4oxbtpC0NgYFOoxuORvxKgak6V+LxX0j8bUi4236?=
 =?us-ascii?Q?ivZmxYHf4vo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5llql62WEyxjAucaaul0D/B8lFaWY7MZ7YC3m3UbCy1ee3kc0W2vMYK9oheT?=
 =?us-ascii?Q?Eiv3eniCHinHRci7RQepgNHHGIY7yYZGaPYLUpyfjt2AvpyKOSKZP6HEpQIZ?=
 =?us-ascii?Q?lMV+nRSIlbJCtEBZHPscyjzQdudddTnfcwg7N6qYkQsoiN8AEfK4hIBZFVIM?=
 =?us-ascii?Q?guQ+EQDdxOWSS9u+ILnfk1uGONwthESCdROzhHnVrevgFAWeD/bfwxVnc7g2?=
 =?us-ascii?Q?ZmUWOYszQVjbFj+E2wmnSRvrOoSFk2NPe/DP9ehZnuA/ra5t28kBe4q82VEk?=
 =?us-ascii?Q?VhFYtbjeTFTqqxLnQu296Rd7JbZbBVSsqYXnj7cp9RhuY6kHJWBvxDotKd35?=
 =?us-ascii?Q?+eFD0AaXh+0HyAoo5IuKiBfL52wjE/8a/pga2PnTte22tGwP4dioIf+lkCJe?=
 =?us-ascii?Q?kPdH3zVeeImzwYOCqWQqucLB63lPyNAdLHiuEHQGVl6HxWgj+n0X4cMSBG0Z?=
 =?us-ascii?Q?xj3S28LVPEVTVI+Nj20mxxAiVMEyHcjA7DSgMT1hDE5hyaZwrstjgXUGY7D9?=
 =?us-ascii?Q?E8zzCkPGwo8L4QSv2QmKwUumkBDE9hPT4EJTwL5IQFgp/IOg3xv7msCd7A81?=
 =?us-ascii?Q?hQ7zVQWysBdaz7iTtfatVlMtRdEuhYwmHA2FRL6bvdIvsN1ccyb1/JvKHKK8?=
 =?us-ascii?Q?1G3iuiNc/b3BOiBWTZmNlB7CYQJFDVvqOFhpR59ez8dSY4zgdA5d8d74ts1n?=
 =?us-ascii?Q?eh2kYvFaYtBKLiSpWgXqyk6hgkR1WR05z/2mGkmFvAjgXUThZnH7ur/FD0kd?=
 =?us-ascii?Q?dEaDqs2meuGCwDEcw72lSem8RkjPflFRP1fpCWy1UYPw5PmrUCk/JU76fpv0?=
 =?us-ascii?Q?l/LTORuYAEaM41Q0leKTBWOrPA6zP8E/9gzEnhc2JjGWearJAAlnw5xtVI6K?=
 =?us-ascii?Q?7gQS74edcjxjHvoKDfmKcE354vor9Yso3L/4pof0cLYZ7vkHJ+1BR+DHgWtg?=
 =?us-ascii?Q?NBO/W5gzZOp/Zfxfc9g2QqDfGgI5plewyQwA9kZYWN2EWdszP0mecG71uhVb?=
 =?us-ascii?Q?GimCeTvpzPLsxCJ6labm4wuFZj/dHwwr5byINpWebAnXjiZ+0q4uKexK1G15?=
 =?us-ascii?Q?MneEZlNy3RIdnsqi/y/QmDNGMVdI5b37A7tQ0I+PvN78q3HgQY9QgqYwU3nl?=
 =?us-ascii?Q?1r9rlKuuV54r5fDvNw4KPr8nowrqxOsMtY6fxSQlkMFMJPI/4YT4RyPUKAY7?=
 =?us-ascii?Q?yIZ5+SfhqM5zWnI+GtvP9eVTDFzMYnwgmXwvc2qS1y72CE15sh0vyteUTqvG?=
 =?us-ascii?Q?NVRb+inmkbArpHRQYG1Kw/jOuoRSeJDtIfHBOJMVmiOMLjmZNJzd7PA649ow?=
 =?us-ascii?Q?K6I2lnUYk9Kd5P/SfKIMZ1cXgrH960A7qcsxPvofXSCjfZkCDl603IgZKk/d?=
 =?us-ascii?Q?LOle2yO3bDGlWpxzSQXfVr0lPCfVE+NxMuvbNHCvao/CF28cOET0MqVxfayz?=
 =?us-ascii?Q?7kBebzfpUHpccC8eu2Hd6fib7t9IAPHlYbwFuh0RZkCWx1fDzpcXd2ZwmvhT?=
 =?us-ascii?Q?rs8BBdEo98M3MA9anpPMVERRJdTImoOtiBvFTmdAJedDdp1bbIVzXQEg7bsT?=
 =?us-ascii?Q?GeLgtCIt3FAeCwyJm3megiurH9MP3Q2+GF9pyniS4D0LBc1/FFWS4G5gMuhC?=
 =?us-ascii?Q?Kg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UmCYd6lRd+x3FcPGEumTCjmdwtd6nnh2XLgfL5xFqb9S1sZB0UQWVLEfBTMhrtA47ZIfiEW7zHwgGoU1OsAga/bSAkEyT4bgBWANofxn78troLUpB1kPK15UP6s5GUMoN0Mp7q25OkNlzkh+mVlLV7DfQS3lg1Eg/ZQu1UJTfZwKWzIKxd7sbDFrjMZNQ99bAnj8xBfI/Md2JTJmM7d2IaOs0I0fnaB1acaf4sAUUxdFJze+/t9mX+5d3Jy6ZKtcWha5OnXJ6iEXaRY4QnIw313GriIhMqqg7B6tfmGXC4H6OehYJuwna97upxUqAg4eBKyukPwKg/gTdnQgjwm6J1yCRkTz5j0IPIJfyvn7n+X1L9c64gB9B+w8Il7f+nVEFahAPWAF28jLqoa0YjCyyYrc1+NGkasTVepVu3nAcHfZvZAtUX04k7mGgrihspAMSXNgUVUlvHNwClddsXK3ESQw7tId8cbF0AisGUEjEGxEMRaeZjsLittNk1p97G5tMuGwmvYSvcJNrAOwjG/e2pPowqR/Z5Gz/jNHGcrhj+uLpF2/u+sSzCygsFoNrIIO3EqajxJO7Xegyc14V523VOmyH520agpJwJqn9C6dpDM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74d10fcb-296f-4aa2-4b41-08dda30b9a9c
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 02:00:39.1866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CdPRvtdyhok1KWe7rYy6klnCxA3lZogism7DoUaqsnoSpFlsEdd1YGQwgJz5CmeZyD6ZHx3WcgSMv06sEz8B00O0mKncoswZTWaSquHiQ+Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFEBE40EC96
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-04_01,2025-06-03_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 bulkscore=0 spamscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506040014
X-Authority-Analysis: v=2.4 cv=aqqyCTZV c=1 sm=1 tr=0 ts=683fa8cb cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=osFMRWM_P_v_crBUotQA:9
X-Proofpoint-GUID: hm6dLBcNToRc2Lv-JXt4ugxkLCJ-xj30
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA0MDAxNCBTYWx0ZWRfXwacQr9iKUqyD ONbTpVqG8KxN3465R/Y6mOsVwMQMu4oeTvTJqncgyx2kd7ZqLd4CRCE22XdfWECWc/R2g7nPcBG hZ1TgicpYEGOQNbPx13//MZtoB+KdGw9DrDQlK1o7RI9TPMQwdtVo7+fweCIecrSuvE4WrMVjK2
 OFn9uykiC4Sia8AqeDzz5HGHtNoP55hPzFfq0+Fu1mOCZoIvttTDwDIGctqY0FUHlx0lobcizBR MOnGN/AxiXYc8e2cheoWiyksKaxtiSwvwrRfLapDG4tg1nURHYd+1H7nSqMZPeTqLtiAl2yX0hF VdRXcbEZffmCWFar5CPMQUc9xL/K9vKLcdPCVFCDbkyduV2MAzAeNvwEmwI8dF+41deCYGGWCt/
 rn6lQTgIcuMYnvHW6SB0irdETJH+ldaYEipmlnlhCkRkuWjuZLl9rS6OkvALUrRyBb2/E/A9
X-Proofpoint-ORIG-GUID: hm6dLBcNToRc2Lv-JXt4ugxkLCJ-xj30


Bart,

> ufshcd_err_handling_prepare() calls ufshcd_rpm_get_sync(). The latter
> function can only succeed if UFSHCD_EH_IN_PROGRESS is not set because
> resuming involves submitting a SCSI command and ufshcd_queuecommand()
> returns SCSI_MLQUEUE_HOST_BUSY if UFSHCD_EH_IN_PROGRESS is set. Fix
> this hang by setting UFSHCD_EH_IN_PROGRESS after ufshcd_rpm_get_sync()
> has been called instead of before.

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
