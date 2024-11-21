Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9DC21364
	for <linux-scsi@vger.kernel.org>; Thu, 21 Nov 2024 02:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732156417; cv=fail; b=ZLh3L3nh6gwYNWnJTByY4L/dKtVm2U2Mqnp1EEjvw7+S/5ssJZaPExofPrYG39V2LNJAUvCUSm144UU3BA41XdH5kapfuIo0MClN5S5BiTxgZMvFFH/NMl5UaNbIauekBcttUAtH9sMn+gISSeIOidSXORpRcX06thGtui2ApS8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732156417; c=relaxed/simple;
	bh=T99cHPgwDadgUZURBx3Qvco+kbtgFcZPADrPr83rRQk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=WLWPbsf13ZAwT6oDMFsxDodPBWGyi+r9YVn1x6/9+Z9q+JqG9dzcN0N2OBhvfJGigxMFtii9dRJE85en1jolcwtK/U4TSwA/QCAE4TdDAQ4xaeKZnDdjRU7qlQSySGn0OFrBS+F8SB9z8BCaYUac8NV0EYOlP2kp+xHudIcixP4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cwhMDe2K; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nvOlnWI6; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cwhMDe2K";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nvOlnWI6"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AL1ffkI009380;
	Thu, 21 Nov 2024 02:33:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=6zQ4dLVGVqCq1FtDva
	0jBZ4V2r9Hx05mgxiP3V09uKA=; b=cwhMDe2KOCE4HGw/V/BEeKjpLov2Nwg8Y1
	PKLu4jhdYzh8WCNchZoLMo9revRatzrqqYJeWECOcYhcl2pY2f9GVxHhdAXCUdPq
	tZDdnQP8bnoPIUx2FucekFw6Fa+JVVFysKjHuB0Gj/NghyESUa75h/A74PJh5RL/
	eeevYl82mm0agylIaqpY9zu68aNwnArGzpbcwtwmEVmYLQLANmOfC/v5Xd5nVEKV
	idefx5+of2n/7Gcvxy/nU42ctXyHbH8ESAA2MKdcxIO68uHwK2b8lGP9jOc/k5A4
	CyQPu6+2JIWGPQ90/QdR8THSwnMhYa5bvAHwk+prViYu0VgUrvAw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42xk0srr90-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Nov 2024 02:33:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AL26qS6037295;
	Thu, 21 Nov 2024 02:33:25 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42xhub5eg0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Nov 2024 02:33:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J8vAwbmOX+7om8RZBlByMxP4acMtY4tvSZ9SU+smqqjbxKtVuhK9dnGjI8x79RPf2kBABgG+w+YjXv8onk7mY/AhQm1d+FwpH05rnsMsHkMJH1NuPwrNE6dN+7dZeSP05y2kdBTwEIrjiy8hpSraOaor+Z3z6iGe01ONExturLuDQaEIE6rtWDLS+Cwdb4y+8tCvI4m0Jw8zwnAuoV80oIX06FKOyKHXATvABFdScHbSIDsldx6q1T81cIZ62Ul5dV/C/cxSwJ/Gpt/Q8sB0zsnn4Bqulm4ZUWXr+qIO06gEZ5C1mxm1bhEXhf3MGoNZZNy9HQPAaOZIPXYoGhIItw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6zQ4dLVGVqCq1FtDva0jBZ4V2r9Hx05mgxiP3V09uKA=;
 b=gJrkSSRQNLNEJDjGnm/aQNHgHTxlU8PW9D6krvGMMcN7cDJqt046fWJsBje3U+2FmohQCf6K6U3BcomXC0nMp+YiKWaP4Bqo3gef1Y5Ls99f3dkvhOd2WfAL2Vs1rtRamrXnLzbLgOdqNLPPXTvobP6IQ74+bcMoQM27a5vkJ/mjdrzYcI1esN6J+n5Q6C9K1se6jzvVu1ARN3P5j2IKe784751maYEIGc7cFw/HTmiQwGZ+6w1u3ZBvRleQfzL14FGWYtzrTrGh7cYQhlLzHue1T3EqD/1Sja8laD9G/9x8r01yvcZhYBwK5VCeOmhZQqGGQJ6WdfemKmr/6fgKcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zQ4dLVGVqCq1FtDva0jBZ4V2r9Hx05mgxiP3V09uKA=;
 b=nvOlnWI6nSxITpdxpML6O2BkInLWohVASsWKpwN7iI+oKgw277I9mf0qC8H7HkZAR55Hs9uB/olICXCFU1fyTaLRETvyThc63jcoKnlMC31N5ZXYru3DA1ASHSOijzKlCJpx72NbD/w2Tpbn8f1oqt1BvT6ZZrgZiSvYN3XkSk4=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by CY8PR10MB6684.namprd10.prod.outlook.com (2603:10b6:930:93::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.23; Thu, 21 Nov
 2024 02:33:23 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%5]) with mapi id 15.20.8158.023; Thu, 21 Nov 2024
 02:33:23 +0000
To: Magnus Lindholm <linmag7@gmail.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com,
        hch@infradead.org, martin.petersen@oracle.com
Subject: Re: [PATCH v2] scsi: qla1280: Fix hw revision numbering for
 ISP1020/1040
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241113225636.2276-1-linmag7@gmail.com> (Magnus Lindholm's
	message of "Wed, 13 Nov 2024 23:51:49 +0100")
Organization: Oracle Corporation
Message-ID: <yq1ldxdqpsx.fsf@ca-mkp.ca.oracle.com>
References: <20241113225636.2276-1-linmag7@gmail.com>
Date: Wed, 20 Nov 2024 21:33:21 -0500
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0277.namprd03.prod.outlook.com
 (2603:10b6:408:f5::12) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|CY8PR10MB6684:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bfde53d-ca1a-44ed-3c78-08dd09d4deb1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3Odmli+iTw5InlMynXnZfwzMUDiQAeoTr0m/+vjbzj1s9SaTbFBfj/oiMw9c?=
 =?us-ascii?Q?9xsbvsBzuQs6VVoqMBbtk3Jq+O4IePPaXWi+deUCpStuXy1bceC5cTd9hUsb?=
 =?us-ascii?Q?dLoIiafqz9UBdwuczBbwZLyg1ygZJbEmdFxCw1AIfV/jBdSKom1OnFqW3T6w?=
 =?us-ascii?Q?9zPRJwjqw2KC2lCyxUzrtThTmxaYuKHby8mF6PA6BT7Ka0Y4zUP5ObKLuuWu?=
 =?us-ascii?Q?VZNlJykQcyyIgmS1sIdEA/quD2mRfb7VG3BvtMDq/t+K+71YIebRzy6dtuwN?=
 =?us-ascii?Q?iUuCyrcmfF7tNC0zZBUiilctGD34dhOfBoNcSAt1hxiKLmdwOIQcTaKIWkS6?=
 =?us-ascii?Q?uyU+yoSjXXQmWP2w84uaHJq8rUzIbpiAbYETURLbyFUWapsLL0OXHkxx9oMp?=
 =?us-ascii?Q?sK5tA8zkzsPT0H1WCk4gMjhd69hdM9dTjJdbignDsdsFDdCZ5URS9p7xlS1J?=
 =?us-ascii?Q?FQhSz4ErjKqN70abbXDCg6owkzeoHbVPKE7R/fBRfuixLxXLpkEhhz/LlPMc?=
 =?us-ascii?Q?wviJVFmsAnKLdIlvwiE+Yo4qqyv4ywm1BIBfqpVLpNg7JN2S1C/UGTBsXPb/?=
 =?us-ascii?Q?4lKHpoYOEzGrV0NOlaUYjd2d8Xr1LRaO09dwal88hBhSjdW64ma3TLw/fxVd?=
 =?us-ascii?Q?ZseqD8JN9wXIH/XHC1k75lgCw/RqTMO1rQQ7moDJ8QT/Sak9y4fgIWtZcgH/?=
 =?us-ascii?Q?zGgE0r2MH8TDJkrp6yCavmD6rJaCYswvpg+5FAWTSQ/rP6MVqsW5IxrnDNjl?=
 =?us-ascii?Q?qJceUmnHYCCfUpxCeiZmj7/2ic5rU1CbKkIpjbZheB88F4nfoe869X0PJ8UM?=
 =?us-ascii?Q?fgLKCCW5nDlDKdGpZA67Pgr9gQGgEQjwr57bHeOrXoQTBJeUerq36T2iyUaD?=
 =?us-ascii?Q?EGcMJIvBeEgZzD160aTjUN+wVMiJNkBorozlkJFQgc5lD5xtOvxDwPdnIH4G?=
 =?us-ascii?Q?WqwUsY5a5rpLWiYjNp1w1uO33+D27CaYJju/cP/aHuThfIfcJt2oJQogNC6j?=
 =?us-ascii?Q?coVGoBiCAH9O3IMH5lWtaGAvCECSFgkijBfjdWklE0u6kYue3JQ8txNWAIR/?=
 =?us-ascii?Q?jCC2pwOwZd23OrKe31g7x//Y4YMNp9E3m5HVig5b7bSJqrdXkRd90uTxVcsx?=
 =?us-ascii?Q?xgw8u3TaqclA/BdoqLsse2zo8H6ruYHghOVAhUGzuRXvVZoJPF7MrkxjAo/3?=
 =?us-ascii?Q?Y/R574Dye3889IUKyFBFlI+Yb7DArABlV6etip/bTC0qIaho9DRk0QY5JZDH?=
 =?us-ascii?Q?/Jx/ciBv/TViX22FEhnW2rHMqwMceG7zxfN75EH1UQb2Qjs3I5yLOegnow94?=
 =?us-ascii?Q?yfL/3CsCGqBhZK6bbuBiAqCy?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rrEAmPHeReQ2yWnBwomLnuMfplvR22ixFYAL3jLQAHE2MQAQyg8CEDsd1crq?=
 =?us-ascii?Q?fo9xWJJFiEZXFq+njmcD0UUTiQzRPkcbt/ac7CGVNEyM5f+Z+ggJNo3guJEl?=
 =?us-ascii?Q?RYS7KW8EoQaVnxFJRU31FLErYr7hLqRAXY9xwaaHMsrIN4u+TnNze1csGuCC?=
 =?us-ascii?Q?x2ANvDfN9iRTNOR3xOor0O/ZyvnZCcvFudtZHHVZkWsU5yd0kT9eEeDPZ+e3?=
 =?us-ascii?Q?jomoH12hsMzFe6dETZQWlJEuOfTo6gpzJ40vwYitld3gUl0aS6izDOAfNBo0?=
 =?us-ascii?Q?14N1JaZK4UqouKZFhl4kcZ+S/PH2tEKh8PHzZlccfzxSNRGyBw0iHd0ujy22?=
 =?us-ascii?Q?DZrXptCa/eD50EFHxemoR4XuGxU/W2Up8euExoDpk6y6Zii+4Fte1Tgm/eMM?=
 =?us-ascii?Q?BaPbxHCkE7jU4ZFDJ/i9+x6kfTrMifNfhmp2885aJE1YIiHK5x5rHIfOpjOz?=
 =?us-ascii?Q?OwoBe4FDRIvyJ/uYXGq+uxf9qo650Vsfp5POCBd0KtBmbJownVf6LER/HlCf?=
 =?us-ascii?Q?Plw2pyivkMLa8Q/h4rhdXhV4iey6YZrLgKgDz6VodI1x5NRwnGE1oD56YcdU?=
 =?us-ascii?Q?Vb21ZSy/3y1wGC5ui0p1XBbh9eW3VHu+JsfcxDhipvya6qEIG2yJri713sXp?=
 =?us-ascii?Q?18+wdGvkq1oPE83fPOoA6wpV9P+lDt+ZDzTdZXdb5Ljpy901D47wwmkSGC5x?=
 =?us-ascii?Q?i7tOnOJiBGhhaJk+QQlwMgYsuuNoUWnw8AmZuJ9AzP8zVob044U7LbJWPxMA?=
 =?us-ascii?Q?5xd6o8wS6PJLMmjVJdr5DcwdXvE3oHGMH6edQz4HHbHy+WqQuoCXFaoDmIo5?=
 =?us-ascii?Q?bjZCa3+SCL4MrIivgmYw0SpTRXbk/lDhsHBnj/ihRlohx1/kmtbmLgcjdn+W?=
 =?us-ascii?Q?5z5TtmU0DyD1OwwAtiXIZJw31b+wUM1PQ+K+702BKE3Nx7yEgj+X+InJU2AQ?=
 =?us-ascii?Q?NOwG+2rLnH2Xl2pSdpXunqo00tZKgealbyknqFzN/+DSmvGpiRLk8kV7cLRn?=
 =?us-ascii?Q?WExcfu3zGt6t5za2E2aX5C/EovibntGCv+haqkRF/HCVNYKCgT+rDCOPe66x?=
 =?us-ascii?Q?VGElBts8p1oomc7RxGxVuVzNL5sNljUK9DdIcS8eF9PNaHH0a7xk4QXT6aoh?=
 =?us-ascii?Q?J2IYraJ3E7JfDunoVCcVGk0hyKkHfIWvQptM46a1B7kL/zEQdT1wdnA5jTGs?=
 =?us-ascii?Q?SbZ/tZ8HYh9LMM8vh8n97P+WYFK9Iy/TwcOjosJq94+gYi9bfGd6pO1Fw36/?=
 =?us-ascii?Q?ny+vyNz5MKSVBPZDdGls8B7AB64EDtngOaqRresV97POmAhdg8ESkZz1rncx?=
 =?us-ascii?Q?7RE69Fu40YNiOJE4LGcYaoB1v1a8aNw60nYx+qecLcjIGnmSqMbcAL0BKbAp?=
 =?us-ascii?Q?HDDeg5nCZpviCvi+/+2RerKiepIQu26lmLMeZouORtRn2jO6doXUZ4RI1GJB?=
 =?us-ascii?Q?PxA6ck1cbdHYSClAHMB+46SBldlXnu/BCcbN9BCRvs58bVhFOhsoXr5m3RzV?=
 =?us-ascii?Q?Eu2sckwON3JiZ0cvBowjsFFEQmXI+k/WcTlQSlVViPnQn9Z8PdX8dve8hN33?=
 =?us-ascii?Q?up5eTT5m82bG57g/mYmIqDZMfxhyczrSvb5zncdVHbLe7CITRF9bhXBmdRma?=
 =?us-ascii?Q?1w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lAnkZBwMhlONVHZUvI8+ngBHTcHzymQf7Cvz5ZkRbnvcNsDzZv5xS+C7RrfYFwdTauZizQqgts683gAS5hVOBXTOSZ5l97MKzdCtAahK9WmvHLdMXttXR0gnqr5LkW/CkfLmEvm5UoSS+pYWwVMqowaaWhj7k5AzdnWLETEo9fb6SGpfiurj2TSvD7IUeCVYTk7vGeSkEB6PeeIZP1j9FWJvt5KDwdXqDbmDaytXjXe1JtbfjpZSNrZFJsX0pSs3OLrIytOtq/fD2WBUlA4245WQx8R5Hox2MZh5cIa2dTVRRHg6R0PLAokJEbTHzn8WK8rtf9gt4ZZUMW/dKLvnSdjrfWw6BLx5Px3iFs8HMXt7Ugrscxdsm0mRUjs5KMh+n2TmjkIwSDmmZfqMgGBZDjrjCHs0IzHSEzT4e/rruOSxrJ9GHyR2+HaofFyN/7MLZVPBnKusSaDtkjrDwFztMI5kpM40MME9tx3uQeYo3rgdVO5whiH5SAfrdEF2QEXJl9WQ71YpNANZj+HHtsaMofk76D9aDmhqyLBw5i33gyKMVAyUrTmNufWKgCySezQoeZOvnuwEfLIPD0TwG83JFztOfWaHQlFNug73dyE78WE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bfde53d-ca1a-44ed-3c78-08dd09d4deb1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2024 02:33:23.1732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rrLEj6Fjfk7OmPIZpp0vXifcJDhRDoO5/OfdGz8siz/cal561hNmf7/7LLC7lfk9ri4Y2Arr3p4Aw+ED2iOdirf4ZUJM7ljyITmLDXYq5Iw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6684
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-21_01,2024-11-20_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxlogscore=654 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411210020
X-Proofpoint-ORIG-GUID: 5i5q9nmPqIfi7ZgZ6QWshd904qgESj19
X-Proofpoint-GUID: 5i5q9nmPqIfi7ZgZ6QWshd904qgESj19


Magnus,

> Fix the hardware revision numbering for Qlogic ISP1020/1040 boards.
> HWMASK suggest that the revision number only needs four bits, this is
> consistent with how NetBSD does things in their ISP driver. verified
> on a IPS1040B which is seen as rev 5 not as BIT_4.

Applied to 6.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
