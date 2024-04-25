Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE34728EF
	for <linux-scsi@vger.kernel.org>; Thu, 25 Apr 2024 01:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714007381; cv=fail; b=lvoxXXzrJXfPDxNOnyK9kiIx0IA7k/yr3aTfVoDMX8X6AWGLEF1QKX8L0SzHpzaUBzxjEq49pw406r7X/f2MFBKKbKVtwENw5YPF88iGgAv/NKNTY1AQMS1tOoeH7SZDeR2Y7UfoLMy3vGk+UDcdxB3PZRxImOg3qGcmcXKSG+k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714007381; c=relaxed/simple;
	bh=llDH5CmBUIPC7nUJFKKsDQMn3fy1WBwbaP8kLOKCU7s=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=f4lFacwGJ05B8HD543t21BmdJ3vhK6CuAmV3mPCzDhiB5qCGKrr6OzuH9Pwpv2UeQe374lZ3Tp6Wlc7KQGaTWzBAfQGso9BZOgfhADBsJGjigW+2c5IXIPSMQXsFv1uchHIzGLnANXNRg49PG4OhQi+DwzPL5dplVwIMORgSrMg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=e5mZajNY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=x/r5UitQ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e5mZajNY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="x/r5UitQ"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43P0iTre012825;
	Thu, 25 Apr 2024 01:09:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=7UB8IHoT+GvCuxU022Hv8jg6EX6+/9GZG75T8xzURuw=;
 b=e5mZajNYxqgxw9OGYOqnX6ZmNl6MJ9iTVH82S4nS5+xIPUxlVe9CHm4hpOsk5Aootom2
 NGINgy4trFBrjdQIknoRo5jBSeBEIUnYxO0Qh+9AVqk9YI1PSVwgl8Z+ASr7aGzvZeeO
 kXeokmdmHI0NmDBh1WEdkp2guHNXqpRuLVJkmlzb+oGUf7Xzbn6onOZX4Usv37QW4Rjw
 qz+Dht6peQqkZ3SfzY+2rkrQgS7sHB5yKT9yv+Iv83T+SNRj1oHOdieTsopKPgl9T5cD
 d4pPxuwkAy49RW3yO4ujKNhSNk+TJF/4MAqZv6LsMkIM5j2+Dtg0+Owv7fTInJqgtBn/ RA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xm4mda6jd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Apr 2024 01:09:35 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43P0Kq6D019262;
	Thu, 25 Apr 2024 01:09:34 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xpbf5mqhb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Apr 2024 01:09:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IhJQK5THLWkZAKFT40Ouqqkh7xE1li/R1z9ilRwcB/oqi/f0fIWZY62JCyq/0VdrZoNQ/EEDpN/yYH0TApiygyzsmSYwiRUcH0umwLrJta9JOtRC96mV2pAg6+esARf2s8+NgLLIcZd6l9cqvctvszCkeJrKPCa/JKCWvKGrXvnQ8HaOvPvyGCoSoqhNQT+qLWXwDU1p1uk7zhZ8qN9LbilYTpvIVl76xGfkMabDuW5UXJdj2Ogts11sIvfnPXMMck7OANANqGU2yalWTDZ2izXb5uaDCt21ssCCcHjdQ7z8vk+jGrrEqKOdUpjohnmfiEvQxoip59gnPh/k/9LbyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7UB8IHoT+GvCuxU022Hv8jg6EX6+/9GZG75T8xzURuw=;
 b=oGAdWonttVI2SNrwhxOpQgUNRZXDlG4A12O9uQnP0cfM068+oz8a8lkwrHqQQ72uQDESreSb+yTR06EL5rm+aLpimQJzX3QxxtcesqbMhQTIgBkbRRtuIG1UnQYAlH/YQEgDIHeGlbeM1ncqtt5Ep1L9EP+uz1SHWccrnMD7xFWEK3alP8xcFwXd92Cb4k0tutEf1JDbXVjqqMEitPz06go2JMtNJfs6CR1OjVSoLNOyZHE1HCPwexmb+tyzRPoVIbKrtxoK2MqxPoMyOu2oANG/MPygcufK4eBqTp7f6A0zm76PkaayrQLnjoXnPRaz2ljmwWUNjrda+xiCLfeITg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7UB8IHoT+GvCuxU022Hv8jg6EX6+/9GZG75T8xzURuw=;
 b=x/r5UitQOp2UTq6WRtv2SuLE4zoC0wik/F8KQ4R6iqTGpFgEJc1eZKwDCtbHHOtez13eGVmPPZ9iWTMkZuqw1O8eag3yZDG9GnSCW4PdpKpUj3TZKUI3T3r7zTjfoUqU3HXe0R34eAelflVcVnwS8saKk+q2f/21K5fCl+vDZwk=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY8PR10MB7266.namprd10.prod.outlook.com (2603:10b6:930:7c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Thu, 25 Apr
 2024 01:09:31 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7472.045; Thu, 25 Apr 2024
 01:09:31 +0000
To: Manish Rangankar <mrangankar@marvell.com>
Cc: <martin.petersen@oracle.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, Martin Hoyer <mhoyer@redhat.com>,
        John
 Meneghini <jmeneghi@redhat.com>
Subject: Re: [PATCH v2] qedi: Fix crash while reading debugfs attribute.
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240415072155.30840-1-mrangankar@marvell.com> (Manish
	Rangankar's message of "Mon, 15 Apr 2024 12:51:55 +0530")
Organization: Oracle Corporation
Message-ID: <yq1mspi8czg.fsf@ca-mkp.ca.oracle.com>
References: <20240415072155.30840-1-mrangankar@marvell.com>
Date: Wed, 24 Apr 2024 21:09:28 -0400
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CY8PR10MB7266:EE_
X-MS-Office365-Filtering-Correlation-Id: a7a22b32-1e66-4e99-5b71-08dc64c45cb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?Svo3AVflUEy2H9nq0upQvnsTawGbn+Nt4zMG4WSblzTL23juJIA+cyS7RIYz?=
 =?us-ascii?Q?8skJe1Z//asKVopLAPNiPOhZH4lafnjPnrzGwQ/QzWPQE5qDjaror/RrzllQ?=
 =?us-ascii?Q?QhwcWjXJ4tYMedsPJasOJIleFC1jitySOmicCsUIOVWz7xRbe7yl/KAdo5m4?=
 =?us-ascii?Q?f/lkQ0YrPH/73zlYy0u7q4c5TaLryX1jA6a1MumkKNrnvZPlZSLXWwJbNh16?=
 =?us-ascii?Q?ANOz+XIBYAoNReHinoN8JdQkAcr2HjXDNR8rEJypTqfAmlJmFuYz4rFWLv2x?=
 =?us-ascii?Q?CtNy0XnHkgTbdSeLAm9hgXsf3UnnWqLwfcbAHznvtHgkYmjl3lXj295DUPkV?=
 =?us-ascii?Q?IfzBiJC67fr9MEKNlfEMkkaeRthLP2s6gEmCmJu4b64zDXWrq3Y5dXUEKskH?=
 =?us-ascii?Q?YD9Oeymg9YgK79dzrJVLCAIXl9I8Cd4lpoJoDsEUUQ9AeeYdENJFLMfFghSc?=
 =?us-ascii?Q?DAbTIPTS81yMtp8lhDgx66/dkzLu+Hc2HwcJ/SnZ8EmLJ27qbQN6cyfOY6hJ?=
 =?us-ascii?Q?XKIzQN/WRE5DSGDaMdMo48bimgqjnzc+WBL+IA6WI6ChXiWUhmGaZ5GC98nt?=
 =?us-ascii?Q?zylkOfJqYM5YgBc+h7NszL0K6pU4oht6fy764gATbTc5QaM0uHAcBm/VEVlp?=
 =?us-ascii?Q?MvExjavKwXYLsHXIn0lNgF3MCEaRKNr+3oVZVf6mBqHCRsuHhwghb7V2kBWO?=
 =?us-ascii?Q?mmQ1awNyLhbr6Y+ApT9xigZ1Xp1F3qmz3B8WxeViC4Q+XQp4SIrWpc2/88lY?=
 =?us-ascii?Q?BCMiY9WOf7aAMFI8tez59AH7b3VCr2IS8Q1OemVC2RsB77ipnVts50TCOJZb?=
 =?us-ascii?Q?axcs7nBLhnE4TzH0pfdE6dOXx3ttyudf6MXl3+buqY7rX2QUGuLUJRF21/LR?=
 =?us-ascii?Q?8gwi6ZnqaomIqhJNXdhF5UjXMp5lpA8sUdGGXBkr9jcTrP1ugv/yINpwe+PO?=
 =?us-ascii?Q?CT0VSETefb0DmWBiv7hZmEpyTxZxP9AuHYLJF/gPSwbj/OR6wUAxQulWT+AV?=
 =?us-ascii?Q?kjwYgx5wE2LE0bAeCVrZUAWS3akHl8OuK6evNBr8wZJW8dOqHWMAUp72i0Hj?=
 =?us-ascii?Q?OfO543Uxd43Mg62w0+WaSfc0d+vH9IW8eVmGQjPhVljfxfpQQAPKu2WY3O/w?=
 =?us-ascii?Q?tOS6N+0KgFQ87L/A1lntZn6q1s0wJD3aQmBT8XhCjHL/9gPxlBiLtP7/00Nh?=
 =?us-ascii?Q?kNwbF54Hi13SHt4Y4wqCQJOi2WEg2Oti7XhwNAgS39CPa7WHFq2YPoJ4083C?=
 =?us-ascii?Q?nDa0Nc+sFVgjdyxuFgTwE/z2nOsF086+rDYRPrpsxQ=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?KGPRrPuKvzfG8/Zbf3FWzNGsbP/eUJitHuKD0/Q76Sh9dHR+ZEekNl3NGOGb?=
 =?us-ascii?Q?L2o2MEg4Ym9PGkODMBp3XJo0Mp6Scvt+RUzxhX3NXY5KP/UZlW+TNzvOOQ39?=
 =?us-ascii?Q?C2ewlGaHO6KGUgGiAQd2xqAtX0woPyh8XJorp8mA6MbgFLXtHSsJPDX6IVCp?=
 =?us-ascii?Q?hjOb6ibg2IX3RTaLng3TzWnNpjuN2Kl1571LDnSDfGSsm3OlgvKodUGKnK9O?=
 =?us-ascii?Q?9ED7IOsPO6mjBo+m6AaaOtqxq5PpKFccfG3vBKDczKWqjUhpGXYCtoFXgoJN?=
 =?us-ascii?Q?9l9bWdpk3G1gwvMB4B0KwbE8ZMy1Vbss7weTZ79yf5hUZRp11uX08erQL4Kw?=
 =?us-ascii?Q?XbsuCNBR1Salc5hynx0q2mNcEZ9E69jxyCFyJFGC5goX5YCjfhe7n2my4HA+?=
 =?us-ascii?Q?PrE5D/JmjLoaE3NamXEjLWIi6EGrvRFoQh9Ps29I0HDbGslU8hWub8DyJ/kq?=
 =?us-ascii?Q?TyqsDgDEQhCHtH9WK8PZqgxa4WWe0hecg+SIpM3ztPYJqrr/ELF4eaBCqcJA?=
 =?us-ascii?Q?i8VAEvh5RAu5b7Q4SWTcQB4qAb/6nAPiq8R5e6nVRO7N5egVbgX7xiBwtCpD?=
 =?us-ascii?Q?QeBmhATNWCtKs5cgdgecDDM/lqlN4394bGMsYMqTETteZN4copNClQeR1PCN?=
 =?us-ascii?Q?HVj+ZWkzLdlPqKtUpH4eMHyB2Ngv0Pn0+V6GSCJmRHiftLk2kStAppFhyn9f?=
 =?us-ascii?Q?9oo7Knb3eH8xTnsVn5YnTpiNqUo82PjHJBKDqkICOGRriaskxHnb3kSNGz3P?=
 =?us-ascii?Q?xuMNUtJaJ1hR8mfNuXp+Ll+y6pCyS9HP3/yN/eoQM8DUgHiFofwPvNvt+sKh?=
 =?us-ascii?Q?0SUNhYCZJN37im2CwLlPBrCtIbgtIHWB9J1miGKO6TPrkMzws71jTPmqce86?=
 =?us-ascii?Q?sRmHFizmvESx8vZSbfve6FawN7JZggG+NIgzCcEqoGQoHJ8KU8liojjyXu1r?=
 =?us-ascii?Q?hln5Q/OchWZs1hVR9sXXiNka2/IYVZZsLmMgYmYUPlkwn3TvCl9K2YcVSZY7?=
 =?us-ascii?Q?6NHGcRFF30Gpeg/y8jAcx6uiLJJQV4pXM0V3GSxHQ7doIxo/2Ns92ANg7TSR?=
 =?us-ascii?Q?1xSF8RPg7auSYo0vxGZNEMPB4uBLSWh7D6llTQC5zoO9UNCFZ7T2CxIQrYim?=
 =?us-ascii?Q?LAVWn8CmOLejglk03d/ytyaFsSJ6fy3PSzt1eiSyUJquKFL8BThswkRZT/L/?=
 =?us-ascii?Q?9458YdvjrXLdq1qTszq5SbLMLXh3AsFtq+f2sza0dyPn08BznJG4Ybsd+STx?=
 =?us-ascii?Q?h3ycnmSAJSZWu30cMtKaF06hKQxr7YVbtiHH9C27YOlLwlsET+qkMAqV223+?=
 =?us-ascii?Q?5MdvUuhtMFXCvE06I82ZtNMF211ksh2pjzc4s8zRVN0yxhph90BmHSuuTqPg?=
 =?us-ascii?Q?sFvQLRm5Bg35VBZjBjZyM2dr+/DN1bJJLaEeqjc/D2JOsmQMTsr49+xlp9pN?=
 =?us-ascii?Q?5R0g1yi/aFQPYIcy+SACiPbAGe3PDtF5oo4j14dzdmyr0SxrWZZustNYQ7L4?=
 =?us-ascii?Q?o0uQAGl+uIIAwvYMffE4kUralvATGhW23vnkE+rMdovXzU31i+O2mAyM07pC?=
 =?us-ascii?Q?h1RabD21Blv8p+P38rA0lKNP6U2tJ+qf221h81p3ucenjId1AYzubIabMv8B?=
 =?us-ascii?Q?eQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	u/O4sikhjiAXr4KAnZXxmYytEXZwbeoSvKfTXKTKDUwljBdqyQZiiOtrL8UZok08a7v4AnyUgX5xujQYGP4PSI7DiSzVmLmoKTC21TWaRl4RqkRaLWVhk66hZxFfCHQMtsAKKHpvZV5ydmk+zfg3hyIryt06G0dEvdtpjWdc7Fn/iO76TbItsM7wDpTWvT5jdg6WvlF9TrJBjZNwV9yqWhiaHuyA/O8c9kGjLESewXjpSLNbYEyGG/t4m3EFgA0+55bZTm+z0u/r/f5jOa7iPklorL+he+oWQVzOGSua4i2DQ5+4Xrovl3ajltGlmYQnfppZd6BPELhcufOl042cOqGFeFKUeTUGkldetbJU6c/FLwoOqOe3oU9HRQ2+32OxYb9w6I5P+2HikdBvNJQF9Sdb8Iy/AwdwG/ERDT6B30AIA20E1ggcpNTbcSxP3Xl4QUlmj6eHV3T560OwXZkpLlK4vn+JNymcZcIW8UIvZGYVG1q8K3pZwCaFCkoczihX1tpl7wdwuFjQNGmdP5W2NoooCO9GT7Ubip0scb1qvF6mWk3PRGdkXrppPVmNgNOiZzl1+QPyZ2zGVE8hwC1Xx6tl0OFJjHv7KxlUSUJULs4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7a22b32-1e66-4e99-5b71-08dc64c45cb7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2024 01:09:31.3107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oDdBQit7G2MFHfVG3/g4tD/mye+p3iQgVXm39WpwxpXe/0NXWmFMvOfRf4QHNK2nE32w+4MWEcdfGQcEb1mkbOXoVQ274SbdhJyoo/zT8oc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7266
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-24_21,2024-04-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=838
 mlxscore=0 phishscore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404250007
X-Proofpoint-ORIG-GUID: XuJ7gaNlO7f01C2Y4HPcVG44vRH0PBy2
X-Proofpoint-GUID: XuJ7gaNlO7f01C2Y4HPcVG44vRH0PBy2


Manish,

> The qedi_dbg_do_not_recover_cmd_read() function invokes sprintf()
> directly on a __user pointer, which results into the crash.

Applied to 6.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
