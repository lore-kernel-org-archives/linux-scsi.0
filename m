Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E802EB1F
	for <linux-scsi@vger.kernel.org>; Thu,  5 Dec 2024 20:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733428854; cv=fail; b=A7leHVrL3ahGMduQs3DQ2xq/VcvCANjln31Y98TlCiHq195a5ChAK38Y2V4pDMxjpq4WjtxjrHmrdkmYFDYCMqL/hW/vhxK4kpmrDt3h6+ob+Mu4muVnqX692oZv2fbiBdl9kUrbfKqsvG0snVyGBsaBDY4QnH+hfp/KPu+vdRU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733428854; c=relaxed/simple;
	bh=697J2VTg64Z1L77L/+a0Eix39rIicmzcrz5NMQVN8/c=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=t/POo3EUcadyOTiwY6HUrdX3tMtjSpGAzlwob889JQJFHH/aosNmbv8DxIu5wWHUcLW9B00KyFBtAGCXd6gZsWwsm019TMDhfhUgn6BnYXIKgII5xqrE14AurvIhOkVHSlah6pZmBjhRocwZ6TIN/hNdKnpYUnHaP69RoP57Ijo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BzHXgrTl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=b14IUJEL; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BzHXgrTl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="b14IUJEL"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B5JBsmv002239;
	Thu, 5 Dec 2024 20:00:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=Pahhu6HhSzCStbA5+f
	QklcLGAlifFoGUKvbmqfmoHZQ=; b=BzHXgrTlXWiGfB1OBMGtkQ4ZfS/JTcezUT
	SjXSgpUS8SFtjtbwp7W+Aweg2jOh7qTuVLU9y4UERlCqLmmkD/2j1eHTNugzmaJM
	FSjTSeTmpsHWmqa1iLoDRdCaOKFsXPmkCMs1ddWEFw273wnkAzY/naP9fY3r/xTv
	rHP/4NcxcrsEi7e1qvmth68CSEPw36Onc2w2o+WXLNveh0aMSWi3BETHeEZm5PF7
	7EuNTbpb0u+n6aTlS2RnnBKW3uDRmbu88wBQJRco5vrjQm//0etM9KkmCJBY7Lxp
	ykA9N66T6Fe1Se+rCEEdFzf22QMEQpd1nCdsBLwmfMii3ujqnlgw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437u8tc51w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Dec 2024 20:00:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B5IH7Ik036938;
	Thu, 5 Dec 2024 20:00:31 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2044.outbound.protection.outlook.com [104.47.58.44])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 437s5bwq99-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Dec 2024 20:00:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=op60kUgvQ6CTCzFW+cBicoZ0F4AInz4pVrvArDahxwRtjl8PQ+nukQwmC++B7K7lhM4AGLHTnWObKrZ5/rHKR0AStM/FIzdRoLh/kssK60uMcEWL1OQLh/Ojbd3N+gw60AK1VLlGS5lkE6gkb+JlQ1El6IVefopsoI4nBZoX4ndhy6rKqxAThaWgbmre2Byo0YD1GlWtDwvNAv1/9bvhnuNGCBx4PdDbybNVC5TT2ajSmwp4QqKLPBgkv5600Dr+ZijPRBU9CmGY9luHBA4p2I/JVrTFg0T2bJeIvrpmqP/PPbAWleuu5AWDqhUTzvEaeAZT/6xm5//HuBKFXfMP8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pahhu6HhSzCStbA5+fQklcLGAlifFoGUKvbmqfmoHZQ=;
 b=RibuzSr2WtNqbA7Dw6kWKmu08dnvgISqfndUqIXGUpUSM2wJClQXvhtHBqOCQxJv5o+qFLKFDNHwZKrQR7W0CVKwBK0ix0vK37R4ogmuyhafwybMGC18dNvQt2xpfym3nBJyxLdtSSiQxHJq+yaS+t5rxDvQJIcFkrxkZxqxv1zBUwGtvYLCFnpt1zHIXIM1wWqWcLSnsG9mtFph5tjDaF6ug+Fm3IyYsE1ltjiZzhi+wf4VAPeKMN7+QUoE//ESBMgmN4aZfeCBxXteCPAcbV5S/DbPlQS5OFiJfae4o8w9gxmM4E4QyzNmdJDXYCHcukx5klaMEaufJbP9caj4XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pahhu6HhSzCStbA5+fQklcLGAlifFoGUKvbmqfmoHZQ=;
 b=b14IUJELMYR2rq7gVgpHixLQ7SpfbDpBvtXAMjBAu5kUX/dSOIgp1xWF7zgvJhuRD6yaZuf0QGM17dhx8wSsFrsRGpIb8B8yrSiaOL0DVUu7BzHXJyxjiH0zN1D/z6XRhgBzaIrt2jLgGEGOCHUsmQLcXgLql69PR4OXgEIyrZU=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CY8PR10MB6465.namprd10.prod.outlook.com (2603:10b6:930:63::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.11; Thu, 5 Dec
 2024 20:00:27 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8230.010; Thu, 5 Dec 2024
 20:00:27 +0000
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v4 0/5] Replace the "slave_*" function names
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <69d7efec-1f69-419e-a300-84ff347eaa46@infradead.org> (Randy
	Dunlap's message of "Wed, 4 Dec 2024 16:57:24 -0800")
Organization: Oracle Corporation
Message-ID: <yq1ldwtoqbk.fsf@ca-mkp.ca.oracle.com>
References: <20241022180839.2712439-1-bvanassche@acm.org>
	<69d7efec-1f69-419e-a300-84ff347eaa46@infradead.org>
Date: Thu, 05 Dec 2024 15:00:25 -0500
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0254.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::19) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CY8PR10MB6465:EE_
X-MS-Office365-Filtering-Correlation-Id: f8c02fc3-4ac6-4fd4-ed61-08dd15677692
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?s7vKIikXCiEDbLMEvh2EtgQN7HRekVa2yuVm5MQHkaIPtxcUKEVuTKoKh449?=
 =?us-ascii?Q?UMwWlosltNzt2zGYwEkCzWGWX6b8dXBw1xb4l013A+eDDggszRzsz1dy8ISu?=
 =?us-ascii?Q?Keg91nBjCI/PFGatWQ8Y8RIYnHrsBmRjb9whQ9TQTYcKAc4J2EqFg8d8SbG7?=
 =?us-ascii?Q?oVvsnjo2+av7YebhX//nTbakvQ4EMh7K4+TXkdVknicmXhyUZmK+a1nJyRFk?=
 =?us-ascii?Q?sh043oQmkDQmSXvRDJpb3jmuWpYbsT5RWjOXFxI5Yq3Ts2tTTXG4RL4aBElI?=
 =?us-ascii?Q?1iFI8QdfS9rQBfZFD893PPRBMH2FWUVxadgnykU47dy6vANnw0/UnrUmViVn?=
 =?us-ascii?Q?7IFoiDCmq7OD/FtT83DqHDiUP9Ff/zQuAOiDKcf6X86m5y3AFXkif1dp0rKa?=
 =?us-ascii?Q?AwrmHK3wotW+8Efv6axhvYdveL4WVk/3n+gvi/gmvZnmFJqRm3L2PUX4WeP9?=
 =?us-ascii?Q?x3SVGUzzdFnCKqdFSsWc0bVCT/BpbysiqxWUoFc0lTUv2hsshh/z735t6k/o?=
 =?us-ascii?Q?2PkWwRQoq3DRKPvzF2Vd4+NThB5jfNb36azldZfYVOOBHfXGL/nxcFKVGJt1?=
 =?us-ascii?Q?8ptvYQX9mhZ77Wzjle473RsX4MuSEAQEaSaxLQiRTKyhuGKkJMyIxJfqkamy?=
 =?us-ascii?Q?kiKBw+TVoIImSCSDRsDd0nc/Km8ppLccIxFlD6OJRXUGs5/3vrNjia9e3PUR?=
 =?us-ascii?Q?Qfnxym2ebpKjq0K9VbuH7JTaUC2gmaoK8DlE/CFS39EiGsrmcHWYCqIR6Cse?=
 =?us-ascii?Q?6WdLtTI3iYl6O93MR/EGhFAjjs1jw0ilE+gKVtO3MHZdLlc0/ozpu9KxW6Gx?=
 =?us-ascii?Q?TcGy1enkIGe/mezV9vsQJsA7pvuMifN6c5JMmVrL/p59Cx2gbZX5WzPYd3kj?=
 =?us-ascii?Q?q5HM34rJwBd+IL4qCO2K7p6opEz1gQwCIWHahP+CwJ55i6/ZUy9CWVARJD9r?=
 =?us-ascii?Q?ttq8hlu3FMqF+6VRuVo0DQ0oi4WwULayC3QLrkNUbwSbpiBvpt9Fn04QWyjl?=
 =?us-ascii?Q?2JcPHl5laFy44eYeKLw5kbRPS0Mbi3WHHx+9mJEMjTiW9JRNFZSIv1teBBFk?=
 =?us-ascii?Q?hpEcBlt/Gy/dF0Ej7kA87vQKKe+rJXeIEXqTE55KrHV06TXCCle0TspqQxS2?=
 =?us-ascii?Q?f7glzTNj0E0JWc6SRN6AjNTioqY6he/QfUPvyWu+5C9G1MuInQsnYXk5Ub/C?=
 =?us-ascii?Q?tnwbNKc3w8Gnve9KmX6PBmAk8xBtQQNXeYgv3e++QKRIKiwmcFg7uirwZhzX?=
 =?us-ascii?Q?4ywWo373IfqT4XN9qLtX01zLAsIm6SDwD0LTBnu1ZQCAYjadoegoNrKe6Itx?=
 =?us-ascii?Q?yrj4yRh/+Cxb0HhBXGBcllGHqH5IAY1GN73yUW2WTobisQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?i/HC8Bcio5sJHP6jAbFpLRkEHSMq/ZlNxYCHCYXOphboPkIuazkBc6x2MApu?=
 =?us-ascii?Q?pVGjh6/HS1mmO1Yit9RxoVu2EYjfR/skZ0OghxsAhLwaFytgB2HQiv53sQIA?=
 =?us-ascii?Q?O2YweYtp5Q9nhCmeT5dvcB8dC04b05jtYyZpBG3byTS3KFASLwyyeLs0IgHi?=
 =?us-ascii?Q?MGDoXEvsoRs/iOrLpbenVLQOBNnN+CVB3aM8lRxt8zgBBMRjl1oUNah7CvvN?=
 =?us-ascii?Q?ddjyqFX0/F82Ypd40f4r2oTMvELt82lvLrVW2iASsOb1aLr43A85xc/mob2k?=
 =?us-ascii?Q?mFHjWTMs/yibU2G1YblcYLQ6nHqKgkNxSAme9WnxI3iS0mzvqGWNpei77jdL?=
 =?us-ascii?Q?dXB6/4UUy9gOdGVhFuZFLg9eCDJZsEGWa7BMu72xBedO+r22tXaId3HWtsRh?=
 =?us-ascii?Q?/csoYztsFQDMKWvUCGgPi92dFjxyZzKz/hX/tTnW8Vml2V0PVbZ81FB14r7E?=
 =?us-ascii?Q?kFzT9q1K37UgP5v/MzVCgDTDLAXuyoVEVqD5jFNij7POMjOvX2UmMBuuEXOV?=
 =?us-ascii?Q?l07/6Z26f3ExMHrfeS4brbwMqalP98Sx0v1oy0TYdtrL2//lZM/wbG/qgQQl?=
 =?us-ascii?Q?6+NAgS19YtcPqSkocA1udQX2kisAC+D0F53m02F8zhZDWt3e79cbly8WEVCr?=
 =?us-ascii?Q?iQ5HBYYHraDLTWSR+sgLqRI2wSLobaR6Wsevl3BLSxtST3c/eLVDzvRDnnjA?=
 =?us-ascii?Q?9fR1em5C6ABGU0NzqfdRZ5bq0IwTyKduv63RalfmJoUYSuVSH1J1fisFXpGh?=
 =?us-ascii?Q?xx40rJRiW1Yibjb6anmnFidiMJfx/bMl7FOUJK/1MrOFQvsMBON/6sSP94JL?=
 =?us-ascii?Q?iKzOIruLxu/Lko/lBkHELAFgIgrBsH7pTYTxsckVMWMgJwefgMRq7OxoBnMl?=
 =?us-ascii?Q?BR2sJ53kXbPc2bJB+HpDgaWXbsViGo0QUKAbysnUymPskaxejD7ws4vkOD1S?=
 =?us-ascii?Q?HvuUZEn1Q8pyZePyw9kGL5AnLSjCvKj2gHvs2Rfz9Qbg3v0sUWIs/lrj1hRJ?=
 =?us-ascii?Q?3Cp6UQYgMy0Rav388FnfAwozwxY5Jdcfyfbs7XwOLuKpvbBPGkvoNVDFS+DH?=
 =?us-ascii?Q?wKvBE1I1NTTUVkIVMB1cA6ISkNGX1cEO+uTk4UrQMIUZKngeXTc1CxslRUAl?=
 =?us-ascii?Q?qqH1bOzSq0rYXlk6Mj2/+5mFcmbh1xek3M5v11X7mLxl+4EuPGmSa7OcbPNB?=
 =?us-ascii?Q?sFmkMBxkGmUMDA5VWiAQwMB5qe1E+wjoKV4+gSfC0FobTZH9V82D3QUhMdbz?=
 =?us-ascii?Q?6epNkvKlWKwWG02waqg36bxb02TcvF6S8cjpvFpTOHfyrpKRnFBYV1sorDhh?=
 =?us-ascii?Q?urazq1qCoOuRW85DNr3ruGRtCggNo0UfLckDRFRiIckWFvCQBMl7aMnZG3gC?=
 =?us-ascii?Q?SdP057HN4W5hFed1xeik3Bks8OIbw3giGH9Fa2HYxYNrsqV5GUm95Cnveh90?=
 =?us-ascii?Q?VRpPkGitgA5cFDhw+8otJDNihDiiIIZ2PE+O7Pn/StT1ZV4564gENtMyDnAw?=
 =?us-ascii?Q?t5CrQEHTuI/0at2zj6Ta9X5aq9WsGdpD4gdKuA4wiPaFVEqO6tFsoGjAZWzC?=
 =?us-ascii?Q?zUeC3A31HEmwlfLZHl/FhYNbiccoGQl8E1/3nWMV8oOYJH/t1JbDHxzP7ZHu?=
 =?us-ascii?Q?KQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RVu06PdFntQjvcJqVukIW/MBFHY8oZGh8DgqTyVMqo4Axm2XeoaOhigGvAtHe9Ovoq0vZhx3Ksb+EcxmkeVBR3wce8VXzmlYOLR4p16eJuZgDpgsfwqXat2qtx8551ZYj8EEPdpazsSq1mTy/iOJZ9ys7s5DJ7MLW31TBe48FMjiVvT3NGOrn+oZHqS6p8FCNZXGVxx1eBLXFHa5QgOjzuX9ZfbKHaP0NxsHsRcjfogPgufKmjMAcMtEKmIDmj4rSkyI5uwfg3hcO6z3qtFee3HU9fkFPGbWQIUDI2hYjBrd1uJbuBv+fJ308nHbh13u5JhIxL0CZePpbIahl7pmZibax3QAgUQbRAQdThjKZ1H+jaVfdfaIIzaR40MnLa8epEvg+f2cyVM26+5jW//8C42NGW+++/YC8++uZEsyLQ3MEno5K7NwJIe50H2fDdchEnjmMEdguYOZRqI3SfwzAGy+7kgFnfJrr4FLgoTyeDW1qogPB+JRju2wrX3UHmn9mzLO29RUVybzhQ317VLFvhDMi8/UWUYOJ4BTLiv0JJ+yvX054ZCsyz+5kgezjljdvrTmpfm9ptcnCuOfEX0411W/LiJ55v+E26jYC6k0jGY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8c02fc3-4ac6-4fd4-ed61-08dd15677692
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2024 20:00:27.2994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KtaqfY7bVO3Sa2ndl1ABTDpnJEvP0uIzN7fALSf668t+krjPOXL768HkxRmXRFYFPuF9DWYRE1f9Z5rPaUFaHut5B/z4geul9o0jp5bO95o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6465
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-05_14,2024-12-05_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=548 spamscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412050148
X-Proofpoint-ORIG-GUID: iY7nAvxRxP3AltMJkrP8GdulAiuOLGFe
X-Proofpoint-GUID: iY7nAvxRxP3AltMJkrP8GdulAiuOLGFe


Randy,

> Can we expect to see this merged for 6.13-rcN soonish?
>
> I am working on some patches that would like to be applied
> after this series.

Already merged, it's in 6.14/scsi-staging.

-- 
Martin K. Petersen	Oracle Linux Engineering
