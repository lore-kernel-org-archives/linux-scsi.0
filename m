Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E2F340A47;
	Thu,  6 Nov 2025 18:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762453333; cv=fail; b=V6SBCNvW72zJ0PmKJNTyZJ2MWG5p9WaaXWiAT7CLY/bZ3hA5wMZZmZtiEwk6SICwTWnKmwwv9uK/FMjeteNfQFBVL789jRR692d37qKGjyDmzqII2UQlst39dC4KXRjXjH5mY1cRya3XQYGkCvmM4yQkKwSCrWcYpF3D2E1dYh8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762453333; c=relaxed/simple;
	bh=fQTyavOGYa0ibS8PcFCdF+P0efosRSFWgdCevQNGG3M=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=u79XJp9sKhctW9B+HAjFMra9gyLwSIDnrRyBSWAFTDN+fvl9xpnY1q0RigMGDdm7QySXckS2MRxVtXNAMfpIqlj+Q7xUyLMsbuOQ34xIPcX8GBWGjs+JCQaVasfxReTG6OBxh41jqZUlc8TXQoauVJTOj5XG8MoDCXP0S0ZGneQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nTr1mgrZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZCWh4V82; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nTr1mgrZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZCWh4V82"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6GoQl6017631;
	Thu, 6 Nov 2025 18:21:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=PcmqNPcke28+EFOkEo
	ltsoc0CL0S3+Yta0v89mEn5Vg=; b=nTr1mgrZyNSFt21c5pZ9VDSqRV5VO4mL/F
	PJS9EYxC27cWc9dVszTpX43ktcOGkxfK02GXeexi5AIRQsQcO1IG6xC5Qwybndfw
	djvwDXZ8nF28NsbV1uueUDl5KloxcuQRg4E5FUJLYc2P0tkJjOzCDi6cJuqD6c1a
	Efd3Qi7o+xRX2fOKx/YphdhIh6E1lKYEy06lJryOd6sARoSsDoFGLN8Yg8+CRXO5
	CP3gHoMx9F5L2NedJlMmrFo34NHevrCup1F4KKIcPyDmFyfyJj5q4LJ1QWGXQLeV
	tWiczgXOvf8rnJL2D2i/TUrY6bx6sot5d9V/2R5Hl6Ls3tXcnpyw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a8yhj87kv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 18:21:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6HaRV6010954;
	Thu, 6 Nov 2025 18:21:56 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010023.outbound.protection.outlook.com [52.101.56.23])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58ncs5dg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 18:21:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PL0sPSfrWCib8M7/d3aKbdDOXMoMblDMzzf7XNJ2LV3Xp/KdKoRr25EWGAZmvM/Uo38O3C5LuA5NMSmvrpYWKlXW4rw+wkEy4p36QhSoWBmk1gi9c+ocTi5X/D5wnXEIhMVQLNP8yIv9gKszVD5QTq+97gcxlO1fEOOXNDVZ822NDnn7gbN3tNhNKeRIgyY1KhqUIpzuip7JXddEbd5KZXQUpn2u75Mw14L9xM0P2y+Y5FCwqrft/FTn049fpx14IBJQNmAHrtVBg6kxfFtfghpMwZPbQWuujiBNI11WKRpoeYWVJkRA4ApiJirRP6BLqOoMx4MeHi2PesFaf2nU+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PcmqNPcke28+EFOkEoltsoc0CL0S3+Yta0v89mEn5Vg=;
 b=MDJdfGrJxGBZ6XdPmvgqYFR/Td4hxbQ05MFYDih+FDVtpmLhuXAStiztpKlHN8z9HQ0mwtvjRQCysTiD4s4fkRjXR2muda1tyIm3YweVfV9d/yJBLJ8V7ASRSzSJ4hG7ohLiHan53QnVRkKR7mh+hIDi0Liv+vrRk4MFDizpfIHrE3q2+R0ESuw3xF3l4hSS6dGze/5DVJaelTa4oZqGN3+sKR6cpw4ocK7rb9vBMavwHbtB+A3MFcAaQMFnnAr5k+MynvWKfqd482MEKOQi79tOgukyrZYmm6iITw1pde/ZS0zcpl7Kv6LH4trVjPcyCoNVll0xWpxFNwFAQ8i0Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PcmqNPcke28+EFOkEoltsoc0CL0S3+Yta0v89mEn5Vg=;
 b=ZCWh4V82aotDr6wF+O+X1y+DBlvVy11xwLxmsamp0I/Wc49AhF+1le3vb4oRUvxnpKycO6CsuaTNDRyWIsWvsUUTGUYBTQa28CmXsLniArrdKbXL1+0MsmW7wYiYWS3dRAtQM0gu5mT/47BDyLRKbmyMphMN1eEtNZUUd4K4tms=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH7PR10MB7106.namprd10.prod.outlook.com (2603:10b6:510:268::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Thu, 6 Nov
 2025 18:21:53 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9298.010; Thu, 6 Nov 2025
 18:21:53 +0000
To: Bean Huo <huobean@gmail.com>
Cc: avri.altman@wdc.com, avri.altman@sandisk.com, bvanassche@acm.org,
        alim.akhtar@samsung.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, can.guo@oss.qualcomm.com,
        ulf.hansson@linaro.org, beanhuo@micron.com, jens.wiklander@linaro.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/3] Add OP-TEE based RPMB driver for UFS devices
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <8de3c5c04fede7ef0b3a62cdbbec133b579430be.camel@gmail.com> (Bean
	Huo's message of "Thu, 06 Nov 2025 18:29:57 +0100")
Organization: Oracle Corporation
Message-ID: <yq18qgjm388.fsf@ca-mkp.ca.oracle.com>
References: <20251026212506.4136610-1-beanhuo@iokpp.de>
	<8de3c5c04fede7ef0b3a62cdbbec133b579430be.camel@gmail.com>
Date: Thu, 06 Nov 2025 13:21:50 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0029.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00::42) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH7PR10MB7106:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f9b00bb-3f87-442a-65ab-08de1d615c33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8NQc0VX+IteXlCY6JUbriCWOq3B9S/QpM/fvoVmG1FRl8r6zQOiaAqWMtVCA?=
 =?us-ascii?Q?H4D5pxmdAz9nWTbhB5kfk4x5eZLrX8GTjJm9zFRsDIn5eFUPTJLI6Z6zvulj?=
 =?us-ascii?Q?jfUJq6J47EKuxwCh3Pw/QVhHIJL7dR3hM+ypVkXYIV56mafWpgkoX/m6+AaP?=
 =?us-ascii?Q?/SkLfFaMnyzvOGIzzIbLATS6ShUfn/sy3Lixo0J0qvy+wl3GCo4QDGErxghM?=
 =?us-ascii?Q?G1tbdfZy8EQBrJQmj0ozeO10wXVspdfsoV83ZcQN5N2W6jvnSEtYya2/quJ9?=
 =?us-ascii?Q?bYQxqmejtnxJ/sGEPZ2AlokqeJMiPtA4t9Xrc8oX5lGhWXevVwT4aXJkgC5R?=
 =?us-ascii?Q?eifgqCHZzQkRn5696k35OksVc88XlYAjaOnnHpTPCak+k6mAa4z22PtgKvfb?=
 =?us-ascii?Q?ERiqiZZbX8IodywZL+F6f/dxEkMaciOlE/FVquwlsGfXM1mInZt7++0gdua3?=
 =?us-ascii?Q?SU9PHPG2E2Sj8InE6aJ4dnq+NRiXBO69XRBKGuEKdig16xlRKq9eVuUir9s/?=
 =?us-ascii?Q?Bo1UhFbiUSPj9MHwmpT92/DZhn2o2xKCpS5MrKeTce+OH4eVNGgnGwb9l6qL?=
 =?us-ascii?Q?QsNPssOGrZK39yvEyf0+1YhoxdFaoF7OCVM9PLu/quAi5P5yQS4rn3ykW0kb?=
 =?us-ascii?Q?Akg9u7aLHik3eD7j3MmFB/1IJ7tAWFbnmIJmF5zyvP7VKubEmWOXDuFLEOVq?=
 =?us-ascii?Q?P+cTirKODgH/7by9JKW9J6I0EE/Dzgs9dfoHVx/u3i9VzTlmgCfnb81u19aO?=
 =?us-ascii?Q?6cr0oCwszRAunJodZoayMrSZPhE/ZM4S7kmA5sjLBfbgfQI2nY8EJ8+3j8vK?=
 =?us-ascii?Q?MIs0Kxbtw/8MIYTt+cda9wBeLmURvzuLYJ0sVQ9PFWVi8wBcj/YnNuyoKaIR?=
 =?us-ascii?Q?DxStP/chWpcPjgHA7RPmyHVkHpq/C7kuYaPCO8RgZD+R+pRh4jYSVLlHivXk?=
 =?us-ascii?Q?/EjrR6qa3a/gKQDQKGy+rSKSCucd9sGM0mKmsfliPga9ZRg2ZJbZM1y+PdDq?=
 =?us-ascii?Q?r5cxNrrHwtE+465dTfa6p19A+X1jr6IBIu7VhDPMmtray0dx9nwN64vvQr0D?=
 =?us-ascii?Q?VqG4zVAjvGu5bSz0eYAcLSxQcIR8cBCqpOSmw0KZ/TmdwcOazJcmqh5rcZn2?=
 =?us-ascii?Q?Ctx0MJlHOnTnIZGLFlsShPvqZJ3AUwkXCF7RqjItxtX0OdYvLCoQ0z24U1CH?=
 =?us-ascii?Q?JZdNXfaSzf/+ZEPpBIai0jir0a5vYN/Sc0b92RiLR8/EdRzIsgG1mut0YwTk?=
 =?us-ascii?Q?LBuvlpVvMSJeD4uEvI5PjaOitF5cq456HfnhD8ptpUCWw2eXyXPhTJBu+snb?=
 =?us-ascii?Q?dkB+6XU7A4kTkrG2gKqfRysT4Itok8lx3COLUzAuDeOuUBmgqM4bGbpQyWlV?=
 =?us-ascii?Q?fUtlDh1Bys3sfA/dXuT+rwuTJeIuDkKUaCRke7uEBvySE+EH61p0PNe2hJuB?=
 =?us-ascii?Q?OIfLvn8HsgfriUAtQ4iCHfYIerCz3XCD?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?M3bahH8BqU148sW96jqcP2JOAnpGQDRxE71VzZOErFmIJs5P1xbomoQKoQLA?=
 =?us-ascii?Q?+35Mb/M+kEYxeP9KMr/OBKiY44ueOiRciQEm+YhT9I8hGiHAHmCYxV7yK4tv?=
 =?us-ascii?Q?4H2NGFvUB2CgpOtYILvICosf/qELyRsa+F0u0W32W6PFLxwnBNWC7KN2icra?=
 =?us-ascii?Q?Q5nWvBr3AXA+naFQW9FntiAYFS6vF2gyTHNPxnDrHgmHhyvGun3ENfnk/8yZ?=
 =?us-ascii?Q?dX25nwDYNYEO4PUR1hqWMthhYVKSQZHua7aIx7mmRs+xIigd2D6y5M24c14W?=
 =?us-ascii?Q?CwA0q52MbzaAcJGq0Q/nKy39XpH3YRgSkE/JMwRzE76hmiYg3H9aPiCVO8uo?=
 =?us-ascii?Q?ckEnvd82MQAfkT+feq6jBahMo8REjM+M2Gyap/KYktNYz5Mv+EoE5vE83GcZ?=
 =?us-ascii?Q?6leJYCL1kKVD2w/sxK05fH6c0QqbGsPqf79hdsm9WtD04VhjEIuThIjTBrA0?=
 =?us-ascii?Q?UHCMpzrgXAg25GT/KneLvtD7OzXLW+BXWD3GvruDs0S5Ssm19+DAe4K+Twl0?=
 =?us-ascii?Q?iiF1B8FG+FiaQOpl4K6dRsv+YIwyoWxbrPMeT15OYvuZi9C5HnVWTSqbza4K?=
 =?us-ascii?Q?susWij/SOcw8apRmHppoDcDMrHwhElBbq6EcRiSoY/PS29k6QotwAZ7BIgae?=
 =?us-ascii?Q?CNd1MZqE4KCFdmzDo2p1DhzR53lE7QJEdVYXIS0JH4dk2IEYo1VlMpdX5KHx?=
 =?us-ascii?Q?9Jo5NgTRZ5tLvo8YQAV9+GrewFTGIg0I7SnxR5F0vT9K47ea72Q0cMTa1U/L?=
 =?us-ascii?Q?S1+Gm1Smu4GuypsZgtJeRBB8dDQKLAylru3hrTY596zx+hqKnUYsIvN8gBk9?=
 =?us-ascii?Q?gftEAN16nwG2ABLaiQ/fQuOQLCLfVyVsQ/B5hPbsgHbFooa1kys6G/4ys9A/?=
 =?us-ascii?Q?VuuVEeGrm/R/W+Fe+/Ztgrvlwo0NqVbzdTLdeo+SLWCTfKSh7vSSXolGWSeK?=
 =?us-ascii?Q?LRGhP3T+MJ88a3UAzs8+b/MNYxgMOOq5G9sinnx9FNux6/hKoGUQwz6fieCy?=
 =?us-ascii?Q?7RkNIxMg9Kx5lGmYKQaook5Kh2srCEhkbZL6JYTWs2kFO+uItmJCgdSS/k7/?=
 =?us-ascii?Q?cS+1o0feFugpj7qewwYk9TCNFQagEO9i7oPQfjvMRf52P9BbFNWl1PmWtSwT?=
 =?us-ascii?Q?LSG3w6dpS7eQF6ND4+C1hPpd0hkOoSNdvVkcU4KyisYBT2Bm+IiqMhbLh8Lz?=
 =?us-ascii?Q?9gVMY8+foDVbKmPWbnpfIzKHEnZB3RnvpoW/SXsZ4ohh8+581LaGm0hvujPc?=
 =?us-ascii?Q?7E1VieBcHHaVWNONU2ueyNszVgeccGxkVw7aSCugZ81u19F9FPFwg7jFWy/W?=
 =?us-ascii?Q?62Snx5yeYWjuMmlw6Ep9Q8oytxMLpLAHfqvohL2jAFy32/QpiS+dM4Bs2nUL?=
 =?us-ascii?Q?+qv55w1MuH7oNU7qEVKhLFHTEktrwDlgqPfSZyLKLtqH37trYip5QX2IB3pa?=
 =?us-ascii?Q?o48gFJ02Wyx5rbPIdBCzm2DquWck9ZizSzk8FZOkuQjpA5OLS4QFAnzHLZnY?=
 =?us-ascii?Q?rNL9osALDRzSgqfv5obWzP7T5daUSUrCg1IsEGZvnVzDb1xvLmpE2pGtRpce?=
 =?us-ascii?Q?+9PaGZrfLgDwf8UdutMucp1qXEO4l63Ex1vRdF71p31MCa5iZ/eaRZRVbHYF?=
 =?us-ascii?Q?Sw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6jJB1PFmRJob7f2iJLxqxFGMxrDrkibMsqBPW5oDr3rVMYi8KLyeV/sQIheBVC4db+cvxsQPElLA56zV+nmcsrUSqxYUz5Qcj2CTHwmt/QJY10tCcPf9TLRpphIIAQTYGmFwZPya4KUOCGE+6D+kuV9Q59ZvgGawE0EcN2Ui66tr8Rnz0Xonx39wPvRnQU3Xsh5Zo4PihW7PMGwmoT6dcXOut/GwUdRAIfsBA8/zdfY8UTpOgOaKdvyoJF0WYbbL/cSGHICCB9Tu9SYdmsJAbA9/znaZtEwtvsPsF4Qor9PUPTWYvPNalUYwHJ3GgIxuTrU8wj8LMdkD+wNULAIkhYLXVr6k+lmvyjA95kWN3wqc1lNEHGIfthld3feiemzYrgOZ+w0071wMFacpFYtub9tMzrM1KvXTfg3nUWKikYxKc8+KRSq3EzhDovKNe9u1L0KPcYm+QHxzQbotTEoj2kAn93/nbTXIymzQt8LZVKW8t50HQLXkndbPYNKEgrwtSwFUGF3ZP6lpXEHRi/SZpZMRfpU7ZuFXnW+PUsWXz+d0x9ltB47z0PjuFbb9RuxHIj1IbQCc8hKJKr6+9reo5ZEN86LsE9ezWUWNUho7D0M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f9b00bb-3f87-442a-65ab-08de1d615c33
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 18:21:53.0480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XouKNFK8QPYFP6IjubxdpX+mpWYOZdR6N1pcfmo0iY+Rjfixw1+HXJGVuIN0jPJSP46HTRMsI/z2LdUolwsOB4xy1BTP1BfWU5Xr+KAI2n8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7106
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=777
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511060148
X-Proofpoint-ORIG-GUID: rPfex09b6gdp0PLYMKkNxx21COPsd_2s
X-Proofpoint-GUID: rPfex09b6gdp0PLYMKkNxx21COPsd_2s
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA2MDEzNSBTYWx0ZWRfX0sg6AKxbEMvd
 uUAGX/dL7Mv2CLepPWYGb/yUdDkFQ/dv1nwmzyp/Kj+OE71rNdFNEYejMn5cOpCWKW3RNcGVaIL
 BqPTwE1qM3SUSJEECcCFkA31vXft343mIIHxTpot8i9TVQbIycMY/fYpmnajZ9NdUjViMQ4hh8M
 jGQ98quFu/3q37aGi1VzqanwnOgpWRDV/irY51fCo87LbAGKEeXI6M2VPEeimBIyO0FM25jI2zD
 qBYFsM5JSnNiXBo9LORlXwcUKc+MF4c9T+tY22FM7D8BO123hVT3hZpswbtyzpPKRQV+5s4YwYY
 AP2vGeHUkE50mEJODIaw+Qw1KIcUu8ycSvF3utUas0PhoB9mlfichalijWYaXmXH40/GY73ZZzt
 QnCiIjy7oopwyuIU8FzU4t7z1TIybA==
X-Authority-Analysis: v=2.4 cv=Lr+fC3dc c=1 sm=1 tr=0 ts=690ce744 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=qDlM2RZHRZ__e7gkLacA:9
 a=cPQSjfK2_nFv0Q5t_7PE:22


Bean,

> Do you need me to rebase this patch series? I noticed you marked it as
> deferred

Yes, please.

-- 
Martin K. Petersen
