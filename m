Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78256185E
	for <linux-scsi@vger.kernel.org>; Thu, 25 Apr 2024 01:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714008592; cv=fail; b=HKKEInZDgoc5cHpkWkh1qGY3MlNRyHKVVi9PzW1Y3v1JDFLaH3A1uLnOOHTlAxMX7GGDWnJ4ohoKnfOBcagILduyIO0pPeG/kqtFBbNdZwvCKOJ82o+GWUYiD2tuoSmOHe5XbFLdNOGPRMooC1qwWlUPrIHM0AuxG62O9qEYG6Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714008592; c=relaxed/simple;
	bh=k7Od4alNs2nu75qMExSnmfgayiuMT9j+iyesAfpn4aI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=HMFr3H3EejtzBx+rlRYeBpMBkG3uDFbTwaPmVUl6cWwokbtGgDqPm8QEB9LUZsK6XnuSVBb6ZxjJnH8X5yJYaWBmsKq4Th3jbNLm2Bs4bxoTTfgpRSKuc+twKoeDS4uzxPSCr0stqZoOITEt24uvBwUAOClMlAAZflUCkG9TpwE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dz0M5gyR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zLTzKviO; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dz0M5gyR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zLTzKviO"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43P0iao7013105;
	Thu, 25 Apr 2024 01:29:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=ZLOPtRaSqwOXsyFR2KNXmCFLeOPXQGgMFfx0zb12blE=;
 b=dz0M5gyRgI9EYvpguUUn/NtSWYd3oNUq89wD7Yu26bya1sYz8bGUsD6PiXEB8YfHUfxH
 owusVwByGkqyypIj/Y/XgJffN0WygZIJUCZxrci9u1RTX8G2HU3imNtKX5W6SGxr23C2
 wFPR9BRv2VVoWGyK+vHK2dvw8M4giRsFRKCJGL8I6S6e2/y7Rewa1iPksOrALw4HX+5E
 qOU2U2oBtii+d9EXvZWDdQPbPvRBuKEZDhQVEulkKlD1a2ormyM9OlvAscn6qZ6mkvM4
 /ul7SWMH2KTXLKA4NqxlXOr4xHOfj8ZXrtFOB3lflgncHXaGAU0Ez/Wh9WyaVL21qNsa Ew== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xm68vj41e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Apr 2024 01:29:42 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43ONHAWh025396;
	Thu, 25 Apr 2024 01:29:41 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xm45fxu0w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Apr 2024 01:29:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G+1edGIC6C5cRAR/PDwaKqV5ZOisucJ21I0akYl2vfq1USyZCzPBhLiR2EW+vkYGOKJ646768vlcpdrWo5IbfyaX0h2RAweloG8WX0sbazwz1Na85nZIrTt2rqysCb3HWHt9M4h2caU1smFozs2B+Cys+LPRkzvKwM0onS95hJVhcKTenJOxW30pxOybFgbR676NvgzU7uO9vgPCfp9nMcKdiYu25zSHwTcadpCNmJkBJaXdUIRxZypNI70qULidinbSIAeeYLCeDUoNZOTozijHmVOufjMMBNsg87692W8Kq+CHyOiZB9ty5l105YDyOZBxlwv47+gUCAv+UQZI6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZLOPtRaSqwOXsyFR2KNXmCFLeOPXQGgMFfx0zb12blE=;
 b=dhzz3OQbs3B1JiomoImS/lVxP2Ke0UNpr0PDVI9wyz7C2Uk5Y+7Sv/eqh0z3ANRghCbWbU0SfkKozZNxJsgsjFCMPJo/JhBk25b3cA9aDGCA5bQHlWY5lL4bcAPYeQ8zWE2bU5fLYaHx5tSrNlwQaa7YGgnLZIAaWjTAdDYCzI2sBe3g1R8fuJDUcsFJVB4LI2sA6TPGa9P18oPECNZrWGdl5pq6/Gby09loAf7jbQwwjrDApDD+sBJll2gL/V7/6xa03p+6xclFfBYao7KKrMWvjg7pW1ZbXldkyIWZTLqX6KwdbBHYZV1l7GWeBjTdWyLa3jnX3OAT9+XQQm7qyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZLOPtRaSqwOXsyFR2KNXmCFLeOPXQGgMFfx0zb12blE=;
 b=zLTzKviO0SL+1a+NDsj2Ust94p7DRii5OliEzKYNv8a4CatWIsWV4vcqtH7x26BJNdsP1vJ0vlyqhKcC7IIWlQiW67M/oF0RQ7eb/QKZzBYv6YwlMwuRafHLVxd5Ee8JAXpyQP9tmsOAgO240F5wyTjFWgZq2yNB2aNqoRpLvsA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MW4PR10MB6584.namprd10.prod.outlook.com (2603:10b6:303:226::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.22; Thu, 25 Apr
 2024 01:29:38 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7472.045; Thu, 25 Apr 2024
 01:29:38 +0000
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "James
 E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K.
 Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: libfc.h: add some kernel-doc comments
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240424050038.31403-1-rdunlap@infradead.org> (Randy Dunlap's
	message of "Tue, 23 Apr 2024 22:00:38 -0700")
Organization: Oracle Corporation
Message-ID: <yq1v8466xhi.fsf@ca-mkp.ca.oracle.com>
References: <20240424050038.31403-1-rdunlap@infradead.org>
Date: Wed, 24 Apr 2024 21:29:36 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR02CA0005.namprd02.prod.outlook.com
 (2603:10b6:208:fc::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MW4PR10MB6584:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d453440-0b46-4e40-fa90-08dc64c72c50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?XCIHtMeDecEVI9DNfj5O6AV8JafZkotazN1cjG7AnW9EmUXrdog5hkPhyk7h?=
 =?us-ascii?Q?MtfLPJo7a7L15VxN36GR10DDYStQyh3pHrXl2z19mOb2lF3GAXseobyqXPJC?=
 =?us-ascii?Q?Z8DXyIPvYQA+fPBpo1Nc9Dgfacp/E4R3x4rShcT4Lil0MPafi5AcZQeA1dvK?=
 =?us-ascii?Q?V2nqd86hSvbAyrE8knfiqOtEKUaLviDne4Q4xNp8LgtGb/e3rhHoQzPyJELh?=
 =?us-ascii?Q?EQZu2oTChE6O/bRURlO+Coe3rwu5RiArcoj4nQTvHhFx8VS9oZYuzMOjSgeN?=
 =?us-ascii?Q?D6jpFCcgAzlFGjYyNzcTvdS6ZK+YS1Ye3eBqveMuxxBIBm7NAQFeTIgzryem?=
 =?us-ascii?Q?vOZioFQEz/hJwYr0VXYFSrdAb8rHc9qIntIbXLoRkJYZOmobcDZ8VDWbPHy3?=
 =?us-ascii?Q?4bdpN4WXB5R4mWam++NiGc6j5WIz4cEfR2XKsRewsfMOL9f3645iYSpn+Tj0?=
 =?us-ascii?Q?pBnLd6Axuoq39hmcFNflFBuzrylD5M4JEh9vkprAEDCU0RT7+dsAmKqYXxwr?=
 =?us-ascii?Q?Gct79C6ix1kfQ+VXXFlktW9cgoxOAgsaEfhRuIR9r61FLXk8OGATn4D8AOsO?=
 =?us-ascii?Q?hG3sZ9OEierJivzcm8fJ9Mk45RuoMvmmqqXK2GoCoRg7oKINTTrtd2BXiC3w?=
 =?us-ascii?Q?VdzVcC7AZaKI6aFVmkKIql0ZW0ifQmpBljG84B+TUuTaAPf51PnVbt3g+pyv?=
 =?us-ascii?Q?AiPdblyhJuMGGBQ0TA+9xogTI81mj07Gzbic5pFTQFvBMJYWQyaXlxdBYwC/?=
 =?us-ascii?Q?ljfXv4v0vmQGCeP30VckwB2lI2lgYAUxalfIYETYVnXxlxsyc1zWQrgBWCBV?=
 =?us-ascii?Q?hWRxmJ9c4UoLf1pAEj+n8G/t4pPkvt8ltHcOfVJ15OhUcG2sUgQkwjSwNzWJ?=
 =?us-ascii?Q?FcAaAAyCJiV4rU3G62B1n9DUt+aiMlkN2n7x0QztE8XJ2sqKln2kI7D6VZO3?=
 =?us-ascii?Q?suEwaSFgniQKNDFNWTHurCEiA95bM9ovpE0oY3GUWMRSIs2TEF7eISAH1L16?=
 =?us-ascii?Q?VFt0/weNL6kQDnhwB300jXs/QKnyPw04Lhi7+Z4PkVz3w/Cd9WGIGW/v7OSB?=
 =?us-ascii?Q?c4orUjZdi1PTUkfp88RUVEhzhrQaNim3Ff7xvAmq4nGznHP2CHcqfoxBG4W0?=
 =?us-ascii?Q?HJvOl8ea+D2oeLJjseScTLjJWr1YsJNLyxO5m0zw9EcO7E01i58/0c1EPxkb?=
 =?us-ascii?Q?TWibUG51BDieOjpujVogV9P51zWVINSId02r3dzx3UM2Iqof6oVz17UB4Ckb?=
 =?us-ascii?Q?WIoxsYl1IbSK73qaX7JOAD8bQnGp/IblIGnisi5Jng=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?qxlkfyv9nX7yXtDpP0ZSYb84L1XIm1oSzKhR/zh1EJ+hQk8GYZ/PpOVz2ewy?=
 =?us-ascii?Q?jVrHIRUbmt0u3Z4sc8bjOEC0xYPcChbixKXtxMKTkP8ardL7Q9SnCMOoO9Z0?=
 =?us-ascii?Q?McfjKzu24n556l4W3zP5NzoPIjHjkQi4Xzlo4r4agO1ziI8+SOw+pt71vqZK?=
 =?us-ascii?Q?/HKikBRjWF/jvo+4UH8xLNjgKqG6/7OmBrEMySh/BTUgVkTgup/lZxGUqvX+?=
 =?us-ascii?Q?JP5MRS7dVqMUA10QtVlSzCA0MDoHZQPCdwuQmHfSok1ifa46rtOmZKkPKm9g?=
 =?us-ascii?Q?uJ4S/mMTX1Hfd2YUugcB3DmKbjv68d9iHlkzM8FL1L8NBrpvtg6HNzEdSsGk?=
 =?us-ascii?Q?u20P0eHm5yITyjrmJpCTR+xppT493EiiBNgepq9SOerlieTjNwdi2pEOm9zV?=
 =?us-ascii?Q?a9e6Y7kYm7KYZ2HHpakmZgBXAa/NlAT62XjKbdvpB8d/FeBPy64BWPZdBqhG?=
 =?us-ascii?Q?5oL+fP0tZ28dQ59o4fsIXn/RX4DJSDSO3tLtQgzTMFA+CzY17Bl0vzPTLSrg?=
 =?us-ascii?Q?9HPKGkksN2gLwgBkHst2vTZz/CUEyD8xLBM2HkDGB68mYp21xmTILon3GvIN?=
 =?us-ascii?Q?nSTvZqalq7T1koAf4VRV5ZTREkkKHSDnAGTai6zLARnKxmNVe7nLQDVdCe+U?=
 =?us-ascii?Q?P20OPJ5d+q/4YdVMdyOq0Si7imXyG4g9b2+cGF4CPy5WXEmEhsDiDE5tKqWt?=
 =?us-ascii?Q?c4ofy7QAS5TJTAV+8jcLXfdxlD+mS9xnWrDR9aDVRRi7/v8Z8NliKU8/tDGS?=
 =?us-ascii?Q?oUfIVxD3cj03pJ7F91t1wb5gLfPero+/7SEp0pjsCqxsCZgOAwtuIGo6e6lD?=
 =?us-ascii?Q?vstusunYikVL7wqiIg+u0Xw6Dr55xCfGcHusmUpvTgYP2ubPonxvlIixzBmB?=
 =?us-ascii?Q?lY7Pm6ReYxc+8cBSx+5mcKbTQwqQ+xH1MpsbIVJMYXJ6vqSKHdF+fG7ggjWT?=
 =?us-ascii?Q?c91EhBNCD6G3EFfOF7cqiYvf6HL2FLfR7Vho6uKQOQZddA1KebsU4TAiy/rj?=
 =?us-ascii?Q?E+sotsq/wHoohp0qFKvG1gQgnXqM722M6DSVLvbuTQuc+W75H5B2d8jX/6qu?=
 =?us-ascii?Q?uEB/BvDmwJeVaoKmVhN+VguTTikWfeq29j1vcOTWl/HL9iMikmeoR3tH92Vv?=
 =?us-ascii?Q?uQrLWNkVZQCD9jIhBHyO6ZwkQ7nfAZoqlSSZpEgmSNwbBpLj7aAPfxKM6/Ql?=
 =?us-ascii?Q?N34OUnqi1gq0lm+Gxe2f0vy78H0H0OYu+0MsxR9ZQacn4AN4HukzZpN3gyo8?=
 =?us-ascii?Q?JeiLBu+e4zarLla436LyWKCPzzAtAYxYmdS1vv1sKvWaVK9YqrG7D0e9Xawt?=
 =?us-ascii?Q?D4GPos6piAwVVKEKWXoKeVUQNPyJ33Di24u1LqdZbUCawvXI+rZbaoixhr0r?=
 =?us-ascii?Q?6mpXj/D6ieXWtQYbLcuJNGCke9Z46djgagj8WX6BdnRaiDzhU3jj0ajm+/q9?=
 =?us-ascii?Q?irgX+XkAmEd7MeAYC3I0E+9wLBwVAuxmRkTiarTPOhSEkyUqdIJo5by39Z6R?=
 =?us-ascii?Q?sIs8YtG6OAq4t0fva6YmvgxhJFcgJmB0ASCAQkEI2gi3Kwniua0+MR3suWWA?=
 =?us-ascii?Q?VNZxjlBTTMRKc373RKm78GgZOAuAaGC+vGbO+eFSXkC+8iYSpeVFbO1IShuo?=
 =?us-ascii?Q?cw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	vI+/Hb53BPERD6lKQH0rZr/1PlsbnN08VumbHRXrZGrnprvpNPede/9gREeYiWTXVPlVw2VqjLamOAqTrYYUZsq2mbb4H64d+P5TABp0wcGRG5XPOij1dLC3mJqB3IWs82yPF3f9MZjgxhFgSCDHruXmNYQveSxaeNeb+oQD9k4RHvWZFHq7G5LXHaFZYZZDEmL+WX/gEKjJU/tKR3CYh1HywbgecsbDrrpQkd1tcFkHTMKuPJwaqiCdPGx/VnWXKL1+VyGp5d/xh0C13a61BycX9JRs+zjaSnWuGUTmOCVVxG6qwFCt2gUc871HXD8HUczAbuGvaDMg9V8TrK+CvTlB0RNgFrIlemQ1eD2o1RTu1SrXmS4bO7OgDGNVlbl2Nom6ekUAubrhaSgDiaiz3fx0o5vxkdtv6YYsWTIo5ewaHWArLKCL8ISD/Tws3quRTj6QVgoPStj6/Q4QjHE5G/1RkVYm62k/hrAZfuntfkIYMkqbPsT7LNcqRZXohGvnHxBv7s7AOPQeR4Ui5JugtUnbnBpLDlurlSr4HKr40Pr7bVghyQhIh7ZQmu1k7LCzpssEjeT8W28umbsPxTqP1L0sItcvLYRs9baZrdrfVCY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d453440-0b46-4e40-fa90-08dc64c72c50
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2024 01:29:38.5491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mB+rx7GPkjUA1y4Wze66+OBG0QsNmjz3+31i+k2AjFuwglgkJopfBivS8ocb47Lq9ty839dojXZ9HtMJR7LKd7qCFo0IgEhOyUr26dbBDR0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6584
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-24_21,2024-04-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=912
 mlxscore=0 phishscore=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404250009
X-Proofpoint-GUID: bOEwQdGTivQ4YSTsLeSm-a3wKv9j6Vi-
X-Proofpoint-ORIG-GUID: bOEwQdGTivQ4YSTsLeSm-a3wKv9j6Vi-


Randy,

> Complete the kernel-doc notation for enum fc_lport_state. This fixes
> 7 kernel-doc warnings.

Applied to 6.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
