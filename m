Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1FC63A1E81
	for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2026 18:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771958491; cv=fail; b=OaMqeivuN9WMNe1qtivH6h9JytnGiMFgUg2TzW5J6nptp/zFfH5n+nwD9kH5w/LtJ187YWe3crsPK6F+Xjfq8Q5M1Njeyxau4SkPFocyqhx+RCZRxuR5LxZo1Z3L6kZmuFDJXgg3I34dD7EJardXl6E3REN58jEH8zWJasnT7gg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771958491; c=relaxed/simple;
	bh=Go2mP4EkicWgNBMSxxLgkYJvRjay31KoGTNoV1cCnv4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=XmLSgF5+gKzfq7vWvG6Nq7K5FerZg7S5MW4QeyNfwx8IZFdhjoBopdTYEre4Xu0DEfAY71vHeMBfgPv4DDPRbPbslGwuQj9mFr2KqX+XPY673oZbl9nbTC8iKthmo3PytezgC88zpo7c7eQZRr7vYnt+qQEFGQTX287RdtlRcf4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OlmYpiwi; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cAs2PqJ/; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OlmYpiwi";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cAs2PqJ/"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61OEMoJZ087121;
	Tue, 24 Feb 2026 18:41:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=yTIZys8s0JQXKChBh8
	IzYNIgPhkvs4GcUt2/C9jGJj8=; b=OlmYpiwiLaSPsh79SFvYzJIFEVuCwo6PZ6
	kub1VHFDRIe5bP1qT1xs15wN2cHlNT1uQJcRk2ZPhNRn+EvB5XNwhW2IwaUfpDi/
	7/B48njm0Ef+K9H1CdG2LehfbLU0BLR/ZUIrnLh0FEQSo8b7donarJQAg8eWPtqL
	pgkROHYqzsNma6G7ayNjXgcrExp0swLVn3u72Ajexntw9shy+1q6Ty5dp2NeIKvU
	keq/UQxKlelSatjO89pFC8ujtEmI8X/Q2/H2NfEjaEGuEmspmEYHTPihIVUBXQs8
	/CVlToOtA/J+uW4DKmmG/0bxk3l8DuvY5TOzncGgY0GXO96dgUzg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3g3mv9v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 18:41:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61OHP0w2015595;
	Tue, 24 Feb 2026 18:41:13 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010054.outbound.protection.outlook.com [52.101.56.54])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35aav4s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 18:41:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JLKJ4IyZbIaMDqf+PqVYKHFZt0yT4wyCZw4YXQYHSH/zf/QFdfx1a94+ZHmFP8oXoHuu++7oQMYqx+6SaB0pzZn+b8r26gMJRju84VChheNLOJkJ65SwtN4q4c2pN5N61+ISHukLwD1x/O49UaEafFn2IDYtzB4jv5OAOlC1MmmkEXFOqlacvyaufmjAPDtJBL0X5MoUsPQuJJmSbgyOCw0POBpHuU/rCyrSRo0JlOxzkhnr4+HkgDgW/t+47B01LHCq1ALKzqonR3deeBShcFbBWkvlHQUOSmq4Dd7ddLUTNibyN3oyqOHJ0TKT9mxDqwZ+cHzi4bFx+2KkdbrCUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yTIZys8s0JQXKChBh8IzYNIgPhkvs4GcUt2/C9jGJj8=;
 b=bsGVmf4fP4/Z+I/XePfVxxrSGMjI4njCHMb2XjSpX2oKDiKseTyQByxOKrWh/s6oz6Bl/HTYY+V8gVnrM2EgNq3rDceDYnvRg+d98UiZssDZZmQjXecOHcoky38l00LIO69xakuSOIHHxTFawhNYNzxElMZHnPsiL2oV534JQF5hSwYSsxnUCKSgMNjdwBYZbIvoKL0G0IZe7A6lcV8kR6Rm+DDixPi0llTghck6ygPlH6UqQMb6UgKcHw9VHhWCNNBS8uTtM4ACg7fMQ1uMnnTIG3eBK5zq1ikNajxLGgFTKeD1pYlR3yEhihFdlRDa4zjNunlg8S8ysIAmBTLtDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yTIZys8s0JQXKChBh8IzYNIgPhkvs4GcUt2/C9jGJj8=;
 b=cAs2PqJ/qk/LddMCYjIIbwPfcXuRUjM+jmphQGACyjBGO7JfceCWonp9rRT3P/V65U4uhZL60+JnptuROr8O/TXK+ZWJjjrsvoq82wEpOwI12D8Ojv0taF57l3v/2Qhw7+nFpY0/yc0iYjlQA8hi0yzSjkgIXPo/n8ms8bUtZP0=
Received: from DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) by
 DS7PR10MB5902.namprd10.prod.outlook.com (2603:10b6:8:86::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.21; Tue, 24 Feb 2026 18:41:08 +0000
Received: from DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::21c0:ebf5:641:3dee]) by DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::21c0:ebf5:641:3dee%6]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 18:41:08 +0000
To: <peter.wang@mediatek.com>
Cc: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@sandisk.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <wsd_upstream@mediatek.com>,
        <linux-mediatek@lists.infradead.org>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <tun-yu.yu@mediatek.com>,
        <eddie.huang@mediatek.com>, <naomi.chu@mediatek.com>,
        <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: Re: [PATCH v2 0/2] add debug log for command timeout
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260210070837.1820710-1-peter.wang@mediatek.com> (peter wang's
	message of "Tue, 10 Feb 2026 14:41:42 +0800")
Organization: Oracle Corporation
Message-ID: <yq1ldgi7znv.fsf@ca-mkp.ca.oracle.com>
References: <20260210070837.1820710-1-peter.wang@mediatek.com>
Date: Tue, 24 Feb 2026 13:41:05 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0309.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6c::13) To DS7PR10MB5344.namprd10.prod.outlook.com
 (2603:10b6:5:3ab::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_|DS7PR10MB5902:EE_
X-MS-Office365-Filtering-Correlation-Id: 37dcbfa2-85bd-41bd-ed12-08de73d44632
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bfNKYdPCDGhWZW61izUyBrSHZwSlfqVvyDxJ4GoPdcSnq11H3dVgo2jgNXdL?=
 =?us-ascii?Q?by3btyVhsqP49MHPiHSNXX/v0fTarVlwF4vOJjzJEH07+U/k+ByAppy/A8P4?=
 =?us-ascii?Q?S/OKU1p/Vzrk/cd4exjXfM7SHdvllOZXeXarDS6wMF/Bz0krNWnEeF+mw+60?=
 =?us-ascii?Q?Jvqn9FCo/idgxAhyzE24TZa3p0vr0JfKp3RODOgJj7LJ1z1iawUawK77tvpi?=
 =?us-ascii?Q?bUqAGOugiLYPcFmh+AYp9i8M+YH2ymLUu/9hv4uK9Q2W/5OgHSzgf73o3Yha?=
 =?us-ascii?Q?gUtCJIVHdJVUYi8WKMck24GtGWXzFNFmkvAI2SBG9+UodOEBBk9Aim+xI9Dl?=
 =?us-ascii?Q?SJQR4tkN8b1PBOQlxHXrWCG6V7zgPwjC6DT26IKaoNEHWfGW94JWRTyvDjTi?=
 =?us-ascii?Q?AipEnGhC9tBv2PYb4mmMtQxTsd7obrOt02nKiYPtgIK7R5Go7Manu7/HKi+n?=
 =?us-ascii?Q?jDDSYKMh+xrKvgqIzFoUsNJWj7c5LntIDAp0ZljP/geA8wkTD6yCOX/sWemI?=
 =?us-ascii?Q?oYsgjILKop1i/6O3DGnMSyvcA70a7lyb9XjMONHg6XtMex2zaJ5szbpvUHl8?=
 =?us-ascii?Q?shRev0kP1yNj2VzzhTBKujDMWAAtejDReMAwp3URvZQ2Jzf37rV4JKbdEGpZ?=
 =?us-ascii?Q?E6zHi3E8wn4FQvXKT4iP1NQFvEXUjiIGj9DwAWMIr+e1GgsBU722p7axcr7l?=
 =?us-ascii?Q?fo4v8egid2fL2ACBGnuZlSmc7Sxve4YgrLuPeCtWYqGP1Z5b3/2x4FNeEosx?=
 =?us-ascii?Q?K2G5dvcthpxMhUTKUr0RykhgDcFzVCldbh84Kpg25uj0fJvp3pXkB+dGxk94?=
 =?us-ascii?Q?cy9DJcGEZMqn5alifyONZTk80dXQpUppTGhfe/Gn44VkWrWJpQ4/xaD0poNK?=
 =?us-ascii?Q?vgVNunBCdbtWbmHfwIIfODleHpwHhOdtXvi6MX/vqAJi2EItfeGm+bihts6G?=
 =?us-ascii?Q?PNyT4AzsA3ChXcDEZsmAlMmEY5p0WPbOjZUF9wg9/HqiPJzZjiuHhaeA70Dg?=
 =?us-ascii?Q?AOwsUNmASmD9V0hT36ZN7WvmdmgpnKt/gBeUBLJHE/ID86lAxWfTbb+csOqP?=
 =?us-ascii?Q?zGFc/b96PYWDkzeOoYkwvRzJvGCp9S9h0envmcFpFEvptTA0y+GH2/+I1yVe?=
 =?us-ascii?Q?g3xUgNVnNnGmGHQ9LMgnuqeUXcLrR//0csUPNNd3izmZXYyBccheYn0DbYuk?=
 =?us-ascii?Q?y5IwHmHK1j7cNDb11YzwHPA+olLhGycCeKfvYVEg1YNpSV14dfhnu2Vdzp7T?=
 =?us-ascii?Q?tgywiBsDHwaykgCqL6qj+/wg2EApQPRdUUDVq0nqMUjheXXC3Eskl6qVV9wP?=
 =?us-ascii?Q?c7uIEW9MpdqbrWsHQgKUbyjP40HBwWDdgVXEz5yiUVRv/pVjbO34XGTk7XNj?=
 =?us-ascii?Q?Qxyq8oDnXubWoKVzEIUMBzKm92gy2kl0v7Fbjwt6sSyhaIBfWt7B5HDCsLtH?=
 =?us-ascii?Q?4s1ganW5gzWPnp2A1wx+d9MY76asBfCcOV+X5qJWelFDTMvoHgBsLcWl3CbY?=
 =?us-ascii?Q?ctzndUHLihEhCcVnkIHneWGIk1Yvyb3HhGfnElDdoiKEDZAT+pPVQjogacKt?=
 =?us-ascii?Q?/J9j4GmqWPHvHsEgs4M=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5344.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QGYaegQtYBWzCv/rTq12LedN9pvgWUVz/czPwUcFVcRf4YP3PegqJObv8/Nq?=
 =?us-ascii?Q?hY1PmRBhJ5HfR1b5esoAHT9JftfYlB19NJ38g1Nu9lRj+LvM+VZeJXETDfta?=
 =?us-ascii?Q?sMdGVNs9XIN1kWxCQbZ3yEBlcieBwXv2d5NEkwuGcS11r+NcYNbviOEudCNu?=
 =?us-ascii?Q?c5TRtys4F1d0OqeM7DtgdFiqNjH1qbYZFU9qtWgxMlzAmCIm5TlXSF6cpXuL?=
 =?us-ascii?Q?l1OgXoODYBf9GT4FediecdL/hua3hvWgnXmzrbmvT+neajOK6yn9ZMJ3JpWB?=
 =?us-ascii?Q?tpP44I7+Rpns/YlHYWcDO7ripuTbLki9AbYPLPRwpLOoccm1PW45YJb9ZpGJ?=
 =?us-ascii?Q?arFiYeuDx0F45Vp/hCVW/vAL4EJT8pxdu8mXAB6gCUWRYBl8VUcFitGveU50?=
 =?us-ascii?Q?GOOeWR/3vjC2FtGpnXdHQ0y675nmJ1L2aLAiqGrmVqxbW5dDc9gkW7R6LZyC?=
 =?us-ascii?Q?W9iRPCtqy7Wlb2Xg8emXK58WcfwcPdlQNcOBKJmKI5POZwQH/10PcFc/aEEQ?=
 =?us-ascii?Q?iU5L/dueHXKIWFJQxdxUODST54Vg7YJFdOrYEJXqBFRHx754NCBXcgzPftTE?=
 =?us-ascii?Q?r31hH5BBE4o6/Bit2lnvzvNXo+IeTOQpF8n608XvSvekiGOqUumCPg3MSaX4?=
 =?us-ascii?Q?x32P9egutUj+YJbVDn0MT1OlmcVxleXDPeZvevW6q9dMNo+rsa2vJBAiz2sh?=
 =?us-ascii?Q?JIvmaVO3kd8ZLmaETaG/rvO/9yfZbTpbyuTMbUpCK/RI9FchxMwqQ71LnGGw?=
 =?us-ascii?Q?wtqPgZmZGTpJDdeQM3OmNsAvVVGvOxR6sFqZVD6Bi1Do707BfoK27Qm8dwLp?=
 =?us-ascii?Q?ftf5vlga2jTyrIBNwlctVolTmYBykiDvezP4WhqjGPdbIprH3Zs/hrcW3zNX?=
 =?us-ascii?Q?E2XCcvU59wuj5e2I7EFCnpdsmZGTvpZtIftp64UnqKwWjR+jxXr89j7+TMln?=
 =?us-ascii?Q?RwnSRaL0BAuG7ixLeY/uffyAB5B7DRPyxEnCeT3FiZ/2Jr+eALg5hiGSprK6?=
 =?us-ascii?Q?BN8C67SRo33J+u4TrVA/6Al4A5eqNmJcgQhjoSxHJJuYQd3tpP5lIo/CaoA+?=
 =?us-ascii?Q?eQb11061yb8xExdVpeq6CmEoc/qIydm5GAEyDQPeTV0pCQgMIu6yVmrvC0zi?=
 =?us-ascii?Q?yQ95lFdzEmACIIXnYRW7s0fySpr56YKjCF9cUC/xEbjPOkaPn5QhXYsmORQa?=
 =?us-ascii?Q?WgwCZdi++pInxwcHv+eCxACBl/uRzRUHkiz2dYqNyCHneFLaBfJPSoa49U7h?=
 =?us-ascii?Q?2XrHOm8cWYHjVzVUt6S50UQu83YkfUr8jrofQhQGO0F1PohdC7pQCcHY/LS0?=
 =?us-ascii?Q?nA3JR3FtiwpMvs8SC/hnsEZgWRhQNyi4kiQ8jYFrAMwnhXWyAsXzenQ9kT8H?=
 =?us-ascii?Q?B3QhUEq6qBImQpDLo/qfyiZtmZi2Z9fjQvxFwulJwn70MXIny1jQEBcxXxAX?=
 =?us-ascii?Q?HnEpBpsGxDKIupbiqKcYEsOtY+flFTmaR6IfofMCFwcmViAqrWvS3H2ekwg5?=
 =?us-ascii?Q?WHvrxX4dOtUDTcGg9dqgydv3t/5fCxij/QPgxTeyg8UB94Ro9DYqxx4lUus/?=
 =?us-ascii?Q?0bUKa8CVt1OVMtLvB6tPx7xkoZ/JxF5Jk0amO9hV0yiWIc/+8pdPJjkw4G/7?=
 =?us-ascii?Q?/vd2uUangsxV3hk54qZP1fgXdVjSlplTuZ1rFvmyO/G/MAAH4BqH/3+7WH/K?=
 =?us-ascii?Q?ik/kwRIDBiMyvsw/HnAGW3S8IV2KWwc2vHZlPxtahxZOOPTrzaJUXYYraDmY?=
 =?us-ascii?Q?QBU4EqHYvgEv00JWQP24Kd7UwL7B6QU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tZP5q4tcA5mTeZq+LSvupLzsN4uhcii7lhhViAAhwB9ncsNQKCoZKMU6YqlogU2SBtusSLLnn0LmJDUgHX+IL6N9mu7rJCRuCvgUtCWTbb9/IaolOHalIBlNZ/0ae/25pfAbBb/biV9hkLX/Lpxzx0P9BDlRaGoXO45x29De5xU/VA6kW4vhrr6dG/piz9gzm0snuAjhS6VNv32ZnV7hi4oHIm+nj0pp90CNf5UwI9eZlTARwyOixQybbtfZYp6dMfEbEqaGZknbAbdPU5ouGgbqRZCkIu0u7+e/Yv80+QednjR72WJZ+fed57dAaUGWRXttw9g/u7LzfNGK1bZtD2KRI01UTEIsoxiE3kCCKCYuMFXBzpSq+b0RONMvvAhnSrxFHFuPz/X39FFA2TB1lorEQlCEL9YZLRLOMEHzHnpiHb0cbPMHNV1X7wWQz16zME5o5Pm+xIVgsjceggrvgQaX7VGzzRKIqmBf0yZMImkkRvEjG8wNeU7tHW10+H+i1ejefVBF6J3RZvqN6Z30wJFAN+++MbFV9GniV+cjqMdgHdiV/LhZGYrfM1QVnBp1K0mgsRm6TXpNDe/n+z5OcpRqGBG2JucTF4tIIhwFytw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37dcbfa2-85bd-41bd-ed12-08de73d44632
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5344.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 18:41:08.3373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SrKX58220lpBm5hkH3LRBArSIWtsO2Z2XYTnlDvq+1ohQWsMEq/uY6sv52NFTR1JJFaHxSA8DFg/3f5jzb3GmQxEE4QCSU3/t2QweKp9UDk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5902
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_02,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602240159
X-Authority-Analysis: v=2.4 cv=Y6r1cxeN c=1 sm=1 tr=0 ts=699df0ca cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=qXo8lOgtQwNT7n_z66sA:9
X-Proofpoint-ORIG-GUID: N7xcuL76gmW4PbA839YHkSQoDTdXViSG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDE1OSBTYWx0ZWRfXzia/omgfxRbD
 j3bm5pjEdZQ8ljtScrdyf5kTMoKJG8yIGr1edwt9qSJ6MO3attw/cB+tEB1ufqQ1Bo9RUriJZ82
 a9FuV247lw/dVqrtTDSh8SS9Usl1WJnunYCF90CHjYDj3Bah6ZlNpk/tU2D4FNUP1FYIYTqEaxw
 4Pmb+m3/HGC+KloXsSYFApk2vWU7sefKWIZOXYnGwyLHNuD13tT20/mPWc6aZxJbPWXiParbIpX
 2q7boPFIYchV/sD/nrngrnUhLR16vyWpWDAwH4lCa9obD99a5bzkNA4Y0/QDhzs2C5HiCB8YmPH
 RuTXcAaldoKBfnbONS6lzOyJnB9fw45aLpdYgaP4O5Lf1qdr01n2Gtv//k96aznikVGBIk5yrbI
 M+eXzRRnVZjWhn8tLj97/z7zIcxuFzOiGYlVlh1e4KxqYgLkNhG+yCA074qikutGKjB/txo26hv
 gCusUEMNwyh94s5LeoQ==
X-Proofpoint-GUID: N7xcuL76gmW4PbA839YHkSQoDTdXViSG


> Add some logs to make it easier to debug after a command timeout.

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
