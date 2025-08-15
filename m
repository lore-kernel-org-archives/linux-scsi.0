Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61C4274B59
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 03:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755228462; cv=fail; b=I1UwHIxmoRdzEx07Tb+pbayRYCF0lls1PbQGHM7AlUhizB7y+7ka73T+VfvXE4Hxvt3VrIomn76+ATwTywDF8Zis9WK5X0fdErBzZpqqI1NxKX9c5eyycjEOSVUGqYwXTv4Q/OCICjawUEHdlGNa34Y5duEIB0tBXwMwkAsttBM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755228462; c=relaxed/simple;
	bh=6jWJJMhG8W9xjTZ367b5c/h8ILJjeNizHeqIVlSaZ8s=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ARMDVIB1gnWklVwAo7fqIMuYOO/xVb75BwBXgbFwsU+g2UwHHfZrzfgG7kdq7PjHXXWgcE+ke4kwp+QtRAZNQMmT1CrFuN8fdbSTXybhpRKkYVvEDNRL5/CgIOGo7w03OR75rTlKgHzkUY0v7W0oqW3vJQKo60f/oK7oYWRhdCc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZCHN6kI6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mCoUZUZG; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZCHN6kI6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mCoUZUZG"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57EHfqnK025412;
	Fri, 15 Aug 2025 03:27:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=yodVmcCaZT+ZzzYf3Y
	afO1Hx2Fdg6qDz3UuKTf+DG0w=; b=ZCHN6kI6J/VjH96kxQ5q44FnxtEm2mUfiG
	qdb6hHUTA9gtq1O/cJw7ADzMfr4zXpZ8YpKuEMoySUZ/4ttqxEvYy/uSTDKraTPP
	AW8wU+0afW2AAIpO8zlKto/1cMWLhnSEs4a0vjymdqjNpIIhAmOEhWax7MZGEa/T
	TZS0YHca0m9kz+m8VCS7r4+l6GCaUQRbuiUrCFfen1QZUm2K0FG36RWo4L802yoE
	WvddUiV+JLMq9Q7Iipu34yQ6UM6+8mRuVt9vxdj+Zi3Go0S93yvyJeUFCVFC6Ga3
	ZNgBQwNNhGwaOdZmNepMrzOhFjNAxrJfAnWKgW722GxilyOiJATw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dxvx379s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 03:27:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57F1X529038739;
	Fri, 15 Aug 2025 03:27:33 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsm451c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 03:27:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FxrosQIOPcm0eRPZUyqC2nJk5QOLSXUhcaYO572BXJbqruvmcW5PslPcfswMzbefFECvdTW/XssE/Lcxg65QBziGx4VeJaPijJtljW45f9KJ+6XrbG1DWrCotSpCqLey0QZrdOYC6ZsvLJ8aEU67EZrljKdDjZUbVi090d4FtWcAFk44pOQO3FFFypoOnysjjDyXRbOW4BMUN3l0dx2y8IFeElXv3R6vdVyHDULVD2zTNhKfUK226WCiIvlzc4262DIDv1c6x65KRC1u2IZu5MLyyW4rTSOCH2Lh2mjGBSv4ijGsRGuAXlLqY85A1ysl3vEAFMYXSyXPgwbUIFclXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yodVmcCaZT+ZzzYf3YafO1Hx2Fdg6qDz3UuKTf+DG0w=;
 b=luooUQBdVtvT3cmvFjiQ0WEa5nefAfe42rR1afq5QbPPxWq8QntxdSTSbqPeuivHzoL4WoafCQBcfB9b5MjjzNtTNlcPTZu7JUW35vbitEtCRElDT3yyGbiUaju7H/PYV4tc3C9xE+hJnwbmo+m+wtq983fO1AP99TofNjJw1zO7FRPZwaJjZWQer4I/9fpWxBx8vnSDQnzhqcRK+s6MJq5Or3ycsz4d5mk5Mb/oifS7yixcgyDf/0YHgRO0KZ1NxbMnraJC+5luyoDptM90lwdF5rdzpySlhiYbGqB5fT1DFbe4saIa+zlJ37Tn9/nPGsOugNWPSaeSIIeX6zi9ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yodVmcCaZT+ZzzYf3YafO1Hx2Fdg6qDz3UuKTf+DG0w=;
 b=mCoUZUZGvkL0oQcBaSva2fq3bb4LCTOmNld/b+jpo5M5Kk6haYDMJn3NytBVHG+olGBPyvPI16lPcAxpXCoBEvawp3RegiC0WJzkOCB/NHaFJUFSCAEY2m5y3WJvJeo4MV5uzHiwwcYcfxcHDqFHU5mavgLKhObaHMZWLSTcFBs=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BY5PR10MB4385.namprd10.prod.outlook.com (2603:10b6:a03:20a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.24; Fri, 15 Aug
 2025 03:27:28 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 03:27:28 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] UFS driver bug fixes
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250813162253.3358851-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Wed, 13 Aug 2025 09:22:34 -0700")
Organization: Oracle Corporation
Message-ID: <yq1bjohqn97.fsf@ca-mkp.ca.oracle.com>
References: <20250813162253.3358851-1-bvanassche@acm.org>
Date: Thu, 14 Aug 2025 23:27:26 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH8PR07CA0030.namprd07.prod.outlook.com
 (2603:10b6:510:2cf::16) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BY5PR10MB4385:EE_
X-MS-Office365-Filtering-Correlation-Id: 139bd4c8-b4f7-44c2-2766-08dddbaba95a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zKBx5E5DlB4UOqTXAk1WFndz92VRu7M2t3OHTLn4BSwLaCBvouwBKs/oC2zB?=
 =?us-ascii?Q?mFn6PHG4UoggXXgAYkF0wyEP/6HsDpRSeQ6YQ10bbfvKMIcSr5xEq436jLxL?=
 =?us-ascii?Q?yUFuVpU5pJvFjrtZBYRxuxLFftyYpYn9DuCUWTHyRtkD370nK7rFGxWI4XAB?=
 =?us-ascii?Q?jnaAvWXwzHZiF7V35teyxnkBHia7XNPy1vkQWwodDIUFj+336T0266XXDPqu?=
 =?us-ascii?Q?qxaztEXg3sleBw9aev9jltscbqiV5WESlEngXWl0VDZd9nEjXMOMo6mHqkEq?=
 =?us-ascii?Q?USwKD9pdIkwniaekRXA43K4nwRB70IcBmA2Omw+rVam7mm4SxTdn9X+mv+80?=
 =?us-ascii?Q?7s4v+5jg3dou4++p0KNp3HrZd2TdG/PbZ1X2RkEL11BtsdnKrqABjkILPex/?=
 =?us-ascii?Q?y8He8YD+0kP+23int36tF0y+GdqmafUJO5INBMcD1tAp4WObk6Bgbet9QQIz?=
 =?us-ascii?Q?wfhJI71RA4RWG188veaMw5pN/i3B9/8cZaTVhYZsmHmljxCIDdjdZLCyV3C+?=
 =?us-ascii?Q?gaRHxov8P94f/5hMbyKNcV8jWupZLZxg3y/is/WUB8Lfe3DLKkbyXUPrjVgT?=
 =?us-ascii?Q?n18LJcd3sWmkpWMXIC9SguifaMDalw5Iw/YTPzeekfM8NidPS7m9EGH7Nw45?=
 =?us-ascii?Q?DZ6x/Z96bMgXtD0+16YrbDcNKsb6V55inGV0PqpmXGgSK3WsURaLIM2HiJAN?=
 =?us-ascii?Q?AFh1U2vh18PTyBn0yxrwea0UGqzMjLtYI02GLnlEaqaNauAXqFkiYNJ4uHtm?=
 =?us-ascii?Q?FfQOhuTs1KR21Jy2gfwNYAJ8xoKFayGuishsfG+uqOUyVBiCsFEWYAIAvcpO?=
 =?us-ascii?Q?b3G9SaVdmKpLPM8o1tLaxn33V2rkKol5A8z7QrNIg5CxBLSROnS5nfJaxeLB?=
 =?us-ascii?Q?85C/B6QJIqzEAtFmzNMCwNt0FNOXCB/W/mYWHHiz5vAJWRAOZ3xZTZmJpXgP?=
 =?us-ascii?Q?5nrIlKjQOc0DEhOXYbiZaEaTiqNPoihlrYKoJt5AM6E9Wa2URY0Eft1hL6wq?=
 =?us-ascii?Q?m541ruc0M0o3hhKBmGHD4e4msEkd1YSNXajm75GEwWGvN4Att8NiUOK5xXpx?=
 =?us-ascii?Q?u8RBvjRuEk6D7HqjPN9cv/rwQIdij/DZU927F4M2II35Bb33ckzUKf8y0Hxk?=
 =?us-ascii?Q?P3ghiO0664O8WV90mg3b1rqAjLtpv73wTqHMPz/eJ3iKRfDgqehuDNs2UDVL?=
 =?us-ascii?Q?ilJPyzr1obXlC2cvkqDS/Wi4apk7h+aJjFZPh7jCL3gXAJVR+jfashn2IHUF?=
 =?us-ascii?Q?f0ctoIzD8dtnyZ9YaONJdCVjlufOI5r2NshNa1tp0Y1N+qhjwaimGAQmvKfg?=
 =?us-ascii?Q?x4QtQbp+i+MJM6zc68gw3ZWKqdjTnJvik+I3SxdkQrWld6wfdLVqfJo4LPyj?=
 =?us-ascii?Q?Kut5Wr7URuZ5pcv45EmZ96BfCPrAq+RBoipui4lQ4SN8GbA7jIy2LInCmX+l?=
 =?us-ascii?Q?irRBQIhtBIM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zg1S0FRj8WYlYVNvLCsCeXRnKzISNaAs+OPVN/OgwNvP3hOcwhCqCZQr2Li4?=
 =?us-ascii?Q?hlApg7GOsdG1zCE9+sy8IWvAiJv6dyDeoqIkO5TPKLL4pqG9HvEJSeAA3XQe?=
 =?us-ascii?Q?qebepkUm/5WkLxdEWIpAaIqEyT6UmrPwZ+PeYpSQTxy3kDUjY+zgy9MPs6xo?=
 =?us-ascii?Q?nQbVFuOVYwb2jlOWGPcd58XIGmz3jR7rq1Dw3k+iZQ2ezVN/FTM/Kb8wYhTN?=
 =?us-ascii?Q?rHOKOLM6V8i/3rkaH/wtDbWGC4h6vMBazyTPYkwSISFkVbR51kcBs6IZOPeg?=
 =?us-ascii?Q?JqzbeEw4tNaKyiHgO7jw1qec4IwpjqXuC2yLfZKmCodMbcLHyzoEDtiTw2Kj?=
 =?us-ascii?Q?OvVIU6whICQRR5rqnc9tH6TU5KAADSDmcrzjwZW86+74UmxVB/uKNgrzxp6Z?=
 =?us-ascii?Q?EJM38K8hRTmyW4F+KVsbkonSCweIplVyJJrMw68FSWqRTv/7l25OqL9xbLf+?=
 =?us-ascii?Q?K2o6eQuWKyIrm3Nx72m8/LhOpcJ1pJbzNMaerY7VGIJXv4n9rcz0hUnabd5d?=
 =?us-ascii?Q?MKujZiEbiTDkNSabBZATWqEQV0fk5ILHMfp/t/bsW6QiE5Z0SJ2L/D4SCHb7?=
 =?us-ascii?Q?wLhfXAalauSoUZ6DA48GPO3637bmpMUWIOcgRMlyKAM79D6kliNBnbqpmU3j?=
 =?us-ascii?Q?7me+9zkC2ApHEAQXKE73apuYEV9w37T4jXhx9cWmgjn3ddpeWvaHhWUNVLi3?=
 =?us-ascii?Q?GjJb9+iBAbgfVImlokBzZrgv237PxsNcxssby0YdYw3Tz1YJPkNjloC0VveQ?=
 =?us-ascii?Q?71xzcqVOW2Tyk6OwiAHyLPo6ayy/oxE3FeV4EfTxzhyHRAvMcjLApL5JgFip?=
 =?us-ascii?Q?goumahfQS4SsAHkfmykbnPm4lmZnGazbQT2gF8VtnHc7F/9nnXPhv4sPegn3?=
 =?us-ascii?Q?XQ+ibRpkkgyWn0mD+mkuemqia8eqohhk4T7JxlytS6EI0HEVpL1MVZ7+e1Wr?=
 =?us-ascii?Q?LP6QJKABOAOh68quBveUbC3kDhwkR/X3BQqC1SabdXjKd+e16zPAG9YLPNln?=
 =?us-ascii?Q?B/2icVybKEycXuVd1oQ5D/meUGYViJfO88PAifCYfeVKZlHZWslWtqlk5C43?=
 =?us-ascii?Q?sIhmLEXhvAz8MqwfBr2wPRzQ60aN71TxLYnJ29ig0QZkBWrjhm8tHmLeYTu5?=
 =?us-ascii?Q?IkzkLJtYWcDiindmL89debf3DScQjWGE3xoB2ncr2FwbHXE48tvMolhWDoad?=
 =?us-ascii?Q?iIuTAGU3Q1IwPsEUJmvP5Fe3lDkP2rDGCZbaC9vgLuspT7O1mOhlHJbodnTk?=
 =?us-ascii?Q?h36aCaNjH+vaMfjfMtynBcwypkaatkfUTIfxhxW1n6uKGbG5i+LXm4E+HlUA?=
 =?us-ascii?Q?63cIb0QGv5KvKXhgegt+F2yCHmzvJe5F7O6qPcfYp6nyaH22pd/Edn2cV32z?=
 =?us-ascii?Q?i0SA69t1++t64LBkTKsTfFbYu25ylOVKsChLWlWuCijmePgY6IM/H2euVaVS?=
 =?us-ascii?Q?fSdpMD/6dZhPZA/vDjylUDb8G6rc6EZgJgZSIajV06DDERdGI9jYPdri6CQm?=
 =?us-ascii?Q?pcDf+O9ft/8yR44zb1ICUsBh2lVRY2eC1Y15sFNTb2X/0Paa7Yp9nwSbTyQi?=
 =?us-ascii?Q?avzdPdBWw6cGguGpq5uavarcNSgSDme8u5Z809dbn1g1IeeYK+/q5LVKkIom?=
 =?us-ascii?Q?gQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ST/2iJ5EOyRxRcwa1vHBszsdAW1ExkLbd+aSOEZ2u3wdoQqH7X06nioEUmC9E29CYgd31iqaX8JryZm9xhPgox8AdmgcnEzYqwqFjZjUCp1CG8v6GNZdtz4rvcGZME76xi6VkShqZ4quNw0DjU85hhEPK8H2txvpnu8xztQF1iDJg/iAbBNjNMQa7D7JhIwdLgnMMAPN2LGyX3rN/ikNJUsSbSRI8b7kw9xhagmlzd7mYowRXvi8nPZKExydwaXFXtEQdyueiZcdwb3Dh4Hi1oMuKlMlyv/f7Os7uJlz+zj9CBfUvIEluyb2oEuNI5YEoV4+F9jLFMZgO+foRtwQuqjYzgjF7xVr8gqZCIT4yWqhs+Q43VTabL3xW4fB9MCKhmKcs100ZR9FtCHH4sjOuNc/ZOovE2LeJQS7G3KlTqz+eZ3a3zuUJNlXzFnrEVQxg15Ue6Kte+dhZ9/515f78/ETWAboZKRfahNetELYMx4nLZ7S6zTL4Hmzo7bInlfAl4xixALT259bhD3xZlGSIy2tRzcErAmmDRngZpFcD0GTVwZPKbiRVQeOXbDgiU+DSxsMvJ5R7SDQ2IrOsR5vc0oiTKecXw7EYbWX7djjDlI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 139bd4c8-b4f7-44c2-2766-08dddbaba95a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 03:27:28.5133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5I3Mwo1aiYMbzsNmJBQw+vX7CwOFjxdqYyrUSMAbYzqCcyzS0gIndfxM3UTpn6vC/c/Omw8w09PeJRLJMneUen13azh4LU5I2X5MCsGd8gw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4385
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-15_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 suspectscore=0 mlxlogscore=843 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508150025
X-Proofpoint-GUID: 7pJW86h1q7iRVGX_j0o8zYsNbLhha1Am
X-Proofpoint-ORIG-GUID: 7pJW86h1q7iRVGX_j0o8zYsNbLhha1Am
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE1MDAyNiBTYWx0ZWRfX4a3egpVGK8y9
 GjAeGWcFTaLHDvabLgZhUmQ1omMHhddFmuSKyW0CmE/7mOKs10VymkdD7tY53eXErdT00OSzjrF
 UOqBt/KyQgCX+EGlZzGhTXYho2o1LFJ3tKL44USQMAdqJNFzP43B0DKq1zoSXdh2JFozEDhxTKC
 NcuuyasfBmc1Ech2ivV1CFuEYyhsisEf4cVP29DSrgq8IKynF7Z0Mwd6zOXWtnGl9JZosoqiqHa
 5hd1paNKaixXPIVZ4BbdW8Ew2AvUjW/84sHW6kJLNoOp/WiyG4YO5Wpf7PCSK+cOvjpVL0bmxjN
 KjlivWRUAGn6WZSAvf8SDYiinLKrFpYDn+QfCqUopzDDyzrK60HtUCW58kBQkzM/OsKZWWpkMNT
 i1W7gHT30tIsiIrHSarfSSFeP3Te7X6feffnLsCmnfoCdLJra2grsV6zQejQNgCWhdQTKQRl
X-Authority-Analysis: v=2.4 cv=dpnbC0g4 c=1 sm=1 tr=0 ts=689ea926 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=8u6wpUVmjFQVkGZwwtgA:9 cc=ntf awl=host:12070


Hi Bart!

> This patch series includes three bug fixes and one rename patch for
> the UFS driver. Please consider this patch series for the next merge
> window.
>
> Thanks,
>
> Bart.
>
> Changes compared to v1: improved the return value documentation further.
>
> Bart Van Assche (4):
>   ufs: core: Fix IRQ lock inversion for the SCSI host lock
>   ufs: core: Remove WARN_ON_ONCE() call from ufshcd_uic_cmd_compl()
>   ufs: core: Fix the return value documentation
>   ufs: core: Rename ufshcd_wait_for_doorbell_clr()

Only the first two patches made it to the list when you sent v2.

-- 
Martin K. Petersen
