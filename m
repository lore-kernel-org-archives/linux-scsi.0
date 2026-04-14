Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366B9280318
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2026 03:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776137240; cv=fail; b=cRNlrIZbomAuBGVpii4oYw6AxaRYSoP99LXh/c0NyXwG1SGdk9IQf775hInqhI0UMAdDCKl/i6FwMwJjuy4l+aG6WanhF+BMQgFY2cgO6umtNMqvNoK91expHyPNKb81h5GqFaBrw+fbxeJU8TrmhZQzIm3rlWccyEC9IkoJ17I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776137240; c=relaxed/simple;
	bh=3+3pdHtmej9cpyX+KR+jEN2TM/JfwoW2/5j6KimHvmk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=kdGm9kOCC1du8vNFJEsv7aCp0LmjZMrIGfjmUd7XQzMbjaVyfPtZ4X9xc3U7MKFOV8mGeKsgINSNuautDub3AmS7oCzEC4FBtv/ahzZ/fko7ulQrqWxd8Xa2AQWl9lDmD2HJ3lu87452zz1BUK1LQEDDJL8zTEb+XsNCzz65DGQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gmgd8WSf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xmwZT4lt; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gmgd8WSf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xmwZT4lt"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63E0V3Z91751255;
	Tue, 14 Apr 2026 03:27:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=7elb7e0cp2otl0192Y
	Ov/mnQgMSlru2GqgV4DeiZwv0=; b=gmgd8WSfnuOJHuaQHODB9bKqSlXCpMvhbY
	uIPO8hvudVEQNeNONseQZ4udlEPzPbEYaC9k+oDNyAw7PIIyRyXX4f8Te26msHbL
	2ds8GN1UNA3lSvONfDURBZumYY12hrdUjGb7YWHUFVHu1c255FDTdAjGgMILd+6i
	rk3k0+6koulHZGmvxMk0k85Fq/4dPVOHtDdVazF6PJjXUgVQ3kiu7XCiclwpJ3p7
	6y/vwpGPT+6b/s0IJRdmpE1nG1TAgm5AnJwr6QH5f2TYFMz8n4rYMUFTmIjN2Ff9
	OAebopMt27PzvcEzNoxUVN3sxGZ2zXCTaeXjWUaAoBGlsthngd4A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh8680e0v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 03:27:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63E3Omuf026617;
	Tue, 14 Apr 2026 03:27:07 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010035.outbound.protection.outlook.com [52.101.193.35])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dh7nktqcu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 03:27:07 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nEzJ+Fqo88Gihfr/VebX0wwaQhfHAUA9cR+uh+1XMFZWnuD0wgZeVOSiJot9YznPo2IpPSLpzShlH8Z0gDMVsdMjDx8MNTbIzrMfgPVRW3a8YJ+ggHJc+E+SCUQFeBwPzDuS76/8Ra2bYeAlznAh7J6xylr2V/AEELlBOeEMuGtPsikBg/ymSghVkWflUiPVnqZpPJJTt3Wq7qSV7mX04gBXZ8VmovkFKTzjLBjn9hpFLGo6yjy0A1UexoPiVjfWloeYYq8xU5hATERUmRn+C/XulatRyDpDIlp0AbxYyOm4R1Wx7fECWeStpvyc+zmZqTXtnqvgrSRqRzNL8Kag8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7elb7e0cp2otl0192YOv/mnQgMSlru2GqgV4DeiZwv0=;
 b=Kqp7xXNkg3avomiB3Mxz7JWEpBeANgaDMcjI+rRmWFopOpKvsL+5FDuPAV6g9i5A3EEm5RzQixqmbVN4o41AA9FVSG2/2puzed5ovvUYt27kUuM4cxm22Mtw732Xe7g+Y/6VwTXgm5U189p7NuO4/E1umSqmcQ+CTBBZ1drbJuQE+8qgjU+rlGMCC0A3O8UpNwl6QpK99ajqEtuYH5PhVfjwKVfkRrHjqXSYiFp7+Bd9t1KQlKQ0H59YagJ2wKupag2Bje762eIVbHmDzp7gUsYbYykOkwdr1K7x5hNks0Da5cgEqp8zUZwed77e9jcmTRKy9kp/Y5gw7NC1kVWpUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7elb7e0cp2otl0192YOv/mnQgMSlru2GqgV4DeiZwv0=;
 b=xmwZT4ltVAcGNJ6aKw1Zxrle7an43MDeD1LjAE4p0li2tUeqxKiRXCCE5dTKzIEEw6h/a/kRJ37rmKl8beP6beX95RN8V75QWy6WHAR6I0+mH3NBjMnEkavOatxhNwoG/xI70Lv3Erf5xRPg0LeeLCC1HGzFiHMBnUsWzoV4zVg=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM3PPF0275307EB.namprd10.prod.outlook.com (2603:10b6:f:fc00::c06) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Tue, 14 Apr
 2026 03:27:04 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9769.046; Tue, 14 Apr 2026
 03:27:03 +0000
To: Johan Gill <johan.gill@bahnhof.se>
Cc: linux-scsi@vger.kernel.org
Subject: Re: How to handle StarTech adapter
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <b8c4c8f8-2b7b-4e35-a750-cff8b50c295e@bahnhof.se> (Johan Gill's
	message of "Fri, 3 Apr 2026 20:52:15 +0200")
Organization: Oracle Corporation
Message-ID: <yq1v7dus01f.fsf@ca-mkp.ca.oracle.com>
References: <b8c4c8f8-2b7b-4e35-a750-cff8b50c295e@bahnhof.se>
Date: Mon, 13 Apr 2026 23:27:01 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0040.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:2::12) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM3PPF0275307EB:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a57d8f3-a874-4d71-44d4-08de99d5b298
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	lSsJap39/faDoXYNnHJ7nl1pl8TK/pQpbe7n3xYaS6G2vg6uFqAHbe1/RLsm889vAudeBFy0O7hjq5XFg8u02e31hxI7U5X4LHHPbsWWJb0DsVxDcgpUadkvCQLVLmnhPbqgusmyUASW267oHjT73TTkaB2b65KAb/s89aC0H3e2B+59mDBISVKUZOUcJySOMvQXIcgorOCGcT5nOZSIkydQc8RrNt9X9rsXiuq/+fvXJRDpH9h/X9SuAjFepzjgRbnd1RHcYSlCDWQMPPQn6Fus7D7UvpDQwT99TCtaQ7gy3najYgoH6x3kZDD7dPkELQ3CTmj/AUenscdyaNf947C0e15o5+QrFgvI35sSDywRezAMNwmcnizyhz++NNegBpzZDRq+lnq2g3Urzkz2jyy/HNYbmt4lLIKkF1fI6L42muRnqtkRt0mB8URONXYOjdn6mvhhUcYhkcHAEIh/W+Z0e6bumyThvmBJV5vsMoVeoXorpkgNN0PNBZmTDqfiJdKzGCxn7oohH9L9Ecm2rXznbsSGgm6sWtd/BY26Q3xXJzJxWOYgqS41ObjwYom0lakOyTpoxK1uYa5nL1k2RThfH2egY5A9RM5NTyt5rJe43vD2JSTSdRWS9lPygwT7X0fiMfFEV/s0xhfoim9lv8zqGdwP6tnkwDHWYiO2M8cKdonETXmWrISGTI/fmmODRwdqfHcsgsLkrrVt4fJgzgqVcirbyOk10OJ9hNmrx3w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jy5CQ7FRh7bkrkGceE0tMVGnTE3wEux5KqeWN8jPCocgXgzVn++5MvGogVju?=
 =?us-ascii?Q?xlqy4263oJlLjHw8/tNTI3nN9dKZaDFfeLK7FSOMzWdwX7BXgAGWV9wMiN2W?=
 =?us-ascii?Q?K64X7fbYItFH8ZJH8R6wTG+ufYxUs2ThgVNDTztkcN4p6cXdBIHIw2I0fq3U?=
 =?us-ascii?Q?a94mBhSrlG28aiz7K1uQHDpd96cHUxwLn9+PCP7zq7ilHdh+xc582TPxRaS1?=
 =?us-ascii?Q?MC10zk5DoQA0uvIjMqdH7SOsQjz+6ovhjcVdUlcqrCAgtRW0954Z5KU7OK2g?=
 =?us-ascii?Q?iU9GCf3nD3/9ir7M42ZLpGH5N0ZBGre15GHHFt2yPz/NLB/NiUfgQceAC6uk?=
 =?us-ascii?Q?K62pDxoqADVzfw23hqpYfrtrBNMmhHFdeRkkjPql21QI8dnCV7O/mTfRLuHR?=
 =?us-ascii?Q?LB3mCRAZxM7+lnJAdQZwoBr/g/8wzOckuMVKVqik57IYX/6bdkhPfgZfKkZq?=
 =?us-ascii?Q?VIkoxgLOwVJVG0c7/aQ3QzrdbsxPiHvJPiPzzpZlvBgriwx/UXMtjSE6xPfo?=
 =?us-ascii?Q?REuoDXomi+43VOXZ4+b7PBtRB/IuksWRqLPnbpOdKO3zHVEvaPNorFyYEG8G?=
 =?us-ascii?Q?qZ5KQU/Dv0ET6x0TusqAw7xJ35/bOuzq3WAhgCYfzsWv89bCj9eSQ6cDaKmQ?=
 =?us-ascii?Q?rFZjK00TaJqFmStqaQ4Kn72n2EhNr/zfIX/hVU9CKBg7uD2yz/9kMyOapuac?=
 =?us-ascii?Q?sOpHvT6cK6MQTa3gEH0rYtBRGzy7JfZz+i8FFP0GKoJmIKp6q/CBj4cY7MCZ?=
 =?us-ascii?Q?LXCb9y2thi5T5Sp/Ul2pKMxqJM+9kudBdDW7QiOIiRTitd22e8KvwNimPzlO?=
 =?us-ascii?Q?TG/nx7Hp5EJEWuWdZfTE6zRt3wBIzfLl0MA6TgqINPSGgSkztUTVMqOF58gr?=
 =?us-ascii?Q?n1E7h60MUTyisLkJssWpbjvZ+rszH+AWYd+zcc6dNZfWPZh0aGswVoQdu3yf?=
 =?us-ascii?Q?DHPFc73YKw+ZVtBljWe6vH4OZuU1bma2/WbWvyn+Xp9tfmmt9q4jsl/+UeBi?=
 =?us-ascii?Q?iO2GF0w4rU3GSuDLwJd3fIzg0KJvRrri6Yni+fycRzr6lsHzcnG0PWhtiMEA?=
 =?us-ascii?Q?RBB6A58C6WacE0J/fGb03sq0jmvJmuZ5fwo1QliQfll/cHyuRKt42U9xWBWm?=
 =?us-ascii?Q?ajGG7eP5J1j5sSHp9xdrIFFPS5jM4WB8lBJiuWvKJlOX4v3yeEer4KJlzfWQ?=
 =?us-ascii?Q?xjfsQGaNjzW7XFhKTbejiBVg+lFJjmCQkv/862zPZTGKJZ5SufY1XOSxZ0fY?=
 =?us-ascii?Q?7irVlccJPqfbCDE9/OHNsv2MMFMQ56CbY1jgdShXWdl+ggvcDDcX/3gJiTyY?=
 =?us-ascii?Q?xdyzGs5DiIQ7hVETHG4Y1iemM+QqV+u4+fWG+gn6dcsKGxyUu1qxvbwmfgBC?=
 =?us-ascii?Q?iYZyMJanlCpG/aBhIIJWahDU7srGDq1wamzKglD+JO5p08qvIDEOMg+2Epun?=
 =?us-ascii?Q?M2v/dnCZE77uhyRsftdKWwYBmspSzDfBr1LOwLaOOT8dtSz/m+1AsTe6z9S5?=
 =?us-ascii?Q?ROUOOD6FVn1XFoPMe8fbcnaZO/r5ZTifZgledc1pT4sGg8L1CJ/eOZ8comNO?=
 =?us-ascii?Q?UQ68i4CuH+isZXP4LV+MX1GiaK7W492sd8HvuaG/rR/8L6UCheHj5BaV9BUN?=
 =?us-ascii?Q?Znfu+8a1Q/lFP+BDnz0B2oCPPIgp8uaHjQQJ6JFaPNluA8fIbQ2fUQF36hyp?=
 =?us-ascii?Q?TKpszGK9yS30elmwFZZ609Ti+aqL5tl9SkmH5rzcYqxCfniwyJnolqkFxVi0?=
 =?us-ascii?Q?qTRBNLfaTTMT69W+a/hG6Y5UaF4VH1s=3D?=
X-Exchange-RoutingPolicyChecked:
	vRjl27cxNmFkwVE6lEakot1sLNqjJrEh8Paq8ln2S/mAFeToaPciM1EqmLg0CibA0t2zVD+z9kIgpX4IbOfUS0SA1IgWBPWSAvxhMywOOE6jQX69Y7TxRIpiarR1RR98R4ECWXVuH2CrlNAW1uvxQSNzU7YmqJAdy6KY8uHXFrF8RZJ2M7Mkmm3J3I70aEC/7t+xg2oQwamVQTxEDM/7cX+8n5+Iz9mcO2QBOwGmiAWTvy+5QMieibQM3ctCpg4a+oUuHBNoaJ7pqI8lvJuaKQLOGDIeguyNh07S0mqOOsK7vej/r1gQ4gEgL3zIpRpQAA8vjo7w+P7/fN2FBESKtA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	M5cahu4jnqfc/1/DI3hA7xEN4oTrymuyYS6ewsWhMd7ajItoA68A3MbcxqF3GqUqLPUgnRPsWi/Tv6Ys/WfWp6MzG43K4nIfmC2PWtaAEiX7aagfgcjsgSkNHBhe4ciXYAiT9zOvf00sJYpvpGINLbt0eztYiTDaJOzUW6GzN/gGQc7yuDq65W6wplYXhnJIIj5R/5dtYVvnzJc82LjnjPqwTJ/x1mQe2l2KeMrmlPT830eYKdKRz9OFOQws/hDoNtB+MbDGQ3P2AdKaXbj0xj7NESZ6/z47ksACpRUN8cfaIc9uf6vFJKr9pon9L7KYklZnNw/1wbr1wmty+6U9NtOxEjwqT86t/sRT0kWazUfUy4PUT71ClwgAWcgqlvDu0+FhsUJo10BZjCAS2GTrUX4WhapCXFvpJyfvJYEeSpS+5P1owvS7B6D3DtGVKTvP1GvZEdw6kPRoiPLPJ9mzhzWGWThBjiU9J+INiQnbj5DQTEOnEdysunLJyHVFPpuL/KE3d/UucpRTioQIxCB8ZkAOBXBbK0bSUC/gKn9dMJT/svaVs2803sR0bm6ict418jg7BM3YOAlYY3xO2QAVAkTo7jjZL5gnsUkDSeV9Usc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a57d8f3-a874-4d71-44d4-08de99d5b298
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2026 03:27:03.7907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LlVQOyvVSmwWDeocFaEVWfVquMcLc8hzgfzvzdhK2Dw2+qR1ypwYqL/Gdo3PyXaoN0DEGwlZbl8ABhpIc/5ajV4IhLRp7cDcriYwPB4wv2k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF0275307EB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-13_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=837 bulkscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604070000 definitions=main-2604140030
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDAzMCBTYWx0ZWRfXwBZFvHIxPecm
 wIPcDQxSXzAYMsbzX9ggGkaJMIG30ntnp5QYAc7CppJEJgSi+nl/ndXKGWwE8w4HFcrLfmB78j+
 x8ihwtZE/sF43FLE/CSwo5PFgXwwT43+mZzVYBFxT2SG4JjRrRdeZ1AJl2Zlq2PKSC7ra6VatpN
 zCaA/JywKkaBHSAGLzypn+RSK+q+zXfTI/aKhwyU3Gs3sXLIZIQYLRHhj7IlTkwCT/i4JNRnZ/F
 LertgRvA7mOJJx1JEhOJfDEmpSj9bTmPvu4dEuOo8S+ASuUubhXwGK3oLkOSb3ECvU+fXwpA2Fg
 dygX504EP2uhg062QekmYCeMLXwPOv8PbziRCys7XUutrwvuLy1VI5uPLyEcHU7seO5ZWVUTXDh
 gCxawvt3Z3BxN5vlOQHdHxBJYxQWeOPOrDuHxUw4J5LAI0ZLF51EcazLZzWRkmd2SSI+4tIbDqZ
 OFMuVm3tgeYYIt+rFPPnOn9xuxthW9XWPk8QZJ7Y=
X-Proofpoint-GUID: FUotYfF_lAe_7mMJR46ue6xJ8jm0lZq4
X-Proofpoint-ORIG-GUID: FUotYfF_lAe_7mMJR46ue6xJ8jm0lZq4
X-Authority-Analysis: v=2.4 cv=JY6Ma0KV c=1 sm=1 tr=0 ts=69ddb40b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=TcBDpYnCsJsOWghsbhcA:9 a=ZXulRonScM0A:10 cc=ntf
 awl=host:12291


Hi Johan!

> The cause turned out to be that lbpme is not set, so the other VPD
> information is not considered.
>
> Would this be sufficient to have a quirk for this case? Let me know if
> you need anything else from me.

USB bridge adapters are notoriously buggy. Your model may produce the
expected results with the drive you have attached. But can you guarantee
that it won't corrupt data for somebody else? There are definitely USB
bridges out there that will happily trim areas outside of the requested
block ranges.

Consequently, we have to err on the side of caution. If a device is not
reporting that a given feature is enabled, we defer the decision to the
user.

-- 
Martin K. Petersen
