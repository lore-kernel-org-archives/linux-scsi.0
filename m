Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77284219EA
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 16:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777566652; cv=fail; b=Y0tpMGR1g1qKg1kaC6ESLtuLTeAvt4NAgxIL2kQRj8bAV2UgDaF+v9cQ9PXssgYC0wzfblODcHxtzZW3LUkHTfcOkfpF7z4/ATtzFjYIfgEJclLIfBxbd5BAOnWYMgPvbear5BKCIQsYtilKHrDao0Zj8TA42fHQh7wBlV0amt8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777566652; c=relaxed/simple;
	bh=cYg6kl59ZRLGrznb8eQUoXUx1onjbRqmpfIwGvAk2+A=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=dRGbkqUpIIu7ewZ4QXmSCiczWzCCH8WfwPq+Deb+zQXIY/FypP2rMygMq1BnIb3O6TQbzE5sVQln6grQgtb+2AyhArrTuE6MmTIKkQGNdfisen11frZr2wFvOfs1qup6n259kQho5maIl70TYUeSvy6PrNzmZEPOftx73sfUVos=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XgVzGIAf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dfdujlZJ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XgVzGIAf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dfdujlZJ"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63UCfRdD1412646;
	Thu, 30 Apr 2026 16:30:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=pMnj/6cmUKIV8OaYgz
	BVl+wrkJJmWzssSHSPgemHaG8=; b=XgVzGIAflw/swSNXeFBvUq4j+/6y37EJzK
	b8Y3l406AP52P3bGa2y7YNc0Mv1wkPvoflM/6bwjIKUU3SzJPtKy9wURw4JNp5Qv
	Qp6cETyZZjoKbS+L3hUTSggtWkNis5Ocngk1jFo7NchWAgBGe5L4YXJodkPLYnTj
	UkNr6sX6P17hEhHy1V1hMrejpYNwvZqIYYrq8q99Fvm0W8GQWptsvDUx2rzDkdxn
	In3TCwuOH5PR/MDDsiv4XnQcJ0FOhgc3ApMABLTwvV0cm/ZuGQmJ4rCxGSnJ9SR6
	mWXUF9cFX/pLuKMu1S10YkkXV0sQHU/yGREo8RNI5L7xvi1WYm8g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drmd65jb6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Apr 2026 16:30:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63UGQFio026528;
	Thu, 30 Apr 2026 16:30:40 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013059.outbound.protection.outlook.com [40.107.201.59])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2g6jku-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Apr 2026 16:30:40 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BVXcaPBUm75ktvZuomwLRXOnkYOup0QBo6wnzgCx0QrfQH+qyG/oceHhfJUhur+f5DLyfykt2FGLQKL29Tv+++7CyNXMPpM7Zrc+GknMNzL8B9751QjLhvxNxvtPjgBtsCbRpUJYpnZS6R1HVZYOs26GkPsjbWuk9NZJZbI6jPhLldPZ8NiaSHxwqOzhqTKr/e5v2e/xmYIae6pmU6pwm+z4IM9+vxjubjuM7XNlp/R0XiUCrTnm2XItw20Thhl9nmoD5MXKMWgOLrTDb6/NDJSf6SQRsPZ4ZvMerspFgL/fZEI4cOW64CQuLmQkr49zkF/Qpwiet5Q24cTTAjV1lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pMnj/6cmUKIV8OaYgzBVl+wrkJJmWzssSHSPgemHaG8=;
 b=Di+qk5bJja2HxiozKFKU57tDGvWm3re78PcGcdGwHh21WwhTRQW8B1oLjIXOzZwy9wSQRV7G1fnqFh8keNb9XKmtj4Ge9qfPGhRstlyNa/3jX7EneVRZHMQcFzWHWz9WmKG0a5w08Ca0bFbKFQQsOu99pkkplEPiMuM0wcL3JsZtg9v1VRsBE4oy2Cf8sv/FCLdhTmePwXmhC41gsZ+g525L1hFyI4JCzF/s9/I+iLumh+4waxCYy4w8DVlK0Yc60gQZeVxRDeYtJz19WQhFGjW5XhLpl2GUpXg9j7utS46112IXZz1TouC3bBB6AOFf7smkDKls9TYtk66bPp/dbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pMnj/6cmUKIV8OaYgzBVl+wrkJJmWzssSHSPgemHaG8=;
 b=dfdujlZJSQoi/xSzQ3BLxcBo8/dKcu8h1WXzeGj4IpBly3tChytB0PIrvxqGlbSZ/3wKc0uuIGfuqMmYIFEjhBKHqfyzVYCK3wJGR+bXEo8eT3Q9+LVjX2NUX1qj94R7GVFcBt9CnzJ7RfevEb3MWBkAP+OxEgKUFbwfURgNaT0=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by LV2PR10MB997777.namprd10.prod.outlook.com (2603:10b6:408:378::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.20; Thu, 30 Apr
 2026 16:30:38 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9870.020; Thu, 30 Apr 2026
 16:30:37 +0000
To: Martin Wilck <martin.wilck@suse.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig
 <hch@lst.de>, Don Brace <don.brace@microchip.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Lee Duncan
 <lduncan@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 0/2] Fix SAS wildcard scan on smartpqi and other
 controllers
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260421202018.511388-1-mwilck@suse.com> (Martin Wilck's message
	of "Tue, 21 Apr 2026 22:20:16 +0200")
Organization: Oracle Corporation
Message-ID: <yq1y0i4csyi.fsf@ca-mkp.ca.oracle.com>
References: <20260421202018.511388-1-mwilck@suse.com>
Date: Thu, 30 Apr 2026 12:30:36 -0400
Content-Type: text/plain
X-ClientProxiedBy: CH2PR14CA0011.namprd14.prod.outlook.com
 (2603:10b6:610:60::21) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|LV2PR10MB997777:EE_
X-MS-Office365-Filtering-Correlation-Id: 38f66b54-85bd-4d8a-d784-08dea6d5cfa9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	tXXUoQhTvsCpiCe+mUTc02NTAB+UiUXll/X2+4chAEI2HwZSF9L1WCNfoyop479PzVBoSCPo+kvJ232pZkhO8HAKWwA/jLHT1NygfI9uAoZp/rKY3T4Qe85OTeyKjgemiXq30AHP4lmO3iM6qGBwIAyibm9TkHcorIzkfhSmnRGOME+wvV3aZPtfNZ7pbRwo7sp1phgibia5EEw7+F1G5/aQjMO6rt7AK6BAfNAZOOMpLw326HKwy0muJ9Irkb5IMNH5trWYGTnZs7hekFI43az+PYXVPykdzt+R5TAQfqRgbiQk1/DZVJcOJdjqzpa4XzTTLAIsa7wFW2zk0DZ2NQEGdqtp64fncIYS4l6/5J2TcUJSgO325z0A9QUXDwLkw9J76wSsvU+A/OIZk+U468MjJeuo5YEgEzpFiLMO5OQVl+6QO/RCkZq53JFLHTmR51wuDwb736UhurKA+UYKmSsY7li48Y0uTOun3U1+lVf6OmkDtEOEMzV+3OF/CrKOPAkOEFDDuWbukOV3gndR1OMueZektdUMeXlZeHW2lpd2OaLh53e2kAKjpUyBK0ZzcnvUZFrTtA9y5nUcV7DvWfu57I2d+/TZZNFWw7ctRwBsxpp9g5lnrchGQrdTHMVvJIfJnIWwA34oEdeho6F7VGxuaek5xAcjPFG+hPY3eZ0AdZjaeaP9gtZaGgynyt4d
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?L+EtincoAUqi+OlSd8qSirilnl1NJC6DYURnJYwUZiJC78BwsdM9R2Hg5N/b?=
 =?us-ascii?Q?NvSmYEvnyWm0mY88E/tzeq6H1WBNvl4BJy7niBVMXQ4SwppcAG6X7IxNgLqE?=
 =?us-ascii?Q?nV4wFj+zzGWp40IfmURNa4mQwAyN2y25l/oxYeUILlW9MqDcCsmHL5ZKN6WJ?=
 =?us-ascii?Q?gUU/9vnYbGoull0wyUqHKSYqBFy6ogy2aeZacTby+6veGPUgzNqf3DwSAoOg?=
 =?us-ascii?Q?hVsgOiNAHOTN8L6cPG6ntK9lKNcqKec+D8KzJ7sidJBFpIvwvQKbFmZ7o4yr?=
 =?us-ascii?Q?2N67N5XcdXXzWd+Y/rXWXQKXp3Cow/OoPTU2nptnYe8Cf0+RdqFzwuCY/gCY?=
 =?us-ascii?Q?Ghuu0ivBBVoERuAABVefcHMVJC4bIlKYWPOL7hUo8Bm3drePX5BbNPFBahNd?=
 =?us-ascii?Q?xqrcAnbBrVQxwx4pvQ67V7JxHAJ6OciIkciLJvgwc7dU8R5KFleMSEPC1ovE?=
 =?us-ascii?Q?ofvKcchQnICV09MwFYUSZhbjYNOy1RsUOQPly7fnrsxuESPbd8Yn+efYNLxV?=
 =?us-ascii?Q?Es17QwUFTmTe/wuq6u9t+xgVQ4Vh141Qth5rKvvkPlFtM7+MJKWicqE3azkY?=
 =?us-ascii?Q?tmwiL0hXumi+X/UtR2jYfn/qw/OWbJ+SiUB5vEnAmzUDJAWKqKs7jl93SCE+?=
 =?us-ascii?Q?Zx6qGVIejqLc2rOC0EUwRZ8dWl6wGCXs5dFWkCSb5FwCGD+UzDtLU/uln/4N?=
 =?us-ascii?Q?q0w7hZblul4zldeTn7QC8yXahTzw+N3sPjs2Av5/+Xfp8VwV3hS74cmGgq3T?=
 =?us-ascii?Q?+R48eJ6K+931yM5l4ERNUFKDTYrJ290FVKTaerRACiAhBgxub7fyJGNrxZPt?=
 =?us-ascii?Q?0rSuEMCzHG5sJ1wYWquyVppRbn6f62z70lDhR/2qqc59ZpFUb7NwEtB9K3n9?=
 =?us-ascii?Q?xAdRy+6iJrWWWIzu6C8Fk7aOBlWJYpScBp1FhbKaqlYUeN2R5i6gRXSSOB+3?=
 =?us-ascii?Q?Q7JnA/8pG5vD2UAWo8PhPV15EcYDjmpPf1UNUeR0p5OAQ6pJ8rg81cROJuF0?=
 =?us-ascii?Q?K0KXrpdSc5bzNFqVsnS7kF2yZzZ/SEdSCWlolEYXqYFxHegYHfzVXjKNZXNk?=
 =?us-ascii?Q?ss9MWH0PhpSvY2reJ4EP/rpVHwIfdVaUiGZplwYzXtw5B8OXdsbfYibh8UYl?=
 =?us-ascii?Q?H1YpO1Ujjd+11Iv1zwONfdWwxEa3JOjE0kPJFDt2wASVWlO8R196mlguDUGR?=
 =?us-ascii?Q?mBVmcl/by3Dk3rbhpco3L182lPOeXoEbXiZXzV2mkD9Qkx0CN++6GEAfBBqi?=
 =?us-ascii?Q?52HN12CWK35hbSWHDnh1DwTWq4TUCLNXJr8MdrVJXhhh5B8bl8x1ViXsOnCi?=
 =?us-ascii?Q?7fBueQHPrFIvDCFs3l9Nxa0XK0VSEKZwermIVwbGtqiHYKAChWNesahPKOIT?=
 =?us-ascii?Q?ATaujbYxYebcn6kKnZO+iBypYD1vva/gv8k6776mJ3TlFpl8wI2mpJ/F4130?=
 =?us-ascii?Q?BJPWHZ1xjf1cvroNiY3ssB4T/DN/KWSm1wvuIaPiVFA+KWMjuuXtl8Q4wqNv?=
 =?us-ascii?Q?n5+xhVNjkbXodccdZg0nvnApEKVHe6UEsHVtMx66H7ErPrFVCvJWT42N30x0?=
 =?us-ascii?Q?9sfTpLkhibFTQ08hiMHF6AIYV0Ola6RmzvVN594SjLX6vA+d57NysDqJAxf0?=
 =?us-ascii?Q?OQy449UUsSjNpaIft5/377alf2PEZMYDIEgh2+HRcr/3AT8TNDSFHckEJRQL?=
 =?us-ascii?Q?OzB7aoR8GwTkLXCJD9E1lvo2s6OtsMHTbiDuxA/+RDRaTd8DNkAvTIpNRHmJ?=
 =?us-ascii?Q?Jv1pKsBxBEI/1wmycGZePw+a0KsJclM=3D?=
X-Exchange-RoutingPolicyChecked:
	M/hwk1vyWs114I02WbMTjfGO6sFD7hZn/AdDIecp6FmZ3FUE1pDeNy6nRqLggYEK6etcsTUD4sCEkV6a8C83ox2CVDjq+IxYv6bFUaf2lClHOfy3M0iJQt7mNsMqvdDFBM0zFQjekno9uAw3RlTQf3gVgdT6FpDpSh17+4YGZYRIdmYhcoc9tp+wmvqI7R36tVttrMb2nXyeNHXcQNrW/CLBl2waBpBgPKO33nVfgqkr5CAMEdlfGwc4qZgQr1SwiXW3QjV9f8PebYOjky33j1V5G6ZQyq4AfBe7/2spiLvcEErv21oFp4cCs/ZsUICtyeamk6g0fvv2QExzgo5q5g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mOWbn61rZ1ZKi6gIitARY+l5Ke01aU2QwbYb0+2EIIcqeBRqMqYoAtQPH+EJyP1XYSgO/gT8UT4mt7Q6f2eXEGHZjO1iZyPQGDyvmFKv2o+92bbiR9uzLVjYqz9VpxA1ZcdKkjuPkPJ+ps3r6mqBv5H2ZbWptt0IqLi7NtrnVcVuCSnMnGcZr4RIs1FncF7DCfl5o8m9h/ub8t1/X3sjrfRNmsRaaa52WNj9j6Dpi84LgK4rzNJPXsRgbPkhX9rC5lvNtZXZFMl/y/cPg6rdybcwFCAR048cgGJXFIsW+nVLszgU126JOxCb5gig5cl/YMhaOVXtrRGMag3TrngOdTb/s1gOAb0DI8sGs1hu5WIV2jl2QO/Nipb0WY9RYGr44RVWggGXq1u7MhGdP5KlfyYszdYPnIo9MtkVKPKqde0Nf9ivQ9T13Cu3PcasefZeBQmqHLhOV0TWS5BlW9EH6499K/V+e2E1Xkod/bItDvBrQqpTH0b46xu2+r3QW37gmzyXN3yxKK7hLWMt9vKRftfxHG+bt46uwVjy1FMmoORwayr6CbFk5nb1lKn3s43pLSiEpPsnhVLo0ylFb2DaYYjMl6APZKQZPM6HUxREnzE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38f66b54-85bd-4d8a-d784-08dea6d5cfa9
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2026 16:30:37.7477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BgJDyPLQ2gwHUfrLTonq+iLb6tYCLSCUQKUxDCKHG0pfbOKEH86I05fK2g6AaMJS1oxiPBf6VFWEVVOmw7Vun4ZmJ3B8GpaCnE8wVpP3KTw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR10MB997777
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-30_04,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=599 bulkscore=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604300170
X-Authority-Analysis: v=2.4 cv=V/VNF+ni c=1 sm=1 tr=0 ts=69f383b1 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=c92rfblmAAAA:8 a=iox4zFpeAAAA:8
 a=F93EH5SC5D_5tLWvI88A:9 a=GvGzcOZaWPEFPQC_NcjD:22 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-GUID: UPip1EIrw6PHg7h_HhRxNbrWIMAJWhQn
X-Proofpoint-ORIG-GUID: UPip1EIrw6PHg7h_HhRxNbrWIMAJWhQn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDMwMDE3MSBTYWx0ZWRfX3YOLYkSD341p
 Ds5DoqPYB3kozDOsXk4PLuX1Ox4S3bV+4v5t3EoUMVOSUIu2LvatuEQNvngDclKVOXxk2b/xkbI
 Wr/8aAGwVQ2Tsm8s6BH7waQEnVHbc1ZcvT0eu4VlwNrItuNxYwreaIGNzpARYhfTYfnJW2Kc9Xv
 2qr8DjhJe7U+kqw8n7dIEqzwcj4TfiEvO7/hy5lazRgMZIXlEgvA7mSSx59HoQqiyb+laLzH8gE
 aufiM+6Q/JgroW5oyEiqAuvJADrUmVoVlga5JfrT7ZCxcJGyHvGtYns/co6HIa3F7R6Gz65013R
 BQfYGSDOwDo4OUfz0DCVrr8006OtMYQ8VmpFlZ1sN/F4y6eZkub+9SRikyK5ijG1XxDArCVa7EK
 ylO6ecyJl/vCqBeYKqIx3juG66FOy43aQCMQNGKfK1zoNI7Xk5jtCb82S/SYbH8sOAWqCrc5qQx
 B4KiHK6eBOU9bA62XYQ==


Martin,

> A lot of SAS drivers, including the affected ones, provide
> scan_start() and scan_finished() functions that offer custom,
> firmware-assisted scanning functionality specific for the driver in
> question. The idea of this patch set is to map the "wildcard scan" to
> this driver-specific scanning procedure if the driver provides one.

https://sashiko.dev/#/patchset/20260421202018.511388-1-mwilck%40suse.com

-- 
Martin K. Petersen
