Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FA4D50F
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jul 2024 02:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720664921; cv=fail; b=aNIIyQTC4uQVjoEWqVsYndlyJmovUEEpAk+7eA2Voly92N5z4T60oOEkO8fDSx1H8rk90K2pp4X86eLZZgs4NKKC9NjlulREe+Rnoi5ILB6gUIsd9Xq472o759hO/aHDLHFhC8R3OY7kfjixg9X+KmpADC7/0Y39wjm//CGV8n0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720664921; c=relaxed/simple;
	bh=zSLjS2L4D/Zzcp/SKEAI1eiacDSi9fmH8br338tMgfM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=AX9CxTjGhAlWYaHAFHNBbXFNOItgAmY6Axk1cPBw1oUD8aTH2vvFHnfJs+gsEfzr0+JqiaGG9yoIDGcTM4GX/P61p/x3eSwg5/215aBbX2oI0NArdVd+W3zLQsHyAtUtMFDf8yJbxp/xUbHPjhTsk2vMLsC7fvyLf4PfAgL5GgI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=m5fomslH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KZDYKo2H; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m5fomslH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KZDYKo2H"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46B18lL6012654;
	Thu, 11 Jul 2024 02:28:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=WuwbuvC7XZqhfW
	n/Sgz3QGR6ZAz2ZGdLQisJ0Ci2qW8=; b=m5fomslHEFBQy4xhD0Mx/IzzEPsJsh
	Nf4cmT2XyNcJ121MH+Y9RguMFDTYa8zg+7Hb1uJftPgYIsyqz/xrmWcN0U/qads1
	fRmeUk8RdZeVDyD0L7ETuB5nqfbiyGd3IOp9WA9h4Kz21Cbfdc2GsUGEC6ivdosF
	8dBVFVOpeRWqFWFFsVx9TcUWY5Sbt/489J4fEz3k8n1m83HYkonpeHesNlns0fHa
	W1orR8n1FV3P80htpUaJyauSrbcn+tJIwVR8ZGXdcwGnjbF/ScWaCfWmPlx70wsY
	vjc4JB30nP1cY2aAn9vtGzl6kGQXTPhpoFsD/Q4pTtOOf26rWmPb9sdg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406wkcght1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jul 2024 02:28:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46B11kpm033768;
	Thu, 11 Jul 2024 02:28:30 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 409vv1mmtx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jul 2024 02:28:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YbIclX3njdczg0CZgYKNL5EYFF/ea7NHqqbVqnY0tpNYgvot0x423Me6T4CvTBo7XCXPEzGL4wbpuHn2yHkGrbvMFuturLWIyFeTU4vgq91LOG2niP8QfWuUThrofykDhpENhI9gQh+cghMbHx1ZLuuqfQXRqMag7E31J5snViWQQLL98F/7o2NCaafTUlJ5lk+aQvb9rS/feYebTtq6ubL4s8CWnU/YWm8mgCR0OMP0gpm17plxSkY7r5DFCkVF9XelQzbGxIrwzZWUgAsCElqXuiddXEKXDmFgXttZIznRGejVnWN8+x2yPP1/u3ch4ur14iMr47yCl8WnM5TB7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WuwbuvC7XZqhfWn/Sgz3QGR6ZAz2ZGdLQisJ0Ci2qW8=;
 b=flrtqSZiDuyDFOWIThD4p+L+iAJiUTobnp/F2vjxje/NsZ3rD2eBpFaeGVOe5QbOAJdVAtr2TtVpqNnfGhiml8JlS5ZpQ8YW0TfB5duFpIrE9+ZQ3K4Q5q6fLlYTakPy1EoJPOlO9iI4UpFfI7nP1+WXEbxvHH6QvlLKw45RYTBLqo9EDPx4u5SjtdYQthrWVqKeExRcGQXuwCWz48Kh0CEoeXjY30EbJJq/NitJ5b2Z9n2v3D90MJzBaL7yKZRb3LxIeINHUrQFCp0l0OIHwO34h0MSp/ygP1KXHGvelcFS3S5u31laLADFw9tX2DI6HgJkEyHruTupZ7wWXHk6ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WuwbuvC7XZqhfWn/Sgz3QGR6ZAz2ZGdLQisJ0Ci2qW8=;
 b=KZDYKo2H1qxHsfU/VYcFKiCRUkIXZ0s1Z5qEYWvyQGCK5xif27t+24HBSg4gZMQy/NBZ7CFblrnbag+Uw3wewwvzX+xeP0Putt05lX2bYcGcV22WqgTlIp0BEFZ/1b23/1vyOKzOmYoHNiRpB6IoiF/fG4zCJianyZYe5944Ug8=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA1PR10MB7311.namprd10.prod.outlook.com (2603:10b6:208:3fa::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.35; Thu, 11 Jul
 2024 02:28:28 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7741.033; Thu, 11 Jul 2024
 02:28:28 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, peter.wang@mediatek.com,
        manivannan.sadhasivam@linaro.org
Subject: Re: [PATCH v5 00/10] UFS patches for kernel 6.11
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240708211716.2827751-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Mon, 8 Jul 2024 14:15:55 -0700")
Organization: Oracle Corporation
Message-ID: <yq1msmooe66.fsf@ca-mkp.ca.oracle.com>
References: <20240708211716.2827751-1-bvanassche@acm.org>
Date: Wed, 10 Jul 2024 22:28:26 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0034.namprd05.prod.outlook.com
 (2603:10b6:208:c0::47) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA1PR10MB7311:EE_
X-MS-Office365-Filtering-Correlation-Id: b9391665-653f-4622-8475-08dca1512600
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?TEXKyoz8YwK9ThtIyhUabjMqecOFjjhTjXNryrwvzKWj/+C4sJ+RWwSG2gBU?=
 =?us-ascii?Q?Q76YrSOQXh9Qc5jHQp7Q5FxyIAJ8loZk72t7cKbHDjNG9wcYsktEVR7RYEGf?=
 =?us-ascii?Q?vVn/0OpCG3n5ZLT20EAo7ntkw3Ki7Wk0EJYxbIY4mTYweR031aaUh3uvqsp8?=
 =?us-ascii?Q?HoOHO3NyZiHo+UTnKTyVbBG+7tmZWh/pM+5q9zDnXOVtEH3rN9J8jRXyrefS?=
 =?us-ascii?Q?lRH2SwHrw8PvVSZsWSnbHELPGz5ylUTvavi2B6FvfuHoDj6HQWkeQh1/u65z?=
 =?us-ascii?Q?IGbtBpmXkL5NMiwsRpDwZ4KNNn06gawD27ZdZxMjMReLYodjIsSpcp8U85QW?=
 =?us-ascii?Q?+XIPn/kf/vnYZVav7MKqRqUlnUc324X00hV6PhZEfpjvtBE26Jco5F34+8j8?=
 =?us-ascii?Q?nE5mLx5GC3ScSKymN6DFvt9qhFY0bC6FOFdzWYYQGqlQ3UL8wGBLSRiMP3bA?=
 =?us-ascii?Q?2/g5IrKgG16RbUX7gZP08TH5IAxw6jdR7tv2UWLn9sjk7lySD11FAUme4HiT?=
 =?us-ascii?Q?s5WkTFv5CpwAtDGfLe44mpw1rJDymgBnEw3lMMK31m57bRCYfrzO36vmpRxt?=
 =?us-ascii?Q?VrfstpgVsPyXteUL0tCpGyWSZY1GAXylV1fMmsG0D/rH0yVOJCU72HbJtO3f?=
 =?us-ascii?Q?+rAeVrz2voaV0rGoZ/BadH5oYU054vDYVnxs64ZBiishENxPEB2DZUOEyN3i?=
 =?us-ascii?Q?6VvdJD++tT4VUdVcg4PXf65vy8oqmTGMRQnUfISBvRi+H4mAr5X5Lw7vLTJI?=
 =?us-ascii?Q?8giFJsPgTI7lafaIx3sF/janouJ8h2YAdTksC0eXpZ7yqBuQ9ybnOPbmPcIX?=
 =?us-ascii?Q?dAkYmR4d7yxr5GFMasamb4JxiUGyLAEbt9eagncqRpQ9qahOWa4935vQDixk?=
 =?us-ascii?Q?psQUz+OtJaWqDQb6GWBxJB7KMuq+s1kgeJs8DoahUSIx7UCVf3Fxigi29ZGU?=
 =?us-ascii?Q?ZwVBjzWNIF7ZoJ3dj8Ka9g898B1yA4pdIbnPokfc4i8r6K4+h3pQoExl5BGN?=
 =?us-ascii?Q?jU8DErNhsCx7HIoVcZfLn/IrL8Mrd55pyXdlO7ThRtvg8dkW254opKskiYcI?=
 =?us-ascii?Q?KwzoYUxFNCN+Bj/GpcBQ4ObalQ25/kn3AoRvjKjpExjUOC3fS3UecM++ZSH8?=
 =?us-ascii?Q?zrJRxocP/BjjqIkLMmWYrByk46Cfpf6gwiL8+XhzOfZoS2FkMMOFpXK3+DQB?=
 =?us-ascii?Q?7vsy6X7S8QbHq+38RWX88xB19tiKuZ8kuR0bqVkygyOmCL1vjHqk7Ryi4k3n?=
 =?us-ascii?Q?AgBdYVqcBqwgBa7MLdx5QArq9FZmmbNLgcvx6C7JbOjdT5ecGCMxONs19+Ld?=
 =?us-ascii?Q?9awEhvBcuTAdpfsSrABwAfL/9fYU9EANCHZ/awj3w65bag=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?L5b+yaYGXwDW5bi6lG/i/IrmHGu3HhT+C7wNTUuStMZRs4PCqYbI+WhzeVJJ?=
 =?us-ascii?Q?L24DqZtom9MxahTeMA6GiLGVFnmDqvmzcU1WyA5wskHohjTsOeo+t3PlSYy2?=
 =?us-ascii?Q?87JbMNRbNOeiUAc4B7V6FO6kXZ4ZPiyZAKYvwfumpyBmUeXpjD3fUFKqQl7n?=
 =?us-ascii?Q?jE36sVBnH3gxoy2a8OOt+XF7+3jJAquX6aiBHD9NLp7jmA5USTEaqKyG1Qdd?=
 =?us-ascii?Q?PGolxtJs+BOfiN78ZFdqaczc+N6BpAQFeMzghVJkVPMpZKHHnerDYiMKInB8?=
 =?us-ascii?Q?/cKPswmbx/5q7KYfsSvajaj8bkhWl4pbiV63+eDxBMDFvWdMrbKO8kGD5VMg?=
 =?us-ascii?Q?H9tLcvKFUFiWeUue1QIlnYotM4n3nMSoztiUsXbkxr9pylDs0245eUN8w8Nr?=
 =?us-ascii?Q?uAeBlgOoauMgTtofAzs2sFpmFuo8+i0wU48Aj+MSEcUcNhGET0ONjSxDn0mH?=
 =?us-ascii?Q?xj/mVxadCCsf1wwWEpbnatcI9bAKcQDH6s1HVbZDYDxNR3RKjAfVZmsHzM1H?=
 =?us-ascii?Q?Qy2voU0wKZ7/0KGDPVEqgXIYkQSLerP4UVkQAN70trKem2eO8U2d7YFs9wn6?=
 =?us-ascii?Q?p/qFGeMvo8rAq8K6Rv1YrsIg2psogteRRNaDdEX6f7zlQCG/qddhmCBvTkam?=
 =?us-ascii?Q?GnkOq9UOvqpU9Jt764WdkT3TnI6Hj2YYlvqRCX/kCRi1tOB6WnRWjqHb6mTJ?=
 =?us-ascii?Q?lSgg1YTb3kdupsstsXDYwG2kIvPMXduV1XSS7btj/Istee/ZNXo8ILSrcaU3?=
 =?us-ascii?Q?OHohZMe7B2e3LolaBTX/UXhhsYTQl3ex0x2IlSgqRhGlOv3fkTpVP74OV0LJ?=
 =?us-ascii?Q?E7SBADaPhSw/3i1fL/GZ0Bb4Ne7Tlc4Fx0NU4seMSQJ1uarNHyP0lHQc4PR2?=
 =?us-ascii?Q?2akuLsm51X7gGxWzcLFPwB+R1//VcwlozQftUapRpAcL8a3RZ6ueMer2nYjq?=
 =?us-ascii?Q?r7Xa/C+RXPnWBeNeDoEGOwG5IgpQNJkl5Y1MFba7egToI5bJXF1DhEDRA501?=
 =?us-ascii?Q?GUCsowhOnrlh8c/rAdaVO00YVPftgT2duadfrdgihbG6I3MRXPVGMZMURq8n?=
 =?us-ascii?Q?gEgFB4hHQDh3BHIZM4/8XpuiycNyv6RiyA+sPgW20e9UlhRNjB/80HHFL1Aq?=
 =?us-ascii?Q?2tvcbFEi30lgnPDRN4pkEG67AGIFQefwxfWzVhwZ0nAPPgQ9kx/KTmV+xsan?=
 =?us-ascii?Q?hZQZShb1bZjUdQ1ai8suWZBvbPZDxVLFU2kVOruSXW0fK/cwxvZw1Qt73W4s?=
 =?us-ascii?Q?kS6aLiGvIhnQvDXs7QiS1yXNb3TtMPANo6R1e4gMj2E9ezWvkCait4G0bQEo?=
 =?us-ascii?Q?d68oDFlQsTvpD3Vxtsm7n0jWwGejC/5ryk5XLGrGbGyDAeRQFkVi7qJaqQzN?=
 =?us-ascii?Q?ODNr0H6kmgTkQu58I2ksx+3eDoxMzIfivuuAyxbLDS22xHzb7gDZge98vWWe?=
 =?us-ascii?Q?jgAguvUozOG3ZY5f+FynjPc+AnmWBDOTD8AJRnIZ8IfYlkn4Hwjxuy3gJ/fF?=
 =?us-ascii?Q?2F5j5C4/MbuFCfJkrVoAosn4D1uHH3dDtbeZpqp3aM19wN3sktzWVXbnThA4?=
 =?us-ascii?Q?ILkQeETA93F/KKpurmmMpH0somFMlpo2M/jXsi10AaETie3UlT3moQC1UpKo?=
 =?us-ascii?Q?0A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	lOHutNLtHVBpDxu26AxFuF5B2KJVhvBpycweCqUZ9Mb4ZVn2F4TUlvaZ9B/nUB+kBjGrLaAhe65xaM2kJaf4D+iVDn1Y/ivfMrJFeueRyMz4qysaOUBnyEJwyFKHpW62QpMPkkYv1zrI1u3NXOMTrZGNzaLwPJwFlm9B7xi5jsNsKgad10NmlLhnxIlOcPeDZnppgoXVTmSYXQmJ66Ta145fmzziisr0RMpNqGq0B0tmacbNrf8DyFF5FxWbq1SyuMAqm4EY9oBiOzPCUx0cWx5ncpdPUs59jaHwfpCA4CzLJHn68A6psffh2Ew66Ed60hHs0QfVhX6lPz2H6VNlcNibp3eP4P7UzypS0kIpFsdugth8or6O5sp6+YUp7/Pjj8XRnzkb6o1MJJrwmrFRspU3wWQetJWMtreP/HrMce5vSh3cmvA3z/TwcrP9NIzqSsSB0biArVTzJI1ff5cMdZ5n+jqOPSz7ypmeccRaRMGI4fQP+I3++T3LqRM9Gdw3hipDF/O3ryyi1efrjYAEtmsXDJGhgro8EU6xx6d/zZR0NMFC802aewIpjKK/POWuwGsOqlobhO6t1jqIUHHsPnKRR+La8lzVT7sNTvZlAUI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9391665-653f-4622-8475-08dca1512600
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2024 02:28:28.3501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WvhoTQwzvIhj7PQYrWtryPG+5RXt5tJtbkUP3MXfgmCA8FJ/v9BvcvhdyVhERftH0kz4ITLZlY1/nAfe+Zpaeggw5ehtUNtWlICBrPYfTX4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7311
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-10_20,2024-07-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0 mlxlogscore=658
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407110014
X-Proofpoint-ORIG-GUID: H2H8WC7gVeDI3BRMDDsT1Be0ocJpLlJ4
X-Proofpoint-GUID: H2H8WC7gVeDI3BRMDDsT1Be0ocJpLlJ4


Bart,

> Please consider this series of UFS driver patches for the next merge
> window.

Applied to 6.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
