Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C92613792B;
	Tue,  4 Mar 2025 03:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741057665; cv=fail; b=Ql4s36PE9r2g6YHMGJhUIAF87moBLsMkJ+9XloEVEyXg2WQGfMr2qLHgCRHanT124CY2BP66jf7EuI0HGQ1noJ2JB8XrfR/GLCuZYUeXB1LTbLN2ZB7CGCIcnuLvVdclC6YgQqhdI5RlCj7SQTSODXA7I4NDiBVbtbQKlSPaYD4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741057665; c=relaxed/simple;
	bh=TMOJf/0S7rbA9VVAMsDZz9GHn9vWMCcaRxt0ANhRU8o=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ppeFGIgjFUHrLa9099Rd7Pa1jcMh+V17W4PZc1s5bNysyU0/5qwi0KLUBeZkXMsS6pRKzGYHsQ0GgcCha64KFeXQJupFprefjT5WazPXLkFQl2zXFqJ3PKh2uVHQpO7cmD8DaOq53P3dwzWAuaqIIeZ0tBjHk5Ig/0CQAIrPCiY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AqVkiRH9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=NhpQMp+x; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AqVkiRH9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="NhpQMp+x"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5241McQs008866;
	Tue, 4 Mar 2025 03:07:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=ClqpLcYdh4eimuocpG
	XNLIREruVvkoRAq6foyrFb6p8=; b=AqVkiRH9gX6uUFflzIYpqM2jEG7kuzsEOL
	/atBbv0T9od6P5CnLErf/xn4coi4/tJkVaJveDITI4u0VUcYvcjh4lshe4agm3eB
	gYnpOYlpt+ZP3mDoXgnKchQ6/CTi0T1Rc7rZBPW9jSF7frFVqcRpdh/m6Wx8s0ng
	Zyyv7wjO9EYOVIReZigmV1Iat53ACQE7EpycA8kMv31+WzYvzTXGEPBGZBTWRZyn
	V9UajEoasKwm4Co3MkzbmCVLB1GBScLDQ9jtizy+7p/dNLkgHfM9tJqohMt5FWNK
	P/6FcdX3FyQY3f1fT8yxQujaIbjBPkXgoKH6RioNIKC0aKMMJLcw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453u8hc3hx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 03:07:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5242spbk022735;
	Tue, 4 Mar 2025 03:07:38 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 453rwuah8c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 03:07:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pvtdhzAJIFMgbtUuH2ezH3/MMHMavK69xo/UV4l4/LPK8rNRgXvnyjIhgoiA8gqfA7rqi70Uo7IJB+L0dI1E7b1NaIWSo/T+gBch4URYjVljvRpXisLToh63uq3oK1QGV8Ukb70vJG9LWVrwnYufvbUR1p1MW3cqk91O4lAGBYwr4q0sCN5l+W6Cd4pMI+zzxdmLHXXA+Ks1bVf6aWZ4rm5/78l6HdVn2ewlj2Zp7/9eVxKJiZcx0DWHN/6qniOZ6ALmM7DTwDxWeMUKvaxEwgIUqDgG8ENDaVBER1EHMrsIr52yxs00HRlsjTAwucgUWnOS0X8lopj0x6S0m8zrhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ClqpLcYdh4eimuocpGXNLIREruVvkoRAq6foyrFb6p8=;
 b=GCBocoLqi8geG69JwgaNDWcMY5kc1aFmWLIZXIFH9mD/ISqIAZL2Sk1PL+aCeRn7VXAupTeAB2BU2Yk+GDL28r48icVHBZetoWJ09s+mvyIXPVc93YWtRBOn0RGaBIlHKjfFdfKak8OeMt4PDA6kRzoykqRrKA6Hq8M/kkn6KwNXV2+KU0a40w3XS1KFsa+oC88uQdBQBJurNcoA4d4qBOyAB4JdbVMv3JJWdyeeZHwJ8hRXb+r0zJP5kMZTHQBTnRq7JvW6Ew0CXlpwoCynOlLUpR3KQeVez+DlcfN4TOongh63WeiHYwFPHVLkzwkdDauuLh/IYdreWxSYCHCASw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ClqpLcYdh4eimuocpGXNLIREruVvkoRAq6foyrFb6p8=;
 b=NhpQMp+x/V9AfTB5lnk5YOk328bIHp9BH1CllTAUotaCjRf29rHGX7zSuMnEfnIvXzQF45Nd5XkCPbnexKsfkucmMeo7x6Cq6W+nfBYMESaCH62urVX+c11Xsr3vG/g6/xls+MpK2WdOgXvfmW2waC0ovlrazhzPN3A9CyxqZwc=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CO6PR10MB5634.namprd10.prod.outlook.com (2603:10b6:303:149::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Tue, 4 Mar
 2025 03:07:35 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8489.028; Tue, 4 Mar 2025
 03:07:35 +0000
To: Karan Tilak Kumar <kartilak@cisco.com>
Cc: sebaddel@cisco.com, arulponn@cisco.com, djhawar@cisco.com,
        gcboffa@cisco.com, mkai2@cisco.com, satishkh@cisco.com,
        aeasi@cisco.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter
 <dan.carpenter@linaro.org>
Subject: Re: [PATCH] scsi: fnic: Replace use of sizeof with standard usage
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250225215056.4899-1-kartilak@cisco.com> (Karan Tilak Kumar's
	message of "Tue, 25 Feb 2025 13:50:56 -0800")
Organization: Oracle Corporation
Message-ID: <yq1y0xlsdci.fsf@ca-mkp.ca.oracle.com>
References: <20250225215056.4899-1-kartilak@cisco.com>
Date: Mon, 03 Mar 2025 22:07:33 -0500
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0009.namprd13.prod.outlook.com
 (2603:10b6:a03:180::22) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CO6PR10MB5634:EE_
X-MS-Office365-Filtering-Correlation-Id: 25ec4f04-aef5-45ff-6843-08dd5ac9b66f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BeFgwMhCjvFJcc6ClAvco9PS4eaViLnxneT8mugSrAy9wwQMs+Bbko2gUDyM?=
 =?us-ascii?Q?cD6MA9j3dQjgdD0hBXbbcMYA938ClZjQ4Db/kXDY6tVxBpX1NoTu3qQ7WDW7?=
 =?us-ascii?Q?qDa16v1r3rLTuyzsPjCZMCns1axiEJCRTGcuxkM0t/g2nop8pCBi1u1oIi2y?=
 =?us-ascii?Q?pvZNFmHOXPTgfhKJN4I1h5wNDYrLakUYl2CX0+M4jz63zEdiR2/aVTz0O5h+?=
 =?us-ascii?Q?Qur82AEUGltaNJsyXZ+Gvm+N5lk1RD5/mKpVtDAPZbhbiv46nuwRCZ0AMtLG?=
 =?us-ascii?Q?01ivLox4gHvUEtA/b0b+FZqZ9WY/eqULyOg6CLS/tP3AWpoIWUJF0YYDFNrC?=
 =?us-ascii?Q?c9itt6ku/ECDJv2rgXDju1dAauZ8UUGlrFrhr9asGJSrGWmqAbxn6qUMykPM?=
 =?us-ascii?Q?3xqalNif9DW0gChchdtQW3luOmxGuGR/StSunjK/3dTwmJYupeVZzSfZ00bY?=
 =?us-ascii?Q?7p3BpVhmHHIVcZvkH+R8LIsFiAfeOg1S0XyBDhf7s+FfFiE2ugVGxKGfrran?=
 =?us-ascii?Q?XjLdBWNRZ7iT/4Ry5WKFEYbZM1tBz5ejqwvD5wCBQum9LKQVpV8DYM7ceoVY?=
 =?us-ascii?Q?xXQx41rxQg94IxuF4VIl2zeVsHiy9c2yHOUo5tPbyigVIr3IMBnqhl8f96qc?=
 =?us-ascii?Q?R2nJSliC7G7RFgoEaDY1s79G6LShVbn3WKgIL+fYWVsjR/YoFH4v/vSL8+Ye?=
 =?us-ascii?Q?y0/F0kzXMb8b3UiSMU1WWfW25cCysTb/J/hkl8e0kS7DCwNjZu8AnJmYoM39?=
 =?us-ascii?Q?IseR5Xvfc0R5i6VQl/rmLqfRIrExldEcQ/RiximLALbpfYOWiyyfFDwlRu4U?=
 =?us-ascii?Q?C6bpFgdpibW/pJVyjrJuz4IpOjggC9fjZBnhaer8tFCHR/w9F4uRoAyq+oHp?=
 =?us-ascii?Q?pnQjSBHMnlxzeI4alJoU5/OBEYPcTXh72ziCqCiCZR69snTzd45+3XYvpcLZ?=
 =?us-ascii?Q?JsvE4KH9PcFW/WjXK3LhRDGr67WD+A8TGmNPpDckYk6AK8k5awWGt+Zi8kci?=
 =?us-ascii?Q?+4as71O1nylJF6EvVW9bJGfCBnn+KYzNRMBD8hmcs6DygIGrDF7nZLgZA7DE?=
 =?us-ascii?Q?fhhX1rt21Pz+6Hm1yqldLURfUKcYy8C/OaH6fLt8+CKm9kCYAEvOHRo8ynBG?=
 =?us-ascii?Q?XoY6/SLJxgeHTavNDhK0JTclwiIVosqwckXDQl+X5Od/jF6kzSZPplbw9tYo?=
 =?us-ascii?Q?C0DcG/WQWYeRE5sOkwh73nAd/dBLcgVc+bGtgDD4TpE81jfDQH+V2YYERm6d?=
 =?us-ascii?Q?TQj5CmcrHRcweJDPuHrDD9WiMbthbH+TTHiLJVRCiPUaGpTPAV6FdAM1maIl?=
 =?us-ascii?Q?E4LFvGsiGodwksnQA37QDzmZLKbk32R4WrvQEa6lS7SaycyBRYyeKxqFPsYn?=
 =?us-ascii?Q?Y44AWrGyeo/qQdcZNtd11dmNsS/o?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RUcbdkUr3bqVJMF+elJ+VRlHZdj1fiwGhnV7Z9bMOICACrZ12zVUke9CXNwM?=
 =?us-ascii?Q?ORttO1SWA5f7B9dWw+kvCtyP4gtM9HhcTJBCG4XdGZZEI4oUEiTtyjnjUmr0?=
 =?us-ascii?Q?mfLDO9xGYdULXRFgo8A0dnm6mw5Lnu50pzxc9zQB5W+Cpz6+X40Yz1iecRwq?=
 =?us-ascii?Q?WXuL4WEmmqCcXVi4988nJAWo2V3X07fv/qQQDt8ymBeVwvzu0n3VgQxl4Adv?=
 =?us-ascii?Q?mTHFuNNy99d5Gs1UZTmmuIRkVcbLF9wuoFL6txkWip6rQcvSxzZi0us6RLN1?=
 =?us-ascii?Q?zxpfCzoBe6vMAS1+YeTfF0bnRfVJkud1ouuVYfY7HqwJREtQXArLwLHVqUvf?=
 =?us-ascii?Q?IEavqEytFwAh8UP77pLL5wue2Hnrd3KJuRFpMYtvySWSOEBC5fl7ZudFXV9v?=
 =?us-ascii?Q?KPPsG+3mfsRTpFsq2EwvRdvUzzunkX9dmSDsYdcWuYvsnTDY8voun7v7rcA4?=
 =?us-ascii?Q?8kp4cWNGyTEzmswoiEoW8XtVUweQE4bYg5ECzeCcws/B+geCmi/FQbO19X7b?=
 =?us-ascii?Q?b+7yltYJI97Y9ivFMcfvLwLDWpZY8Kv+juPbLd+fAMIV61FMlDaEeCjR165H?=
 =?us-ascii?Q?8D7LPy9LhTFanORMhSewyr6qiVqvigchh3I3Q4gG4KoudevO4Eda0iUjv8kH?=
 =?us-ascii?Q?N8sDIV3Hpi1y/lVAWvKkVoBfsErIgxhhrpLXhHaVIlSqzYsclUuYR7FB3GSl?=
 =?us-ascii?Q?OR6ApIAUHF5H2lNG0fre3pKvnnt46IC4UPFgcXlh4mVlUAzRHygt+T9dni+5?=
 =?us-ascii?Q?cWZsHvLIRWdzOWF1Ca+MjgtvyISqPakIXCbhWikH6DJ6WkeNPPZXf/oQ9jY0?=
 =?us-ascii?Q?Dpl4VuBcz8bNpvB2HB6ES8+Kwcql75sUpLfvJN7QeaxVda0v9OsSlQ/a3bJk?=
 =?us-ascii?Q?BH0KZ3soEULnivscKdEXI1+SuTnj0mCxQ/19cMssu5q4u+QG0k31Xb/nC6gk?=
 =?us-ascii?Q?1OOvelmB/ZjguWxUBFESFJwb/AG5xF51OFR+dlZ3qzshLP9djq3ptwzqJZtL?=
 =?us-ascii?Q?EY4m8AqVwILeGz8/Y9QhOZ/YyRk+Iq6gO1dn3PvVkL8xTFVtGkgNEGij9U5l?=
 =?us-ascii?Q?5A/aS6fDhSyiKPf/FFq2pyn/8ZaP+cZGzbGTD8nZh1uX2I8lTxHEpCLRl44l?=
 =?us-ascii?Q?ZDPC/YGCsI/4U6DYJw0Jxw9+TxaIZ5N7Zpt1xNwk+u6ninPKYhJiDrjPT7VE?=
 =?us-ascii?Q?j3mzJU5ep/35Doa5L4L0YdHlKYlirjADtH2xfft4iiZE9vVc68PQwFoUDWPt?=
 =?us-ascii?Q?KyGWSzjJ/ybFFJl9SM3L6pcZpO3YPEfSYNdKr3BOOsznpCush1WKsuryoNit?=
 =?us-ascii?Q?oBPB9VrZY2JmuJolBgEeRhtg/rbaEzuC5jZe3f5EuhM/bYQZYWsVrR1cmbTI?=
 =?us-ascii?Q?HKuIjYF0qCqpzYjsBDEPImAFV+7uf9MQ80QbqLxjtfd2peiSRaoCPKw0aK6f?=
 =?us-ascii?Q?0q4F9cl6t+F/0VKTTGgRkIdZuoKpHmzIRKHqYFbhtJ2jQlr0fdDtnsHXPvhp?=
 =?us-ascii?Q?qA6yqUXQsUGFXgNBT9sHF/o5c2gWFORVu7YVNkvf8s63IQLdPROfIFh8z/LX?=
 =?us-ascii?Q?8UpdNI+il9HlAWNyjSg2F+WVzny1hzWAKHTh2GRbo68mPm+6gd7wayg3OOxi?=
 =?us-ascii?Q?wg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Jj3EL/7C13lZcv+hgfb0KlyCikUtLDxh8RKlhFhNzVh8f059R6EsKCTNyJcVq2doqZubMVn3XlBFOKiqHKq2A4prESpwf6jxpDRPDOQBRimNqMYrqxEyd2uciOqeEZzUyEY4Bjgwftl17nGRIe7teiTa9NEyc+Osj7gAhm2mWtXaP7kAKHBQU9hL5HcfJT0gv2/gTeKzAAlOboFCUjVh1/kiRI53pBqneVX3B8q7sVy2m8njZN7QNY0qBpwMZ5a6Fyoymzl1RODa0LFW/7e6tnQ1NTNx0+e/VcnuScHQVqSuoKRTBHeSzlCgIWV+GL7D4X8Vp331Xky8Vug1Fh4bIL2QwzGHfB9FaugykB/G6I0ABBERwGYZDy7vhs8vlPGUvf93GgUXduumfCZLuoM+9OxQuBnIbGfRcGlVzhVub8VuZWKjBQ2x+8Rpt4XgxxgLji7AYhkNTzBZExiHklBJN+qMF3usuvydi5bWIX0ycdMaffik0XMtOxMdYTEylGFl8TbjXm6ocY7jpsDKS8gJNV0oE83j73/BMiQYjY1Rmodb56HpqL1fwLP6faRUmizsMli6cA1IJWfkPyS1kWUUYE3Qm33D6CpY3JsG/Be1wnw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25ec4f04-aef5-45ff-6843-08dd5ac9b66f
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2025 03:07:35.4110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mohnH1Mlcnzf2T2qtGRWErQgzsuBMp7dEDm4cUWHxvKKPnmc06pJsIA6W1Am2jaSUUzgQBO5D1nNoPrQr1jiEsEHxJmspyFbHivFUC4p/20=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5634
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-04_01,2025-03-03_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=898 malwarescore=0
 bulkscore=0 adultscore=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2503040023
X-Proofpoint-GUID: y9jwUgskaayR5WGHVEvZiDS73RcZLK5x
X-Proofpoint-ORIG-GUID: y9jwUgskaayR5WGHVEvZiDS73RcZLK5x


Karan,

> Remove cast and replace use of sizeof(struct) with standard usage of
> sizeof.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
