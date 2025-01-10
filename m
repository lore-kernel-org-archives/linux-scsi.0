Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5464D2080DC;
	Fri, 10 Jan 2025 23:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736550412; cv=fail; b=GMXdVA4scn1xMiqcoBAK6kaMa1xrx+ZtqQAnxm48EBvMFyXdOkAFka2HAS27mQIn8iv/kRrhSFtmaohhgofLvxoFEXZSCFZUemGefmnHneAiMUUgz/GmX1kU9oBwvp7c6LZ4VpOYHKCSk0xJVTRXeaywdqxHSizZBqicVreyzDI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736550412; c=relaxed/simple;
	bh=MeafS2IkRQrfDdk01u1STjkeWySiAnazCg/6o2yZ6jE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=bFfPYRGyecVVtcX5bQbMUdg5ra2Hy7SrTeaq0MuuueZj4B3nQqpOnsO2TZp918/igWjJ5Omf49oXRXCdb/Pc02sURh9RfpJcSWIuooI9QFFm0d+BYK+/OB6v4rfhOx25HwmXEGUO4oBYUNeHhyPRhVmyHaC3OmNPoPhDR6H062A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=E8asE69M; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WjoRPtKU; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E8asE69M";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WjoRPtKU"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50ALBt4g015601;
	Fri, 10 Jan 2025 23:06:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=Ljr+qqpD5zEAQroKyc
	nNgxF6D1ycmmifflNRzKUOndU=; b=E8asE69MvGT1sMf7zKcP0oaKoiCQtI69z6
	bJtExKZDRpzQDPd3i4IVHE/qUqjANzFnuK9XgTf/E5yziyjJ5/Kllf9zTltDoXWj
	eSQS9FfK33tIf5c9bGAQF3+pIVc/vtYbvVE97pWvkq+pm6lZWEJ36aoOWslTeOEk
	6yxdWSbWXU/f1cAkXhOkoaQFvJyCYZk4dkTin5/m/vMvSLaNxpW6xRhpF/LpauML
	dUGfY1UsDuL4xvQae+9MIZ24GMHPVhqESVaeBc7oSKpR8xLiK2s8rigNuwQJLW+f
	fM8ydLjCg9LpjHmXXeltI2bpw54SvPeak6U77sseXULdRgYVnZcA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 442my62ayf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 23:06:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50AN1Nbk003584;
	Fri, 10 Jan 2025 23:06:18 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xued0ubh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 23:06:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mO5LzC2VUsPkDZIWJyS47gI2q2roPSEg1K3Q7vE/M6eneozComb+JcLmrnG2PpB+L4kFiv3ax/iiM0p/7Q8U8QzIkUIxOhSDEAkpaoTo5e/VsQDAro+xYyM6gtQy5Omkh1+Ltu4IbJQc6qycGka/PqC/b09DUkC3KeHy1wr4WszXSY3JQmkFf+qoWR7RjprhpxikKOq9l/ChZtwseJskY6q7AITRvNfC+dvPe8TuOTwT/OPPQHT5+nHyhNWvOoN15OV9klP2mQmHqUsrMQY1u/WZk/nRBryP2OGXl86fv+zNpJS06ZRgZk1veq777mixB9JhMIRTpVx0ayO4lP4mrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ljr+qqpD5zEAQroKycnNgxF6D1ycmmifflNRzKUOndU=;
 b=KfPnPzwag06I/4icfXMe9dBeQNRW9Lelv15VpkcQo79NvdIU4zDmErsKCc3jKjnhBJcW9WFk8EuLDwrCcoyGh9/A8TAnuwlu4aRyR+SiwCPMInmAy345PlP1Dv4zz3k6liPURjV/M0uQWCLDgaHuPshGorkDTs//g54bHs9F7/ZLSMg7RUOxfJ0re6qP6LaGEas1isrOnpVF0ihNQsGRroIw4f2KnUHUj+XlrUk9lQ7PGfMZjtkGLXwQjbjlDGGe1xqneryJ2HnzHp0EHoFmj/2/WV0GzK4X5gqa+wMTBZ7glwQFCQo2D9tknZSFARDkkc+LboPPQDcTWExiiuls+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ljr+qqpD5zEAQroKycnNgxF6D1ycmmifflNRzKUOndU=;
 b=WjoRPtKU7VO+o9V6rDy8+KiHv5UBzBqKFHPHzDR/BRPMlaCGsC9cc3VQxWdOEIGbrTsVKbkrSsy+QCVHzcmmizdaXeWwVFWxJjRbRe+o5xEqzJ9618F9gWjWwJ8HfAU9IfNK/kjDUvf2TMh10SJFmvr+gbb3aXD3lXgsCGDw1xA=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH0PR10MB4986.namprd10.prod.outlook.com (2603:10b6:610:c7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.12; Fri, 10 Jan
 2025 23:06:16 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8335.012; Fri, 10 Jan 2025
 23:06:16 +0000
To: Saurav Kashyap <skashyap@marvell.com>, Nilesh Javali <njavali@marvell.com>
Cc: haoqinhuang <haoqinhuang7@gmail.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        himanshu.madhani@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, haoqinhuang <haoqinhuang@tencent.com>,
        Haisu Wang <haisuwang@tencent.com>
Subject: Re: [PATCH] scsi: qla2xxx: Remove duplicate fcport release in error
 handler
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241230065041.67315-1-haoqinhuang7@gmail.com> (haoqinhuang's
	message of "Mon, 30 Dec 2024 14:50:41 +0800")
Organization: Oracle Corporation
Message-ID: <yq1ed1a46e4.fsf@ca-mkp.ca.oracle.com>
References: <20241230065041.67315-1-haoqinhuang7@gmail.com>
Date: Fri, 10 Jan 2025 18:06:15 -0500
Content-Type: text/plain
X-ClientProxiedBy: BN9P223CA0009.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:408:10b::14) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH0PR10MB4986:EE_
X-MS-Office365-Filtering-Correlation-Id: 2956e8aa-87c8-41cb-af0e-08dd31cb62d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?k5FijbtBuadhA/9eDNr4nsXJvmIVHVOfEpB2DNPhuqqg9EuZB92CFeLIqTNi?=
 =?us-ascii?Q?LWEuwmcCJjgLsVaUnpHPt2kLXzxDQPOHQFPaEma+nxQFQy/MlQ6J5Bgb0C6L?=
 =?us-ascii?Q?uH+u8RsO6hCHZ4MSwpAENe6FsO2WeetVDOwmuD5eQ0VbvOpqT22g0zcjJxni?=
 =?us-ascii?Q?zo74xronb53KV/KqjQWd3z4mvZXSxOPytpfTJJbVjJLwTif4V0fXv78AW28a?=
 =?us-ascii?Q?s6xFjKccdfEVfKzUL2bl+2HgLVWTrXe5z8TG0BlnWIgg1WSr5RdG67B8/6MN?=
 =?us-ascii?Q?LHB6F9Wec5q5mzcJNmrA2uqqt7K+cs4tvkfgecwzpITaO3C6h6F/VHEfhfNb?=
 =?us-ascii?Q?IUheklZDkNclIumfC28Sp3kKpGSNfAtWxSEvynN2cHvET48A56/JHzd1oNDA?=
 =?us-ascii?Q?Hn54e2S2xd5VdcYz1r6L5q9pKrXo9u9Xi0NgV3SUoLR2M7kV7O84lprJURQz?=
 =?us-ascii?Q?6ROSD8DMBXFbfq8u3g/HtNzpwhG0rkSTv/H4U5NlM4o6MtxAec0yFtgzzczP?=
 =?us-ascii?Q?UKIQbpo3sBEcnVz1FOuZj331Glo7mpr5lngCeIuTkFrnMyGTGLVQUTsXKUTK?=
 =?us-ascii?Q?3xafWRqbdyK2KoOHGgcyzKTu6HUkWj+to1vawNi80315JE06Czqtts0mrLtf?=
 =?us-ascii?Q?iaQ70m5Ooeb16/zyFwBY5wgoZIxiaPzTuusWUp7kq23CJ0UcvaLDqyzFUqm5?=
 =?us-ascii?Q?xDBtDwZ4N+oV+0QoGYd2bYoxc7DNn9WWYhRxNGRw53FFC7Sj7AFM7ugaN9g2?=
 =?us-ascii?Q?wLG1ue9+4gj2gfkrpu1Jum6/xmMjKMtTE/N/7KUaFjrZnQK7eqomKXcYWivA?=
 =?us-ascii?Q?2YWEhr4+5PWBpBLd9T04j58N4Vlo16kzXVU3oCFAaVcCMsPeaGnDf4onjDHu?=
 =?us-ascii?Q?h5IQkvFj3Ckgw2FTP/RrX5/IJoYmBtNWLUsZu5/WDTG7lao+a9eZpeJaCtyv?=
 =?us-ascii?Q?xfKSIkK7EFslmKCD0oGATxsBOrW1mHqL0ZHBsdNkX+xbtdULoc9WvcatySc5?=
 =?us-ascii?Q?ZtFoJIdwxhK5PrILDI4qQvF5vML2ElqKlqV1gDvddaLpVyuMzd3qjbrTPGpc?=
 =?us-ascii?Q?UPEwVL5Mv0nBKFnIOQIc5D7WHh+tnTx3tE87qh8MsyLs3VHmq7IzT+UmHaK9?=
 =?us-ascii?Q?NdqMsKgHa+RgHKsX3HuuNk4/3RaeDy8FN09dsbKypLc8zFYx3/dNwjQ9eh1S?=
 =?us-ascii?Q?fVr9ElLadbNEYPW149cTpiZJAJ3cqFvlXHDU/KzC22JLr/Hj39RXglSVcphL?=
 =?us-ascii?Q?cG7nER/x8sVyWFTmuZy75mFb6uYO9L7xd8j2Th8px7LdD63WtSDV9ZWTr5/P?=
 =?us-ascii?Q?P1s6uLbR4I8AUAZllG305t0idUTlFNtnYu6VdtG2FkYjsSt9nYOeKIes3Cbj?=
 =?us-ascii?Q?We7lnghzdqaxA4Yw7W5hHO6808Iv?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vLseWktzInIwUfO3yT0M+bBwt7TDgmRzYbEE6KE3UPYAebIv+xSC7oBe8JfG?=
 =?us-ascii?Q?luYB0n80SIL2j0lcgvDcRls2F8pqnQWzRBSUaBULQFkUGJ5KSBI2XvfP/mCK?=
 =?us-ascii?Q?6zRz7aeswRX2bwQZ18YUfBKsPyUFUDb/P8y4II8rhbmYki5S2MlvhtD/XtDp?=
 =?us-ascii?Q?qBNyq31Ov+r3kcl+44x83m//V43aztCb4dT9cgp/itvIupLP678TjJW4BQ6p?=
 =?us-ascii?Q?oAX6MuWlQ4OXzKs9gD5iP9fJQMqT3CW3aWUywvf58/5qpHmbFJCh3ijoDDpq?=
 =?us-ascii?Q?MA6lkubJfWXwHIZDkBl+r/d8L4TPulZtOrHzk0O8BgJSOAAaOZSGTs87VPov?=
 =?us-ascii?Q?cpEI1ztMp2wuOy/fEBVw9Uua4LRvrBuDqoY64F2BSFkEszn49qsnYRnJz4d7?=
 =?us-ascii?Q?IFiWA5JczRvRg7UUmk9AiiAwXEbWCe/33g8bcR6R8CC3TwmPvAWS5gtUCs2X?=
 =?us-ascii?Q?N7bTVzXENGmcbjW/wPzGQyWGJmvJLPBPgZdjRKB/4m3FzF/PydamD/hr8yei?=
 =?us-ascii?Q?nxfJKr0JqaV5FG/Rf55+ZRGC/R/wjxaAjBnbFMudgCydAJ5IaZxUH5YT5lSi?=
 =?us-ascii?Q?5y/Qv//Az+RU1bEjRdw9Sp7hQ4dLniyzVqic50RGTMjU4J8C+xa6mzQEcrRT?=
 =?us-ascii?Q?e4brKeefpO2/ADO3MGI6Fkruuu3eGvBhvF03W89SpmJSEc/bpHicnTXV0OPc?=
 =?us-ascii?Q?RTbWM8a/FYb2APQBljVl7nNQegDiMPX0QTqACvCN5wDIvKJ57YfbX99NSU31?=
 =?us-ascii?Q?KsTnyG3SzK9ZWUkk3i1sxbmiKpYvjZSh9mUb26jvTqnuJc37gaepJtDEvmma?=
 =?us-ascii?Q?D3s04wSt1h+Cp3WSvnXQ2W/x0G0hcFi3wtP/HH6wjuKLTna3U8HCmMocyNC3?=
 =?us-ascii?Q?lmRZJ++IuqwIKwyzCWopDoyDAes4EqxCjuWBQTgaldGoNngF7iBoMQGSphTb?=
 =?us-ascii?Q?jxiH+R70uO/PyyIzBGm3MAZHxFfZKRE4j15/EF4rS/XC+lswpY4kjUg3N7Za?=
 =?us-ascii?Q?EK6t2JlixOeqRaeVb0jkUjvy3QcO1KE3DafOMaiNv3IGkliMX/Nlw+GVIqZF?=
 =?us-ascii?Q?tT8IAMFsoqVVn+5zfd0XaDAYXoDxaifyOIQRti72M17487SIeOb9SQZCckiU?=
 =?us-ascii?Q?CPAVL4bBU17uRmicuKGHisV/6J1TthlyO2OMjbkyR1bRsHcm6DIJmzqctxKI?=
 =?us-ascii?Q?Qfi8ajCHP4mvrunhUYYMEQa6/xRq1qNZ/WyIA69LU6q70aTIy5m+AE3b1HcF?=
 =?us-ascii?Q?3+nsQ16WXtZppKUO1EShk+ZTM2SvajCiUywa42tDQ2XaigfSdqMb1mY/mc/A?=
 =?us-ascii?Q?lq1KYlViMqpNCq1Z2EPj73DOYA6EjB0mgAPZAJQPJhfBWvJ5xyE2kEus4tXa?=
 =?us-ascii?Q?2qKFsHs/KGH3URBu1Xj+l37gM4NPeUSx5zDmqvqGzhnY6ZmBzbzuCt/sSZG6?=
 =?us-ascii?Q?a9VbiAdBfU4rUSdQnmvlMKXba31t38vPv6POF49vCObOGx5scTA+gzxK3+q+?=
 =?us-ascii?Q?etCTOc1bq9eKWqOW11qxeAuMva+95IFo9qH6XSIqFKeaLpyLhxxQgxT0w8+0?=
 =?us-ascii?Q?LUK8SK4KNrRipu5tjSAnV/hl4lkBliocWgRq2Jwb6wqle3yLKpTqRfuazOH6?=
 =?us-ascii?Q?vg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EybOEw0oJzxwqIq7EdkxYazxl8XXd4eAtASf9gJ1YcMlcyMfrNwL5ylb4WeLGiKPyfJp1ggyUQQ6wJuf09MloPqIgNhog4OLBcCxTGiPxLr2/7Uoa8qhWORjE+ChsPl4PCO8UraNgNByjYYkVnz3/PzLCcWMCuaGkznKInY/gr8po/o6Awse682tAgiCxEoXgPh0V9cOzZgNoSMrECmyUjZJl0FxqC1/IwUyeIFWGW1IyP3fCtbUHPqboLZb42CwqlK6Cu0z++QUu+RvJmrgG8bxBKZEkPpbo3jHBwdAo3qOPOcxDhu/yES8Wv4sga0D1w+tSZDjPZ4bhwMXMwqf7lajdIuvloAuLaXTRewo4KDTX2eyY+qet6VJX0zDvlhS5Yaot/DeQPte3h5DDAY4G8e+uRt8ulp3R/8b+to0VdDQ0mfLZFgO/m8B4sZq0udr9Ev2KHlpGebi+/A9f46MyM75BCGuEuUPR8ePnM/FaddBZWjgSf7Iwpcl5CouZLCdHwbIdlM9vn7sCznTyEBnVyaU6AbAmF80MyMzy97linpxoFrZKxJ+YHoPqX1MqXXaQrtCxqs6rYzCoEy6xUlHOFMMlgCrT4WMGSmomYCepOQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2956e8aa-87c8-41cb-af0e-08dd31cb62d6
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 23:06:16.4408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fKFjobv+Ty9Bttn5WummaG1yXYS48qfshnQFtkGMnpYI3vJ9qbXR1BbWZUvuZ8Tp7g22IIhUXyRdoEPRMWuVtXd87+EbNJU6i3XyBBgKhts=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4986
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-10_10,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100177
X-Proofpoint-GUID: uXgI1QWz1ksksDgeZ99c5sto1ycWrvPr
X-Proofpoint-ORIG-GUID: uXgI1QWz1ksksDgeZ99c5sto1ycWrvPr


Saurav/Nilesh: Please review!

> After calling function qla2x00_sp_release(), the system automatically
> executes the function qla2x00_free_fcport(sp->fcport).
>
> A closer inspection of qla2x00_sp_release() reveals that it triggers a
> call to sp->free(sp), where sp->free points to qla2x00_els_dcmd_sp_free.
> In function qla2x00_els_dcmd_sp_free(), if sp->fcport exists,
> qla2x00_free_fcport(sp->fcport) is triggered.
>
> Given this sequence of events, calling qla2x00_free_fcport(sp->fcport)
> again during qla2x00_sp_release() is duplicate. This redundant call
> should be eliminated.
>
> Fixes: 82f522ae0d97 ("scsi: qla2xxx: Fix double free of fcport")
> Signed-off-by: Haisu Wang <haisuwang@tencent.com>
> Signed-off-by: haoqinhuang <haoqinhuang@tencent.com>
> ---
>  drivers/scsi/qla2xxx/qla_iocb.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
> index 0b41e8a06602..faec66bd1951 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -2751,7 +2751,6 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
>  	if (!elsio->u.els_logo.els_logo_pyld) {
>  		/* ref: INIT */
>  		kref_put(&sp->cmd_kref, qla2x00_sp_release);
> -		qla2x00_free_fcport(fcport);
>  		return QLA_FUNCTION_FAILED;
>  	}
>  
> @@ -2776,7 +2775,6 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
>  	if (rval != QLA_SUCCESS) {
>  		/* ref: INIT */
>  		kref_put(&sp->cmd_kref, qla2x00_sp_release);
> -		qla2x00_free_fcport(fcport);
>  		return QLA_FUNCTION_FAILED;
>  	}

-- 
Martin K. Petersen	Oracle Linux Engineering
