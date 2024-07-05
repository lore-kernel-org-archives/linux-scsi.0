Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504E4F9C9
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jul 2024 03:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720149573; cv=fail; b=WzEu2ks1lJzsHiy+XaulBAVRgguVllPro5Zfk5TwoMMqk20ctlvE17s9I2OwE1ucee0PMJ1rC3g1uyNwsk+5WbeWmggMR7rUc2DYKlhcQ+kGItT+B7FeKCaC/c08WQW4EySZehXxfF2E7LPoFp+Iar9nkXLda9dvORzD5LDET1g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720149573; c=relaxed/simple;
	bh=yatQ9NVozb3kpA9qcMNW7AK1xMNEGgNX3Ldaz40bbJc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=TKDJzx7xGkekScNJpcpusYHke+Lje4poiZmkwXDv/xd0WHufLk1O5eY5p1Lar2pfNiXCRHuhZGQG+zclhlfLxvySI261FJ8g3V7Nk9oPUa6qgePwNfrgV+zu5F0FKNc9IVuCHmyRmkh66QEu2l52iFDuylhRzeYZ3jiUuWq78Aw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gEGVgKZb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=M+w7NHPX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gEGVgKZb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="M+w7NHPX"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4651tmV0007892;
	Fri, 5 Jul 2024 03:19:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=vy17VE8XxwVsxJ
	s7dB1XUyz1PAKHm8J1dOepfkonXxI=; b=gEGVgKZbqw0LnnG6c00H80mFymcL4t
	hzHbBIOeQCOryJzJA0UgULEc/l/5GNnWnE4IGkZNOw/LhyD5WxXiQHFd4aFueLbs
	Ri8WvlyRSVXUU7Y1q0lFzqw1d5C8TQzFArPu5gY9tzAVdx1K6hRfhqgH3K8muNyG
	l3b/bb0NQj2yv3e+wELxMgRRWmZWTAhBLBJKig6k0jUzN7mTWbgfiR6zU7jU7Q47
	wrJ8+ZHqFKyrRYaCYUT9hbkro8xOvY/1+pl8o4J7kzatgKjucz7POudoWO/ysEuW
	5/zvC0msYK8ZQZx0V2BqeMkuz6FcTP3/jnrLtceYIIM8NvZs5WP6ryVw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4029233185-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Jul 2024 03:19:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4650Naap035679;
	Fri, 5 Jul 2024 03:19:27 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4028qancd8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Jul 2024 03:19:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iCCU+c4PzcSVMCgki9FBKTAsQybF2m7BayI6SNOKXQiIOuad+g5gnTWU2D4w2uGg02JeKPjNY3ChW8nJukkk9x2xTnb0wRXezjRlJvRX9WxW79TyPQ1zJoveE5gB7qFfbg1VWfIeeyE2AAt4APVZmmmKjmyBpQXSkt48N/U4U3Je8O4U8KlC7YvPeodOOHoXThm/YBRjlTaL4ABVf5FM2MCV1x4EY0I8ibHLteQ73IpPr1HtUqvrkNX2fC7gcdDc0lQJcZ3mWb7CpW06UPnNLMjffW6gU/xPr4g8qbHZnjFBhCQ7JRwmu9HdFK1cQA27IyXII9yiNvmzpOBY01YceQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vy17VE8XxwVsxJs7dB1XUyz1PAKHm8J1dOepfkonXxI=;
 b=F0Voed39Frmoe/gSOMHC1xFmbv/mq1n8jMW9a2JzB3C7Z+MiSK4GUib6LOnHX72Xx9kvgFxhBThgFvC2Xf276t/cgT/uzTcQht48tB/P2oh9sM3uvEz1r5t4P/e/d0OT5TtvQzD2QxAWcOs4LEjDubpJ09Y/MHfPIqoNACZjxiCw9ft/n6TItsjEpf3xfdMoNA7w+rd5pcnWzNU0HoTYoDRQhHt0SXlXvZhE9lJFM/A1zfgf0IO2g2DCC1baYvbdX+Z+BDedfYfIvbTTgZS/32IZTgeIw3TKRtOz/GwcpoKK8JDYIthN7oFH4bcSu2MCsdL1AVyhPyz/PFIcoFJV5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vy17VE8XxwVsxJs7dB1XUyz1PAKHm8J1dOepfkonXxI=;
 b=M+w7NHPX37BWOeFlO6Z0EDdqRWu5bNIDFl1VqIBQwrIPPbJNRcqry414GgHaEQQ7ML31vm8aKFs76J3+OLa45sTVMo+THvVQpHT4JRwSoJUhuYbqAASbVKOQnrxzdW1Kc90Qu6g46aReJgdkJ37LGhnoDiuPEjXXwJmK+YC0yCQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BY5PR10MB4146.namprd10.prod.outlook.com (2603:10b6:a03:20d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.25; Fri, 5 Jul
 2024 03:19:25 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7719.029; Fri, 5 Jul 2024
 03:19:24 +0000
To: Max =?utf-8?Q?Zettlmei=C3=9Fl?= <max@zettlmeissl.de>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: Oops (nullpointer dereference) in SCSI subsystem
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <CACjvM=dA7MqfAC6_fiWv4LvmN8mNPnNG_YXoKnEz6t0vzyRkSw@mail.gmail.com>
	("Max =?utf-8?Q?Zettlmei=C3=9Fl=22's?= message of "Tue, 2 Jul 2024 03:44:21
 +0200")
Organization: Oracle Corporation
Message-ID: <yq1r0c8a65c.fsf@ca-mkp.ca.oracle.com>
References: <Zi5YTR98mKEsPqQQ@zettlmeissl.de>
	<CACjvM=dA7MqfAC6_fiWv4LvmN8mNPnNG_YXoKnEz6t0vzyRkSw@mail.gmail.com>
Date: Thu, 04 Jul 2024 23:19:22 -0400
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0015.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BY5PR10MB4146:EE_
X-MS-Office365-Filtering-Correlation-Id: 68704cfc-43d9-4655-a83f-08dc9ca14543
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?KYleDfYGCafgE9ZjQCohAC3nYw0x6YAtlIxMoJ0q2ujdCkPFFBowsxRW95mE?=
 =?us-ascii?Q?Mmo/0uhw2jtDPUomtxgeWz34RmXzXM47BIQ0mpShx9EcBkrv9liGlEAr8kXy?=
 =?us-ascii?Q?DKFAwMvPQk+w2ce2gFOtZ32utv8BqFM8Daq2YiHB9nKKjgzw55oIqwoj+ZKo?=
 =?us-ascii?Q?lRGDWgqAM4iGzNWfvV+Ud6oUnUSi/3NkmybEO2rTXiVSIhIVzS+2ShLWSHMy?=
 =?us-ascii?Q?pYt8dzhhqRHVanOFnw1vYA24bcB/mZ587GzLrS60zsLSK2DQqyTnCyrDGcth?=
 =?us-ascii?Q?txZBc6UXf20tNyQTBA5ff1gi+lXQkAUwQH3UQT6nqcCsVlgNNkBVEEgVFakR?=
 =?us-ascii?Q?WSJffHMV2FaZUSdl2kS5KrbMA/Zj+5H9Y/MVA7XDepop7m1DIPUSuWCBDxDZ?=
 =?us-ascii?Q?QqAkPEzpIlOFCuCnq0IRV9eMOfrRO54kS62ZdWz7/GiJ515Jyo/kHq7sWKwY?=
 =?us-ascii?Q?Tmr7lKOqZcr2ex4MCr0uiSb2DT5E83Ww+5JZiezBS6FVRpZLSPOetFLU6HBm?=
 =?us-ascii?Q?e0+PGGs/yMyfOaEOJ4ObHTOzzcOptXPVIicYcz7VAJHakB8mzWpYY5xwYVJA?=
 =?us-ascii?Q?nrifCUnY8SLEBXBeQfIMTOK2S1jne8wz5E9X8nuXs3E5P3ivrRYexaTf7we4?=
 =?us-ascii?Q?Px1uzvMkmAdmysryZEz3bi6zzDrNIe5lmgENn0Npu7SNqsykLNYVMg/y/3n3?=
 =?us-ascii?Q?2VRaoO518DymN0YeGdqGmwoNoeS7iA7is0tehnDC2hU+ujeyajyXoRDTjUH2?=
 =?us-ascii?Q?u7hd9D3ExGYqnuBJIxBWdcd5UsWeqwvsjX9oWuaiYortNZhF19GH+lSjx3WA?=
 =?us-ascii?Q?Z1lB+IsdWnIGeSISMsg4HUlxnRU9VVCOflrjfVtSFaCYrpfzXdBsKdP93ago?=
 =?us-ascii?Q?ACPhPvXsGFKHRcliAuJ6bmlURaCtCTI5bhEjxH8G8oyQaDFIEvBebcsuMSTO?=
 =?us-ascii?Q?5po6aF9gcEC3DDLxbDCN+uj0w3KIgbKgkfSe+GjQ5L9TuMC971fbJMcZdj3F?=
 =?us-ascii?Q?8Ext6fSzTuMFxeZtWPOrURuQ1xCI1hldFiQeXxrySYjwfDn/c2y71AkE9q1e?=
 =?us-ascii?Q?FfkoFBEhHfZRhe3oU0Ceux0mtw3MgvTG1ETpxeTtpstHYTPhf5Ke/zWGl89o?=
 =?us-ascii?Q?pfT6GlO5KGf/clEnWJIs/28xWP1iAzuuoGxsWcLD7KWyNw7z639BzIql9PXN?=
 =?us-ascii?Q?II282lwEZVM/LT6dBiZTGv5fensS6CF/K7N3z6VEldAaSia8ixBjJzDmKt+m?=
 =?us-ascii?Q?HO7LIiuywFv7Ev93bCR6dtnKuR8gtOTUgA8jxtt1rshqXXF3cEfRSRAuHZwG?=
 =?us-ascii?Q?N9sEDfC1kiM1YTWNjNANTj0101HUcpR3muXUVEf1sTg/Zg=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?XICM5/F/Pj7TspfmD0Cc/iHtFaWWe9sV25AIiKBm+ZSymsRoSLTRbNhvrkiA?=
 =?us-ascii?Q?wXZ49aBgFevsA3g0ZS7ILEU2IdkkHGqSj/kBA82Aqx3ELces+JsvKWgNqqSD?=
 =?us-ascii?Q?aYoIel4UG4Hw1dhPovEkIwTCXUg+89mr0PtKyNKSqGX50dj/j64rEegT7EVa?=
 =?us-ascii?Q?bViAKAgq/G/IpdM+pqlmgCnEFoA8yp6MFFIdduHx4NFGzEUiIzddlcM4LFOw?=
 =?us-ascii?Q?RZaTfqt1kuwVBrfJ3cvnOe8btYiUiADu+KrzEervD8t3PtBIVYVqQ4kxDX+N?=
 =?us-ascii?Q?X57Gg7kiIWdC7Tgp6V4i9bi3mk8cXFXZbA9HYHaS+SkEq8Gm3T+w09wfTtMd?=
 =?us-ascii?Q?M0arBnzXyHE9ol52AjwkNbOWG+qX1XSH4pM0XHQT9W+WNPlA40oTWBv9RtLm?=
 =?us-ascii?Q?Du+tESgf5X5ty6+lztsmq94TPAggBwAtSDqRouh5d4EUtmjbavVQwGIsYyNw?=
 =?us-ascii?Q?pDSFIAcQmtpAYo1Bo2aBx3BREz4uEDeWc8N1i6njEbg0R8q0goEVcHKcG4/G?=
 =?us-ascii?Q?+gT5OB65gexZkszRF/e15Bj78vIBhw19wvIj0VFfFODqcGUaqY+UrZtmfKcp?=
 =?us-ascii?Q?9soOpQWsc79Wcx1r16xQ1vI4hKnxHLQqcKtwrO9kXcNoIt9NpjfrcLLlb7+S?=
 =?us-ascii?Q?rwZybH+Cajj0OejLol1TZYYaGmbNJuWmxoH4Wt8CTGZpLE9zRrLyylrMq3A0?=
 =?us-ascii?Q?Elxg7pD19vbLPRZM1z5otLvuRqiDzsiYt//Zs+fWK+jge7oLjWaQuI0Adl5R?=
 =?us-ascii?Q?jP2Ld1iIO7RTB4mPKNQd6q3xQoCseFokES2Sj56urPinxn8oXmPOIRkVxhzv?=
 =?us-ascii?Q?0sxjIuhBu/bN10jWYjgLoy/QJEq8IUk5fvC/htFiW754B5qxPPRBiX0Vld5a?=
 =?us-ascii?Q?tkGQsiLqjKhn7YV0zHYGzRysX+7hnTF2/jPj4rTNqfYFZ+FV5gGbwbnJnhpy?=
 =?us-ascii?Q?6JvPuYjYpW4U4Qi9dg0Yn0+7YlTmU80fFUKJHQ4Z6lF7kRyB1F3g0bSLJdXf?=
 =?us-ascii?Q?6yTJrc0fmhSgyrezkboarwKO6nU0ZLHLgbhU2XiQckZ7MOFwnGL6B6cTo1PP?=
 =?us-ascii?Q?oedLofAaxS2AtRbQNatXP7yTxHqUUHeyf0N5TkcSPrihHD1GOfaOoHjMzMAN?=
 =?us-ascii?Q?wYDQta9tVHy458rtC7NYKtTcy5GlOderrLII3avugcKl6UBIhcAw3qyDtjdL?=
 =?us-ascii?Q?hjm43RVti4bg+l8V+tKqlsJdnO7PNd4G4BstVGjermDtsSVrFr9Z5CBNCIZb?=
 =?us-ascii?Q?oUhFSCPKTjPaPD468LKPiSkJFLPwHX9FNwJ/62k5jLXEhaDdopXqZ6lBftkB?=
 =?us-ascii?Q?/iQmsyoZIOAP1sEa5XP0aC9qJRC9XhiTetwqBuHqivHP9gsT40RvzeRwirOC?=
 =?us-ascii?Q?OhMCbfC29qqJNFAhW1M8eRNdRSoRhB8oCW6QuyXBm9aKSEMBjEkPnLIeoecU?=
 =?us-ascii?Q?yD/jC4afv1TnkPaQootbTChFdDRNO29izs+JioGLriQF+T2lrF4YK8+376mH?=
 =?us-ascii?Q?x9jyXa1PKLo5JjtnhK1eC6tfmxsomCbF1uIvQBRfSbDRR+Oxj7mw4ZXhlq51?=
 =?us-ascii?Q?doCRqlRh/rFoSjzIrRNmWJoRl6eEIpws4P3GEeIaXQGdGu7RxtNl9vnqPSsI?=
 =?us-ascii?Q?4g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	YC3FD6h6km5E4lIDPdXvmnqjJAFepoghBal4DQzk9cZZNJvCvDXBVvVJiJKGcdVpkBB3hJJEhSDr81Xkjqr55LTM+JF4oRaSrE7pjJMwYt457WDne0uFn0slEJ8vIcbx9hJ9Iac1sZ43SBldpUVoFQ3/sZmnYGuHZmndwYunvefiUkJEnC2c6Eoa0MLLFg29F2RJJ0Yt3VzXRAyrq7WtV2dIHomGrVkJjr7jnniOLONqqOBqknijvbwGfxszWk2s1okP0e0AJSH1t+aaJlonkAA5+N0vcenld4HFHeMXaUrTz6NHsSNQZiiHGS/R0k8LMzDgyKEHg5H5Mm91Hx4TOFiTThmHHLIM8+RXqZDU7E/TwfQ8ZtysyA/EeBGBFv4D2KrwcFvH8HTldo9iG5BbWXPTQXiJQcCs6jacBwNkyAUsMgIkKo439Wpj2sRrUBo2BmT5KavKi2ccXqHgSVmbAs3IZy3SHioV8HFhh35L3CsENe4Mu4kCxHieriYmQvlGXg4K6hjj5ghPBEZntfibuR+jBoiFyvwjx99dhlNhZ8h79lGmWl6qchAb6Iy/tl5b/x1roGnoCi/lw874aqJXXN9vQMHz2lnrVLYh6ucNMW8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68704cfc-43d9-4655-a83f-08dc9ca14543
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2024 03:19:24.6982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C6YruxxqfbeIP+b8xDIsESgum7l9dg0SAUYuwCQiB30Sb4HIzgly6FmE6ZAkGOF8gEr0dVkEZb6mnbQdxslPdDu/HO381f3EXFKnWM24KoA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4146
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-04_21,2024-07-03_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=659 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407050023
X-Proofpoint-GUID: coBQyl2dMizSH0RhiUk8_0zQvgy0-KkW
X-Proofpoint-ORIG-GUID: coBQyl2dMizSH0RhiUk8_0zQvgy0-KkW


Max,

> So is there no interest in this issue?

I appreciate your thorough bug report, it is still tagged in my inbox.
However, I haven't found the time to investigate yet. I'm afraid the
CD-ROM side of things isn't getting much use/attention these days.

-- 
Martin K. Petersen	Oracle Linux Engineering
