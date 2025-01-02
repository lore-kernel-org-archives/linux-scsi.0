Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D588F3D96A
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jan 2025 20:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735848231; cv=fail; b=jn2z1lG7IRx3WVQyGo+fIoRk7poMOutVv1jUtPX+paU4nTEcUFqiwbuc/T8RykGvyOMI3t1Y2Dfvvrfk/7xOQ1ZG6wqowOm8Y6gmRmAB+47fqLSXnRMg3yA/L/vlZxpBe5fokn4XeRPHsMI6OX95ouxI8dYEpXbYqS4DoonCCes=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735848231; c=relaxed/simple;
	bh=y9mFKD9XxM909aJ6C6Ze32RfHfSuduCkZ3gdwWSPZ/s=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=OVNM3XNSNpKTD8yqZZvJ+Y9QQtwNrYowRrcLpGZJah5T69c75g3fF1dibwMRgrDlcq3VZ7v8I2KiQP0XJIVc6bH07zpUc+taySg2PTbeGExLd7fs3bQ7cLBIVxj2+EQzRnmCH4p1K+Xd5N+Ca5ZVkWb87egiwm5bsKQ26pndAwc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Z3xetSud; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QPOZ2x+f; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z3xetSud";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QPOZ2x+f"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 502JXkBt022099;
	Thu, 2 Jan 2025 20:03:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=MtzxqGd5wrLrFldhZQ
	3ovTL5FVjMmoYzZ5NqJNZeZYQ=; b=Z3xetSud/fTqHu2t9oPmXWx0/JJPCOM/rq
	I15AbTrsbaC7lx97ma/fXb9kHgujM0xISxd+SgWATu3pJkVtz6fu2aMtXuzqOo/J
	kQJsmeIrsh6PCuddPk+dFD3IJHQuvy+wS2Nz14Ac6hxHdhG3TJsdYY+jzyhglBUk
	YgSnbsJyH7GRJl08m4/ZiE19+Np/SfBWkgjZ6wtfdnld3ciV9P7pZdoLYosQ9FN3
	cYSLBKcJfFMdpGduLycVByJhMCUl/yHvOEIAT+/fJ7+W9n4up4vYwQicAobzI54+
	hKRAKedxQQJOc8m8PCirdtaiOcKWNdQHDbx6vNm69OHAUnCioMnA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43t88a74hh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 20:03:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 502IQvWi011864;
	Thu, 2 Jan 2025 20:03:45 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43t7s91mdy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 20:03:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fbUyvuHn3fWASud9pxB9Fji3Vnx0ront6hrnkEQk/H3koZyPTZud5Sg6lWxHcZ4SeEAo+m8s9yxqVcUccV7swCbYarMeSZhqPkJAxcicQNGmSFaXqO+NQSsV/A1kT6ry6v8vf211MZnUkDO+D8lXjBOjWC2lfzx7WCHscJ1VG64Iy+bIeEFA/Hg39msKjLrdqmhenVwl70WLiL7ymCLgjwZeIuZlOIH1FZTo3oaw5GoyG41KY+6wWpmM5mWCkz8lXlFlNBuBKLCg0QYIxoxEUu/4ZtEjCuX0HuyOPJ328FyFL8OxxohzljdTrcKR9MVn+dAvYwRT3IPFxZCbfpHJmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MtzxqGd5wrLrFldhZQ3ovTL5FVjMmoYzZ5NqJNZeZYQ=;
 b=GzSNHaugzESFsSQZg+1nUADLGlD2Whf0MdYuiDazLri99Bt1KSLoWCWS5Al559RVqsBP8pxwhONnLuPysUwwKu/WtqZuN0OXbC75+JLjWI341uXItV8cqO1XeZuerzj3Pyw6DtV2it2C4FElD4Ga2kt9KgxDZpi+OBTsQWI1v71ZVBegklvXtDTQ1+J7aqHyS7b1CKLw/bE8wqqRsB5MxsovCPPSmMLwsblOxIx1hUqK1X2njguOxk7xDfctHboluKp5imv3UK8oS+HtMt4HvoGHNCtugi9LIIvo2N2gaehWWLNV588hAgGKThON0y3f5XxyElx5MCdaFCViHWgLPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MtzxqGd5wrLrFldhZQ3ovTL5FVjMmoYzZ5NqJNZeZYQ=;
 b=QPOZ2x+fGzBkPz0OHeuSWn0Vll914GzzopxVHp3LSRgWBjbqfEDybYXWgpBa2vHVA0E4/TxqxlSOhmqH+onF1jYQl1oLID0hbSxEQIo93wi0CP30lSAwPVlOTDTXGlyKllPep61ilOchpirmZIf61wlmvvp3Yfk2gg79X6PKnHM=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS0PR10MB6975.namprd10.prod.outlook.com (2603:10b6:8:146::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.22; Thu, 2 Jan
 2025 20:03:40 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8314.013; Thu, 2 Jan 2025
 20:03:40 +0000
To: Justin Tee <justintee8345@gmail.com>
Cc: linux-scsi@vger.kernel.org, jsmart2021@gmail.com, justin.tee@broadcom.com
Subject: Re: [PATCH 00/10] Update lpfc to revision 14.4.0.7
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241212233309.71356-1-justintee8345@gmail.com> (Justin Tee's
	message of "Thu, 12 Dec 2024 15:32:59 -0800")
Organization: Oracle Corporation
Message-ID: <yq18qrtf0fl.fsf@ca-mkp.ca.oracle.com>
References: <20241212233309.71356-1-justintee8345@gmail.com>
Date: Thu, 02 Jan 2025 15:03:37 -0500
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0167.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::22) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS0PR10MB6975:EE_
X-MS-Office365-Filtering-Correlation-Id: 09b8b2e9-b66e-43cc-41d4-08dd2b688d21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xfXRQfbiqcrzNL5At/hLxk3cX1celyVyU9yzANkGMYSGoanycJsIdcfCJ9JQ?=
 =?us-ascii?Q?OFkJ5eFDHXCMVZ+dvDZsaMmPKSyVPWxoym8W7Rag/0sx49T6AualjDyZdJBR?=
 =?us-ascii?Q?5Ec+7vhkqooAIxBMMvEK9Tu/TmqZWmCLOPLP3YT3T8YUrYAuo9EUQ0Z/F/bZ?=
 =?us-ascii?Q?qIYHAY+9YjaeHfEXsPAa5J4I9QYHniaSHP8kVGgfPewiMpfBGPl661i/qWb+?=
 =?us-ascii?Q?34ogJQUdCZ96tC2TNeW6SZY26apbyn9IjHoTUjzGCQcUd8uChcwYStRYjkJ/?=
 =?us-ascii?Q?mvhQtCKTWJa04WP2DaZJP1KN/mnE662wkn1KDUTAdcVeZuBLkToBgxSbHCto?=
 =?us-ascii?Q?8xRWIelBx7f/gSEbrl8vQ3Zyrn+rejV84oFCnsnlDgMayhvCGlbnH9dWn5Xd?=
 =?us-ascii?Q?IfdOU5W2QrNOFax32MXO0EmDwEFXrzIOa7F2qk0WrrYliHH/2XtYF2XyOzpl?=
 =?us-ascii?Q?ahWTbWVbIpqJ1CGOXp+tjMn0qSjhfnziwflB3ii8fSDiKSRE0YygX6EOnrzK?=
 =?us-ascii?Q?9sh9LyCzUkO8ndJQFIae4EfKG8SQeeYDgRVZJRXXP1GO04mApV3qg7UTdW9X?=
 =?us-ascii?Q?guhz1u2dIS/SkNh8a6z5nSVFc71H3bMQffR2fPzMKt/33mVQAwfWqI0zHr0o?=
 =?us-ascii?Q?DsxO+lvuj/kw2DLeFJKUU1vD772ou99hHvw4G/h4bIL/ZYYJnbJOF9aDejJa?=
 =?us-ascii?Q?/rUYaihz3ZFB2TrKlKfA23eAZalWvpc+OgZXzneajoHK0dFFKmJp45uJ2SM4?=
 =?us-ascii?Q?7vcF1CYJlRz9aIepaP0zFEAHLi4PRyldYw95jx5nh6YF9pFsfQRgLlUOpsan?=
 =?us-ascii?Q?oruy63jnkUHWknhtG8iHm0iNzvEyGmP4XOqaIIpP3OojjX0QVcyYd0CRGsjJ?=
 =?us-ascii?Q?YUQplogAss3iARc2XDeDeqoJK2rCwy8InTgftcfJ1Fj5s7uTjVKO2bsAfNJR?=
 =?us-ascii?Q?aCbcdkOhcwWs+SVpg8Db79/r3G1PtDCaYF0peKAHm34GQxdVl20466t3Xc+h?=
 =?us-ascii?Q?lJfxvgjQXcTRzoDRcLvWRC/pr36Qch3G89QaPjveO5DSScDGp+kLdJz2GGla?=
 =?us-ascii?Q?UeVzXsK0gGRJY/IWzD1qY5Iwn+IV0CozJ4OAJWDtPcdlld1/YCwi1HguMMET?=
 =?us-ascii?Q?nuH2VQFh5RE8olLSWbnIy+bJWfIxP2yYy3Zbrgz1OFNw8iF6SfkHjl+Rf/Ra?=
 =?us-ascii?Q?U/bIwupq115k2BUfvl+rYqxkegslI9G+Rwn57eF9oT9esTV1WXTQ2aQyIKQi?=
 =?us-ascii?Q?vODt3CyRtlVbtNox3WfUanqUSJWqkxrksA/NRPLWAK4aDs1dpm3/G5Lbq/hy?=
 =?us-ascii?Q?K/hmHwvWgBQXP88XkZNngLnEhulm8AEEsk2gPKMy3OP/JBQSe7JKzWku9cTg?=
 =?us-ascii?Q?wwR/NnYl3LQhPWuK23iITbMcxMGE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?asuWOJnw5FPCcKSSP3gApkMj7pFeA7zhnGfXf4zz1sWNw4V20BvEIiXMHS+J?=
 =?us-ascii?Q?dYv9j5/e0nPA9GWABcv4MlWFWU3npWJfiMCIQX3V80Gq/Rf4Q5n1bmtPl0Ev?=
 =?us-ascii?Q?jwWSFBOssVVUJ7CO81q3Vb2eBJbHgCuOMgvtQur912KtnFOHTEzCC25yoe2C?=
 =?us-ascii?Q?TiNBeISr7TEwJP5fopsMwk13z1RYNtMojdKGakStnrUmPv6vP92l1yAWDbZ9?=
 =?us-ascii?Q?ImXnX01szc45w+ISoI9jogdjL9+6kUxsdmqzoj+hgIwndSOPk3EZ/swRF12p?=
 =?us-ascii?Q?PFi0vjemS0iN9nq9unE9KPD/JmijRfNCZrAZWyrepJ2wiPDI6lmsPIzPMCYP?=
 =?us-ascii?Q?6mCiaso4kcsNcKu3NyQ2ZINupDKPPa5AnmyKhNlT1auq+s9JKGIfI7nND2ml?=
 =?us-ascii?Q?AMzIyagLq+MdwaMFtwcHuRrndZGJweRLZuO56GpPF5Ih1/gbthtRU+uvrD/q?=
 =?us-ascii?Q?VClprVDTnUG1GwP5u6o9HIa74s9KlQ1qDHI+KTRwCnITJBzQapab58TxcJNs?=
 =?us-ascii?Q?WxFn3Jhdc0YOQfSKFhxdGO8k7ye2BrSFPw6n30I7jhIU/yXFJgzfAIXVQKIn?=
 =?us-ascii?Q?G1tNgyhOx7yzHZ0Z9e7AZBAVi3+iWLvRe6xojWOTJhTJo1b0DiDTawGUNX9B?=
 =?us-ascii?Q?sW5PhdCznBcUqDTz4VeouVVriSDCDxwalgu7jnSMsb8vVPx1FjCE3Rinpm7F?=
 =?us-ascii?Q?A9b7/pftWMoTW3VjnXuB0Z3hg7813c4fOe4EozY51DsnnWpHAgLRsds7YyWx?=
 =?us-ascii?Q?AI+DcNLdD5JhkqHUyZXalkFz+WZp9jdT6GsE6iijRX/Vrx0xuL5zpXupy4uD?=
 =?us-ascii?Q?C8OUYiA/kzGLzNv+4EhM9kTNUcDm9PvKHUwsJMHh5VI1WayCGtxdf1ymQ/YU?=
 =?us-ascii?Q?Px75SDaIyN/p+tPWdhdV5WQGUrpF1gSTyDBZ7mqo2pZibDRTuXDIHuhATIA6?=
 =?us-ascii?Q?LFRAmjo1RWhpibPxcI+R36JMJVoqaLVtDhp+hcftN3fgOynDCrj2536yCDxa?=
 =?us-ascii?Q?oBMALDZLMewJBkw7bK+GND1edocxPTeTEFrEbZrVdc6u5+S9yRHM6q5dKJTN?=
 =?us-ascii?Q?kdQ8S6cIzLDge/EWFU02SEWmgP9FKT745URW/ujQ3qz+D6g47A8JY4rsdO6y?=
 =?us-ascii?Q?CN5WnMCJ6fjZViHwlv/OgQqvobGXqvCh6HD7QcOy7mktZjyhh5BLgp4yfnYW?=
 =?us-ascii?Q?nNvLbaLnna2DEVkHAKEMENp//qGwR7fftcUswEA7QFTzs+xHOBKPFmvDNC/o?=
 =?us-ascii?Q?4c4jAYv3X0B578VenxzP7qdngzuJ2DfKIpJv384eedEoLM62Uh4kBij/BPna?=
 =?us-ascii?Q?pCrx/CKqtFuTKUSOfJbEgO4OGmY/PXj33sTxiDbK+rSlMwtkMEIzzDTiPLBG?=
 =?us-ascii?Q?87BmbleQcKP7dMwC2G7HmkrkOf8refRg4mDXQXI+93P7r9Outvg/3ZMKNQ76?=
 =?us-ascii?Q?Qm0Xfy6brrPsdM+lidAst3WptYsYu4rS1nd/pecWib3LO4SXSbaHcQRktOgc?=
 =?us-ascii?Q?oMZzd67rzYgM5A3pgEEyjsEG/+/wti8q+6DEAgpYFxvxeFM8humeYLHc2GvW?=
 =?us-ascii?Q?muqsn2SMMrXhDBrsoL4X632Gjk++I6FNibcaRI1ynKMd88D3tbUW9IhSL83E?=
 =?us-ascii?Q?Fw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JK5JJ/uJ36APnKMHWrbgegRhrqYXKAbT3NImlQscLeif4ppiYNHakm0O0PRLu9n/Xx3hWQfZZQ5hc/uItQ3QUOmDMNX36hYkLkcXqLYshq8v9dAu6Sz9LQ43t5c6gj1FOQjEri+0XJjiSj/Zpm3Sm/nCI79TJo8dx79sRmCQpC8DxsgLhjgfu0Ixu/maoxaePDogCFXgXgV/HHvP0BYxy8XlmfoM/i0vADf63eVTZaDICYLF9NIPb/WlTvNBH2Q8GM3GgIwmeUmLmU89C9NP4sf2Hz3HvWa53A4XcOIXobMq+rXb9jPU6HoX1Weq7q//I9UfB/CiNEqyRgnUSbTX1e9XmvIDHg25WTALMmMTI+N9lgzUVPsUhu2/Qs4ojC38wrJD21fhi4jYeE3i2TXkjqyAv0BnwTacxqwEPxcuTJak4NCHsmlb48L+hL/8PM+CfUBAzVq8lHHfD7IP7UhgPazbGSzHshqZHPJrKgWoirbIIrVEvySiTMdnls73rzu2/WZP4UddskIUyOUwXclN5+UcvBhfM+eErTWXAlyWqXDuirnmq9q2zYI6zkf7LfaYp1axAgHRYp9xo3o7SdNBMs4/Ka6wuoQITH9Yju8v9aI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09b8b2e9-b66e-43cc-41d4-08dd2b688d21
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 20:03:40.1997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SOvYsVnD8gWs2bRF6j6Xh0y89Ru4jYdyNl9vFDLq4W5VuQsPDq56PKw42iZqYSaCVSb9b7az0gStaUabr6OvmHjmLaEeeTxuKNMxZpQWdIg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6975
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 mlxlogscore=620 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501020175
X-Proofpoint-GUID: 7_bkIFgVLAKEfmcFfPPU_86hgn_zRwqa
X-Proofpoint-ORIG-GUID: 7_bkIFgVLAKEfmcFfPPU_86hgn_zRwqa


Justin,

> Update lpfc to revision 14.4.0.7

Applied to 6.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
