Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40642C8DF
	for <linux-scsi@vger.kernel.org>; Sat,  3 Aug 2024 02:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722651146; cv=fail; b=Nx8Rb/d3JRYzEskcxldygfvJF9ZxTbrSBp3KTYVjN9cyt/xsmVBszwd4Th1o+cRBV1s0XxtTgtMUAintF4JJbT7GAZypnBM7dgoiO7fbOXz4uGUICsEHsaEQ/3g1gAAIv5LCxk+plcwHRF0wsMCS8+grObAx2TFKLu/Q0Oaz21o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722651146; c=relaxed/simple;
	bh=fhmvTP/JEpvmlKwsOPAmUwvMkdFu2hnEiQpc9hR4WHc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ez6LaAZuJTHzjmzD6mNwxGBbR7X/cC+y1NG16LdG8vqkIuUR9+wWsOJ/92uKAQ9I8vJPRnBf6jwcvGEsPT7A6Z94GKK0k8A9agYQv9/J100Df5zDS7fQ8nhF58pEXbZxyZsEP8PZZcVVkqAgMY04Z48D/1OwzK20nna3vHwZd5c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QVkfuLCB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XI2KkAPE; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QVkfuLCB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XI2KkAPE"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 472JupZ0003008;
	Sat, 3 Aug 2024 02:12:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=ie/Zqi2pMF38y9
	3SKp9li5ngUVWNqVY08wUAQ9185No=; b=QVkfuLCBXKu2+d7D6drZr21aLj+SUy
	gr6TB39X599vUQuSLnhb2d8324TwoBZvKOdO4se1XWe5s9je4MUDjzfBPFc5x+G3
	1mhg6MrvloQmVxO3OyG8qB9C80fC9OU6a6OSO6UFhN0ZZxwQvZvnK4EZaFTSUQSt
	yqPrGV045P/HBf/3H8dfYTxAp/2qb4yGFiA5lOeEO8Azn2PQTt3vJdWvT13f/BBz
	DtpMzep53kVLfCfVjiHUAC2WnhDz6ImHGFRDSJmK6dlK7pravJw4vwCpvjPDWDY/
	ZN6Vp9Wv/A2elr8nsEotIq4/t2qNKp79rV1Z7/V8a8hiaSWjgSLGLlXw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40rje8jets-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 03 Aug 2024 02:12:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4731Xct5018242;
	Sat, 3 Aug 2024 02:12:11 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40sb05ghgd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 03 Aug 2024 02:12:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oPIZWHUSiby4d/YnhswLIAFwLZqA87jl6ad6bZ0+fyzaPfTSyEBvPvRbMu+O79CephRjJRPmOcZCP1Y1T+cxCs2o/vxhJXxQMSJWMosKM3Dbdei3f/4c52cBN8T2tAFCJsDt7boI2wxCSRSZLrQEV2/csStHR7Hsx1juN5cMv3gpciPmJljDd7WZFO32lMRhFus7plrh01sJsKfxNEKaI7gn8+BdEVbLbJW2yXDUFjL2331Z0IVdEMa5kWpyJNGFKwiyk6ViFy9GGsqwz5sknNpKA0jl9lzxxJ4rfXdB4i/tfU7bs1bkGvAEbyXu2itYK8annmHAmg3tSGoXt9KSgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ie/Zqi2pMF38y93SKp9li5ngUVWNqVY08wUAQ9185No=;
 b=UYM7Wd61WcsXSt/hqC0FrIjVc+JDUxnRpJRzGkY29LSNzlGo5zCVq2efG4Z1OTltW5Kp/JGQFmrJ13uRz8xpRDhZVzrGqX0u8KElhq39KGGV19keMJJ5hh5RcZJrexD4u33Aw10rNiLDI0cJTV3kReDUDMudpLntgm1AGQeEj/r6FHkPQFtlVu21Rn7Q6fUNM4NP8EHxSCFxYcE/wqPIxA0rE6L10yqCveFZphSFa3dNS2xu/DLi3usQRYa0z73vVXqMaL+t7DCfX1J+R0spxB1JNOOaMW482HKAY+Rq90N7TodBzZndhxsqWaDy38Sg37EYtXxzyDyF5SmM2faoFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ie/Zqi2pMF38y93SKp9li5ngUVWNqVY08wUAQ9185No=;
 b=XI2KkAPE48taG8R/gYJp3DaRoshFH+TFNZtz2ITXdJLVutU/JVkjeeJsVrqyiCl11dJmsa9PhE+u/hocTUDANYzYBMYFbQQy6XFvJv97Cr8T4A1Q7GriJlpeZSxGUV3ATHJ420NiUQKsuw2v8Nv3qyv+E0KmBelt8ZusWVBBG+U=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CYXPR10MB7974.namprd10.prod.outlook.com (2603:10b6:930:da::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.23; Sat, 3 Aug
 2024 02:12:08 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7828.024; Sat, 3 Aug 2024
 02:12:07 +0000
To: Don Brace <don.brace@microchip.com>
Cc: <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <kumar.meiyappan@microchip.com>, <jeremy.reeves@microchip.com>,
        <david.strahan@microchip.com>, <hch@infradead.org>,
        James Bottomley
 <James.Bottomley@HansenPartnership.com>,
        Martin Petersen
 <martin.petersen@oracle.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 0/5] smartpqi updates
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240711194704.982400-1-don.brace@microchip.com> (Don Brace's
	message of "Thu, 11 Jul 2024 14:46:59 -0500")
Organization: Oracle Corporation
Message-ID: <yq1le1e5p9i.fsf@ca-mkp.ca.oracle.com>
References: <20240711194704.982400-1-don.brace@microchip.com>
Date: Fri, 02 Aug 2024 22:12:05 -0400
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0024.namprd21.prod.outlook.com
 (2603:10b6:a03:114::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CYXPR10MB7974:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e7ce35b-158a-4bff-ecb9-08dcb361acef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3aX2CsTCDBtpmoYQI6mNHvvTV1H3Ns+p0XF3NS4DiR4BQ7ucTIpkZKbwjkf8?=
 =?us-ascii?Q?5+o2Jz8pjvGpkHUEVUg4Z2wSvNafWsI/Aq1K9PMZOUWLg7RJ7Nw6A+mgkvAx?=
 =?us-ascii?Q?Njq976uuLkKTQKIFbztS4j/xYWEmBGj3zsuuoQ7xmxPlK7ANCzFyL5pjaf5R?=
 =?us-ascii?Q?UPpjkaaVkbHne8bEP6fFY5OKoJVKSEHDIs9LgDRHxKC76l/RHeZNGHp5cfnH?=
 =?us-ascii?Q?KOlo6JcAvRP/fYs/3dugoGXDmbydmUIGW2X/GVGGNV4F204VxoOqMyHwVWM+?=
 =?us-ascii?Q?kLWLAUnJzDO9MLwynvrrIdaTW09aGTOKkf14HnM8OOxCOQCLcgTf6oey0JUG?=
 =?us-ascii?Q?l5UWoGHvLy0fCUQaqq0OrJdsw0g0T/zGOcU+LbTfVoOdkh6Pmcf99Tyi/6xX?=
 =?us-ascii?Q?Ba2OvSMlCsVD2S5ohSk8vF/0kTX4HJYAJB1bSx9Xswdp1vXakGUp5Vcxto/4?=
 =?us-ascii?Q?P5B/6sagiOflTxT9WMNoothTPPZMel72ZtbJfiJ4gwOzV8MxnLQGWtuVK7PT?=
 =?us-ascii?Q?zTNZOIKfdRB5bUyh0UtVqDPDjQLT4cUodbk38iMIACvEQP6sxm7VfuNhsDwu?=
 =?us-ascii?Q?RTDOuYU7E482N42aJ5M1omIkDWyuMmeYtudBtmOwoLOclJxzp5uIE367/ySA?=
 =?us-ascii?Q?oit24D1Ih/WNlxNRknN4YP9tpECTa7Fo1wXQB/Z/jVcdXxa/R/GYVTvtxZMR?=
 =?us-ascii?Q?ugssJJI8sK0FTjQt9oafpvwfufWnvFM/SD8X+hdDLMXoLLA2zoSk4QopVrRL?=
 =?us-ascii?Q?ZLf+U0KVr4SjW51wSiG43L2wHcfGAYsGz+s5dq6XLe71pKnS6VcHIl0BPIF6?=
 =?us-ascii?Q?++XLQswmLTadePa6Mj+ygh4tp31TBAAW0Mzt7FYORJnyKz/+LpjdJ2HzjtJx?=
 =?us-ascii?Q?4M08xKbqBmD3GjA0a9u8YwMnORbeazJB0F3+uOCfsvkgMZWdyZrobpETdeHR?=
 =?us-ascii?Q?NZ/Ro2qMSPVJJbkwqHgYFn6YvCFZoA7M+da+kDGCTomm3L277cDuLPGQBmsv?=
 =?us-ascii?Q?LXZU5v3LPifXnKSu2rrRDuvtM8BOzfQZ+h2kpr+SjQswJR+fyjNyxM+W51Yl?=
 =?us-ascii?Q?NPd70NHIqUQ0dal+fH6Qjw5QQ9xt4Jf0aEkd50RBNthtljW34VgCRo/0o1S4?=
 =?us-ascii?Q?tfKkhY2B1jNH6wWUqaK5uwj5FfeHtUiVCdTVLlbd0vJ63jTsV0B0Yo56JhLA?=
 =?us-ascii?Q?nBc8peRUensWcChtT7T5rtjoOM1uDo5DZodctVhYnMCKxV/S+Q9YVWeofHy6?=
 =?us-ascii?Q?/h0yIKrUWxCljqEcLLgNjrrBR4oWv1I6+N1h++fWFiuBi59v/ZEN1LWD1peI?=
 =?us-ascii?Q?xsw7itk8iORWO++y2yeuCxIwLN1Y8qcLgpCUCwV4dMLKzg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jdbbp3CY8L254bmB+EcOAHn2z2rkLzpJuqU4A6ufp0UyCTe89NI61IbvnbPR?=
 =?us-ascii?Q?NiEnJSMmq6DolADaEKGxfYk1jkTf4m94qa/ryQd1cNPrquTr5nTKaVc36zIY?=
 =?us-ascii?Q?dWnKhwuOgB+StHdwtzLNaE5DLlRHXSVINbt4jxTb64NXHAu+Kon6rGengFxf?=
 =?us-ascii?Q?kkHGSBrHovlQQHIfEbMoVUe4ICjUI6ridBBjkjcHgF4KdTQlTN92P48LJ0Ui?=
 =?us-ascii?Q?QYE8msMp9G8r8x4iOSmvbMTRUU/X1hlExKw2ZLTtguH7qvEbrm+1Lmr6uZhw?=
 =?us-ascii?Q?2FHE3ZtcDfJhaO3/YJ5KtkBV1PCnySZyMCzU5/h0bMQaQEdMfGDMtfuYN6pQ?=
 =?us-ascii?Q?KyHnkM8Lp5myjvkTHForuHd5D4gJScq3Yhfg/evjMA1q5xDCMQvHnYBzKsIO?=
 =?us-ascii?Q?v1Zj5tponSSljgZp8nJoVBY6PJB7PM9BAtebtdPY0UIT4S+VckeBWrB9it+D?=
 =?us-ascii?Q?dt9uHd+xXvvCEXvyqLrupO4rhX+ke6Q+hG0nKMtNnXzUS01LSONI8Y4ge4Pg?=
 =?us-ascii?Q?EfTbte5GMZRjlfECc72l7v4JfQhJgWxbRrloEUEDdeF4gwsgSZQR5OHrzPBy?=
 =?us-ascii?Q?hsH2rRZBSEF7IaZ6ZJqUSSz1z6AlIrpXeqNBequwL57gjJTpwp3FKPOnQ4UP?=
 =?us-ascii?Q?juxx2XK+WPuOc9vkeAtQx45OXBQda3xdrnSHIJRWcJl5XSs/JkqTOWDp3W4i?=
 =?us-ascii?Q?rcdVW03iDC7el01x5MwArcZXr7ftmYgHYFJvvsbXgJhhjJI1yj4MyNx9+kMA?=
 =?us-ascii?Q?HyDrdUpyfr+ZZXF1XspzW90sstwI3FFR+Deosf/7MhIiWEb7wKjThPPuKGCe?=
 =?us-ascii?Q?WZ2OlUBdjgwSKLJJ01JT2etPe5JL087iulIZ4+pUyDrdVo1PuSSp+y3E9ZBr?=
 =?us-ascii?Q?J2p5+5r7iwGZyEKk1vK4VYTY49NBME5yAnjQnITQ7Q2D2n/yEc0DroLXIiZk?=
 =?us-ascii?Q?BmpuZ7wx3CmwMiZsSIBESaflrOq68VGKKgCeouD0V5V0zP1PoPNuLW0BtE4l?=
 =?us-ascii?Q?ZmUnZLstGc05OfEDD9VDK5TpFlDbGebqtEMn/hFduIC7QfCpqdLcJ6FDnpMb?=
 =?us-ascii?Q?lecaWUqwObRMgACSWtbOkD5pmXsky1T+Vdu9RteA/Wwcbrj2afG11wGJIig1?=
 =?us-ascii?Q?eVRizMM5rSwryzH2vHPQuQgQJXN5bhso0HIQbDRSgrvQ3QK48r9KUNv85Ou0?=
 =?us-ascii?Q?9V89LDnWv9VJkjo+ltXKrrQAi9chjEKjZNBVFZMytMQOfCfjlVSUFS/9XxIN?=
 =?us-ascii?Q?+uth/UrXr85gAAtBZE71LyNcWSdSUrSdG7Pwi4LSp9KW40PFik+AbHbrH026?=
 =?us-ascii?Q?rthDCWPytwK3V/jakQku17QMKL3q/YlT3hUCl54JTvb6VCCDczq73oZVM/nm?=
 =?us-ascii?Q?GmAqtzgaNzFXf4FLp4BZ5rnZLcwInYbP+w9u2NBGwktWoYH9ys7ch7NXfpQg?=
 =?us-ascii?Q?KXy0SCqbFblASzMb8+JBkTHnkzYOUFoOoJMJVYJfRg8zntAbWbqHplJ7hakJ?=
 =?us-ascii?Q?40ES7qSbGY+1GI5BeN7eXOpqpNv1gh+O4IqRG1O7MuD0US5WyLWxdOd9a0sl?=
 =?us-ascii?Q?ErxdJBHqCDQbWX0CxUeIzX4iQ2FKxhl2UXY1+reWSXpo4yHSTO942kwfFChJ?=
 =?us-ascii?Q?zg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0Pr7ZxQ4NVfy29qQkTKwKKk0nt4LnLKzc5p01nAF5pyKNI4amL3etf3E9GV74rDwQQleaKlXZc/96u4P7yg+D0j9ARWTXtXiwdhek0ubfM7bOw+RsTir/xIQhpyYTSO/COgJEfR0+eHDaH6XJHL5zDCzVmSOsRXXMXM07Lg3zlwYKdbUrhRtKcOcLUhxhsMGpGpb0TBj/ObpIbV/fkxztJWY//BkNibCfMlS2zYfaq5prWwiThgiGmDvn5OSBymYOnFflZ8nPKgoI1Ls7/WkSGQbLyUpjjALAm+4W4eto2EK0kxamqyV2/TNaEmnvDeZyTLQb4smGI4VRry+khRo6n/XaJWrJH8jZOBwpAnlWE2XP7ueL55zDsZ3755cPbLtiFR6q3r4xViTRalNAeh8wMtOkR2h3MuJ8+Jdh2Y0f+uhZoEpArcI9nWRnUvFdG8ywu5Yt5QkeX+nJVgHGmuCgaWq5jR3XN9THiCNSX/H6vOsAYng/mE5FMZOviLJDv0hmyCp8CJF8TPWANpnXZvpdeJphArj70MTfUbolEpD2w/MjHTPX6VgzUXwsJxMJHv0YsSGan3YG/OPn1d+tIqCPpTfXlFxTjYNQJnyXeCGV24=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e7ce35b-158a-4bff-ecb9-08dcb361acef
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2024 02:12:07.5581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 90PgwPDxRyrpuhv+QI1gEr7r2LGHrp4ulyz96xWW4Umgu3ZFIsxvIg/p9FUxsabNLu4e27/NbiWlOtn5uL65GpyWLqHRDeyeewJJdH9nEJM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR10MB7974
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-02_20,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=683 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408030012
X-Proofpoint-ORIG-GUID: iSyC8xcawM1nbvz8H1FBwSxQ0PAUlhzw
X-Proofpoint-GUID: iSyC8xcawM1nbvz8H1FBwSxQ0PAUlhzw


Don,

> The functional changes of note to smartpqi are for: multipath failover
> and improving the accuracy of our RAID bypass counter.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
