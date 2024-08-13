Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65906AB8;
	Tue, 13 Aug 2024 02:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723514962; cv=fail; b=nzgQYiEAMZ5LmWPRt5LC4s1LaqKPKa8QD6Hd+hqvR9/86xg2zNShigwNdOXhZ33Byl8lWePLJXlcXhO44D0cxqDWfdMmsrx0hUZFpl/UX2GKFLGcnNg0eqbTPc6D+JAJgI6EmLHtqJ1cAznBHenZv4g4pe49iQldqtmIszwNl/Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723514962; c=relaxed/simple;
	bh=TSaq+F9f/CNYSN4Jr5DYFWc5okVB3exrzKC3UfbF/ko=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=BhGOpMUA/fI5ud4mT9lh4vavmMtzpHEQ4lqC+65CC1PlgtzCzAEWh97qJno0q/dKPgo8SpcBW8BNFzbOw27yxeRiuzr9hS0fhReiPoa1pw6QAWz9vq2SsN1jxCywR6V76VoUgPHh+yoV7cEwGYa27YOLDY+CNiRYjHihtRLQiGM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZLuMhm25; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=W9vNa/DP; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZLuMhm25";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="W9vNa/DP"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47CL7HGa005165;
	Tue, 13 Aug 2024 02:09:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=le4EvZG81xjmbd
	eZjN3c9EfLOg9lUUHttZEFBIjagb0=; b=ZLuMhm25U2Iu0iaM3utTExJ7KEnre4
	fuxpmMOcqL/0b1Hwmbu8PcKoT/9B5x6MtH+Aj4retH+rRyR/GejqP9e/XLcLZnC0
	2xLPTLG7JPtv5rrMROo9lEvWAgQA/fhIsbo+aJKTupGWRcyu8elfAnj7ZGCVbzQ7
	4typ4sNj6REZpe2qqP/99wfUWYV4oDYoXr+lhmcYG7oIoEu+fj7aF1kpxGyZCCC7
	ocqLUKBedl4QPdLBhCQ+2XxleWrmMdtiVKOzPQ+kNIw6bsVqOk6FdUsR9S7d6Q/q
	7STeZV/56peKCzgbww2mqF+JwTT8PZmerHowRzU7qbW7GuhQ9oSInj8w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40wy02vynb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Aug 2024 02:09:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47D23MPA003739;
	Tue, 13 Aug 2024 02:09:14 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2045.outbound.protection.outlook.com [104.47.70.45])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40wxn8x350-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Aug 2024 02:09:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NLRWYpEDJAQqJOKI1VDj9GjnFob6Wfec8st0PoBmZZ6dpE+iO2UpE8KphIaPuD5Mvd9TkdPsVhXlFf1OgHvGFYzqvP+wpI+54muasE5Z6MEPlyOfvAu3DJ+n5V3KJrWfvMA0ewo5+2xoJ3v+GPNHS+LNp3fkLak/YCGxneiPE343QfVkefzvznqbMGvCuC/ar7W+x6E/9Khg3ojE0vfQJdeYPSfTwvcGyvBnhPnmlov+Qo6hX797hCI/jUTN6SBY6YHVk4lcLMfygTPE1owCW7V0YNoeWZpQCVJDt+zdXDZFmJ4I6emO7vC0m6A0Jg9HIVOKkQi2YgssxuiMzgLzKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=le4EvZG81xjmbdeZjN3c9EfLOg9lUUHttZEFBIjagb0=;
 b=K26o0er4wwKrJ2jnUXAMQiZo4u5QOyX7OjwRISNdKsFkBt0U2wlShsW2S0Omif1C+f3tH27tpXISW9m2ybWLkdkth+V81uNA5J80qejlvos++w5RD+mM1Ny0ESKdiEsIFxshn59TXsAOYOmXjGsnh6v1mfIiN0ivFhj8ngJgfI6xhpeQKDrQFgNfFRkDwt8+dTAlTG9TCXwT9gNqk45iNvDHxc6fLNV0LQlCxkHBv1pKzxHA1GKR+g6rR9Zxya5BSHYm93cwLCoxGf+PPbSxKrIKqqUJIaIbVzjmNqfJqplBqPsNQIuFhVCFN0xBKYaLxzKMFMgHpj5LvP+mVMzoyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=le4EvZG81xjmbdeZjN3c9EfLOg9lUUHttZEFBIjagb0=;
 b=W9vNa/DPauPRoHQLcmLcNACqkX4mf9vH6iGoqnNXwdpU3vkJGWVxlrppYCUSzqKqto/P/CGa432ehU2ySw2RifDvkU5Qm7I97dJh7mtZdNtT42vpXWYUNUovgSzw4jSBBGO/TY6PPL4H/P4GJlVmo/r4i0TeRhdXMttoqZarXR0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB6967.namprd10.prod.outlook.com (2603:10b6:510:271::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.15; Tue, 13 Aug
 2024 02:09:12 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7875.015; Tue, 13 Aug 2024
 02:09:12 +0000
To: Chris Bainbridge <chris.bainbridge@gmail.com>
Cc: fengli@smartx.com, hch@lst.de, martin.petersen@oracle.com, axboe@kernel.dk,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] critical target error, bisected
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <Zrog4DYXrirhJE7P@debian.local> (Chris Bainbridge's message of
	"Mon, 12 Aug 2024 15:49:04 +0100")
Organization: Oracle Corporation
Message-ID: <yq17cclw4xl.fsf@ca-mkp.ca.oracle.com>
References: <Zrog4DYXrirhJE7P@debian.local>
Date: Mon, 12 Aug 2024 22:09:10 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0196.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH7PR10MB6967:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d53c04a-f78d-48be-93ae-08dcbb3cec75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HHB1lY8MJFFaC2H+ict4RerBT+f7cKSt+FO8Tae0ij17VP5kodxYyxzKAX5o?=
 =?us-ascii?Q?1IDwcdfKop47rahoBoS0SUFNy6uIOZ3GQrtJmyQP795EKLQZiEZmymm/53gv?=
 =?us-ascii?Q?EGIPqzdCqhuLz/KwvTSm9L90aCHkLxSkyv3hrKdSbEfv2r4NYAPBnSow+KhV?=
 =?us-ascii?Q?gLT1sZOdiQm/fO/gi+wx7XUhIBtjd2qOep4HS6qYA1KuZcUIZY6mFktOAGYv?=
 =?us-ascii?Q?+Ko9yg8UGj/Jb0F/L0Zb4n0ObIguNeDUmV6vktIJt0XQBQOivuVxc/h1dW/L?=
 =?us-ascii?Q?fH62KtMqWfyBywHrLOxRI4tdoxq7+9s7HrgwVDX6tt3o3GKFogIWIfOivpzs?=
 =?us-ascii?Q?tfCB5flD32xqqP2G2xNX8eMr3LbPt14VmREQeHiUUzr5XZ95ihL+RD/5ylKL?=
 =?us-ascii?Q?nnuWR9uVCTSU/RPVMONCkYPfmigCaRlJeqfAcU8pl/MOfzXXZB+UZ7aGE3tv?=
 =?us-ascii?Q?PQlsVksF8CdR6zBXqWdVYnXK57Yb3z9yt7S34NtXbyQT3yy3Tns10Y2HNsRn?=
 =?us-ascii?Q?2W4uvecttSGj1KCn1FK0Pa1APqRraAxuIp6/ZB4eAFUEonPhr3fJdULzOwnn?=
 =?us-ascii?Q?w1qqwJnXgRr+/U5+E7G9ETDVrCBQke9J5AJjjlXdiZO8s5Scgr6jpX2xASVD?=
 =?us-ascii?Q?XA82JtCtYwOuW1/A9DfXJ9OztuqCFzeDsObFDYWHfp/ACaeZpvFGowqVxmpi?=
 =?us-ascii?Q?HjUfl3VgTfoNU0/orUx17ejmG72qYf0hg5BXRCNK/Zs4Zq2iF82G93Y+uKcO?=
 =?us-ascii?Q?KIrEw1aJNfmyVbOfzYuq1t9xlTcbt9JG4X8nEGfQnzCeJckxydRikei7/uT5?=
 =?us-ascii?Q?eCiRxs5hO7gXT4+KAAfPVHXwE6IPAz9s1S6zKePJBOoOP5dWPGvywbSiN/04?=
 =?us-ascii?Q?3AK/NGkc1NPVRfIfxmDToTlKPrG+dewb8PwCfO5Y4rXuS3DfPbYat1yFxHYj?=
 =?us-ascii?Q?xvWkmfxM5o7XH0eU4GcNvh8u9nWbEHitZ/lNzbNJ74vlMbjjuZAH9CPbVd6n?=
 =?us-ascii?Q?D2IJ+XanP4QRv0JC0dEUCA+QJd7lxTY72hGpkcI9HBi8BN6P0KozQFjgrD2R?=
 =?us-ascii?Q?akv5B3mqTxloDLhxSBeWzoM+WFYEj9ABm3RJxi1Au3wv/edwGFiCjcU3isFW?=
 =?us-ascii?Q?01WybOp7pWFf2qRUF2CrSRftGtB1Os3RHPPInYXiKWdxeIuf6eA9gb5GlkGh?=
 =?us-ascii?Q?JCqPlirI737G86tmuqLT2xkvO4phHRUGCdf3FQoOEhpOSckk9G1xFs8B8QrU?=
 =?us-ascii?Q?sAHJWwWjkq1TY5+DaC8p4DSkDjadNG1Oz0e8neU+EROiaR0eBZf4Ptys96Wj?=
 =?us-ascii?Q?jqhhfhdC4AoEhQwg0eI/tcFmzaTODfVaIP2EfysMz3y2Ag=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?K1HVGWrZuA7DG6iQdnKeC0Qto5WyAMac84LSLJ0bZB8ZehxyFi0LFcPAGyBs?=
 =?us-ascii?Q?bCswFHy8CUsNPTBFVLjRzFygUv59dXq7mqkjAyGCsUOiO+e2seLmLESNLEsQ?=
 =?us-ascii?Q?Em/LI6jcyVJwtgeYG7TiJvcW/CO/6X1z/6a8XJ2LhAckKOBH+uv5Y7o40ym8?=
 =?us-ascii?Q?007XezK5+kUfUx0r9oDwOAfuYAmkl0LKGK78IWIHEwn8s+hycOhKDwMT0bJY?=
 =?us-ascii?Q?xTUodqvbwi/tdBNFMydhE8MYMMx8tTh50QGE94WsBun9j6a1ELZzVgQE+43Z?=
 =?us-ascii?Q?r42tRBFKHhWEHifhtroc2ea4v5TTJp6dFvxzbn9dGkhYconh7O4gumQhKcIV?=
 =?us-ascii?Q?EL7+5ilPNMEI9JnwZDswPknyYvU0p6laES2Xjxbn4koAY90EzPp6qSkHS3CX?=
 =?us-ascii?Q?+WhddKRwSHDPKvR6qXqDAH85yHiEe+aDaLyEpdWWl24GgJYByCvc1WeKLYTT?=
 =?us-ascii?Q?NKQM++WS7BVRwGp1DIWpqlkse15++KkpVgXIb68Im7BsE+jhpOLAB9Ek5aud?=
 =?us-ascii?Q?S/QzGnqciWIz/QBPROmblpVJF0CE6IgzKsibC0kb0aNaR8SOhRJi2Y16yi4N?=
 =?us-ascii?Q?4Tw4quCNJZq92VGT9e8CL7KeNTzKiCnaltihQMQIz4py4LZwUfNJV7WQ+Ibk?=
 =?us-ascii?Q?55G1YSmhkAn5cyMvW5t+yRbbUutgCeAojeUKg7sPGTOleB9BuCF8KAGJMnKn?=
 =?us-ascii?Q?Z3E5TB73bOOqMXMX3d8jak+ripB8ieE+zFaWJ2jZ/VW5zrJIN7STkCA/VGMn?=
 =?us-ascii?Q?2bayPaoOBjm6VER5K+4opq7I9UPQIfi6lZjx2WT7bC7UGDszGqyjxJpRPyDI?=
 =?us-ascii?Q?2n/hSJgg7rK9/8uw5EyF4Uxpt+JuIhlZ0wydsRiD0jsY97mUsw5Ey2AxhAAM?=
 =?us-ascii?Q?wh4gBp3FSVNsXHoVLg939iyK9moH9pOyTRB9+1SEa0k8HwCRDrjC0AESvX9G?=
 =?us-ascii?Q?+XIAwJRK09a91/40heTBGdojhaHcFCTQ+s0ei4fe93KDvNxnD8ZxUVC6AmNd?=
 =?us-ascii?Q?mZUO+BBELamY4wCFLgEvByRiGbFlMv3yk6GC75AhZdU0nmhWTQPgQ14ok+VZ?=
 =?us-ascii?Q?d6qm7BEanNo/zzEcNRPnb3pZi9RcDgTvNG1t/QBLn6fxCldp4yJhMVaGXCq1?=
 =?us-ascii?Q?O4rcKlDO7rvaXFCKghVMQvp0lHt7RN8eRa8+48xhovJk9WfUqGp4xzAUaRcY?=
 =?us-ascii?Q?DpalGV0v6Kpm8nYEE6coABgHGu5xrQBed+3lwUOGpLhV+uGKvAOepmBp9ckc?=
 =?us-ascii?Q?QCCWz2KNciRq9DBTJHGU1xvjkNTqM4zz31awX8wQR0aJZqpmDkhBrlKa25l0?=
 =?us-ascii?Q?4WEq0tKXgffSnk0iHFg7n84gt0KgtGCyq89ocnYghMTw0/4jkoUkO6KSnWEB?=
 =?us-ascii?Q?SSynodfklWaJjOSw6W2o6rqwsRJ2tqHgSmfg7/D/Wyj+1S4tnORPYmdkXqw7?=
 =?us-ascii?Q?U+pvKpPoTBG+cy4kcT8K/Ot4eDGq0huUMu4cSMTmVZateIsvrHsSgRapepUf?=
 =?us-ascii?Q?p8SLYOxunDv8rCGBU4GoKDma3F2MzuS75WVB24t51brtC5BeFCRKUuG+LZWs?=
 =?us-ascii?Q?Kr7wg4UNNl3+2TS8HFYNJ+0gqUcU5ZGcdYtWuycjVr0gE1WO9skZDkkAKsX7?=
 =?us-ascii?Q?4A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Oh8QfTpb8zaLTrvskmjeyYuP3YxpkF9/thVd+Y+Y3gSjaPS7+13ZCwwRFhMylLeA3htcveUFzbhZxsXFplA/MHr7vdOP6b4Syn1Bi+73Atv8+1ESWONvkF/P+ubpsNFw3AegjqT6yqaWLzsJ4KwuB80Y6bvY2sxg6PlaPWRJbHGZ5j/pNrK9Tp978vKFKlaEm1KQbsd8U2W3j1RCY+upi42SRnUVC/QnNiy+mYxM49VCqUPyWJPFqoUIS42lqC3YuLnWi1NFYGDOl1w52RI0zfDMDQxx3g2w7y2Tc9XBDeKNWQfpYPB9w23oOBw/tAF47It1wLXlIXveGRHShS+dwwxoZ0Z/qwtvnldB8vffaXVXHpzCshPlVeClUXVF0+gp3QjUDLMqwREzrFoV3KRRq64Q01DJBvXfvEkRQHzurez6tcAjorYwwQFoUHb3Uz5/5LLV4wtSIM2gj/hRFjZBJbpz0SyTmPIlfLDA8ynddEVDHkAyjU/T2qWh5odz6a66I349e5dKFTdHfYEsIObySmnXWEdF3y8oeyQA6n91GT8ehaI+o2vHfTRw913q4mL7g50cl8koTRaX22DBOweZm0ojaPeeOmlhAD6N2rs0McI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d53c04a-f78d-48be-93ae-08dcbb3cec75
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2024 02:09:12.0838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6eulPhP0hpmNlyzC0Zmyyk4lQIlsxC3T5fx/GnlKxraH72ZbsGi5VJYlZvKPK43IjhUob/3s/pbdzvQN9y+tApaQtByuc+RqggAPyJ0+ous=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6967
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-12_12,2024-08-12_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 suspectscore=0 mlxlogscore=600 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408130013
X-Proofpoint-GUID: WQNbDp0npyQcqAu3ybiCsqCrEGwrGXig
X-Proofpoint-ORIG-GUID: WQNbDp0npyQcqAu3ybiCsqCrEGwrGXig


Chris,

> [  195.647099] sd 0:0:0:0: [sda] tag#0 CDB: Write same(16) 93 08 00 00 00 00 04 dd 42 f8 00 00 2d 48 00 00
> [  195.647101] critical target error, dev sda, sector 81609464 op 0x3:(DISCARD) flags 0x800 phys_seg 1 prio class 0
>
> This error appears on two different laptops with different USB drives.

Are these drives usb_storage or uas?

-- 
Martin K. Petersen	Oracle Linux Engineering
