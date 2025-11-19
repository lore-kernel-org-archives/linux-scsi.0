Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F10301475
	for <linux-scsi@vger.kernel.org>; Wed, 19 Nov 2025 17:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763571934; cv=fail; b=t21kDKb4oPWdFblh7BYhQhwVj0Fg7rwQ/cLAlL9BKaslmR/fsNDdEowRllnwm1JwKrJw68znE8JioY52RWvugRfZ+69JwshbnqhyV61LrQ1wQMp7p/Irf1UFIW2h8GTPDnT45FWik4f1Pww/GAwfyzBczpeHafivIKlBFDAXs4o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763571934; c=relaxed/simple;
	bh=WYzVQ4V58z9X7PXbZybwNeG4ZpsuSc+lAiczuvbVwpA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=QWnZwTH9mnD9N2KlFA9aklwxLzVkiPNkglxhg0fpEA7YqMnZu/UGpJ/M+ChFam3lwR18fJIj3krMoKoTM5xw62EJZqJ1D4rdmiC3DrkJHwrPGJYCH0Cardp3JK13NtxhIj3Pt+yfWFDsxEf/GsFqjPbUjaDQN4sSft3T+HXZuHU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ip3sBg8w; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rG2vbdVU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ip3sBg8w";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rG2vbdVU"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJH2B82032473;
	Wed, 19 Nov 2025 17:05:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ZFDbZGCH5QBxuyn5eP
	ioW+GVC7S0oP0lFXrD2qUckoU=; b=Ip3sBg8wDN47vec+KzCh/hy4kOLnlYea3h
	rH31N49faAlf7EfBSu3jlpf4On/73gG7FmlLQsoj44FQRfffgJNXMaR4IVUZi09x
	v9Vc+T6GMldqBXMBg6kEvmflVY4Ux+9P+KpfrSNCtgR/DzAeKh2s+NTMo3PaB5nF
	mvgAxuiq7n2lgr8MX+NqzICnoDJ0GRsBpP5kTsRJ7eNv4hBAK+q/SuEwhEKlNrXq
	uF1e7Hu5sCjAViIwVbA6BYjuf/mWaunfn7ksQdwdQ/ZZ+17RGnr4aHB03wXPYxsR
	33xEH+hcFNT1UaUQb7P5MjYIt14iP1JPwjmCu4TRdCpSwHcBlFQw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aej907jnf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 17:05:14 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJGfgs4039834;
	Wed, 19 Nov 2025 17:05:14 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010058.outbound.protection.outlook.com [52.101.201.58])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyn6b9y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 17:05:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cJgecDihHXzWWQB/ab5iKnNjuG3YkoAZAMyZPMeX1h8Z+juJDQpvyV67uK7YmKFVZSqkXjAbDTV5llNMmzDs6ClOmVlG2MC6q997vtqkHjvu9btzAIgKNff8VkxCkhkepi3ww2uGo28Z/1qPf4bSkXhDWaB76xqDJsRWwPLpJLRL8zRQhpSySM2poZZJw8mVllm9wok0jKkjRn9SIWZlFRbEguB0zTkLig3+dEwm8pUOG3YiWWRwUXs/kQLFstX/Uiw8z9+x+KxHpZQHnA8xW70/R2/77dl25iBTJLoTh/Z0hURTWFsLruG1elyYRCGXg/xUX4pMM+4uRP3MtL7gTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZFDbZGCH5QBxuyn5ePioW+GVC7S0oP0lFXrD2qUckoU=;
 b=vyJ6hJRT/bkVozBbTEiWbzhM+2NoafWvTUGx8OKi7rvhL9n1OgtUS5JCDU6Y7Pfo0mFnzqnoWPZYJ2N+UTOuBupoLV58nz7Oz7YilyMDM+YF3CF/NX6paBCwWpUe1ImsDj80oh4zdMYTVfTMRHx7lUHXz+/+aeOghUFTAmNqLNJbTCLdoW7N2ITFNNsmr3quZ0SBypEDr8HreIq/4eb6S1xQ8Kd18T8p9bgq6mFvJBEEA4KaDRwHMg6TOwGM4iRA1vAYByrLldjZoXtwvDaPhx+8tH62wlyq6xm2bHH3Bl5EzVHnHl3YIcsVd4Tcry9HjbP9OX5MPAhbx/CJSXk4zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZFDbZGCH5QBxuyn5ePioW+GVC7S0oP0lFXrD2qUckoU=;
 b=rG2vbdVUCuzJsGel967hFxWQsMrvVmJ54Xo3BlWNn385EpAioYHAIewgpwbqymLe+po2alPvneVDPglf5TcbZS1rG//ilim7c8Aooe+LkiSnDvXvHvqpNhRRTmnQeHhmGRf/omBdrKh8WIm5FVk2/Yd65ga2a57VT43ZdV9mE6I=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MW5PR10MB5875.namprd10.prod.outlook.com (2603:10b6:303:191::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Wed, 19 Nov
 2025 17:04:18 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 17:04:15 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?utf-8?Q?Andr=C3=A9?= Draszik <andre.draszik@linaro.org>,
        "James E.J.
 Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        Peter Wang
 <peter.wang@mediatek.com>,
        Ziqi Chen <quic_ziqichen@quicinc.com>,
        Can
 Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Bean Huo
 <beanhuo@micron.com>
Subject: Re: [PATCH] ufs: core: Fix single doorbell mode support
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251114193406.3097237-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Fri, 14 Nov 2025 11:34:03 -0800")
Organization: Oracle Corporation
Message-ID: <yq1ikf6ar98.fsf@ca-mkp.ca.oracle.com>
References: <20251114193406.3097237-1-bvanassche@acm.org>
Date: Wed, 19 Nov 2025 12:04:13 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0057.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:88::18) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MW5PR10MB5875:EE_
X-MS-Office365-Filtering-Correlation-Id: 17a5793a-786b-4b9f-079d-08de278dab62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?l+a6TYkGGBqEU7GrSiRuuKr7C5raQuvng0+ZlAM3WMbFSvCiLtXHg6Z0iNat?=
 =?us-ascii?Q?pIjIMyWHtlAOOTb+zY1mutMYty7Xh5RfLBpxoz8RzeA6ej0mMPTV+3T9Cci+?=
 =?us-ascii?Q?x7HDbxRM6uSNSsGFlomwKKWUVRqIu5Ysd2nRpLEbpMkU77SXpdR83V+3flHl?=
 =?us-ascii?Q?PGZd8pZiU/NbV4JG/43MOWeU1AQE6pOakEFMKtCXw62LtxcLETj0VfKyO7iG?=
 =?us-ascii?Q?gh9wRUjOUk2kXMROeLACUmBMw2rE2CYhqmbUzKX7/jfRLluHrJpSG9/6niLJ?=
 =?us-ascii?Q?3DHcwxqaN+YWsFqGqzbCv/ND81rQJ+J3zhJiU0QkFQv2CZlGa1wX9oMkmMoy?=
 =?us-ascii?Q?BBpMjiFlh0Ko7GbqLE9vDgA4YJIzJwtKFlGuSWk5re5EFeU8S1towiYeScQT?=
 =?us-ascii?Q?T+1tMQQNkmw+VkzgTTeNLE6MEGqbz6A5R0WB0QGUcYrmVHYw0vWGvd0sH2cJ?=
 =?us-ascii?Q?ME+Xkg2vQYZkVdQ/EJBIYXPl8VXUdGCwFL3GGgE8DR/mcd4Ufih/2s3/lbVY?=
 =?us-ascii?Q?bFzqhmqk2PY1Y7IbNf1zRvlQIKjk4XDF4liYiQyA2vq02XWTY/NDtgoy572F?=
 =?us-ascii?Q?viJsaxKyZjf4YPW4iK3MubqUFgJSA6nc+8n/4eDQJv6k4kRoHii4ZhgrUh8F?=
 =?us-ascii?Q?n68sKEUT78sckbr4jU1NojxC12lsC8G1CHs6ESt44Vhani8X3X3VoE0yfdBJ?=
 =?us-ascii?Q?ANPzrT/q/1vyKUeWV1TUCLIFECnScVmt1EhKvFLjc9Z3J5WbhgnkZHqw+RVi?=
 =?us-ascii?Q?2ERHZO2LoUQJXyHtnxkKM2DNV1Ja+481YQwxKPx5LMaTfPNOqulSUNc7RYPH?=
 =?us-ascii?Q?69F0J70hEDZ4LM2vExMCshyVwGrGE2BNrTtdvAkLtJqOTjymf8TutpldBokw?=
 =?us-ascii?Q?m5PYZ22uPJHfaLToVRJxXU7LeuVbBMewVozAIwHIvQ0lqZ8nZo2HdifTUkRL?=
 =?us-ascii?Q?BdbyaiJqYo1xigoZNAQYkMxM5QrGndDQxWY9bZ4/ICE+ZkJEFzCHkbIpN2PW?=
 =?us-ascii?Q?I488digTgAT5TXUleNxAn6EPv9L+95AysFJf+x0DF+yBXjuVJr+7527zMQR7?=
 =?us-ascii?Q?u2LuGC/eOfNmKfKGHN6l/IjILrM7XeXgkvIjpYxAvC0iewYLUFL1qF+HWH8F?=
 =?us-ascii?Q?pSltNvUDaz+LTQFUvhRINakHZCozI2QLhER33ZKV5pVZl6LtE0EW8jBAO17H?=
 =?us-ascii?Q?Rww0OJj6s+78V1ELwbnaupNvIEXIafsVdcwKYmjq3n7oGmFdwc0T710mXksp?=
 =?us-ascii?Q?i8hoWSqPnKY0VxXWf0Y4DL4Q8xlZiQ4y6nlDW/1m/tZhW0+lbUd2ALvB9AYs?=
 =?us-ascii?Q?XICeouHa5w3qejoTGzOk+T/fHr6hgQZTD7K4LRu+i4NU5Ktvaq6/V9fvG4Wp?=
 =?us-ascii?Q?WAFGXyaLMU8A84phqSn/laqV9+iJD4/N3YZgONVEe0qlGap2jrGyyHcMnFsX?=
 =?us-ascii?Q?LGWfS/29OKyLRDFphA+MDqCmnJ8dIRor?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ABKbK5YWLkAVp44cDk9GKbkVryY/KfuC8DeXuYvzhb6Z1Q4QvcYcW+XEcOGl?=
 =?us-ascii?Q?bZXuMTlmCAZ7KuICi5zYxOLEmCM2QFWrrU6esPCAssYDwuoQBIbhCq04AEm9?=
 =?us-ascii?Q?YuYXEzbaod12ppWP4+pNuh6Pu251Yc/H00EHBxmpoD2dixc9D0egYJNK4YIo?=
 =?us-ascii?Q?YxvI8JKBPJvaZMYKCQZmIsaOAN5Rv6MWf8EZNjDu1oRnocuRcR7Jji78gDrg?=
 =?us-ascii?Q?dKDPz330SWae+XVHWLoEMGNDDX0OkUhW0vIvC7YEN+KC+X9V3Nyth8C7KJIt?=
 =?us-ascii?Q?SmZyFWyFjWf/GtVXZTE3JGLn2SdsNsMreyVcBxtHlgbFY9cNPXjqITlkmWTS?=
 =?us-ascii?Q?jR4ASpXSTWUHdGVOttuvSDEmMU4oP8JWQn4h5R6OR6dZbkhp6Y1f1GvhhYwR?=
 =?us-ascii?Q?Vi8lKdnzTUYBTkFR+6pnxnJtn/FlKQwPF6YY9i/S5JqjaFdhS3MO/qwdNGfF?=
 =?us-ascii?Q?O1zayWnpXK/ESH/3aPj8poE52AuFZsquajHsOyzyzKQwu4rXluk5ESJTdHuw?=
 =?us-ascii?Q?Ee4XnHbEiXMcZ05rrOEM3a5oidjy2G2yg4ZI8v5kLiXCu56hHyJeodBJGBsX?=
 =?us-ascii?Q?5/0SRzri/lsr7sSqkTzs/67goABZXX1AHFz2KO1xX+ndXRK5CIidI4TnymHo?=
 =?us-ascii?Q?K2AJjCcjhh2svSyer3422OH0VEem7eZ21tP2El6n85+5Dg+T7IYMRR5ETVmJ?=
 =?us-ascii?Q?MZKI4HY29Jg3Q/TeTiBTllj/8pgVxQvIEiRWn8fpZ/KkrlYGmj37awVykFbn?=
 =?us-ascii?Q?g1g8A8poE5ltOeIQrhedKsDM8kaWKCP3ZTufyUhG5NcFfpGR6PsqOcNch5/v?=
 =?us-ascii?Q?tdfhKCrddyYK94UIuD8VeXY7gyhmBbnWlR6iDL3Ur4A3mkLyQguD0jWE76cu?=
 =?us-ascii?Q?D0XP1wKr7H2fHFB1mej1WKMirHDCXFxqkmzWOCzhI2FzPTbFaqz6md/Fz8Wf?=
 =?us-ascii?Q?rUQh2Vxr6QR0eB2v8AaeRXE6FM34trfO7gXrc9S47djNdFh7zlE6WG9NzI1L?=
 =?us-ascii?Q?+NRl+PAkxtF1XLvA7bPOWMCc5GVBjm0pVCUVmY7gAnmcBx5+N6hLTJ8gBDN8?=
 =?us-ascii?Q?pED/NbjpqlNC+GLkbhkRbHIolrGEkwCV4e2wEhhuRpeWHEDghfj1l63gIX0U?=
 =?us-ascii?Q?qgy0wCYo/6A4s62JEasyEPvV7ilakWHzv11SNoF8AX+PLAm0wlEe+TGGP4ZN?=
 =?us-ascii?Q?0H8YR4O4SqnkFSQSJaL7cdmzODE+X3tVpNCZcZJIqxOvDpAOurV9CJMZG6aQ?=
 =?us-ascii?Q?TSz+JEdwFJVuKQl04TxtHQCUXg49ohalgWcU5F7+3fZclsSV9Saqr34gw4AC?=
 =?us-ascii?Q?7UpdVgO0HGWRYPcDUr3UF3R1WcEEikZRa6ZqGs+X9WQSmXNMIVCEaXQtYrBZ?=
 =?us-ascii?Q?wu0ri+omb1KM2qplvj523a7zG7bFe1tuXT7WDvpoVLU1oyEfAGoSUPtpTQPu?=
 =?us-ascii?Q?g1U/uRqMbBiaQCEoPEO7O6wguAul3mmZs3RGWQ7kgqcVzfeesztO8ezePxEC?=
 =?us-ascii?Q?8oBknh5HatZGKNpSSE9Fs05voRtNFEEwWeGKS5V8ZTavVCVIwGseg650RcRL?=
 =?us-ascii?Q?xEPX3lVCkhulUm3lNhBldM5WaNNGuzXtV5cOdBbXDX8UeVoT2si3GUPxgT6B?=
 =?us-ascii?Q?Cw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	myS0PhMeU2vHjBdpy5fnjoz42Anse6w8dqmldBaCRqvR3KkAtND1xkVjYBiJpbHB2hH32hfm9jv6oHcnWJn9DNAm511QkpvzhI1SH24w6WFOC0R6rSbSrEu6pN4HAZVowBmGmUlowJJEh+0f89wi4S1xJzFSaVysfBcqxJuYXp8MVngiZ3BXV3GHdOdQMXuq0FAMkWZDTimQZsZbe7QTPxvTLxyK34J1xZ7uIlY0z3GeygDtvSUpSccJTTEFF2JQTyIzIfIeknHFLc3eAsaHvFkI/3vPJCBM2hiFPVniP7ZsIqSaGC7N9RXEIjf/wiO6NaT3eQ5A2k2bFwu6tJrZqpegrHlVvezs828DsKr9HWnlKfWFzi5hPuw+OjBc5mS7BCTOvK2Jro37wuRwNqRgyGKNNUjvuy/2Suenjldh+F+KtpkBFrVNFiEng0KuJVrCpjL9ICBsQDkoIcdT6SaV4tc0pGG71LXmF9sZ0vMMd5Cu3DHVIRRCWrpU2JzO6Y1PiKEj8RpcqInkRjq62txkdVqNJkOnWtiG3Jur84AvyU+cqzwjSsgkWZ3jQ9XzQdayWVFJBfINoXUB6SjGNWqSoFs1Ht0wPiSeQBsUCCKAOZA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17a5793a-786b-4b9f-079d-08de278dab62
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 17:04:15.3700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ejDSSvnFGrVk0idL5voL9qeUiwr26iYcw1nJIQ9knRvw02RIKRRk2/KVZxm/oSsr2JPiE9LI1CiNvU31uZYprSVWu1mrS9IwOq+fYjywZE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5875
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_05,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511190135
X-Authority-Analysis: v=2.4 cv=OMAqHCaB c=1 sm=1 tr=0 ts=691df8ca b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=APdTsy1mPjVvL4qEmPYA:9
 a=UzISIztuOb4A:10 cc=ntf awl=host:12099
X-Proofpoint-ORIG-GUID: 2oXvRBz8CkAK8RcZSMSjiuOVs5YHsqrn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX3RhqZAOAB4fV
 7NirDvBhxvoU0reO+kXsXV4pC58KQfJprUTGWaBq+IodOahjDJiidImbp+WizqzcU46JU99aafZ
 PuukBxit1C/8eYozgXR5TxGPbYCA0O/TcrN/wkBOJu2xpkEcup1M6DtXCQ4HoO6geoWZccXZGgi
 Qx8OFDmKcPkjy/2Nq6+QR86K6FdnpyHuStA5J5nryFW9PG24M/JcynKAz0ToZkpw+tsebclxdC+
 W+jcnzwEMqqbG1Sr/CcaOQEwQEp5BAI5lFDTk6NfbY+AUVEI9owUDNIDfq9bAIZpa1e9TcD2718
 aGCI43Snfa03Ic0m1C7YDeP5tHQ28Y135NEz23QQ591ZmU4/WsG9sLxEurGOwM02XjuG37dpUFd
 hizo7hZyylN0woL6BlM2fxGHnvJYNbZazm7QQSdn82ZdS/MYzV8=
X-Proofpoint-GUID: 2oXvRBz8CkAK8RcZSMSjiuOVs5YHsqrn


Bart,

> Commit 22089c218037 ("scsi: ufs: core: Optimize the hot path")
> accidentally broke support for the legacy single doorbell mode. The
> tag_set.shared_tags pointer is only != NULL if shared tag support is
> enabled. The UFS driver only enables shared tag support in MCQ mode.
>
> Fix this by handling legacy and MCQ modes differently in
> ufshcd_tag_to_cmd().

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
