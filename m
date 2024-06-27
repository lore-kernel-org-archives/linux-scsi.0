Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250A917588
	for <linux-scsi@vger.kernel.org>; Thu, 27 Jun 2024 03:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719459094; cv=fail; b=G1yuVb3mjH66v61bcb37mLvEUxCV5gAPT4s2224G5QT0ihiV5DhWNWRPzKqTj1wNZDQt2xFWd6gTuVZrwBBRjVYZvxiQyNMC5QKfiZSRuMQ4MJucqCTpo/Vml1WEqJuDLeJo5nf6tjByEvelbHqnWB/r6dPnQUxbyjq7luD0PAY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719459094; c=relaxed/simple;
	bh=UFIXLu1iJipkeOwYg3fTYFpLQ15BdOqbUU7cbO+g9ug=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=VCAugKgDgP23SmGJYrJGb0A0WluZkoIvKea9ppNRI/Y+unaoelIKMoXdrQkAFJ5wVqPvFpw+XT2BcYwNWzU+wb0sOu7a7tsptiRryIRWCUCJu84vUvT6YvaY+nogqhmKawStazG1YRu2j8m1ViXiEE2fBUjU27MPX1ytY2wE2w4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BXWZt+Ci; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bFyxtDBO; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BXWZt+Ci";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bFyxtDBO"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45QLN54H022605;
	Thu, 27 Jun 2024 03:31:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=eS5V6W4HHVcEU3
	eRpkmMlty1pdXwOJLs3yBiqWTEoU8=; b=BXWZt+CihZ+7aG8cdokFv6oo8NXK9P
	7KW+PNv/m/OWZ12h6me55Chha8NeoOiryt9e0icKSeEMVhIjPldjS+jFStIAWKwd
	GXRyiltbvLBU+vRcbi6i5LjEoLR9a8kTqn9QLjspA+aZ2+pFD5y7zerTlvGDWn5q
	ft65utGPM8O/vgkTqANsDVmoK7EWOfKxwi1qrcJpv5fYp0xSQRhWI7PE1jeipclr
	oBMWzHFjCvxZCimuAwCcXC58pURCBVvSA4Jef1x1i5b9qJqOxh7fHd9HAPcoKkZS
	ylp1YuLt8p3i0YvGjwJUyyk0AI6Ycn5NGFQgKhUgis1ysRbxAnY7KPEw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ywn70cvfu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Jun 2024 03:31:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45R23KmS010911;
	Thu, 27 Jun 2024 03:31:29 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ywn2gaw4d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Jun 2024 03:31:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BBG4ZlXMaEMlYT8Fx0kqoO8YPu/3THtZkseIfY8CswMF501j8FJX3E18fdsbOm4Bk2Vm+7UnaOvSaDEd96AEBwznaz9bfsyz5j25Apg+hzBw2VRhH2N4DD9woej+IS51Op4ysM1yDRwGr5R25MaSHyknIeAhDpIKQxhq+oKt74syNxIXpN9rlpPzhPO48eSRR3vPb7vDVIBuL5aOP2dBy+TWNSiiXmp9/yuE04g/NDNzauLhDHe/GpgdWQER7iaSsu10yQtWA4Z+Z7Mqbjj7TqNT4cxfREpDcXzHnH7OyCym06jXaXKpAuPsl/72z5WMDTCK8IE+tDLcCllaei290Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eS5V6W4HHVcEU3eRpkmMlty1pdXwOJLs3yBiqWTEoU8=;
 b=NjiDwSILDUATcTSpl5kH3L3VEIrJ/cBmo4IqqTuMe8W/Agv/WhDyrGiS1VtqTBsi6Sksl+0z/4U/05y7WwukM4617mGod8CGuLmVPSUxkfaAhD2JyXKCZFwXKYGvI/hRAshdQHKw7h17Y4ssMvNBCSKoj5YonKCGD57+Hn8zPaQos8T4W6YBRe2/HzQtMWYpCZ/mqo3KV/ZVDtRDW9c+RS7Loia1NffoVUs16BcDyjCBjJTyh0LRsA2AHF6H8/81tF6Q8aQDAEubQFezSPbJ7yaRo91Et617pgFIpjaKkYtnHOVLdgsUDCZhJSsvQ0oVSZXN0+8nWvOtH1D9q5d66w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eS5V6W4HHVcEU3eRpkmMlty1pdXwOJLs3yBiqWTEoU8=;
 b=bFyxtDBOGeBWCx2ZV9lju75n72NqGIU5geWRfrDT19YeL3sgPAOs33b8hDauoTmWkB5uoIg0VoSWFggZch4V9etTzHAXKq8pVnqqeQ2v5Fizsqp3voKcDKLti1Nndr/HlAHvAt2GN0ZBaD0yXgiukM/u+EDApkOQCFYTKfZecgo=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS7PR10MB5181.namprd10.prod.outlook.com (2603:10b6:5:3a1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.32; Thu, 27 Jun
 2024 03:31:27 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7698.033; Thu, 27 Jun 2024
 03:31:27 +0000
To: Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
        prayas.patel@broadcom.com
Subject: Re: [PATCH v6 0/4] mpi3mr: Host diag buffer support
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240626102646.14298-1-ranjan.kumar@broadcom.com> (Ranjan
	Kumar's message of "Wed, 26 Jun 2024 15:56:42 +0530")
Organization: Oracle Corporation
Message-ID: <yq1msn7f4dz.fsf@ca-mkp.ca.oracle.com>
References: <20240626102646.14298-1-ranjan.kumar@broadcom.com>
Date: Wed, 26 Jun 2024 23:31:25 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0016.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS7PR10MB5181:EE_
X-MS-Office365-Filtering-Correlation-Id: 0dcbba79-96ea-49a5-d449-08dc9659a0a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?Ppx/fo2gyzxfLMbr41Xsn9nm+b8v7I1+8byXM3sgha5zfB0ptHOaHUBo0C2L?=
 =?us-ascii?Q?NbzjPSYyuIBcwbcqxB4NAj/abO9BVaBFvtRuGj1pU4XEm9BGCgE9AlbeeIUf?=
 =?us-ascii?Q?LRsKXS+CeRophT5eUZc6C9EsVWbvXsk12t3ITyTQxa0543x22hnMoSr9xjku?=
 =?us-ascii?Q?w/aitxGCW6YPKrjHHm4+cOr0xjnn1QPKWUiXnCIikeSlR9jl/eoeouIQO9aX?=
 =?us-ascii?Q?GxP4FhuuBFjZLNGLNIn4IQ8AIMzsiTjnN7XUMWJ076n+Uom9YtXz/J9DOrI8?=
 =?us-ascii?Q?qOzTtOBp5JBXbuK9WxMz1h9PsCeokxyftHfV1cEOIBFVenbivAJUsqhgLjKv?=
 =?us-ascii?Q?utb2+9E9uE0id/yMGS+bxVw7QtqeZoI8vStNKMMUpW5G0BJKJN7d42lXM79U?=
 =?us-ascii?Q?G+Tf2Hut2OWBldGKBWBFVAdzXxmXlXM+n8FTuquiSMbThwFCM0bKJCK4sAKP?=
 =?us-ascii?Q?g12jhvW13fed2OkEA/DGFsAGHRUZ2rL3aX/Jb82SqoLKOtX4Aj+IED9sAsDV?=
 =?us-ascii?Q?u5PKvu3LS8byI6rcgS1Gkm7pnMMeMPZMkRC828nMad9QWtOiVtw1yb36qihU?=
 =?us-ascii?Q?3B6kC+sX62vvfoYr5rnw6l4rUkRU1sso8mxUqmdgNq+jlY5qaPv77o8/0owN?=
 =?us-ascii?Q?xrj5ynO6nEkxXZ7EA1MM2eHFEN6NL+6t3xk0BQSDh5dLQWXjyIXOKmYwnK6O?=
 =?us-ascii?Q?t0JBv1INVjLUnPq6iPppBg6Ken+bexrEgTJIXJXmx41wy447wCw1XhFq4eCU?=
 =?us-ascii?Q?mWCatAi1SRRaGtThIGbP5au9DmhlzApkySWr/4gCz4Q602uj/4q0wPwCjrSa?=
 =?us-ascii?Q?9fcqYqUuOC1Ijk0QoNaNZrvq+kRYtYO8eD/+LPLHLiuLj+SPFdVr4XWKipQW?=
 =?us-ascii?Q?87dHkRc8vEPhEGmGllOHPI3cBYdmu83FYNIcn+n6GAzWwEgqtk8S/LKyzbe9?=
 =?us-ascii?Q?CU7w55AwmCCWiJe0NFP4s/cUwyUv9OhGUMGjY27QrIamvnLJRsruVpg7IREI?=
 =?us-ascii?Q?Xs6xF0w0/uh7fmWYIbz6RaS9UttM3yPxviD7NVmyArOB3suJj0kGFv4OKLdv?=
 =?us-ascii?Q?4HIbJPVN7ufBZC6Nn1cSjRV2wkLoBxgGZejBHzEZ6FKCfV2uCydlm5pJdEyb?=
 =?us-ascii?Q?yrRU00XNOXzsg1fzKmwBYr6g+Fy2S94nRc/qBZ7FtkbJLUbuN3yse6ZcCO1v?=
 =?us-ascii?Q?K4GvpN6nl9yYUoK8xt5CeY7HRHgMcwH+2T63w7YImRz51Q2RtR/LNnJd/UrH?=
 =?us-ascii?Q?+hT1fKRenki7EEhO8IYxONZDYbYykacDtbV2BGIDc3evGn9iHF9gNIo//CMy?=
 =?us-ascii?Q?Xqt7ka52HaGU5oaOTie4Haw1k/DITMm+EbE8+QZG30FVag=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?oxhAqrD5+e1fd8kdepN28eZWcZV77BpnRfrgNbYF4Rf7vWX1a1ISzjb7ZI9U?=
 =?us-ascii?Q?Ud1V8/JqVNZ2t32mOaNR4mhIuPOu5MMkEa5F0eeYq64cs71usCdNMeZ0g8qo?=
 =?us-ascii?Q?ahsBuGR/DMM14Yk5eR/7MhfaRDmOJywr2o9RGM16WZJAtkqx002NYYjcP+MP?=
 =?us-ascii?Q?+h9C36aDkUuJeHSOXwMtE1PJu+OpZJhUFntpLs5vmcepvMgz2IiESwvbybSg?=
 =?us-ascii?Q?AJTbX5KWazCRv9sqolYspAhFKE7/PSAURCjHfrCvMqvDIcKmPR+pLJUhABGl?=
 =?us-ascii?Q?bQdRAWa7QJI0pGjS2lGK4J7FPCgEvWyaWSf1D1+5BovmGIe328hcrgeEsFZT?=
 =?us-ascii?Q?iqW4BkAVc7K5JpbMKRDlI4CCElT8GsSVXJnB0XEJw6E4Lfrl7m/AQ9zgyeX+?=
 =?us-ascii?Q?imfZQ5EZAt1StbTnnyJWgpeHRKCJyuBYli8dutMiXveYUtSthL7/MwidiNLn?=
 =?us-ascii?Q?bRktF1BSy+SbKuUqTH7ePprl5rgRbwLuy3ty09Mb33URNEob5TkRPsTSgjgH?=
 =?us-ascii?Q?YJoHKDylB7HNT25t87wpzTIC8jbDLHxtNjwjHXPVaFMnPA76jpXOwISKfv6k?=
 =?us-ascii?Q?31JQbyo4/xUJD2URUdaO1M8ffATiI3N3S7JuHU1YnsrRCNYDbKR89eI+cbfJ?=
 =?us-ascii?Q?6CM3vmpLEbJ0ueis79mUSpVBj5zXJRe6zxRV58ykhinROr1Xq7bPJZajQ9ZM?=
 =?us-ascii?Q?uBQSROh5oldNo62YTLVXrYFWY6p5kWaFZLBxr6ZP56ALYsS0Cot+kjyxl7H2?=
 =?us-ascii?Q?Zv7wxQvFQW5763HbAjZCwZ81FF6wcIsaMzLuKalQ2zfIa/OdYYlpRvCNS+zk?=
 =?us-ascii?Q?K8IvXtcO6Y/TdFSBhkJzU4oz+lQCS9qqagHCusHSTQZUf4eQyF/vpBgub90z?=
 =?us-ascii?Q?A4h8eQJ4u+s5HF/9HIUEehFGu5KzoA1HhwEBW2cToVgi1DNatHeBB1fA1FjO?=
 =?us-ascii?Q?agfGW9bFq/wgfaiAScE7d9Kv3N6isJoxacYeNp6OXv34zq700yGGP1/de8FW?=
 =?us-ascii?Q?b8fbJ6VE/r+LG6qR7YxQPyGoCmC4Y9QPYNoAIvwwUZzFLW0AJSbeRuSj81uh?=
 =?us-ascii?Q?Gy8Hdry61fDVacpFwzmvu5NkP3bID1z7KYCuVXDxJGLFAcTlYlXXnmYdFalr?=
 =?us-ascii?Q?VuU3vYzgktxDJmVvK7ZXyvGb7FTyNfAfE5cYzHVsZ/zM6WdxB+KbI05PrSUB?=
 =?us-ascii?Q?GOKaT/PtOsNsQph7+oGhPJZFw7fvmiRA2hP+lSyqXPv2YtmB8MAwaF9KiuLm?=
 =?us-ascii?Q?UL3DoUMoEYzFDpCZLCw1hTTjLZOBLNv6/AKHB4PZamYVOd/C6EM5McsAskEG?=
 =?us-ascii?Q?3wjUJHy8u49NGG+Y5Uowzh8pIhvHc99fzm1uk+Vx7LzVtVo4nNFdLXa5d9Wl?=
 =?us-ascii?Q?dtFxwijdagb6Nb95I4WM18h8agI3DmXrinU/050CNeSVVo0WhuPqMJNqKj6m?=
 =?us-ascii?Q?RpZtErGcEPsKohJTuLHqmzEG1H6sTQZFBFl4xY0Wd49wYFRL+AGc+XHJ2pe9?=
 =?us-ascii?Q?ijbX4/yD+o4Kyhk4Yh8vnywpkkwd85xuEuv2euj4IRgeHpDUM916dlit4e3H?=
 =?us-ascii?Q?hB5jJqfrZoHYyn5c+US5acKf9ZucsOlK9JZRdeDGUdzNmwQWJ62/5GT2Xs29?=
 =?us-ascii?Q?tg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	f0PAtE/Xmr5pgsNGbMOhGIpuY5HWobml3MiLT2uc9AknpMNK518yPPiksFhyljh14xlY8IAk/eeiiIAiFWGd6hb4SYeBj0HgA+x6SCbuTlCnyukgBXHpWYvJk/uLQAMWRxTSF5pKnmV54zTp/HOK6W3BK4wv3PieRfNQvtpx8/M13w2zZOZ5PwPYcB4BJdIksOkWvC2Q6hs+782YcC9ziAvPX3CjSs3DU1qngQnCakyPrLCedgGpL79T2RcqwzVca/Rwlk0D0dn/8EQ6ocwHEBbmAFr6JfpUtrbQ2c/X22PpqcJsc44SzjgiO9XcO4xy3mZ7X1sTxuPnBiSuIas5cYixhM1x701yY/mI8BUepDt118inrwpqcl9KuzTNuIeWAvajvbd1fYckN2lf251wKR+WKatq0NkaAXUmWLBDprB9kPzCbSBbDuUNNkppVkUt7r17f7XfQzNki2tUanzpE38xOJ2mgpnfVBiuBuppha25nKUNPyeuZryilWTv01ul2btLYpJk+IckV9rG4lx8r8bkDRXZ4hVIRDQc+dsLS8YFWTxQguR7Y08DqJA3v+oxlnaZMpHU94DJ7fKaauhidC7o+g/F31HQynt4G/ZfTys=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dcbba79-96ea-49a5-d449-08dc9659a0a6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2024 03:31:27.2174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N/O7eZ0Zd/tRVHp02Hkgtf7WD8zFiuJkPjuSHW2KPxMO1u//FYavQufCGDnggzbhrIQs7P+Ka59TKhVQ6FjzBBovOZ+GFpwqZLoSnIRE9+o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5181
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-26_17,2024-06-25_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=678 malwarescore=0
 spamscore=0 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2406270025
X-Proofpoint-ORIG-GUID: ukLbMWi6lraYshnR7Horig--ZBaKYr-v
X-Proofpoint-GUID: ukLbMWi6lraYshnR7Horig--ZBaKYr-v


Ranjan,

> The controllers managed by mpi3mr driver requires system memory to
> save hardware and firmware diagnostic information, this patch set
> enhances the drivers to provide host memory to the controller for
> diagnostic information.  This patch set also provides driver changes
> to push kernel messages into the diagnostic buffers reserved for the
> driver, so that the information will be available as part of debug
> data fetched from the controller.  In addition, support for
> configuring automatic diagnostic information is added in the driver.

Applied to 6.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
