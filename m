Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CF12B9A4
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2025 01:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753406747; cv=fail; b=kYFJowhvfeirRQiY1UuczU0E7GocOjqF0DAbVi90bcJZaZ9/KgYK6Qnvscqu+0z9gI2dpS+/mOumNSHYxMoX5Cnfz8LTe/xfHgiwLG/QTqQiYvVpngM9myplKjQitSqEn+EJP/sLMxVEvSmQGzEBqfMKmBQ4KAGZ56G4tca9wM4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753406747; c=relaxed/simple;
	bh=56hiXWiprx57diHgqJnE5E4yg5E2031c6UJ2V+V5dSY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=WNrU211b7rB0YOoHIEl71MlCBEX0JYvZ4vQ5DPZRSZzGUqo+O9DqnaPKSTaPDXFIfjnFM3GsbQK7Pn9YPV7snFOLQ4kbTWVnYJOKL+A83HRj/E5TH8Ojln3dcHue1ZK+tR2Qh0Bx2TK2A5WL3O1tmpHMyMto1JNb895KTJwQeUU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LKTkWN02; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DxMyeVzW; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LKTkWN02";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DxMyeVzW"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56OLkGh3005038;
	Fri, 25 Jul 2025 01:25:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=bzmSVbzz2zjFeC8n0A
	yquExYO+rLHlF1ylZUa3yZYXU=; b=LKTkWN02ltsdI+ISCz5cy9FbCpfuybkRu7
	DTPq//835lcUTjlpaywVCpX6EOCq1gGLFUs2zc8cRMIHMqIawMcrEB8S9yblG6Sl
	x4K+zaIuJ8AXTax0HYQHkfN3ozjYbOJnjC+J8HrGu/K3T966olrtFtQNsE2ySC/b
	cqGkjbbprGG4Ssobm4MfO9lZ6BuFDsJSZ06RHnVL7N61TOTVDAge9+inqDTlet45
	VWuqRXopVBHBkeIK/11zhX9n5hgAXMAkCQCjJL9OAgpaW5+DS8iFMQ7G8HZSuRU0
	trzleIHo9aD5r14STWJCh/U0imKNmYqQFyfYMBGqwoTjzreP9KgA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w1j061v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 01:25:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56P1CRvw038566;
	Fri, 25 Jul 2025 01:25:36 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2053.outbound.protection.outlook.com [40.107.244.53])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801tcjbvw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 01:25:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xmJRD4pPHuDF9qjLLnUblJrZZkWGohrn/J3sG/kMH4pYSAmedIgFUlGzJPwmys4woDLq0kAvK6Vm4PMGWoKf4n+py8R55d2e+BKUfxRlUy4mQOW7Tb4f/uDBp640UjyF84i2E4LH5kM+sQxjrLmJ2cAIZaq7Bm8+y6rNCa5QOwjair4e+eBAmXEvih3LQ7I7IRkJBjM5gy6h10utyWJLKk3p+UnbI2Bxa4wVjugX6XBAAO9zZvQhSfW6WsKVUlwZJ36Zdnvwb17UhoL74SU0HgUjgwLyL8uZoizJlBBm02KUrEfvmk3nHSqN2oAOjPMy4o6XC/xAkmC+ltsqh5cipg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bzmSVbzz2zjFeC8n0AyquExYO+rLHlF1ylZUa3yZYXU=;
 b=gm9t7Gm6GdFklSRvbhogBjjZkPyJiQpF89H3FpkWEGRa6A1zOKHTOS5oKBG8nYs5FI6Wuh+X6g6z/XRuHxSPYxAIt/Ezm2hzghkMsl0DtF6uVpmaKeYmGnBmMdGrOBlVE1wH7tvO/hoo6QAqVDN6glwEKoNL6X7qjQIqUrwpxO2zfxR8TQidRbJKU8OOb/OAbOmP0KIPxL+s9qTZJcRgvH4RLR+ch/dD51a2KyYvPIekTVFoLfHefsji3MwEGT3v5mfVUXj8U6t1fOyNShL80HZ3IYKfYAY27aBkZvOJKH5ZaqKgFENh65WrMhdp86bdRfiEouBg09xk/pOzn4oS3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bzmSVbzz2zjFeC8n0AyquExYO+rLHlF1ylZUa3yZYXU=;
 b=DxMyeVzWlvJ+kSaqzG1AqL9oqovOQXLXj1CgxJ8GJKNLbv8oJSsmLBLURQ8ihn8IKmGJh+mEmAeptFuFM26ueXLrtV62Nj+/ZUTClVaAkU01+Hp/yUv9101y5TqDSJe3lgvvjjkLa/fa9oYm+j2Ya28axqA9hj3QM5JDe/x+rAE=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH0PR10MB5067.namprd10.prod.outlook.com (2603:10b6:610:da::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.22; Fri, 25 Jul
 2025 01:25:34 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8964.021; Fri, 25 Jul 2025
 01:25:34 +0000
To: Seunghui Lee <sh043.lee@samsung.com>
Cc: alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, sdriver.sec@samsung.com
Subject: Re: [PATCH v2] ufs: core: Use link recovery when the h8 exit
 failure during runtime resume
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250717081213.6811-1-sh043.lee@samsung.com> (Seunghui Lee's
	message of "Thu, 17 Jul 2025 17:12:13 +0900")
Organization: Oracle Corporation
Message-ID: <yq1ms8trri4.fsf@ca-mkp.ca.oracle.com>
References: <CGME20250717081220epcas1p224952b344389e4967beb893297f1ae02@epcas1p2.samsung.com>
	<20250717081213.6811-1-sh043.lee@samsung.com>
Date: Thu, 24 Jul 2025 21:25:31 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH8P223CA0021.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:510:2db::18) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH0PR10MB5067:EE_
X-MS-Office365-Filtering-Correlation-Id: d39399f6-2c7b-423f-5023-08ddcb1a26cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Sj5Ry3wYbpU+KlsaK0eyoN3UUSZLIQjrC5vUnVPVlCYx56EvMUfJ3WJJKRW2?=
 =?us-ascii?Q?6VwDThZ1s+a+E7GnhdHOjHhJRId6Qe7Z2vCkGz8ZfUeE+clmxrfeCUgoIikq?=
 =?us-ascii?Q?OQAsQMrVZ7N2M5NFPNmwDplFUHzzMjWNupLdsgYC03zjIYgIbJ9XI8CUyTaC?=
 =?us-ascii?Q?h74xP/q1PjVKGStxX7bA80MJJiZgY/Ds0eXIEF+Vu5rAxWpI4N4mmsvqXtd3?=
 =?us-ascii?Q?8/n0zsTsGdl2ksgYHtOcLn9DoyKOj6c61+qLR9RhnXa/ZANJBvQhxaVvg85T?=
 =?us-ascii?Q?ZTy1x9Sj9gdTIw2T+MFA+7TkHgXbJw7KDweCmG9yA+1O8z++QK6fdIsqt7IM?=
 =?us-ascii?Q?hHYLJXrFKA3ljXszZXihpJ4pzP8Y0XnoZBOW1ltn8sxQZXwCBhWgYkgzKcIT?=
 =?us-ascii?Q?hgaHwlhRF1ZEU89gZ4FS7wHHqjaWjEJs+pNSWhYKf1nGiiTcM7l3I3Wk2xUV?=
 =?us-ascii?Q?zF7nPRZi9oKpv2iDhtU+syq0tRDyVAjKKvVwXE/g8B1eO3v+Hdyb4vh8L+YR?=
 =?us-ascii?Q?INfOWDyNSId3j0ik4ypIybUPeH8X3/OKcfQ8JtJ+P56N8TdcGexKGS8Nro3I?=
 =?us-ascii?Q?9CImSsmffDq8gF5fEo2iIx5dR6JbM2Ww1Jprpr2EKqqEXlOyPPyC94t3LC5A?=
 =?us-ascii?Q?DMTKhKhWTxv2616CYvpBc0hKpvTa+iTPHBjrSo6YByvXvHrfA7uxM6Jcx+iS?=
 =?us-ascii?Q?MIqnz+vrOsUmBsWwA2qUGTgSqkGUjDqBEE0rygzBefXp94Af62wVjatPHYnf?=
 =?us-ascii?Q?g77qqNk917zInk6U2AVP5iELVlkYP0oliRTn+JmKI7+yMyMmNXFYtHHDZeHm?=
 =?us-ascii?Q?wIu5uTAcj66NpN+edC9FNIP6/zlVJyjnsICox2vggR2cuJgU1UK1JaSZ7U8q?=
 =?us-ascii?Q?MkaKTlOp0+9Q3va/RnmfPYNmn0sHVT5Jvf1bMbheX6qvM82G6iOSrREMdWA0?=
 =?us-ascii?Q?EQThm6J0TRDuapHkLfYalk1CRzg7m+N2DgGM5lczhpCoMr9och7D5H+Q4vFx?=
 =?us-ascii?Q?lqFMgEfsG3+PoEr3UX81wgKoKWmHy2ZwAZ1XuSDFuvFhbJeHDoTD9ZLWhgb+?=
 =?us-ascii?Q?tfb0vwc4eomD0wDTlCs9JY4aE9kFenLlYOYCFKhN5HQUzV5dGZt3SsmHo7uX?=
 =?us-ascii?Q?BYskszXZoS6gx7yiheNNvq2fOmcmRr8er2xthVSV44CT2sAyGOtvBKcY6KwA?=
 =?us-ascii?Q?K5Zr7OL2xubDkOe8+JVQo0e/1uDIjsEVfiWi+UM2G4rc5bkZ+kMma4UFYrUz?=
 =?us-ascii?Q?epKpsyUkT57Y4igywGz4vaQrF+Ovp1j+rCGImzO5pKoNegGBrfna/YAMQYEI?=
 =?us-ascii?Q?QKHu/uC2kssx8TBXk2IvC9H5gEFV9dBU2cib2W/Apy3ItPIbsNrDnemue6ue?=
 =?us-ascii?Q?Ugq0fJlQ1dJoAsv9mRPDuF3s12XtD08yYpMj+6+qs75wbaAyMrpobhSz9kem?=
 =?us-ascii?Q?I4RH37WO08Y=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0gnNjpQf0AVahO5sZZBjN3c0PUNTgjGKuP4J+q+zuMmsCbb0FMEBAH5SHYg6?=
 =?us-ascii?Q?16/d/f44w1xHvgFvm600Ujh9hNNWfC5KBvXRCoa6Z1N0DZfM37GWp/ZH37V3?=
 =?us-ascii?Q?IADBuU9yGhgdpN6JXnoHyMDsTYBulBnHoHXSigT4ue+BOBH02Gif0pZHAerk?=
 =?us-ascii?Q?CuMTARAPdL5mNL1FG0nIFQWZYsbaKe0gnlkjDRAuP10/ZgxuMsL5XYhRWZu4?=
 =?us-ascii?Q?0ulMs2TBaIIJUkcbXazTpH6zSePbz0Z4wU79SqAb9KpfYdt8kPA/2fpObmdx?=
 =?us-ascii?Q?8LDtlcXNGpp+6oGbHVZxZX28EO0qHlUZ5i7pbdNhOBJxFcxlZxzY6oLbr+E8?=
 =?us-ascii?Q?jR6ProTBWSOQ0UgA9Xwx1muBOuDLIaDv8ETO4XsUdYooQU8uJXhrUZDsejtE?=
 =?us-ascii?Q?CCBlF100vaiFb9INkZhlmdyAwtL3Y13TP2KgpGXp1Pebl0ftQ/76vBkOHufb?=
 =?us-ascii?Q?PT6qyj7acITH2LQjpnzaPKhXGMDzF8tkPWwnqkhPPpWnFrO0db3wOzh1DA8e?=
 =?us-ascii?Q?EjeTDQy8VCN3Z1TTveU/s394Vq+ksaBqrDBefczfrtiu8Zme2no8JZYWwsEq?=
 =?us-ascii?Q?AsHmydL4WpXKbyWXHL1XJxuYVA2cWazg8OwiUoRV/yJnpmGjMMLM0w/GDTyZ?=
 =?us-ascii?Q?kWiO6f7D4YPHDulGOVc44NP7cTY16FhmFEuOx6Y3mqxQulXxUHAF0XsbUwC4?=
 =?us-ascii?Q?KRpbVX8jmvlLJW10gSJubekph7r6vWDgJmjmp0pa71aaQOd8FKKmZn9kjLCI?=
 =?us-ascii?Q?y39SF72HL9nBojUxuMLC4klNMRS1sgC/ST/Cfaa/q61TII4qx73Tz5aaE0SL?=
 =?us-ascii?Q?zPGhIYe60rO0JKMk3q2MlaKQVkQHMTCPaJ4NMVmU+s/VaCMcnhIC/TFMmSRf?=
 =?us-ascii?Q?hpIMutKz84gMvJ3sVUt1iecx9cPTvxJo7LrQMuH7LnrONqib1cnHb4BFdRWl?=
 =?us-ascii?Q?Mzf4+ku+WSaGF6YIEegL3qUyyras8NgPFI02a5RCCgKGwQ/5ATrTubJvluh5?=
 =?us-ascii?Q?ZzvrmfGUAOPnvfkTm1kWcJDXbVzpWnOaiKmx0ftQ6D8JeILHyBQ07y/LEt+P?=
 =?us-ascii?Q?n76+hzyKhJmxumnFeBT3bwIS2YXNZK2oPMqH0mVdOYQOd5c/nk0/5NnnZsjZ?=
 =?us-ascii?Q?pcQLqXbCRVP+YbHNaovmoqobnkvMVONlC+LAWCbIxkv0nfkMDCJD0hn6vYmy?=
 =?us-ascii?Q?tLGoFKcUeZe+KB6HIo2bSeq7HdeC3hMIUWYMmI14qTiPI00RppfUxmaeUNGn?=
 =?us-ascii?Q?bnp6az5wgq6F5CNno7+hh0R6xLXuGX7bbLcWoNhIy+gUhdCgefLLPXxor4OO?=
 =?us-ascii?Q?vutgYfNaxGqtDyIGU3F8vX5dIQpOxjZP53zLobPuGNVeMiax35rrKcG8lhvm?=
 =?us-ascii?Q?Fwb8vJ88ShtapRcvzCooA7deLr5bxitTWh6vxSNCGkMPYXh8D7mQZp5bZzqq?=
 =?us-ascii?Q?E8rFls67tqUgQNJRCkGxpyVo3LbphFOvBFsxIoEMCkYr7NN9sJRA1hAJ3+jI?=
 =?us-ascii?Q?JDWKrC2fpEzHC7u12U8nQjxbL1GwFd/NG6h2nlMNQE585dtZQa5Bij2Isqp8?=
 =?us-ascii?Q?YhhQv+06LDQ+oiqm2OEqKmAMgJb6uSeqmMbzvQ4moKgzShSWQ+22+hQ3sK7z?=
 =?us-ascii?Q?fA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Zf28D/MT1jvXZpNLqPD2LojZe1KAFrxr1z0osgSgsLixrQOssqlWeXFTwcfl7OBADhAzIOgNs1v/zYEC4+ia+6D5t9Cn+vvjGcmFFJSY21WiyehVG9ChVcv4UvLqDWqPFzUdGP8u51D7BqcEZfTIRoV+qhOYIJjDSoY1mvkHNmuCeDi3OnQb07qUHVjce4xJBc3Z7KgekWcXk4jGuEPOEllO6W+jTjoyuIidNgH5wKMPahk6vf6IZRO1TkBzMYvvHugR0lYgfK1viEVKCvjhJsLMcYtxXp2/C+4TFzRATj4JhD/idQdTlIYVvtF7y0A6bccFqBsOTc16JuFPHOocmTdMmwfHHt51C1cAuGzAP7CmNoBnneEV3Qt7sWBTmgBVrWvDIZzRuwsaCGyC5Dr78xPjqQA+hnLPycsAGlkbu7latUWi7ofsXq3/CCWokPhpyPXQTiz0xwR0MzLgWIMvtGyJYGKoMafIKHhS2GJifQxaVym3slPGJ6LnfEEfMnjCEwRPMRmbHCrr5NsbI8KuFZaw2BDH4890yVdqEJxHuHEGrVvyMkAfyq5gxgxdBeW3eGHTrUBplwiZ4eePXtEFih95WDl6zd1DQumt2WDaYPE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d39399f6-2c7b-423f-5023-08ddcb1a26cd
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 01:25:33.8264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y8TEoIYrC9gSMPIOyplkVtB8fM4JyZtURn8Pux6ahSjKNYGViSTaJrg9eGoTJ+Ret7hI3619wH/jJlo2UyveO35D8JyFo2FAgzR7Gv6O4HE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5067
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-24_06,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=681
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507250009
X-Authority-Analysis: v=2.4 cv=Jq7xrN4C c=1 sm=1 tr=0 ts=6882dd11 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=Gfz7f8dojFaKYbt26aAA:9 cc=ntf awl=host:12062
X-Proofpoint-GUID: ftz2-MafuQYwuYUtnXzAUgfo49MRu1_5
X-Proofpoint-ORIG-GUID: ftz2-MafuQYwuYUtnXzAUgfo49MRu1_5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDAxMCBTYWx0ZWRfX2DBGg4ZPEbSM
 wxdB8IlyDsoOkSWZF837qIdqvBCYwW8xtxXOhKX0xnVFNAYX6nvcM8l+1GMvSqLsVKZm0ugyYVS
 XzBLe6MInllLEX3fS/IYEkBa+jcz9HnwT/eA8k6Hdk1n/iPh65i16wZ1D+a2x49rGixEB+w2vct
 23kSnbb3LzypbbTo1PXn3yMiMfg7TilMVI2nPakO7x4BHA1AX6g/HfwzCInV9MOOB7ZaZl36J+e
 krfdQ3nvpjOoeAg3bBKThlx47hIHB3B7yghfzruh4dmK4qRfM9QLb6OjYjFsVEc41MAy6ig16LF
 I58FzFw2f9WNIGUGYpAiuzHwWhiUFg5YmEX+G4uvP6QF6hLSEmsp7KvexR3iUNjCFxsO0/duqx4
 N7l7bm+toB73uNMdGOlX4h57FvGQTnCCEcTg2eShAWuehKbeZFDi95X9EImAB7e6Kk4T7fE/


Seunghui,

> If the h8 exit fails during runtime resume process, the runtime thread
> enters runtime suspend immediately and the error handler operates at
> the same time. It becomes stuck and cannot be recovered through the
> error handler. To fix this, use link recovery instead of the error
> handler.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
