Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2B0367B84
	for <linux-scsi@vger.kernel.org>; Sun, 12 Jul 2026 18:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783879432; cv=fail; b=phEfjsxMtzmmXQNOCPA27iXuWwPnTNRO31H8tpg0x0iBl9pz0ZJbD0zBq0p7orHQnoLWGRTG5JfcWFJJ6XO8fiwbiRmg5xpI3/OOV1hC4Al12D7Qf1e+nmLWPAwdfQDEfubbnLAauUT0oEBRWttsONxJJbdL9om0KRbsJetlbxQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783879432; c=relaxed/simple;
	bh=mD/3uwRdJuw2klNbbnCiBdqoil9O/wVbtO/dVGTAgVo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=keYwqIqlRiXzumXkTKNQkteNZD1PkUAS0a4ogwPLlEkRXYZ8kyBT7WdkKPr6fi7yGx5h90pnYVB2qB+EoRYjY4m9+UUs9FXsz+4OVxPCAnizV7876lGV7L5A382HOKhtsRr7nJneLsZwO6P14StAXhHL450DtOXzaBD7NOJ3IEA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZlrE2RwD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nlebh7Kn; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZlrE2RwD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nlebh7Kn"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66CHissS3687861;
	Sun, 12 Jul 2026 18:03:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=BfeCELfdtlizN6zPIY
	QKY82In/YgXnmjQGGd5kicH+8=; b=ZlrE2RwDZCL3vNcIHxx1llGBH3TsVjSD3J
	WrGijJgP3irgCjtNHHAfmbEQpWhYKkliDXCPc/RDDt/9siJIpGZWCQDp8UXWpg5D
	GtkrqvUXU/CBANXBtJ3m4n5J3o+B91ye3LmvS0wJkG+6CguwZq0EEGV6Yc06IYra
	H8A/ul0g322WWZJySR9UqTUYjQ/TK4wQYq1p3hAtKBbXzwhjHImhU/ttM3UkYN/g
	nzSCLwPCwhAD7TfQRsQV+E+2KXDLkPAWTCJd+z/o2UKphIWkn5qsSpzHKOM70WIC
	t96GKAdHA8TmZes8HHa1cnKFRmq4JTcOMqu/X5FYR3uCFrhwU+rA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbep314sc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jul 2026 18:03:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66CI3Vtc014970;
	Sun, 12 Jul 2026 18:03:32 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011001.outbound.protection.outlook.com [52.101.57.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9pkqc3-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jul 2026 18:03:32 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d7RuS9vccmfY1KPdm3dpI/ArMtuZL1qNxUcssO6WaAoNfv8eAdZutQWY5ExK1dhyDk/adoZDg+scDvSJ0iWMJbbMGKPkzlKohd2kdw0fUcfnOWoBgLjpAT8taBhY9/UAPKowUqwuhGuat8pj1v8SdaELsskX6Ht5qKpDu5FXcTBI85A2mGwdCpheJlMuRmL3g7QCZP0Pue68Rn/OPTyJQoYmKvy2uEXJvEPjpZV99xBOiRgeLkwyHfLovSQ6v8OJ+5NPte2FNWgxIgOBkdngAadveqUAxYVdPVXj7EU3ygtSWHFKLv//IehdmAMJHPrGGwXvAFoc0XV/UXJt2t4d1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BfeCELfdtlizN6zPIYQKY82In/YgXnmjQGGd5kicH+8=;
 b=Ng1CfpduUDtN+BiuvNDK3wnLOs7y4mTdtd8OS3PcB2McL7g1flsipwoyzrVGZJWmUpYhPNDAV0N373faU/x/mh5Kpl9APaDRANjmRhJpD/FPg9GvJhvKkvhDJpEQcEp10H5tTX9/VKrEov7q+0SDkHjj4mB3c+zmffKInMQD3CPVjuGOP5Q6qKzWk6eX/fdH3VDb7Ny+PdtPZ/kyLAN+eL2OxlPTxB+1WucAfX0R7EeorwN3fij6ifkODGmHbuft+Td40wU8rzHTVmuDEJKzb1kGPWOh67R6/pK9bzpo/p1TqbO8lho6PQXKE+EhzbfuSrirziDIPJ/dGqFpTS5/bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BfeCELfdtlizN6zPIYQKY82In/YgXnmjQGGd5kicH+8=;
 b=nlebh7KnO3dakewIAbGchM54XL0zyzFNKrYnEqDavOYwPLOA+KKJnUwCkwhakcP4M2ZcSaOF5MU/B7rUFSHZuQ2+NUID+jV0edYu7x59xb6iZDSG86JZaI5eG9a1BFwfl25sZT7SQQgRQ62wOQ808AzCEYVyMcQcWwh5PtFfSXY=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN4PR10MB5624.namprd10.prod.outlook.com (2603:10b6:806:20b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.23; Sun, 12 Jul
 2026 18:03:13 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0181.014; Sun, 12 Jul 2026
 18:03:12 +0000
To: Can Guo <can.guo@oss.qualcomm.com>
Cc: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, mani@kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/3] scsi: ufs: Harden TX EQTR error handling paths
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260625121306.1655467-1-can.guo@oss.qualcomm.com> (Can Guo's
	message of "Thu, 25 Jun 2026 05:13:02 -0700")
Message-ID: <yq1bjccf5m2.fsf@ca-mkp.ca.oracle.com>
References: <20260625121306.1655467-1-can.guo@oss.qualcomm.com>
Date: Sun, 12 Jul 2026 14:03:11 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0203.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:67::11) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN4PR10MB5624:EE_
X-MS-Office365-Filtering-Correlation-Id: ce7cc009-5fe6-4434-c78b-08dee03fd6fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	WtQv6PFDFT0l8oYyJDM5vHnaJI04qbw8mTJkfgrIEUgbKfl0AbLVad5w4b/6343Gr0MdrERRmn7FSbu3Tp0XFhLk8Vs25WRTP4TnawXcIAOBFur2buND7xBPotlwkS1hL7LL9Gj28wAa91echYQeydblby/JBersPqG703i5C6E3jFPko3e/wFU/aRyBzW992yT78Qd8NCQCWtc0tctpGGIWsNkTU7WItSXPvXzUhDj8LzIQC+65t1jK+aIImt0+E9hJ/LdhZp2e8rFeWM/C8N5VRkQmww8dWvjIT7qslgAIpPjkRgZfc9nbr8c2DkcRBaOxkmsU7RqeHzzd4QcU0zoBz73YmKYiwPbLlW7edp03k0q/juSmZfRPkjWp0FzZKvLD34xjrDw1nWK0rzLw5hBuNEbqGR42MqwrTZRZuAPv7ojySYXvd8laC0xb+NpyjdbAkzZx0ZeIaQnsPIBt1WcGDTseJFbVRFcniJzHzj4Tdcub51ZrempEXSeJSUxN8PhwrUs9vLD7sI8ubzr4361AmMn27NDeBWKkmxD29Lu8wsszgDSa0ml5E+m3vPw2XWx8GIqDIhDVVsfflLN2/wfgGZ764oQ0GxZ4OIdoR3M/d//vji30bH3mXAtG5tiJgsytwtpil3NB8hb6CgOt9ikbvVNhDtMGBfs69ythLGc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZWFZaPX5qe0guGlcw8vO4zhBILeOZ5QAfBkPCCpKClkEKUxpKbImy2HK4fTF?=
 =?us-ascii?Q?/T4aoEZ9IJrmaFRAyOXG5CWTtTp8Yeu9VCIrUp5exKF/jqcdW5vJ6Xy2Vpp+?=
 =?us-ascii?Q?eF/CGM3oLTVnZclokIOQFDgY+Y0908SqCPXDGUC7WzAKd0Z4xrTKNITk+50k?=
 =?us-ascii?Q?njGtqc9eG3FH7euXiQ1bIR7/BFqTmDpwQKDGu6LM1FZ4uh1b5SsiKzW0f7uh?=
 =?us-ascii?Q?hDV9IY4vH3teqhto9uxGFdOWEE5VA6uUbJrgUFMq+kY90/xwcBvrzeroQe5F?=
 =?us-ascii?Q?XNpdhki9fC4glUBPkhBseqC9Kv0F1XaNU7n/ygxxfY//qTyEGzhYPVDPYcKt?=
 =?us-ascii?Q?r9fAVNMBbt+E5kfTn5RY5CoIuiQzgRRdsBcMJflzOdIMmioZSeHhx3DOKXKp?=
 =?us-ascii?Q?y6SXI/OraVg36xBvW8sutN3B5FPsSJJwRwgSdv39zf6Weyx3EIk5Satkr3E1?=
 =?us-ascii?Q?YLaM1RVmo5gjlOMVkIKZFh3YcwmY0UoD4a1lDVOnYhfvtr6AALku96o8qzfx?=
 =?us-ascii?Q?u8MxuCOnTM8diju7/hyq/yvhf4hoeOYyOTu4Tww2MLsV4PgAembeZAc52X3m?=
 =?us-ascii?Q?eQXcwDvvOWm3+3rvhDCtahTvsUtGTuVa52YNvMWKVdZtQ1bbFH+333tORZAn?=
 =?us-ascii?Q?D8KyJnuS+xL84uh927b9Xl9uUIox+9zHVJXK3Az0cw83vlN+JQ9cir0iJgk9?=
 =?us-ascii?Q?fDex0FkdfbPvMe/G204JNAtEEHJCTktHS5DHUc00BI+sLKiosQHITanmcsOe?=
 =?us-ascii?Q?vYyeSZ6NJpN1O2raeoNJKx6jHmqzmnGFJ6+TDX8n+9gZIFAIUMvEIPJsEZpW?=
 =?us-ascii?Q?IKzICBNvLvuohbfTM6NZZdY2J84+F8YhKAawt5sTdhQfQyTdvvFBunkOPBhd?=
 =?us-ascii?Q?7BrMz16jWoDODEg9sE6dIwM2Rn7F9+vtxz6VPcYK07FCl9vdmS7YstcxNjvU?=
 =?us-ascii?Q?ClycwNWflz/FMOXUt0OXPfqLBV0g7e07lJvg2/m9lvb3ry6Pe9WVij3nanGA?=
 =?us-ascii?Q?8e07qv1t3LZWLCxkZxVoqvGxVZeDG4jaQbLO7Pihmmk5+f4L4maX3xpuwBvO?=
 =?us-ascii?Q?dDRq1m0p65w5537o/TTyM9qtPTRdGf2pdJx5JwPBvQMU25AWNQDIm2QFTpOz?=
 =?us-ascii?Q?VsADal1TyXL4QZSOAqkLRUlOGVxdS73fOAplrSByOxk4Oi562pUpimAa0YPl?=
 =?us-ascii?Q?yQeG4Emc7iSwbozSz9VMiDVHs+3bVZCS02yRgYCUnJQjZD3YIRIAGWhc6lTM?=
 =?us-ascii?Q?vVzQMGrt6TyMHd8jIhKGZ/C4gYs4xqICzldfp70gdOwQBS94A6RLef7WVZT8?=
 =?us-ascii?Q?fPz8FgRAgeq3HIN9LMxpYJIaXp0k2WiVoF+lh0LV7ZvukY2LahGZDH2UJeUO?=
 =?us-ascii?Q?lvQkLeO+ofNYMrfvuFY+D8xhjFKhOMrH+0jcCtuEHFvoOQd5EhzkAVX2Ik/i?=
 =?us-ascii?Q?O+xMwv+AWiLE1GqiyBwfs1ASeXclaejIeUDaWT+5cxjgogazqnCwWoRtnoyM?=
 =?us-ascii?Q?JXyvUaRaN0OJkyZK1qP7RN/fKvEQJvedbixNeJkRFc1rSv6F6boLVSgZ1apB?=
 =?us-ascii?Q?ZVNIU6tVEv3apMjHNwwZC4cgtmazC+CG74dwEYy/E7LiYmdg5t9m1dSnQkPB?=
 =?us-ascii?Q?svDKzkAHkaLZKLGNwSy3j0jCRAihqICh02emNmjbRUqyF1+YJFuiPs527LsL?=
 =?us-ascii?Q?sj1ZYxDENMeNIRO3ykqMP49rpACaXf1s3fZ3Z3eUUadl3g0rZ2cmIBrb3Xin?=
 =?us-ascii?Q?eR5wM/JZDMUozKGHuDCqNS1XomEhP20=3D?=
X-Exchange-RoutingPolicyChecked:
	c8MOWJq7I6dpNcK2i+nb6PvpOcSt4M7X0W8hRShuepwNB/5Y8iW4BQ36hSfBUpBX3qjW9GDaEpteLUogaRRLMFQ6mEIiDDSNrZtMT8RQItFW3zfyT0gv4wJS1089ZGy6Kyu1DbsJQQLIT20Exgv8Y7+EB3UQ626iAJbKJAoH5zYyG/YwtyoNLAB/zxlpdzab/SZqtTdpUD9KrkoIFELUO86ygYVH+Y9zU+aHJQbJhPXDWELp87JpXo7wLbnIkLr8Dml74GKrkJl98hePRY2Am2IL+JY9hxAXqqCy9ifLP0Elb98FbMoQwXHEL+lJzJmIMNCblCFsOkB93iZWyJvJ6Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Fvfdc79adpPDi/96VygK5RgRuVr1s0mvdEBkJ97eSmhz/RgUmN4B/yav8wyDPXEgPa6PW2JK1FJrzUR+RpffbKHQROvMpSY3hPVhwvudsmuJPhJRQAi0GWKfKzAEx4ETyy8udqhEROWEtgd3RohRgWxRQndLR0P/OG8NvG7WHFCk/ipAQe8D1ymzyudbehzyPoG/TWkvecgiBSG2RGeQga3RN8HqKYbsfxEBMetleMCN32UAvkcxRpNE1vkwJPjVpiqHBOTD6bu9diKD47bfm5x1/4HYs+hG1OQYeU60/Uc2goBHB9REr6RCwh9JilCModWnNQMh2Mb1pbD/DHsb8rHTdM5OjuEWdc/HaXQaO1/RJPoQujEa5Xyxjesr+6+tXc7WoItAIsppfGUBDurXf4gfci7uQZrj6cObRO3VGyVCM7KPSSMWINU0GnwPPHdzCw/1ZI7crA4crLJx0c+IyBLKpqraJJZEEm+OreEMDPV7uVZ51V4OfTGy7R9keTvuKWdBdZ/77WBkDWUkeahwJg5+Mmx926dEKSVUPWQdKeid8fSjb28NGgI+KqZjdD2hbubIQJXd/CQCpTVk9lrKzAXJRYYF7RV/K1aGXZMO/XI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce7cc009-5fe6-4434-c78b-08dee03fd6fa
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2026 18:03:12.8724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hJrm8DxnIHhb3gr7thZuHtjzcV04IK+fXGeAL7Acgq+G2YXtxa9leSLwRTqpkmO/jOgmKORtyAl/Id2OJBhe90pOoAQ77mkKr/d2esJ7by8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5624
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-12_06,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 spamscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=799
 suspectscore=0 malwarescore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607120194
X-Proofpoint-GUID: b8swGe8ps7ZluVcMXRjfN08AjFDT2G3s
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEyMDE5MyBTYWx0ZWRfX9SlGIowZFg+A
 D9PoXc6AU/nkz22HkTX5VT96KC4lp3VfzExStbD+jGQoKEtSMgLN+EAn8qPOLWX82ZuP+Zm7yGw
 Cf+izEpZcfHgdl5dRGvDaPo2D1Ix3w4cNkW5+aFgWNC7GqkI4ybY
X-Proofpoint-ORIG-GUID: b8swGe8ps7ZluVcMXRjfN08AjFDT2G3s
X-Authority-Analysis: v=2.4 cv=dYawG3Xe c=1 sm=1 tr=0 ts=6a53d6f4 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=7Ko4-yU1ESnuYVGe78UA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12222
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEyMDE5MyBTYWx0ZWRfX+3Kgz6g5kwDJ
 ue3Rqy+MWafj1e3cVnmsBTpy0pfNdhqiGAgj5mtfdDjbT6T2+SfsKK8UKo6V4eN/Gh8hom5J1b/
 OLnbL9dlOuef0auwvu4iWYUteJNu0i6Gk+5z4jZpGD/1iQmsJ0zfTw9c06oGn9vZcta6sdw3u4i
 M50f5MH6tMl8Qfew6MbZQS1ey+wkU/tIhLaU4gzW5gJ4HXmYC1E4P958O48S7XDOz1SHFRj184k
 NDZ/Qhp8ikpd6+wB0OXo5G47R6dAGSno3uHr5rlgQcVzgLJr2hq86Fjiqm1zNuhLCZTkjblh157
 q3ahdqshKhpBFwDnJfp+pHNwuZ3uEXanw0Kh4ljvO17S+n86nr6tBN1UEkVY0Lf8og7pJCNNmYd
 77yLpZy1hYFrawhPBy/e8XZ4LiiSbHNjafhOOTdP7elcF95Vtyz02Rl7TklbBTmMSSCjpzd6+/b
 BVRk1PiWUNzOJViE8fYR5hpCVpD9evn4zmKcRjIs=


Can,

> TX Equalization training currently has a few error-path gaps that can
> make the flow brittle and can leave variant/device cleanup incomplete.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
