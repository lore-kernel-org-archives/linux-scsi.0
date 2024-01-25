Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37AED6127
	for <linux-scsi@vger.kernel.org>; Thu, 25 Jan 2024 02:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706148909; cv=fail; b=bFRd97EE854fj5ojaslJuPHN/OWuV19cwWkjXH8EA9mpQQaXwrvqCEOIKZ2vwWZbKQPWkCri5c0CXLEFRF6Efo7ObDiM/59y+qKrnOUbM2/rA8qOwy9iQO68iRljfywIK8ucWt5kzzH+ijA62aknmWcUne/yktch3pyCukb/zsw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706148909; c=relaxed/simple;
	bh=FfyGsaQ8R9njUTteMYu5OgmjZQPL1G9hAftr6t2r5Vc=;
	h=To:Cc:Subject:From:Message-ID:References:Date:In-Reply-To:
	 Content-Type:MIME-Version; b=qdswl5wz/n9hdQlLN/4AzFwS1ScsdHAFYGyZIoFB3gq7wSHCM06FplDsfioPSK6K1BQNZJGcsXzqtzOmDEDF8M2MZNplCddA8eDo3d9qnikMu51r6KNkUsSpopCyZnTx0w6tE4P7RNkUo7fQx+MZdHr6kJ8ftnib0tgC5vTPv58=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fgDVfLY1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kV99e30P; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fgDVfLY1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kV99e30P"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40OLc5ll008145;
	Thu, 25 Jan 2024 02:14:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=+YbcrGLTeUGDvA7JalSfo05nNETrmA6EMHOWuwA/dOU=;
 b=fgDVfLY143sz2ZbIdwjeoXvIir37AIOzzch+ofHs5GJS6/gIwDyr4hODWNentn9GiowR
 Fs8wW+VK2EoIZJF6cUjII27XemVSL7tvN4B/lXzwtRgrSvG0zwlbhUPvZ6B9QyjKXHLz
 vGMB+iUTZ/2Bdyl4vfc+Pl0W4raZKv8IoYSqfpxZrUZ5mw8HJkZ12uP0urT9DZgikOWR
 NeTb2//k7jcG3j24GF6ly26Q/6MBdKm57mFzdkOntFzhkbp9IWEAOQt3E/NzqbhB+zFf
 cDh++QQZF6jDZfPOH/SXs7KlS7nyQCzQM5CbOFBlf7AO659B8OX8UU6vpfSNDPPPa6fT rQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vr7cy5d93-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Jan 2024 02:14:53 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40P24Liu030795;
	Thu, 25 Jan 2024 02:14:52 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2041.outbound.protection.outlook.com [104.47.56.41])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vs3744epm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Jan 2024 02:14:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gbgYRg9Mv07StL1uE7pKOncpFSJJaRHlMgDHeVEz4yb1cviL52v3K+FIB4vNsc3g37p6jVqyyZTLzTR8K9CEmfwhNFkm3nRrXWDmwZg1+2rAToCgcLIkwRrAtTtoqVbB83bqGjoZfWXlvuZOT8JIAotYWAm1kyWeblYXXZ/vwiqYQn20hFaoS63uQp837QBdPHgy8PssmszFjJjF0lQxhcZmgqTbX+flYT+Z97TCOw372+nS6lSdgsPLTqWJFBhF8G4yAeCSAmW4rX0lrbAKKZWkHlc01WuKD8C4g5DOog2F2vrbhzZN6PAZmNj4MjzlONlhacBMrVJ4OQEAIRC4EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+YbcrGLTeUGDvA7JalSfo05nNETrmA6EMHOWuwA/dOU=;
 b=f5graw6cZQ+kAkDAY40YZqN/qxro+qnVdGA3KQKdwyWjKFUMctPovsXf6TyPrdeuh8Mx0L3ZcwPBLafc7wcA3ClgjyYFwjBNhm6hbMyp9NnwJ6yoGvVeaMyAgDB5FOfHx7YrZFg+4vAszEfSB2QYYlji6WUrJHlEJTTRWWnKyNSDwTyHJB88+bTHIHg8Bpcyoga/s0hKZiZ0//TjBJSweAiJCB94hYmmGm737tq+bZkeeuezHKvj29SDbxUW1qZofabjL4mIk1MWBG7/NKOTM20Lei6vMYgm9uxjnSNfKVZ8jynsPzXndNyUTmE4ZSH3JWQng4a1vhYZxaIIfcJwYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+YbcrGLTeUGDvA7JalSfo05nNETrmA6EMHOWuwA/dOU=;
 b=kV99e30P8B8iA42nRENzU/3aVwj+Bq87hHnaoJPEX1XgqrdTq3q5ndE1AXhDFfb0W9lQhlNvNDjxafCkdiCHK0bju0fPP2vukNlaOQGwoQX1LSPifDGriGZxixaw42tNtQ7+6UatEVERE47x0E3rt/lCYp+HmXSAtTSbl+F/sME=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY8PR10MB6850.namprd10.prod.outlook.com (2603:10b6:930:9e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Thu, 25 Jan
 2024 02:14:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::3676:ea76:7966:1654]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::3676:ea76:7966:1654%4]) with mapi id 15.20.7228.023; Thu, 25 Jan 2024
 02:14:49 +0000
To: chenxiang <chenxiang66@hisilicon.com>
Cc: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>
Subject: Re: [PATCH 0/4] scsi: hisi_sas: Minor fixes and cleanups
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15xziw44y.fsf@ca-mkp.ca.oracle.com>
References: <1705904747-62186-1-git-send-email-chenxiang66@hisilicon.com>
Date: Wed, 24 Jan 2024 21:14:48 -0500
In-Reply-To: <1705904747-62186-1-git-send-email-chenxiang66@hisilicon.com>
	(chenxiang's message of "Mon, 22 Jan 2024 14:25:43 +0800")
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0128.namprd02.prod.outlook.com
 (2603:10b6:208:35::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CY8PR10MB6850:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b232d3d-a75d-4553-8917-08dc1d4b68c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	FWnfwPI0v7FRh0ZkW+Ti72CEHHnQ1bcJFPAmDdZuJa96RV6mBhAmTY2ErVLLYS1b6DGjwRUE/HHIWVaKFJVbEfkAD3AQGoyOGngVBp4aYUqijxx5zzTlE5pYSyLFYAhCll46/rYVW9n3tEdxzY7K9NXtg5cNLY9lwZzmNTIsceo2fPy+JH7jry6CQ17OL22kKCjmz3Am/WnHzUOK7ubNyFCXuNEpzgzou6EO0l6oUjieLYnhvzkQXOkoG3fW0zFGRigHlHka6cfN1FZXsQpOuItbepYH65WTzdwBwm4Bw4IUwqyq7UDQ7o7KDFJGRiI6q8J+bZBXpA6jQNQz/cMv3rXF1/8GUCv5TlJG/0crMJgIuziDPUjOYAIjoXSP06fOhSipOkossE3+jpADPdGFOc4B8fS3GA8ZjuuvS2AXZTwnjAFZPb4zCCZ1kxXISWVn8q0y1amAuMD8sH73MOOj7FcIYrBxnggSCmBHYaitTG3cRyaf7CRgJ8k6bxiy4yyyX0cr92A5JdkE4wll/wIsfOfZ8kwm71K+YPbh/ZQy/spB4l59rtHznPugyYbmtkyP
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(346002)(136003)(366004)(396003)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(83380400001)(8936002)(4326008)(8676002)(38100700002)(86362001)(41300700001)(4744005)(2906002)(66476007)(5660300002)(6916009)(66556008)(66946007)(54906003)(316002)(6512007)(36916002)(6486002)(478600001)(6506007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?bxVdijbYaeW8Zm18tBQY1aNmFDyq7C2hzfPJ5Oe8n3LnA9cpJ8eUJiaegC+A?=
 =?us-ascii?Q?lt9wxMuLLpbo7bQ24HjP5mxuZ+TwkNA1aArYcqWPTcMrOrRpwFliL219ky7y?=
 =?us-ascii?Q?kKKQ84ghh6unplScG/BmaKOgyNC99WkB7i8xqhyot9ynZ/I6OHsN2hGBhtUP?=
 =?us-ascii?Q?x3Fyjjmo6klSr1jQwoaEB4ROZrUucoYzEZBL9gID2Sult6o3mRLtQ4OmRcdA?=
 =?us-ascii?Q?wKi1E/2wxQzR/hxXWzBra4MRES/ve3n2bHf6xajZFL/skQCdj7McdqUIRv1i?=
 =?us-ascii?Q?B/bHXLiARzqkGCPpzaZRymYWLqQUvsBSI7RTG3THRkU4GG099YvGIBcZwMNn?=
 =?us-ascii?Q?/s2ezmJnHHZozTzVyd720cJJ8Num5u0+e470+BSYarwg/Z2HEXuziuYJSDVl?=
 =?us-ascii?Q?ws63m0Sr8eZehfLV0y3sH7bzzEm3C83spsys5GyORSFbI7sgJxYLHOR5VFMR?=
 =?us-ascii?Q?gIznfU3/tGvko6OgQpmf7olOFhICvQIUpB10KWzY/pPp0IMpgjO4OvGd3JlM?=
 =?us-ascii?Q?HH0vPkdGXPSIhe5v6Zp1ReDxit7AL3TcNIq5LJUXJZ/AkNCH57jKCpd4hxZp?=
 =?us-ascii?Q?mhiw7ssNMceekAh9rAzK3zPuldtMO6ezp6eQfO33Lgz+RJMCYlL0p4FIDFYS?=
 =?us-ascii?Q?GrCOrDh56gwZcKLWVsUQpz0MxvGp2zYbcWNyhPxamEvN2hY42DLSCQR4i0Vq?=
 =?us-ascii?Q?lPQtL5xhIHNqj/tCZZvMzb0IazdkX/Tgp817gY8y4R9IIIQbDKa2Tfwz50Fh?=
 =?us-ascii?Q?hgNKimIjgi/FIWxBxomtfTgE53Oy/AGhLi15Vne59PgcalajWPDlfcAx4MjZ?=
 =?us-ascii?Q?i5tM3BlsqsG8FafrXhwsOSFykQjGeH3/NTlJigeqOYJstMbLqvoSD+2Ds3f8?=
 =?us-ascii?Q?ZmCyuDX2HWSH2MFWVxLAt+FHRN+Oa01LJrsHxq7ThxTi3RqUCRbL/T/42lyt?=
 =?us-ascii?Q?CQQkSbvKkKBLlaOz/dFWAPlfF449CAFaW4O1fvJIRxbd8Voo7NhUX8gTkoN+?=
 =?us-ascii?Q?P1e7GXJjZrYQlLloW2DZpo5qLN/b0WUJbDGQQWRwpeXOJlzeQEXo3kwIxFJd?=
 =?us-ascii?Q?k+YyOKLuZtmkpv59o1fNf4FJrJCo1lKbAeuUMxK9fufJIjIKsSCLv7RPJ9Rd?=
 =?us-ascii?Q?40okBoDsETkL160jAuIjEGK/rGJ1uu1p0R14eA3KC4TTcZIXmVHBco6cLuhn?=
 =?us-ascii?Q?GbtuIjVRxEgPfbWWErMl8qENM2D0PN20PaTmmfcoLjPeRBeNDwu5e+sFHA3g?=
 =?us-ascii?Q?PG7XQClJTxb6GdcA7YPYzqVky6FfNX03aHf7pm6Vy0zLs+eb8a2D9QEqhFTi?=
 =?us-ascii?Q?CY9wJp1kVQxL+l8PXo6cc2DSQQ3Ojs89j5MzfUkIc1yciISRGJyfMcolBuVX?=
 =?us-ascii?Q?77as9KZPhL+V8Nexei+pmkL7hVeOzc6OCzDAaa2or9OQnmGoNxxFMQnCjeMz?=
 =?us-ascii?Q?ARObL654E0yH10YJQvSRCdMl31NARaRHdi/bV3g5zCanP7DEbHHXGNQryy0I?=
 =?us-ascii?Q?kNdC5g2hSYjOYGUcetaw1Jo8xH4Aa6xjaQu+S82fcvrGXeFvuYJR7tlyqV0m?=
 =?us-ascii?Q?+U/H1bLHmitfe2wmVKjAimo0Fgi8M1Yxrg5krUhp02oC4f+PRFXnl5ICpw4B?=
 =?us-ascii?Q?nw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	FrITQEGmcUlliA8nmmcLcH6GgecjUD44TGDH1rkhEpFRebq0Yp3U7xtRnJ+S9SWAPdZfi4iFUUMwje+ThXOGurM34qbGcaKzjKkOgB5iU0jtlSc86t7beIsg3L7D6FHNxRPDU/THUztKlwlA/stlgm8OtXbXHpJpwipznFFB8Ut/gSLjzRdhsaqa2s30WyEm/ffSWVg7c9DY3Apu5T583iFM0qJPgaipxtjRw2F2o3RA/iw2KcgcnGjw3HiFoFPF3BbRLsro7sjqCZvgIWiqsFBDu0Wm5aOQOw42SI9ZSZdHChDPI00D5C8vp9g/XIWWBAcw5G6K3NHsVUWVAOOdpXa/4mGURQPkIlswvaqLAatbC86vDJilY8EipfN/lQMAX7blLNR69ZQ5yeqGh1sv7yKzuwsnfOwA6HpKWSe/rlXmM/xtajSFi3D9T1z6nV5xPxphrMFE9nc7cYQod5o912JZSmU5UAgiLzmrlniX2ZD5G3gAvdtis0nA1Ts6Oh5bWGAeQTcUTnfLwyejNBF6HmH+90Vt1PAaWRpEBXAu54d8g0gBH6NIyBICD7CnXhMV2Hlhs73zqpWVbRe1hbqn0tbtuajD5IOEFkPU85a9m4c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b232d3d-a75d-4553-8917-08dc1d4b68c9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2024 02:14:49.8567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 73a8isiQCh3czh+km82Vq1ENNBBYlT2N/V6DtOMI1W+FNYKx45UqgNIV+UC/2dAHwNYBi/P7lISLp/dHXKcjPLiseX7cTHreEhsx0lyrkgE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6850
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-24_12,2024-01-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=834
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401250015
X-Proofpoint-ORIG-GUID: r9-jjDChSWbv99enHiyN7vKZxoMAOJix
X-Proofpoint-GUID: r9-jjDChSWbv99enHiyN7vKZxoMAOJix


> This series contains some fixes and cleanups including:
> - Fix a deadlock issue related to automatic debugfs;
> - Remove redundant checks for automatic debugfs;
> - Check whether debugfs is enabled before removing or releasing it;
> - Remove hisi_hba->timer for v3 hw;

Applied to 6.9/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
