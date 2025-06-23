Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933A429CB58
	for <linux-scsi@vger.kernel.org>; Mon, 23 Jun 2025 17:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750698793; cv=fail; b=UCxd1A/wgwnXDlSrYMUjcoCj44fMGQExCAKSAmCWWMzHy/+Jv+FyepIgG1895ia9jCh0YWOtF3Uy6M0lxopZKdndM04jogOa7RDtDWzTBEA8jdrCGFgSZAESrPfX0qX4vEMSsPGFN5vFMs1SBg/+I2hA7PQ3TaicZiQd2tFtAFU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750698793; c=relaxed/simple;
	bh=XEoImBhAlV0GZhcGsNKsALfb11xZSUUtXhaWCEL7IeM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=btpEPJ8ga39BWIfpAWbcSvzN5GkRYbgRwIx5di5LUUqgoryh49YiUQYahA5p/nDg7XwLpnFbx7JEQPHtCoIpi/9iVKdV5MeewqztOLYlsXLLfdPq8ZD2ktmkQjNxbODc9RehOLj36pQQphT6c2K87UxrkY3XEOjE/FFkEdJGFyI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oyxvDenp; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ie++o6VY; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oyxvDenp";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ie++o6VY"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55NGXqmd015427;
	Mon, 23 Jun 2025 17:13:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=oWA7jTwh5G/lIHATeR
	uwQAiuPyMNUlA8zcbLPhMkMR8=; b=oyxvDenp2KodznMRQKAIj4jEYln1y66zq0
	mNwaMrUb7+RAKN+n74j2h8WJjTNwYvAtLQyUw7q8GC8pJ97iQa5StVI+83nv7Mgf
	YWaGUXM4Ks5WWbflOcQvKi6Dr1WllIxkYa95RlbA+X0Rl13a1pIVBcYA/kWHuDsc
	9Q95oKgaRL247MoxSnPXku5nzCJVwO7Led23KBnhOoN4F/Y3ILLYgIQ6ytZWaCAs
	dYlelXu0c2+oihg32WSuP5vUbE6bb5zLOn8LIQLY7u1c0oio1OpFNO63DZSTkAOU
	iAmaOXGGxtj83aJ4xSEHm1bRFa4Iy9ajB7N7c/8TqMTds309s6Bw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ds8mu6hg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Jun 2025 17:13:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55NH11OX025880;
	Mon, 23 Jun 2025 17:13:07 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2051.outbound.protection.outlook.com [40.107.220.51])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ehvv41mj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Jun 2025 17:13:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XIuqvGiSLhF2DbW5hfWaH/MFDJgPlXTWZmFnfJHU+Zw9/dZsvetdg+6PORT7skANhdymt9D/8X4jRDb0lCw4KOH+W7xetce34mhepLEWnVRG21FyGZLXIS49ttRJf1R4DLaHgdQc+/vPDV7CZ3o8Vjkpy/vA4BxlLzHE1uyNQzI+ZgFXLpyhNJC1EBduYps7ajPf792W2L1BdZGmUwFTauEJRJl6sQHdZaTka7De78MI14CLl06AagXK+MTITs+/MD+393uLZ3mKY8ks3m5yqFXvHwwsGDNf32z7uBZTR3dru0PoK1jkroPRL0oPeeAtBdHSli/XGgoiSML8P07aoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oWA7jTwh5G/lIHATeRuwQAiuPyMNUlA8zcbLPhMkMR8=;
 b=LFOtcZlTCs863z3r2E5asX6clfG1XsgWdzf8q1SiM2+fXZEwV/P0bDdyM6UdGUOO3H7TVrnj2PKd/6FjVKIfIHUHH4WzELlSj4sjSHwm6Wq9nbuEQZms2LtDU916v4VonxDti2RPZCotGEm7J8r8zlrrV4NtwVY6b7n5TDszDxFyIG6Oe/PlKIZ0xCM8q3bmQk2P6JJA4e+ZcpkfUSvyanKF1QqKRU1w7XMl7TBG2sTJGUzSMrLoclbHQrD7FnEqi0iN4O1+/rL3AIYCvbW8+UxV+SeesuIL0jGbsHfrbY3GSK8bG+sQD23QHS6meLx+2f4Y4L1yeeUnzCSabIhE1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oWA7jTwh5G/lIHATeRuwQAiuPyMNUlA8zcbLPhMkMR8=;
 b=ie++o6VYQVQgRLJm5mzNa1uxKfM3R0UYg4UFzxyYwYzkUTIuN/KomWZxIA/vW4jMjMxVR9r2yIQDjhNhbp3oQ/99e+Ft+Led6v8braX8Lzlj+63ROh5qPTIvLsJtCS+lHJUjtCAqVHrAljvmzBx7gAQ4HI+I48VNyYOVUFRTWD4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS0PR10MB6175.namprd10.prod.outlook.com (2603:10b6:8:c1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.26; Mon, 23 Jun
 2025 17:13:04 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%7]) with mapi id 15.20.8857.026; Mon, 23 Jun 2025
 17:13:04 +0000
To: Justin Tee <justintee8345@gmail.com>
Cc: linux-scsi@vger.kernel.org, jsmart2021@gmail.com, justin.tee@broadcom.com
Subject: Re: [PATCH 00/13] Update lpfc to revision 14.4.0.10
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250618192138.124116-1-justintee8345@gmail.com> (Justin Tee's
	message of "Wed, 18 Jun 2025 12:21:25 -0700")
Organization: Oracle Corporation
Message-ID: <yq1v7ompejx.fsf@ca-mkp.ca.oracle.com>
References: <20250618192138.124116-1-justintee8345@gmail.com>
Date: Mon, 23 Jun 2025 13:13:01 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH5P220CA0012.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:34a::9) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS0PR10MB6175:EE_
X-MS-Office365-Filtering-Correlation-Id: 234ad01e-d2a2-4eb0-2f39-08ddb27936e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+1FMGgxJGqjaP03yPnQP5zLupvVzkxNwsM9wJEz4WiT0PoCurc7rS+9BuFAq?=
 =?us-ascii?Q?OC+PoU59tb2hCOe8mJtS8Agj9WQD5d6psBCIwDT6BrPzksPBz8wm28jkWpEz?=
 =?us-ascii?Q?EMlPa+olPl5UWufuGIprhT65KddT+KfGTQSeet/XKwA1vs/vdw4DCG5KJFsQ?=
 =?us-ascii?Q?O7LSrX2zqy7gOGFe/1L1sWzxRsGliYjzuRkiLFBofFE5n+Us1e6HiqApelJB?=
 =?us-ascii?Q?fTdRLmqqKqXNCGDPvGFN396b2dmvYKS704QDBqRHIA+HfRgUsWRLObHDtJx4?=
 =?us-ascii?Q?auCXNWlwGOzW9aHy2svt/3/usJLT3DIW8AxglOqw9auFWbftSssuuBESoQiS?=
 =?us-ascii?Q?sxYuG/xg7SY1AmQ/Rxz39alb7pqlrO4I16IsU0vB6mAFtoI9VVYhNDcc8uJC?=
 =?us-ascii?Q?BiBZGGBoPY5cv/Pv0npQ+jwCIIutg+ppJ5KXKrXF0ncnIt26dAVUUrCRzj5E?=
 =?us-ascii?Q?y3iXzV7OMuoivZn6ACEoURpW7077MFrUQuWc+Uq3/aGqoLMigS1uIX1fD82R?=
 =?us-ascii?Q?7oAVqbsRV/a3/u4qXdZbrW4qVgUuKDfSEQrZ8P6SyXeccyAy+R1DKMfeaEyT?=
 =?us-ascii?Q?dSP1P1V6eIhhHSAb057l2ylS9dik0zs+OmMJhOVQnYyjLtx6jlbgzEeie8EA?=
 =?us-ascii?Q?45aX0u0wA9hdeKXkHgDBisHz5281DrfSw6G6Jas4g+tNKNHyK4jkNDNZHInK?=
 =?us-ascii?Q?qF7OKrEcdZAGXvHnKyUWcIth0X1csj3pGNmozyx911w8Q8QIi53+rqZVg615?=
 =?us-ascii?Q?8vXRW7HqfkD5ZYJCqIZdfWsLXuuTEv0x/fqZA+v0XCdGOsO5MAjM36xjvYF/?=
 =?us-ascii?Q?acoT9eMCFDj3bBcIJwD6JwWrsXpKCZjlDjRzv6jKoZjd2Z2tjZ8VtivUwpC2?=
 =?us-ascii?Q?KZKvmDY8o22aFaIKvu9iwTh4TL9MogwYrKpQ8z+CVoVw3P7U7HtUYeX0PXHp?=
 =?us-ascii?Q?HJSDw7GuLWlLXDHa7Oq+sI/8KZWJ5LxIEPj3ruJRMWZj/sedYnHqzjWnyAiy?=
 =?us-ascii?Q?bQBHaTm8xsGIbf3o4LlMGGh+bwTqa/4yNvU2RSIVUCq22H0nSu1pGKdG3dRG?=
 =?us-ascii?Q?fP9wtbAhFD3lYn9OQf/VvpoKQMJeXtSZsK+fiHg5EptwxKkzte8IfJPgZ/3R?=
 =?us-ascii?Q?H0LqSP2+imkYBqbuGvBU/zF+xBJehSpOnTNqaJLlmqqASNPhtPc0aHc7AeFb?=
 =?us-ascii?Q?ulV0MqpnIOx7PDcJ+P6EoILDcwUdAPfgawY7lgSI87v95E2ilsgJFknIjaz1?=
 =?us-ascii?Q?Dnk/YiJVxg7dXVF89/a/SpOHPCg/BvoA3DszIBxExnMESfKeZly1J5kghM8/?=
 =?us-ascii?Q?0ZjiOtv5BDRH4Y+/yJ+tVH2QCs7KASW+jcM8/Qvut1autEXEBr1RwjkCd35v?=
 =?us-ascii?Q?slNd0fPYxCgBlKwfCDYvoaUhMvpJurHqsz/oiHXsHf4w9ycjSVk+SMZsyDnR?=
 =?us-ascii?Q?OQHcHCLdH5k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sC8sytxMX3Q7oTVbDkSBjzIpTAVjkBlKheMQwOtpjeaguA22eUSMiUL/nlEh?=
 =?us-ascii?Q?apqnYmGo/5BrHr20xAyaPdJAe+TkVvlGIiCaJzMiGFY4fNeN3ALuT2/Y05Sb?=
 =?us-ascii?Q?e7LQJL5skTokdHkrc3VeYUfnlYQGO0LjOoDygaMAQSa4KgYGMkrYJm3lnhT7?=
 =?us-ascii?Q?0xijWKsQjc0WOPe7aW9sBG/d/bPOMXCBgCZJJrIinE4jlPAv7SV8tP+mHFke?=
 =?us-ascii?Q?qHcvjFcby6FaxQEf4RTWB9Fqby0sRIBsU4j8hGU5FwaV7J21TU7UK5O69/3H?=
 =?us-ascii?Q?h8JNvT6Kzh5ZC9wiilXc7pBO3nCNk9v+yhgnowqSJyd0KkdoL2y34U93+sNW?=
 =?us-ascii?Q?P88H23UQO96/2AUBawqg7sSL0B87pvmf4eTOGwOGKoWiEZz8HacZmCVMw40X?=
 =?us-ascii?Q?ePnFKIIfE/ynFjnex4Jvxnbz66VbdY9Ore7vhYXPsdtcFjJS/KMpmVzd5f+2?=
 =?us-ascii?Q?6G21jgjSjdJU8xgdoGRVjPCSuq+5EN/djPaOBjTGyYW8KPxF0MJwDzP3Ynxw?=
 =?us-ascii?Q?XQNgvA6pHW8vrEUgX/JjXmDYnF8/e/3c4zOJUYHBCMCDffHPUV6nr5xdaEeW?=
 =?us-ascii?Q?Epz20nXXux+3kJnteV8IPKNbzJh5K5SAN//i6yvyd4Sv6umQ9CsrtMg3otDq?=
 =?us-ascii?Q?+LaUCDdkJJYafHhwkdbnBn1m4lNgzY4dHz8J7Dowp2qKky0P3sZS+FhAGNcE?=
 =?us-ascii?Q?I/FSoKyGUNE1Qsq2STiTiewsTZo66mU9iPc4LiAl+UDnM5rduOZogDuczM1q?=
 =?us-ascii?Q?I/H6bkE7en4+m7VlGeYaYaI0kVsy8JlGmlRBEECn5POouYfOawycaxXqBVpv?=
 =?us-ascii?Q?JVBDyCoeAN5JXJg5ZCoPIGDuEVLA5nPn/Tp4HtF0uIoLAoRqwRVUeyhDZwbp?=
 =?us-ascii?Q?VejCCPEZ1VBKDFMxdmeHjY1Djr1j4qhTKyi+MB1o5o64eKl9ZST51jlH9Dwq?=
 =?us-ascii?Q?seK/vwzCkWFuwjyQk2lASL8Vae06bJi43CjQnNwQZmdfZex+xs0pIUFmWcIh?=
 =?us-ascii?Q?OEd4j3j87VaMngi3CDC0P1vq1Jm4qKKjbsRiEoRB8u1mJzW1nr8k0vCTX0jY?=
 =?us-ascii?Q?M2GTPXe3EjQiVSjVTxZ87mIS9ZLJITYAmt560BtmiCXC7GMFWt+/oyoQSlzF?=
 =?us-ascii?Q?XNUOmYjk5BfUYkIIyH5oGYoJUY1v4wpSYHyPiP8EJwwJBATHJKw5PVxek0Ro?=
 =?us-ascii?Q?bsA6gfE4zdHvdkR0voMyJRkUsriEq8ckD35cBLerbj5tUIvMIdmaNQ1OKT4O?=
 =?us-ascii?Q?UpqyV5BLk0/0laU6oPD5i8jRqIHO4x5mGCAotPRQrki6FuhrlXxCww6PQNFs?=
 =?us-ascii?Q?KXLisQoOstNAI5ZpZKqjz/B6tDKOgZesBfoFYeJhzKwmbyVDsjXCpjQW5Hfl?=
 =?us-ascii?Q?m+nMAdECNxq8eSNQ65JZv+Ozcc77lXHRL0AbuKY2sFksBvCnM5TaDOq9A+rB?=
 =?us-ascii?Q?vybCrvgSQ3i4mo0AZYK9yhqqmE2vGDPeu/91DLjFq5tAeyzl2V3Y+yiBUu7c?=
 =?us-ascii?Q?Z4cQBKChTEObzz6Bhrf7AQrqMkpRylZPw2Fv7qFOuc2b5SgVafy4fw1Gvcql?=
 =?us-ascii?Q?Mn2OeYhYnCokinw7YK5wVkQhwdRoVFskrx3Nt2nGIgvqeEG8isW0l8ZyDTKm?=
 =?us-ascii?Q?sA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yK17RAAJ9s0/TznkLcK+KVT9OCSTH81SXiZ+brpV+gOlrmJL4+2GRqeRCb8IAd/C2BCykMURPZHp95JferqYNxifiJFNG+JqMngIRZzv2QFxQGBjTPKSBvky0RVQ9yOKU4R9YK8mNzyvr7v6PLsR55pZUcmFdxOZkp470lK/45cZM0oTM9NN0p2VnPc6sFwelUYNszGavu/aYRD2dRFmPlaFKamPe/fSAhv/l7J7qrbRtVeDnWsIX8MJPPv/nqTNWuDNi7KybagZ8+B+uG+ZRwO+G2EdC29C+djsbdUft9TT06+oHbC9ldu9SH7/3cOG/lRW9SkojPnFtM84LK4lCeumKgujkinDt6NPWk3R7CKHojnmnUTClDXrSm0UeQCmlaPqocB0RqFHX+vIXSCK99IhDD0GudwxTo6edYNAVOAh3Wchf4gyXsGYTmFBxh/tHPi5LGmfmHu5a8Q72A3YUwHBqiTHfbF6Fj9+kuRqJC5IaivtealRfwSM/oYQqNMWXgxgfHvn6LLvYyK15Bq3n1jMglQDNYFNoEXpL+dy3OTce6bBpVUtD38WRvKg6XExuL4gHXL+aCD9ivVwb14KUZgQ/gNVApALGv0Wrkt+8sg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 234ad01e-d2a2-4eb0-2f39-08ddb27936e6
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2025 17:13:04.2839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MpG9RAa9ijfZC6E7ZRlflSi2+qXOEireuPcqbPExp3CLDO25F9/lW6tjSKdBcroDkO+aZeT7oaeLs6ysYtxUakN0Jw7EhdLzyx15DMLWrqk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6175
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-23_04,2025-06-23_07,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0 mlxlogscore=796
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506230105
X-Authority-Analysis: v=2.4 cv=IcWHWXqa c=1 sm=1 tr=0 ts=68598b24 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=cewXuGIsSzsw8c2jRYwA:9 cc=ntf awl=host:14714
X-Proofpoint-ORIG-GUID: q-HrEIfcPakz3JkXTKrVoIRyVHlpeIZj
X-Proofpoint-GUID: q-HrEIfcPakz3JkXTKrVoIRyVHlpeIZj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjIzMDEwNSBTYWx0ZWRfX/0wboPX17Evk uBKHSK/rSkzfZ1VXMLahAD/vWrZGGc5iU+o9T2b27HZ6X5UiltY2rPYgao5LmxJUFI4ET00HMgy G/t/8AFBnEFfiE8tZ99iDX7jl/bjHQnUrTg0JoXkbRDcOf71f2rEeSoAYCZuZBJNb5QXlc0IhkO
 RmxtktavAuuG4REkN/Tb52hAiKRGcFYewHK1HaLHJD09NNbJx/os5fucNznue57IVnIAHxsUbOe 19Xs42rWtJWXBbHYst5ZMiToWBX7JicLtoh7Ons4GYVNt5tBc3a6Rbf8r9vKzWC2wK7DpI0+4Ek F+/nvxHPHFGDSZsPZzhoA9PT+pOpIKIIqotP4A5XQDgDvH8X08/fMKhr+r3DQWWrdTVoFAfsnJP
 6tM9VVG3DD7D+THLAghQ1kdpWLaYUREtmniyuIMVbv8lJKUZmcdNkQ7bIz6zV8e3KD5bp/Mz


Justin,

> Update lpfc to revision 14.4.0.10
>
> This patch set contains bug fixes related to diagnostic log messaging,
> driver initialization and removal, updates to mailbox command
> handling, and string modifications for obsolete adapter model
> descriptions.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
