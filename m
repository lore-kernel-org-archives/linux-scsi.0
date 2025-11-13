Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDE23B186
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 02:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762999285; cv=fail; b=syc3sV686Dn4xr7tLJJ4i733LL1jdfxECrgS8oxaCQzTA2KCYfA3+/PKan4XyLjosHoFliHPmeamLxVlyEeqsNIdE0C73kMgHbsxL9WS/geNQq1I/WXjZ3ywxi4DY71EZanpysruVYSHyxKuDtnCa+bbE3iEO3BZ2WMVr43K5Dw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762999285; c=relaxed/simple;
	bh=ZNpTzN4W6fU76M0UU7r05A+yaoagWb7qofqJhaksqW8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=bzU9qETgK25LjRCweiB0VWSbFPhNiQ/GkV9rqltyhWsMP8NA9gsyZ9ddrlnRkgMux1iphJQVcZ9iE9/eck/erh0d5sRXt+ysto7P+JqmeHq+7+iuqdCHY2queUX5c07kfVzKqjZhkO94hMGen27fs80J23Dnw6bl7Xge1WilaQo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cc4fPxSw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dyBIMJog; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cc4fPxSw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dyBIMJog"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD1gO3k022542;
	Thu, 13 Nov 2025 02:01:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=RhhjYiYSjwbN2ALY7X
	YZZBLuDQUXfYoz8qMDOveETmo=; b=cc4fPxSwpvp5d7frVjJbLkwppchmcvzRd0
	UHbsMt8Y/xUZ0YFGhxgWsTF22HwcRAXTPAZhS0fTj+jmrzTeZdWH6NOKUg2Jmdln
	olFLmNhmtETsAWW5tOfWHktqf5qmlrhRYkTteop+F/KCyufy3Q9dunPmNY3Qeo7R
	/Do5ppO9J7oLj5NNgPCt4bbDjbqrjw/A2shWZrpyRNbVT2igzwgFOUPngIIVzkAa
	kXVx4b5jbnYVevszwGS+ZsSUbhKcldhmCHzl+wdtIRip1cL1Yhr2Y5yWQkqWToc7
	K0qkT+I1HE0Ir9X4ddIEgsysYO1wemu1cDlfadzTdh2lUl0hAMKg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acxpngufm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 02:01:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD0wWla032409;
	Thu, 13 Nov 2025 02:01:11 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010039.outbound.protection.outlook.com [52.101.61.39])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9van8mj4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 02:01:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DRYQw02eq8JaFZ3eFk5JTyyU4sWiwYO5tFaSxXMZKK0RC1WimE4cvchY2YVwSFNjaf5lDnbKx5LAKr0fopEUnAtACGoLr5sm+7TO5dil/cUwNHoVRYmZUyb89SrYEMFHfIdD8+mW82lg6edO91rgWSnKyod2Qhojtpm9QixtsO9erW06CtsFjaWKelsHIXt9c09OFT6TGNp7QeGCumf5lItq3uGr/9rFWhnzmSm4BH5BcPcGJStqqC3eHzyRebCWIuATt7jF1qpoj/6yeXwNeHEKF5OLPui50Gom1tL/W8fUHQmxgaaanucAB3igzzIxpPmz1Mk9KRxvP01P8dNONw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RhhjYiYSjwbN2ALY7XYZZBLuDQUXfYoz8qMDOveETmo=;
 b=SGPTcrfYHix93qc0u4vPfwp6u4qwXMTQp852LR1oq7msVGbPENH7X9GwJlIbKJS48/3pus/C4Gc9Xu7m2dAEHoaGDlMKhTklfAPYzFQ5598oLE4wGEif00uhshUaD4ooHyCN6aL3jwLfVrPhpWu4Bw2kpqV4h/GyoOnelTeNiUv9ybe2UUjFIQGhTdxZwMf7C8b3dVVMa4E+rmu5uBKGnukx+VVu4zOFQXAjNGtkUJbtmQf3lgQJyd8e64F14idbd82xNhRdjr4m1gtAY1E4hCcqp++7XieyC22XIppoHIJoqfpzUkk8BbL4CPgpMucD/Ciaki57CuimjZvpQEpA4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RhhjYiYSjwbN2ALY7XYZZBLuDQUXfYoz8qMDOveETmo=;
 b=dyBIMJog7FKtmpYj7sMYwYFrDByVaDnMPZRM22wAIJIahEviJRz1DmSQhLwvlOZAlUrehGcPEnHK/xEgXGhyDVkEgEqCUWXvJbVbS22kzafS5Er+v7fDkdZw160YuO1eT4d6masSKdSQ6Q8w0kV/R755Z6V0wW/EcLlEjdEG+hs=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS0PR10MB8055.namprd10.prod.outlook.com (2603:10b6:8:1fc::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Thu, 13 Nov
 2025 02:01:08 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 02:01:08 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Chaitanya Kulkarni <kch@nvidia.com>,
        Damien
 Le Moal <dlemoal@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe
 <axboe@kernel.dk>
Subject: Re: [PATCH] blk-zoned: Document disk_zone_wplug_schedule_bio_work()
 locking
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251112182421.3047074-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Wed, 12 Nov 2025 10:24:21 -0800")
Organization: Oracle Corporation
Message-ID: <yq17bvuelnr.fsf@ca-mkp.ca.oracle.com>
References: <20251112182421.3047074-1-bvanassche@acm.org>
Date: Wed, 12 Nov 2025 21:01:06 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0166.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:f::9) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS0PR10MB8055:EE_
X-MS-Office365-Filtering-Correlation-Id: 36a50d6a-5005-4af9-d18c-08de2258832d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?12VWy4XKwB6mBPcBfJZXm4bNcltzNgiSNgbrAyqHIHFzfHP82i2VzJRJSso3?=
 =?us-ascii?Q?b0D8lwlO7nRzKYYuUuad2osercF6M24AulJ8Zo90KM+WjxTK2CGrbW7QOG9T?=
 =?us-ascii?Q?LOzoLaX2/RZRhPCTRp7IK+KfuUGgiDJBRScVt8u4hWEQt1c2sgq115f72D/O?=
 =?us-ascii?Q?l6G5GqSrVqvrVljU7QuXO6/gtZQebHehr2KChHW+rKjR9ByqOClIe+QpUILz?=
 =?us-ascii?Q?4manSOW2/iSRif5ZejMpcspXFPkQ9n/ZoGDAwFTF9Wta/3DanfYGKUGf9N7N?=
 =?us-ascii?Q?8RvmSUNgkV7+akB3sOurZeGI3wuTgLX6m31C10SjIrgPTNHotR6osXOnonCl?=
 =?us-ascii?Q?Ze6wnlzdEOC1dS3kWiAfDt6rFi/+z6Pu6OQdAHDHzzQX6c/EGgUYqw5dVdLq?=
 =?us-ascii?Q?mQAOVZ2LDGt3JzG73xdRFZDjYL37xt/sPo2RYcSBzdUZ2tiIisbJjtmAEAiX?=
 =?us-ascii?Q?szAA7KUYh+HDdhXRtqvLV5AbUn8xrf70JENqbU3jQBHLrfV3j158ewa6bOgJ?=
 =?us-ascii?Q?QYIuc8s9Rn1Eom7sLD4ARJtNoSPXljsSfb1nNaxetN0vHDK6nVQU1PkDYpW1?=
 =?us-ascii?Q?U4FYML70Ek7ub3uYUledQahlQ1OHxmjKfD+JqqnwVvFSEa99G6UhOZSP9tJZ?=
 =?us-ascii?Q?gLfEp7iRc86C02eqj0VsqnDrfDKSr94X5KEjl1SuRYNwLvT+Bj0HVW4p21wP?=
 =?us-ascii?Q?nFg/DOipF2GGKBocMc3aOtpCvS6IUkWmnshwEW9Br//we6Nqp1J7WsNBWX80?=
 =?us-ascii?Q?3ad+6af8D/OnuRKz5pydVZhDdjPHRsrrGGKW/fSceiNYS4Ll9nQPOal3gnI/?=
 =?us-ascii?Q?Cs2cb7MXfybDXarKp2OVsWxjsjnR+GMRMfHFCmHHI27jDDRZjEyGomQSijD/?=
 =?us-ascii?Q?SqyYmX/NqB6jTU2qqFVzAmaTWH+ofVG4sNtZ86cMSNZB6P78pqwekDIMuPr3?=
 =?us-ascii?Q?8Q6ro3Jn3S00AeFnnjFLz/i01P4EebdXnIn2kKUmAAsetMp3NXQn4TM7jqSr?=
 =?us-ascii?Q?2YAzo1f9lDJF4kIgB8hggINuZOYe/urPbXVlNHwg3+dLZ+6woidoiJDrMVUS?=
 =?us-ascii?Q?JG8+8boGx90BjTVFjL0mTLr4vL6jtJIy6RuQm1mZrq5xHRs64bR79ppaX+F/?=
 =?us-ascii?Q?uyUOLioPe9pNs9c2kTYPEyzaahlf/VY0eSr0UMYlaKbVi/n+CxKcaOFr/PXL?=
 =?us-ascii?Q?Nv9WKmOgF7jCX7a6+wzXAYTnwnj93S5xDus03kElsLOU/C6iez7k4miB2GH7?=
 =?us-ascii?Q?xmI387hnFe71sn4CvDalJaAdDuZGDc9FdRz0BNW4vQO04IUi9svaCnVlC0SZ?=
 =?us-ascii?Q?Bhm3G38GOPP6bQ/iRqqbCxFEfaLeZ/jy60qfreYM2xXwKURXM3crAzoPnNHB?=
 =?us-ascii?Q?MnpYfgf57Es3wVaspEjRZIZhgc1I4TN53XBvYhJ7jlN0b3+RRcqV7n8XgXjt?=
 =?us-ascii?Q?HKo+ozy2k6EHgNl5c0VZPIlx2e7ri3GP?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2XNWeAhhpKQ8pFN7k5R5N1fc8Xsz/93KgncKWMqEgTazPhThfAbWqAZhNlKe?=
 =?us-ascii?Q?kkMeZiUUu4upMr9Qd7kz8/ANGjd6mbz+2pGy4suC5raiYChg5B6qc0v8Bdxx?=
 =?us-ascii?Q?yuc82crUgN+E/sW/ZxaCYTZD1t8YUdmAZksJW06vxVkIkRvTnYc3Ak6CBAVn?=
 =?us-ascii?Q?OIycFHwzzI4tGwsdUdjyU2fGQmskwBN8RAF7T6zDB/rTf/bbNPYMuldJtkyx?=
 =?us-ascii?Q?UxbQAWTZRa69gT6c1aiBLk933YLvDB+rMo2YFvw4n6bAU0WJzX7GyuHNFjK8?=
 =?us-ascii?Q?nGJsJIC7QNT56Lyy8zdv0GkNnkiGBs+CcleeoipiIBpKmKIpbvz+iypE97J6?=
 =?us-ascii?Q?w6prGlddjDSnYyXiKC8G1z/AeuWC8bhncVveXZ4JBFHmq51cvibDpbt0UdOn?=
 =?us-ascii?Q?bV4b0yJ5lRPbAkgVx7ibFzZ6RYgdGPs+1eT01ABEu72Kw7yi1yoWAH42J/mu?=
 =?us-ascii?Q?nd3AlldtJI0/K/iI+0gecIhlSP4ZFZPIiiEONak34+DbnUvwEkxaeFxgdTj/?=
 =?us-ascii?Q?VzvZxORXayFmp7HKXktye9gUiIA9c3FNIWZs9gaNMjv/JEplUA33iedzN0Ia?=
 =?us-ascii?Q?PH01TY7JW8iTrbmLLzRp0HvP4iSPFPGvJPb32FHgfu05oEk99zY5EGNAzWGR?=
 =?us-ascii?Q?c/ckvVSuxxL5oV5GkoToBFvdlWOPdNfjsLYUX30gfstJi+Zmw0bNNOYQYTpD?=
 =?us-ascii?Q?js5u1tluGopx1fO/A2x5kGdB4zYmzzHzsDOeMCaM13BUGZ5YYDrbZiUEn9m3?=
 =?us-ascii?Q?oDDGQLfIwaz7buCkNLk73qpL9e57AF6TuqgE2ZMnriP6czGM+9qKrJVRDJaR?=
 =?us-ascii?Q?DrAIgq3cw17LsRhTu28UvmL7Z4i4SRtWW7019EqdrkqlOdQmax25JF/d9lkt?=
 =?us-ascii?Q?jS1AYO3/alOxukP17gQ4m211sS6uCMWn6GYQmX1Ev2lFUU2gq88tcraNIy15?=
 =?us-ascii?Q?Gu6QPyxH2tFErtmY+T79jZykUGiCQiwDHzj2aj334e3FCEh7e6h3XQqEn+kZ?=
 =?us-ascii?Q?zXnhOR2XplWQsgrlhT0uN1QLxNRpRumyG6SS+1MVNsopET65MEb1Hu/hKAUz?=
 =?us-ascii?Q?qo5nj2lw4PRse6ULogfJWYZkcU7YTvNOtydoRFh3YhZ7QjEQNH+EpyIIJGnk?=
 =?us-ascii?Q?R8ChUh6mY81QR5m+DlJiBJefx5XEAS/4n8EyjeIi0biqyvU4XdjQdHXXq+sq?=
 =?us-ascii?Q?cnAWycQxhiaZ+SWvSzUZuaQvMTdmk+zq1QeTLhZYz+4EipIltcDJEEdkK9PP?=
 =?us-ascii?Q?qASLyQe0yE68uWtQ4vJT7UaH8bQyXmwFe4gctzcsDqtLogIySsVqNiVo8Mbt?=
 =?us-ascii?Q?vdF6egXBd7PN6iliJlVNB1yI1UGLeSPy8SqnoldSg5M6/0TNv+AJ0Ucc24im?=
 =?us-ascii?Q?8ijPnnfp09p8JzH5PINSvAIZUri06Io3jxEbS6S0b/RrWzx6qRSxarGY/VYW?=
 =?us-ascii?Q?QQXu9/QQH8GCl23QNFgiX+qf38/Ak6BynKarxwMvghvWAx9nRP6O386v9Fk7?=
 =?us-ascii?Q?PYSSyEeGX7vu29bMZlzoM3YW7ME38Be1KQS3BSD+Xwr0B72xzfUki8jEuoR5?=
 =?us-ascii?Q?E7XiGsdc5q5XmjKN9ULKPLxjPVAF/5rkuJ8qf7+AnRo+4/UBHicqXVQRV4p6?=
 =?us-ascii?Q?mg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fgLzPAQnNGtlpRrXaV3lONaFlElhsJLsy8z4FvoEiz/odrdVyYczdUqDrcUEVyLwkt4ugGauQs/tkPWqYXgrPRUYBAAPlIZ566G+q5m7EWY2jV+wuf0AWMP1/C/OnFUNx6PQFffp1lKHHEzxyapDma27DDYJzSGcyhxwRqel2zF/x7knZMixiUjaJNbG8c8NaOBEVmFGzMxPYsjrS19JGVt2gYfOiOVRG26ors7WtcXCF0qcSdJQxdEjSUpcYva/ziKIgztl48sDNh6rzPk7h0KqfBuIs4s59EC9rGaJByWNwHxH8zeS1eIH8OlDVVjwjsx698BsqIIEuoEtPHl+YMwgx7RvHwQbAHBlMNzxFNXlWML3LlhqZVe4eAWUEx7k0J54QN+XrjScRnModMopdAlPajPZLCGm98hHQ1yITSoxAYCmgwGVs20xbIUL9y/CQD0TXUNWJHCR34Boc0juj9/Xvq2s1L2ipjRTibyCoJ7wrtOwBmEVfnCWA9Dc7fyRAHKb0fxqWsqPw26iOxg7aVFNdGVsizUtJeXCed1iJ/Nr9xJeLZTd9gPi38DqqXyyjXd6uKDMbsOlhkfLo8o6GKUgNsH5NWTzp771VXRl5Rs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36a50d6a-5005-4af9-d18c-08de2258832d
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 02:01:08.7644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iU00DQhSaYmazQ+BIzve1zvHMZZncWw0w1alA7e/5eaI2ZAFNKHc6sLOG26BTfIT1VBykF3KKstjz3V0ylSi6J5a6BgXKDbFQP+8V7vdP4M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8055
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-12_06,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511130011
X-Authority-Analysis: v=2.4 cv=Criys34D c=1 sm=1 tr=0 ts=69153be7 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=kKZJwrs0N8TAQP8QWM4A:9 a=MTAcVbZMd_8A:10 a=ZXulRonScM0A:10 cc=ntf
 awl=host:12100
X-Proofpoint-GUID: IbUtMEscvwXE22Ewv1w8KhMBkDxSl21M
X-Proofpoint-ORIG-GUID: IbUtMEscvwXE22Ewv1w8KhMBkDxSl21M
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDE0MSBTYWx0ZWRfX1qx8mOsmRy3I
 dyKvbAg61SpK1VaX1qTsZYXdwuL/UTBgvKGzg4bhAYntmRn2StTbfAhvOtb5IGtJkk6IMW06O6j
 jX6dP1Kb9gFRBExyYRh+5OVEFwPXhSPEm/DQXHHJ53HMcqhWu/kFclzn6DDb40CAOHREd/Y0jzT
 Y8+ZoZ4QYhbBQuEda9wH6wM5Cx5hvJkuDnF76Ifn+ubhIedlDC1p5UXOPKFIhS5CK3rhbj14mtd
 SCOorJBwWFdfzQRVwzUxOaqdgYK0IlUwZbi6vMRoLH/sIYNvittv8fXwlgqlqbQAOhfXn7RKmwM
 Ooycyaok1T8LzV7i61V6ly/CfBCl4CJ7iYor6x0b/4mD4EtTxDyvxLBkTQgQ8pFw6bqsxfNw5xI
 aXVa9xJsMmjNa+08FX9zR6byEkEAid3hiy4/jl9txfE5j0ccIkg=


Bart,

> Document that all callers hold this lock because the code in
> disk_zone_wplug_schedule_bio_work() depends on this.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen
