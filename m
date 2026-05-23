Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAEEC1A9FAF
	for <linux-scsi@vger.kernel.org>; Sat, 23 May 2026 01:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779500028; cv=fail; b=c16LfhhDtYS2b1hEOsWgMH+NCFeXY61yVEHUt1SYVU3Y6x6+5RvXWLUpWa9jxPTVvYT9VPuueBV7Kvoz35d+dfHN/3eJzfu5wdSNYodYVJyGUMCt2XhzbdgxjoT8947sSPzoMm8ul02UVaaEDV503CDfaWy1KEYIL2rc9D2qrs0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779500028; c=relaxed/simple;
	bh=RX7H4+fpPgKfhExkVDlYTIqaIs4JsvKqHGx9FS5Jg04=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=UsX3y4QFuR0wMIZrE4sdV6t+OhMrocPzTS4TgeqYEhgPjanPiYOuIVaQ7MLD5uAtJJKW21vZCfRKFlKsMPGIWeKxNiPunGA+tk4cXZPoFgp7ElKGrBJEoMicTPvY0j85qEen8H7oS+8V83MLLfG64AIKzgmn+SP2Hn2saOegLfw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UiwvOuYJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RnkpHNuu; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UiwvOuYJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RnkpHNuu"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64MNGPK71531598;
	Sat, 23 May 2026 01:33:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=FqTHfM6gZmCfPQvaow
	+DzyI7JsJ8u5jZTYmlYrqNJ2Q=; b=UiwvOuYJzwAMeIxq2eo4XuhYEs8q0Mzh6x
	UeXOQ5LswXoya7bNShoO33N+gADuOGeOkYe0eowswGa/uv2eONfO/PeFWhzrtQ7Z
	w010W/sI0JMqjYIizZDu5flGR8gSh0fLSTotvYjRb0Rc+pQeP2edr8qcXtMZtk3D
	2OO5grqntOcxrT7SvXreyaqn8ntStOAeOJpJLhSBCimaGyIoA4EC5w/HZTiqD3bH
	hBYRri/WbHdxbReTdrLbSot9+h8Fpl4qx1We/VGzkZ3bkfzngjyZJaLAiQN7DeTv
	bF6Kwo87tWwCYporBUQdsde2yyvZV3Q/NxCAFeSwyrZKINuCrn8w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e6h2cuy4q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 01:33:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64N1XW0w006785;
	Sat, 23 May 2026 01:33:39 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010071.outbound.protection.outlook.com [40.93.198.71])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4eb2p6r01g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 01:33:39 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rxkr2jTBqpMXCMD85SF/MixU4K5/rp1DU8lso/hKzGLqU3Jd2ISmVjmzc5VnCEg7h5DQRUQtTEJFcArvJTddnouYx6Pi+QbVOHYRGy5MARp/y3a/pGJ5tG7ATE0xkohF6Ds2BEWRidjh1SZLHzjY4iFW7aZOPEOD3WhbjVDzovi8xwykmkAcIZ7Iy7dpgpl/mVH//gs366vNhUvdbYqcdJLMwhsXCC/uWK0BCuF08jlt/vFrgSMr/INOOvHV7+AG9QP7aMCNwCzHS7wMKh+5gEcg5jd4ijMfozlOFwO4gvLAI7PkN+Zk/F8yfBpsmikMwDYgPbeFVkDCn54mzl2ptw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FqTHfM6gZmCfPQvaow+DzyI7JsJ8u5jZTYmlYrqNJ2Q=;
 b=S4vVlQXy/Z4/CZePbrzlm0dfIYoDO2yK5TlnBaV/77SnXCks2q+aqXoyXw5nhACAGYzTi7Rdtcs+otGCgyG4rZdlEVqpEKTGNWNwAY7DKbRmVvCiHVbGP7JWwf7xZgNWB5+VuuVXuJzP0SckoVeMWEXvERZrVFxCHPaQWxi5wnmDDTiFvZ9MPTvHLF9iVGeekOyb48N5s1eU+r7sjWVls7nAIz7zp2767sXlYtDaeSbVM07colZWy4Cstus5LLs2VzWscXHQc0nuo+mVHT0VWLjJOMqGYfbNfgWXuqnKDQyV2VAsHh/ejf2vrZz0Of/TLQZagU8AoE4qQPfJrUpGgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FqTHfM6gZmCfPQvaow+DzyI7JsJ8u5jZTYmlYrqNJ2Q=;
 b=RnkpHNuuROV3q4vULnFWSDC4lOGhotNN1E+FwBnmPOR2IQpbcHSZKDDe8w1SmwjrJ+aFd4U7kA9p8irrS5zjrKxuQMmde6Z5ftOw6tjpqbV5AiniPOnyNyX6gv/bZgNmDoLRaeqcLIQTyPBEeQcQtL4WJh08rSXALIyhYrCzGdk=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MW4PR10MB6396.namprd10.prod.outlook.com (2603:10b6:303:1e9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Sat, 23 May
 2026 01:32:22 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0048.016; Sat, 23 May 2026
 01:32:21 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        Nathan Chancellor
 <nathan@kernel.org>
Subject: Re: [PATCH v2] scsi_debug: Remove the set-but-not-used variable
 "sdebug_any_injecting_opt"
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260520171454.4035623-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Wed, 20 May 2026 10:14:53 -0700")
Organization: Oracle Corporation
Message-ID: <yq1qzn2hpx0.fsf@ca-mkp.ca.oracle.com>
References: <20260520171454.4035623-1-bvanassche@acm.org>
Date: Fri, 22 May 2026 21:32:19 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0024.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:85::21) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MW4PR10MB6396:EE_
X-MS-Office365-Filtering-Correlation-Id: b3cbeec9-9b5c-454d-99b0-08deb86b22a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|18002099003|56012099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	X18j0j0l5K9OZmcAnPtOjS/z9nuS2ri9DyMfYFtogqZmwfrMv6TGv23fPle9Ih1sDxzykOb/aWVXTKuY+p4CrCzn56wXmGC2uyi1Lx1DLpeBpRIbc1fdHj+g0Bvam7tYksDafPRfsWqar0sdHKktpNqBpKNbOTFoG5zNuY9gr94s1xlHig1TTPwQBVCrkZbFoxoNd0YAPZdH2znxXnHHSiT+lNFszvA1cqFnX9UJQl+Apy/XRrwsC7A/hGluPl9mBnZId9G/3Z1VqTbd84CKg5OOpm9hx3D9fqRuN6t20YBK0Au3DdMdFm6qkOgFqDJyiDYflUxHorkUtu1telb9dMh+Fngf3G+qMQPzZAqhI0vbzZ0Ip1U0ASA5ivQ7LIc4c2gLz9AAPmo9U385bF2AiWhhdcvUjDcvaOawB+wW9YsFwujkvPdCblHdYdSSTz0/AOUAmz5ophBW/cxWJm47CUjmB6FvShsuvdYUZn0eCu+g0u7DebD/+d1sedP/5lVtT1OSEHxqN9EJjwQRDKhxzc5vOTtwXfG3shFlYKYBPf4pVwYObAYkjrMzTs6jKR6fkw8inX5IfgnVTBHvgOxyWuVudyysBmydo8Km9ryZ1P90YE7F1P0cJXcFRtiRsgmQN9RldGq59191eAhCRYrlPncgreu9Vql/+/KW9keNjyURG9FGjSCttWG+EBwhITXy
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(18002099003)(56012099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3dvFRRewrRliTJOAasTFecq17n7gfMdZRQxP52VaAYw1meCTjZHh1U89Vntl?=
 =?us-ascii?Q?KfxRzNmCcQV4/SysHr/zdDIJFTHTBzr0n2nshvITgx1R1ctmImysJrcE+2mo?=
 =?us-ascii?Q?ZZ24Tz0SPhww5ChUIhjs1gUnxGjpCEFca0XWNClB2+uyF/T6w4F78ZNSbLc/?=
 =?us-ascii?Q?2w9igPVClxUpWry1eaMtHQxEHLrwK8VVIhVXh7r1O75FH+8Ha1dW/P/DUFyV?=
 =?us-ascii?Q?mH/WLmHmOYNDSNGaacKNh6MGDZmJ+7J+mMutBo8NcuoPFyyD1sGsi5RrKG3T?=
 =?us-ascii?Q?a4ejKN8cgZUKqKuf5U9/wB/1eenBvGlQyDnE9trgDzvr6X1kDfdqnsujQ7TW?=
 =?us-ascii?Q?e5kJ8baNCufV6aN6K2Tgs8yvrNhkvSlFJe/WNKKLSIbhgPm1or5xmTuJ5nf1?=
 =?us-ascii?Q?kDnv4TOla015FahygGgVrGCZntxqCAIkdsZY0M2ohKnHS4ff3Kqjfwj7XH0s?=
 =?us-ascii?Q?XBGtdb+C/bH3vribAJ4ZX+GZ4ul7Y6o924rfrQOthnWLKYaiWKEEQ8JJdSol?=
 =?us-ascii?Q?48yUs8CfExN2LuKQ9BsD26nFTfxHcFJp7CZHgIUH7MSvlQa3ru1vZHh4EOhE?=
 =?us-ascii?Q?BdBMNiD7sapcposv9fB6HmaiD4kINl++oaAHWLFyrYA7zTekXEeMFmx5MKWh?=
 =?us-ascii?Q?V0kQ8hQqLv99Zo2PrMKfmhq3HX90uBqpqM85zmD7XtdLRb5G2ytKRHNpsBKa?=
 =?us-ascii?Q?RG4/OkI1IBL1vx6XtnZtkZtguksF5oxMiuotqBJ90CpKj7q1vQG4M6ZR+4Z9?=
 =?us-ascii?Q?etYBO4ETL9G1bs8ZVUpgQyjUla7Y9MoBJaWHo+ASzmhagHRkC3Y5mxZ4e1Yq?=
 =?us-ascii?Q?pSxHLg+aUejZgLeRgB/QiSoKVA5jDZ7Bxj6+0AZmxj2046AgkAsz5j39aRsI?=
 =?us-ascii?Q?p4ak8pHhc/FAp7g0yt/udlJmpRAnBvX5f6zrJqmi65hFcEyOmEdtrjCtILIS?=
 =?us-ascii?Q?/HQ6PISB67IyzSwqhs71IQH48E8i7WJpxdQA0VcCx6bdORucug+Q3ud8mth/?=
 =?us-ascii?Q?s/XvNfKxTTLF25R4C5JAuNXG1Q7FGgvVNYFATjomFSCsa9jTCpB31tdvpcK3?=
 =?us-ascii?Q?AYgJM7Q7OLPGpICzt+BJQYcN1BDutPo+Cb81CqRcDdVfbyfm0HQRdfLYyn0X?=
 =?us-ascii?Q?evmuWyVHYW8KKF/ER/oA17gftmJHuJRrlw2FnHqE2ADgKJgzzciT0LBb92LF?=
 =?us-ascii?Q?7ackiJPow97OxnxZJOo/hx7RDZjj3SjZDyXspQDuBGzmQwNF8iS6zpDIpwNI?=
 =?us-ascii?Q?gnSBhz9rkVuGjrNg96OrfRISsrz3J8gqk4qd0SVjrR3Okc8rKZQiRy7zPUAT?=
 =?us-ascii?Q?deXrb9Nj7GP3ofwbTJ2GRYqiXVM3alYwwVBA8fuPk4qVN6IRBPUtRfqxBnwa?=
 =?us-ascii?Q?M+vreO7DSCd9qJ9ftRKll7sEF86Kj7zKHa+HzPohuxMd4VLCDz9kJtejexWe?=
 =?us-ascii?Q?7EGH7AQJ/T41zoSmz4yUeVSoMTmXQOe0LyJJsfjA8PH+86OXRMYF7U9I84jQ?=
 =?us-ascii?Q?cjtSRa+cW4ZUT14DYgcUZ1gn0fkiFcXGaDl0owyJpFI6J5k3CqSroS66R/kK?=
 =?us-ascii?Q?32qqMJSVccECKY+dmTHMDLKhf9gkAXS+CWeTDLtlooWRW1wqALwGaGVIFiDk?=
 =?us-ascii?Q?ZkZsj2ehsaPFsgwmUH1h5yuQik391mvgOMWinUGHToTz21m3OggQX+nJEYSr?=
 =?us-ascii?Q?a2ZqdojeGo/ZfGrKnwknDNpuy5I4BWK2g8grbq5bPSFa0IpBwK96nL/S0UnD?=
 =?us-ascii?Q?5ajs0yfEVmvaT14esLg5xMuUqA8yvaw=3D?=
X-Exchange-RoutingPolicyChecked:
	FkP4Y59PW5TTP9PAGG/Mergsgb+xGingalyZE1tQghSqoMzNrQNDeyxPbmi6Vu+UqW9kXLd6ENM4M3KVIpJN+AsYBZ03aVhUkfgQrnuLAITP7eqBVFWDCf+d6fmnT1qDxHOX+y2bof+wWqzpJLO+7vryEyPaUsqpfrKw4JhpcBW+6xqgaOkrk/dghy+OzRLUH3UMKgs7eC0JNybPK1yHM9V/7YJY+gEp/VhkIzkXcYUaYe9Y1gTZY8b+dJwTAdC4LKbW4349tTw8ZMimLU7mIjnkplP1AIia5FevtQI+GvGpscDEtOj1Ca8kcuRtarOOkw3g6zuog5UA0GVvaHC3BQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YyQmsNLM5nom4QlTWJ3O8y7w6RIj3S9opeerrHOrgBpXE3g3QxP7m711WmryWomvMiDxbXXLm3pOD74madBNrcIUfn6u0db7kef8AtaFpToxvlpQwms8Qi0D2tGY9URzJ9HsHv3cwZo1Hox6dRaWAgfz16eCJQx8wbXumcws41HyDtQvv5hlwCeG1CQAei8mDEuO0QXgxWxdIEbHWWGv8dXwfkqzGHYZkyeHWZt1NjvMCI8q9emAScA8AMeupQLD2cMJlgGd5ViCM2Eh3YrrsRx60/TE61t9aGGj+BlOnMfJnBUjTBga4T+jXVuG/EeF3O3rnKEn1KiOifMDRorb7HdgiK8Hy8Rg3KwTf1bYnVTOP6E7eN+PIY4z6MoFdx07Tcbi40EmPAaprwqnsH6cBcfjTGmzUH0Wac+/AhuyaFjFCTicPb9BNhh+pDKheotN4sMrL2mle48zv001Ro6bkSGnowHQJZ5fkBcqv9fuyM/4qZNjfCNIfpdDVew7CX4F9tybPYoV8F/Om8QXmpO6HSFRvmMIjR7t5vog3PByc/6tqaN0Bi1ypEXDuCGgHEYLbo9LB48OP4j4WGDEQuzsUzkn88Q3q98+KNR8L5E0dyo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3cbeec9-9b5c-454d-99b0-08deb86b22a9
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2026 01:32:21.7331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bDjioaUTzMivuzxGMA0Z4/GXqaV5amjXFtg639Zze2zSZiaL4qK/L3fKgXiacdijV4q7boaZrSeHv2uKxyI/fG6WSLgQ/sdTmuNmyDqJts0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6396
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-23_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2605230012
X-Proofpoint-ORIG-GUID: P5w7GLxQNyXDMEceK9TpVeh-OFgKAgtE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIzMDAxMyBTYWx0ZWRfX1rJcqHXz+QS5
 lBYHm7GaXNd/JdKOb7f0XTBb9u2zlb16oATy3c/FWQQlAuR5B9JF5yLRz11pUatUZXniafGu+tF
 YAf8BKiGKZ1uYm4+I8b0/qaqQyrlYKWBw0LpR0CE+P+TVZ0vYpQRgN31j1YAfAYmJmEQro7ej6E
 3B99wl4DSOFQEq+FXAeLa9xWrGUKGPyxuJhurjHISvH9vPBB95Zj0T34sEwK+AwKJEZaZfOHFAw
 UgW1j35ScQLh7l9IbiCE++c2v5ikpmEewXnxSB9lguViTtzRodk0FPm5LyVaPTpd+jwkMItRvZx
 ZN9hK3xFy6nmA/cfkKtAtGj9QvAhWztnOzyMzyTg5N9afCqQepgzSu9qf4mEoI4d1JAwXTBySNB
 126zq+RPIicuUf57j+MnSQCD9JeooZE1rBw4UVu9zV5X9r/c02vhH+Rj7i0hRKSKXoJurdZHAFq
 wrRyrB9Q/n3AVDL76sw==
X-Authority-Analysis: v=2.4 cv=Ws4b99fv c=1 sm=1 tr=0 ts=6a1103f4 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=NGcC8JguVDcA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=6fRf2IhVbGy3MCQ_BqMA:9
X-Proofpoint-GUID: P5w7GLxQNyXDMEceK9TpVeh-OFgKAgtE


Bart,

> The static variable sdebug_any_injecting_opt is no longer read. Commit
> 3a90a63d02b8 ("scsi: scsi_debug: every_nth triggered error injection")
> removed all code that reads this variable. Hence, also remove this
> variable itself. Remove SDEBUG_OPT_ALL_INJECTING because there is no
> code left that uses this constant if sdebug_any_injecting_opt is
> removed. This has been detected by building the scsi_debug driver with
> the git HEAD version of Clang and with W=1.

Applied to 7.2/scsi-staging, thanks!

-- 
Martin K. Petersen
