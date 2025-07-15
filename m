Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B19C86337
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jul 2025 01:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752543094; cv=fail; b=pq95hhR5+/QgH6ndd78Db8CqBT9v6zymrr2XopPoQ3JRQnh9gUP2rZQLDkNLORclEd1GCpwH8o1FX4nvr1GHG4sajSmXoHNxMxEkefjMgBb1REIQBN9im7DZ/gOdrl6TvGa6UP+tpszCJS2FOfzOvc2w4q7MO7ZQdTeDqXph/rQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752543094; c=relaxed/simple;
	bh=J8atQkX6VQuWXoSQT3xT5Z0N7jKlei/We8aHvSBcaIQ=;
	h=To:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=S+N+BICCOUkl63FPfNR1uxJXCnsqHuaWmh3WZsB9DwSQCPNqBdKc0BQHqrBucXSAoY9jwHK9n/SEFMk1ogzqSfsT4pRXr/ipdv4zMuzGu2SfZECp5I3XDE7oQOfynSjroSafHqqwdk0Vai6pf80k4nlZqxvBbiPJoi98x+J8P8Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kBDhahJy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IJuNj76K; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kBDhahJy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IJuNj76K"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56ELZBh5027210;
	Tue, 15 Jul 2025 01:31:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ukTra0DvOL7qTXzuQk
	Hd7bKUOgKp8KRDhF9c4wC1BSg=; b=kBDhahJyoBkENdp+Hwb3KItS2DE8qTYEyc
	ESDBqBZKp+QZARqEe43+EqMJb8AAeuDKSMwyKPDvo/yRxg53e6vFvFdJw8eB1RMV
	Xql7Cgw925sm6Ttdad58jVuJ6CJJDPvIdEwGcMPPQ9tL+TDwa4fn6uubvimqvR7J
	NmLcP1dmkhZKYYivLLYhDlJajnFhJzRpcOl7iXnYmwuzTDvos+5/5UoTwzB03CZQ
	NgpOj1+jbY0HDWli8AxokHEfHnm4LCk8S0JI/d46NhhCAUrOiGDGXcAWJJJpleaL
	lmbAXZR3Q3SssxMSKyZybcHA3buVMpXkfX9/vqn1xEN6ldp1Rc6Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47uk8fwk6e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Jul 2025 01:31:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56F0fjat029626;
	Tue, 15 Jul 2025 01:31:09 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2053.outbound.protection.outlook.com [40.107.236.53])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ue59217c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Jul 2025 01:31:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CFiLLMMej/CWRkAuLsHew2befNCpn8eN/+nnnGccxkHgnh77v3zRHDgn+KjDsFwkzm3gE78WhLfCaT/l1ubofvLK5+9DE2Oxx8bHVAx8d9P0mB47nB0cUb9tCP24Rhpe25mHubxqt3fNpCbWJ6YulJ3RdTHTfe2Q+/wBHWWny+Kw0+ogAK3WhIkvjj6iHDCodn+u1chn+yLNi7kJsZDe4rNna0WH3rI1dfRDuEN3ehD9LkRzOe92GqaMgprPdCFAdmTnZlDB58mDt+XQWyjHkZ4CVism8zxGVlIgREExYrCgxsFNnhvXsGRlumdIqCCroNqoaVo/ZFwEUpMkqTpIfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ukTra0DvOL7qTXzuQkHd7bKUOgKp8KRDhF9c4wC1BSg=;
 b=YzM+cdIT31p9mg7pgKd7nv1vx8HlA7CHM0Gy9AfJ2RJmvXSpXyTdX6FPB8y08Nm7uZgpCr2ElSJCKiROawV3N8oCOGhi35TsCtNjZNdE0nG45ZNT4APnAkKclBNsjaOfpH9IZSuIxWCXf43LNfh7h17Xme3oUIrBMMCbWkr0/BWlxGUwkK+cYcGTOg1X+WvDjTaj/Lip6sQ5JGY2J2l0+05HRBhOhcW4reHqqUZInk6cak1wU8cBsPmKp0Os0xgWXlNeYNR2ecxNcdA08c+p3lUbGPv/L1+EIlWXjLfh1WTzvs12Hw0DhRNmvF5ZbDtJTPpVr4NZmUWicluKYb+fMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ukTra0DvOL7qTXzuQkHd7bKUOgKp8KRDhF9c4wC1BSg=;
 b=IJuNj76K2P5RIZD2UhmSJ2dc3+u3rF4d50zBjnJVrxYI2rc1imhCL8GdTbCUJHHLZZrjvilGEjs6pkImy13ToCExZtOFgvHhFGfBZK57NvKzNY6gMNpv6co6zN3qlyowtq4eu2rffvlqgEFMzTWsE4FaFocWY/0fwS3vAcMNMh0=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH3PR10MB7308.namprd10.prod.outlook.com (2603:10b6:610:131::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.33; Tue, 15 Jul
 2025 01:31:05 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8922.028; Tue, 15 Jul 2025
 01:31:05 +0000
To: lduncan@suse.com, michael.christie@oracle.com, cleech@redhat.com,
        linux-scsi@vger.kernel.org, bharat@chelsio.com,
        Showrya M N
 <showrya@chelsio.com>
Subject: Re: [PATCH for-rc] scsi: libiscsi: initialize iscsi_conn->dd_data
 only if memory is allocated
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250627112329.19763-1-showrya@chelsio.com> (Showrya M. N.'s
	message of "Fri, 27 Jun 2025 16:53:29 +0530")
Organization: Oracle Corporation
Message-ID: <yq1y0sq5jj9.fsf@ca-mkp.ca.oracle.com>
References: <20250627112329.19763-1-showrya@chelsio.com>
Date: Mon, 14 Jul 2025 21:31:02 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH8PR07CA0008.namprd07.prod.outlook.com
 (2603:10b6:510:2cd::16) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH3PR10MB7308:EE_
X-MS-Office365-Filtering-Correlation-Id: 6069908d-eef7-4309-60f5-08ddc33f4449
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Jcd1YidQ/i1+PZutjGdR/kuo/q2aku51HvuS6yoEJL2XZ+rn1clKGeCZ+BzK?=
 =?us-ascii?Q?jJTMpP78vqBLc6jMdSVEIKysjeuEh3bktInPgOXRto7XjCrZ0OVNkW2skc5E?=
 =?us-ascii?Q?C0qQpwtKGeK21cAx/wopsppDDC5NydRr986DOVKJAOUGFRyi1fONT6vAHAAD?=
 =?us-ascii?Q?WnLKVsKZ1ZhEqMDqfj+geSpLlvGJOjLiTZv1l84ja2LPmn47Y0g0ZWFSTcU7?=
 =?us-ascii?Q?93Qi4Sf+EvIzqQ9rsfkZrsnWrcRnfe+9j/n2oFovsC0rE4TOsazDOvOYz76x?=
 =?us-ascii?Q?XJUhBYYo+zL0h01RakN5BATb29tjoQArmSipVXAOugl3o2kO8cHnDcOckcjp?=
 =?us-ascii?Q?TJ2uTrrobJWyFO8wIQSLpeyDoN2AewRnIYE5Ql1eRTNkX/rM2TPjL+DXRtFx?=
 =?us-ascii?Q?Dr28l//3iogVadZJPmJ+6poEXQlhIHjFWdGMLCYf1ItzzkvfuF4iOZsSRHfg?=
 =?us-ascii?Q?HEVJmW9uONbUfZFXI+qEIXdEQlnVNzfLe3H/kQICOfg/PZaisyUN3n0UDjDW?=
 =?us-ascii?Q?PzNwR5z0cojvEEBlOAOAMBTLUzl7DrMMfVFR+4Fg6Qg/Nq9VlrvR6JdXqVpo?=
 =?us-ascii?Q?L6Fuv6GrmGnu4y6lpHtBissfN6PBEV+gVa82RnxrlvI/HMPl15Ok7bjW+Evv?=
 =?us-ascii?Q?8usbFEb163ORMluLDwrIfTEX+JNm3hH6ZArsrZVwuNobE8ewNxNGp3RIy7Sw?=
 =?us-ascii?Q?vjKVwY/BZFPovBq4CjlutAOyhpmxzgJn2VTumAMCjsfgzNCDTfBTSdxqI400?=
 =?us-ascii?Q?wkwXUVoYtrLfZoNjKN75WKiZA1T7yaPgXjTxvQYXuISVeRfTUMxq+RrpDp3V?=
 =?us-ascii?Q?64B6FpfkQafyy1qJ+5yw0j/tjkIs3qo51pSQxSYEIlVyKSLYNy+7dqI7+QRP?=
 =?us-ascii?Q?oUA61bUrLMM2JHuLl/0UCIQhtcA9cgmoPt6JjuDqDlKrS+50r5wvW81dRm3k?=
 =?us-ascii?Q?PEQwC2MbWA5Rm0LtbkOrPjy8pSmGqJXix8HoA3csHH6ZLwEfzOqZLHeOCFv4?=
 =?us-ascii?Q?6bpsnWSA6txr3Kfl6vxOXSvCI9S6dG5RAPDjKBzUUX3qEEn/nEZEvUk8d7uM?=
 =?us-ascii?Q?LGuDfZ3hAri7hTFCY3ccvzDBEnLo7WSCXfcLpYw/Y++6VqowsiIRHrbEfCkJ?=
 =?us-ascii?Q?yL1CoC0ZJ9MJEqECeJXb2P1Psi6pe1qP/1PAipY9O1mdMsCgIUZt+rx6Yd7u?=
 =?us-ascii?Q?qC49JxOrrs9XSCVFrXTQnB4atFY/SGmh6xCalDPJMFiqyaKb0jT/ZD12ZxvJ?=
 =?us-ascii?Q?Dvz9H5LObTkvkWS5gUVaI/fW1l1rNRJD2Gz0qIjQW3hPLwCJTholrpoleqUL?=
 =?us-ascii?Q?Ae6izSMzSKIalDNSfAB4iqIVuMbe7VBg09tPVbu/z1y8ZcmFBYBgGLiMOJN0?=
 =?us-ascii?Q?kgd8dkCu0qDI8OUzqMrTLj1+IOjwdPHc3qBjZYxu1oiNzYj82cBoEB5Woent?=
 =?us-ascii?Q?WRF+Cq3rDLs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gv3TaREsg8KbuYR5VfcFgfJ73Utu8UBnzeAwdvGps9OuDjtY0opxu80mAznb?=
 =?us-ascii?Q?alMrddgpvyiF2cffWONXys9R7Jpb6KagdD/TXMgFHmPP55782NQ/MEwNCzOI?=
 =?us-ascii?Q?04boHMrUqATAi3dF+uutGNKCQP2CUnDdAtiux26konOMrA8csUF4HGjj6L2a?=
 =?us-ascii?Q?34fcEZ4LipgIGHl0YGJ5oULwRgko/P5oeOxvk7eAAARf7LgR+Fp+DQYJ2iEO?=
 =?us-ascii?Q?R4/BzHNGGOafRnyxO8a/nbi4zIHRrcC0hUiKPGMclBXvbYry6FQWusymm7QR?=
 =?us-ascii?Q?aoFMn6EASIuGO/RRkbny0cbFW6UdEDvvpA8IsZO1Cevufc4GjzeSkqAgn/vs?=
 =?us-ascii?Q?yhGjWdf0SmMR2zcRVd+lx7UlrtoVSspMjiGWMPLkuMPgfdnYMdKvjm5KzA/y?=
 =?us-ascii?Q?r3kZyy3JGMVgWZdHZ23M5eP1skKbUMvYD3kvqsppU1gHy5me1QBtWJTAxdGT?=
 =?us-ascii?Q?UX6uGX4d1zIku0HHeTEAl8IJzFawFUXG2B5knYycW7H7bSo4pFJAU+zm3HXt?=
 =?us-ascii?Q?dXO+muydS1kC1n6mhFhOTVm0IvQKq95MY+dqa9amtct47LGqPWb3YDYa8LWB?=
 =?us-ascii?Q?n2r5vSG0HFJm4RF+PpdtCxfQtM2YliQHsVPgMrQMqSqPk5Uqag9vFN4bJJr7?=
 =?us-ascii?Q?6pbbubrsjbiZqluAv2MsGuihhmiZfZRl3tY9cgPwPX0TyNF8g9xnAKGoV+h1?=
 =?us-ascii?Q?sCZjbs2P5UoeNwLHJ17T0inXLCz5+YE9ioolntDN9yaJingpny+gRS16LeCl?=
 =?us-ascii?Q?Wf+XIs8pNnuVGLkYhxdEm1mWPF3+aCm/Z9KP1RtUI+Nz1BDPAJr6w8wHcZ+n?=
 =?us-ascii?Q?ftJVDk4QUZQbmDWhOHDQRVnbt8s8yKWVsoCxsJPdvDnAT5lac19zSt5+wY5E?=
 =?us-ascii?Q?XeyPJwmd+LovQwUEWRrUuaIXtP5TAyPgb0rhp1KVVueINw14BxP1GCKRDJay?=
 =?us-ascii?Q?U8uU6ZrSgEHfwggLwRQ/ZM41POlCBl2WpOkmBYH2vxneEbdvzDyYLDxFwdQl?=
 =?us-ascii?Q?siC44LqLmNyLiRDcs5Dlbj9lhWnY9vTY5dLjoY9Hc626bBGBs84FNpTmPo/S?=
 =?us-ascii?Q?UUnIr2uUB44m4YZlnCGL8mmddbQtkvp+6k7v6v/i/Dzk4llCE6iLErRjH/0+?=
 =?us-ascii?Q?ezUrkj/empJTrW0HaGCUMwY5M+YFgLlnErlB+NkVndnFSZ03pSKkfFRM3Og5?=
 =?us-ascii?Q?rIOOhNY7U5wuZiylQFzEI32ju7+BwXi3rVpT5jkDNvJfwJ8f4OYxnkouG5rF?=
 =?us-ascii?Q?C20YxcJW924BF5U9brZMtuQFbcG+BfO3i9McNJnZJ+cjx3+O2Tb/YQmwHr9W?=
 =?us-ascii?Q?5HJze/XOlPUKm5ueJ6fUdLJx70wCQE+P4mONbi9TE/Cd9exzVNDypc0cCUya?=
 =?us-ascii?Q?Oq0ixlxDN8pR0jd+mLxVQjonmuymzTaQ2iSvHAfADCArgRjlYJuTsuD7LcDU?=
 =?us-ascii?Q?bUnAWwGe77Tx6AozpzsLc0lJoJo1svnqfD/4W3kJW1NK4h6fmgUjPON8H84a?=
 =?us-ascii?Q?Qc7BXL8+2iemsN5b7DEDSMpwG1bxJ/bPsTtTyGEfm+aDpNpxKPKLl4QjESF6?=
 =?us-ascii?Q?WHQ/HH0p2txpxd91g0DMa7m9Ln5NG8Smr1ZeJT+6o2TIrWqUnQWocEYZyPlc?=
 =?us-ascii?Q?jg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zAQnsvST0gbL8wXIy0iOtqKL02Bq6T+C72caCTjYAQfgQRfAY5n3JWWweSH/W8nkzUUKdw1nYrmjlmPJalIvGYvgnKg5XfNsc9BcAW7b4WbKne0C87If5Br4qBk6NWS6w7eJtly0JL/h6Vy9+PsTJK9qOXXrp5hm9g62ltoSU5Z6qesLfxJXxvhHAexHhVZSBBixcOcNwxjUooVG0zjwcIWwTt9LlCTVDGLUzOx9vIJk8CP71pGcCCzSkvrz3xtu4cLJz4IOQkh2sW/8R3WAm8x61AteuUA0Cx/RNT1E3p9U0OCo/VBZnqQTwP2FISql4PkHhayTwWBrPdkORCfrK/KyjnlozWDgIvV5Z+8XZzr/bakfWfzsCvu+wvms0fCtiijQwInsgK/RdUiB/nsG8ulzdSjjR5VvAHojntqW+2Bn1eRxKfMX5VI+zMYt8qJmvunvx/wjjyN2LWMB6nTzw1ZO5bwCxQkht6XrLLOVAP8numtBq+ua9nJT36jBa7AuNMm5fb6QboF/Cxe13F0H3PHG8yg7WC75frLXcT3kvnJ8ODVfwK/rsc82HJCT1M981IIi5KpmJVSaIjGsC5COHXpyYI0L8X22jkg50ZVAnK4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6069908d-eef7-4309-60f5-08ddc33f4449
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2025 01:31:05.5508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4IgjWaaGcsKuFgapO0EYUXk57aPtdlYYhFDV4HdRnBS3eDqXEa0FuztnvvdXQXF+1+TM+sRRpjWriAFb6kSA5xDN/YxSxehO7EHS8NmUTuo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7308
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-14_03,2025-07-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=830 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507150012
X-Proofpoint-ORIG-GUID: E2cvtMt5fDPQZaA2Kn0_kpnR7GlIowVN
X-Authority-Analysis: v=2.4 cv=Of+YDgTY c=1 sm=1 tr=0 ts=6875af6b cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=AGRr4plBAAAA:8 a=zu-KwisgrndMGw3F_dEA:9 a=bOnWt3ThIoLzEnqt84vq:22
X-Proofpoint-GUID: E2cvtMt5fDPQZaA2Kn0_kpnR7GlIowVN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE1MDAxMiBTYWx0ZWRfX+QjenYkv4rN6 OrbWSd6f3Jf9+BVqBGn94Smhz8ynxT+9ApHO/P6rVPOPYe0VEJ/Ill1R07MG5FujpFVbQLZBIIl +LBPgsdHkQ8uNtipAL6fjiP/qe1uOnlCzuWBLkUySlO6eOrzBbUPBXUhFknEActvt0cClu7aFGS
 gWEhSGjmHUshJn2qdv9UqDlVXtRD1dxfq6o/mcEn9TTGaGM3xRKzmDH2Ffnl2rw1o3kMQbCuzfl LkklEleEb1DdP/JXgMR4EOw3yiF6MjeDh30yvMwZeq2CE+VU8fo0tdTwODdAkzoiRyOAMNz/8Ug xEYUrw1ldOFKgPI6VCctbto+L1vO9T4cZ2+K4PeyPUgLF+ioL3rN3/y/6MjtviHs9oO49xFOzYP
 4/STA6/dGjDQ2YSLSfsCY4n53QMJoBRjoY9LExFai8AN48shZSZ3Trj3/PVmfc79qFb6jtN3


Lee/Mike/Chris: Please review!

> In case of an ib_fast_reg_mr allocation failure during iSER setup,
> the machine hits a panic because iscsi_conn->dd_data is initialized
> unconditionally, even when no memory is allocated (dd_size == 0).
> This leads invalid pointer dereference during connection teardown.
>
> Fix by setting iscsi_conn->dd_data only if memory is actually allocated.
>
> Panic trace:
> ------------
>  iser: iser_create_fastreg_desc: Failed to allocate ib_fast_reg_mr err=-12
>  iser: iser_alloc_rx_descriptors: failed allocating rx descriptors / data buffers
>  BUG: unable to handle page fault for address: fffffffffffffff8
>  RIP: 0010:swake_up_locked.part.5+0xa/0x40
>  Call Trace:
>   complete+0x31/0x40
>   iscsi_iser_conn_stop+0x88/0xb0 [ib_iser]
>   iscsi_stop_conn+0x66/0xc0 [scsi_transport_iscsi]
>   iscsi_if_stop_conn+0x14a/0x150 [scsi_transport_iscsi]
>   iscsi_if_rx+0x1135/0x1834 [scsi_transport_iscsi]
>   ? netlink_lookup+0x12f/0x1b0
>   ? netlink_deliver_tap+0x2c/0x200
>   netlink_unicast+0x1ab/0x280
>   netlink_sendmsg+0x257/0x4f0
>   ? _copy_from_user+0x29/0x60
>   sock_sendmsg+0x5f/0x70
>
> Signed-off-by: Showrya M N <showrya@chelsio.com>
> Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
> ---
>  drivers/scsi/libiscsi.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 392d57e054db..c9f410c50978 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -3185,7 +3185,8 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
>  		return NULL;
>  	conn = cls_conn->dd_data;
>  
> -	conn->dd_data = cls_conn->dd_data + sizeof(*conn);
> +	if (dd_size)
> +		conn->dd_data = cls_conn->dd_data + sizeof(*conn);
>  	conn->session = session;
>  	conn->cls_conn = cls_conn;
>  	conn->c_stage = ISCSI_CONN_INITIAL_STAGE;

-- 
Martin K. Petersen
