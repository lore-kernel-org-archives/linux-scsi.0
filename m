Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B020D28EB
	for <linux-scsi@vger.kernel.org>; Sun, 31 Aug 2025 01:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756604165; cv=fail; b=qxki5QU4vppaSspQNb6ozakVC9Rp/i5qHGbY/r1Nr1RemBAQBCC37imXkAD8B0gNOd0OgjvjyvZ6knXOXyOeUyDt4iX7RUAA0hbSlJ3+oD4XcWJ6PkVDidqiultnELdHg/hLZwrEgvhCJFX2FXXziYqD89FOK8BEU4nFICNlPf8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756604165; c=relaxed/simple;
	bh=UeX0iNR0g+6hEBP355S6M93TaNYlkkD8AAiigci+dU0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Xaia6QoBnHuTPD621BF0Q8BEg7UN0Wx0ZsaYVBj0XgmD889GKCICF42Wet9cA4oTmFXfcQ5KXAB0GxkCW2KOAZpka7VZRqf82ZZ+B+nxcsvtqVMS69k++UTECiEZzc/kxGIoGVCiOI/FPoGSatDzAlCqzIdaePthBhT28fvZbHw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=evayvFp+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QZ6t04Q4; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="evayvFp+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QZ6t04Q4"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57V1QoZV016138;
	Sun, 31 Aug 2025 01:35:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=/5FOc10Ziaak5u/wc4
	TMpPK/o0sAy0ceOQ2ipXlJlPk=; b=evayvFp+J99vUVgimVuxjwPqcxe6KhAunC
	2hnlLdPldK98yfsVLDGkXEGAt328gkhmNqBUPRPTkehMxc3RyU5KwvEhx5P6dbWl
	6aC7qLCqIyq9q559MhAj+yFaVMpzjQwXW22HhJk4tOI0wauOYVsUzGw26/FM+tZ3
	+n1Jv9g/8YG1kFjd3q7HGJGgFVnBmM5CufjUk6JAXwcwVc1uVLoc4JpbfnUaxgYv
	YQAWvtqKuJPlmYWoIL/Rqe+Qo80GP5NKxlxMzYjjBp63J3Eu3h/rPXZQ7yD/l8xE
	9im8A/ymbDMAGmhkbKpBUOvG3NSSov5DdqYAp55zisy/xzosZn3Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48v8p4g38u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 31 Aug 2025 01:35:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57UJSGQS004166;
	Sun, 31 Aug 2025 01:35:50 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2054.outbound.protection.outlook.com [40.107.94.54])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48uqr71qr0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 31 Aug 2025 01:35:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F7a0RXuriZlQktC3qaS48YWkAqSVU+7mMeS7rboS0Oi46jQsqMNDMuetN7LmDfE7fYAkoEr7kUneXFYpaV/OgCMD+flQSP04TtbkCW/VLV8p3rEJAGNWq0EGUNLpRd4ef+szUhb7GyFuD2OAIirEQl8By8RVDJjitFd1emaAJBj/LyNcAe0vtohrw4Wd3Xgn+ti/AdYp2xmzW5CMj16c/Zvtw57wH2I7Pe1CVnABu8t3awNnXzmO/pbnU8mNeQv65LRFVhrNfYJ7tKT3Wi9ZkrWNPIk0YnGPlHv22Ks2iaRe1GiXh/R9Nw+aFdhR0DTNCZ6x59NRP7txbcb6kPJJgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/5FOc10Ziaak5u/wc4TMpPK/o0sAy0ceOQ2ipXlJlPk=;
 b=hrJLzoHRjRmrCMa2DL0lx3M9Tcll3ncqLNjNnIZFc1uN/Ra8T1r/t0DMqWjQSs0URimZbBEQuIlhKURh3z++6H5M8KT9IaBicGTYMZnPqR9XJE+yYNyxtcswWejic9gFj/AjHreudgUAhYmbLNOCZ00n4ApsThg6/mFYnHZNw9Po2jokff0PFHhkMd6PU+KLx8XMkrJ0yS1vfr1FaGL4LHX2RwOecEJUYmenUVLxy0Jp6f5AA6wmHq4s5xJFSwSpBCCNC+CM7MmqGEdW/9ng4+j910M8aPHN/Uxl8gz7bXviXHch8o6hJAc12D3X5THl3zHJoniSaPQxPFKGZtKl0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/5FOc10Ziaak5u/wc4TMpPK/o0sAy0ceOQ2ipXlJlPk=;
 b=QZ6t04Q4tNVzlTskChVZwoJ8L0opXDkKSnIRnYA7wndC35SzK+OjLMN97SxuEFxEgwhcYMvPcS4tK17CqMwUUBPYGHa2zz4iqPruhDmXeBkxi3bYqH7Ndg+ybEkeiE3f0w185apWuOcoJ9e/Zblagu8SWYe1CtFFnuUzAzoNIj0=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS4PPF415C917DC.namprd10.prod.outlook.com (2603:10b6:f:fc00::d19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Sun, 31 Aug
 2025 01:35:47 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9073.021; Sun, 31 Aug 2025
 01:35:47 +0000
To: <peter.wang@mediatek.com>
Cc: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <yi-fan.peng@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
        <tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
        <naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>,
        <sanjeev.y@mediatek.com>, <bvanassche@acm.org>
Subject: Re: [PATCH v2 01/10] ufs: host: mediatek: Enhance recovery on
 hibernation exit failure
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250826062314.3070425-2-peter.wang@mediatek.com> (peter wang's
	message of "Tue, 26 Aug 2025 14:22:15 +0800")
Organization: Oracle Corporation
Message-ID: <yq1ecssffil.fsf@ca-mkp.ca.oracle.com>
References: <20250826062314.3070425-1-peter.wang@mediatek.com>
	<20250826062314.3070425-2-peter.wang@mediatek.com>
Date: Sat, 30 Aug 2025 21:35:45 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0043.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:2::15) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS4PPF415C917DC:EE_
X-MS-Office365-Filtering-Correlation-Id: abd811f8-1c64-4d7e-ad53-08dde82eb5be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+Doq1zHm9ceF+Td9eclKUIFY9gbgqer12WXZoGkIORMcXaW7fiHRCImZvlCq?=
 =?us-ascii?Q?iL31BW2v5k6iYb674h6KidHaLscAm/KZ3eg/sfdrRcw3rPZQUx8xysNK6XXp?=
 =?us-ascii?Q?A2N29Pmv7+ie7f03U/4HaXj0QMwe4dezQ4s4XTv6FKwrz2fWIWg79WHYEr79?=
 =?us-ascii?Q?uYTsTxK/RYorBjorIZztxYFuRoG1xWW0Aqx2GtmtOEEw+Hu2JwIes2ND+JE+?=
 =?us-ascii?Q?pwTqC7CQ5b2XsW/LnXpy1kOf/8oTi+7Pq7yKL7jzB9qy7dC5/VwS8tKjgMwG?=
 =?us-ascii?Q?VyMBAONG6y62AsJ+tKMuro3cR3GjyFbWCiziMT5KlQqYPFKLa4RT7OAPoKIi?=
 =?us-ascii?Q?EYfrC9WQK86dOdlbCaSFryx6Kv53PmeP+XLxgWbffutbO92RbJZipsEhYeQe?=
 =?us-ascii?Q?DyKPzgCXzQSxz69IHYkcNwBj3uTvC1zTy+p+AQ4oNv61DPm3gH/aON3Zm+RV?=
 =?us-ascii?Q?nfVUaVo3n8jg5fuaThmGmTEndMEeE/zn3cTBKGCbfELXiFVxjrdMbWFJrnj5?=
 =?us-ascii?Q?vBtmd7NOhq3yR+8QrrKKK1QYWLP+o7ivZvOTBQXpWUVKDcJVs2qeR0Z5/rlU?=
 =?us-ascii?Q?67VpcPmRbYzUTuRGLJfIWcEH7ZbNh5PfZtTg63e1QoyGwu2lsy/wCS4ltxyv?=
 =?us-ascii?Q?zJr1zhMwADCaSk7XOXoRwgFouC+0oKLI5wDQu3I+WJZVJ3bDWMPebr8TROph?=
 =?us-ascii?Q?srcYU8ClH3APBBFjEJrAlXXRtSK7Fu5caGfh7gl+OkJ22lm7qAB+n9g4kDJj?=
 =?us-ascii?Q?BREJB2zbeAhOtC9NQGJFyvTjZ7HidGLPW/z0JUP0xo1sRWfX5IEnFDZYngSj?=
 =?us-ascii?Q?oSxzdTabJqZzpibIzokmmgLpG8bsk828rmIKL5Jnb6Ao/CGxYldD/xcsr/27?=
 =?us-ascii?Q?l4iiBYfKn/eqr6bPixc4z3wMIBETirVLEMk1/JziOkDfLVsUf+ZjgQLXK14W?=
 =?us-ascii?Q?IxNyVO/KLp+0CIHMiOVwL6GmE1cQ6Ai5Jj8k8kbRq8wOA8d79Okcr7TXGOcD?=
 =?us-ascii?Q?B37nihDE+nbRaGlz+qVVPbYNHzt57tu6ffdZIUMYhAnkfo6FZ0/qJyMfWLPX?=
 =?us-ascii?Q?2EffNOAjNjL162WDWbsPZWsqmaYd+vnqZx8/aWAxl3I0GhfGOkcsjU+F1w6R?=
 =?us-ascii?Q?QPvk/q6Hu1fUNK0vCt7ylBRW80/Hdl48rAAq/39ESkpiESwry4djk3S6PuT5?=
 =?us-ascii?Q?c0RcexDoh+T4rBnEFtbhAMQBrLqPxHhhMVXR4FW3fdMmYJ6pVuUUJhadcqd5?=
 =?us-ascii?Q?jRV2djrS1d/4scYFsbp+aIF7r5pAYszeJC34LCBEaCup6kKuzL490WLQJjJj?=
 =?us-ascii?Q?GZoyD4bo5x5lX17B4keC67qzXC+rfREEWld+HghX5hQEkqjOysZlVCawQO9R?=
 =?us-ascii?Q?34H0ra2ecyPS0E0sE25wXUA0ONAjuHhvll4srCspmeTIri4fOh0xbdQUslAd?=
 =?us-ascii?Q?SUmRAMnCfTI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lQDYXTV84mufk+nDRZkSaoXkgkFVHibEw/N18+838RgVwjogTfOmsQj07Pto?=
 =?us-ascii?Q?/dewhEy3mw/fU/U4QkUriA4ohEIG44KTDUilUNoLjk7TS0AEyO53nz4Vit3K?=
 =?us-ascii?Q?W8kZQ7PfV9QxX5z5G1ThW7DX74KQlcgGxmBWZvO30UGtNFd+m4tfgAAiWmL4?=
 =?us-ascii?Q?/l5jVqntATL5Myk5McEACXqPfBiRsb0TDsSWLAuAmNWh2rQknOYfxR1e/eRy?=
 =?us-ascii?Q?EonAr1p+1AoOJKkCKeh6of83KxxQSFAXm/LHsrlNIBncSeLeyhF7JFAM+dos?=
 =?us-ascii?Q?8uSyx2n8DUGjJ94eeS3DuC1iSlQF7q79gycXU68n22JhOaX+C/ioBnuMxrCH?=
 =?us-ascii?Q?4Ig9WZRF7d/rSVhjVpAntyb8BpUIJaM3CNGtIppVrG7kZVj6TcTAB3BT0sjP?=
 =?us-ascii?Q?MLW3zFOKkSeoPtyWMwE6Ob0z46kZFLqZszGnJd0b28AJOVHdhHzpx/6c/dYt?=
 =?us-ascii?Q?GDVnrcO5Ju31j/uBaRoWY2anZl4UsIkn721/DjzkTSkQYH/NDud4FPklIchU?=
 =?us-ascii?Q?7KlOLGz43p9UkVzek1303Pz5MRcdgU7jsEgWO6AYQZDkhppBF1/PgTGXAuVx?=
 =?us-ascii?Q?8sLeTJJ7TKIUB0wWFDTKEN6EX4K4ZCy8Hmtkhg6sI7aPOqNzm+0Oho1zdfNZ?=
 =?us-ascii?Q?iuGsfxhPQKdYOt0N3cI5pTkz0AXAo4KJ5t6Tvr4AMuiUymXrxWgeBA6DQCLD?=
 =?us-ascii?Q?fGv328zQVrPqqwEXE8pF3oRQrzeludnaIanHwjUrRbYyPsfMKiuRus4e4L1O?=
 =?us-ascii?Q?xS72aeY0K4exM83cxzhXSxRF6U2HiVw92L7evcn6IOdVg5UqjoHY4rqbcvVX?=
 =?us-ascii?Q?wzlngBUd39nCZdDaUoxL4FnFqiBIczlGyLHDhJJ0ygS0nTAVFLsSjJD516L+?=
 =?us-ascii?Q?LX3odcJO5ay1Ay2A7GohUpIsavQwizl5R+Q3Jh+GztnV2YLvS2OtUmQgADqb?=
 =?us-ascii?Q?6JI4OwLq1cN0eq6mecYTayRnDoavXTPlxS3fP93rHZ0t6XuXYqKnHJKDB01l?=
 =?us-ascii?Q?eH1Hs509XOsgqFr/U5zFySieozuU6BNNLZyN/bDgCWb2kfKXMl58my27hXdg?=
 =?us-ascii?Q?HCKTS1sjV0/rZhSPdADwkfU9Mlq4qrk+OBkwfHfrd0P6l8i8R/VUm1ElAuQO?=
 =?us-ascii?Q?ItVWNVpcXdw+alk1jPROs5ZgsB1+GhahOotBdT3uO0TQ7uacsXu/49tuAbPs?=
 =?us-ascii?Q?xLQ39mBVSAWlfR+JopvtLWtZ+GiJW9cNgD23e99VZZYmtleznkpM0aPV8Zku?=
 =?us-ascii?Q?cbIzrDRekp4pvlhW2e8wYnfqooxW1SzTlgmcXmOJy6EbhKo4OX0vbvzkf99M?=
 =?us-ascii?Q?ZBQqy8GSSfr7sFpmm3vN67phLmpdzDovz0c+P/lDqYnUzu1j/yLphH2PNP9/?=
 =?us-ascii?Q?3CU/dh6QC30o4wBnobRILA90pWAjmL50EW4RNG9NzvmiRSQxd1YwC6rxuic3?=
 =?us-ascii?Q?NfSjeObmYP07kUMcOjT5MhA2srNhkX0Ei0T3MmysiZvOaB4MxxYcMdpXXuJw?=
 =?us-ascii?Q?jSh+yENHk+JZqjuuanrntrEu26ZXc2myotQDFkl9gljYeEOmaQIA9xe7rlW2?=
 =?us-ascii?Q?00UzduRCbs7bTOayyduztvjMUDlInwMHXTlqu/yuVYDE1bo/KwfdvKS3USvO?=
 =?us-ascii?Q?NQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/uAscXXrZQn79l0JE3gvl5roXL8nidBkD5vnE5QmDU6ku1Ers0oLblG08EAeWXLkNopRbbWNgMohYsb/7rJ+/U3pz+AUebkK071djMciQvjnniJtfhX4XibCiLl9QBJ4US4mULhy3Iby5bWhBRBH79CvpYNYYa9hOSC/OVJaW9uZkYoH5hQ2gYf8BAPEy/jbA2xTwNj6c5DJ3fbbysfsBebuex+vbGxeBEj7O6j/PTntW5zBTE7HqnOA2vvcTubo/KK1JBXzR9HhzyN1uzB/+LWjiailFqdkVldDoQgag5VZX3qpBgazBCwmbMr8AAfWAyGFNXvfrmA6+/F2e36/c5ExiRpxSes9rDefpU5juYlKchtuKd8BJlTCCr2aMuGvCYBDOC52HKVsFkMBJ+c6ELurt/DQJx7iN47Vky2/BY8FxU6I/UsFsvbEEx/QzamRlKamfdz+MTfTbkVhES1pKV1A7Q8UwX/YUtwCYorwWbIQke6CRhwX3ByFdd1u7KcQdf8KCxIjQFWMnZnOalRn4UopeyNd2pomYBFeuuYEQdXjbm+kb49/XX+L5uI+tCRwpwCq0sePI5KXQyV8tV2/EGOvJ5t34iwVLVH8YfDQgQw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abd811f8-1c64-4d7e-ad53-08dde82eb5be
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2025 01:35:47.3122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fm3bmTzdNN9K0xPJ1dzSUTQj1yAGeyo6qQGTLmIz4lM2vwor9KbT6W/RxU3CTJIAFzXZFpF2mwDUeTGNgDCT2rSkkjkNFMFZrSIJziaC4n8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF415C917DC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-30_10,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=905 spamscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508310015
X-Proofpoint-ORIG-GUID: 4FMPmvh7awqgSj8Qcf67wufqrl_MLsSo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDIyMiBTYWx0ZWRfX3fgQu00TsWC7
 aK23lEYQSl48xDmeLyUKT3KhYaLNvoTlgZDjtHR6yEJpZ9K3ao1qgz7LWc8tjxF6JO17tjxYO47
 3XHCerHEtr6VWicrFZ+zk5cpz5XOegbMXe75RfpDWe/E9SBlJyjPV1Be3E1tv2r0kaVpEWOSXK1
 QFTNsmJdWXJB3zEdAqSKxaNUd1iebvS08qZuXiCB9otfXWpcdIH5qwJfljaqTiQK984z/UNm1NU
 A8l3/4+JtQYUJ1N8umyKUk4HrvfuQIP/ejvdZcIADfRvfNSSZOYOX837yGQGRRR3+zP9GuiAZs4
 rm9L+s0fAVvqvmP0itZhKLx6g5hHdnWzmwghB8MJV/ezLBx/lD0BD1hOwrJYuZIQ2sqpeugqVNs
 5R9W3nTB
X-Authority-Analysis: v=2.4 cv=doHbC0g4 c=1 sm=1 tr=0 ts=68b3a6f7 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=7DQ2_-bZmusFoTI8zKEA:9
X-Proofpoint-GUID: 4FMPmvh7awqgSj8Qcf67wufqrl_MLsSo


Peter,

> This patch improves the recovery process when exiting hibernation mode
> fails. It triggers the error handler and breaks the suspend operation,
> ensuring that the system can recover from hibernation errors more
> effectively.

Reminder: There is no "this patch" in a commit message. Please rewrite
your descriptions to use imperative mood per the instructions in
Documentation/process/submitting-patches.rst.

The above description should be something along the lines of:

  Improve the recovery process when exiting hibernation mode fails.
  Trigger the error handler and break the suspend operation, ensuring
  that the system can recover from hibernation errors more effectively.

Please fix and resubmit. Thanks!

-- 
Martin K. Petersen
