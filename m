Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE162221FDA;
	Tue, 29 Jul 2025 03:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753761030; cv=fail; b=UShuajgmtyT8D2jakLXVN26fw9daaD+pgArADtYbAq7A5SzhfDJttyzAEu7pM/LQupWFAgvUm9A934ifd4VRgb7NIzS80zxEJgEoHdm9MB57+b9G64zAwcUqa8mM8NAKcrmv+0NxDlipjGTessdNMfAkMPy4HKCE0Q4VJOcJ18s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753761030; c=relaxed/simple;
	bh=FGH5DMbnmdyQpxOILX5tMahuRUULbcpnoMq2Rj/XLv4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=RKBziXibxCbyRhlPjOX2eoq6GUgBUuVQnn7DuI8ltpGi6r05eXWA6hk4KS47Ux4Sw7s41vha80KBvguoBc/qvUJAp1E8LPt4EHwtP0fAMAqhO+mTipVIHyDOtW++TiihtA9kbvQg/PPrPFIO7CGgFlfe4C7IcoKzOV/tlsld5cU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MrXguzjm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lymqcozh; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MrXguzjm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lymqcozh"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56SLfpHl002464;
	Tue, 29 Jul 2025 03:50:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=64jOM0HbMaN/aZ2+L2
	oBxIkqdPR84sd5YyhSEs8gW7k=; b=MrXguzjmq8KEeFzPpEAHuK3aGagAaJ+unq
	2eiUaccdOeijIzHB9rGtqFJHfsf7lj8o/AZE1ryu4TmGMYt7hZ5olYvuKgJJgZ5E
	XTUnRfyfwipObkc70De136LDc9DpbExw5Fc3B28OrUNACQhgEa87IkEt9wHJt69I
	SI1vOk18XLckym2CBCdrCOR9E2dWMVNmvttDpXaFUoXoEh1KgHNZHsQ6qtu8/Kja
	liQFhJdmsDCDe6T+YwKam78yciHybvUDrIuzDk43aISP6UeziNCEbA5K7yOZoZt3
	phgGLQ3IgLryAi8ryjeKwVIB556WoC7U+oMPp7FrpUu5XgUIIjWQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q72xtqc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jul 2025 03:50:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56T3asf8020417;
	Tue, 29 Jul 2025 03:50:04 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nffnntu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jul 2025 03:50:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RrjFFZGtbwt3DFTq3SLxUxkOZG7ypNXhjl7fvHfPadwb+UCDfLvTZ+F0+OjRH0K/Eqnbw32kUdTUah+CQBdzb3wLMEBZcO3FMIklb5nsIFWAuAvaor7pSLtWl3/knAUpjiUua4FgA2/LHBZP9UXqrfESAYaNvpIn0Fib16mpSP3pniqRKUsht31B7k8jTAqVPv9wyioVjcKIQTF4blbk2r1V8TMiHsOGcKIbsf/aiJm5rh8s6rwP99AuVm30pPCo9L7EBapamSsenMRT7vRUn9v2A4WIqWesadT4vFh5mBeHryZNZAy9xbS/wv8UZVK3WxrZjc6/vu1OYORaQ1sPSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=64jOM0HbMaN/aZ2+L2oBxIkqdPR84sd5YyhSEs8gW7k=;
 b=yu/21jacP3x/aQuPmlpzfm5Lsu3MfajYgHZcppMUbGQkhuLX2CvDvz2rvo0ojV9RYSC+XaeT/8AX7T1XcqYNdPS6qFgeq4v8110ScSIlYcmCRUDHrNnwj0PCoOL5w66L5ylhw5RBoFgoJIKpVVj2ggcoH95Gi8M2+yF6VtgmHalfrO15pUcdYtyLVqRsk/kbt/hfumTPPh6IFhp9+lQIv/AF6MhCGXG9GfKyOFEbNkb2LWp4pvUnEaRtPZTx7WgDLDl1gIQmOYymKkWwgwjXOlvuoQ4Gy8u1OqRsWApI0H2nMOcE01KBHsm8KDjStYiEWdeMjRIYOSdnk1iBhpeVGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=64jOM0HbMaN/aZ2+L2oBxIkqdPR84sd5YyhSEs8gW7k=;
 b=lymqcozhRjn9cg/GOXpP54ZrW5EX/KtRxYC1K5i1XxsnyvQY6NqMlVNjPjRwia8DGd1E0O3gOWLvqud7wo+DeIhDPEXdqEIge9lOnhPVyfl3GSWx5E0Jp5B7cPuo54vn3mclt8joqCkcG7PqLY3hJlDfK4bkTEgr8kA/tNgqTt4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH0PR10MB7461.namprd10.prod.outlook.com (2603:10b6:610:18d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.27; Tue, 29 Jul
 2025 03:50:02 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8964.026; Tue, 29 Jul 2025
 03:50:00 +0000
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>,
        =?utf-8?Q?Csord=C3=A1s?= Hunor
 <csordas.hunor@gmail.com>,
        Coly Li <colyli@kernel.org>, hch@lst.de, linux-block@vger.kernel.org,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, "yukuai (C)"
 <yukuai3@huawei.com>
Subject: Re: Improper io_opt setting for md raid5
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <a1626eef-9846-4824-a899-2fbd8e369fac@kernel.org> (Damien Le
	Moal's message of "Mon, 28 Jul 2025 12:49:45 +0900")
Organization: Oracle Corporation
Message-ID: <yq1h5yvn0bb.fsf@ca-mkp.ca.oracle.com>
References: <ywsfp3lqnijgig6yrlv2ztxram6ohf5z4yfeebswjkvp2dzisd@f5ikoyo3sfq5>
	<bdf20964-e1ee-45a9-bf24-3396e957ff67@gmail.com>
	<2b22f745-bbd5-4071-be9b-de9e4536f2d5@kernel.org>
	<6ab1be6e-380b-d4aa-dd71-f53373a66e29@huaweicloud.com>
	<655cb7e6-897a-4fab-a8ce-8832f2bc7274@kernel.org>
	<4767823c-2332-b3e1-67a6-2d7f55b48156@huaweicloud.com>
	<a1626eef-9846-4824-a899-2fbd8e369fac@kernel.org>
Date: Mon, 28 Jul 2025 23:49:58 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH8PR22CA0021.namprd22.prod.outlook.com
 (2603:10b6:510:2d1::7) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH0PR10MB7461:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b7d1066-34d9-4fde-a2f1-08ddce52fe3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MhZI9XYJCpEEViFNAcBokI3NLbKeYYq97jw0OIyUKIysEhx67WiRylwt7ClZ?=
 =?us-ascii?Q?jQv5FQ2PP9NjKiHbdostwAty4BMAT3spdphQx2ab2qEwemhoktb7M9q4Fm6f?=
 =?us-ascii?Q?91p0mTkBdqFUel/OAeQHXULnSbHrup0wnNfK2XsdroN39qAv7AEfKjbOlEWK?=
 =?us-ascii?Q?2RSlrCmBiNOjC35zZJPD7Bt35Ej5RPy0CiqswfivYea7pMtwzrICjBkPiFyL?=
 =?us-ascii?Q?r8L+25a53gHYMacCK5pkKGQc66k5qFgaVQajOnKElEFNyQLv2hgzr0fwGR4J?=
 =?us-ascii?Q?h1jWnll2/xi18SQnIGlxfrN4eqj5jtAJh6nxt52WFIMQH4gTQWSnTB+tf1EV?=
 =?us-ascii?Q?0wbwLI3KW0TlcZT12WUryU92cuh8sN11TQcecfd3YsrvHplHUfenry6gAafc?=
 =?us-ascii?Q?OmEPMGjdMhHAGGvkTj74HMJNBIJ8jATeR+ApNpbMlPZ/O1zxz5vyKrCImvd7?=
 =?us-ascii?Q?IDpZ/zPaZOsatMJvFJGRdFL5z1oVjETxDsHWE4uSg9WG9zBccpTmcFv2MkHj?=
 =?us-ascii?Q?phRNYWq+vK8eWPQR5Ny2yRpZyOFMAkr49MvduWJs4gsTmobf6bZWGfw/MyRz?=
 =?us-ascii?Q?YiulmHePRKhcde5VUhDRCGvSMQLyKvsJL5TLu1iZcxXVOvoB/nu7SGEwBgFj?=
 =?us-ascii?Q?5iUiZkr20wurXrt53x5jX14wl8qFg99vR/jI3s1w0fKhGksTBaCrC02XVy8d?=
 =?us-ascii?Q?Imsz+1v9NJ7RhZIsu8g/JNyA3C4nFEuC/lDRmrjgKrYYlPTwM7vBrkAuBEjx?=
 =?us-ascii?Q?L4eL6aGv8WBX1ItGH0C/F7BUj2IPkmXisyYGn0P2uVQJEU6u9iJEbnPzYXSd?=
 =?us-ascii?Q?0wVKtxflq4PPcE2JJHKqO6VJCJ1ZUL1azdNFGE4XMnZFkNYB9ZWeRLYYgIEl?=
 =?us-ascii?Q?1cfRqijNPQy6/ngI3sKOjkvUm4ntVkZguvyHc45eLkVBR7HOBfn3ZWADcoO1?=
 =?us-ascii?Q?YBDtzQ5FCqZX2EXeu3pnsPflqEA5NcQuKx3IDi1XYV3kyIKuiFJqs/U/y3hY?=
 =?us-ascii?Q?04LIEuV+VhUK00XQ259ORAdw0Ga07dTKI90HZnXcu5BYuXnwgflyXHC3szVm?=
 =?us-ascii?Q?IMNI588n1TlPqL9ArS3XveWT+MDvwF2KeqaIUodUqGYdIfO9hEQHiJTzvLWh?=
 =?us-ascii?Q?gScpx5LpxB+52Zl0ARsRGVQVpo/0uKSZiPhwO+ZbDeTUuuiJlwN136hw7Kuz?=
 =?us-ascii?Q?eMHk4jn0mdl+8T3DsjR0y5Ak8mHLk+jfCVMxQ6NUMy/83rgEja9jJPQQjsNK?=
 =?us-ascii?Q?LiTb6fGSobSHIzEZGaoX0592ac3F8sM3Lr8CnSJjBTZiujwXsVrWoySvAK87?=
 =?us-ascii?Q?y5HRPMo2EW1UDfaGO4cQ3DZjMScg3Oqp0n2+wO7FAXcbDevS2oqZWAeoYz1O?=
 =?us-ascii?Q?PoWOVV/jlXykvyfw6hb76jlR71o7VY5EQ1xpHh/f0G0y68fJmNt26wAsbvJB?=
 =?us-ascii?Q?VANsNFK9Umk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?646lLtibMnjI4QcYl9sepnz5uG0J9ZntYdjcepNooMC+fZAgAo/HiAGoIEu2?=
 =?us-ascii?Q?Vzig7/LnyEwy2aH1Rvt5gnkKsRu+m+sKaXKGlNyGcB2WMsikJzOiUVQmMpyk?=
 =?us-ascii?Q?tR7c7rYhV+46CC30Ug0ZardBsVwz6jUPvldLGB2JKHBjnJRpMc0eHQGrDkm0?=
 =?us-ascii?Q?SzlRoStJPw7lCIa1uYRmYYn/f6dkH8342UVnjJo5RT+tyjyl9UzwevmyZdG8?=
 =?us-ascii?Q?MAjc07egWNxlhq+8gBHuqSlFSDDUFWONuumO/GUXU/FZoOcR7RajM7IyttjC?=
 =?us-ascii?Q?QVUMzpBSBZFdEztG0XH5p0KlJNbB+TmmaGuDC7B+1C+qc0Oj/VUlLsg3NamR?=
 =?us-ascii?Q?WKQyh/PCEeI7DWBAfNSfU2Uzx5wfUK5htGpOhkrWwwm1+steqTRZZkhwN/hN?=
 =?us-ascii?Q?muUAy3w34eo9JlljtWjGZ7uhtBvaY2hQA8ef0Ku3Q3mPRxkllFqFHIcV3UZH?=
 =?us-ascii?Q?hRDO5YVzeRbRwhqpHhZq/qipjcTIq4ct9ZJGwc83ZJ49Lcq+wHDhAVSCxuAX?=
 =?us-ascii?Q?RKiDms4SlbElWf9fOE1HafBVNtync9Nyon7TLElSDLL5307Vgc2Lz3orTnK+?=
 =?us-ascii?Q?Epkmn/3btinquQYZlrdjgmx+UmnnGhmO9i3N/HWuDgbl/dhHS+9spl/wttu8?=
 =?us-ascii?Q?ZdBncSp117j3j48ykpt//olk1OKHm+UK+lj2CgxaAX7V6PLvBuzmTl/2MuCe?=
 =?us-ascii?Q?PE6JgVFchrAFsRWV8XGHmGLf/JShESOm43bCxLphGJ0V5GUIIpIj369YAq5Q?=
 =?us-ascii?Q?t/bLlib/xBDMqHtVgqtYaiCQWN/f2sqJ9/rJuNtf83nX20cMBb9oCZRZ4L0L?=
 =?us-ascii?Q?ffYaHWnC4YqGUR7DSaO9P6ecH/Qb9x+QCje/79fhdCNOlwGDkMdUpKQe4RdF?=
 =?us-ascii?Q?2sEgcx6W9xlw4JbFULSfm8PajMr1G+LgHgMEi8fNbotl9ieOsCsc8g/dX+h6?=
 =?us-ascii?Q?jddZJ+zC1x+n4iVM2poofWlO73zGG4CFXq7yw3E8Ov1ADth1EAW7JJezs7wn?=
 =?us-ascii?Q?gOpP1QIoSD2amw8NQtFQGlvbZavTy4ai2wqOOM8H1nQ4vgKYGw7E5JT+Vzxk?=
 =?us-ascii?Q?lqYBXVAtbSyvcenAPqy64MIg8y99ZTj0KMPMetOncjTqeJT+kggXAk+07w8n?=
 =?us-ascii?Q?a03kqLNpgT5qkxHLcqfc4lIlkqajxn3CZ+BTOguS9xmOd1YHvXGrsEaBPdAQ?=
 =?us-ascii?Q?ema7j6fD93eI9Ath4Ao5WAiBvyJdyUUrbPy/0XG/xR3JfSG1OILDsJ4rX82y?=
 =?us-ascii?Q?ck4/2bksMuVUPhAyp71O2YxT5uQ1lpO2lK9FeUj+gUuQWfiRZGNnCIfGLTRQ?=
 =?us-ascii?Q?CFahn05mlIWfOuXX5qbqmZvfOXzib+xRxg79uEXug9lBX539mrgrmCLslfqa?=
 =?us-ascii?Q?Pf5YDmo3huiOcAvRVLuBcyKQE2xiJPl4+zw+wvq1rdKuBtkdf1RPpFFujJUe?=
 =?us-ascii?Q?XqO5UEs5aCBCVa4+u613sLdE0re5hfHYZ7L8oJSxOll3a6B32GLYQGOvXiSk?=
 =?us-ascii?Q?zyiRnsW9h5kx9xTY4mGK9R9yuCNgHhrLm495HcAae4IvRh3HPtViQo0Sz6Be?=
 =?us-ascii?Q?kDVkeO8KzkRSOE7HGD9Miw1KSVMEfthw7QqHa10vnReN6NpCL1KaTmdQE6MH?=
 =?us-ascii?Q?eA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OYhqQRKP7a+5K1ePbJzMpA3dD8EteTa+8iUJHgwujJ1Lmbb0FaotqPPHmcSHKK2ajau0+ZfBsDCfswZGGYY/nFcf1DSwkDpuGxhScQ7k4pntU4xuXhgM7/y+OUvkcEE1otzw3cqC02MmEjpCSBM1DKlLlsYOoefaHxmHmll0bnqPJRpTsbB5ED+HbbQ5Bxaw3JsA4qaTHEpHlZ35zDAipRt+IO2lIiEvrUq2f6NI+YqznXYA5mI7Yspu956H/dB4vl1TAD2ho9s5Z0Ieb15772fC3+WnxIgZUh4KM9hmA9fdDWisBxgflFe0847kmaljGUJXBXLPZttBMKxCCoIHaeVlMnQsZur7BZRJ6WDH72BG1zw4/lpVrcx+E4hR3pw5H37snQcZ1qHtdfnePur6sXtTM6T2SKGizWorLHEb2kTqeCrdeYvQsAkQqk2qLju43tk4PLgGC8oWvZ0Vs5YY4sygI3pZ2j9iD5+dXiRArVaP8TT79ellZtvwOdRDVf5nap0H4eAldWUrjsdgq7t/UIRZznFGWkYB4ab1Gh8G/tb2Exp0yME7sjkbTVHAex1jJpTdeNmGCC14H/Fi9Hj+rilFlQpAvszkHE52opCGbEM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b7d1066-34d9-4fde-a2f1-08ddce52fe3e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2025 03:50:00.6204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GLLthsyfz6c5lIENPM2QG4IVvGjRx7FSbTqmTRFV7+ZwHP/EuaCudko7cTKUrabvQ2/pdhPc2BHf15J4dMAFj1/ZkxPcZX/eMMCCMZ7zfeE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7461
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-29_01,2025-07-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 adultscore=0 mlxlogscore=993 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507290026
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI5MDAyNiBTYWx0ZWRfX3gx4JN3Hesji
 euLYoGf2oJtBFiB6/2WSX487v4Kmo+HSs4Hduyo3WFBTpT8VG2gFw3ibM7hS2trs/Amk9c+5HM7
 D2ThoXPFwO5wSmPYWL3OZJaRfDYjRZq8rYS9q0cT8mMo+YzWOs/ow/Gk7/byp5gPALuEyBObvaM
 npaOOv9/rGDGzlrfSmrAxG66SfD6ZhrUDJTJ0f8w11fq2oQZ3EHbvFo55jsZMw1OcEyBhpYhCUl
 Xg+GW3R4udUobee72lFNpSQH2alUz8wQ+PIYfXiDAAzfA/FbdGh/m+9Vk5niAi0qt30/KzWeAKr
 UE4uBhrPyKyXxkjodBFalNebtHu6XkxrBkaUf5p0wZO/dDErNHJiCjHSo82UflCzBJzF8RcBNc/
 PRLp7AOOiWTTC3wkkfMiOQBvof7E84oOP7jTPLuYGF2W1t9MjYgDt2dJplzkb1cdFO9YBncG
X-Authority-Analysis: v=2.4 cv=ZO3XmW7b c=1 sm=1 tr=0 ts=688844ec b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10
 a=GoEa3M9JfhUA:10 a=BR-yPlzncgFgpTaWIKwA:9 cc=ntf awl=host:12071
X-Proofpoint-GUID: 81gc5uuQxh3d9lmKNYAuuYjR_cxkPEFN
X-Proofpoint-ORIG-GUID: 81gc5uuQxh3d9lmKNYAuuYjR_cxkPEFN


Damien,

> An OPTIMAL TRANSFER LENGTH GRANULARITY field set to 0000h indicates
> that the device server does not report optimal transfer length
> granularity.
>
> For a SCSI disk, sd.c uses this value for sdkp->min_xfer_blocks. Note
> that the naming here is dubious since this is not a minimum. The
> minimum is the logical block size.

min_io is a preferred minimum, not an absolute minimum, just like the
physical block size. You can do smaller I/Os but you don't want to.

> Storage devices may report an optimal I/O size, which is the device's
> preferred unit for sustained I/O. This is rarely reported for disk
> drives. For RAID arrays it is usually the stripe width or the internal
> track size. A properly aligned multiple of optimal_io_size is the
> preferred request size for workloads where sustained throughput is
> desired. If no optimal I/O size is reported this file contains 0.
>
> Well, I find this definition not correct *at all*. This is repeating
> the definition of minimum_io_size (limits->io_min) and completely
> disregard the eventual optimal_io_size limit of the drives in the
> array.

opt_io defines the optimal I/O size for a sequential/throughput-focused
workload. You can do larger I/Os but you don't want to.

RAID arrays at the time the spec was written had sophisticated
non-volatile caches which managed data in tracks or cache lines. When
you issued an I/O which straddled internal cache lines in the array, you
would fall back to a slow path as opposed to doing things entirely in
hardware. So the purpose of the optimal transfer length and granularity
in SCSI was to encourage applications to write naturally aligned full
tracks/cache lines/stripes.

> For a raid array, this value should obviously be a multiple of
> minimum_io_size (the array stripe size),

SCSI does not require this but we enforce it in sd.c.

-- 
Martin K. Petersen
