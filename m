Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBE24F5E6
	for <linux-scsi@vger.kernel.org>; Tue,  9 Apr 2024 01:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712627315; cv=fail; b=i6xcmtn8sfEPx1yglEWp0xsurdbui5ggeJuLptXwdCsYFfuYwJKBvpTZuLk732faQ4rpNYMJvfWBm6ZH4kjePaJdAUsZKJEAms2iH4+L81BBVQ6fWNLeY0xEcg3XPW/eWNtQGpCIBTKRrNdBcL6aJ6PWtm3pom4axdPd5l/8ntU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712627315; c=relaxed/simple;
	bh=4ZD9PnwWDAHD7KhyI0pb/t9PGaGmagkJYWv2S2KSjJg=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=aZr/aOAIoO0E7zi2F4Zn2Ux1X1UQP8RaMzGk7Sk0y8UfeH7CUQ+aFp7axxO3/AwceEXmvD44eIusR32Z3wl6txzaMR6qZaZsUFvx5/xvLxOwCZ/vEWcVXOG92NUC/xpBepzqPkONS+GDPJSJoQ0hTq7VYJrzGU7s2AquMXOBYYc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WEQWjuJT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VQ92xxYR; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WEQWjuJT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VQ92xxYR"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 438LnM7F007089;
	Tue, 9 Apr 2024 01:48:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=3Zn3uwNwZD3xAP5+6H8iwQeQe6qAYyl3gJ4Zc7oSQuE=;
 b=WEQWjuJTf6i0xnuFZb+LioHqMB2cfgOZdDKwOtdFrF7ht4idS4eLjpHFB2am8tzmeaae
 fboQTcR+ysAeFni/0xkFONEXY3nymKK0BQZXCcFjx5HEDTjqEs1CPXjtrcu9bD2ET9Lt
 64fzMTDn+d7p3C4SH+sCkWoSua8S7R01Hyn0u3d9UIK/utJlyHbbrewT76M8dlrWgzEV
 82SkWpVD9dUwiqtu5pzVSny/1TJlOZCfgDHUH4xz1uRhNQvy1guPqMlPXOE2SLdBnD8d
 SfeOl8RRyb0S5Uyt9LJM2MDU7xdTB1zAZvnheOgs+X6Av3aTxGIsYJ7kRnml06jOruQa IA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xaxxvc1mw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Apr 2024 01:48:27 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 438NU3od017924;
	Tue, 9 Apr 2024 01:48:25 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xavuc8jvw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Apr 2024 01:48:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GqGu2AvfFzpjf7xKeL2NjbupSHuvXRVIZxqgxAaSuQ3z1th3HKk+uxcKCjbNyXCBgzKGUIW672SLGg9bvV/q8NbkfpMO/e8zdiPV81sLCJq7BE50iwce7/5P0jkq1Qp2uLYOVzA/invQUeItmwcZ36ciSivVDRtiBEJhK1diVO03wjCiok+gPpAVOQR+UHx/WrWs5zzQwZMb5dvj/wuX6u09TKT5NWqne8u5t3sHJuRZz/GOeaiQtcwEfnLqxnoSIWSEu1cyaVwaDhC3tW6aiu8dcdhkUfypMHAGC6Etid+VbNLELPm2wgLTqXi9IBwpaFiquMveFXjhJjmxNzLpyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Zn3uwNwZD3xAP5+6H8iwQeQe6qAYyl3gJ4Zc7oSQuE=;
 b=BtFegpEJ1fUi1tPFOX4CdlJKgm2Tq+577XceDz6+u6QapK8GaIlB4mrjDF0oFYU+dd07JO+sdLkpb6jFIyvxeZwIGBuwJ5st0wOSROPyIo7Tjycgb3WtKtGXgtX5Ejc4MCYz4yWgqkGAhExPFHIvgF1BC41D6xEvknV/lgpzJPB9x5ayL654jlYaZywEPHz3nLSsplYpIGQk7vqAtvhjzo/roWJPB6O+u0lffRQig9H2QxXojlBIktpVi1T+Tp/nLaOZBUDokMTTuGAZbWa9vww32rh/NfxL/J5JNyD8GGlt8PKlEmWt3sMStIm+kOBVO0JikZCoon1Z6lC9GsqLmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Zn3uwNwZD3xAP5+6H8iwQeQe6qAYyl3gJ4Zc7oSQuE=;
 b=VQ92xxYRR1ctG/q5cN5u2bseDAAddnoTqhJEqlQauSP05gywArlKZsxcZmm8LIa0adufYLyMMWM7mB2mTtI675EMeLRYIbpgtkSlTEog+ekcRiq9kZdqslzAkhIFUgg7SgFxGMLsei+4+QGmVCOQRx7lw2TOux8PcoeLo8Ccejk=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ0PR10MB4590.namprd10.prod.outlook.com (2603:10b6:a03:2d1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.55; Tue, 9 Apr
 2024 01:48:23 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59%4]) with mapi id 15.20.7409.042; Tue, 9 Apr 2024
 01:48:23 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Sumit Saxena <sumit.saxena@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai
 <kashyap.desai@broadcom.com>,
        Sreekanth Reddy
 <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley"
 <jejb@linux.ibm.com>
Subject: Re: [PATCH] scsi: mpi3mr: Reduce stack usage
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240325224435.1477229-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Mon, 25 Mar 2024 15:44:34 -0700")
Organization: Oracle Corporation
Message-ID: <yq11q7fpatx.fsf@ca-mkp.ca.oracle.com>
References: <20240325224435.1477229-1-bvanassche@acm.org>
Date: Mon, 08 Apr 2024 21:48:20 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH8PR15CA0015.namprd15.prod.outlook.com
 (2603:10b6:510:2d2::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ0PR10MB4590:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	d98xlOheJ9Z67ztRe14c8QBRGwxeypABxBD9FHjBO059JLElYVatt7jVuAuMkDXGs1csBqTEk52hou3FVZPQ6EsqHcMEVia0TyQxO+uvHob+nnVFglDWbvWt6xmckKnTEpBoIMr/Lkuj5uckYYiqEaivuiXi+Egzal7SP9G1fHHbQnRuI6kpswxPupKy6hUbIUawMD5Ahnn0K6/f9H70WhrglKeq/RLKkBOBW4FQXYtfQLpbwDlG/D2mg9biQoPMRyVTTl2Lcp62iUaM3aT+iCS7zNyZvgy/2zx3hMdqsa22mrE1dYSRDTjW4F0Qjw4n1lD++RTjipumPCZaJJ2W5dmi+Vf0x33OnZ/Qhrqh0ZZbIJDCyV5TUF0XiTplErnWitCY1z+sxU8IU12Co0Okn+IHhog2D+zJ54On478qLMsJwIlogjMbhrR4E/HV7gKG5+5AS636HeVZWPIIXfp691c6EFre88hJwA+LX32DLeHPUjUADteem1lZ1gZ1RK5d8Kpj349J2w3NLYtzF2A646BUZDRqIPrtsCwyUefptdgVMsjP+4YHiJsPngVSlrR8vHu1De3TrZt7Vmr3IB+njo0ONuxf+7YFg/PsuC0ElkbRydg9i3Fjjs6r64vRCqGkIcyZfacmYRAOjOBs4oRPrCJ+EcnmHahNG0vNfHzsw1s=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?/VCAhXfyVQbvAxoLcNeBOXNj38Q3oULDY74vdQwqGhgoiDuaS4lF9WHOAMD4?=
 =?us-ascii?Q?mljzJ2kQmduSwhIHPcW/OONQoRHitMlX6q8deyl3iT5IUhpsXOa5zI/NAyCu?=
 =?us-ascii?Q?y+Vk0vDKb3jAi3lapLVo4fV2DTqZYmFar9h5W740uBLs0b6V5LJIgEUyXWKI?=
 =?us-ascii?Q?qtUPHsvaigWmGg/FGPyxb/DXYTCdwirjxsVRHct+vxQl4CimuOoG6BqkjnXe?=
 =?us-ascii?Q?JipowLD5FKRajiJeT6PrdnMDbrGbyq66u/owupSXAfJKwXMnlHmOi6PWIPNk?=
 =?us-ascii?Q?rNZbuH6LcHOgIocdURwaUA1YyDjlTXQ6hFF70pSzlywEjfvEeJ+s07Ce7EmD?=
 =?us-ascii?Q?mPRJlNXT8Vcy3OMtFD3Ljo6qm5znrk1+r0rW5YQ+/qbPCXc1rtfH5L26I0dq?=
 =?us-ascii?Q?07NKmOuocvNi+losy94WwB5pNHvT6Mum+XsrCykNQWapPw4tA/XrYtfibAnM?=
 =?us-ascii?Q?INb4V2HsOQFkzXMvw0TtghKN9HZcgOvvwT7HpUnAq08RUV6uqNOjcwEPlNJ2?=
 =?us-ascii?Q?H5KILHFAc6IjRewoLMMjMQa1ihPJogfDOofzuLQ2u48vqzxKvxW5GEyIVuy0?=
 =?us-ascii?Q?uHLy7KHQgoYErwqh39wNEkHSlzZtyCkqPVfvYgSH3txOSMQzjRJsAn1T9y+T?=
 =?us-ascii?Q?B5OLJRS4x6XlUzU29Uj936qtDoJnFqE4m2cDIxwRUfgZsBLXZTNlj5YS4eyT?=
 =?us-ascii?Q?8p/TXt/MrGp+j5ssMXNf1ZoSnrgIY6YSFGPcomSzAJ8wPc4D2V7totypbJPM?=
 =?us-ascii?Q?wKZ0VyharHgzAOsypI90g7R6jluq6799dT6vehA8IS2jv6sbbW0UvgJxCKtQ?=
 =?us-ascii?Q?b7mt4FTGkp2g9X6Ed7CywNjO8hAuhHPvBL58taVGNIIfIAukfqwQZEbIy1Km?=
 =?us-ascii?Q?JSfnVJ9k1K7jY0lw3ShBBtXTwKCkmpJBDXH6r/Fe2R6oR6auRlTwkAy/dGVC?=
 =?us-ascii?Q?MO1clSD3OCS0KCbdY9Q98lDZhtr98Maim8mF4Z5jvZVEV7zQf+n+lJAKlKcs?=
 =?us-ascii?Q?3pYa9qPbIeSUyzhnmfHSfdXki6eRgIvtVN+npdu5lcB2ouKzPCfdcjyNuG7E?=
 =?us-ascii?Q?lbuXMbSWQ5bC9BhIdJA4OT4MrynhFVEhUnhf8KgEOhZuzwxHbelclF+g8opT?=
 =?us-ascii?Q?rT6cEJ91jmybGvdIo83O5tjDdCUA0NVZo50V42j19A/iAUa8hM4khZ4rTDjt?=
 =?us-ascii?Q?aa3DY4llsp76vWHSh/sQFMKwj8I4aGk6jsUqYVljTrFm7OodWagQ6BAm9YTp?=
 =?us-ascii?Q?zNYLY2r3zKrMYJyLwz2jAJ7kg23HGEL7JHBl3H+t4mH9OKq/98PbonmR69Ah?=
 =?us-ascii?Q?LdmAdGXyV1J6GaXpmkRamsRhyQefc39Hne8VvGEUoWyMAJY7yE2I6l3t3/vv?=
 =?us-ascii?Q?+76Ity+z/VfDHZ8jTX7MMpOxHbOhsyGCtjpTwlQZwvUhCjgyxMVBb2wd4aPQ?=
 =?us-ascii?Q?3XUc7THLHaZVZaAUC+DcbDG2MHwUwEBtIwPg408Ge19CNtafhX7lD/SfZPFE?=
 =?us-ascii?Q?oezYQpmv1iJNL/bcGtSEACYUcSJRAJ1mq+08kxDxOva1NNbwmj0E6ZjJzv70?=
 =?us-ascii?Q?zrcWp2zNV3y3avuUo7h3QQcFKIU5Kllsb2UIolwhJFTa37GXzt0dRYs+FyUu?=
 =?us-ascii?Q?3Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	IyA4o8nNOdBocraE1Z3DpRoBqBSqaQBfyWqS41sfquOsqtBR/1YlZ8fihH4BFR9bBgRKKliiAz1RuAIttckba76xPjfDBgeeMGlhgffK9/9wyPAjKnPzgiGZooDPpmhNQjaokc0XZ6+WZxLuPYnPP4FC7FWPCI8lLrRYtkdZBjPbJ6eMTgxkvd4ykM5rRYOBsV+qZ1pMZ7eGRX43QG5Iie9yOMzrvAT2UcpsIsWrHboOdBkm2CAXfXyIyndOHserHHlDqsLuaU8DnrnIVll/K9le2m+7Fb/pykd0riHuzEnKIWL95OL4NqJHKqB+TUYtSI4a5vufirWMV20EITAcM/HcjzY7QTpojA/GwFROXwL7eN7m4r+6DEOeqmLfxUEsK23PJ6wFAIukNA7EUtsEYPm4f68Pm0gM+p9l1+/8tFAjZsDRgKmV380wAJRO7seQsFBZJTrjcTgvH/EZwpGgf0nXDzSGhRqgykuGXWMS4muXZ3niLtcyO20tJmhxp3trgZuLCJsrK13Mi3WMFFiwMSnQ6o7cf4V/f8KGxrESUEn4p0NEv3WIOAUwAyMK9pf4u/V5xjVA13RvZyLHtwVuVaVf5wVa7J7adwpThBEQX0c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4e594c6-2161-47f2-fedc-08dc58372424
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2024 01:48:23.5051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b7U2v34RcIbDIl1J8/Mz0K2ioXazX+oQPtdxYF5hNDOlQGJxdFeAXHAX498LxXk4EY2U9aLEW+Qzr/dJWaKTeyfHpAe5UplA/fQB4OVD4Mw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4590
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-08_19,2024-04-05_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxlogscore=945 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404090008
X-Proofpoint-ORIG-GUID: 3wB2A371ZrT9L4axlTOv6Lbzf0NcqCs9
X-Proofpoint-GUID: 3wB2A371ZrT9L4axlTOv6Lbzf0NcqCs9


Bart,

> Fix the following build error:
>
> drivers/scsi/mpi3mr/mpi3mr_transport.c:1818:1: error: the frame size of 1640 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]

Already addressed by:

5cc2da0b60e5 ("scsi: mpi3mr: Reduce stack usage in mpi3mr_refresh_sas_ports()")

-- 
Martin K. Petersen	Oracle Linux Engineering
