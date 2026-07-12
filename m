Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CD31A239A
	for <linux-scsi@vger.kernel.org>; Sun, 12 Jul 2026 18:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783879562; cv=fail; b=KNeSCaA+XcUqKi8xIBbmK/ndNaYUQr0lIw2GiSe6pyND+dZ11Mr+iOBLWi/B9SFY/1ovC1Mb4cpre9wld4TG+X8tet3t6rAbPlWgimqnHOFS0eLe72dBF7yrjPcLAr86PeeVL7xrlR/vmguFty1ICAqatDFc4/VNrsZGuijDuIk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783879562; c=relaxed/simple;
	bh=xs7BoIqHALb4jy1jI500SVQ+JLXQ09qNtOBoJnwOGj8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=LzrA3azOGEpi1BIDEG52GI/r2vU9Nihj6bvzBLcwb2EGS+66IbVoovOiJZuGARt1SshIqZJCwh/Dy3tzPMiW0WQJ/5y9Duk1h4+3EpthNNMHATCLPJv+20GY1S8nYmV5UVeYRHQnOeibqpYXK27Y76w8p6p25YdI2ui/J91LDA4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=K74D5kBr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LKtPiPQk; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K74D5kBr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LKtPiPQk"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66CGVGUQ3607513;
	Sun, 12 Jul 2026 18:05:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=NR7yPIXSTFqR4AYiwf
	DHPBDKreHQ2/Y1iUEQbjJBFzc=; b=K74D5kBrSnA1v8RljcXZJL+XBI8OOqOPbt
	rogN5i6SRUv1+JivNsOy5U3JLwq388dvBI7ayjfpAW9iNsyIemcoowV1V//DMnrN
	5yWYevh5qlgF3rR56a47Cyeah9Vj6MsjKcbGdzMRDhJTU85m5c66bI6r/PvMas9S
	FvKmlFbSXhnVOUfmkPdEN9++M/I/ukclkXyYNF6IF8upmT942dpBrr674fX1180m
	1SJHSyfOP2lbdaE/iqU0N6bZxBOI3jHTXJvuxsHf1Ts9HlAwIWsvxy1e+YKNbTdT
	5dT5HgOLwvXj5DZ32USYNMHQobev2Ipbd4c5T3dps+uUmjFzj8nA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbeh6159d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jul 2026 18:05:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66CI36ED027493;
	Sun, 12 Jul 2026 18:05:53 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012068.outbound.protection.outlook.com [52.101.53.68])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9bwskj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jul 2026 18:05:53 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UqjocOgyEA9JRKcF8PCunvnntw15QVUNTWJp4pMt3gRkScfh75ijc9Eg6oXRrW7oRsWi70b7QNePZV+sbiNXRuOH7OxH5XD47jvLTtVmohvrmzybvOcWpUEY7PxMI6e6dGBuWZpHIanq7mSvRfsoTXJ3Raqp5aN9+fFqTSbKSSv5H1CQ1F6DtxSLOX8jSS3aNDpKo/o7mpe/975fM/Tyn4iqwBQnMrt1Dv/Yx4MPyQYq73P2tiEVP1YP4ADybkI8wjGDWludWDiI9LUX4lG2nFKWiSxAwJS2mODgj9n4R03E7LAT7VQdVErrIzX2rxu64Uyj6mOpcOFOepafTzXRpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NR7yPIXSTFqR4AYiwfDHPBDKreHQ2/Y1iUEQbjJBFzc=;
 b=ogHTlF/SKs1Dz1BF3vUKWneOC7c2yhX7Uir8/gJjyleAkjOJDa4mVEsnzcVF4eq7nYnrKa64yjS6y4nUOeLRqaTXFhVTLeCHxzf2a1opcDQKG9uBC76v3Y8jcuTOlKD1qmQeFk4w8t13yL1AaExK1licVc+50/6wZ03NDpoAlUkJ0fjY8oAdUgm2hkflDX4Y+91HQ47oscNNSWb13zxUy7WfN6daNNPNdTYybZ3ECCsi0T3AJZIgIc6toqwaxls4EbPV2oAnqKPhJsCrWEER4N/uCbwtkto6UwjQ7aM+gFxyna8oK2LdkZCtHmiCGHULvs2HaaRe7JBHXH52dLm9bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NR7yPIXSTFqR4AYiwfDHPBDKreHQ2/Y1iUEQbjJBFzc=;
 b=LKtPiPQkL74ojxmNY8i72nDw6VmIFcUunFL3bcIKiU5gJmBholuyqokSttD8tCYgvq/6BTUCtukSWaO4gW8Cl9i7ah0vb2PssQU9hYH+51+4yriSzPvvXnH6yvfxlguU3agu29RuXDy2Kqcu5u5P4rwTFK66io/xdOtXeVDYtwk=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN4PR10MB5624.namprd10.prod.outlook.com (2603:10b6:806:20b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.23; Sun, 12 Jul
 2026 18:05:48 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0181.014; Sun, 12 Jul 2026
 18:05:48 +0000
To: Ewan Milne <emilne@redhat.com>
Cc: Justin Tee <justintee8345@gmail.com>, linux-scsi@vger.kernel.org,
        jsmart833426@gmail.com, justin.tee@broadcom.com
Subject: Re: [PATCH v2 00/14] Update lpfc to revision 15.0.0.1
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <CAGtn9rk+PKVqjBc0Kcy7Y+QO+B9nzhAd5DKNHB-c_ncKmm2Uhw@mail.gmail.com>
	(Ewan Milne's message of "Sat, 11 Jul 2026 21:24:22 -0400")
Message-ID: <yq133xof5hp.fsf@ca-mkp.ca.oracle.com>
References: <20260605182336.134919-1-justintee8345@gmail.com>
	<CAGtn9rk+PKVqjBc0Kcy7Y+QO+B9nzhAd5DKNHB-c_ncKmm2Uhw@mail.gmail.com>
Date: Sun, 12 Jul 2026 14:05:46 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0131.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:5::34) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN4PR10MB5624:EE_
X-MS-Office365-Filtering-Correlation-Id: 053ec715-e100-4659-1223-08dee040338b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|18002099003|22082099003|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	4PiATp4jpDp6hgfNm9aCAx/w9faSFb13EPm/OUkekWzrNU5TDqn2oslecRIEfEPB5GRJz4PksfB97rrm/OqQrW/62L4pbJ3aOCk/XXoY9iKSM4Uv0vVctUZk/WMssG9tdULm3OrWMI6jtEy35JBtKJMfdTyqGwPdQ7QUHCqkwmAVCVHGMVcwOOUt+jWzt7sPXC/680soy3r4rRMnHMdvvezaplekx8mIUvhkm84gpwB9rtPntAQDpeKV73pvO4zJ1HnQlSsszVtEKF0pEnqDWgN2Rpp3LptdRPT6F5TNsm88fsAtE6Uyv4siXSXZBc8gccX/j1D9nCoIkV1LV3oFgtNzi92erF3SnEMhMRjk2qfAVf8kuvxUnpBUcbfnkKiv5fNOW8LZ8iNVLVgzAaETV76j1f++WbzEqc0uZRGlpXcx+S5AGd3nP34ybklMlZ20m4aZtQasjykWSgWbEKGis/mRGNq1myzkUSiBib0nhqR1Fs84VmgZdNsE/bmFdz/WSi3DRJEZ/DgSOVpwOq6SkK27PdyV8OeCB3N9fgfYHW2a9jIk8MVB6KcqKTnJWd9GyzyyhD/ZKpO2UVBEu/mtDfgILGwE7iCDb5euYE3kobRkOYU1JJrOXMWDud5/0dBt5xbZKgu+xd3fuQtnfvQdl22LroQb8stMK0jfJT8E4ec=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(18002099003)(22082099003)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xTYRqi9HnwRhpT7yZG0DySny4/myyVX9gCSMr2Is6B4vlFRXGB3mD+qQ4cph?=
 =?us-ascii?Q?maGUU8CaeR6aHszwdePHfxyOlwOX2HiD/olsSyGQhUzAx72fWvBnUjwNbKMe?=
 =?us-ascii?Q?TBN/SvFLlp7zEZ9BBPfSDiSaf6XCw+ThURscW7wkl9s8z5Rn7ROLnhh9jR1F?=
 =?us-ascii?Q?pB3KRk154KD4O+T4P5oKjXldNt5c+Tv2X74CBah8GT41ZJdnns0cx9muv446?=
 =?us-ascii?Q?bCaruVHlulYm9Zcge42dJewYaBv0OBHyNTGS0SnLne6blR+0KhTgOXUWh+SA?=
 =?us-ascii?Q?M5wIbEj0HnZlPKOR+TGNk4TNA7M+reYQ6ke+XLIIziyeDsv7F1H5BmZ/XYln?=
 =?us-ascii?Q?qfUB8RZFdwcgrR2x4xEuHMm21Y8q9Ieb+sIdUsmhYSu2cLqy/P05kl80p3d9?=
 =?us-ascii?Q?vYWIrcmbf1bRew4zgM+an94aexHV3L/88lmkfiLRJpvlkShxYdzjsmwjRt0T?=
 =?us-ascii?Q?eeAZNAZQJMRkv7Z1pGhYmGmlVtJ5f3q+jR+uz05twUPB816MypURqA44ldLe?=
 =?us-ascii?Q?Ya3eVn7Np5pRfBjeVGRZqgR2+Z/VX51dtIkPa5IxZn/xpNIuoucw/th79kKA?=
 =?us-ascii?Q?kCaE6t59JVK/qBfEOfQcu+bxqtvrQpgnmwnEaQ5Pt+e9ryvWhDONRQNJBqRi?=
 =?us-ascii?Q?m2VLENJRadac5qNIds42XjyRDA1NVTfcXqi/OpsWo5inWqACYusVot2r/e7N?=
 =?us-ascii?Q?eZcarK1TUHfqIg4LarIeQjwpd0QUheB+KP2jZGpQdjgORgCP7fblewqRpLX1?=
 =?us-ascii?Q?8abbg4NVIBb1pvJx42DzT3nWCmdHVmbXBocBHLlicotX2GrvOOLHWK+YOgq0?=
 =?us-ascii?Q?ptcIradjKY2iK64q3a6Yo5O2cQR6nHeyM/6iQv1wRXJiKYf1Cntd3pD6CoAs?=
 =?us-ascii?Q?S1rsLv3LY0HpVw22tLcyr+tuPpzgFO8EhxB9NVkhr+AMLB3sZ3MMcfznG26t?=
 =?us-ascii?Q?P9yP05O7oDD03VQXWy+rSH2c55xUxiLpCi/WUz5zg0/98r26hJu3U7ZwqsaG?=
 =?us-ascii?Q?eIEGHJD3/NsPPmYZyUYLOwYQzohaVEZbOXXtvB8+cx/yUISGYyBkry8NgZhv?=
 =?us-ascii?Q?KMmNd7h+hRnawcNJixANseFODBuBnV92QpeRzzfL/8yNf97cdurBJr2HtLmb?=
 =?us-ascii?Q?e3CJETvnqBVbaOupUUdF0Ugzo12/PTXoZekT7ZApDwtm+SDqpx6ukShjFced?=
 =?us-ascii?Q?kvLw7gAYAS9+A8bAz+SEBrHdQ4WUDXvmdmAgbe6hzEXdeg4Fwp4nCJrPyn4Z?=
 =?us-ascii?Q?K9d94cI5HkT0WudHsiLP2F8jrR69RlDUzGQRVK18ZHGiZ+S8FwCg/85hF7GD?=
 =?us-ascii?Q?ibwauKY+fcEmoZMF29bpldclVSvanPyDt2Q9cdYWCcr59PZkcma0zvkrl7bE?=
 =?us-ascii?Q?9H7mpXkiV7M6Fm5Op0nmbyFeZGp7PZLcVcRjifZDbYx2qAXUv43K17n5691c?=
 =?us-ascii?Q?xT+4YqW2sHKHglEvnfaw2HWONf0372za7frmttx/hZD1UEs292jjt6NEBXzh?=
 =?us-ascii?Q?BZMWqZbwiQlCrNlxjMolR1wS3a0swt5qH0SOXFEj3OMiKXvNwIDM7J+1jWiH?=
 =?us-ascii?Q?mEyXqKsVusaQ+os2SyVdVDJUQMvYAD08NO49Daa5+VD1X4DnnMIR+iVsSIAy?=
 =?us-ascii?Q?OLXD//1W9iKNRKRw+sYiY6QsqqYEhUyc5tJnlS4fLEYgPH9+XBg/DtktpqQy?=
 =?us-ascii?Q?RWenNKdK6ktH6QTVwzBcFLPe8CqHu24Q1SFrCV1dbihsSi7LvLtoknRg5Q7/?=
 =?us-ascii?Q?c5g2pE+IRjHWlqObwhF0TgS/hcC66G4=3D?=
X-Exchange-RoutingPolicyChecked:
	gONoTUylJYPiGMJ6JWUkDE8Gc4/GzPF6tI3CtdXj6avS4BB7KvPxMm90Ntks2Z9woraX9xjAdz6KC9B2zwHdeh7tW2jrMmsyR6u4PFQbjVFQzA7R7MSsfrpX6Bvxus63v2CnVRtbEtu0kqN+9/VdmUkL8Ao719SQ7orrUHLqOGFcoKSCrpxIU6M+MEjDgrrKzlwa+x9I4QaZlxsCPapej4r5AnqbHCxoCk53JkDXpm8UPvDU7oq+16UfwUIjXWLEJtvVzIfSNUMAYZBAVwW9CdkzLiWCzzecWULVq+++XE3tcQnOh+EDDIukBKuO6w27y9AgQTyrwrBo7pKYBY964w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EEpVdrZxDnT4dShTUC1i37UCSuRXj//7B7+E02qiSD7CxcB22gr+arjAtZNkUsMzajVrth19y1V7736l7FYrridsgQ6cmPhIXoLR4q2KhjSgplZXSzXBc6tOvmfRZgYHzfO5V9Xmx7Q9ouzGMcRCDCP40jxhJtoafMrssGRUyB4eABXe23dVbfHNr0QH72fBLKgg/bJVJ8aqYlTJH1jJtTlQb+3BuhoSPslCuJRxgyCA2wcl2BU4Y8lUoUJDaHcLqUDsdcgKlsu6ngwtDrMTkRCkJbhuN18ebOy6k82a0jzvagwZcOSqZ2t5A1XtvwKXNM7jXmdO2BOc7oy7AclDqpAvT9as+JVMdWyR0hMN9AXqYkzpE6bHrAf+s6hqnmM7/OvPXuUQHyFXPiPFvznYBOgU1xt7+wxkyXa9wFdNzjl4nI4Cb/sOQJU+Qv1urUl0qIChbLLJLg+QDb39l2V9i/ElwMjKU2F9QKXUo7qU0jCjHivVWbKZZmuCGVBD+zBs7v+oQA3szTEzUgIgR+f9GUBfIEyIMjBiYosY77EAb181zi0TaPAgyO02F6Ek/cX4vbxqmHswEkdtNWGTu6E+SAtyPRYpfpp285PapzpHrwE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 053ec715-e100-4659-1223-08dee040338b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2026 18:05:48.1437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nd2TfS639u/OB1TRzvcesESeswf0fAIutdg//UmabKdDo3sPpxGNjc0bgfK++kCwSPe2zRQ3FVFfRpd4dgvBwr0p97tpyNbCE7loaN6TNVQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5624
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-12_06,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxlogscore=594 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607120194
X-Proofpoint-GUID: wJ0nTICz8VG-5VNHaJiOVrRukBVZNhVS
X-Proofpoint-ORIG-GUID: wJ0nTICz8VG-5VNHaJiOVrRukBVZNhVS
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEyMDE5MyBTYWx0ZWRfXxG2LpNSjld0N
 fKug9doVSQ1Ui8qEj/nKp8QzUk1rTiGARXO4pPBDvc+hiID/DGeaMKOp0oIJVImYciY1+0whe/U
 d1ShzZhOaCgDPFANPPvXYJi7Ft4QMxZXISJiasUtJWMd1hWXkh8q
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEyMDE5MyBTYWx0ZWRfX6M1tc1gaEU4Z
 i7T/u0Ob6O6I9aRpDKi3xjhuqGV96RZafNL2Obs2nWHR9X9xBqHkt7bVDJVKo0HyvFqMs4n3m4h
 b5vfVz+nbb1yskZCx+Vac2OVvBAhgCWvhgmIxLKEVwegqMhUTz7PqIcymN6DtAnX6SKhDgnDcfC
 NpXR83ZSwtFg6ENdFUEci9QKr+9X7khLmS23aIHDUXYTZ8X7MIZ0GzMRvSRrs+ZS7BYRYpowIPR
 Fg0YDEOwqhbkY/BZaGOYygXUnFyPge3k5Zt8ZFem/O+wN85JHDDnEL64PJLAruH93QMqhtXKyY7
 Aee3HBFLxL0UszMb/swEYvwn8TTcUtOfKge7yKzwx1e08HurGC760MShLTgKnLjkqzwnPnBE6ar
 nc1+mEJZmLDWJ5SIdZQaqVLG19a1SQs+zhcAUlWsc/lQ/pAgpHVCJrRYUToP62jgTMnFIGiJG22
 rrxQ0CWXNQGhZN0tF7w==
X-Authority-Analysis: v=2.4 cv=c+Obhx9l c=1 sm=1 tr=0 ts=6a53d785 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=t1X9yRwuZgu5i4792f8A:9 a=DVKqRkKJf1IA:10


Ewan,

>> Update lpfc to revision 15.0.0.1

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
