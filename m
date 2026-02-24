Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81ABA26ED3D
	for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2026 18:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771958601; cv=fail; b=iZmh4bDsaa/zEo1ack2uh0pWgETN6OP6Yt+nXqxSGOwZ5SppgCsOXwWHKQm7+0ykGIS21xwoQHiiyr3fytxqQKpfUFccD7cDBY+qEgW7SFe0+qNqaoUz6vP89/UThixo5go8Za9eTnUHwkGaCRYe3iTQGIx5CwFNn124M+ClwKs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771958601; c=relaxed/simple;
	bh=R00ItZnf7bCsQ2ioug16ZNr8ZrboyhQxFeI0f5CSL5k=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=s+7vbf/b7iL43Ph4xtho75Uq5E21Z7WYa9Yy0si/H/7VP5jQaQbSUZNC6QJxsN5ccOjlocA2kVe5FaLKhCTNYGHQGSM7tOL6plUNqDSWlbQLn0RzgnHvk2DS+WTDgJ6wctrgGT47TOYzy2NH1DyYH/b3gnqjsWVl55QrlG3HQLw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=rUsAfl3F; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JbP0c2EU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rUsAfl3F";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JbP0c2EU"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61OEMvdf351837;
	Tue, 24 Feb 2026 18:43:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=l0TWFUhYPcfki/1Uxt
	yX625ebGQ/0BgaWxzM+lPiqh4=; b=rUsAfl3FDRSs9dlB1XmW9Zs1MUkb7acoGi
	nWF1+SNiNutFVAbrR6LWTXAObgdzeXcSRG3/J3F7d5zNTw6nwAZolh31u+3MX5/j
	42Nnlkdj/X5VO7hTMOamaz8ubgs2OpDBGE08DhsoZALKbWkgv8dKKpk9/1Nqlv2K
	rGu1hod4SpNgIMnnHThwTRg9tU+WveV0scLi8hzg0UsoaFIkB8lVS+fii4A2RoHJ
	guJfPKpmx7Aq8VECBtEov+nAwyzFouDH8/RQqzOGuiTC0rBcCzMTNy3m71b8Relh
	+MCube+Kmm3VtdR8A3eVCsUGWwQPpUO3vL3S+wckYa3eJ0dcUcqg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4arctn7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 18:43:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61OGuIE3028534;
	Tue, 24 Feb 2026 18:43:04 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010052.outbound.protection.outlook.com [52.101.56.52])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35a2nxj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 18:43:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bodPDEhFAKApTnAWQawXVw8KgTNHPYqScq4X4oIS1RS4tL6QwBHYWU5Js/cDxay/Vst9ecgG77kYClnh56tX4VjqyGOkmChnB5bx2xeMIYNSzzMks1s/VUSopgUalnOrYyqlTxWUG+xCKep+Q+JU/nETXLoMHWQLHILuN127GkYcwOwfN5Q/x1n3TT0TKI95MgQAezSbAoYxlmw4kNfP+JPPzxqhVOTrgFlh86VKb7VwmAGGbrXmMTHQ/gNTaMjkD7AQQK1jrwvn6pYE0BwRVvjF9OGr/cgweo7Jafxe1h94xJtlJK0Qbx37XoEnKbrwAt+D5bJcI+zlndHAptb5eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l0TWFUhYPcfki/1UxtyX625ebGQ/0BgaWxzM+lPiqh4=;
 b=lVi6z2wZ0vw/2DI3nhiTK43TH17qfl5v8kLdQFgLuIZwo3UKVLJ4Aaq6KqIIwkAFXBsHQvY9AYeYABzE5ah1fGZHFGJiVi0Z6T5xeQxSQkEwEEh5aceuAWujnlbHvztXb9WYRZ4nitWI7RhIojxh4xTO8UBvTL3khJf65cv7lZ8wqRknRYdb8BWUrDj1DlA6f6RAa/VrSoCMW76ecoKuI+ho0vrnuMxbTRFHDoXAJ9CVKuexi8aOWQjcGdIbgi7dbrJuG32AcI8+U3Ag92RI1qRuSL1kIWK4xjc5PdD0hFQqoTGGTON+cv60YgCO2IjEmWo7qTg1lLd1c3q1zn7Rxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l0TWFUhYPcfki/1UxtyX625ebGQ/0BgaWxzM+lPiqh4=;
 b=JbP0c2EUJfIGfu234A19AB8Ilj8wvh5TZD4o8teC3wEmDShb1T9rQoGUenUsYszO+LuCwwp3SA/iu66aJXHM6cTCyZhSWJXVLq4tR+pw1hMQmbCCr6lcc/M7uNDx3DDDlWpoaYM/Vxae0VPH3PTU2xJodlrQrTF+Olec7FmrFdA=
Received: from DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) by
 SN4PR10MB5590.namprd10.prod.outlook.com (2603:10b6:806:205::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.21; Tue, 24 Feb 2026 18:42:58 +0000
Received: from DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::21c0:ebf5:641:3dee]) by DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::21c0:ebf5:641:3dee%6]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 18:42:58 +0000
To: <peter.wang@mediatek.com>
Cc: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@sandisk.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <wsd_upstream@mediatek.com>,
        <linux-mediatek@lists.infradead.org>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <tun-yu.yu@mediatek.com>,
        <eddie.huang@mediatek.com>, <naomi.chu@mediatek.com>,
        <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: Re: [PATCH v2] ufs: core: support UFSHCI 4.1 CQ entry tag
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260210071834.1837878-1-peter.wang@mediatek.com> (peter wang's
	message of "Tue, 10 Feb 2026 15:17:30 +0800")
Organization: Oracle Corporation
Message-ID: <yq1fr6q7zks.fsf@ca-mkp.ca.oracle.com>
References: <20260210071834.1837878-1-peter.wang@mediatek.com>
Date: Tue, 24 Feb 2026 13:42:56 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0013.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01::21)
 To DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_|SN4PR10MB5590:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d59f506-29d6-4141-43f8-08de73d487df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WFjoGlfLSUP5uKZaqoUfsRmdSVrRd+UQHEAl1L93zg+sNxb9qyiC+/14mBXS?=
 =?us-ascii?Q?/aZeN29mNyEXK3ywh5t8pZ7pYj8HuBEJ4UTiEEkcUw3kaD9UFFcZw8EitWgL?=
 =?us-ascii?Q?6AQU/Td+9qJKZ1lbsT3EMb9xNCSc18IM4Uto9QM1zqOQdfQAfu4hxgqirrvb?=
 =?us-ascii?Q?lUkPTXJqH9mPrngWLCu6dVAeuos0+Xh9A87RvUsMyqe5VLYME38icHBveCNz?=
 =?us-ascii?Q?E+9NZftmP1R28ZkXhfDoS1zyBffoqXUJ0yFh5xc6bJdzvftG1FcLQfymOuYg?=
 =?us-ascii?Q?4NNB+avBo2O31RQPIAiiz59VqHnUUpdZ4PuEanW2gkKmPKaKkFCCxQyeYNjj?=
 =?us-ascii?Q?q5vPsdltvQm912M5d2Pi0b6dNORgWf2LNnnBHYgxMzdxqaAZlx3uzkvnbmra?=
 =?us-ascii?Q?0qpD61+W3puuP9SkGyF3Qhin8UEPdW+0L2aWHpAxI/PjG2zKy37AWp3V9Y3c?=
 =?us-ascii?Q?GBf0SP7CdeK6OQodekMl4zRaVJ9nZBrIengusIt2cxyz/mOSUIdKWAarP6Lm?=
 =?us-ascii?Q?c0m63alvzxkMDhYaBYy+pRvPjN2Cj0Di5W8PY1GLf8WywdtJcm+zvI+oAmCT?=
 =?us-ascii?Q?mVsQKQLeCaT7EjIw1nyoZ1vmNDaBjEZ9wFsNm/MHn9cJ3q1DEgMRNKJHeBRx?=
 =?us-ascii?Q?Wy/yaoFip9u/Z3WuNTeDBPfctIxhk+ORuCvNQoKUagkprs/i657G++wxj2M5?=
 =?us-ascii?Q?i/Q3sI9KdE2dqFtPGwnHwTFnzLpq9f/5i0aXbDWCpYHBDM6pwPXaWSsZc6zM?=
 =?us-ascii?Q?fKdi5hkA8/POAbF4MjgoNIPwL/Am1xivOUNtXAkLl+ExSepPRpm8Mj1Caslg?=
 =?us-ascii?Q?kHFhIpk2Tf9CCfLJVbinRtl5WMM99kcb0I67Y3zwNDzY0qyNsPeocE6eJcz6?=
 =?us-ascii?Q?lPawqjTxiAHF3fHTWF/FBjFgvsCykPHB5fFC1xJoDHddV+uRNJh+q5sAiYys?=
 =?us-ascii?Q?7JITxh0PKiTYU79u1bKZ1N84SQLnrpGIJSLyTKYUSRSjoAUV2c5XFhXIS9xC?=
 =?us-ascii?Q?9Giee79mmpU/0KceitODSKXterSqZ1Xvms1F1Znyq8PNJWeOHL6E9X3D0FMc?=
 =?us-ascii?Q?3pH9Sf2/VQdjXOm/44NuBNi01Ml6Ux1uMIANeVkd5cniYXkEzVrbn+eVOut9?=
 =?us-ascii?Q?6g1Wp4pDMkL13dt+QGpkdBon7ihW1aEnTSu49boUfMOUFKWHmqV7QXQ34w1W?=
 =?us-ascii?Q?2+lHmYXdEh6X/KUYg8StiOgFADzxKrxUBAm2azM2p01A9Xj1s3duCWS+Ar5p?=
 =?us-ascii?Q?4+e87uHp+aZq9v0evtXI/7bzB2zhVKZ7tMNAQciNQtNhT2JC+L7ctQjTuZFb?=
 =?us-ascii?Q?NJxG2GfC3Q1TEYbeFDje6l+9C+SX3onBvlpf4CMT+3kcf7b0ew2YMh/enlWZ?=
 =?us-ascii?Q?+WDQtAYFpg76q5QJu0LxVuG8wCBLRxu6PVeJM61F8I++1fxci1P8WL1oNZOb?=
 =?us-ascii?Q?HyyUA/uQPQ6czfAvB96V9z9RWLbqk8esfgBEO9hZc5YNeX0RwPC3sHByNfbe?=
 =?us-ascii?Q?G8CfZqjEOrc32fGb2VUXYrwYZGnt24V78UMc6xTGdAn5fcCcn0Z3y7EDK7m+?=
 =?us-ascii?Q?c0LH0qwFSF3VG3GBkGM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5344.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1Rr1gPeZs/+0fX0HGUt9U5wjgRaqN5GUyr4rtIvDcb7K7aZ3FycGwsu4Vp65?=
 =?us-ascii?Q?XsAu6enA1CYjv5VqeOAxzVqnqifMK580I20VTjTsIIwEVvSN0f3PVS5yOuiD?=
 =?us-ascii?Q?DCCxbeevDEBvPIyMRy/3Pj+xz9lJuKbpmSqJcN2S8Z482uGT0uZCTxkhWeJZ?=
 =?us-ascii?Q?E0Eheo9HDEl+Nr20IG3SWSattZ8in6YTenk2MEroZuaIaKnUI2W3N0LqHWUj?=
 =?us-ascii?Q?VX5ubmyV75JlOmFp5Sv1J7FN3V5WvhIRUrqeaTDwPxqr1VlONH4B+ilpIEkb?=
 =?us-ascii?Q?tvGEr1Vsg8PEu3886CxwAk+L01NPrqoVJsn7fG7tec3+IzGpbFiE6hEJGHvq?=
 =?us-ascii?Q?VVtGvdDC8EczOvi6o6Lm7zWurZqpuCBzM8UWlpOynwGg32xnkIbSMqdSydth?=
 =?us-ascii?Q?ztpFoJa8yjFlZhSNiPM4s7KOxQZqs6VerlN0JTt90rEW28wqnooDVvlOh3tF?=
 =?us-ascii?Q?RzNBi2bQR44lIJtUBSq4VlqhOw3I9khMj4BLBC7imHDW3K54o63hnqIO6Vmu?=
 =?us-ascii?Q?kUex8QW/5nyxriQNbI5q8dgt8pAQFGW9xbW47tqyYT9u3j+n84tLjIqw3oyl?=
 =?us-ascii?Q?fWazqvsIiNjdvqt6NI+/O+QXjqayC78NRQ0qH/0SRKgUjR/PuTkr87dm9bs1?=
 =?us-ascii?Q?P6QZQsFmzq5Xxzi6xdcn/EvEkiyoJmtxeSkaFg/96TdqQMfK6ocU6/ukfO22?=
 =?us-ascii?Q?JiUedBDivd6wFSJeJTlZK4Euo6mJNPDCnMicHkWWsiPJ/qLndkvbUq//Pn4J?=
 =?us-ascii?Q?zkglisFlDG9SnO7q8y+BXRkoaHZq82TKp22mjbL18qmjNjTI6Nh/sN/W9JO4?=
 =?us-ascii?Q?MxNtU4NomHgTADUiwmQITgDKcw85r9oXFqcVN45HvIOECjmmUQfoNHzvyyJD?=
 =?us-ascii?Q?l5kb+k4t6JtoahuDAL8zWJOEtmqpkMJiA1uQcZ9VrGIezl808t+LHsBbcpgZ?=
 =?us-ascii?Q?0jWOQZTHgQDV9MPBR4EL7rm8xvOU4oPaT5JDnbAuKk04WHgADo67IBK2gdIH?=
 =?us-ascii?Q?uwJZzv+d6sjTwUiGHOPrhF5Vw6s0MSRrl4UkGaHHJAdOOuk1F8MKwZ8ijvWX?=
 =?us-ascii?Q?2tnbFpfKa0nRZ0vJJLQoI4uq/OUJv4jgNGFF0x+muhsXId5K8wjjk/b7N2BY?=
 =?us-ascii?Q?gSi3MgxQendAPjuwzWb8R4ZMmJv7OyNuA/OQEDuAofEOXYeBgaZ6B96gUhD3?=
 =?us-ascii?Q?mdDE0NztHH37s2qk+S0kGqcc+txqelEPI915XREeA3v8Ti3A7zjQUu7Kf43f?=
 =?us-ascii?Q?ePqRYIL0RqhD+48PmpLa5fXH8UCo1IoToxjEPhnmuBwg35eJkbSMfug8s+VR?=
 =?us-ascii?Q?lBZ1ejwo7btIFmjSSanqUK5mN9SiQkuBQxHP2tW1tp5ncedKwuIaW+Vp484N?=
 =?us-ascii?Q?X2HixEDbCzb6RQpDi7JzSP2DaWKzUWdi5ziX8QrBaqX713HPeETPAF7YpNmg?=
 =?us-ascii?Q?d2pM89hDuWQU89rxOzvQta4rjyMFksj4fJKRs6z0zz/VJcxqCFBym2de/IHm?=
 =?us-ascii?Q?CXOQrgAp7mV0Z17ASsjl720Lg2n9w96umFF9OZH1kyWoNh8KONLw9YCon0f1?=
 =?us-ascii?Q?danF9EgfXlr+iNxTfJFjlGJrJsMaQnw/Qq6xMwetGQf+OXgUNKMiaxlA/WmL?=
 =?us-ascii?Q?S1c26+FX/KXgivUCIeTxcoeBYF1D1SXHo4nQB0ImjCnB3JROvyB1ZGWjzSvN?=
 =?us-ascii?Q?CLnJTHgr/hNAV0bc3DRPPuKLvToYoa/+Cf/hbNSe0r8Z+dPJxxu8YKYitaGf?=
 =?us-ascii?Q?pI6feCaYB5KKYRMpVrVjYreA3v0/8mY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vglmYeA3vWz+GKy6+Gn/kK5hA7D8eslM1mUSpypNUW3lGFsaFmhsGNbAYVlnDYiHJuB8PPtC+qVBVIqAgKTS2/eI5SPRMdFnhxAK66Mks/QFBE4ON/CZ3tQCT85cDaKR7hVjpRKQ5BlitLpdtaqACWdFxtADfa9bsQSTJchTRhC0ls3Ea2ljbGuMrLjI97QaCfX2CGcdJBgSAQFbJzuczvanBjnv1yR5GzAkVJs6gPxtCTe2N52gbYseRe3RL+kETk+/LSSD3D8zlf3vpPiJNPBWMkxWahSIZsPp9mOpe31tD2qXoF9hu140yJGMUkv8kadiJzNg+VAcOA/H3qC5rciRY+iRPhr5kOezISGQa7nWHYhxtideQoUZg3fxBPduCf84rzZJ9+7VNUBqAZKah1Fc9eW1c9H31AfgXPr0f/ZMOYmz8XiR//kLKK0mA4BHP85VVkG8Hh4JAb9hgF8+77HWuLhwwBPcwrpM2Eq1FmBpiKcZsUUNvxqlo2H6kIEu1/2ekKDZnX194FwELjVsibNsi1mV3rDUVa9EN/UMOzXfkh5DAmT6mxmmE5JY+zAj8cwOrw3ilbSbzmrtt9VJPZMqfIvC0E+IYwjxUDKabhY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d59f506-29d6-4141-43f8-08de73d487df
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5344.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 18:42:58.6852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eINl+uAEWdrWJbOSipiAatK0ejhYZkqt4vGuztI0UukAmbDGWr5tfCHuYRIIKK7InjAka/mPKGt6jbu38FIVAblXDnsHE4BQR7pOm78bvcI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5590
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_02,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=970
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602240159
X-Authority-Analysis: v=2.4 cv=La0xKzfi c=1 sm=1 tr=0 ts=699df139 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=52_T1jr_FX7imiZLLDMA:9
X-Proofpoint-ORIG-GUID: iGwdUels5wo3WOIl4XUs1m3XLpNNcCgQ
X-Proofpoint-GUID: iGwdUels5wo3WOIl4XUs1m3XLpNNcCgQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDE1OSBTYWx0ZWRfXxNNQOoLENk5c
 ewFpu82tYFj40b/iCfAIzsBuFpE1RInu3SxQThRKVTuFXNG8gSlejVn52x9HOWt4VWrztD+Rer7
 w7aYJQhCh0SL2QqndpdhNmIz543IQIYZ46Lfs0/FDlZzzQoBxuphs4oJ627D2HX9JrPv/6JWZy2
 rSYCH4YtMV9ChJoFnqAJM2+iDH5PoDzBpd17rC6PSaRdkENZDojctFeKgSPjO2gziVjTpz8r9wU
 X87zqvweCe9DV7512oVpMBfrnKL3U35yeTaxbHq06gHeBEPqtf3SSJrfCMmk+2ZwB6H8JQFQ+i/
 pD5qrUoeutuSzT8ljDyYfkl0UcOvjP8cWehlITumfTCnXedNBJV7VCZmdRl/pL6KeppTURVIgDm
 AaYD/b6nR8b76tNQc2VrnY5FQ1pDCFustWS53oZWnGs8nsnaSsefFoiuCrN9+HaNSfEvXU0MrTs
 N/2Qyh1lF0ih/5EbQqw==


> The UFSHCI 4.1 specification introduces a new completion queue(CQ)
> entry format, allowing the tag to be obtained directly.

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
