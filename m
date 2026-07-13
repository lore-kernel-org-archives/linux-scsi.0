Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA857262B
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2026 02:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783909032; cv=fail; b=iIwzBAphxiAm/kxs1vtLOXaQWYYdYVnE/oywX20JA+tErWbXK7cOEZfX4vPu57FYq9L+hKXUkzCZSQhQcVxOnomaQHqmO23tQTU7NKDxKva1C6CAc21YxDg2C8HLflUQ9xPnFUuIom5Ad6fLkpr/F/MwFN6TuyRwrR578kYl244=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783909032; c=relaxed/simple;
	bh=4hSE20e2/IK6605s+3Rr5fw33TFL3hiK2CNifeAPqug=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=dEewQooFweq/NT3ZVQw0qz/kCzlY3som0GbuDLQ6DShQ1X+uys+5nxHrG/XlPPBWdvgMTwICHzY5tNbxDQ63ERaWSneu9WYtsOUZJzW41rjY5BXGX8Sn6HX8jNA7BgfAKxWjmLPa3uAver3SVFKh1xJWRMIP74/7EIBS85rBTnI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aGdjO8i8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=c4K2Wpae; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aGdjO8i8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="c4K2Wpae"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66D0oT0f235392;
	Mon, 13 Jul 2026 02:16:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=F8S4tg5hmH4IGztmM5
	kFNAIBV3koQplGcpJRoJI5luA=; b=aGdjO8i8njnjaOQRGjWSPy6VB0uxi3mBN3
	RioQDqj0VVA2FA5lo+lvLZTYuuFm22Fhd6g3DqEGSLv2/7jNEhuve+6YbUaHT1mw
	olP8sCmEhFcVFM1gLGA7PjjsGwdyyWZDiXWoMqki+ZLe28ptyGjuahUszMRP3+TK
	y5BNNcF92btnngw9BZ8zx5QnQ1HafdlvrhGIPiw2rqNIMES6eK97yJG1q9veRrkL
	EsRxBqn2MwuVmf611lKkE1StX0ynzzkoVoHcsU1ObayLSjYB59tlNpj2SnKZQH4L
	a5Qp9Y4tfh1+uPaAPxU19Rii50YXdx9hm8zhPuDH3JIDi4L3VB6g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbef0sby3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jul 2026 02:16:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66D2D6r0040910;
	Mon, 13 Jul 2026 02:16:46 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011058.outbound.protection.outlook.com [40.93.194.58])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9c1n5h-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jul 2026 02:16:46 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q197n+PSnvFFYZwx5vbU3fEMaMyExmk4FLtszHPDp4bzF1zAnNTReFVnZ0PZIEcf0b/mGEdHjOlQh6RiLKer9jWOAZ1fVdPTNK9iZkHtgU270VNHSU/QrLPBKBd7g1Fhp5k2C6RKSKxs0DECGkV3uxyPixltMgdmCjaJ2Rm7QujXoyQpMrPkhkvKWuRzSw/G6iOcEk9/6kFqQbYGKj0mx5aHUZKB0aOUhFETg9Tc+18j/d6YImNB4GdNAwPYy9KG7JBTJU2AgvmnTwClMhveeeQhzGhn1smMpdo+MtuZGU9sFb2hsN3OIzc1BeKJy4x9wV7tocS38egteHMM9RC9Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F8S4tg5hmH4IGztmM5kFNAIBV3koQplGcpJRoJI5luA=;
 b=NKhrUyiN3Aijbgb6WnBxuLZjlmn7kvorvFFIfnI7ZLUQcsqCjvZEXWYI3tX/sSqAk3mm2TMXZ4nJhDDzBVp44Z7JAsGyPLRZbUl8+gpbkTgZ3j8iV8kS9thk58M7JAZ8TNvUUmiwgyJ1Bot9sOdge0Ke/dycBnT7JaE7YKastwGHx5BETa+r/iW9n2VxX8IQVfyiqV7prVF0xZ0eZo+adDACaUKlRXVNDjzbtXb0cV+bEANTSXcyoasDOXjhSEf8usnQQChA9q1rXXGc+jROfIBSzauvrzGtgQ76Y7PY5hmlqMDBY0TJEPdEWwpjkuOll+IGNfZQh8rAlQKZlMRw+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F8S4tg5hmH4IGztmM5kFNAIBV3koQplGcpJRoJI5luA=;
 b=c4K2WpaeUe0pdOw9QFd2jvo7ChVv99eU0+GKqQ66+pLR214e4ZCgc5aD4Hzkjwg//vopfFFEpRx0JCf6m57YSrxfohVa22oVO8QOUq69YNMznd4x0auWmCETIxw3HDw/FkrviWT12ae6/9EM6p/BwubwcIEYhbyWSavT/vhb5f4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS0PR10MB6872.namprd10.prod.outlook.com (2603:10b6:8:131::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.22; Mon, 13 Jul
 2026 02:16:41 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0181.014; Mon, 13 Jul 2026
 02:16:41 +0000
To: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, me@magik.net,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Kashyap Desai
 <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth
 patil <chandrakanth.patil@broadcom.com>,
        "megaraidlinux.pdl@broadcom.com"
 <megaraidlinux.pdl@broadcom.com>,
        "regressions@lists.linux.dev"
 <regressions@lists.linux.dev>,
        Mats Topstad / Intility AS
 <Mats.topstad@intility.no>,
        Daniel Fernau <mail@danielfernau.com>
Subject: Re: [PATCH] scsi: megaraid_sas: fix PRP list out-of-bounds write
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <b8fcdb5e-f2be-4bd0-914d-d03e87af9630@leemhuis.info> (Thorsten
	Leemhuis's message of "Tue, 30 Jun 2026 12:26:36 +0200")
Message-ID: <yq17bmzd5jr.fsf@ca-mkp.ca.oracle.com>
References: <GPhsSM0vkgyIrs0DIZ62qeUZX7X4RxwQXVKiuvMx-lHQVSPDxpztUyQOGS0xikqvJ-Z94hMV-dW_5KN_0CX2hsfV7kTf_t0MTf6vdAAaSEc=@magik.net>
	<yq15x5lowt9.fsf@ca-mkp.ca.oracle.com>
	<b8fcdb5e-f2be-4bd0-914d-d03e87af9630@leemhuis.info>
Date: Sun, 12 Jul 2026 22:16:39 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0023.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:85::19) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS0PR10MB6872:EE_
X-MS-Office365-Filtering-Correlation-Id: 94330522-fabf-420e-efb4-08dee084c71a
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|6133799003|56012099006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 9rQdP3mH4ZnbzluS/ChWRyI90WgRpyGHnV44glGClfFJ4qYEJqLS4TwpVj3nWgkIBJ50C/coZSlJhQPWDZiYai9tG098JDCWAdiNTbW9T9P+gV8poK+CExg+HCZXo+ICDoDAVjWwqUve8K1z3cZcTdfsePa3X7UH80B4QC5T5nR5vBXitMmVpz0OeNeU00DmKaLtkVW0Va+EKcFDLGMk+onG8FGzRNBv7NA35l6xPtJhk2+yUuBftB5s6hJdBPJ8BQZuLH6htSWnZcNGztTS5h87UoO2PMXcSylDZvY5m0jMJKU6asXyf062duN+Ky/Ze1YuPUh/Ci85tDJgI32R9wL4KPjO2h8o+m/t7zrVvGlijmbjXy8ZQBq+/78AtVSYo+mDvkY0E5FMSe2wNVOczzxfQAi9YeoRN45qc/zkzUTTmenSVApMFqfDmD/3ixQ7Ha8sNYhiZYlTlnFHhk7Ey5JFVu8VGbM6vwuSbYBx9yzkcdW/iaZ0vBELvSBPqjAzkemSw5lBapHyzbURUhWGlzhwXzTJWL3mQDXqsIwugORdoLENQT9lenYl9w5vmdriorNi3ud3dy6RySx+rrEB08Fpda8rCm19cDrT09NFsML5DsvTlmn50uX/RSfh91V0RJmAEhlriWa/t1No5ywAxA5k0XlxoB5tDPe5g37S+T8=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(6133799003)(56012099006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?fk4jPtR12InfCnFxSCI0rwiHqj0iKEBBWGmkxuuRMH0FaFBbkSCAxUSUMftF?=
 =?us-ascii?Q?uufhr8RMFNbeKhR5gsH2zVjYduOtirkSJxaaqhHwHGtLjm2h7zo2OWqWNQxD?=
 =?us-ascii?Q?Sf3VHBjfpsCCdUF4xfYE5uXyrXpg5auAe07msQ+byQp1nTDSKfnXDnrR3wcl?=
 =?us-ascii?Q?NACih9YgHzR8tMAYy33DLEioCGMX8wOFy+OmwuMPzVLl9OJWK7lBceooFRJ+?=
 =?us-ascii?Q?+3KUgBIJXLBJxfvfOd1e6nL2s5wvysBrDujaJ9DNGQVEHoI6c4gsKvyO3gQl?=
 =?us-ascii?Q?eoS7EpEep2oC1h47J9b8bAw3TP5bE2z3+h36mpuelJ4rIPW5fziCgQ+9AbQQ?=
 =?us-ascii?Q?7wsKjRXdvnS2IbfLGNGRMmqhIv+ANK50uDqsd3uWZR/3z6M+prM3TsgTPZ23?=
 =?us-ascii?Q?rHPIsL9nTo4JXGTNTYO/bM57wy7MwMarYxzzez3O2sq3OGA8qMlBBsedCvGt?=
 =?us-ascii?Q?aH85mQGY4QzRcZU/dNZcnCc+pkUBI0RtB9nsK1K2h4230mJgUEW6FSdw6Hce?=
 =?us-ascii?Q?dX52a53G1X5rrT8J7Z1ThaVciIBC2SkdzVhjoDHvR2mlJl986MyYuHMn7U4G?=
 =?us-ascii?Q?zx061BxUnF9UeRMev16D61vNT8RFqHTine8BPyBKgexzg7ZF49917CpMEYC8?=
 =?us-ascii?Q?tENiaCXsczs3Zn0epOFyYSClTN6yD8UtftaeAAoAhdkzFD9LMtaAlUPnt3FA?=
 =?us-ascii?Q?0MhCFcr67tS6JpCpy/bIzV3bRg6qdhWMJzVJSl6n+W4hYL6Am/3dl3+TWOFH?=
 =?us-ascii?Q?McbBctrRd0cPeDv7w/0To3SEknuGLGvgvpVd1YXOL7myTVb6Em2NEWjzJ3dM?=
 =?us-ascii?Q?N6iWQ/VHvh//2ZdRYBln/02anxxmA8v1rqlzL378ARXLCu8IFW5t0zl5qkIq?=
 =?us-ascii?Q?GhCGLnT19fjaTVwO4FH3zPidit2WLjmvm3/rGXOg0wmlwrw+qDOnhPorQDM7?=
 =?us-ascii?Q?Q2U3Ba2R+AuV42EXEH+lFXXlctomb78Ha8MynmOKUQb6UPxtTfd7cCVIIjvn?=
 =?us-ascii?Q?mOeTdvsPbb5ruXNFDS5SgneoMixXBkgpYcNF8TNPIjhKRcWkr8fWAiLrJBv1?=
 =?us-ascii?Q?qxgBVHPHOZOVl11EN86euLPoLknOi08VkNpgryvuEy6O3E9Gm6CnVjGVJW5O?=
 =?us-ascii?Q?Qd0YWELu4QSn612gzBkFhQL5dT3mPE5CSYtWOmOUYlnKi768q5RNPQAirPj0?=
 =?us-ascii?Q?g6hTepXl7luO++obRlSmvRHKTHvO9oGlm4BuFLQ5ykuf/9bAiqpbDUwbdymM?=
 =?us-ascii?Q?pcxA0TWbq2SsMi9wjLFqN7HWGtH/NKQ/8TEXhxw4/PWgWsulBxNu2wM17vlb?=
 =?us-ascii?Q?MWliEiSM5U5imhbUxjQXXI9uIFEfIg26Lnb/RHxxv+udC72S/AL71XAfCQCY?=
 =?us-ascii?Q?OptSi8r0br5tF/v3UbZBn6a3Qcoq/Ns+Vi3HWMF/sKaDV4nPWtl+5fNjRq+H?=
 =?us-ascii?Q?D3+5crWpjI9fDTdVe3LD19n/NuRg3vSSu6L+/PBWdu4gMXyRRHH6+2I0DrX3?=
 =?us-ascii?Q?NCtGO9dOAHz9YOM0ABrVsV/7I5401I2KkhnBdxCtSxK7kjLFennO3Qg0b6SD?=
 =?us-ascii?Q?p5PHoV7z0Ah8pbLh/3KPqFWvVqX0SchvY9QpipP2O76dmu4LQ7xXDuv1BJgJ?=
 =?us-ascii?Q?zDo8eWI4AWdr98YNJ9D0MkTtIyX6DCO8kt2v2kXPCSc0XnIG/tmRPYEeGvI8?=
 =?us-ascii?Q?mASxo8F3j0RX/GIYF+sJ+Ts7cWoUUR2eSj6juCl0b9vdNNj+xFsbakhch5wl?=
 =?us-ascii?Q?lz+t+tDf+7f0m8GdemU/faVWkNTRp+A=3D?=
X-Exchange-RoutingPolicyChecked:
	dRZQz6o1MQelt9yYSMkm4TlD2DeNaLZrd+mBrx7U4VEKTqfxTuBZL9TOb6BePVhSzmVCXh2Ak0nxxzIjOCLOOdGX1Z0FMbWrxephW3KFExyXPOL0qlo6OuA6bDSxSFKvSj0jCVrvXLpSdlRzOlaJHMnWXDfvyqStgnQZpYzg4ajozWnyB+WvIoENJKVPJGFMTUuy/DXurS6iNqYQ1GkI6D/CjWtcFW61Z5v0e/XmCeTOkn6xZz27YLSbXwc//hQCsvbIxW6nP4R6OdACccsyqgQ7KiuxKfGJ5unoi2VjgkzkQdHOJ3T7i5lSOGUmGnvuBHW8rNM6wX1b0Ql2hpBCfw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	D4NLhykU+AKN/t7ENmSKqhrItS3RqMAhXMJTN0yc+MgwtpgdVA/aBDjzyWuVgCjAAQDZdxAenyKK2S/H5VbgXGYDr3UPdjWhNrfoSRG7ElO5DexzDIlAwV33nM5GlqpEQj+Tqv4i93ce+oa2eZf9sPwfJb7s8NCy7Ol+zEPAy4YJMPDvvu002S1Wyhv+AxC7zFd0PmCQf/yOSjZPEjts5Emxmw7+K+YI6vVvBiNnTlPOGxeftmynHEXXsqtuSzjUzPlVmSQmG365zY5XyXHihtKatTHiQKNMmhxeVKONdiq86SMRFek5IxewI2mUkqmcAHkRN2f9sNn6tNNvnmCL4cvUBO5rAsSJqe66FA6vwaFO9/JH8C/eTBzuo6AW+mJ8/kh3e5gLQRzzBpyaiktc6sqMI+S2jOoK00nxjKzAyzmkIP/rLPI6s+lbWn1UuSW3ow7pJLemSkDByCDun9iDmR5cKcA0URo7XX+wKmECrfR7NWEoS6HE5v9Uq4BdBugddeH6d1E0RqvXKFjy8jH7KdR0pRdSUw7vUyT7N84uf6eTUoYGEVwMz2uo2GRzPtwJ+a6EwbdDN4CWbxflcLk4i2ZYgUWJ8VSKFDb1mjNoKEc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94330522-fabf-420e-efb4-08dee084c71a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2026 02:16:41.5918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yzJozbJfiXf0Pn7XKH5RAT+ZErEPKSW5lYC/xG9YUObdZ9pXWpfrCWmccARthPSXTbv+7Pw++mbuwY33/+8MWcNFOuH1jMa33z28iK3Sryo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6872
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-12_08,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=999 bulkscore=0
 spamscore=0 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607130020
X-Proofpoint-GUID: CIV6bn_rGDytTZTI6rHOPKh26amVJt2E
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEzMDAyMCBTYWx0ZWRfX7AkyUQi9KQCW
 pAaXc2Haz5OnT/9EEyb/NRtjP5h/P3y/FwGyrqGC9d9+/vVgfqiZKmcTuON4kh+XZ0MY11r0oNZ
 djST9+GZrpyBbxchm0DU9BnOI2iBkjE+MbQCO/g6HOffTzRT466Z
X-Authority-Analysis: v=2.4 cv=KJZqylFo c=1 sm=1 tr=0 ts=6a544a8e b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=9FQiX2dcnwdcGL2xIaMA:9 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEzMDAyMCBTYWx0ZWRfXw0muOlt2aN+k
 l0TWdKhFBJo7My2w4eMmnYo2rJ6ue/z/ZzW5FzFbthJMybBFAyWy/WVA34urgaGIItPFSOY8uK/
 PO+2HToLk8Gf1tSfvrc+oqvSxqoBg8oXCN6eAejYqqpeEz9ERIwoawHZlJ5yLrKUQLa9NDyA50V
 WBPnDD09ds8p1D9ev5aw2gdvbIQPPck2og2Dpnq8fwPF2n/lH4prBDnFhYGGTQieU1R+nWfzyK3
 yWhqfh6AYckH8OhNNYjm0dreipMzNYxK+kwxqeUdQnByGWAjR7PN38bEn3Xl+BK+wv4OXM43Oxn
 ZndCSRD/3UbF3D/EB8MRO4PcTAabjKwdpC+ghiZo9MNf6iuMULwgRD0GtSxa9kQILU9OwwZl9wm
 Rs6Vz8Cxh7vBoVIrKMFrneOfL3QRkunZpr/5N3P0R52W/rTM1qo7i+e+mnps4nQatxfCQPuINRw
 3K97rPFdbXkJzXaRllw==
X-Proofpoint-ORIG-GUID: CIV6bn_rGDytTZTI6rHOPKh26amVJt2E


Thorsten,

> Martin, do you know if someone there ever looked into this regression
> and the proposed fix? I'm wondering because Daniel and Mats reported
> problems under the same subject line (in new threads), but also didn't
> get a reply.

I think this problem is just an unfortunate side effect of the kernel
being able to build bigger I/Os by default.

Typically NVMe SSDs report fairly modest maximum I/O sizes compared to
SCSI devices. I suspect this is why we only see this issue with a few
select models. My hunch is that these drives advertise a fairly large
MDTS.

Since there appears to be no traction wrt. fixing the MR PRP vs. SGL
chaining logic, I wonder if the patch below is sufficient?

-- 
Martin K. Petersen

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index ecd365d78ae3..b93a6d1180ff 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1978,7 +1978,8 @@ megasas_set_nvme_device_properties(struct scsi_device *sdev,
 	mr_nvme_pg_size = max_t(u32, instance->nvme_page_size,
 				MR_DEFAULT_NVME_PAGE_SIZE);
 
-	lim->max_hw_sectors = max_io_size / 512;
+	lim->max_hw_sectors =
+		min(SZ_2M >> SECTOR_SHIFT, max_io_size >> SECTOR_SHIFT);
 	lim->virt_boundary_mask = mr_nvme_pg_size - 1;
 }
 
