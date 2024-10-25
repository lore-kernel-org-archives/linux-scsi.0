Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440E3167296
	for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2024 19:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729882927; cv=fail; b=ayboixKOWmE3MtvX8KWOmNAWqx1v+bNFIgY4V0fnhdg9UJgd3cW+CAHmrRXMEoTfdX6AiEQnhC/1ppKqLarnRebttqEGTWHsCMJzjzrdumb2eosMhyooHj92qQD3rpt1QtkM2dowmhGDXbc5YRgpaDfyqb4QiUOujBPE3v/Dvjo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729882927; c=relaxed/simple;
	bh=fptnYoCTXimdIYqkkXcUU24nfhgQtEsl68hovYC1sAE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Up07PP6uZuXXfmvzUYjWnV8D20hO8Xa2An3rB4fMfnSUEUdJXIiPhAGH/NrqVYmz+alfVnfOomdub3/hhlZypnAtEn9ybxJq2j4lzTdQKcwjj8lBSZHrAFCUbAMCrAtDXNHpUl2UlIV9aUbqdUjYsdoSU6dLrJmhF31n29GA8Ho=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=T6nnnav7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XBL5u73J; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T6nnnav7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XBL5u73J"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49PG0ZXX017119;
	Fri, 25 Oct 2024 19:01:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=jPRdfzwhaiZ2+q0r14
	zDroMFE8FGs9bIvS7sAy8XXyY=; b=T6nnnav71EyuaVp/Qk1NT1UGFo7nDJGJ4B
	dCE+igBPSgLh0eg7ZTfI6o5IXM4EBgqHYxbz9UAwq+279cSVaKIUTUsMMhx5bGmq
	yOV2cWREKrBLms8hnMBgWP/hprfoSfkqi9mtTNZh+4hDd5aknlWAsos3+YjXOZIY
	04QAuSgCUH9i7FGmXjd65Df0ecijwhSka/ZyWyUhMgJp1+sLiL1evtbpyDx/MGu9
	wyU7EKaSn93Wx9O6aOgPAfrmk0k7w6M1EOEsY55sxtC7LUkiqaDECvuqk5m85xoA
	o/yAAbZueLpqZnEOGCk+zqO6jUWgdwx7fTbZyAZKT0oVCC0x60wA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42c55enj5n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Oct 2024 19:01:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49PHjvZJ008983;
	Fri, 25 Oct 2024 19:01:50 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2045.outbound.protection.outlook.com [104.47.55.45])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42g36av99w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Oct 2024 19:01:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CF48z/jqdme+iZq0lUSvGpuxtRq9YxmMLxUKDkk4iPhpFksJGdgWJ58vS2tUhb8dMR8fRJUWSxaEF7XndKDYLcemdbBUWlbwDgZXhwNVioMa3nVQR6R/1JHFTCgFCIPXoBQzy+jo7KDY1HUrjtMAXVUjGMbFCkkRH5ZrMg844Re7eGpsylZDWYdPv0iyuu4FazQjxLMFQJLJnpzPiYlsD/ygYeql038LkCel0av+Q6bgD7d0xgGTqkn40ymkT7UnABCr36ILDVV2On2Pk1ZWmE7lSMFuz9cGtAaMwX0mbREGwKcbi8bieyXoXE6tZOd8BCLqIoB4SHhx9OPbsDOtEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jPRdfzwhaiZ2+q0r14zDroMFE8FGs9bIvS7sAy8XXyY=;
 b=KWFne04+ZJHOT50pGxdvk7TVtiEoGQS+vjrhk0GFDg7mNRvkBv641sNsUOPmJxYi3mNOvfkyNpfzah+Gwo+VwwVfN+lHTrl9vV2iP/BPAl04L6SoKnnbzs7wV9INSPXE9X50iYvAyIUBQePLGtf0fR8AMf/tp2iFcLOAotVaNTKrUfq8WdByMpo9EvK3kjGi9ugnULR5Uza5BGH/SDAZJx1I8133+B1Oalr8eHgJO9SkAO5H/KKsmScAuo7o6xkfKZb2fDvt5q3RZNo9ahh5EBcErIhJyt0ItdqRR1lDGAL9Tmou+Kwo0U4yYM4SnSQCK9mm1QH/PlHo8LRo9f9VbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jPRdfzwhaiZ2+q0r14zDroMFE8FGs9bIvS7sAy8XXyY=;
 b=XBL5u73JAC4sdcLZChmtx3/GWqYki7CKFnGIQNHG5AZiEiN8HVf+9OzJ6RZrqs30lUMCduSaoFoJPpN4RE1knOiq1Ks8KfFEVRxoVbJdVTmtcu/ytWwVrERHYdKFH6940omOp4gPBhPgsLhuVxzgUbNzvpF8BYDzsPbQzQ67BJQ=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by DM6PR10MB4186.namprd10.prod.outlook.com (2603:10b6:5:218::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.17; Fri, 25 Oct
 2024 19:01:47 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%5]) with mapi id 15.20.8069.018; Fri, 25 Oct 2024
 19:01:47 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/6] UFS driver fixes and cleanups
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241022193130.2733293-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Tue, 22 Oct 2024 12:30:56 -0700")
Organization: Oracle Corporation
Message-ID: <yq1y12cdn27.fsf@ca-mkp.ca.oracle.com>
References: <20241022193130.2733293-1-bvanassche@acm.org>
Date: Fri, 25 Oct 2024 15:01:46 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0027.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::32) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|DM6PR10MB4186:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f0d58e3-1f74-4ae7-1cb0-08dcf52779e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PB+ZtlYSEKZC13N+DB4DGKnVFBR408CavAKDSHgU+/f8rYw5eO6VoxK9nQ5z?=
 =?us-ascii?Q?8rvtghhhvKnRB7npYVacGnKwAjWSkiuX8uDH6ZENzV5FEQ6i6a05MYIavjDo?=
 =?us-ascii?Q?9A6C50bAyDK+1i6S+bwuzmZ/7xVX3n/kfcAabgEiPtugQh2xCzX9qwB/omfo?=
 =?us-ascii?Q?1EZvIrMzf3/dBSMJzDp9zVbJ3xbPKCInASJzvaWIjGUOEJT8nFNSVESvuDUY?=
 =?us-ascii?Q?QMtIh1V0G3Za8P0w/gfKQz+KIlHz89oA9e0hKMyPba0d49mwiXVq2sXfcHJb?=
 =?us-ascii?Q?fv11bT+1mHiF72ZD5+mttHS8oQkv3JPTJBkErfJD96XCJWefI6jMDuQDcTud?=
 =?us-ascii?Q?4gX6QKJGJtO/Fr2KGDnLp9ljWepxk19CZC78njjSl1YdfSyUIkRMyOttXLY6?=
 =?us-ascii?Q?C/es6MkGbyiwCrqUVezS1YgGIYAqIBbpvRjRgWKQTvjgrnT2WRo0SmYjTUpC?=
 =?us-ascii?Q?nutqdj7Pp8kPAo75oMAUUvAMzpsFWKmB1IoVl1rOGI64YpO48XSlCD4F6FHM?=
 =?us-ascii?Q?Zy1dZYGRzhhxsquLGjgsN1Mfb5v4UD/8F1WxDXpWgaEoQzEMjArfmDVXLFjM?=
 =?us-ascii?Q?bXDAskTHrT4H4obTLhOx+wevpk5bdmvEWvmYyjs1Flv9UQ27oz9XGMBb9eRo?=
 =?us-ascii?Q?CoN0MmoTma8aMur/DovBdD5szHgb7xJ6TG3DY6eA6lq5bDY54xfzVGhLymVI?=
 =?us-ascii?Q?MjbfqGDG7LkQnxlGtf/X6kzJrbsXzGqeAfxGtKqJbJy71YqUlRilLRTbcS4t?=
 =?us-ascii?Q?GjfdION1cAwANxqoNjjW2gzp7oPwi9dLNYqXxRRafAN5Ci6OoMAK2CvFnGp2?=
 =?us-ascii?Q?N+cpdhBEBaZoC8LxLZuncoDXDq46kCmyLFO/K841N14nFBhUhAuMLJvtInzH?=
 =?us-ascii?Q?7LKXUX/0RE8C7zYGnP9Vv4DqS+qP69WCJR9O8L/ESIjhzxcYPVCkuAm0vBBt?=
 =?us-ascii?Q?HiVmYsjs0VElZMtBvZXb84fG88DTUzau+rK70rO7TxW/rXsCLlixi3Ix8Yuk?=
 =?us-ascii?Q?kayZjv9Kblx76nViJvpcBTAkr3k8vyDz1Cp5Osl+TcojYb01X6YrlV3j5cY9?=
 =?us-ascii?Q?+/C/LicroL7Muf94tuWccqmIfE5UK0dG6VKwjllb/H7UCi8rBPl7gqv3WgRh?=
 =?us-ascii?Q?mVBl2OnrlyZ3chrqC8je1BeGy8bmzC1SVY41shhOpZEtXjzAjoy5EpmE9mjA?=
 =?us-ascii?Q?vKBTFx6uw54a0Fc3M+qDA5VD1EJnTuo1mYg8LxuPZDEO+HbTFHcDlYpXgldZ?=
 =?us-ascii?Q?oZG+5Vymha/+wNmKcUykbWjTuu2JH1ElyAStUP4hkpb5tWA9HC0BUvxC4QzO?=
 =?us-ascii?Q?S/Gm+aTHFrsqTwleuEtR0X5J?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CNvDSnnpbKjw5M8opATIWnZm63pbmbQ0MVLNrBIWD5nhVtbb1c6c/2S8Lm4P?=
 =?us-ascii?Q?kc+D3fqb/9NFF/DaBdvPWJwHOHl8j1Twkk0HJKuCESf2URisb6ClNZbLyXOH?=
 =?us-ascii?Q?cDA5jFhEvKYhiaTEpLjQhj1A0jKyYUg6hZXQUNGvkIbFW3fPMdwngegexTAh?=
 =?us-ascii?Q?JhOLhIdw0ZHjnL/hDv18etnjlJzQOuLDlFl1QnsEvH7tCwynWtHgyjt7C4RU?=
 =?us-ascii?Q?PBn0045l5ASwxrzMHZyCelqQJZ9UGfLnUumMGKCzA3G/ATVAJ0ZS7w7ZtvtZ?=
 =?us-ascii?Q?dTKpQuBj3NQiYGBOHYJIE7Gu6NEEn1mosp8vIR4Lk6NOCeMlW8M0ezlOnt70?=
 =?us-ascii?Q?sKzTGCaY98HfvUMnBPt33MaoVaNzc3PsC2aSJerpqnQjuf4tJwugiu0KpEIm?=
 =?us-ascii?Q?PB80UaubENyHJirVlQE2t9qH879kl5lnmYy4fVWLr1SEEJdPR/51NxQewQMx?=
 =?us-ascii?Q?P6eBpSMqnEuW3jNHslQ+WwL125RwKxu6PMlRHEnBTvKdZHSV0bQClD3yi6F/?=
 =?us-ascii?Q?U1M5rkz0wx3adf7Qg6HTnIP+PCtw2K8f3bhBqvJ2JlSYq8EQwb24zIACXcBs?=
 =?us-ascii?Q?6n4NqXrvo3YGjYoyZflbTcnct1y3P+jW6/GzuKxVYV14v+MS3OW62CLZKKTf?=
 =?us-ascii?Q?3P06yBZoovHMv3COFlNKyaW0LrZg720/FXFxSzhR4CEv5TU3KKLqqapsBZYT?=
 =?us-ascii?Q?cKismTu5g1y5QdEnOwDIgAyncaGBAGth6d7FKCQwOIk6O5zmsYrwg234dKqk?=
 =?us-ascii?Q?DtQrtnJQFbb3XhvjKB//p//XyW5+1wuqFEe9O4+DpybdGnLVXiFQnhKsKBaU?=
 =?us-ascii?Q?MH2fzVvOdf1zjLboqr0Bsf2612hRD+7ZV09LtGAUulwTHUIcpdQTamlPZEJK?=
 =?us-ascii?Q?obaqOJthq8nNBDcOC2ZSWCE+KEwleWXKoUC3gOWj29ZN3evTiw5lOAwMvv57?=
 =?us-ascii?Q?hxc/RtnMOjDSi0nNbu4i0RwQY4jTgHF/S7OTabqJ+7kzTDsi4c/S9rVJCads?=
 =?us-ascii?Q?e2yA0MimF4e0/so3F0+FJOusd7HI24iqym6YCGqR+MVc3qOWps5DhFFGsHli?=
 =?us-ascii?Q?RqSPygqeSjsKM693SJuL+cng4cr9Z9KG/Nl/xQ3XgHihW22+4qybCgZJFn5b?=
 =?us-ascii?Q?LBVrWx4zJY5H+chxYXjVCFOAl/L0Dtibku9BbEF8CtyRPR/Hb4C1eM5cpcDy?=
 =?us-ascii?Q?Sdd2sxyp0kIj+lPw22MNuCbT2FVdsHZrA8iPjnj0rotcWFOMkPxH0wn3TfVi?=
 =?us-ascii?Q?B1POKKoJWb0GyVV4LsoCSJJZTirry6SjltyhBnpzsS3MZErMCowfRet3yjGm?=
 =?us-ascii?Q?zxuerO3Tgyhn8W5LuCA9oZ3xAjknCwc1hN+nHOVFihXEQofvqujfIfcBCL9E?=
 =?us-ascii?Q?NLtML4RCHx7XSVC4d3FmE2klwHyoNd6GsLwd78a8swYl9hi6QUlPQV4Tx+Ds?=
 =?us-ascii?Q?2XdvKbvxJVi5bMRPlGDr0ZYL0SSBKakG/hBZCH+lGs7nr92ydV5KCHyIYrBF?=
 =?us-ascii?Q?c2q9kEb73NWoRUvUIASpDQQtGuP11+lVN8lhN+NkS0tadjwpLNTF4m8ID8pu?=
 =?us-ascii?Q?55l0CUDpmsbXJ8EXybFwuDjiK8LggBVg9KLwgCSf7heE2KwlD1iDC4Shh+aC?=
 =?us-ascii?Q?Eg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	79ylUc4428mWJ+zhcB8/eKvSSxPsSrpla5K+9x46FEeUOkJi7hoXz55iPO9iFS0Dv7KqvPMgPG5GqjkgiRKkLpeopQfS6U5BpMnBpGTN3XMw/5un+dHcebjycIYYSGW01ezyF+wxR9XZE3srSs7bmIG+/G1rjFLcbYnDaUc1wucax1CAkp7hjjiiJYcpVCCDfJ44r9tgAR/Wc31Rsb99tfv95x0739wlgblSnWwS9I5d4jzwBdHwaFejVtDtmaJvq+Y6CLBUY3HTsHSNDnXBt4kGy2FjFwyziswvLaYDIFGb7OvEizZ62abeTEj8nPVtxDefB2JDo8GDB4j/lqaMtItc0qFjp2vQ/FA4DUb4lB+L67F+tAdIBNrwPrJsTZoz3qmZZMPhDVpx6Sn4dfzbIXNMD7OPdqUnu7x3VoN8D9vyBfItn0VigbEk3C4LN4SXh76Gjv5Cw19fvftgUOLhZ7SN4GCox+B80mDH7PKDTlzYlRGK9CUsyiT83D3MAjwc0bhaNHp8ThdbaChCcjHL5/gazCqiH171D/6sS4AJbFzhRjyh4A5DgSRwuuEdJliFBYeQHp1/yPw9+VzPY1HdoMoRYninbJ/+336fff6LaCQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f0d58e3-1f74-4ae7-1cb0-08dcf52779e3
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2024 19:01:47.8108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3KqD63xNv4uszjfl7bGTHwV2KKEXKABr6c7wpI63HO3HYayIhEPevWsna6ape+EIWTRHA74m498AVTH1AewLfzBxz0PrnO5nwUcZ4AbVdnI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4186
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-25_14,2024-10-25_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=602
 suspectscore=0 bulkscore=0 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410250145
X-Proofpoint-ORIG-GUID: vOsL0sHmjUtTAncRPfxqknP5cZaBL8zJ
X-Proofpoint-GUID: vOsL0sHmjUtTAncRPfxqknP5cZaBL8zJ


Bart,

> This patch series includes several fixes and cleanup patches for the
> UFS driver. Please consider this patch series for the next merge
> window.

Applied to 6.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
