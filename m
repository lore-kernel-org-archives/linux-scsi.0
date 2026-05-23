Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05C41A9FAF
	for <linux-scsi@vger.kernel.org>; Sat, 23 May 2026 01:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779500494; cv=fail; b=lxgqUgeKU7/UnVKgeOiDlDTZ7HMWmnHE+7b/cpBxgqsbW0Mt5p3b0muLzUMcFloI0OvLCSYT/hfVXcx691IJj4GkUIaxHjvzKgze2XK38x0xoEUhHHJEVcpyNCug29DBAokSBA8pnzIbyyoOfBTLNOLohDp98GuP5AIFWzfWJ5s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779500494; c=relaxed/simple;
	bh=YQRPL+4wzaEMkn2/iofQNWL5hkwR0ILOMCPPgugKbFA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=QmHcQfcuG6qvMAJroLBOFuXcKST8z0thUyFkP+A5yU7yAYUarwox3BQPwllbB3QlZPrtAD1Qwj2VooR6HJajmhFZJ4zn7XhwPaL7b3tluYRB2pBUGkTXhVIqdSCAYIq850gQH0jufGy2DActBtVIVejljN/Q2gPwIXfpQ9roeMk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CosmDRLK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yfaP7n0T; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CosmDRLK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yfaP7n0T"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64N0XDD51807005;
	Sat, 23 May 2026 01:41:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=VuNYvOF2rrTNw0Bjnc
	9DfZyVeBCOxjLbngwYsy4RbQo=; b=CosmDRLKkgCTnf5MOfXkdkOr6x74WA2igr
	+IpGtBMMEzChlmUkJ0nhYMPXXP15e3IaLyXQwQcze9gxHtyTvpLKK8UzDwu7YwDV
	Q4pGmYKVtGwy4rsxn1FmW8ed1/X1/BfFfJc331dpITWLMrp0EKfWGWyyD3ERQJzJ
	mUltTtw98uY3UeRirwvp2se3+D0mLREuKukYHZ/Vk83Hp32MGpJR0PApDJCMojNX
	/REdK5wY0tBDHt98rLrvl2WUQX4HFOrlIKz9AZYEsw8f4Y7k4J1bwLIPkbPlPBMp
	nisQBVuOPkLmL/vaW2c8XWdpzWPioyycW/n5kq20VqTzMbAhwQtg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e6h1t45tg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 01:41:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64N1dpuF040296;
	Sat, 23 May 2026 01:41:25 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010015.outbound.protection.outlook.com [52.101.56.15])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4eb2pcg4f1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 01:41:25 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GXeJiacwJZvXlR/XcKZiVRFoY4C/svJDT4+omPk+UGpD3JfZQIC8IyGGmGWxXreXX6rJ0qe3Vnl7eC0oIi7Xwfsi6bsTF04ujDOpuAiBxOqf2z3XNkjnjIeqRwRHQUhiFKyf9fMeXXXfnNJqFSwXdtGaXMJkWRLuI8EXdht3JvCAvYTcorjAOuTFdcowHRadDhxYCnSjxy3Yw+cMmo4Hh2Z7Z5poKc2QZyXH/g7LOmR2vkPPv99mq37Mr65b+3pPLyy4ZGQotlAj6gxhGzQlWdkIZmv15nddi6HHdS+DdxUr3eGFGcGQOvViElc+TFTZ0nYGA8BeDdY77QctNXBdEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VuNYvOF2rrTNw0Bjnc9DfZyVeBCOxjLbngwYsy4RbQo=;
 b=j5PavYxH3f02edU2i4KKw6CpiaNeiys3dj0VsZyiCB+YC5chHmEfRjh3OanSHFMysK7m3MaZy5l5LsjkOhGiygmLdl7712O1R6dclBkBZrh/aJMOWWusyh5KyWLIDqyiJ/En2wMDWfmz8vD+3WiCVyFtUtyFXOEqsaVSYE4WTftThwWoPY3Y3MxTpeApxwycvBH14KVYIBGDgPmHxaAlHo0kEY2MiBoqL1XH2uS9Qrrjd4RDKhNsggLDxo2Qyy+shGy0DV6tARDGDOeohvhSUDPEX5cZaNH3U8qQr2b5I1Vg5I8gDwf/GMkTrrs/G/ZiyleMhWZgyq3d27BuUrdiZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VuNYvOF2rrTNw0Bjnc9DfZyVeBCOxjLbngwYsy4RbQo=;
 b=yfaP7n0TKa3ADRNL2YUyHv0Ey0nRdQfx0GcVkJL7qs1dph3YUeGtj/QuK2/rxUoK7RIoR0pm60B4mG/pYjhMJLYkD3VTbAip+2/iJANsG3v8286tg68lAYSCDx8UslF2YRGarH0V0iDOz3sBFR58ARlSPnuZSvUKMiRuCH1dNis=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN4PR10MB5560.namprd10.prod.outlook.com (2603:10b6:806:203::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Sat, 23 May
 2026 01:41:23 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0048.016; Sat, 23 May 2026
 01:41:23 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] ufs: core: Optimize the UIC command implementation
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260519212135.3130556-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Tue, 19 May 2026 14:21:26 -0700")
Organization: Oracle Corporation
Message-ID: <yq1y0hagaxq.fsf@ca-mkp.ca.oracle.com>
References: <20260519212135.3130556-1-bvanassche@acm.org>
Date: Fri, 22 May 2026 21:41:20 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0053.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:88::10) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN4PR10MB5560:EE_
X-MS-Office365-Filtering-Correlation-Id: a9c5c043-5709-47b5-c9cc-08deb86c6532
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|18002099003|22082099003|56012099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	yDPO882aOSER1E6GL90VHNMymVjE7lWoYCnk52EFjeILt6xGVd87svSC0SgESgrVok2m1rT1g95dq/D7hCvC+TW+iFmDeomVYrRWdEAeWcX8t6H7BMmssf9pKNIMBfOn+Fk1KTRv2+fiaM7OfcEaaqTAH6xAbpy5VhqMupXIzZgmxMAqWytsXrphbWSpE4MCUqc3oaE/tz0xpKCLhKNmsyKUBO7m198LQoZ84ZlToH44jiK0G1Q0D5hjumJtnfOzgd/CoMlNcAUhi2azDBuglQ8QdFqX2Ii49gityjcmtacQIIyQfNPmoMOMGWnuoA1pY1351Kqi0a0WAITCv9tNhonz5T/NVg3zOUY0wfpJxJJFtVqj4VlIgr2fL7k5+mABL6G8jPC4EUqrdUDzGmAdVN3zhUYNMaycpInbLBOZ8L8KWTA9Dc1DeokjLCeZuKHaqJMj55gfrcM4NyYMb7VFlL2x7TKDq8vaI6W1JWoPSIO3/r9gQVLLB6SBRWcHSE+x4yGmnESiilnoFOKZT+mj4BzScGj8ALOWa8SrztBe3zRZyPy8mV5ODaYpkBcHpjk9J/O3vkCBq40qve04BFPyGORPhZi7rgN/a2FzntyZwS+Ncs93bS0a1GiaBciSG4xiGoVaFSf9ZvPiL/y9gA5kiPWrRTQg/vomw3UQN3qBahJHEBX2OkeTK8m+WG0ZwERA
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(18002099003)(22082099003)(56012099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oIIgHuapRLrjaSja/f79TD0Ge1vC/ELXmWC8WYlGw5qhkqDdjuc0ps2jwrZs?=
 =?us-ascii?Q?6rg84qvdofvmP7KA0KjaUgWYlxUvZWoDnNpp7cebgMLFLcraH9af7V9bAE8e?=
 =?us-ascii?Q?0CBOYuKv3SbST+I8iLvB7ic7cixLbQn5fETaTfzZiMMe/JWDfVdRYQ/9jBUf?=
 =?us-ascii?Q?ovIH27oA5iga49/FoEUnYvUw9XfH5IuKauzTHqRVfLe1W5UEN8PeHjPV5Ega?=
 =?us-ascii?Q?tchXysi/pWzvrimVk+8UMMat7Rx5Lwgpeqop3i34TAYJtwREmIicvIthTTWG?=
 =?us-ascii?Q?28Sy1NvbD9FqxggX8/AOkRHMAdE8BSnAVTuXH5UDkl7CrXzJU1cGTsdZ8Jh3?=
 =?us-ascii?Q?cMOumvhwnxrXMud+Pe34vumEjq7f5RSzRz5mxDjsKWakqQBuif39CoDHv0yR?=
 =?us-ascii?Q?jqgZm2wrNHk4/mTk9Exw9YEEYjblqRlp0et8DnS5vTfW3iPIC6gEDE/94thp?=
 =?us-ascii?Q?3G8d7dpX+tFaYD3X9m2qXFEwDnyIeDIpH1AsZ6gvyfQ9ZS3g4JG+02OeV7O/?=
 =?us-ascii?Q?Um3VWO+KYvTWg7Uz7/Zp2rEHn7DPHHS24WWrfvFOgDYj39FqxYdwVoEN82tO?=
 =?us-ascii?Q?sO60ZB0VxR81XaKtvbz77cFYY6heFG5BKWmL3oGXIb/uu4cMtSJn2lqGsP7h?=
 =?us-ascii?Q?N7h6aK21SYczvAUMdQqQq1Pd2HceOXpWngsHMV2H6zX3+XjKN177mUA/HxfQ?=
 =?us-ascii?Q?3okQj2NVRFUbRqYoFB/USxhhMYSC0pLyEtZ5qfuwW1NJOFfYcFlCwrCLW2EN?=
 =?us-ascii?Q?NPT7nYV/WWJJaMoxittldmtwWqt0dbL0aZ/kxDXC/+M+PJ9HjVEEKoXOD9Rf?=
 =?us-ascii?Q?zN0p0OjCye3YTjtCjcMV5OTlZhC8dFJQLQuLGQF48UJkX5h6zxQNwaakv7mg?=
 =?us-ascii?Q?e/ArKgs//GjmSRjz3beUngytfJJrxmZNg4fKgrk/rO6BlD3W5iydMRWA620O?=
 =?us-ascii?Q?RPIkskB95C3afTNECz6ECo/FX8oJ2KV/kmw5MU3qWWQCZCl5gvX9eUTg8tu7?=
 =?us-ascii?Q?iJDdxmevOmQc8N8csngn3jwMVDAN2060Cx1+obXQc6hbfvn/JlUZOPT4Iy+S?=
 =?us-ascii?Q?oEL1YJC0MSwzqu4hKykU+weiiPkx4IaOoOxWT8paiK7eUJNuSNsIfJAT1i7D?=
 =?us-ascii?Q?/mVXN/srwjhKuysnqHkJpKZzskFlUG8oTwH2AGmgNbC3oxaWoNlGOYl+qc9Q?=
 =?us-ascii?Q?f6mfNvrscYjzrYB9KpOOT4TJ/tuvAC8LAL7HMdl2c0wGJ/0kySbFZJbLjerH?=
 =?us-ascii?Q?ktmAumnK+TXmnDmiTQl7DE0Ru2UK/SSuUmuukXE7z2DBwYDCDA2g4rB5X13H?=
 =?us-ascii?Q?FYTalEZ0tRCOwMIrS4XEzCrrdFQF54PGlirXjPtgs7MWt97LJjKHopuHjy7Q?=
 =?us-ascii?Q?/URVPTTkqJ2HOAkqiK/hSfFGqRO/MJp5C+LTj+GJrHL9KSBZ1s02zq39kAIq?=
 =?us-ascii?Q?RG8CfnS8TJCKIDgpBzpqjoboI2o2aCsj+uLxnlLt4CJLfVlx7asz5n+Nip1S?=
 =?us-ascii?Q?+dEFRO2p/6iMLFq5aTXBtq5qtrkBE5MfBS512Rj5hI44p4r3B+ZTq9Kle2ZZ?=
 =?us-ascii?Q?ABXmH2aFwIynlcBkh8mCGI6vlEQuyKjFafZO3qSPKZtWFtu02vTu3lyxEjx/?=
 =?us-ascii?Q?NdcncOyu2UvvNWIMjArWkdpdyAkJe4sCBJoVDF2P6/bISy8y68TfvtX/kFCz?=
 =?us-ascii?Q?zfTc+uWzkPTbEg+Ivd2C4RBFDWilaB8iTRr9IrSmTaVuy+O8RIqxD9X3A3fg?=
 =?us-ascii?Q?jGH5ZKBoiuYwo4kK5LpNd78DT3lwTAc=3D?=
X-Exchange-RoutingPolicyChecked:
	j5UdVOBKqK9yKQtWONL+ZJrQD8o7mQlXpeSO9TPOG/HHbpmNkEgscIbBJYkbydVVRRBqxHN6y+Z3DrIdn3A4dScWIzrXlcBrzH/cG3+nbluVJhs6r0y1Q4Ko9FnKa8C9esQzmu2/jHDT/a0MoX+8K51ITVQDfqhtvE5RE0HNfpATVo/4wKK1nAAOW4F1OeYYqpdfIeJi6BHLS+CcrtprVe6vIMjDbhyRrpScO81pbAK+CNpHLGIp1YLdwPP5FsPFe7SN6+ho6kGy192zv9KSB+c2kLqpmIfRrhYxY2XfW1HwBYu2nsYRSdoCVCBmIZE5svXjTpXbNGpgBmTW/g5cNA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Fqj3lr1Wkd4hkB2TP28U+DgmWX0cehjr9TwQppslRvHuRBCED3GdR3r6dpybLCgCJp1Em2iGbRglVgPmDo6E1h+ygOMywQBY6fcSpjTvOxj4JfAZ0doHhYzDiQ7G0V7osEkwNbOTy+Mfyd3gtgE5Sx2Q2/MQLDT4tlkdq5rxlbS6FtZZG5CPGGLyIPVirFfyMu7eKU/Tyt0DbEph/1tRRhULFRBV8lCeCsUezapPXn3Vjw0LHP+kQZYIXtMl3kspW62zU7fj9xlprdC+0MmTJOPmqlwOCMLv8P5pMI5LUkQ+Ft/EeXUGp1bztbF5fTVFS73Lbb2Q3c4E7Gl29bxcyrZmp1Gc1ivvA3uXaceH23E2dnm7zi9/wDR7z53EJC07iInw9E+z5DOBx1enWN7PZIdhCMsbj0SHHRvDxATXSDnRRYT6F9aeFfQYYPWo5RA4tkA7VwEdsDLI3cZ2AtSqpXU+2Ti/1uWCYPirEuqPTlDdLs1jtEDeiW7jyGLUhrSY+IYe8riDlSqRbqjpNxMzFk6C2E7gvYnvdHt2kc1whoKu3Wlgaz56BiryKtlXFPpKDQ4Bz/R69joNyNlOfI7aKUQ/WiaPM4VhNItqIf6HYOY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9c5c043-5709-47b5-c9cc-08deb86c6532
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2026 01:41:22.8671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: APnV4Igb6cs9owWmWQTpAPE0NaweDF0F78pRMsA8VWEunLVZJMWJzhWsw+5yKroMg5zAc0ryscC3XdNpZiZe5dtoH8iXvUrkgWKTABtggYM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5560
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-23_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 malwarescore=0 bulkscore=0 phishscore=0 mlxlogscore=801 lowpriorityscore=0
 suspectscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605230014
X-Proofpoint-GUID: PE8b5KqhZyPHxze1lx7x3BFVcx4gaTHX
X-Authority-Analysis: v=2.4 cv=d9jFDxjE c=1 sm=1 tr=0 ts=6a1105c6 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=NGcC8JguVDcA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=vJrGPoxL-D8gLZCd_lgA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12301
X-Proofpoint-ORIG-GUID: PE8b5KqhZyPHxze1lx7x3BFVcx4gaTHX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIzMDAxNCBTYWx0ZWRfX7RGdpfbxU91K
 3bXOQRZpitSYQqRjBKFT6rklUV/UuZoYya6fCsc/KfLvKironOX9kUce5gPADbc5btMO2IItZ8c
 ZU8E5+W/sd9WXws9hZImlKLdXrQcKzXPe4Alg3ms4gdX7sr/gg1D6fZS2SGijxOEF/Qo4aw7VL8
 u7rl8ZsvFDUFkf8P9trS3GbT1yOpVKidQu/uojr/D9FGj4aXLxiY2c6JD8319JHkA3mLVSOx1YA
 amHccroLYP2+nGgmgumYcGCN1MKhlnY2wTkvK1DprZw3pdgGqBAJpFApRqW4Q0ulZByD/c/eeUn
 Qt184YRdDVCnFQBOMTKQ9CmGg5cCd1CBEMSTdaK84GC/ZZS4p7dmlEjbOlsxCCSmUrLmgoLmVxz
 F0oBTyAwcuvTDtRjGzOpObo15zALVl8e7J2vnR6upFDxhBI95T+hA8KpA4EUN7c9qFq1YBvVIyO
 G1LeJLEgBXi3WoJBh5ZJBB+jbEq2rzK/0CmO9wbE=


Bart,

> This patch series reduces the number of readl() calls while processing
> UIC commands. Please consider this patch series for the next merge
> window.

Applied to 7.2/scsi-staging, thanks!

-- 
Martin K. Petersen
