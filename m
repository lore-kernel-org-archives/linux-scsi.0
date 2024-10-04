Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CEDC8C13;
	Fri,  4 Oct 2024 01:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728007086; cv=fail; b=oIRubMK04LcB9mWkbsPhwZIKAkS9gDMtzzuWHhFTiR6ym36CFslfcNMO1D+TOy/7mH13anAbHu2H9tpLT6SP0aJmrQ8HSvNWhhYZKlWV+5ILOJKKD6Ea9mH/99Yq9ruPPh5qa+H377YEC6Ay6D8lwVipufuLQnIlTBk7PRYV4fY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728007086; c=relaxed/simple;
	bh=c8KzwdZkwCshiJcpPgcka3lTjr9vCY4o6dBnSTZfp8s=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=YTcWqqe1s8/EUKvtQNMrogJjDQ0k0RI0Cn8ajQs1GOrRnB9VqwP7X6B1tkS5ffjzeDvCvS3qQrHUqZ4i+koXujX4ou7WR9SRJW6JwwTSjsmia1H8v6ur3eWIC4ESQQMQYA0EU0tiKazDi+uJhyPxJTLQ0J4pmJQc00uvrkxMVE8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UDLmDenD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EVezM5JU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UDLmDenD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EVezM5JU"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4940tcwR018285;
	Fri, 4 Oct 2024 01:57:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=jpQHadKDibaQ13
	LnUirKNXure/irsH9Vuchvr3n6vPQ=; b=UDLmDenD28qX2JMnfFbMZvTJce8EEu
	5sMVAKVrwNBrBnEqCi/Dml6f453p+HFCuFkoPEZJZsa42K5ecXaPyG/fhlDJiLdD
	xWK/QAGH1YWDN7qf2Y6v+3Kn/fDPXnp4JBf0Ypq9YkhEPNprqOI5mtdESegh6U08
	94vth4ePwfNXDrrSnbO+2lFXgbxlG4e6pwspWkNg8/CR0OAiu32ykrs26PF4Nie4
	Tg/hVsRvwk37stJcBP8LMdW8xrrXBNUeDCrp/L57KFXCJ/IuOG8Wwi+EflTpETxJ
	dF2coAGiUwm3GUZtcL39AUsuibYwpsYW8jfhb5T1QNwroIoV2S/3MhPg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4220488pff-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Oct 2024 01:57:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4940528h026478;
	Fri, 4 Oct 2024 01:57:59 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42205567ap-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Oct 2024 01:57:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CbGqBSr003FUzSZBFl3u5AKzfYl6gx86We664wud2IH1+M13c8dKaAEPra8O921o8HncOjPt+xMcOhjJJbD8UamGv7KiqIbYERd/J4DQS2K+choNUZ8/NUl+j9krbTmQ5QK6rKQ709aN1r8p4SWXwhvhbIrXxaXQOk5m+hshRkds62Bp6tqGfhwDaFG8emCUoQEAVo934wsUqMm2A137ZbsPXmgVKOdoUCEGjBdyMqF8kMAxUDOanOJ/oWtN4yi2XycquOWhrcupvQfx68GERXR4b95Yvk8hQO4gnB58w+1/jnYI3CkTTbG4KokyvovztjKYBAngkC1p6l35kj895w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jpQHadKDibaQ13LnUirKNXure/irsH9Vuchvr3n6vPQ=;
 b=jXUuz0xdYgPiBB4eaU0xkb0FezrKM7syq8unMaxH9a/RZ+c/bXAuBeCVUK2kXhKlLWbUhFpOXPkEJurGMljb7fsSlB2mKgvdroaI1Y4tU8/AQSFEnYsVOO6Y58Ik3FV+Zq1xEc1/D/RJF2izCwrvNbNFIBZONs/llf6wVT4m2t6YP6HhxI7VVmQe74zIsVc/K7k3jo+expVp8xJqWbYYPYkDgSl+5GHkEDIt3h0Grkmvv2olCFMuLobXOlYN2XCgh7jtiN71SRyUUSg6XMC2sC6VKHmv/Sl1hgVc1GRyHWfoIcukxBlpXoPLIFCK5IqcnEQdQAvV8EOypqENYFNdWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jpQHadKDibaQ13LnUirKNXure/irsH9Vuchvr3n6vPQ=;
 b=EVezM5JUxKAQdgiIq9x5r/YCe4MB2vAgDOokL+LvSeQwqLnGAwz2mMp1ckJhInrHI/CiS5VQWi5xYyQq4bHet/NBujd9OwNymUbgLmeCahT9CARJ9QS/0cyYnWSqKdJw0ECFavhD0d6/ynLrXefQW5u+T+BrrASudeZOAQyRnbY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB4265.namprd10.prod.outlook.com (2603:10b6:5:217::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Fri, 4 Oct
 2024 01:57:57 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.8026.017; Fri, 4 Oct 2024
 01:57:57 +0000
To: Avri Altman <avri.altman@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van
 Assche <bvanassche@acm.org>
Subject: Re: [PATCH v4] scsi: ufs: Zero utp_upiu_req at the beginning of
 each command
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240921062306.56019-1-avri.altman@wdc.com> (Avri Altman's
	message of "Sat, 21 Sep 2024 09:23:06 +0300")
Organization: Oracle Corporation
Message-ID: <yq134lc3a0n.fsf@ca-mkp.ca.oracle.com>
References: <20240921062306.56019-1-avri.altman@wdc.com>
Date: Thu, 03 Oct 2024 21:57:55 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0002.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DM6PR10MB4265:EE_
X-MS-Office365-Filtering-Correlation-Id: cdb3e5db-a47a-41b9-0bfe-08dce417f795
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JYFKxeGP/a0pTEcl9S34Bg5UPnU6Tr5b5/g1N2sW4zMz4wXe69dsKs5wZkXf?=
 =?us-ascii?Q?9Wk02npoSnU42OoqUEEH05BPpiBjnum6YLHpLW4O9pkCduFZ2T1Lqmk5768V?=
 =?us-ascii?Q?LWt+g4MRuR5u0GZJ6OXZXpvL+5tY3N3VxDdfUAvpNNmMSQDJs+R7KKEn8Y2w?=
 =?us-ascii?Q?ljOnd65u4WJ5sPn2N+asIQX0jE2mxSHzQkXIrnTOtVxGwZZdNNAuhF/j/xPy?=
 =?us-ascii?Q?SLKIfRQ2GLQpYdw5G5MPPZMlED99NVv/RumaHBpI8C6NUdV+pefDYcb6yvH8?=
 =?us-ascii?Q?VUcfqH/0kTNZZpr+1zaopc9KbUbuqub8Wx7R+NNWUZeopYBmCDPm2+x9cJUg?=
 =?us-ascii?Q?/qS2TbxT3K5HUEG7UYOperT4NbBHmYB4ObjaJEBcJ9JnApmrXZ1rzkU9cUeG?=
 =?us-ascii?Q?uKTftv20CmTF60gzodU+cnN40QKP0pMRYwZEV8zgK5BRhnUPKrKIdg0eyLCs?=
 =?us-ascii?Q?+C5PnB2bSCh0X/rx9CEYxVoStFX32n89mPVTQOJmU8/wCo+DEnsGu/ZIKkM7?=
 =?us-ascii?Q?0uFdIQ5J8hyqxWmxUoGcpai2gfwgl0z7K4a4NH1Mc0KHp7mbhco+D7LwpqUL?=
 =?us-ascii?Q?5rF/Tg3yPrtD9cR51uA3oor8UbHTleXLgIyH9y4egk4JTs4WWosyXgsbM9jD?=
 =?us-ascii?Q?stUcdgENbFXz/CRVUkXfRQvySCC5WmEvNo5+eEs3g9kRuTgKfjGAyZFK6TSb?=
 =?us-ascii?Q?fgPddmUuUAa/tkJhIthnrgZZ2OZJP5xDJ2UapXqL6kKNWTdRW610Z0H2y0Rm?=
 =?us-ascii?Q?/J2YaeBSCO5I3zBBClJzeDKE0MCC9j1OsiugycX+KKsXPKHf03sOtM9I0del?=
 =?us-ascii?Q?+XvDXOEbW9uYFhl0I5bb/98EyErDrbxk3AlkME4zhNyUAHxpe0pCvaiSQB02?=
 =?us-ascii?Q?GirBbdPPU+q3PWlUFpYNECp/ZfRRmwsyWgWcZ/ZEwBKI+PgxL2663D0gpgTI?=
 =?us-ascii?Q?+XeMETw2GWmWnUboQPttM0e++i3eI3gME9MUt7B1DkcKNNYUk5zdjCVEhes5?=
 =?us-ascii?Q?XJ4pTgzyyY1GTe9aUIiHb5C8R+RZeoyNKZA/0iHTpA7yedNwBIWJTe7MtM5i?=
 =?us-ascii?Q?/0SaDv9HXIw5XvAttlKyZwrrH5eo56ajlMBucN/5PwUuOvVi5Iqd+gk2UKPu?=
 =?us-ascii?Q?SnMaE3veJTJTKUQ9B6YTV3LB3sJf3HT6v2HirnRSqrZKhmET4RDBs5D6vpCX?=
 =?us-ascii?Q?p29gClbQNjJKXyIepmmuvNN88juuriMV5fpByW7MLDWCrfO40XAJDbgPfwUw?=
 =?us-ascii?Q?I/hxGEoCR+cwPo9vr+5XZcGJ4/oWUXmGcJDMJ8uv7Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SslT7bchwZM/Mql6eV7YWQ4EgZ1JPYyYtNwISvFcLRmRahfJydDQOZsezIuY?=
 =?us-ascii?Q?D4zgVprv0PFD21SDypUZAYcLIRthTpHTFwUdibxsI3qhHm6IsjW8zURz5jFz?=
 =?us-ascii?Q?W777oo0qkAH7ZbB8BgiE9CuMnYyDPdgPMpFUFHqn3BoVELgq31z5IdOIul3k?=
 =?us-ascii?Q?+tiGn9FzWSeubT/+gYd5dDw2lnwcQ9HCPvk0CJPDQUfsoc+Qe92yBLwazZ9X?=
 =?us-ascii?Q?FrPm98vuR3f4zG0V8bIQ+elVKDr92Z2d1X0OsHOD/3g0LtOZlRAyak94zrJw?=
 =?us-ascii?Q?Fwenod54ExFEUDs0qzOwdzDLgvRykCvDklGwYuHN+Bg06qGc2jSLnOBubMeT?=
 =?us-ascii?Q?MJp+uXNbXqJs0EU8TiIfRfe37hyaYUZBpQ0GQ65TNeKJBKEN0+UjS27owZXB?=
 =?us-ascii?Q?aXQFvegclvnEzR4EzUkrVNxdKzWMN+Ov5RND2xYsL9CprDNsGnLmpofs7OmS?=
 =?us-ascii?Q?0DJ6zXRYeRZuC2D7QdLC0V0hHXFKT7XUzOHlzea1bDTiNPpTroH3nQmCCYri?=
 =?us-ascii?Q?QhWZH4OdtHAQaZYCE8vPezQhIVCRO2QoC5cyfAJqqdS/qU5oh2Z3KSQLhp1X?=
 =?us-ascii?Q?gx7V4FaT23CUfAYPEhuJTWv92rGStJrV+GWGBmgblRmYdc9KWglMeEAkzMjc?=
 =?us-ascii?Q?rIcnvWfBXvBr5mbfo5ANRIHxuXUYOYNzZiixCeqo5tb1aP/HpIn9WFfMLRvS?=
 =?us-ascii?Q?X2u5Px11mzp/kmDhT0wGolkr9qEidqzPyVOUV9FagzV4m8A7uJu947g1P+R9?=
 =?us-ascii?Q?x8Be6sL8EFJ3gBoTqyqg2r+hA4jgcuxhkwAl5mzgk7b/pRMd7t2GJzLgrzhq?=
 =?us-ascii?Q?YLN7cFchMPbbGv92PXRkVNWSKc6/Wryn6cC0ZRO1h06CDfZuEfhDbFjJVBCk?=
 =?us-ascii?Q?MA85Ah0sFq6kaULRVrTqqJN6QSU9GP/wal/8bhMmt3W/Nh+vYPC3BlZJTwoW?=
 =?us-ascii?Q?sIDFK6xeaY5DMUM0sX59m0elLm/yJ5fQsXoltCvWWQp0OEZm89tt5h9A4fJR?=
 =?us-ascii?Q?9S1hNuB+9QgmXJQ2Q5Ne38dNYdx8htHMJ8RY6b+vD6kKq4vPyOVJhdIl0Dr1?=
 =?us-ascii?Q?bQ3E1TiB65UlmT08jWwCWt6PiHm8RUy/bILegOA8xs1nPv6gDXf/7lQSNRF7?=
 =?us-ascii?Q?IWwHlLfeACB7PZtISY2lshM3yCl/JPIe1PqDhUvx+cWNCB9MkP4yz3VrkaYA?=
 =?us-ascii?Q?cr1LA7YJABITTFPiL5PfHFfCBrfp4OpZkX+tm+GIpIuhW/h4rfmqd49P1Bao?=
 =?us-ascii?Q?iIwFUgs4yOYiOlCnvMjvfkcc/dAEfOfmFomTUrl8s32C30SwTZFhj0aD+qTI?=
 =?us-ascii?Q?ZbkBwMyeAOl+rYUbLnDGnpu89R7f93olHfJyGstUjihnpgGVfnzdMO3I+7kw?=
 =?us-ascii?Q?uFh3S9FS/0X6I4JzsJwvA/LVHQvcwYq7RZ+L7PPIBfobch4ckyQgonQU42+K?=
 =?us-ascii?Q?C543Hx2IgLT93bwar9xZKCuDTh6boct0cxH/5PuRibCDF5Af0u2J+Ry4C+5T?=
 =?us-ascii?Q?CVZlTh6b3Y0vqBrTzTGqOAe9Mtxlu4q0cgMW/gsdkEmjrrIroneDl4j5I4wd?=
 =?us-ascii?Q?H2Ppjj8224YjEslv0JCSjdhAOXe6K4cxrUqNkYBKhqOMwu5w9Eky5RghkRvr?=
 =?us-ascii?Q?lg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OMWyXXq3NSabugVqdgYfWnDHKvhf3MGrkJlu2FwTE39rSI4rJviIL+DYWm/vIF04IFCMQPT6YeEM8GYRZLnlTRtIvQuee2s7hXMrmX1PwRJtMyLOwVMaAZpCvTIwnCEBj1/M83vvcqdB3KfWnPGC+UzyrK2Eakz2DL7wz+EEX4nwiz18z9DRrtCvqIhvNPQbgPvAv6YxjSSyCAeZJKHCBlijkX5l5ovRJyGKRP3RUwGMNW0Egn0sFDzI5xp7qX6Z1Bjc15o6MZdXbnEX7NXdiezEyT01OWaFhelWmI5M+p2U8MkOwZotcM2ZjOfSalUj78vBMLEdFqBmXL4+2tAIX8pqbOTUhz5HiSo7NVjdAIYF1PJ2CjMsFoSvE3REXN3zSjJEsB8a5MrG2F5uyFwDqaTAcQxUxORYSsAcU6OJmfYBjgtUXglI+ClEuew+tfPIr5Yx4ZWFuNUdVgFTnpX6XOe2Wr/8vKHy6R4J+Nwoa35Xb/W5O1jw5X1xWo5TWu1vbfRklarHzbh+DM9HYt25EC5u43GY7CysrgEyxj+R45ydBvGBTJDgztJqAg+pJ970mZ6g2lyDbUrzxE06jBrLD0p2UmIR/xB654kfpj5oyjo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdb3e5db-a47a-41b9-0bfe-08dce417f795
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2024 01:57:57.0371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h56IJoWevutS4IhklanMLrjggqL7BSa3aOklV9aN/+GDzKPLyu8+fYTB4SYHa1imACWIeISeuwg4yohjK5+/T9VhFLL/uXFa5LWpnCaRp6M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4265
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-04_01,2024-10-03_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 mlxlogscore=562 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410040012
X-Proofpoint-ORIG-GUID: Gt68B83hNT62HLj__nqUmUiXD1Je2rkQ
X-Proofpoint-GUID: Gt68B83hNT62HLj__nqUmUiXD1Je2rkQ


Avri,

> This patch introduces a previously missing step: zeroing the
> `utp_upiu_req` structure at the beginning of each upiu transaction.
> This ensures that the upiu request fields are properly initialized,
> preventing potential issues caused by residual data from previous
> commands.
>
> While at it, re-use some of the common initializations for query and
> command upiu.

Applied to 6.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
