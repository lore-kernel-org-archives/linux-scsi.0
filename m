Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D4A27A442;
	Tue, 30 Sep 2025 19:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759261835; cv=fail; b=RVjbMW1X2imu+cnzl6nCKU8KKNYkeqDBjfMhii2tk26wgOAJ/7mgl7ljntygojHwXwEgSsyNMyUipJ/kQTmt/lc3Cjlk2dLSwaNaKjVgD/EdiusQtMTZHn09+IENevgihZCFrBGfocjThWEKz83+5PNmLD6omb4hD9shsgIFmkY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759261835; c=relaxed/simple;
	bh=u8V7sfR2KI9hSC6iy0rWJAz5b0nXucfDDQc/qDBr7ns=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=tlXywbHT5teyb9c4Nvp5l+rGcapZ1bOMaMsgXn51BX0BfgqKqF4srQ3ITZz3bZe8WZAyCAXpwEKO9tl/2w87npp885KvY9GDuwUhcvMC+PPVWNJj05eStPQ7vxFOmGsW+3kupQT/jiIlp4/dI9tDXna3Z7Ve2K0rgxPrGZud33E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=riK6Ic6B; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jqpkQso4; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="riK6Ic6B";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jqpkQso4"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58UIEuBM008310;
	Tue, 30 Sep 2025 19:50:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=oTFi8Y/h5UJ6AUFk2X
	Hf4RsNcI0AJ9OxSE1J5OxZfR4=; b=riK6Ic6Bu8zFaL5EDH6xtR79T1+Ew9NnDm
	JiM4xY1pzktarXXJCMdZto3YtDdEN6mgZXqcy8hWOgmaAY9xkLd7SCyimfQcGQSB
	JyhWE6k6bEypyvgoZKesNEWHvyvjHAzD18SQFOqzSp4ffWpTNY0MLoG61Hu6ZEx7
	V5OYFxcWZmt/pH6Q9B92Qkwz9TJwxfHEtflMPRpDTTBDv6YhCUq50u0J0t0qXGOU
	HRxp5wjXWkpficfMMZLFqDAMvKUh6KJdXBlkaZrx1+LdhgRvjD05v9Z7PhsLj/RQ
	HWDVVNDsEbBhHaCQzsCUqAwQ2mfiTaGXC+5gWcH9pLHENK+GKp0w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49gmacr61f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Sep 2025 19:50:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58UJGp5A007755;
	Tue, 30 Sep 2025 19:50:12 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010019.outbound.protection.outlook.com [52.101.61.19])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49e6c9ajak-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Sep 2025 19:50:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tdfPoWWd6NkjFtmSxkey50GHTX2euq0LYTZM1yRFuYBOS/QTbii/CsLiRE34gJyJU0V/SSKFjE3910Uzd8HvPVhez1GlHmaH7dcfsK5Pi4r5i3onJe9x0Rto4m7W6y/n52Q8m1HpVfmxh8q9Aq9LJzQlU/SkRhGVkYh6oRKUbTm4lQkwi0rLm6D7us7htao8hciH5fBQzVIvM/h+rXLALqpAaqcqHTW0Zuo3eDvAfFR/GjSxmxrpLsSoMcyX3o7rZIVvGLxYSjdvCl1eQq/2XVKXl1Fz3E9iCcBFP+UQr865FCrjJQuzkWSNLz+uFXn/u+TU0CSan6TS5NjssRIHvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oTFi8Y/h5UJ6AUFk2XHf4RsNcI0AJ9OxSE1J5OxZfR4=;
 b=eOGiwDCl3w7vB2Lf3p0NgEms4BMexd/bIpr9JUP5P7y/8aTVcWOhUjdXtIlMz6VAWExKQW3cozkW7W6DtI5kRKdAm2sodu0M3H1MxRj0qZyw5p05pMBwZIeQE1/NLmIBaZKqPQLjA4ZtmU6RqFsLntBt1UU1UgEcyzhSIdrtiK/F1P7nx1Fahid0ehu58J3UYlpmpbGPFGcQf9ARWnUKXIOAvifCDuVDctf+hyRhW/cHQP24SBENnNkhtyq1zigg+VNcYUz2WaOLNRoYFL0LQMhD75uso1qncX3XHSy6kJtJZnDYOx3sNp6vra+ZxB27KU2CNPjCF/HPEuixnQHMRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oTFi8Y/h5UJ6AUFk2XHf4RsNcI0AJ9OxSE1J5OxZfR4=;
 b=jqpkQso41elIX3SnZB9VuqMID5f47tBJOG0zsdVf2YOpCwZ3WUSkxmQvLuSwsGvYZ2Kvsr0FB879qdKM3f8ugfyPRUvpEMjJ6bHGCokahWrl1CJXT++DF9dnMzcgiKvKwplvyJT8+YPSYAh4HqFQRER9t56e0gqkrDh7l8VbDk4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ0PR10MB4639.namprd10.prod.outlook.com (2603:10b6:a03:2db::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Tue, 30 Sep
 2025 19:50:09 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9160.017; Tue, 30 Sep 2025
 19:50:09 +0000
To: Daniel Lee <chullee@google.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        tanghuan@vivo.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: sysfs: Make HID attributes visible
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250930010939.3520325-1-chullee@google.com> (Daniel Lee's
	message of "Mon, 29 Sep 2025 18:09:39 -0700")
Organization: Oracle Corporation
Message-ID: <yq1ecrnn2jd.fsf@ca-mkp.ca.oracle.com>
References: <20250930010939.3520325-1-chullee@google.com>
Date: Tue, 30 Sep 2025 15:50:07 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0094.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:3::30) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ0PR10MB4639:EE_
X-MS-Office365-Filtering-Correlation-Id: 220b2af0-73ef-42d0-eef1-08de005a8fea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RGXW71V5Bqo3w4xEnsmjblrGgI0ElVuVDFm9OBupaXtLghFG6IhC3gExXgDw?=
 =?us-ascii?Q?0ybMUmpG55Evh5JlkyDY2oCArciefDZaBFPfQmdo9jI0xREYcwHLqp0vwsPU?=
 =?us-ascii?Q?HJECMF+0Q5VTwvomVEMp4B8DSvMi3F0PsfFDoUCeeBtuedP9LsDH2EwJ/q3c?=
 =?us-ascii?Q?mk7PUzBhZy6WJnGb3Azbu585+u/T+9pRnC9yoaYVKEAiz3Bi4SEQTaJUovAx?=
 =?us-ascii?Q?frDb5UUxE07mn1byd3OSUMAMLSpUSIkMfk9WOCGB+2HRUjbL7G2e42s9XRcW?=
 =?us-ascii?Q?vnlb7g6jezi4ReAdhcw4sLQXO4PXDKR9KpdW6/IjVEXwh+TDIbseX8i/8JsM?=
 =?us-ascii?Q?0arvJwi1F8v2olJSYen03fqauwAlF5o58G1OdQMd/DbnoO2tAImjqP2jLLQC?=
 =?us-ascii?Q?aehzRxIzrV0CUZm6AcdnYete3VPtGeXA7l5dnHGveG5rfmuTYvaZtn61wycj?=
 =?us-ascii?Q?lejV5OQrLrS6gGEQRozlwjuCsEPlkPmaP9RHxn/Puv0yllgNph5NP4WsfeHw?=
 =?us-ascii?Q?X9S4+xsYKIggiVBZSfMzgRReTi3MYStZ/3gO1NvWdfEpBxqCT8axiv+lYJ3D?=
 =?us-ascii?Q?V73xIfRmOABDfNgVP6z3cfIKLH2EEia3x9WSKNF+pfvBxgVoIpGRHOGxZ3vp?=
 =?us-ascii?Q?s+4BX0w0/GEgzOr49v8x/jKjT7J9H+gJztf3Zc8LvwYweZrYAxB1aoptKPyV?=
 =?us-ascii?Q?tLwhuy+iKmB++xGk3tV7RkQPD4oGs5K1ihDbVZ+sJg560wuRjFWRyyKxgPDA?=
 =?us-ascii?Q?iYKvqEtZ1IsrxwrzyDhf4tO6jKikuETWlGbgKcyCBTOsESkg4/QNMHVsXdHt?=
 =?us-ascii?Q?cuGfTC2/a8PWzn5ARh4hURqVzU2oyNXG1wv1SvNkn5ZKcKJUmANBHzWSBYTM?=
 =?us-ascii?Q?JJb4cSVbOAxMVswdEr4orUEMFrKpiSyY5vdM6k5sWWPlDoh5MAtYvqQl0P4B?=
 =?us-ascii?Q?KvHjFIKAU3sUyS48OibpISDTB77WekfAfONz8+8YjXO+ze0pcHwMpOYfOHi8?=
 =?us-ascii?Q?YNzHfqXxDtWSD5c4t7zkAmCYcWe2Ioled1NUy47+lxVu94cF67jtrprPREmn?=
 =?us-ascii?Q?HE3KIb1zXfpDnHAp4uthbFNHqDLNzvG+wKMWeWXFQY59B9GhpxpExk6QARQ9?=
 =?us-ascii?Q?5taRdeYI0G2tLWsoWWfdDNf/prllrhI+tWatetOvU3fYiHYm4u3sA8RRCTB3?=
 =?us-ascii?Q?u7xxby+2kJCZe4PSVwLjDXMtjsy8CfQubOTZ/viytRsoury9mfYxln954WuV?=
 =?us-ascii?Q?qeA+pEzhfho7RRZqnGW4gmlyK/6ABaFFnV8vq3ZxuT0TZdic6+P/DMAE8ryt?=
 =?us-ascii?Q?4r2+mIk2bGDgLa5PfmXN6PQ17knvCFEhm9FTfWEMtvavbxuHpPZXWvpBjUSb?=
 =?us-ascii?Q?P9uOGNxLjIAi190VXnZPxc7B0mcNruk94/KyoepSGr/I1WqOG5CGt74WC+v8?=
 =?us-ascii?Q?eScw6TiVlk+kshQXaIUHy+/104kNrj7A?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SkHTIqlOQQ54IQ7vWxcs2aYAi8pR3WpUgp/CTTG0MS7pRsd6FeTJyPFoy+qJ?=
 =?us-ascii?Q?V9ZqOfAtFbqRfRd/DY1/kgyWHS1go/urIq4xDEABSHpU47fGliN5RWV5tPOC?=
 =?us-ascii?Q?SIE+etBbZkCkNduFv9C7wteLFi7KbRe86EszPxU1qyIowD4Zkitc5HJdhuH1?=
 =?us-ascii?Q?4kiPHzJWA0/i7DeN7TJOBSx1YxhtvaoF9do5+s+sJx99KYbxDMHMtmWvc/0Y?=
 =?us-ascii?Q?gFacWxCUv4S7BmKzAE0SIn2ODCKB6eeP4pXPZgr2+9Hz88EsGRCCWkIqMNU7?=
 =?us-ascii?Q?TawQpWOHZKGZlRcsXzFPLRPRRLMZnyMGbwdIYArN5FeT78CY40n8m0AawMJS?=
 =?us-ascii?Q?bKs4eiqTj4IzprWIMOSvcppZP/Q6uN0/9Bwy+iXTqf9Sz98lRYPLcIhM6BkR?=
 =?us-ascii?Q?MF8tg6Tove26tSX2AaI2hiDJnIV1jlBB5mU37SoPjAwaaJg1QtXThhmjz2JT?=
 =?us-ascii?Q?9Rj+PfEy+UREtgXa5nDN+svZltE+AGWu3bhMyAEIobS4fPfytbR7vGjvtpWw?=
 =?us-ascii?Q?2DsGGsCFrYchbikfxQl4QbEOMruZg3wpddZJVuIeobEIp0wudeDkyAzMVcAh?=
 =?us-ascii?Q?BHaiDUiGQ1StfwVNmXZ94m7xmeAvNa9MKOnZVWSfUKyRSbiFLxnElXjRyDzl?=
 =?us-ascii?Q?GKF/mVZTqCASYuroFJuogjahYQyFti3PBDoW2p2NmG8BE+4IojbnlnaiSqsR?=
 =?us-ascii?Q?WSn7iPzDPbdqshk6XSperkFoC07YV1KC8a6lr8o60jN1hmE05aY94TGqmHz9?=
 =?us-ascii?Q?Ku0mNyWHfa8sGN0VeTg0hR3MvL32tQeJIjEbA/U21fiOydWu21RTlFHXiitN?=
 =?us-ascii?Q?so5ScgbBS2QeuP1nRwDzYEMPULwV7N9wIygewLI2uZaotUreYYsxq08mhhF0?=
 =?us-ascii?Q?wj8a71ZP+T2Hm5hHIb7lrDtRwQEMla/8gAabuf901So5cv0fFxiFO+i7tj0a?=
 =?us-ascii?Q?VUQbs6jtVsvhMesV4MaDOvKYX6U2co+BVSBnSsZQht6oOLLYaVO4xsfK3Tak?=
 =?us-ascii?Q?hLcTBM67/W6tEz7bjCfzkDfmB+K2OALbVGXNB48rjqOIX93Ca7wW2pxBlLWB?=
 =?us-ascii?Q?q8NJj4As5NQmjIJAEYK58k+3OmnK5CEAMqmzYsjE93MGO7ERfr8C6ls9qsDM?=
 =?us-ascii?Q?qxh2C3X1bExKqBTuY3nWahMlKRYKxaVEUEUdXCrOZ7HpKCYFkCST4RJw9q1H?=
 =?us-ascii?Q?gYgwzjqKt/y2tSlT/MCog7UQ1XLMx/QCU/17nzNfGhMegDM/HJYSbWI15tJO?=
 =?us-ascii?Q?F9M6ljktTRC2WmoT7NwxVbimTKrDqqk7Tu7Grw4NWpsR2lHdY03a/K9RIeDq?=
 =?us-ascii?Q?VlNYvjmhFcIiA4B+G+cpgdGNW6R/wAYhSx+ZlZDMEQPG2/P5UZtXgL/n2cQ7?=
 =?us-ascii?Q?FGvRN+WQ6TqfaJZUR7TikEW5yK211kncNbXRnuLY1Fy27jUV8Z1nMDMg64R4?=
 =?us-ascii?Q?CMJKjXTJvAh2DqgcVbaie73swqmfxggeMWCtskLA4/yTrGkW6Py7CjbDBQhL?=
 =?us-ascii?Q?3l3aG0pfQZx0r9OrQazjYLE2RwMYZdoK7q2pbbq6ioLIbtrJpK/W2qJWOG97?=
 =?us-ascii?Q?JIJL+6yiI17DXHTbh5PgyYxtq1JcyjqZ7HcIrHF4X05mFvdDeT3OGSq8kdIU?=
 =?us-ascii?Q?hw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wWxZQ0KUhWgjc7V10dVw2LJkn2OjZmPCIsEpveTHNIRIfltjR+4mtOm276tj45hOFC8nztva9DKx1qwb/6KYPxVj3nPnXO42ESyQ5etQfu3ZDzNZqpQQxQ377I3q+m2+ZkMnResvhOf3qVy8Is1Uyx+e0LlbX2r1RKj+5czxFHvCcT0nJCNFpKxxSAAsvHplES7EJh3NV57WjrcwrcLVuVpz5dN27ZXJDpYobcI101Uz4EsGrjGXMxSSwqM0kuvPqPcKzM+C88XlHfoJSFGnSsUTsBY/KvkKhEEhZpDAyLT+RVll2gNGpoaRGY4PiPV4+lMyCmg1HDGEfSYfTY79Yp0BkVCzGe8oykPnEYcKeLXtBN6JpUyN9lU8JsadFbWRH4Nm/NdCwSsCpPA4kMm998wIfhFnuCZJjEv2xLMmmnuIMaiXOBPZD1rUFnl2U5KSPGPthrxwlYOHh9orjdeP0vpL6R5dcJmlhXYpL9dElsrQ6VlPI9IpKKXfyZQTkoc2Xi022O3/9CL1xK8lY1E4qvE8wMps1/1NCW5pGAU19ajqULVOPxyVkOJasrRLyxjyfU3PkULnqoglb5wxYJqrRHyE5TRYmHbS66izKdPp4ZU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 220b2af0-73ef-42d0-eef1-08de005a8fea
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2025 19:50:09.6583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0SguRKiFfL+GQ9z4YWd8CmTJQzbWhLod1FhSbwI48KVGWrpaL+tCwSuJKHL28d+Te0i4i3MKZmI+OWbZi3KOqCM3g0EKu2ULfwwpfjZb4z4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4639
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-30_04,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=557 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2509300180
X-Authority-Analysis: v=2.4 cv=P5I3RyAu c=1 sm=1 tr=0 ts=68dc3475 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=CEIZDvEd9kZ5D99qYfAA:9
X-Proofpoint-ORIG-GUID: PdwdBrVI9cgCUj5Q0T5xL8fpaZX5cWur
X-Proofpoint-GUID: PdwdBrVI9cgCUj5Q0T5xL8fpaZX5cWur
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTMwMDE2NSBTYWx0ZWRfX5Tg7L3C7pyr3
 tDjlEsP4HnWtSs/XyT8wOa4Coe8f9oPtArmDsLLLgHJEmbJDaIa3JvTOWcfymoCcPhAg+/3Zztt
 XcHYmDHOsNZsozJ6LLMNCMFC0zgkrPRmVNh7Y4weuVOD5JvmdTW7q1nC7vhKwPKijyDcv1NS3RK
 FUxNONJ+Q9tPfarhyBV+SRMQey5Hmb/BymV+t1WMynB/8VI+x7BH+h1ml5qG88432prjSiF2exO
 zBEFLnuybXj56r2cZ1vF5PV8NkxhZI7J0a6+J56WPqRMk2i5kEhD22aXGo81BZhVvKE/9DI5oAY
 0fybUkFWIPA+9ZXhq0Rr5hrNLUIWWHCYMfx6nTaFEnEM7UZTTLj6ESncXSapr1kPCX4qWRmpnJP
 WLVejN24Vtw2gOHcLa4C3FvsazFb6Q==


Daniel,

> Call sysfs_update_group() after reading the device descriptor to
> ensure the HID sysfs attributes are visible when the feature is
> supported.

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
