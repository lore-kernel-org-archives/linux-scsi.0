Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC6F38C2D4
	for <linux-scsi@vger.kernel.org>; Tue,  3 Mar 2026 21:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772573609; cv=fail; b=gqTj3ehFZYcUnL9dKyKkL82pAlbH3swQyQBPGhnUMYy7LvRwwE9ZlRkQrgj6ZVLPbKtMM0/qon/vVBuO0/oyYxeBWcRcxLNjHJcpIRB11E8OXpv42NgHkUoGUP0OZ31kiX9QYkExsgZNHQn7Idyqu3SHCF70dCwGG+cpFFUvPU0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772573609; c=relaxed/simple;
	bh=8oens+l/22VVfsbRnCqwn8aCd07LV8/PT7d0D5xc8Gs=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=gK40ahJ/jBMXQCKhjaPNbQ5N6V8SnAap40BPDVMcjiSfcmhWIUkaKspBrGjv7R1GzW7iIhlfi0rVGaK9oLBq22a1CfZwnhCSXx90xOnxgQF3Ic1kAMCK6ELVyVFjnXJ1ee4jRuyqSXLryfyV3rwJ8p71wMb0nLcc+2pDH0/PLDg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jtz0Deit; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zxaNWVcM; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jtz0Deit";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zxaNWVcM"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 623KbYl5763046;
	Tue, 3 Mar 2026 21:33:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=zHFSie+lX7yE/NrG
	HkwMeKnMySEYqhXWvHjOnSYEdZE=; b=jtz0DeitXDNpxa6Q41Gar9nB8bRspHFY
	+UGZwkrF68OAGpXmlp37YbcR7F29s3fI8LSOgDeWo32dE7/0G52STzbNCAcfpqfe
	OSqAosJ9kY9jKFiyBFCw2b6sl2JU1H24ESIEzS6k8BAZOb+F68eoCQNhOAyscVvX
	v6/QX9Vxhkb0HIR7OsFG+lJSjC58cNlhxzGO7Y1WkCf8w0S59hyLYwY+95OpGmKW
	i7W4nHNLxuYO3EOOq84MBGW6Ckz+PXabBsI+Kil9y7HM4kdkVZbK80sJr9LMw+VH
	XDardYH2tRVNOZeXroS3E6Hq2maPHkp/b9MLXnhK253lkNhenTUlcQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cp6uj02c2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 21:33:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 623KA49E026843;
	Tue, 3 Mar 2026 21:33:21 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012029.outbound.protection.outlook.com [40.93.195.29])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptan9hw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 21:33:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qc7uSi0/PLoPaK4usrf7BSUBYke/9GqNmoKfwjZGZvmgbASRcl1V3Wo1itVrxiGvrawMMESfQvGBDKaSTk+5AwX0iueuPiA7/DhTpEFS5n3gdz7y9aEcB0XlwC1ml08129caDzLgfmcBQEw/fCX/UtgOL5mO1I+2X8Sin7byh7kW1FjRh529c3MTlq+jEYbITqQxPS+7xnoxtxIRCFBgBvp6BrRSfmsS8TpsZu/VmHbfuenDhvsVY5Tnce08EAwjYHHMNguaqu+W/rx+EC3BDnkmYuBbvROmJ9gBvQwyPO2WWei1cX5xL02+O9BUs3BKlolSeyUzixb3eBXcoe9qgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zHFSie+lX7yE/NrGHkwMeKnMySEYqhXWvHjOnSYEdZE=;
 b=aeHl4p3+tl4ka45cXEY6fYlmePYW9WwPguxyo0oeNOD961ArO9D2u+5ep5mobix0GDj/RYnZBlnMi/oNxncPEhY5RfWElRNviPEaHhBiCNKb6HiVYg693Kn1gHweVJVbxvP6uAaFqvfZGdT91z+6gLVs04m/WtfWm0Ti8/Jj/8ZDhF/61UTzFHTAW9h0qoXG/ZjMYtp/9wAT44l5ZJSxtxwubOCq0OCx5n2aqZzA+E3vAlSsQ1S3qhQAPW3Eb+lH/hRGk7tRKR5bVfgAHHQ0NnIwbAztwGiwLSDBLzf9P6Jfp3T0NOyXENuHKOVWjkQOkg456AkGlXZ1yFtbiswC+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zHFSie+lX7yE/NrGHkwMeKnMySEYqhXWvHjOnSYEdZE=;
 b=zxaNWVcMpTODLCYxVt/bQ2m51pbkPJg9IT7edbtb6UDUr+RHjQgdefqFsIdNIGVRdy4K0r5QcjGBy/UuRQt6Nei5V4su8xkg8qxysSaU7rshKDSXVphDVrPt8bp2wAeyRFJQrxAj4iG2eXf4eWvjflVi12zsgS/G2u3JWzwH15A=
Received: from DM4PR10MB6885.namprd10.prod.outlook.com (2603:10b6:8:103::19)
 by BN0PR10MB4901.namprd10.prod.outlook.com (2603:10b6:408:126::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 21:32:56 +0000
Received: from DM4PR10MB6885.namprd10.prod.outlook.com
 ([fe80::544a:41ae:543a:f8ba]) by DM4PR10MB6885.namprd10.prod.outlook.com
 ([fe80::544a:41ae:543a:f8ba%5]) with mapi id 15.20.9654.022; Tue, 3 Mar 2026
 21:32:56 +0000
From: Junxiao Bi <junxiao.bi@oracle.com>
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        michael.christie@oracle.com, bvanassche@acm.org,
        john.g.garry@oracle.com, junxiao.bi@oracle.com
Subject: [PATCH 7.0/scsi-fixes] scsi: core: fix error handling for scsi_alloc_sdev()
Date: Tue,  3 Mar 2026 13:32:33 -0800
Message-ID: <20260303213233.43166-1-junxiao.bi@oracle.com>
X-Mailer: git-send-email 2.50.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CY8PR10CA0036.namprd10.prod.outlook.com
 (2603:10b6:930:4b::27) To DM4PR10MB6885.namprd10.prod.outlook.com
 (2603:10b6:8:103::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6885:EE_|BN0PR10MB4901:EE_
X-MS-Office365-Filtering-Correlation-Id: 79b44203-e5c6-4638-b2e2-08de796c6efc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	gC+TYFlRbGzoGw37TXO81PM9mu73gpXbqPF5pzy3imGaEIA2WXSv19yZDd5MffIzikkZ9nKfCfjzP6Mt74YuzvytUyQa6Ayq49e1n1tLSX7vc90JsNd4d6zwb2dE279jJLNUVl6y8RCFPBdNmd87s45hq+NmyHsUPtESV2H/3eUjA1sVF33xYdsp8o5ALBRtTfcmoxn46LZAAP4SFwftYOHCsipZ13wY23NKMFoAkZiOaJdnbXSCK/LLJpyO2gpAafgoXkxotBc6HmgxQdWqhAe+FTphXZTwecrljYxUUCwZmqcXBgFxZdUf/LV0TXQJ5WaWrcv36k0e3evBNuUDuOprFeEEx6Xu23wZ1WzPse1sfeY2L2x41peAux//M8RISUTObJLYFhXMRv21B03PReBWM9zKzRqQedQdr6ftMpN6ksW0aC1q9Q4nleixzbW2lzrfXw+nd7yLathm4b/egmq/g69JCaL92uMFRsk1il6SM1D8fCupWhJv5UEePsHpPR1WSCLggYcVr4FbsEmw7Kxp3I+s1xG4GvfUhDPOCm9xsQxdFwtlgdZgFyfOT/dSJEi3k+DZq3Z29jVPPGqUErp5inFf5LCKlP4f8xN4Hnw2IdpQbzenno82N+dOflwoAdleoUZv9KPfYxFF2DWYFW7Xwh9MtqbaR/Taf1dgBn1CHdkAsahxyy1QLOdwb0vsDcYS5jKvqAA+5vHGSRGjRqEza05zAw92zR7P9prOCyg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6885.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qvwv8EXB3PbWW7Fym8jW6iXFtYbvYF8zheK/dVNLG7KFCj7tk/4OzKnguX6G?=
 =?us-ascii?Q?o/830AutkXckUzb7/xOa77n1sR0gb1QD5C1X8x7M/b+knkZTpVTPB+VJuTZ8?=
 =?us-ascii?Q?dupxrBQkz8WI8cBy0/6y9ypq/o2j+LX8W2w1/zXU40YJmBQ0IpMsJdKm2bht?=
 =?us-ascii?Q?SbsUAFMef4pDQx9cidmIaCLAXQU90EBzv4kW2IbIC7Wngwf2iCBNtoaFGFmU?=
 =?us-ascii?Q?OgJmzYp+i/+6a8CIJTiLGin5X9QUzMpI9UnZDej6EhP0jLHvSwuU77xAAGvM?=
 =?us-ascii?Q?KJWFXB5zJCRZLj8auj3ruV+nGqsYw/8rmO0xIWF6loEDd/U4DFLOIIWj3rNj?=
 =?us-ascii?Q?braLlxIMEt3T5dzWBMROn8ylhxoQ7IF9t+9/yYsvtyyHDrLo/te0gZfP37UG?=
 =?us-ascii?Q?V04vnfHnQEO7WrneZNkNBCxoMuV4Qw0HYf1HNx6tEm0QwRmYScDWv/7Q5iKo?=
 =?us-ascii?Q?7GEKuiBInxhJiM84QrxV7dUVmHY9aAeqAnknmYSbU75o860MFIIuvphNeG51?=
 =?us-ascii?Q?7kY4ZhY8wXbUmVga5T1jT1LdqYqTge1fnWo5BXwWRJ9pkbL209G4VL665K2a?=
 =?us-ascii?Q?LJ1SD/V4/iRSfYPvsan7QRAV2HEFfr1TrHTHqbA14OP5hNGRRLG84HLRfPOE?=
 =?us-ascii?Q?WgseRFOLM2G+QJy180vI1Mp9idyWTtvlHPioZ/h2C/ieDPLw8pAAyv/xh/8i?=
 =?us-ascii?Q?QCU+WK2txbX7mKNkf3dh42fSgyz1zvDBm8SMW9UUGwbo+WBFCdfNlbOYYVBQ?=
 =?us-ascii?Q?FJ7hbmuHymC+Cg7CerfhYgSLtbGZuIzM/GYasAKupGsfFNqmzXaNMMtGPvih?=
 =?us-ascii?Q?Omn2mPWD6l/2Uqar2yqy0Qczaz/49cwGmU2TDWcJvx4TvAU1g9U+Ox9pv3GL?=
 =?us-ascii?Q?1hs8UBymMgVpuNnaU2YlU+Oityc30QKrOnXNj1/iFzP662PGjbbXdsIzNjnj?=
 =?us-ascii?Q?FSTyjk26q3FVQn524Xi+FPT+s7c9Oggt1ntdvOKsZ2PEkBxLWUi3Au41nfes?=
 =?us-ascii?Q?7q+t9zg6x8eoCmjeNJEv6c14fO/RzoqUadlU5MRnehQgdUPDjHXOwomD9BNy?=
 =?us-ascii?Q?hUscvxkoCRDYlBjXUDDzZU4vcAlmQuzaIcENmRuXuLLwZE2FIzONwNd6g+CE?=
 =?us-ascii?Q?JR3NydjOZyDl7+BwMYLoVEma1mzu6AhR25lIr8RGYbYmJjiOSqNIC/CD/hGc?=
 =?us-ascii?Q?496QpiH4rd89WH10zNFjrNR/mZ4tKy9T8JsWskJhYP9ZUumiTjtwdBlTUGYP?=
 =?us-ascii?Q?sVu/qXPd9j1EJ6e5KTC771MfHwGiCLZVwwG7WYb2uyEaTQ+zy3H44z1ajwx4?=
 =?us-ascii?Q?8kq7DPO5nu597fOlrfSWr599Onsn71NzjjW0+stP/oxIJjX4kuAMAPECuf3z?=
 =?us-ascii?Q?qm9YGPlZCD3zQXYUTtO0ETldPJG2ye24rMLKiovU4WoIWYbl2EeWB1bt+SAZ?=
 =?us-ascii?Q?uJKz1ttGt572tZ5OFOcUBUlf2krPXVBwarAKfg/IShsNnqjChTyj8g7deJyo?=
 =?us-ascii?Q?S/S5eMFgOD++6GBiLwUgDQkr7sT9tnYXWbnW7LQSxMKOtMTnAVYS0LKo/ANV?=
 =?us-ascii?Q?RJ96aDrAWwG0MjkDafLN3N/qs4tHJl0Z3hinQRReLS6D6Q+0ZEMRzA/2SlNU?=
 =?us-ascii?Q?QkVRKGJqaVZ9Ymgba37oQs9DlhA4H0+QX4svALrEctx1QkpnUOsXry2+A7rZ?=
 =?us-ascii?Q?0Mi+xY7QEvbNfhj12RH/Pk94vBPdERPHUVDEv82j7GCb3vln78torPzB+vQf?=
 =?us-ascii?Q?so+OOKavCw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VANattP9eYhQAPoCSR3EwPB926sqOygms6CZn+xqv3IOlrE1t7IP4qjEqOCA4ijBxtoYSXUvN6TaYuTjwmbVQv6/bZbFRxTBrEVYjKso2hv0vebM3roAsCvqitJqaC3mUKpq0kcRdyF8D9mCLzm4rRnR6sbbeufjwP5vlYnMo5+lN5/xyQvnI3QcODrd0ndJhVkHjNtyoKV4hC7HofKr5dXLyNt2Kd2IkmJHrMzuoGh6rE1OFZzFjO2Uv9WcAvKGslNmoNxSF7LIhKCoxGAV5N9Vfu+zqjvZecuFU1pRIbMom1a3p5Xn+iJDc6OdI8Nyvqw/WbaGJYEuLekhTvTj78uThiY1wy7aoGxAr60lBCvCY5eR63JQF6vyncQzaLpMIJ4gppw3uo5WUWM7RkwXsz2uyRSCTgROMmEuAUyjK+uuD0Xzix9+EW/XLqwIKEm2ThBUiT0TuBcbfFalHNZlUa5JtvJIrUXNyL0KP2zQ5u+aF6yMlRrF5jV98noKfDbc6vFsCEL7NeerwZc2mimE6tvDu7gGlWYcY+cRfMJkzpoJnKEsvETyOjUtDBIh/3aCcbTny8OSqauHHHYPTIUReasxhv6Gy43pgliTT0nvBLE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79b44203-e5c6-4638-b2e2-08de796c6efc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6885.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 21:32:56.1554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lMuaKnLkEmI7b9uixXBWHcLBxx2nAkg7QxlRc6O4aHn3+Zs8w9OjzjbPv26c82oIU5nf985BGtEO8rs12zyfdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4901
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-03_03,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603030177
X-Proofpoint-ORIG-GUID: 1f15MMsfhOBSNswI6OOAH2huiBkaPBPw
X-Authority-Analysis: v=2.4 cv=Q57fIo2a c=1 sm=1 tr=0 ts=69a753a1 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=CDkjUh4nk0AtzYtmg9wA:9
X-Proofpoint-GUID: 1f15MMsfhOBSNswI6OOAH2huiBkaPBPw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDE3NyBTYWx0ZWRfXx0j1ykVldBIJ
 CRk5m78LkDYnr8X54fBgc2fEwKU5vtU3rSN/GqBcczughIZayU9OKdqEzzRBuJpCfGf6HomZK9m
 30eYjWerR1CJQ66xbJrekyeJCf+5qpVTd9oDNgpk5X4IQeDvw3lTHMpTiLHSXCokqYyrIWzk6hF
 46Y+uhp+4BcKpxE/HyRICPUIgrOL6ep+lzbA0mP+ne7OFM2bXoE8vJDsB0o9qh+/WhqdWqpc2u5
 z2JV2Gy1T6waNme8FGqJTMg9gcN/QE2wT9XAEHdU6tdJe/KmzWz0EAQaGz9HJiFqgdfWokev8XC
 0G8WhkG0Hz4PS6Gl2ZxAOV0IY2QSbOR3Ml6NC1v+fEgTIkFRHTltVRWjlCMjoFanRqeVLXdMIf4
 Bvh8IqBKJQ3jQQ0Z/OAxbP2REc0udzSvY+rKPbWJ8M9fJ/URFIy+d0qgHzMLSc58RJ1HQ7x/FmZ
 cf55eQh/p07mjcq+Lag==

scsi_sysfs_device_initialize() was already invoked when
scsi_realloc_sdev_budget_map() fail, it will need invoke
__scsi_remove_device() to do the error handling.

Fixes: 1ac22c8eae81 ("scsi: core: Fix refcount leak for tagset_refcnt")
Cc: stable@vger.kernel.org
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 drivers/scsi/scsi_scan.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 2cfcf1f5d6a4..7b11bc7de0e3 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -360,12 +360,8 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	 * default device queue depth to figure out sbitmap shift
 	 * since we use this queue depth most of times.
 	 */
-	if (scsi_realloc_sdev_budget_map(sdev, depth)) {
-		kref_put(&sdev->host->tagset_refcnt, scsi_mq_free_tags);
-		put_device(&starget->dev);
-		kfree(sdev);
-		goto out;
-	}
+	if (scsi_realloc_sdev_budget_map(sdev, depth))
+		goto out_device_destroy;
 
 	scsi_change_queue_depth(sdev, depth);
 
-- 
2.50.1 (Apple Git-155)

