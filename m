Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0995917335C
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jan 2025 18:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735843857; cv=fail; b=KqH7JSTmtgubpZNJLErbVCtSferyqV+tVHk85p1sLypcNZ657ZJt7nyXw1Y3i8lIdppTKQyaeLa46hhak4rnpL9zzcDemo9xWHZcY52StSFLPgU/jQFXaP7LPMiXT/gZE0ig5VRllAcvOaFSjbUr246p4u0Wa6uv2vN2dkejn0c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735843857; c=relaxed/simple;
	bh=TzlZNNHWQW3RqWHkBaQhPXgRmOQKnPXO/yHsY+M8AZU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=amMbWtwP+geMtPJN8W9QoDd2vSzWXJxHPkRszWORx/2L65ixJjeVxHjjYvP73CmW9ArvORgHYJszulkSzNOHGwDKGCvagM3Emsa7TJNOKUofhon55140uBvK3VJpmPM3S+RaZceLBDM69fA7uspRZvH8sY7ypSLoBQE2eDkjZbA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QMxXNxeg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=soDMhWWY; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QMxXNxeg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="soDMhWWY"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 502HXsPB018959;
	Thu, 2 Jan 2025 18:50:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=2hb4Y9te/oEgNTV+EB
	JdIYo9SChMCykw/n7Prfu/dsA=; b=QMxXNxegnrE9nwFi6s4MWaxw08I39srE6X
	AN/Li9t9kmW2TfmrpqpLdF9XIfoA+bPbAMKBTmB4IH94meO82/AEbqrlu5y29/6d
	sw6Q/hxA0jxA3n8QBQ+mE7BuZ0W5sxGgoRcvFxpo4jYPVNswBARREFKgx38aCpKM
	0lRY1C+2kAQjNtY96eEszvXa7dXts27i6kCUI2jekRAO6kQBTRRZUon2vmpx6doU
	7rSE9mNk/CFuKMZ/zmI4gxFL+6k0EYeopWXSk/CHvdyAIfAintb/AcQn1z4EW+NF
	RG+ip9ZwvMtz0Qw/Q5B07mWiQzGonhbwiCvGqbbHdhY8rGsz1/zQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43t978pee3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 18:50:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 502HJVcw008518;
	Thu, 2 Jan 2025 18:50:49 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43t7s956fh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 18:50:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xhWVhY81dSeXJgJxHi2bOZwmJxXJAfvBw5KoJdWfZOWTi3OleafqExqmIG+uPfUFBkQjSBL1+2R9Kft7rItjR68VjcDra4l8HeSySeTmb510JQNwmxIc2uyTejrDeGSUuVGlKED8E44lb7GPyC3WMeQkKFW9BpQ/WpPuulmt3JdzRMPBHnj8T7Tcc7mgTQn05/uhOKuZUnEydQCEfOrQQc0HMr/YWJRB9b8C2fDnw5l/Tw+C7SpXzqDZjxS5IKIcSWD2y0MuhiCR8hh2DThBGZu8ftT1WWKV1WXzZNV0xKyOMzEetxG5bpAkEHn1/TQPT9Nf0Qz1rhHLziDmdimv3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2hb4Y9te/oEgNTV+EBJdIYo9SChMCykw/n7Prfu/dsA=;
 b=G/CMOSiWGVfjnyz5p21eeG5ymL9F/TBjAUsngXWL9txLkWVAuDlI1FfpfBLUi94/yv/B/u97M3MXrHACuwQ99AbVd/jUzWCB/jUuBBT1gKVKsBN48BDTluArBlojjXxCDAiUjnjscEwFXAlEaXVDAfvo7TycaZOXXOGR7iL5VgzlL82Xtpw1pTGE3LEzXndHvqVMI2HWWFxb4BsmAT3GhKAJp1koxb3ubqZgNN78eTf5JDGCaS/nwXAxGiEBjMwat+NrNQtY7+NVFhHJNMLL0sVbRCvzuHUFAmFJESOZx9gAOjAuZA+eDjQy+l0stdpfO2p+kgT5x2nwmnDuwbuElg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2hb4Y9te/oEgNTV+EBJdIYo9SChMCykw/n7Prfu/dsA=;
 b=soDMhWWYAmo5+4zQS4xqjKeEdOPspFVErstildUGTxSija/ODvcZY2Lg/x/U2GYbh478n+e7yNfjOdd8TWl7AWlrUGW/UYTjCEG0ilrK4wKby98ZFlo3/wyhMYng8I7wyckcgXr3dARI1J670uYke06lhH0O2A9gLl400/qX/0g=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH3PR10MB7504.namprd10.prod.outlook.com (2603:10b6:610:164::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.14; Thu, 2 Jan
 2025 18:50:43 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8314.013; Thu, 2 Jan 2025
 18:50:43 +0000
To: Ariel Otilibili <ariel.otilibili-anieli@eurecom.fr>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@kernel.org>,
        "James
 E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K.
 Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] drivers/scsi: remove dead code
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241213225852.62741-2-ariel.otilibili-anieli@eurecom.fr> (Ariel
	Otilibili's message of "Fri, 13 Dec 2024 23:57:29 +0100")
Organization: Oracle Corporation
Message-ID: <yq1ed1lf3z1.fsf@ca-mkp.ca.oracle.com>
References: <20241213225852.62741-1-ariel.otilibili-anieli@eurecom.fr>
	<20241213225852.62741-2-ariel.otilibili-anieli@eurecom.fr>
Date: Thu, 02 Jan 2025 13:50:40 -0500
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0409.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::24) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH3PR10MB7504:EE_
X-MS-Office365-Filtering-Correlation-Id: 96f9cf36-981b-48bb-7ff0-08dd2b5e5c27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ivJfhyrpRkkmnfBXqdYbdondyCV318H//jMMDgdhfUn+ECVZfm9/lRGeJd4A?=
 =?us-ascii?Q?RpCQRnu2d3VbkQf4Ay9KOIcE9/WyINkFXfmyechCVowwfG7WzYuzzbyt4ipN?=
 =?us-ascii?Q?fsnEqXIhfLwVP2yi4SEtvT1neWJZezF2lZEB47lfi3gaWgBfi3rhOOQ6+y8y?=
 =?us-ascii?Q?hgEdnSinqYdHVJnDlJ1c2I9bVAOS7Jo5UlaGhUp9HgXemFxDVv1p/T9T0pd1?=
 =?us-ascii?Q?2xc5mds/Rt2caUg35DMQCPqy8i18eg6UI3B240EzChQst5pj4EuRVfmiGIgw?=
 =?us-ascii?Q?jK8h/7UrqHdTOTuaFFESqlDYL1YAsPTbDydqbW/vXUwdBsg/DotzsHxJGkvT?=
 =?us-ascii?Q?Rs3D4j4+SJveQRM+LuBairsK++rI8AZgC+YSeUSt0xeOm0Cion88ObQLpZqG?=
 =?us-ascii?Q?QLFWhntPkWkZDYEeLOP8f1PiqNkvVvdBCLHW0hBfRYBWrajSMrAfImCKey8Y?=
 =?us-ascii?Q?ahP1r5cTQ83iZpJ6v3561cCU+o+jZmNh1myQonsKpf5+UcFX3lzYdVoIirJg?=
 =?us-ascii?Q?IM//sclKWA/7SnFWYX4t0qbZrv5v6otg1vwIByGxkctGEcAw0m5Yij4tCQ81?=
 =?us-ascii?Q?MhmrjKvVRAHLy2XCxVkpVA6czdwSnxMpaccHyDEH+Oz0J8Tz9L4DvuUqa947?=
 =?us-ascii?Q?caQA4QauHAJE/D5vCOZR4fuJogShf9SQ+tqHX48JwCMyArx8qSOlVLd/zEAV?=
 =?us-ascii?Q?mwQiKu5P4P3ekPNPStovOMA15JSYEpEOrst0wemidyS/Y8LXqSLYpzBleLpA?=
 =?us-ascii?Q?amiAVIfVOV6tx3pN20hirTi21NMBtSvBC1dfPNsOUPaIs+A/bk1vIYYc1hR1?=
 =?us-ascii?Q?zvqAYhzdgS9pWTkjyPxMGKIEydViFc9OK+MScCwC5ZezizJWA/NZGvSFXUjP?=
 =?us-ascii?Q?1qmblNls6F66puA6r7CexyB8NzVA+a0/IVxl3+OUl/tmDVRQPTo5MGAgxw1t?=
 =?us-ascii?Q?Lb2FavAxbjFx1xyHL8p6Pb7fywUgm/u6v3GvKlw44UsjK7x+7DFOFflsV/iL?=
 =?us-ascii?Q?rd+OczIiFlgjl5O5USptAM8NMOdTTxYlZJpedAb4flk7I0xoUEHX62rm6UoO?=
 =?us-ascii?Q?2XSrGagsI1hHCthFtgv2Da1OQlgm/u1zuD/TIpJDmvLBy1WYYC9YQci90UWr?=
 =?us-ascii?Q?xheLKab/7As7Y0n+Mf4OunRJ6BKWJZkEVvm6VAkzHdvZZN+JXWgSvIz2EohJ?=
 =?us-ascii?Q?TYZWtNDAsDLdQEfc+6DgogLS2raGrMoc0ZWa9C3FIVl9BtvSiixw+vxgEalI?=
 =?us-ascii?Q?+ecC1ZDxG50RyPNJ+Kcw799h631rxZX6UDeFc3N7ZpyCq9IFJBY98p2TYuZU?=
 =?us-ascii?Q?zjdiIzTLmzapKn88hSExt5k2w0kBxeiRRkAo52pyFhzOuUty308jGfXEekwF?=
 =?us-ascii?Q?0FxNgR0fpT/A57JNxY98D9dqSXhA?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2+o1tbnUkLSAlVASQWfoL7P+H8rGhvgsn0SxqENa3UNnjP+ya2BbKJrvUEgj?=
 =?us-ascii?Q?SIFePC4Cp0ReLZzmDunGR+c8T4rn3eqiIULCcNiDsztEFWuB67/NBB1svxp5?=
 =?us-ascii?Q?XoBHZNMNsmHguMzsf4TyE6RC9+/ziBbi+FwXEiktAHwY2x3tQeUuJUKwN8d3?=
 =?us-ascii?Q?UfSjyayF8GnhVW/68IqkUGjJRgzVyweF6xeeSGcr1NeRB30bwHPJgl+LMHTm?=
 =?us-ascii?Q?5LNI2yE67qyFdD0pzCxTorUA3Myk227rUz9pxTEibBVomyH0zVHO3dDc94Jn?=
 =?us-ascii?Q?GtPKU8+YF0uDA7oMNc1u6jK1MRK3vUyase5JXVFedA/ICo3pAJ7wXBtxeCkc?=
 =?us-ascii?Q?xV38LlvzfjnKDj/xBkzw0fN+WC1pdxH9lH72ynAsBvGhumL8A6mTjctgIXuR?=
 =?us-ascii?Q?PC9y5l2NsNMU0onNCkbCfjCSzGs+tye0R1gDc1189P0H6b/pDgMqY77ct8+a?=
 =?us-ascii?Q?bdEvDOU269VHc4Nbyj6FbS/rSQszQZOXbitN7XO2x/0PiAOeAnJbnqX2an5B?=
 =?us-ascii?Q?fac4rz7P7zzOtxdk7aAGna8mtBCJ6SidsQ/NqDHDL/RlX3CwZ1itkeODaFDl?=
 =?us-ascii?Q?5Wt4ybH5AuKG4fyUzwFecCleo10qObg5YQVQVia7qzU27aG2kfCb6jCBMiYp?=
 =?us-ascii?Q?r3WeEnIEKWYYv1eEH9qpFdiD8JPJYR3CmHVr0uCxfXB2FvkJfpx15qjEhJbT?=
 =?us-ascii?Q?WpmT9TWMfFLHEE+F2+xuQYy4XL5Ro8C6g51+n2rn+UJXWzgPtKeuyK3XnCXZ?=
 =?us-ascii?Q?cDrLtLOyHwgZbnBjE8FOq2TNsNgodfE7uwC9ioMPfTm2F0JKLhkr0AZOr841?=
 =?us-ascii?Q?oHkCOfgQAMnuciA6nZ7Eyu55ZOS6B1BMBJMMC6amEMQIl2GaSNmD/W3pQJNh?=
 =?us-ascii?Q?Lwy5dDbeRn4XjozYiwp6wPtv4Zk6eAZwA2gs7JrL9icuTkxPxiPy9BY9sckd?=
 =?us-ascii?Q?wy9IV/pwLBZalxLYxTwZs41Dy9LVnzn0biYafm45jTeiYoJJZ7/rhm/kFR/8?=
 =?us-ascii?Q?9qZsBtckjUr+OBk6ke39DlCWEy0c5ys2Gmc39C5dyCjrjdtO+UUTH1jQpnfP?=
 =?us-ascii?Q?2navs33SAnb2lSlq2jR2Sy/k4aTYQeUPGZ+Gi2WiOjj9Py4hyu/et9C41s8x?=
 =?us-ascii?Q?LnPlBujxHCfxpw2MkBUvUetwxmlYRsykPgc3LP4oOHciZYtw3AFUFVlKg+Ge?=
 =?us-ascii?Q?qQG344bCSknPa0so0ma5xyS0g1y5mEbWjb7Y35XrgKHRtnLdis7pp5vgBh+x?=
 =?us-ascii?Q?MjdmXrWiFEWxqfTvy+UfqGO0WWaTiB9WXdUyFOGqN5xSEgPAJdvnlCzzeTgU?=
 =?us-ascii?Q?/tHPky9ogvutAwt/bHekWoidtZLIRoLCmY/Kz8RqYSsDt8GfbaGgdjeYd92z?=
 =?us-ascii?Q?NDD/OrFk+t02aIAKNcJDDL5r8KjXCUG629+enAIeuI0A3nXNWx+kVLrXhQwM?=
 =?us-ascii?Q?MAjcebHV2Kuo71cLxAO09an7mLCyOX/Ahr4yI0r9WX5u32sKUcgcg35r/6T9?=
 =?us-ascii?Q?C81vMjFwFgNZb43363vViQdxuiW/Y36Dj2Ch0kIFJeOoi3tuwjkG0X9R+9ch?=
 =?us-ascii?Q?ojcNVUR2Yanbt4fgH5tIKOsdFssbsJf5eYCqdDGVR7zdFqmFVh1HpvO7GZTj?=
 =?us-ascii?Q?vw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	olt3cQISEuLw7PvGgRVcys3MRriZam5JDnb7426xLeFg7VwBqLxqPR9Z6SF7I4AshqtVSd13dPsM2go89KaXDlW9VYB4FGyq1X+e5giEC9oUg65TD2naXWxkynpmYd7IA2iP3tJ/N33g/080nTMQJM4qKZSz7s3nALR0pv/FuokP6xeQGK++P/9er8P+LbPivRnIAatxTqd7ngIGH1ImATqVwa754ODqYoFG/FGnG9uJG4ghIyjTEAfNJpyBu51BpuptTHPqPn0BIjNGRtMzgRXMywwgAo7nbiXbns5iYW+1Ox95BPEM0H3gyQooOu9PI4nIhV4hPP646Z3Ofly0wAfYIPws/pB6sBm8uzjSkBeKRGO9mGouVzzokl7GcotjGRzTUst84dAEyINE+8jF9TNOEtCNwJcPn0l6a4W2y+9QdH3v9ry9smr99fjLqP1bGE9vztcMmMuVMr389nf0LXuh9GGyVbeIICvZTXwuQQbnnfoG6nC8qemaLCQfMyCjS8/cq/5+L9zdQ4K3HonI4Q2gtZzUa+gn0gYfBldLORY3UWBwsV63biGxBucg4KvJ6VLBqZie4OBAhgT/KI1UnwbEE6fWXWf9Wfkt0x1S5cU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96f9cf36-981b-48bb-7ff0-08dd2b5e5c27
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 18:50:43.0716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fx4BnSuJG2JC6RHlo4SG10T4icFpfEOGYl4GjSeJhliYpp56JQEgMX+waPyOaBeSRHm45qH3mjkdBTe2fSUUlYPziN+rC5OBfsFnrUwR3fY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7504
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 mlxlogscore=633 phishscore=0 spamscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501020165
X-Proofpoint-ORIG-GUID: 4oqX3HaV3wikcOb56GP0xr3aEgLBSaoc
X-Proofpoint-GUID: 4oqX3HaV3wikcOb56GP0xr3aEgLBSaoc


Hi Ariel,

> * reported by Coverity ID 1602240
> * ldev_info is always true, therefore the branch statement is never called.

> Fixes: 081ff398c56cc ("scsi: myrb: Add Mylex RAID controller (block interface)")

Per the Fixes line above: The correct tag for this driver is "scsi:
myrb:" and not "drivers/scsi:". I fixed it up.

Applied to 6.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
