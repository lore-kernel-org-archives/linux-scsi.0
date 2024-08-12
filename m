Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEDA14A4DF;
	Mon, 12 Aug 2024 22:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723501095; cv=fail; b=pH7q0nuQ1CdSsykthk3kzLNljIqK2Xai0ZZ6KPYMPMsqYvi8K3EP4MOWQQYzF0N82oGSJRVyzDXzOY4WzXW6QEczf0kSqNZ3UT++qwtOKM78eS53WFKsp+U8xEQ97MvmFLu59S6k0AD32FWxj9tbeEYvxu4T46/93FsKiis5AOk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723501095; c=relaxed/simple;
	bh=A+/STc8zJs0l0nTnnqeFyFlpjQeYUIJJ/JAMuebUiNc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=OGM9hslqxZhISEqXzzqR5zXTkd0zb2MyW7b3/6ZsBqb3Whfihmk4JCDbU7pHrzWXOfDivd8st4Gf7kG1RHiYb+87udUVctzZvKj2gYijdMmHtK93sqyI4ZOaDIZR5x4GG8Cb6izydwPdqcLKohQREVYHpcCee7sskIgCHel9qig=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EnljWm1A; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=r3sn6ZpU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EnljWm1A";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="r3sn6ZpU"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47CL7JFX030878;
	Mon, 12 Aug 2024 22:18:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=i08b1WJVYz2YdN
	+uXjlUI/2p7M5kI9JVUU+trU8Sauc=; b=EnljWm1A4Npyk95klu+vNl5G97TLJo
	KE1L7xuZt1PH6shmaM1V+CgXOvjBN2H5/+I/i12rnaothm02+6MmSrQ4IXmkiC1i
	I9TCH2pGi+sJCPS5Hpvzith5dLdUHMVGZ80GTQkfQX7KcPH+X/K9pbdFTip4QbVH
	JMD+CzvwcMrX0suO62SYV2WXWF640YGT2QgNBiC6sevx1zfSWeIdZh02zMOxxqg1
	X6IfslxMrJuwikSDzmvVDmq9dWBl3ASP9erE+2cQpyQoLH3gv18RJBvQa5LD/HDl
	nmn2Auc1dY2BuEQruGUcFGz8xgIbIkFmexOWEblGyksYjqXWFNvC1Jvw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40wxmcvmd5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Aug 2024 22:18:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47CKJoCv003397;
	Mon, 12 Aug 2024 22:18:05 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40wxn7qjw8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Aug 2024 22:18:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SrRDzl3ZcKqZiZIoJHKhSRBnXy5BUZUapmSKklrUnxqcvUDpH8NbVay0ze1/djmKU0vRR4Trz1iz9uAa6vltS4JLi0/ZO/+Yf1vXjF5Uv3OzQFymul/+4dnEJhxgV3Bi0w02BtmA5Zq81Y3LFRmjMt2FVmXyttWVXGDIqKhIP781tcmNtrdYprxnNFUxBL9fvn1gKmJrpI6mpi59MNfgVb5ja2dW9DjIRxF1Eq0l+51D/rvNevuN2jtg5JLvuEiknGGuGH0sY1x6ML1WiM0mlWyeAE1j5qm74qf/4QUESukLduf+hI3tevEdBmjWHRooZp2HrcI9gWfK3XlGhn1Wlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i08b1WJVYz2YdN+uXjlUI/2p7M5kI9JVUU+trU8Sauc=;
 b=FqJFvHhEaUy1UG+XfUTb+lnKwIBJj5m8EFEY2sGU1y+rUCMlUQnEq07ADK4zkfG7TfKWoCQVZ+WmaCXZrNhi1HdH5UrRv66KgB9JvfGzsgJ/vUXWZZihbmu6dB5hYB2frrnB10Tw5wf7GnzOYAqvT4TM1V0LN8p5LOgTisxzso3AeCLt7yA8MvuyjjVffmCiwYrItN7Gvv8hrC05jYHotkH7ZNEvcUTIhUheIp7KVwLvQD4iH/vtx+GN21JSUGcp8mnGUAZRnTkNCyLldyNDqD2czEEp6yMsfvQhaKp/vE7MseDWX0s6eS0N1WPbOF8O4pcHcxKkDP7KrpUCkw2lzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i08b1WJVYz2YdN+uXjlUI/2p7M5kI9JVUU+trU8Sauc=;
 b=r3sn6ZpU/Snq9aqAE+KtyG8Y9sJYnS9D1jQt1NNd+yl0/mSNemyBzKMOBvZ4Azkag2k90AqjOdqzb/X/FJPBi1kM3w+GsXBiQunXxcEybc74tgyMv3qVID9TWsriikHX3HagOOIk2QKylEknRaMReyD0LeynFnHVEcbrulQQsXQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MN2PR10MB4240.namprd10.prod.outlook.com (2603:10b6:208:1d9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.15; Mon, 12 Aug
 2024 22:18:03 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7875.015; Mon, 12 Aug 2024
 22:18:02 +0000
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche
 <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: ufs: ufshcd-pltfrm: Use
 of_property_count_u32_elems() to get property length
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240808170704.1438658-1-robh@kernel.org> (Rob Herring's message
	of "Thu, 8 Aug 2024 11:07:03 -0600")
Organization: Oracle Corporation
Message-ID: <yq1wmklxu5t.fsf@ca-mkp.ca.oracle.com>
References: <20240808170704.1438658-1-robh@kernel.org>
Date: Mon, 12 Aug 2024 18:18:00 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0031.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MN2PR10MB4240:EE_
X-MS-Office365-Filtering-Correlation-Id: 18ccb2b2-3383-4f94-06b8-08dcbb1ca176
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5rjP4weX3J/XzEh7+tbvVQMsTo0smcjwfxsEtq0RGe0qDzQeKkeZeSvmqRG+?=
 =?us-ascii?Q?sQLFNYP/TgeVI9yASVFLe2MyWAp5GMOqgzPNBoaDKBphZl9BgbOGTmgVc66r?=
 =?us-ascii?Q?OIKX/c3TaxiOUPLsZUsCe0uvZPGm8/n+Zc4aj8IHBY7DblvKJQQ1f40F96Lu?=
 =?us-ascii?Q?W77aqv7UcNGWK56rCeVu0oWTfNvwWfhnv5eD4kxeeDprD3PkMUvCd66scXJw?=
 =?us-ascii?Q?MO8/Hid6swv9wWEfWyDnwNcRmdQFEqTorMfRv4CWTThJ+ISxdk/CiAroK5+y?=
 =?us-ascii?Q?rdmHTYn/50ObRh2sJSpg5TfnfDQ1vn865gqQcTlRJ7IR6y/EnjELa06e/l0C?=
 =?us-ascii?Q?Cvh40vaA68lbn4g7X0OMY0GWdDAvIDXAMbderIgykWzRtp9vCwI8mqZPEBq+?=
 =?us-ascii?Q?1Y2CBx2UuEvbzMWcM+7NKwtnFhsoumaQP45vGYhANaKBgvWKuiqHURABHXPS?=
 =?us-ascii?Q?3z1TPh6Fp8EeHhpLiW6Vb6Irc5nntvAEYTv0fN3Y5pOjUxBB8j5yqaCbkNbl?=
 =?us-ascii?Q?wnck6EUz6W1DB5/PfRGGamf2k3Z7HNlRD9m7wbYlduZRc7mrmXqhdGoGMPP9?=
 =?us-ascii?Q?vmyn4m5xgunI/LvgtTMFNJQZZFgbvy5YnlCGJkIX1K6HqN1+EAOeHYXvggXB?=
 =?us-ascii?Q?blctNI+kmPTtUNhggbo0/v777ALS8TCgbyneePwvAfj2ioB2n6sx2AF7eENk?=
 =?us-ascii?Q?9etQfdHuDBhSF6eeiO7kuezH/xUGfu5naGOliZIXWh7BvToKwAuvB82b4fUY?=
 =?us-ascii?Q?Hs9MuALnAgVbZ4O53kTSzmHHqJyie/AN+OWNXG+uLOzTXoZky7If7maiWUFq?=
 =?us-ascii?Q?q0t5QcjGMrzW5ZjpzHSESKvwr/jbw667OPa+E3UN6Q9pB8nct32YseJ+/1hJ?=
 =?us-ascii?Q?+6rR9D7ioEWP8WPscCNgiP1zFNC4qs9b9lf/IYrViOF2ui76IWDoY2XCIYbQ?=
 =?us-ascii?Q?emBTfpGDRILXOGYb27C2Nx4I6GK6mJ+ZUBOtlIYhGVBqblY6T81FoJ10MAvd?=
 =?us-ascii?Q?D3n+A1RtvZ2eTr608O3DLsd8RLqxHiSyo5e7s/st/Zk7WGZr7ZQozncGlnlr?=
 =?us-ascii?Q?x7sBHGc/RfT+mScQlh43Kn0tOwk9nPJpHiZvHJCKQSYiTY1CDegVfDBC0O1j?=
 =?us-ascii?Q?6DmirzylJxGJ+1gX6YIHX48AC6DzNbAqmTJMXfY9Dwt8bZuQxdSLiteLCzTN?=
 =?us-ascii?Q?fW/FIB1l46zx5XlXlkviy0mccrJrlYKQVKAsBmDlH7m555VGFdSuV8d1UvqR?=
 =?us-ascii?Q?TAm2u+oz5rSKCaK2O6D+vBitrWwKCLEjkowGJMAcIYbFflteK6UOg3GtLRW3?=
 =?us-ascii?Q?wBfo/VWobma+BhhJljDLriOypW/ct6W4pdh1jgPt08GfNg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RAplY0FmCn6EYNU5Ns8Gcbct4bGzVLqDbVqiJr1tPa8Y1JXgXVYJbeyZWNoI?=
 =?us-ascii?Q?VSyA/ezMsbGfh0FBTMvgNfyj3mNbGiigwRg4vHEQkZTDVlO4OTUp2PhgbK0D?=
 =?us-ascii?Q?8Ho2LZ/qiPdiKvKte6xGKF4JptRJ0k2Mmv7J516fZDTB104yzDyeZhkN0Vkj?=
 =?us-ascii?Q?2A4t3QiaHYf06UE5nKglkDGBKzzmGJRM1Nubt5zOmTF7/zk9AZxFtFMgq+Ra?=
 =?us-ascii?Q?LyX9XDRJfP6QzvOqxy/vNQ2BlDSnxO6ka87aSE4PP63PDHAt4UgITOopLHxx?=
 =?us-ascii?Q?b/LkJD2eqFmE394foOmJsXDxHjy9pN5nc5ddtdCJlhFyqOVXcxhOki1QbPvQ?=
 =?us-ascii?Q?fI43lbyWYsRAlpWHfi5TEORToQxI4S0Zc+PmyK0WJWFbElRg3buqbPm54k6C?=
 =?us-ascii?Q?KcFoN/J0RGEKTXsUU31vpqL705iP0tSBnhlPvUQSfOTn7eTYJfzbX3Wv2jlL?=
 =?us-ascii?Q?f+3F92GJlNYDUXfleGuXTKOefqTML2nuSyj1kP/aiWhtnFO0L38KdB0dLND0?=
 =?us-ascii?Q?1QUXmFL+aCsKrdUqvZkoaiSXOptELywB7piTcI1TsvhMx9w4wZpf4RHM5syA?=
 =?us-ascii?Q?CJim+4w2O0vQGJ+sS592C0H+nU4gI00MJnZl4tZRD4d1I1lGOGkXWVxuVbjt?=
 =?us-ascii?Q?LNYEaGw2WOw50Ef4kqpxC9jXivjVqNbnld3EwLyeuZin09l3TqfCn7u8MaZv?=
 =?us-ascii?Q?2tG/oEqMj2XmyFXE6ug5x06lKX6li1tI2meX/9gNVzuFyPXIxXEExiabL6YS?=
 =?us-ascii?Q?Xdzw8gJoNGgL7xQ2fIO3pnNm3o0P1ubxqOV+ihzx1zS+DM+gRGsod64AJst2?=
 =?us-ascii?Q?HAEl0n1Hmh5fDldkYaNjcdYXHhmHQYJGC+HsaD5DbzNODAj0bnIBWrC8QVPV?=
 =?us-ascii?Q?Lb6pY+8/4zzT6XSuts4Id8VAWzzsyiJPXpJ3nimGbynuFiFSfPiMGPB8IyGM?=
 =?us-ascii?Q?4Ruk5Ud8peAsveH63/5gjYicOd/n0F/wwUGNNc3jVfeLLTaqDuTGhkVEVYEg?=
 =?us-ascii?Q?IDIvrP9Kdp2P0K75lTlEjz0zXleJRRmU8DvhA07i2LKW4jILauXdw6yokpjL?=
 =?us-ascii?Q?jpXaHu1dBBsNstRT4JeiFwNiMu0tnEgnRP/ddJxk/1InoCzjQ3pETcJz9gUD?=
 =?us-ascii?Q?jUFrtGRqyEZt4RCLkdLMEOgcrGTTGsp0PMUmWUuNZUEdPn04vuIWWfK9R8Sb?=
 =?us-ascii?Q?YdA0J7PIHg2bmWgl1MEAPCzQ9hxFGeecCPX2Tf+L6kQURJUIUGI5eNBLFiIF?=
 =?us-ascii?Q?FbqPLRE4b8K9x+MuNxtWBez6frxywKLHJ8jpP+R+B34EX5z7upyzAoRYhlOf?=
 =?us-ascii?Q?Mkq9sja6Lyrf+u2k0g6YJEfmld72B3FuMr8vi8ci09aJO1T8JPgwhXD/TFdj?=
 =?us-ascii?Q?wtNC4DOd5m2gg35NMHahVd1xWEz3NDgiD10l97vPe85qDBjCUADGQRR1NddS?=
 =?us-ascii?Q?Btguv2z2dcq1BIy8UsJXh6WBJlRekCAkMC6U+MDuFTk2asp8inF6OF1Dq2J6?=
 =?us-ascii?Q?mGF+RUTTqS0bQsre9umT6Ki2DjSt+FUi37fhTUvIfXVKQEbWigt3z1mrFfW2?=
 =?us-ascii?Q?k6d/U+2NdxbFbkAxpQj6FtJrlrvTYPEsKYYFfr9a/QzY2CJEbj36ZYkCBnpS?=
 =?us-ascii?Q?gg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	an7fVSQhCw6jOS7ARtd0G/bqG+UJSpwsN+tQykAzrfhVKDPLkjko9vkrlJUxkt5A+Z4NGqTVmdXVWqsRSzaR2enCyYDFUYA8iwf+3/qeo92QJRcsxHLCtNpupiOOuIXPBWFw8uBGGb56az6639uFwztG+WCixF+a/XNY+EsTCvEBgj4kNpFEUjNeRe+xsrETtbvKtsyg1iu04iFeoCdmv5pH0p2/FI3IvGMQmx5943UxOY98XnpkzdwLTN2WV6rHGTUXx5XN6WpEtT7HSsd88whYzlJ8yx1OcYaxcxgUSgO59gAvi+TlwusW1BxPhwL+UkeamDJm4X5xIHtCi3snD+ffQ2cyiqOTbVG73dRNIxCviN49D4zh6aC9brkGunYBhScHxgbyL7nmTcM40t33nJ/jJ7htfe7gDRL7dLRFhp7SmOV1AIFI5sbY/6bpnZfA+NxM93y+CRMU/ZGVWDPkzQm2y3sOTH9qE7p5cL7SPSYQirItAuzv4suIaWcMyqX4oSwBzHoJeQDHTonNfjW1EItqBxaSR5uovSXUE4F3jrjvglaRHcX6bBz3fdqkKbXfRDoPi89bD0BQSNBffJPZdG8l815tfe72ybqm9DGjv98=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18ccb2b2-3383-4f94-06b8-08dcbb1ca176
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2024 22:18:02.3473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rF/A0PUSBBdG//OFT53gi8nzInIXdoI3DAe6uFwoeBWlsq06NcylBrCyr6DkpS9zRto8x/VuTuTRmhyyVhe1JNAa61ak2ffKPaRGfVHQAVU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4240
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-12_12,2024-08-12_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=844 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408120164
X-Proofpoint-ORIG-GUID: rf6dR19zVU_dzLL9xfUHRg8nlEV1dr3i
X-Proofpoint-GUID: rf6dR19zVU_dzLL9xfUHRg8nlEV1dr3i


Rob,

> Replace of_get_property() with the type specific
> of_property_count_u32_elems() to get the property length.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
