Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38BBB1BC2F
	for <linux-scsi@vger.kernel.org>; Fri,  9 Aug 2024 22:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723241604; cv=fail; b=hX4cVfKz0beIIK0zQYKtxEyYbbVbAd58NzbE8dCHyEqshDFk+PoH9dBrBxAsmriowPLq0MYwENqzqGzViOOvFV6P2q7pX53PAwFx7nP3E9l75bEtJ7oMh9C1qGXNPtaHu61329/o93cpKO5YyNZJ24zTpBNHyigN1A791qwxo7E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723241604; c=relaxed/simple;
	bh=u2XrkiMn/TCQutRKfyWzcIzeoLDyS5qUOQ5BSiyR+Sk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=QA9qEwXRYaB1f5Jv70si5VG3jQkQrFajFeNlNojb01fwj9CCooMeUEk5tRsOTqdFHIhqfzfOGjj/MOOyynNxg7i2K7jnQNz/l+XefaSjvwMqeKeNIu/JYk25Oqv2Yhc5p4lklSc7glO8pALXI91rw2z0uPVnHN19OyokjK8pp0w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ANWd2jlY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WgcpETYu; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ANWd2jlY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WgcpETYu"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 479LL0v2014633;
	Fri, 9 Aug 2024 22:13:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=b2sPgbINyNjbhj
	7tmjbijiyGSv1Hh7vYMfCjO3P3iRA=; b=ANWd2jlYop516Yuy6kNlfZHaV26ts6
	Dfcu8F/0UIWsAfNCQELXZz2VExil9D1y7FlJHpfaaMk+pTPUJaxCw8SHDRva3yxr
	f/z6MvWF7oMp7qNqCqG2sL4tGFpCI/vthmlWF3odJf6/jPajO65E4+pjrUKG0Dbn
	qY6yD0o4RPyWaEVcVKFFDtqrFjAZyUa4YwpqPnMn9n85k1vwLXrRXjvxMej+8k4v
	qUC/aMoNzZWqHP+myWx6oPCKJYv/eq4EYtL62tPUMXjw6K2klr/VIxnCayk7q0J0
	zACcJoWCz4+ax+omPerzMZKYpFooU+HlFtzEpBLWOe9sS2zav3N3dWXA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40sayecqyw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 09 Aug 2024 22:13:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 479KXx88023959;
	Fri, 9 Aug 2024 22:13:15 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2049.outbound.protection.outlook.com [104.47.74.49])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40sb0k6bd2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 09 Aug 2024 22:13:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MBdzcewkaVpQOmAeJC9CtppbI9uoi+XN5Ig/MeznBAGivnV2/hzSRAznS3/2feixUHRNU4e9zgIXpaaWxZCHZczY4pJqMXG++dfQRVX/rUTT1z6IF9+scXz+4UfbqkI0l+MmEt+QiiNVHHtDk6Z1KfNc0/lqiWVehsxC5PkOj1AxqI+pBdwB8elEhoZsCSLMTGKRDzJ9JYWrQkwTxoppxZdx8UbDlipI+1fdQQnzhHZnzMINTuwkYebIRMB29h2FV7sJo/ScBV5MEIssF1Qj+xIp+W8QPCd1Y77VbClGE7yF0r6z3MSeJK4QWCrKsSSqH2Gu3cFoK1WglSsU20By/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b2sPgbINyNjbhj7tmjbijiyGSv1Hh7vYMfCjO3P3iRA=;
 b=c2WQ4EtWO2iKf51t9SX30bIpqfdxcXwM3ObUS/yWE9uvWBVzTTGu8ydxiX6deHKFCYazr73dtYdPSjaEV2O7f5ITs9iXlWUvjoR1diE2ywp2hscGmNma3z7CK2P7OuKExeWnEpg6Ceuwyhm34R8YidyO/lXo9BacC1MKp0KuqZewRtJAYWArpDJVNUT/J6JhBVQuQIwOrQMH7CFMn89LhP1TwN3yP2NXNbRyWDJwglBelatAd9HQIqh5TZFJ8XACrpUnAC5goeLJV/i+YmvDXeJfEHde37aFC1JuwebpRvMR3AaQowDTlkIhqHopiX1VWlcbvqipiXdyrtsz+985AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b2sPgbINyNjbhj7tmjbijiyGSv1Hh7vYMfCjO3P3iRA=;
 b=WgcpETYux2P6mS0LRJHYNDrPF6sb2zsSja4qiTLGJn5bY/IohDZWvX4BWs+SWbg/urpl0hfKsijuBUPgli1h5c5pu4eSl78Q8/gzo5Y/NUy696iV+dsm+5EKQ/iTobp2fP/S1cJTvRvdRFWM1d8kaqqleWLdrNfAidbKbh8+a6E=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH8PR10MB6313.namprd10.prod.outlook.com (2603:10b6:510:1cc::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.9; Fri, 9 Aug
 2024 22:13:13 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7828.024; Fri, 9 Aug 2024
 22:13:13 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/2] Fix system resume for SCSI devices
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240809193115.1222737-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Fri, 9 Aug 2024 12:31:12 -0700")
Organization: Oracle Corporation
Message-ID: <yq17ccp1i4b.fsf@ca-mkp.ca.oracle.com>
References: <20240809193115.1222737-1-bvanassche@acm.org>
Date: Fri, 09 Aug 2024 18:13:11 -0400
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0009.namprd04.prod.outlook.com
 (2603:10b6:a03:217::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH8PR10MB6313:EE_
X-MS-Office365-Filtering-Correlation-Id: ea90cf9c-be0f-4278-68fd-08dcb8c075ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9S4q7xOZMf9RWm4sruqDIW+ciGG6TZKPxzEGNYZI2DkPWs9WnmR5BKchqHA6?=
 =?us-ascii?Q?niicFSeylp8GvEN6++JelB98KRhqlEVutgqGCsaI0sVrDT5JDjJLBC4k91kx?=
 =?us-ascii?Q?2DzE+v5IMYe9GFEN8J85HT6gB0GXJXPsrln7wH9K+LJULhqiPcHjgeYHSkmz?=
 =?us-ascii?Q?ATMT3T7+A/hJMCXouFj7TOVHfB6YqBWQJ7omz/rIhHQc+GwyHoWL2prhR+HX?=
 =?us-ascii?Q?dtMB+w1tsj1ZTtAMC6HG6a8wZVeh7CMC80SrA5XYx5/kafAEn7HBmayfCmMp?=
 =?us-ascii?Q?eNgIq6t7NgTkLpHJz9Fu83vVsYXfcVzylGPg0Tux4Z4+FJcE7SzlYPeRRTKd?=
 =?us-ascii?Q?Poq5Mvf036FfZxD2XhAYapF28LanBNHFq3oarlzeCoS7olO9AGQ6gypyjUgI?=
 =?us-ascii?Q?uUnt1aIBdz3rtAPnRUG0k3yAjoOICgCpDpONUEzRUKdoOwdCagcK/YlRNemH?=
 =?us-ascii?Q?UtyXkrFNrN5rdrvp3duzUwSagsnylcKSXScFVWh9X9XRo7CA+1WOaH9NXe0U?=
 =?us-ascii?Q?BilzrYoWI+oWsoBfS4mwwGTRfX6adrYXJuMkR+B4fSPMspR545wZWhSKFoBm?=
 =?us-ascii?Q?uDcIXLMR9Q76rifJUhxoU7dyDj3Sdeumr8P5qJR/r/mGYkVZSpZGigGpfQjp?=
 =?us-ascii?Q?7bWlwjK8NRnBpCi7YLI3C2XRnClsW+KAmy0NLgTTq0UeMkJ1bbRWr4Q9/ETt?=
 =?us-ascii?Q?6+0YlSn0xjZJ+B2Yk2bDfIMBzYFABqxKS6UYMFROlEabK6Gaxx2b038HAiot?=
 =?us-ascii?Q?biKaV/2jVZQVdWA+y/mbx1ah96VbLrtB5qMzpJ7zE6wnjKutKLB9X8gwKxzb?=
 =?us-ascii?Q?UroSM0PT+DlpVHYigildvV6Yuef8D5a+8qik+hpY7cBGGUgU2vXKl5/2xmY9?=
 =?us-ascii?Q?XOuWqET0ADORKzVj8L6zlQWn9VowmZ2hiE7AcMn05e9Zo58tqx+RSgpPe+x8?=
 =?us-ascii?Q?ZB4IootxRe721s6yZxdGYAFeCa7ocBJGf2PfVzBmgdBpF/PBOn5na7hbnJxW?=
 =?us-ascii?Q?gMkBFIQgxu5YocH8u4hQ5x/AZhxnVT5ZoOBeGIAUscpHwZiK6aCKuTSOBc5I?=
 =?us-ascii?Q?h7OH1uSYGvZy6OBWM4GWpIpOPH6Bd/396/60aoU5SCcL2CdMYQtHf+qzZ5kU?=
 =?us-ascii?Q?mZpflqaoEaVZcNIETymF3X2ouCV2fF2Io/WzjRNA5+TMDp5cFWbSVHiX8/ZN?=
 =?us-ascii?Q?+hXfk5h8X372bTlobLf3ya2fOLnk1likZWxaSKWxzt1qPEtYDE87Tryo8RS6?=
 =?us-ascii?Q?k/k5xf4O5a7PvbHuWkp76oVcJcRFL039WSI1jG5diEkE5Rc5UkRLUQAioosk?=
 =?us-ascii?Q?oRYGJRzoPIO2ZP8+SBwOosmfyEKdog/uGTu4Gre5zFV8eA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XfXVkY11YT3MaS5BfvQMLtBP8cKDV6VSTIjHgDOMDakjFZTlFOfk/vrMusa5?=
 =?us-ascii?Q?icARDu5N1qqM4mL5j3lQU4kKCCJ7OQHgeV5c2owMBur+Dqmfxab/qTjxmWHx?=
 =?us-ascii?Q?71O2AYeRQDA5n08mK3GFqlOTzOWz0wSnw6GEHPXMYaYGmt8nCjhnqfrTr2a0?=
 =?us-ascii?Q?xKitd1bFg9kpWvHC30GS9MJwgZYmZnzjI0QafX/HElMtO/vzQrmx9EBAeZtR?=
 =?us-ascii?Q?ZrNBA/JS5RQaK+DaQZDAqyarBOxF8KFVTQ87sx1HoT/vb0x2lGVivOG1NIhN?=
 =?us-ascii?Q?6w7LLG8eK/XuEtE/RpRn+o9d4jiKJ7B6RbabKWx2OFWxDWZ64ue2MW2082l5?=
 =?us-ascii?Q?eaidqVUTaDPlDfQqsX1GxIwHQFszC1cD+E+E791IyXjaxvmPlohjvddIhVTu?=
 =?us-ascii?Q?UjfSkbW3NtjDd9TR0SpmtX+Pfh8uDyocsfO6DJG9yk+CfWKtIdo//cHy1PUW?=
 =?us-ascii?Q?m1SiJUKyXiO1878wTi6YnGj1DGDAjFrtf5KNCUZprWU6bWhVao3ehIBH4YoZ?=
 =?us-ascii?Q?3TD7m+2eCFy4HMl5TVDOt7arTetxZtvdTWX2prXN04t/fUugmbPLi4coa4Uw?=
 =?us-ascii?Q?uSrmMpR9groH3+g+MDP6F3I7gDnyOfkDjYw+Zj4Xzn17l6b7bEtpE9hp9nyX?=
 =?us-ascii?Q?fJWfmpAVprmah3RdDYfnliTHc9WqM1PC6lr9iGbcKf7XjEhtA4vMVlv+yiu8?=
 =?us-ascii?Q?AU2Z4EPnFnoCL7qmn7qi1IchJdfD06hkOU06HS283roIdvBGr3yf76HDC+30?=
 =?us-ascii?Q?w8M8ymcL7xTKFVKlNBqYZpYil034a0CmcPM1yw77NGQYxRp2I8m2VI8lVwCb?=
 =?us-ascii?Q?Bocv332ZSda9UHTFX7EW1l4i4f4YTSWYwuB/5zU50GFKhAit4BH0pomfXUls?=
 =?us-ascii?Q?3g0Zvg8oxLE11k1dgt/eGnVIYMX0uUXx7FiwoaE+zQIq16b3XCCAeNuL9Lsv?=
 =?us-ascii?Q?LEtOGELFMpw8L3UduX2fYEy276rout+oHreYyPpKajpi9A9nhoylWzJHmW3X?=
 =?us-ascii?Q?8hqjfl8+QHN7yG8j7iZJqImrrckZ9SeJ/MKHJM0hUEgyckaGDwbEjSsjn5L7?=
 =?us-ascii?Q?05HDuvUzFuDGyXYIrGxLYXd8f9nPjqNlh4ELbg8wrPInkOEWpf+Ai4slfpri?=
 =?us-ascii?Q?8JL/WnJCFPq5wVNrl9OxMNMqPD7nyWPpiHOqOZU+nogfU37wgA4JLBn9dEhB?=
 =?us-ascii?Q?2cQcydyCKdjG5KFT/+mysHHwoC2Ne+dZbsySO62jOsf9pQweZq3USonDWdkq?=
 =?us-ascii?Q?CBkyflRsVdvu5qvmnxmXHJ9ZpU/eU/vMN68861RSCVIJxruqWVWE+ENEzcDx?=
 =?us-ascii?Q?asmmUrzq1ZuN4JT9cBsDljJFxYlrWmf4ACUO+aChwZ9MLa+eC+dqKxRgdcfa?=
 =?us-ascii?Q?Wx6YW0wTTfgLguFe/DmZxEKtKnaVdvm2ygiGaLWLpvrc/Mp5GKqAdwqFPQu1?=
 =?us-ascii?Q?a6gBjVAE41vaZw/HzAgtDSWeKBdVy+wTOOmh3sgjrguR+3mv0HyDMKaQ6gDZ?=
 =?us-ascii?Q?lVOuwCT3nwZmUJ9GbZ5Bi/f5gbcvXURqowcpEkX7wCx9lDMhBhaAIAGFi9sF?=
 =?us-ascii?Q?Vt5WaGQntVU7L0dd63azLBfA0CvEODN3UmdRGm3/NfPYv6MlNMCOj0baDpIG?=
 =?us-ascii?Q?bQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8+r3VSb6+IJlrZZXuU7W2b7Y7AkTSwi+ahjVmNjqi7xc9iG6BPWLUkObu2gOz6FrKOih/nPpGing2OkzgP15zqsrnHy8OQoxTBmCiDvOCq4C3xJj4OW4neYcHEhEQQIPqeP2Yq6dr2HSBEaJWdP3jO8o8A8yXUHHeZoq2LUH9nO1xyniRVy3uwcPgMYu+ET4TSISWyuks7LYOMf5cOJRKSaz61jeiaMoGjMza4s98WFLPwbRze7NyCP6i/nfaD2UfFtc+0/EP1td8aBYJzEOA3Kk2McRs/KyX4Nnsy4J64oJh/j+yn0L/bDP3vkKxsyiSMWiAY6R8rzCkPrK5EpFZDjX7muop0tXql9y2SsweJ+uiUXpq08W7DwX9lQyR1zvE9ZhpWMUcXB33sh5DjQIKym0+B+M57ms0lAfK51d3x5Sibd6y3gdWwgxjTLvAE42SXvYE5a8mXq8NtIY7vTxy8C9f8/4Yeb4atlZA7gUkJMf72NaiNqJqHRoYp1t//rfWx61vS6ka42XBm3fXXZ7NuzeLjD6pRJcxvUcrlPK6KVKjdoiLjRzoOxluAWwa8cfPOwrB1DEPpSypD3FLOCuMPZnBroFfFflyHW34PPkeO0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea90cf9c-be0f-4278-68fd-08dcb8c075ec
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2024 22:13:13.2983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oeTqIgsJrnBEN5kT39b4XOp4IgSHgia4DppDQT03QKifa8QNElPL7y0oF0BNdsfLZD7j7BXc5x+rELZ7RO2/w+GFRBL3Rel1ZUrZV7h3luk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6313
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-09_18,2024-08-07_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=865 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408090161
X-Proofpoint-ORIG-GUID: 98lXWA6n8ARu4lIvbOIu8aJ9_H3QGbbH
X-Proofpoint-GUID: 98lXWA6n8ARu4lIvbOIu8aJ9_H3QGbbH


Hi Bart!

> This patch series fixes a particular type of system resume failure for
> SCSI devices. Please consider this patch series for the next merge
> window.

I have been working on several tricky regressions where the remedy is
similar in nature to yours. I.e. retrying in some situations. I ended up
using the scsi_failure infrastructure to handle the cases I care about
but now wonder if a more generic approach is warranted. I'll contemplate
a bit and try to reconcile my changes with yours.

-- 
Martin K. Petersen	Oracle Linux Engineering
