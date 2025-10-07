Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE41B7464
	for <linux-scsi@vger.kernel.org>; Tue,  7 Oct 2025 02:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759803934; cv=fail; b=B3O0/XDgdlKZ3qMbUOM9FZ6SKml7XFo9L9GIkoeMQkx7lVb6ynG2y8VatytlPF8tDVjAOg+AXHYCPvOBnThBuNFE3YoNCYqc/uqJ5hRraQeeDvqcOWziKOKUm+0rbuwwm7mc3EM4POb38PbtNdn5xjEV2dvE7UHxJKJV0cI/GGo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759803934; c=relaxed/simple;
	bh=CSmzVWOGLITpK1xVOW8YS65t64S+mB4d9Z6fckiCLP8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=X3Bxutjd6KYp0WIqVQmDpIAKj4zR7aF2V+qdhA3YjdaKVtgWNRbT5WNiaz4VKYYnN73W9xJDzQQKE3RlUNcEZitkCFI7WfPi+xGMC8oJUX8Q5uzyrtc24Uy7w8C6yh+RgwYYAZ6gvy1iPEUxYGnCFJKfZr+HkVKulyeF/Atd/Lw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kOO9llNd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=czgXBnLy; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kOO9llNd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="czgXBnLy"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5971oHLk024398;
	Tue, 7 Oct 2025 02:25:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=sXGl6Kk8tuGfvRsntS
	+NwIYqAcukMFU5RGj7ELtzt3Q=; b=kOO9llNdZhwG6IknhGGVs1IVdBfC6ZSZ5i
	r84OgiyGpmbqoBh/oOZg4Cu81HVAXJdBwv3tVYowaiNZn0w6ZKWsNIumi4LwtA+v
	azdXpkfn1zKlWDPde/FuMNo9nr887g1S593w8SbAddsrEAOhNj+FzGZvMcak3mf1
	lCq3+dQZYiIBftWqfsNZZ5uAxat64hSVAztYgUdisgCaO1qtfbhgUqdfamd8WfCp
	eL187/ASKcuPaEXvLWscrZO0+Wu/smUfP98n6Ot5DR9UFrnoO5pGM+6Sc8GIo21o
	2DPu0wt5yEMe1j5MevwtBv++vGyGrFiWH8gc8yi3YSTl77qT9KpA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49mrt7r2eq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Oct 2025 02:25:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 596NEjDC034843;
	Tue, 7 Oct 2025 02:25:24 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012071.outbound.protection.outlook.com [52.101.53.71])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49jt17knyf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Oct 2025 02:25:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DbQjCdoEscqkmjPQo8Z4YF13GycmoREbiuPYX7PHqHpVpX9CSXMfw0/qs0CoUFbq6jWiG0U3AvEuuZoxzize9idtK4XdpMIUbhqI4vhA8A8y3qAFAFKNf5WtdCjVaMExDYpVGZJq4LmuYWfFdqbM7jcg9RLCvaOO5f8bt0Q3ux3wzQPOukknRJKVVpIKXdeu9Lor8oKSmPSf+clOIyuv8k77/7bJ0f1ZhLwF98gOd7/wStUpGWW6rxBQi50OOP+qf3vOqblYKL/d3BXBXiDmUKb2Ir207eHAgbFygiMZBQPLwEmc5gfIHiluwbgXoAvP9om7mVm2J7NPBD6u8XSsoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sXGl6Kk8tuGfvRsntS+NwIYqAcukMFU5RGj7ELtzt3Q=;
 b=JJTNn/sn7rOX7RV5v6ejHA/epjm7A5TefCs5MJPROSasEJzWw/XT339J4M2Wq6+40oO6v4711hcsRfZp/lbUNemBJjVd6fkN3Ohkfbc3iWGqe7sAuhe3rtzB/5lRi7QBY4BvzIoNeOxnmsGrlBixMe35sdeU2/WkL9lqWAeiq7uvpRs5OZtZNs8NKIdQF8pOEzlZsrnq/cJKrD3yra7qKh77zt0X+5yTLaW8BnLNbL0tonh89PuUQ8razlekA+4/BQjkaQlkDskZ2T/Yw+2GvkEhNVhhvTDNZv+9c1BXeKhaHryE4CEXcEO13OB38ettNRhGAfwRFQ/C/qtro3C1Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sXGl6Kk8tuGfvRsntS+NwIYqAcukMFU5RGj7ELtzt3Q=;
 b=czgXBnLyTMoEn0gsRzrverEuZqBh6Di3OJa++d57GVNTpdCV77FKRWy04s5P8RHvnwSzYTUBCU/Ezs/VzO4jLcpZs2Xav+Dh2tjo+RfwfLANMwm23CIAUiiuasc2YYsOBaK9iZBH6t36onCV3XXYu30NkDaUfOOvcKa8D612jxs=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS0PR10MB7270.namprd10.prod.outlook.com (2603:10b6:8:f4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Tue, 7 Oct
 2025 02:25:17 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9182.017; Tue, 7 Oct 2025
 02:25:17 +0000
To: Bartlomiej Kubik <kubik.bartlomiej@gmail.com>
Cc: sathya.prakash@broadcom.com, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, sreekanth.reddy@broadcom.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH RESEND] driver/scsi/mpi3mr.h: Fix build warning for
 mpi3mr_start_watchdog
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251002063038.552399-1-kubik.bartlomiej@gmail.com> (Bartlomiej
	Kubik's message of "Thu, 2 Oct 2025 08:30:38 +0200")
Organization: Oracle Corporation
Message-ID: <yq1frbvforp.fsf@ca-mkp.ca.oracle.com>
References: <20251002063038.552399-1-kubik.bartlomiej@gmail.com>
Date: Mon, 06 Oct 2025 22:25:15 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0145.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8c::11) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS0PR10MB7270:EE_
X-MS-Office365-Filtering-Correlation-Id: 12ef1996-3306-49ce-abdd-08de0548c12b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?779o7+lD0uLGl4hqHjVyCmmbUHE6mMO12Y+1e/LpofJ3DP3s6I+qhPtVWj3L?=
 =?us-ascii?Q?HUrMjLBZLj1/rtAMxzK1iVgXKR7MHG7NsopfSB5WyE4oEwki9Mv+CqiPKBQz?=
 =?us-ascii?Q?OXvaNfKAu9vILPqo+rsFFhsVEJ7YnyAPYslhT/OTZPcjGFFwV8VfPzll1fG1?=
 =?us-ascii?Q?F46VZCKC6DTnMYp2+aCgMkZdXz7RSabmKiTDPR4VStm9rhaM6dWXQmo0a6mW?=
 =?us-ascii?Q?x/YomDy2VrM1sSvenZxcPYyqKuj0AbEYIz8Pn8Z5WngPzZtW7z7+BKTDyb85?=
 =?us-ascii?Q?WBTRUbWCc05Ms/VpkxIJ1wesHGOxD9QvNtLKd4AqQpEyZHr79PykknxAMCto?=
 =?us-ascii?Q?5yytwH9HuUZuX83TXOga2f34aZMv5A3gCYErbuOasGvWl1RJYJW93+RltoqA?=
 =?us-ascii?Q?CUsI4pj8dSQ/vVq3FJfa4R28JhqDoJe0eSWbBevvmDdcdwzk2Rc0fLyaTX70?=
 =?us-ascii?Q?sjuW0If652iQiOxndXlxISLBMDpTfjFo35TLrj67tLrrhzzDS30vG0tUsV+e?=
 =?us-ascii?Q?T/9w5+t+ACyD4PkP9cSvePLlc3OJGLSfq/i5XfXogt4RVt7DOL1n5E3EXiQm?=
 =?us-ascii?Q?hBf0ewIEe8oCPeW1+6jYQAuQEfSu5uWf4W62yml2yPCLvwJGsQk1mnH2B0km?=
 =?us-ascii?Q?QaKmflbK+vMtTEFeNuQ9DJ1CRBjSJct6ZuAQk3tzxuXAoCfpAidAcPpF05Yf?=
 =?us-ascii?Q?WpXzo4EdYtZMyT8GAoRuqh0GjGjiEky6V9moxH8hVbx6zCceHQlZULVkHpkS?=
 =?us-ascii?Q?xwPFYX5PZJxYuRI3NwCN9iFixfSFOUIBSalD1Mx/GjohbTOaMjYy0YNF7j9N?=
 =?us-ascii?Q?Ua/TzBOslhN1c5gRlbfTEtfakemTIwXSFKN7oNNIW1JcM5xCdPoEUaooy1KA?=
 =?us-ascii?Q?YtVyBcfIkEm16qElQL0jXEnIeLNHhDrH9KcvR9nVyDobVG9rKSICKz0ru1xf?=
 =?us-ascii?Q?1yqgRo13zAFS3Fhk5x+zwJRwpX+Ava5BfYpMMN9YL+SWVnjIG2HJWXCi4MmA?=
 =?us-ascii?Q?875ubCyHZqISME6vU9Bev3fVyziwrfQEhKsN6tjZIKK0FeT+8sMHAZxqxE4h?=
 =?us-ascii?Q?dlbzrrR8xC70tS+Q46CCP5GR6r8NYCawh8G76yuJtYfKaqhZRnfOIJE2Vczn?=
 =?us-ascii?Q?bqO/DrmgBa8RLLBbU//1lgbxxTMpl1GoEcC/EU5wTzVRrxq/+xyhbJbkxIZh?=
 =?us-ascii?Q?yFKkODBwi2IVL9Khqa4yx4GN0vtSQ+0vzeRcRR2E9D5iJNOQtuzvBqYUY9nU?=
 =?us-ascii?Q?muTTo7lN2gGEkhFB8JlgGH33I4AKM8XL1q1xyCTBAfu0hBeh93QYbBCveXkM?=
 =?us-ascii?Q?x3S2qYS6xDn9js+kZByIxxt46a3VIuoCMfLAuoYAEQjkyjkh0xk3pHnEWRGc?=
 =?us-ascii?Q?CuvPEqioZt960sS/zHk5/U1n4PlpYk9+FkMWVKt5QvpJbyJ0Ze1d2jxLdlkk?=
 =?us-ascii?Q?8FoXzS5JeGszYVcll7QAHuBl7EVkJw10?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5SDZzTM0kOdBSczFYZi3yyl8s3nU0HmbsfSfpIeP3OEEKTAJ0JgjIeFWUNOG?=
 =?us-ascii?Q?7H9ICShRsFf7TwQNIC9Cuvgtg2r7FcDs8Uh3+r+blukSfJ4EUfiH4WIMJIbr?=
 =?us-ascii?Q?+uGuwCW/dbfKnFUpL8CDSlj5quKwgwYFQCK8asSVEUH8U82oah/EJIyeJXTd?=
 =?us-ascii?Q?a/RL7QZbs0OlKRHYTbFPWrKC8uQm8yvpBd0SSx5Os0xEG0ak3cKtwbN7e0D8?=
 =?us-ascii?Q?G4Lfaj8Gvvh3uYNquEZyYgucRpW+2CRoe/ohGY045Q8Z9Zwr85vkj7EXQykB?=
 =?us-ascii?Q?AHASgNc6Hk6S3JFHhX90DliJLEA8xuspJHOaGFg0SOeLjCSnUG6DF9cp65D1?=
 =?us-ascii?Q?4FVKp0kVB33d7QopHFPSRuUrwShQWlMLj5os+UigKKU/NW8ZXOO2Q4ogwJKb?=
 =?us-ascii?Q?9t2dph7r+9WwOz2ebg00hFroPz2wekcFIojcN3G7GCEVr6J75uPi4e3KLRp8?=
 =?us-ascii?Q?ibyulK866Ggch60SO56g3cRtPhh4+8y8nQaEzcm36Mvx+HmixP+px8SIFWoB?=
 =?us-ascii?Q?CdQQW5vCpf+iSHCNIMe5fR1Eqgbz2jjQn2xMJkYJIM9P/SH/fuLZoy7kQ3LK?=
 =?us-ascii?Q?v+RXIfOENGjgGr/3bamXrbPdjnPadWllLEQWHaVT+yumNtsKTwyKpp99Svyk?=
 =?us-ascii?Q?EnZvAMuqCp4MU4UE3bhN7xVfjMglrSZsMS9ZfDuL/GiLpxm9FqMYM5zDm1Qs?=
 =?us-ascii?Q?h0Z0EcB11RPhF7ZDDyWwp56XWtd+WlZOfd+5KYN/3d0rcvF2cilHsm3FTxj5?=
 =?us-ascii?Q?WLxg2VtGEAz0Vy4NPPlVboAUu0TvFy8vWoYXmFWQrP6LWIYvwfJWxXC8wBub?=
 =?us-ascii?Q?1h7NIYrhg7abcSEBCwxrUdKZ2jJwX99GX1usP78XHwRPne+PbRHGFX7j6Qy3?=
 =?us-ascii?Q?c+z/5dO7iWKeoGIHBdTWc2316qsVBgDDyP5k7pDVoFmWh+pVjmYwMWMHf+cH?=
 =?us-ascii?Q?Xe1buyGgxNbUOudvcuVcbs3vA24aWycMHqsqCgt4bf0SgkLIjSMz00sVzLwW?=
 =?us-ascii?Q?lyjGki9DdGmhlMI4HdpETsB6xe5Vn7fZFJBKcAGBTEDD0JcRZTT2WWCbTedZ?=
 =?us-ascii?Q?SMPBe0bj7X9pFmDtAi0e/tF2eeEsUltkh3yLtsnst8dKKZjHPRAMtqq5+7uc?=
 =?us-ascii?Q?bv5juY0MBv5F6wy73nHfeW/6A0OVLXpsRBkFyJcEXKYNyRpWn2GFniB9awbw?=
 =?us-ascii?Q?BAcR4eEcbYi1jRqHiW3dd641zKtbJcyYqtCficHkdTp1Qr7g7DIJ4wjZJvE8?=
 =?us-ascii?Q?sCUij56jDFg/5lSZI0KyOf1DMGAB06MF5WMJDLik4WdcIDBRtVoWRyAQyX4b?=
 =?us-ascii?Q?elg3A8PLubNkoRpIml0xzCHBE8g+TqfpaM6DCMyeP5uqPKUPZV4U28OFa5X1?=
 =?us-ascii?Q?vGPLdAIwCLzW4HWc/WnpwPEZYZ+i6CEwOWI5JYEZXhwVKykgDivdjr56Lfzi?=
 =?us-ascii?Q?7vEoHEjXsJ0C8KjDLS6GG6QJVvgwbAbLcuD39Bm+VHbH/xciwDa1tWjCYcrT?=
 =?us-ascii?Q?RMeHvKLtPdunyZ1KhDvPAH37hoK0KG4dbjEWDIjeCtKGj3xxT28R3ttzZ+qV?=
 =?us-ascii?Q?qIq0CuDFWmUI6rIxISJ2Gx3o/2bwN+dcPJU2oaI1AzrbZukRtDbx7bve62AD?=
 =?us-ascii?Q?QQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	s2hc3Cl+kj2xuMupMkitT2ypOMiQWTheXK0ZbjqLEFsEOww5/X79K4Im2QoDufFCY5OkaxWKuMF7oGziSlzqsBrG6gItq7xsygpiKShbrOD1gQ/nH63OaKsQ/DWQ+6GiOfWE7FGrJfl4YipzO/Mxaw3S5Ac2kf25anmw4ENyI7rfQet6RVR7FmznkB9wjTwj21lLRl4S8+OQHNqztN+j9H4q1b7WF80PP6ny6rjI8ZNfNcXJ+qnGfJvFTge6ZTZX5v9WGNKcI8VB9LCU/6lfH/fvSIogWRJk/s5fqzEevV6RJCKLkZGBFTEGxAMkdvWJLK//xSoSRt1b0bGoYPQMhu7iPih1ijm92dB5gGyXdd0q4jE7XpDxE15gF6MD7bLsAbikRsPGvydExf6xcDsZYKcgQZwwtRt0C4XsQFQuriboxouHQZa7djmYiQVCIJ4/FMiM5FyimRsvD8dYWuD8J0hkVytW1ocS/hO+DmAORHn1YDwy9Gwx+X1p7bpJl+QrOeM8vdVlH8onxeES1Cq/W6Myua/5NnusooqO0lx5d8t41nZj9+3eD4BGsPyv85Tj/E2yMh2KeTVYjEdwJDCPGIeIG/r/MF3nyG9GfGKQM4M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12ef1996-3306-49ce-abdd-08de0548c12b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2025 02:25:17.1974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KwEgJujqTqiG74/TlMRgqtjXqpoGn6ZPL03dzSVKF6I9j2ZnS+9fJDDJdbE+91p3wpqFawbDSil667Cp/Vvkee2jb4Af+U6I2p9tSHRGqm4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7270
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-06_07,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2510070018
X-Proofpoint-GUID: SktA-7AX7VnwtfswCxKm66CR2etEQef0
X-Proofpoint-ORIG-GUID: SktA-7AX7VnwtfswCxKm66CR2etEQef0
X-Authority-Analysis: v=2.4 cv=SPZPlevH c=1 sm=1 tr=0 ts=68e47a15 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=oX0Ut7cakOUcYgtEO5EA:9 cc=ntf awl=host:12091
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA3MDAwNiBTYWx0ZWRfX206TAhOeqpq9
 BRNoG2fuD3FNYL+ceX0q2yAOxx7UgmlUeovbZmDylrJ3x6H53BRHMsriB6j5eSHCoar81Rca1Nn
 FYQWPRcnpaKx/IE6d15qeEJi9m0QBE4VBjpaOvUgVQ0JQZ6cQIYgIztG0IQoer92HvQU2aeAkye
 Zgz7iluW2Ip/yY+e98xmXGNOiHdv619BmmT+DC6BKVcfiwqaFIPvDrbWM/H5DnLVWfzshqRXak9
 5iLc3C8xVuaLIP3e9+QTAb9LyDaoFz2OFOMeCnp6VAfWVq/o8+VmwwD9P40PpiJbBtCVACorKCW
 Z4HZtI6r0WJmnd7+3CY3IpBGp/82CFIWhs7PSZpZ+fo5+19R8N3BI/t44JuHGx2ofha8RZnP2ED
 TJSs7fUQjOh0xzJnQbZaRnTg6UotoS9qvQUhjKT9mzAncGLpPAI=


Hi Bartlomiej!

> Fix watchdog name truncation.
>
> In function mpi3mr_start_watchdog, watchdog_work_q_name is build
> snprintf(mrioc->watchdog_work_q_name,
> 	sizeof(mrioc->watchdog_work_q_name), "watchdog_%s%d", mrioc->name,
> 	mrioc->id);

> +#define MPI3MR_WATCHDOG_NAME_LENGTH	(MPI3MR_NAME_LENGTH + 15)

Please document why 15 is the correct number and describe the code path
which leads to the watchdog name being truncated.

Also (and I guess this is a question for Broadcom since I don't have any
mpi3mr hardware so I can't check), as far as I can tell, mrioc->name
already includes mrioc->id so the id will be listed twice in the
watchdog name? Or am I missing something?

-- 
Martin K. Petersen
