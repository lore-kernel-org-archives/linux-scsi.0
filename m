Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EEFC10F7
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 00:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726188083; cv=fail; b=hbvzvB/D07wnwt4qPVfWsP7cVvNI516z8853yNQ7UFgJA9f01rTo1H+CJZyZ1jke3uYz6wnWrdaU5kIr5640b+XUNus6dYl77rkEGrLk9zojz/DgU6ZnikXJeC3tp4JuxCh8V+e2uQsF6AGtxNN0QelMan6QfSxkpeYLH1zAiZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726188083; c=relaxed/simple;
	bh=3eKx/dPaxxAfBg5xGtBXLV/uakx/ll6mOHGojtcIr0I=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=bgTzOjTUglrvlV/e4lpLunAX81tz/N4nJlQ6zT6YSXQ4BM5ggjlNa6ksiCHFxnKoccasV3UyhgSxbIVyMZlHDVGGBx+LuohXqf1EoM5RlFhUk6Ig4pDDFR8ohie3EMEr6A+d/ved/KAxIB3v0bXZA6gGC/aWsgCMk5IPVZOUPk8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=f+ehV05R; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MJHQbuBm; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f+ehV05R";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MJHQbuBm"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMC8Oi028124;
	Fri, 13 Sep 2024 00:41:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=IP8dYCIhVeag2F
	EYzsYebX4h5aUoGAeMppXiiaB/32A=; b=f+ehV05RB2Rel0hGjgKBJ66zJO4hs/
	2XcSmjk+BzCPwTag4b/1ECt46mSwagtCXZO5EUqVfbj+CHu3/MAduhVyETXKJd28
	gOEnwRwBebv6rGzLCAAsxLyCni+nkdtt6Rw2ZKEv3WsARRhLP97h+MiUXgeFqXVO
	yg5geg+IaBfX7wdT5EFk99zB3XNCDqlJBfTy9dA5gz7ruELbvDLPkrNP5APEnx3q
	zRZZtus8kvrUEI05UZj/R0eKdvUQ+7j2Hw/nk9+6wuAZFUSudSLbJNr0KCF/CEik
	JP3L5rlGAKsyh6u6Uw4uctUiPiSgB4QenzvC2QBBMA1dARKU0ldrp+zw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gdm2v9eq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:41:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48CN0edC031602;
	Fri, 13 Sep 2024 00:41:11 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9cft6j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:41:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LsfY+56GG+8ZEAPDninuNMCx8W8x+Zj9CxYIoZoSzJzjeJmy+zHH4lKyeyM4uHX0UU2x/IQGUFBY8jNrhuErYsDLKZw4LGGTHxqnh1crYaHIFWWkGNlnPiG4igRrBsiN9q2Zld1Q8OXVVwWnhksZYQBYxgGXezDqADynLbfJeIqOyQq4gScwCpmt4bL/woLx2e8NdOWClU5dFk5YWiZVP+k/vi2IHmDFPfcPstpuppuS2SYNxE8+DqDoTcEz06U+4uHwUI7uudx7eb8CFG1lcX/JM8TZC1QDHwkbSguv/f5+2jD+3tuN14Z88SJ6LhMvxhztJj6G28XPduO8Ldug1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IP8dYCIhVeag2FEYzsYebX4h5aUoGAeMppXiiaB/32A=;
 b=TiYZZGVq7GjtmIKkwYtH9dMrT2t5jQOBEUzV/fOIKHDyQ+sXrZ/ggI8ZpTmLJ4FGBzALRWfAVkF7jA5sM6bbhaWCmxCAauDKEuabE/7E7Mw1QiRNqykrjRTvHTYOwBsHHMVA9wMzZ0fOoZEQLCyUPC5/BHjBimp1/UKqIIbxJVNfwMtTO1WEtqPitUPTP5Pjhqv5fPy4xvBQ+6okABzNxYlywqkdPog+MVrFrVY7clLjj9B5sGjU9YhHicUs/3Ngn9NHDfyeTpwXQr2EV6ecVEnl4MKhKQ4dRDSrRNwFY9zItiVKnzgE4CbdmuwcZcTYmfCIxFDHvifFx0tXgIwk3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IP8dYCIhVeag2FEYzsYebX4h5aUoGAeMppXiiaB/32A=;
 b=MJHQbuBm+cis78JftICmOGkNtS8M34c2mUvl9+yAkHnRcnTOL7jv4eIkLAERtupMzUuemqpklh3HMiX3DJZEwvcXStSZwyLRtz6Egl4do7CNsc+8nQDdRJYYkSM3kY9uCbx8xzoU4ahf07WscWt11neXrnsAEKVPCUDk4gyUJY4=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN0PR10MB4821.namprd10.prod.outlook.com (2603:10b6:408:125::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.8; Fri, 13 Sep
 2024 00:41:08 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.7962.016; Fri, 13 Sep 2024
 00:41:08 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
        Mike
 Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v3] sd: Retry START STOP UNIT commands
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240904210304.2947789-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Wed, 4 Sep 2024 14:03:04 -0700")
Organization: Oracle Corporation
Message-ID: <yq1ttekwflo.fsf@ca-mkp.ca.oracle.com>
References: <20240904210304.2947789-1-bvanassche@acm.org>
Date: Thu, 12 Sep 2024 20:41:05 -0400
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0063.prod.exchangelabs.com (2603:10b6:a03:94::40)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BN0PR10MB4821:EE_
X-MS-Office365-Filtering-Correlation-Id: b8bc3cf9-90db-4da2-ac5c-08dcd38cc1ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?P9lBm5ly2VfKRAg7LA6Dpqjfs+Vlcr/H2O67LbQlJaKezjjpcDlGja1LQJop?=
 =?us-ascii?Q?USftuLV5aE5srGUvpxjXNGi09MMK45yBWlPMuCBo7vY269ARrVC82D4K1uMz?=
 =?us-ascii?Q?X5wz6AYmLn8WxdPj07Tt06l3Unjmo46IZKHIjqkhNYST6JxxN0AGZLTtIwNf?=
 =?us-ascii?Q?ufCq3FtUJeeJHcNyrJgJ33kvGoUboasLI+NNKrW8Xh2Z9VSm1zC3lPB6dxiL?=
 =?us-ascii?Q?TjZmN446DErcyeS1dr4fzsjGXp6rvGIXbMIlIzV+TcwWNCHJNx26uSMwaNFs?=
 =?us-ascii?Q?70XezJV8XLH6an8ezI9vpk8DbDWig+PnGoG+kfhQfylt11xVszGKYADhFnJ9?=
 =?us-ascii?Q?lzpTlDdW39jQ3tKzW0TaOyFsv9qFnkA50M9GQjpsRcneykFYvRaztZu+GzLE?=
 =?us-ascii?Q?Xe8mLKxYNBz808lMHx/gwxlbFcz7benGl9bIQyr2QdElvM2Byw34O7Q9to8h?=
 =?us-ascii?Q?ndWmiQI+Imai3732fRE3bp/GgmMIp6DJXEEDVldE4Ih+OrO0otmO8vmRoMbt?=
 =?us-ascii?Q?DVeCjMCY9saaFqM2sZ7tPyV1YkTHgjBL+fL2TxIL8rIC/7YWkGXiFRvhH9Fa?=
 =?us-ascii?Q?eAskVewBebz22L8p98zpeROCxHdTnHhk1Aw5tGukhkyOdkL5ADxPUYAz4AmK?=
 =?us-ascii?Q?ZJF/oRxyWjLcpwftTQ21jvMR4zaDcHIJOlZQxqm+aNy3zuE4URRq0yjvdFNs?=
 =?us-ascii?Q?7yYZqyB3BO0AjsljjszEvn9Qwe8PxjRnwgiHsiLARxDMJCbPvILddaiiVpeY?=
 =?us-ascii?Q?y4gS783aZIrzXJ64Rm/zdxCunzU4nnscdkCVPABKz6AjpIfC8LD7Jl2qwr6O?=
 =?us-ascii?Q?kkIV4LQ7lYTrpy2GSID+DyvuDSQw0oToTdNkSXMy5/8arfFxRnA5VlPLYiBa?=
 =?us-ascii?Q?HUv+j+jhwS8S/lDMsSH2aLxaSnxi70mmC1JKSYGqHrdnpxxckcElK3te0vQU?=
 =?us-ascii?Q?RLX1TtwbpcBVXjsap0cGFKvHXkDEb5fYRyFzcbWG1r5D98LlRxuO1Ej99ud4?=
 =?us-ascii?Q?kQmTJrt1X/mCQ/MMtjYn542/GGNDbMrgXNwne73oHQrDDHrxbI5zmUafGwpc?=
 =?us-ascii?Q?tIMqaeHPhVMib2m54O/nLzkUe+KslYLo3ZetUYmN6JbnCZ+kkAqsbWSYZ1c4?=
 =?us-ascii?Q?IQZb43dQ+kckYIe1r0Rd/mIOxOJlYiSiDdipDkfgVaJ8pMbCMVCdNXfYAHSd?=
 =?us-ascii?Q?qzz5ax7vZGuvDlodeatRSsczX+LG5eaRssFuNgD1hKhzvj2syCVm3Y1ERChO?=
 =?us-ascii?Q?OnS5cfLJD7NDFH0Brigm1KOjTo3Ps7GBzM2sM9zmjxdrG8JK10gr7SY0lXMn?=
 =?us-ascii?Q?n+pjj+bs2LKuYiuLtvE0W4bA/7Y9lFoZeUHDkIk/q7t5Aw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WiY2BAN71zzr1VgkCA0tNEMAVScHK/HHCkHyKt79BSCwPKOLQc/z0VKfUUmX?=
 =?us-ascii?Q?AJ98gLiitRlE/EWjjekgg5nNByiK6RIyAzJeWEfOYgeTEJ4lbfmvdhC+6JFe?=
 =?us-ascii?Q?17o2WQpMBFgJTql0aXK5bEsN3j+v/mDeF5y1VpiVHTSs3B59jGFo9uAXhWm1?=
 =?us-ascii?Q?UPgNLdeJNZU+aZCQSBsZBJKCHlOrWgFr8yTUlxJkg/eWPsHdI9o1bdXFKl8d?=
 =?us-ascii?Q?7G6saM2w59cxEXqfcPyzyZPs/Ax5fg7FNhyKV0Nk8KgtxPhGEp1tkZN12Vfi?=
 =?us-ascii?Q?mLFkvHw1/b23ApzO2kyu8KKztO9271BT5YRRsvf97seD8f4vNmibP7qcDwgi?=
 =?us-ascii?Q?kO+QxxnVyt3DYLhoQ9Vu8Oh1Edi1A1xb3TqmVb/TyEB56qzqMnoQ7tlRR0f/?=
 =?us-ascii?Q?zlQngRcCCtOp+xncZSwjW3ByWBABQRZqQFSRWibxYGGsJ93Pu2dKpTUkhMOW?=
 =?us-ascii?Q?1xpaHmoA+wRzLFNoYMY9h2OkNMvTfJxM5BYWFLcTrnu1HxZQwwBvQ613H6Pv?=
 =?us-ascii?Q?Fg4SR8bDihRReKLFWTiz6sakGa+ZvceD2ea5nrT5Uqpgk9jmpsQhJc67kj+A?=
 =?us-ascii?Q?bDk8IK0z34dnHnUVCOsDs9Pskx8bKzoriPpMLPAuuj8H1nZTeHZhzgjr0iFT?=
 =?us-ascii?Q?5GDoebseO0QHRfq2n1+l8xyAslLEGWBUOTc4HC2VH3yA5nz6rNBl7/blvCFb?=
 =?us-ascii?Q?F1uvJDdDUS+nYdbdp9nxf1ytUUpH3d/rIsohQP2+5NUhsoQSoYOCLqYjRvnn?=
 =?us-ascii?Q?/Q/s4X+tdngIW6+NbWKUoVOurIKt4+y02GUGNTm5JwMSTiap+DsvaS4UVHlz?=
 =?us-ascii?Q?kperbXL4gQ878mY+IemhlmFz8fLTYsVGh0vMaWpbpqnxqdm2QFjBTGe4Rh8b?=
 =?us-ascii?Q?lmPrXB8+ImNJt6X25gPm85XhDa5MTdPDqqeS/90iktMk/xscg1jpnytcR6YH?=
 =?us-ascii?Q?cHZv5LAFkr7eYJdlRa/jttAcNT/QEUsx59xPnTzaoCIFKchMkVrUoT1Vl8yE?=
 =?us-ascii?Q?LSoVlK6F5NuhLiBBA+2Gr0gpq8ZOCzmOBwcXCE3XbFKtYEPARsEmqVoZTHRs?=
 =?us-ascii?Q?cQ5jbXcZ4fjCIR06EIZ2cQ9kRIF3YTiDk46LpfyiLgXuz2m+fS+HbTEMs/ep?=
 =?us-ascii?Q?kCY63ADCDyrRiaewpW7jpH9tQcdMjLyAyCkuIwwSMUVjXSfK6wSRca0iQSbI?=
 =?us-ascii?Q?EYZORAz4zgkXsN7AOQSvpDa1bl6PDmZiZASzFT+bHvzXaT3KD0n1kID7u20n?=
 =?us-ascii?Q?0e57LJUy5dC78tV/Uj16iMDnMWDZkSE9VVi7PTc9oRdBZbCQ2BiGeDD7GNnE?=
 =?us-ascii?Q?AOXCxaNoh1wZqjhcm6FdGjbQfeZ3NyRIR5yQsDnDWTDRXAHqCjzlXH6oc9iv?=
 =?us-ascii?Q?W87uW/FRMogL3Krw7ga+/g+tSgTYyewPjQFRJ/9AWCqNSQUwP5YR7arwDxUU?=
 =?us-ascii?Q?vk6B3q2ss28bUQhUO128pPZC17D394Vqk+ZH84IKFgTt8DlGkg69rYgrp+oQ?=
 =?us-ascii?Q?D9y2f9RWYy3HiLFTqAhCRO2HFc3uV62tbzD494abnspwSc4thz3V/NdHaRXE?=
 =?us-ascii?Q?ftdbSLGNnUS00XM5V9/qKg7+5mI5w15tBXzPcsbhglx2a0JYotv6u4zTFmzZ?=
 =?us-ascii?Q?qg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	l03hpmoLVKdQRqDJQJRspI+5rNh/14pwxgUBiUwG2cWslGL2bm78QKhVfO43WSVh9F+qzJlkv2Jdh3zZwoT9rWtXmI+bVaL1hp7QnU72RNCCu4pZkndK4Oba/kT8+WQ47KB1HrSg7Z5H57gtPY3F1Ix1CdWjv6lqSfR+pNDH6xvyqMOtmpAeWbzPMuTfKa9hjLL97l3YGnurQxkDgoOpeIjPvHYgAwI498SVjes92G+pPQdH5N4Owcl6zH+5IBPiDW2m8NEs7GMFyTymYshP/fr6p4BAs/tm7Bw94CuR+Ze0+6E9JNCMq0yjsykIde/5OiN/g3Cpw07+CWxfA0PE1WtlRYdCyXVUZEvbKB1JGt4BdD6GPq4GE4in/GzdbQ30dy5i3tIviNK6NCnB7iFMJ4VOeJ7BMv16V59AjX4R5vioBsE9VhGqoNd14XJusFpmUS8lLjE6qSHpDw6Mr7H4Hi+2OIIhiFH+53PBXCxo8SeOZ1Eg28xIUwsfZvpBkQNSRPFKzE+2xwN4kA/z26D9hd+Xrq4uQgfCOC2U1ezXgCaECcqZFaLvxWrH3IjNCmF2i0AwRM3dbVvoqxcKrh//GaaBLYx+WHo0H1qsjCQ681Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8bc3cf9-90db-4da2-ac5c-08dcd38cc1ac
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 00:41:07.9458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +mD4e7AANxiJ6Shj+SBCRpdKAn0uuzt6SoGv78vZsahU2m0MSbXMIru/ezEl3B3Vm96hZvf8xJueqxMj3fzOJGOEJ3vMoEZ07NPJfv4jMUs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4821
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_10,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=871 bulkscore=0
 suspectscore=0 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409130002
X-Proofpoint-GUID: syXz_q3zmaZZhazyCS616X7PrD48VL9l
X-Proofpoint-ORIG-GUID: syXz_q3zmaZZhazyCS616X7PrD48VL9l


Bart,

> During system resume, sd_start_stop_device() submits a START STOP UNIT
> command to the SCSI device that is being resumed. That command is not
> retried in case of a unit attention and hence may fail. An example:

Thanks for making this change! Applied to 6.12/scsi-staging.

-- 
Martin K. Petersen	Oracle Linux Engineering
