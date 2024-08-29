Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1269217BB7;
	Thu, 29 Aug 2024 01:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724895256; cv=fail; b=sPZrxoQ1rVqBToTvTz90vPLsbOsUNIlcXP9fW90lg1jJ9MhXzs+ot5YSR4aOmZTM/1qo0YeAJ7Q4ERN32vuTFqqAHNwzgIzozrLg3AExvjWJTbiBXLa7xfI+AcVJHg6XVfRpK7BcFrOa1tfFiknX924qW3qgVTx3IMBC6CCOE2c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724895256; c=relaxed/simple;
	bh=hlunBG5iiERwnj1EV8AmmDhyg+fFrmH+OmsmSr6Wmdw=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=O7O4y6OXV56ijYa9dduEXK0taJoXqfmJkPrPrBRTBHDp1YV3FuqwlgAmn1awjG7hWWBNkoQ30bJ5RJtkes+NCUDPkMFyFV4ExPopfo1E3vCipgxBIP81rcaQBis8z/NYm7UQpzqxY00OP2rn/Y4GDs7z8SjUzcpFfbR0rYyjxs4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=m/Ok/hRA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VyapKU5M; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m/Ok/hRA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VyapKU5M"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47SKiQaq003328;
	Thu, 29 Aug 2024 01:34:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=A6Ha8y2SeZFbhU
	zpr1zulGzxeP0mt1EdX7QmkzvLKzk=; b=m/Ok/hRAO6Z3GDUt/XtZlOIePnYJX0
	C8YQwvCvMdk3cjdIL24S21mjNX2g0l0mWyTJXnwc8YRWEvM24C/Yxgs8Tceo47W4
	8m2BCH6VSP3T5wo8jdx33cBIOraBsO0Z0G1mnvJ3rGvbbbaIT8tYszMWnL5Vj1AT
	K7AH+u8DeCqocfqivcirLFNgFuCjLiz1qkkjEJHMexjXfhaXQIuTX5QqkeP1E26f
	SmMGgHfkyj2T1kCUjLOwjdGrOvHgNyb+RfmAPH+Z0XZflq7NOjd6ImW/AMyoxc7e
	NIEyQhBq/BUmBe5kJgmEJ6/5Y5ImV40iS7Vrje2ZDtRxxbCahOymoy5Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 419pukk01j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 01:34:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47SMiU77036495;
	Thu, 29 Aug 2024 01:34:10 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4189jmkegj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 01:34:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wvKzx5HbiP0dwIMVhIN5nVqMEKCnePsdOoxz+JzCdQ2/L4FazDoUV9B44IvmnsV0+g0Kdu+UESgxHUv84Z7Fsru03EPHXsBKa40oRKln+JQhq835/g8VZhsYyRn6DXgk+Ox4cyt/PXeJL8MXpyqzlW1ftiKfdF7Lf4TjImL98uT0seoJfdAblR/nBu6z5bZJO+VAVFHBmv/uBZzR5EVI4RR2JUHjEqCAWagccn4XsNgiY69EpwwHFojUUT7z3BpXNv0Buo7Bt5qdBAo0YqUsQMfKsFdMup9jsoUVAmgW/UeEyvjSvKKi4roKi+jPjeZyy7896YOyKdvgJe067GY/ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A6Ha8y2SeZFbhUzpr1zulGzxeP0mt1EdX7QmkzvLKzk=;
 b=Thl7UWuyMSzvTL7t7bvkzskFTOpeMWqm/dhMTES9EK9CPPC97Xv7kQJ3shcnosoexvj/DVwDIX1AbXcHQT1WxRsvA33MzUPqkj0r0ZIxkFDzPj+mkPQigsmSWvfvbuaavaTGub2yPX1//mOLwLGQ6fU/wODaMBZ0uhCK1fCKkF2SF3W7sA59v1zoo3BTctQhYr+j5wJL/csNWZBPd+IQwQjN2W9O0R50LR8dSjJxMqIt3dZU8lwLeEjpL5VldDRkAZdzSmS4M8ClYglN5rSc6G+5bGZO3+wjWLfF/exMAVr1f4WSyWzgIE6gvdESR+zX6pAAfYNPRlMfT1kQl54i1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A6Ha8y2SeZFbhUzpr1zulGzxeP0mt1EdX7QmkzvLKzk=;
 b=VyapKU5MPQK2H3SiDeohwd/cb8YFkdO1g4S/l8qHF6Zx6MoevnhdkXDU7AXisArqDJiJq6dI+QJJxXUaJmfgZo49xRcqsWrL99UJ/DGcsZabjK1+qVvo/GYhIBX79W45ifng+Jq4ZXTt9WGTAjBAr1+O0RIlQW3Wsr2gG6qApA4=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by LV3PR10MB8202.namprd10.prod.outlook.com (2603:10b6:408:28c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.19; Thu, 29 Aug
 2024 01:34:08 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%6]) with mapi id 15.20.7918.017; Thu, 29 Aug 2024
 01:34:07 +0000
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Saurav Kashyap <skashyap@marvell.com>, Javed Hasan
 <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James
 E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K.
 Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: bnx2fc: Remove some unused fields in struct
 bnx2fc_rport
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <42e20b159f3bbb12da7796463a521ca051bd5274.1724399924.git.christophe.jaillet@wanadoo.fr>
	(Christophe JAILLET's message of "Fri, 23 Aug 2024 09:59:05 +0200")
Organization: Oracle Corporation
Message-ID: <yq11q28dse2.fsf@ca-mkp.ca.oracle.com>
References: <42e20b159f3bbb12da7796463a521ca051bd5274.1724399924.git.christophe.jaillet@wanadoo.fr>
Date: Wed, 28 Aug 2024 21:34:04 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0499.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1ab::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|LV3PR10MB8202:EE_
X-MS-Office365-Filtering-Correlation-Id: 55f386ca-c6d0-43b1-e3a9-08dcc7caace1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oR09LpPrKjEM5HDXoHTxPRDeOZ85SJYuNo641uCW0bZfvez1mJrbY1a4NwfB?=
 =?us-ascii?Q?I8uAHTfGxWscvMX7MeRZ9ettLJvK1WRAsg24mKB09vcD9DZ8TgCqIhekJqTY?=
 =?us-ascii?Q?lVQ7wfKHoEJGp2rcO84ItQ2zARgjzRtHiR2Cm7sIKS0el0CEROALgdYY/+T3?=
 =?us-ascii?Q?6b09PNCE3JJqiLtAM93oOp6jd1DaPMFytd3ex5VLvLjeP+vS9+5U22B2Wznn?=
 =?us-ascii?Q?QPQEDHqVnJDj5QXC/6s34dFIcPrQFmZbkwT4SHCx0719D2mW9zw8nCQUj26n?=
 =?us-ascii?Q?B3sRAUUn6MsadGfEJfrPFt5/AvQDW57+F4PODwNXgu3sB6SQw9bvWzrFDwsg?=
 =?us-ascii?Q?WeBOKYrEeGRc5FIWuCUs1OYyTyNyalgTzbdSdUJFoAGBXFDM2MCZwbX3tZ/W?=
 =?us-ascii?Q?oTKMLASEEcWlXV6Kwx3T0ocx3undLudrZ1787xzfcov5CzJzlDJd6R8Pe/1/?=
 =?us-ascii?Q?WodzdtE7U4xHuD0Ri4vAatB97mCSAud/6X9hzgDb/DyNp8krD9+s8vBpV0Pw?=
 =?us-ascii?Q?iJNXMJPXwJwV4nJFOk4wz1saNyYLEQwXNXdUkkYfgysaAKtn3iPzxaq4wHxi?=
 =?us-ascii?Q?DnkynfHPS2a7KNHjPnEyiWwqkZO60KfHeMif727gPschDgbivvnm6o5tEPqh?=
 =?us-ascii?Q?UCjs4goCUYor1BkfbL6z/T41a+PlojM4pm83Vrgr+5mf9fK60f/Audz2M5iF?=
 =?us-ascii?Q?qPZ/0Sl4zKGTCEI3Tgi+70YAEKtvpuVjAd0hM4jyPPQMqern1+kQX9EZ3jXs?=
 =?us-ascii?Q?c1/unBq3rnGyhvQc3n/a9gQuuJJZMrAIzZ0UqajX+MNbUFNFRWbIOfgfXzJD?=
 =?us-ascii?Q?ulUfWBpA0DQ8CHZk9zdX4hbWyc/wpZbosQaV9tdqVX6ER/1UWUh0CAnUzxAz?=
 =?us-ascii?Q?7v4mQmy5Dlz/6mwrFauYNwhm/yPvJgkjTnLSFQ2TEjMGnFlsbXaxzKcxhD8l?=
 =?us-ascii?Q?hnaUh07G0UzLe6KjLsKJhVN8H3KRPReDlHJZrt0/LUHYll5DE05atsRdFu97?=
 =?us-ascii?Q?uOExTLrVAGfjtcbsJHPgswUSmAshhoCgHAUPsLm4SzmcDxPxGLIsG0pG1tb4?=
 =?us-ascii?Q?7a7T+/FVU30jL88bXf/wHpLZJXbLPq0qq4Ajp58rtmZnbOd97Bw0IVXBh7pI?=
 =?us-ascii?Q?OG5u3A5Kyk6CuYe+G6w2IS7Rao0rRJ/U7cIy8csk/tuRn/3MSSP9VdTqX9/W?=
 =?us-ascii?Q?BMdSdZMnuGUCn8F4MutYO4sg6JD/PjamEqgsOe6F/VGMKAYr6uN1O1HcDGd5?=
 =?us-ascii?Q?SOHqhyntzBi6/50RPSmQ3j30P3L8nBPboB7y5YKo1cXJpXybLShHnpDLVDlW?=
 =?us-ascii?Q?HX+9futN/0WpGK+HyBd3EQsofwpoq1HIDysAj1iQeT83wg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vzwRdGT7v76HeJBRUD8tlaQ5xlQbDrWV9Dvq8f1iG417enWINKdmKUd/SJua?=
 =?us-ascii?Q?ZViGWJs60NJLrwvYfFc2um4JjbnNOi1kG3kKKrVyq417Kdg1FY3K3vmRvjOx?=
 =?us-ascii?Q?f5imvH61DWhdAZRQEidALgA91ZMmuL6RRkaUuuKabvylsEaUzACZQ4JER8TZ?=
 =?us-ascii?Q?/25PdVxF5A6ghTgcdkc6LcwA8urpSn1IvuocxNkrRpKiKCyyliFsulx9LhcT?=
 =?us-ascii?Q?sGR6IkK2NDAG9k5mle+7qHuXeA9+pio1N+t+bO4wwsxBUjulMskVVuuO82ks?=
 =?us-ascii?Q?R4CkEZXcWLPXK8EZ4fXGJrr+H3btOf+Trwkmc51aHv/GTQWf3y44Sh5VY6a0?=
 =?us-ascii?Q?KrWN3xCWtdqsPSjkluuP0QJ/6ctkPEzkEFfItjWWdgi+VzP3xiE4RQ3odlcd?=
 =?us-ascii?Q?rqm5duXGGe27tHoCQkFgYrc/hcnJ3JYQCxyLUh5Tjzg4EAPIX6vqi7Uj2Pmw?=
 =?us-ascii?Q?yN/g27Zh6fFW+wEl/aR4zKy2A5LlN3L2bsvDrMYhEXT7+yzyJMKIdR8ffFQJ?=
 =?us-ascii?Q?YycW1v1dozI6UDuF8oeN8dRnRZkS1vD+8E/T6ozIMmd6u0k2ljKjWXXezSCF?=
 =?us-ascii?Q?T6MePX2BYbkgnefyQJf4grRlZq8paMJhvq48cl1HpdVzWCetCD5RmRSBQEnA?=
 =?us-ascii?Q?u7KMfF9KUXI3hxEJd+Bc/fyR27rARhPtBqlkf1g7putjM0dJOrqvE836HNdb?=
 =?us-ascii?Q?I6D1qj/Amr6bN8p8LOC0MPKw/E8jf2oiLJVcOXOF8wBrBHf9aDAhY/UxwWNk?=
 =?us-ascii?Q?bLulRTJUXiMX1UyffOMaV5rD6W4VObjM0U9Ad97eWrTj2i+1LC3CqYEcq8wq?=
 =?us-ascii?Q?XDSKWEI1yEAm/0Whb+u7zaBfBvj8J3A2I0W/KjJThuCS8iUbOvmBbc2RqrpE?=
 =?us-ascii?Q?nEZK4RLV8yT6DhNLJbkgik1RU5O27MD6hEl01B/WOR9xQBVyj457TrtSoEkJ?=
 =?us-ascii?Q?QuPvVtX2d9W1XKeChRQH5oOU3wtDayVdtxGNTCps6+yrfh76M4xVtlHWcQyB?=
 =?us-ascii?Q?GDzP4000UEzTiKdluXogdwC9aCzms1lnalo1WQpmMbZmqFCp4hZYI+igr7mj?=
 =?us-ascii?Q?1X+LXXOh9Gp/P4ZVq6Af65RKs63ZNEyDvqSmNLUv+xaXV7lCcKXR7h37Kjzr?=
 =?us-ascii?Q?MB3LiijyzxTjix9R5ICCsIVEPpyCEwres8uTwMAJJDQDly/iGr1mR9eMBvqn?=
 =?us-ascii?Q?dfoDRy3Srsp168jybFSMxkJdth+2Qk+e8SMOA9LDrLLHotJBTWY9IcYUi9vO?=
 =?us-ascii?Q?iyneKq9wcn6/wXIruxSHm2aiggXvFimOUTWaltqXGUbZ/uKDEKPUJLjQ9n6Y?=
 =?us-ascii?Q?t0/lxnHosaCClHKbM5ieJt/rjGCDRgMstIJ90qRXCfe46BhsjrhK5iKaazvX?=
 =?us-ascii?Q?g2TmXwiKFAWWx0p3ZD/LXL+9vNwp/xOaUq0G+f4VCKz9wyLKCvHd4kLGL3Vj?=
 =?us-ascii?Q?Gbeo7J5kixrnPIVzcY8WVxGmD4pR2t/8qKnoLlT3DApfHSsPvv9NJN6OkiJ2?=
 =?us-ascii?Q?LlBXt/McXbvF/TxGEaiJaaAwovchiBEsIv9sP+YiGO5VPFmO7K315m5L9ywO?=
 =?us-ascii?Q?vrjAr9zDAFAEcSx/RiZ90Ygt/zoPiyFeuDKWj1PdHdVwR8HqXDvY3op1jtfB?=
 =?us-ascii?Q?zQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Pfl5lOZNBWRjNr3SdubaM970pXFxneJSv7Z6G0oX0Ufp5Hl0sUaf3tGoyTeld72pah30lrUiwuIYvvXSVSKjBUu3S9YkDDfCz3M94ZfTeKbGcrIHBGVZDyJRtlvEUGTAZdWi0vyvira+EUum37uPRyCMyUOc0kbxltVNoP3NDn192icn+svUy/GygLLZMYViMPGfuh6tcGgeJrbh+7m09zDNohZI1JlkdgoL8Y86uMRAhORA1QrdipUJCASjOfq/T9L6bStYV2/59FLVISjETp/i4OguObnBuL+mK3QNPr1Pm0voEia1FJb3abjeyTw+sMwH3FEdvjN/PUJzi0bmmoh2kWJgxj1jcDRbj5pJEfEBY2XEPNtBeaP81GEE1pc3NwDChcMxFkiK8ajUhkLHrHQfVUxeiJl4cVI65LRGXmwXIHwY51CMYSxxKw8wMnUm4foSoMOxMlLyvEKpRGF9WLYv3TJUCouYgUvtA5RxPjOhHEjJ7o/35FjIfFc1Nhn5Ko4XgNu33h8ja6rK0lJGj1Mp4uqfCexYnTfaCH0o3T2znaB6ZAgx3rcYiIiVf/In0EpMMTqA2zv3BtlJ8kAXS8oryxFBsFShoNd94QTtEeg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55f386ca-c6d0-43b1-e3a9-08dcc7caace1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 01:34:07.8410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oboo+yF51fuyMVhQy+3329fXzeFPVj019jXSrUYQOba5Jf9VvTgIWE1dumH9KHTwaeH0p7Hljyn60sQ76afcPl0NZ5/dvYLOkN9YQmEGTSs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8202
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-28_10,2024-08-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=839 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408290010
X-Proofpoint-GUID: 334Vr5PgwM60UyJ8-YMqYlmFtHuv3xEF
X-Proofpoint-ORIG-GUID: 334Vr5PgwM60UyJ8-YMqYlmFtHuv3xEF


Christophe,

> Some fields are unused in struct bnx2fc_rport. Remove them in order to
> save 96 bytes on a x86_64.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
