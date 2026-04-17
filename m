Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54272BCF45
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 23:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776467287; cv=fail; b=nK1E4sxsEZ4IQEmz28VdrXiYG5xar12phhSGUt3BDDunuAZgF0zuxCuPF9PT25yItcuhd8AWxi/9smthy8NC9EFCShPOAu9ewfjDnWbNsmELQlWUAg+b7j+qsfanJWnuKYnRTJWt4Y/TH10PdkI2MZIuytbsrzMvY0BbaGNvAg8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776467287; c=relaxed/simple;
	bh=Qb23XqYPUSOyhKHC9tnDLeCyBnjtJXMXML8xONK29Eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OmO8U81e5DvgFstX93i5A4cZAd5PVP0PLjSZh2zyeeMenAmGI8EGj8I9XD6h2obMD8lSYQyQRCEGDFKCX1UxE6qO3ITrUMEEqH8Mbaj2MoZS2WFqWQTouU6w/NXB7wWSunlajUrKcMPDWKzKCmqC/hfsMq/fZEsSLi6eGUX1eeQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VMD3ZTr3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rAD+pXiy; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VMD3ZTr3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rAD+pXiy"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63HKfXTR1225577;
	Fri, 17 Apr 2026 23:08:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=tIst8gh59jJ/JRUFeTJk4tirFObHzOksYwfwm54evmg=; b=
	VMD3ZTr3YXDPWOsjha/wesv6IPvCiRW4pO9oc5b7DzyvoHasoyya0MV8B1IhfEl1
	6GSVNFNik3LU70YIaauCu+Rs8n84z57BuvGbE0WBIN6juwlkVy+iW0LBf2O8aIBK
	rKIObkaRFFsPJD5BuTokgmI0fCScjD/UxBSd8HYM65zgxzC0xWRZh6MbDu8YHF0n
	Yl9Ud2YaRdiJrlbTypkkdOjn/F48+1kb0yOhf9oVTdOIxTYrgL7w4mzHEd5lyAVf
	CHUf6C7WtkCoe+U5Mjho9AS6mQMVCH6vcuDbW4SuQ+aq8VeoO2vf32PTn1axwPf1
	lKRIWnpyKaXJnGZLo2bOqg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh87mjrx6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Apr 2026 23:08:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63HN4SK2029884;
	Fri, 17 Apr 2026 23:07:58 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013043.outbound.protection.outlook.com [40.93.201.43])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dh7nrbsev-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Apr 2026 23:07:58 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JG/jL1Jtz4sB63H0ivqC8bu53hL4lt2knd0KlKbStRch6X5fUL7kSWc2WGU5Ju1xC5rn5v02cOIXrj/Rl8Wj3m5f02NTJAhA13eHX5aa4APiGOpxCJ4BzNK65OOViFaZMpOo7W5dSspmc0KWe9xCHoTVpucEzK0KUgN/xZ+sIjxpQpkdEkLnkFWR55bFqztPn6H+mgYVhe59HB/THUzbP6Q//5TQRNOFQg3LrbpVBQS61M4CTGs8WR+LdA+UuuV20IgqbzV3N4Lke4m1BfXBYpNU2URBLtCRfyJYprsiY3OgsteV4er/7ETarqpZZfup69UHUMx0/LtcZLwbcXUUVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tIst8gh59jJ/JRUFeTJk4tirFObHzOksYwfwm54evmg=;
 b=qP9MXOBV1z4N/dk2QtSzUqRzbcN9ybFreffOEI8q53Vr17xvGJ1PCanj6I0b1UM3YjemPk4ef0EOgClnnTbmBQwK8XttZHuhpqZSlC0fxEKL5rOFC/El6nB/7gchfPofrcR8PO3jNWMZeDKYR76vqHizdhMws+vYqXL832a9zgqAkri52ans0wZpv6bH6iKPjUdaRjW0Bqzk9nXm/vwU3cd95UTGzvuiMzFtRJxjA8f+Yo+b0qFiCxE7gySVVNr+FSkmebir3JQVb0iWV++SLnAsaFVoYCG1Fax97VT9PuM+HWsVWNP762yuENvzDHAlDX6IOj+lqC6cpjXQW3YfUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tIst8gh59jJ/JRUFeTJk4tirFObHzOksYwfwm54evmg=;
 b=rAD+pXiyQQY+9s2g36OScOxvi3TyTffZerc6FoAcb1FvAmy1GL3ER8/WiRPXVd6NJS3xZvj1MkFMj6LP5kWaqB+mKeVMecLQLzvrTHHpeWZ1+YJvs9D6KTiLcbuaPHLZ8ZuXYGx6U/9enMmp6T3OIkKSv3Nl20VOD51YckY+kNU=
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37) by MN2PR10MB4205.namprd10.prod.outlook.com
 (2603:10b6:208:1d3::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Fri, 17 Apr
 2026 23:07:55 +0000
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4ee0:38a:f5b6:336c]) by DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4ee0:38a:f5b6:336c%3]) with mapi id 15.20.9818.023; Fri, 17 Apr 2026
 23:07:55 +0000
From: Mike Christie <michael.christie@oracle.com>
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, virtualization@lists.linux.dev,
        mst@redhat.com, pbonzini@redhat.com, stefanha@redhat.com,
        eperezma@redhat.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/4] scsi: Fix can_queue comments
Date: Fri, 17 Apr 2026 17:57:21 -0500
Message-ID: <20260417230751.117836-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260417230751.117836-1-michael.christie@oracle.com>
References: <20260417230751.117836-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0287.namprd03.prod.outlook.com
 (2603:10b6:5:3ad::22) To DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PPF905D77450:EE_|MN2PR10MB4205:EE_
X-MS-Office365-Filtering-Correlation-Id: 61fc4462-be35-4687-7ebb-08de9cd628af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	xNqk5UBOdmh5heC2237DlX/pVMj3Rbq7PbQJaj/eVF/mfDFBmJmi9CER7Gx2eFTSviMhJdAmGIsGjGD+UsPoVHp0cK2DLPHKC2NrwN+29uU2OWFy/5Pt7d8DGBlJI4wwCbn6Qnoeepz7OkruzAW5qDkjBolG2w7KZAKjSCAiOSvpEQjXDADkIfF99xQh13plRd2P4R64Ek4F7YrFyYrPKpy/awwM6FMsZ0ExqpZINeQctNaf83W8ciaPvL48+VRSDT8bKev+x3AsZZgaBXqWOP29fUJXlQdMC2Tnf6pQwFmp6NRlh4V16889qPGuwFy88SDX3fMerINHl+U8k7rL8BRvc+7TixJWNm5ZewLV0NbQoh4alPXE5N+ZQKwRKDQNxKWyca53/4fMrhqM7HU3J8nCs6SLWeFXzcO9eV6bbsy5E7rb38DDn980PNsmx2OURntS2PedKJPL0rKX2yMnPhFOCSGIu7tvTS4pkrgHCcmP0jELdZ2hGKTmkC09ZdqniBwiTb1DwRsnIvXkO+nCSW+nw7zuwjVujTlKe5qc9esij4IP1eXIlD+j2hFy2uVFF6Ue+YhQCMgJqQj12xE2yXT9Zjqln/Gjx7ZHNm5uaRN1FOSoF8By3XGYcwjcV4r5PHRpK1oMczhNRIvGsyx9bdeOkqbQ6jSpY6rSy+bITnOSjZwLbQA49dHvNZU7j7qiHrjTwO/WtpnjEa2y2EOQiC5yWKGAiLbhLK6IIMi/9bU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF905D77450.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4y0rg5+YJQbdOby7Se1yzEjMOhP2FSo16bORW+oIzYdxqdn+EKadftDwTsRX?=
 =?us-ascii?Q?BOXun22ATEDVLQbaU1SyRVNyUF16OiVxIoU4+iAkkPTxUuhQIv8udTqm8YcL?=
 =?us-ascii?Q?kmu8UoY8HGsZG/zbh/3qIufFJ1xx4A2/Y11J1BVanN4DAqjAfrTjf9eKJtxx?=
 =?us-ascii?Q?aKzg+QbzF+PrKW08aF/ZfM9I96Aiw9OjFMVZA1VB+0hthXsncO2zKqWsky7c?=
 =?us-ascii?Q?qR9urskMMdAmjdjvmBHsHQy4VuVayFR20tdzDJwqqAAHdpwbZmv5HNuQNdRk?=
 =?us-ascii?Q?nleulYO3dqLnHtFLl4ZNpVQ3ORbjIWT6qWNSO0FA7VEWgU8mg7tUsMEE/aP2?=
 =?us-ascii?Q?7pizYM3icIOSszEfNH6sv2tAOmXhS1RZpDqjKPYqUT56SscEa2BsFr1Ti+2H?=
 =?us-ascii?Q?B+C3dN7t8MEnL6phTY36ksbkj4fMuKSfWRonCIKtNNzF4ied8kcnbXpMNme4?=
 =?us-ascii?Q?TQYGCaaLOe3Q4koR46IP7xnKKSdWafr+OgG8KudwAwri0X9Yq/yoa48GaKny?=
 =?us-ascii?Q?OTMvMNz/Z0GBkY1MHCQqQvDDhADHDlfKeTXMm+AfYgfXpv5UbiopovLE0DDb?=
 =?us-ascii?Q?JK4BdnkLo58j+fa5MTFda7rIPMrPFnDaGT1wRlGsx+a+RnB9vR27q1tFBjoa?=
 =?us-ascii?Q?u1YqcByY53AhIBm1YLUQM5plJvUM24AAk7aKqW75EDbSbcw9L/aZWU8NkAVG?=
 =?us-ascii?Q?JgFhdVgaTfvIgPrusanGDDN9qej5xhOyNvoY9tzcHukCP9FGt00kR3k6mR2V?=
 =?us-ascii?Q?05Psam3XrjOTr3BjWU5tpert9mDARhwHJDxnQXilxjvO0xFOnWGGZuiOZemA?=
 =?us-ascii?Q?8V7VKA5oUTXbTETQRA338gGfHKsHHim0iYlv26QLe2mh394okQG0oedp3jeK?=
 =?us-ascii?Q?T24qw0On6toUqbGqf8Kqo8T7L2Hj7FJe82SJFYr2xUMy0KZUlqBm0mSxiMMp?=
 =?us-ascii?Q?epdPJmAxsokIXAraTCIk3BH+NckH4sShf8BEkSf7LgZy3kHu0BFjvcMZjuhz?=
 =?us-ascii?Q?kGAJx+J6IqrAOcV9Rzf6oddIhLBth4jpGk53ieXL3WsEO0vEWdNcb1G3VOjU?=
 =?us-ascii?Q?zexiz43dQFjYMAUv+1x0yxEqkMIbBfXDsatSPVxsH4bQQAo57r+9ox2sltUn?=
 =?us-ascii?Q?7CRW362p776Bx2b3q0Z8nFqKGVj0wpYKUfAz9Yv/OHoMuJQ7jRHxPz/EHFD2?=
 =?us-ascii?Q?/3QW982yRXWifH/DttcRWWaTXZ49vdf6+FBCe2QtcWDkRQti1s3i7YLGzMXz?=
 =?us-ascii?Q?3MFRZBkw4/+kwo4hsJQ/bJrInoSixwyxDKSQIoDx3RlCjP8GVKnAGiedllWZ?=
 =?us-ascii?Q?EhaEg2YtagrIJN7rs5zHwUbvgNrRiumwyE6urufxsFE+gcpYCFemwfUbFZUb?=
 =?us-ascii?Q?XHM6ehwobL7fz9smoG7P5l3/YMGqsYfyd5J6QoNJsj/OganbUC1Uv9zrONNh?=
 =?us-ascii?Q?00NLR0ZlOrUYtFW/iJsQuv+OCgg5Nhj//cH6v2LP88sA3Ubc1NN6clBkYLqf?=
 =?us-ascii?Q?UUnBPkgqtzfV0wShvMA390ONomzDpTZb2NBceK8Mvrr5rCNLzty7L5pjyl3X?=
 =?us-ascii?Q?AawUB8vL8SI8j807qXgJpshWdhO3sK1XhQ8ysDpsXr7E3JJf8WJHjy2RWxI2?=
 =?us-ascii?Q?V99ogoDPYDtuUgb3xyZyxZWachfFHJ7j4RKm4IKLdpyL3XHWCMvjjSqMqxMg?=
 =?us-ascii?Q?vGaHb3cR3U3V6O8MtVGF6juKo3VKD0bjfYp+9gEl+HrYNeq052ljjhFSnv6u?=
 =?us-ascii?Q?7FDkWSZedSYOsP33ZMQQQdrLZXkQ0aU=3D?=
X-Exchange-RoutingPolicyChecked:
	R3nle3hZZP3pzGTOXsEOY0mOD5+GLyw+H3jLQmlgSQT5OwaIXDzWC5UjV7bBR0I02ThO+h9nl4FrmxlBn+U4yyMciLWE+4OK76zL9ABnJDkVScTXPQ7mBpl7lDn8KB/X+nO1NZGnKgqFt1ptFGBwvRG54vOIlnkaf20u37QU8gz23muxsKklw0NvFplGLWm0XvtbzVLvoPqFdP0od7wfRhHy0KU3eS5mc6t/8YQaxB7CTXWkN0GiNPL3d8AGJURvM+mFLDaTXrM0VdjZoCXtpOFJC0yUJske/w2IkmcNk6vFIwoiFw5aFEcexgkluuG5joJQkolZV3kttdNhq6mqHw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	h2g/2Eq5Ox3K3dEctLqyrX1kNanvnPnvWtmd7XvnO2eybAoSolAtS5Rnje25D0yQGqUo9RKET1UEMQIf3cSo6Q/q/oFcLp6MXMMEflq4m5e7d24+ySUpwbqM3mtncXkN4ix3pM+EO0svQVq187R6qpceGPRddolaUVmHUGJBgDlPy1hcoiEehLQUMA27LSRQAorq4387MQGUkcAkBo7mKVVeM41yIo+UalPPRL66OxC9BX2oOGuwsZk+oXmKpe9iGKl38xIssOFzx5YdFB8UKRqCGe1R9vRNCMD719VZTSTuwSCuR0bFH1LpYqcjlDtR3Pf4v1rGUouu7rbXM4uo86c+DdDIDbROcGu7pYiH1ssXYXk6o2BrIKhfC+sml3q+F7rA854D0QadqsFG1ah5SszORh2z5tVgoEtjGrUnF1HLYAQlksOsOkviGwIr3yG1KQ7yXL+Co3VGLm30dF2FYNCUFjoTToQGBSSGJW8teFo3J6YXX/tAaZWC8TWMwxrF7rO2B6VhIAQ/6As041g88HsLy1kAlzc4LLv46YEfw29YJc09+Kz6bnArrdNZR8J8cTxC1ECK435psSj8yQDAbEjgLUezyIn45OWnt/LdJZg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61fc4462-be35-4687-7ebb-08de9cd628af
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF905D77450.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2026 23:07:55.4153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CYJhCneY2c2sF/vH1kaHjCa7BGQHifNbJ3HRHT74NIJd3fZaHGpBCRXn52O0n4T10vdVe+vQ+m8tHDNooa4Ex0xtTCUVwpj22Q+Rl68Hn2w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4205
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-17_02,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604070000 definitions=main-2604170232
X-Authority-Analysis: v=2.4 cv=JKYLdcKb c=1 sm=1 tr=0 ts=69e2bd50 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=ih1sjumYWU1RLgJRaqUA:9 cc=ntf
 awl=host:12292
X-Proofpoint-ORIG-GUID: C82G5Y-7rt_gbi_xzh6Cn3kgj_flpmQC
X-Proofpoint-GUID: C82G5Y-7rt_gbi_xzh6Cn3kgj_flpmQC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE3MDIzMSBTYWx0ZWRfX/XwGZ5msCQve
 EcM79I9LQq+V5aEglDt9z1L8rVNXVkv55LfHPPYGR9ltTKs8zwjWCEQ6QvBk/6cjzdi7CMhTCyh
 82gsBtmnauFYJ4mxYzPKlthusp4t+HxE89cDUgpw2n4vPI3zemqXmt+Emg4Ks7mqfxyFEmltCCS
 03GpbMO42mNonpOzJ+eaCkh24Ni6nUzkXj33y1wmq5rNuk6fdy6mwOq3VS3S41QJXdQEmmMk08k
 25ZbSLyU/A/9Lxwdb2i6tpxM3Hg5FQCTUTrNfr5ycE/1XhYbNTjOP8w8r54RrBj4r1LaEyIOH9s
 OkzX5BZkA7hizWSNExiRZIgWRaJ5W0cxIlT3EHCUWDXtvFwbq+lKy0W/My3TBkGQx+Vq3NFZ3fG
 6GvMlXgNCt088jlp8daMhuDTJNVuyG+16rvSssZs+DKGDUPgUHEnmABVCyx/BW4yPNn1o1YVQxU
 PKRN4Sd7g1yQF5OPg2nC6pCyuWoGcNsPoNcLQ/sg=

The Scsi_Host can_queue comment assumes the old pre-mq can_queue use or
it assumed host_tagset is set. This syncs the scsi_host_template and
Scsi_Host comment so they are in sync.

It also redirects the nr_hw_queues comment to can_queue so we only
have to describe how can_queue and nr_hw_queues are related in one
place.

I also dropped the non-interrupt vs interrupt driven comment because it
doesn't seem to apply anymore.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 include/scsi/scsi_host.h | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index f6e12565a81d..7c747b566bc3 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -381,10 +381,13 @@ struct scsi_host_template {
 	const char *proc_name;
 
 	/*
-	 * This determines if we will use a non-interrupt driven
-	 * or an interrupt driven scheme.  It is set to the maximum number
-	 * of simultaneous commands a single hw queue in HBA will accept
-	 * excluding internal commands.
+	 * If host_tagset is set, this is the maximum number of simultaneous
+	 * commands the host will accept excluding internal commands.
+	 *
+	 * If host_tagset is not set, this is the maximum number simultaneous
+	 * commands a single hw queue in the host will accept excluding
+	 * internal commands. In other words, the total queue depth per host
+	 * is nr_hw_queues * can_queue.
 	 */
 	int can_queue;
 
@@ -631,10 +634,7 @@ struct Scsi_Host {
 
 	int this_id;
 
-	/*
-	 * Number of commands this host can handle at the same time.
-	 * This excludes reserved commands as specified by nr_reserved_cmds.
-	 */
+	/* See scsi_host_template's can_queue. */
 	int can_queue;
 	/*
 	 * Number of reserved commands to allocate, if any.
@@ -653,10 +653,7 @@ struct Scsi_Host {
 	/*
 	 * In scsi-mq mode, the number of hardware queues supported by the LLD.
 	 *
-	 * Note: it is assumed that each hardware queue has a queue depth of
-	 * can_queue. In other words, the total queue depth per host
-	 * is nr_hw_queues * can_queue. However, for when host_tagset is set,
-	 * the total queue depth is can_queue.
+	 * See scsi_host_template's can_queue for queueing requirements.
 	 */
 	unsigned nr_hw_queues;
 	unsigned nr_maps;
-- 
2.47.1

