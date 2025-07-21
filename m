Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436A7DDC3;
	Mon, 21 Jul 2025 18:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753123916; cv=fail; b=u1MucEgfqniDQc85VVjtSokDMk93hbVIDMD3lPZoNJyxOkRi9Es27axWyAtr/Z0QMBlCfjOcNCPFlGnVsewF294hdqoZ3R56I50OO18RtbtVU3ForJPoe2F/SD9wSOkvWUvhXmD5zlng6761CLVN4ryeQR9DaL94g7d/PK8zK1U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753123916; c=relaxed/simple;
	bh=8UcXx3OiYkeocOoVNOu7usu/3PgIszunE5FGzWHc4EI=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=AGubNbJGI0GS6N+UWkGkeByHdMFq7SfHBvlF7FtT3A6Kijm5zlmHE5+v+dwH3pMJmnzPCr+W5zVjo3x89Xn1Ooh+KavXCx3smpU4atDbjokdEMoA4zulgV2nxhyqcj6Ei3btmxrLj1jFAiE65HCgN6uKiMezxKOOAii4WxfCyKY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kzGjMa9z; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=txCoY6uy; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kzGjMa9z";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="txCoY6uy"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56LHfg6p032557;
	Mon, 21 Jul 2025 18:51:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=CgA5v6ZUPQN7Riw6
	NGFg+7PfFJXDK72bB17xYWgOSwQ=; b=kzGjMa9zL2kvZqVRgSY4s7pn1v4qVQ1p
	jLh8EHc0smDl2ta60rqeGVlw97RNaXHQvqPXo6pjsYlHGjdPdFRAw/dWU/5ODPek
	jpIj//xHYOjaL/1LIG0VTVLnSluQlge5QoXRd8/B1oEsgWxNDAwQYS2ovrM6vhKr
	/Wwo5tNLEv7p7hweTeh7S80HT3Kh+av2WZ7D09wZa024FuZ857rTsUKIqy++G+qa
	GtHDBG04Eeey2HFWGl8CE5j1sc3SgANJho0SBR8vv9nVYJE+Pqz63084Uf7rGH0J
	9wUOVjKNTkFrYGfA+gOTumeiZ90uKnmzo1SreXXFVII8KLZs+WljfA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48057quhmf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 21 Jul 2025 18:51:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56LIcxBv005773;
	Mon, 21 Jul 2025 18:51:51 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2087.outbound.protection.outlook.com [40.107.96.87])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801t8dgrg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 21 Jul 2025 18:51:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fLe9wbjz+p+NTxl0KU2jH3UWoO4qgDAq9ECQpVEp363jGyUlDMDcNnbuZYePNc2a8++sjm9GtIjpkepkn2ca3TlAP+TEyKOYhWTTPNqt92eBM+HFVzvWj6y8W3brsPqpaoM/9wh0DEd0iCiNTQOVfUaX1DWIi2SUcgfX6rmKNeGP4GsDAvuaQ2paAGHEu1k/VY3/GkWtAOBVl2bR9mRW9SaDFMEIDI5pLNIa66QzrbdtGmCqJfsmOfk7C9c/TSwVhAKacfOMn7qJ6r7jqBPy85GhdgnUBqJXWDQSXTCXiXFjmyjA8rBErCPTnot01PlTSF5gQT8oFuR3oIW4l8C7ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CgA5v6ZUPQN7Riw6NGFg+7PfFJXDK72bB17xYWgOSwQ=;
 b=s+vRGqQquMOKdCun4xVfbM/U78r/7YM4EhZTEqODvZKIFgPKdnQlqoENUl5/OQzw9k1Tv1L2pfLWb299GTw8jKSIL8EVgDUelULuiG4iVwLSZbrN3KFy2OeOXqdqbq5J8vSJgPKraE4lTCJzYOxoDeCeM7P0U+Z2LUru1By8US25zBceO7MF8CrTA77EUkswjCYgXYg9eMtUEhku34Zni7XzpsOLKo3DYdIu9xzekQC9wkDFB4AOLJnd/1ur+N4zBmx3up4JP9Cp6Pha7v6iNi3sTKYaq8rmMnHKky6vpqoSnVph28zX6J8bW+GU0rkRJ8WlOn+oA5SrRRRAjshfHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CgA5v6ZUPQN7Riw6NGFg+7PfFJXDK72bB17xYWgOSwQ=;
 b=txCoY6uy6FmDwclYzWmC5z40RA+VrzlUO+3Rw8TBsccKJbpvtutPIzm9xdjZ29GddmjzKNYmvgSYHs++9t7YbH2B4o0RpHD9D8D6/r28Cej/B7Kh/5Uh1ZVFn8Dn2FNVk3Ba05SxKg9qrE0d+XGIbkEdkQv9MJ4y2IVpogwHbBI=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by LV3PR10MB7817.namprd10.prod.outlook.com (2603:10b6:408:1b8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.29; Mon, 21 Jul
 2025 18:51:47 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8943.029; Mon, 21 Jul 2025
 18:51:47 +0000
From: Mike Christie <michael.christie@oracle.com>
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/1] target_core_iblock: Allow iblock devices to be shared
Date: Mon, 21 Jul 2025 13:51:45 -0500
Message-ID: <20250721185145.20913-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS2PEPF00004563.namprd21.prod.outlook.com
 (2603:10b6:f:fc00::519) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|LV3PR10MB7817:EE_
X-MS-Office365-Filtering-Correlation-Id: d06de099-ab5e-4b16-1aa0-08ddc887a4e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?U0LqgGiAeYTRff83I2dd/zgfZHQReJcDDf4SwnoHSH0/xYRRDWe6af07XHR6?=
 =?us-ascii?Q?FXO35ehczPB4k7rr8GTLIuzzxM+EnR5frKGpIDTRfRGukJPS+pBCKFYom2SO?=
 =?us-ascii?Q?Q4da1O8nXIp+IQa7TjV0dOak2aNEZcjEcz/djMQO34VVGpACy/BS+Qeq0eU3?=
 =?us-ascii?Q?Z5TStNPFFiTHw8gnqYTnIQfD0PDPLZC9Rd509fdUZYuoqw7xul2FyJoW1GVf?=
 =?us-ascii?Q?E8vmYDMrGGSsCInEHJ0aLVZOOUHka5o5PctLjqDZCNOMKufDCA/Lvgrci9oV?=
 =?us-ascii?Q?JHJtlkSCpAqxv2PJYbQLt+oyn8uPev/bMCEWoCRA5cXv6l96rj1mKMO5Rwxv?=
 =?us-ascii?Q?yf5MVpdtppLpvkT11h697KFdvVT42aoSV8r0n/zMuOJ4q54oA9EgR4u0hPFX?=
 =?us-ascii?Q?57xyDHMx62xCxc/NAyceGyiSiBVHO2coqAmcQtzuBFtvqhlb0L5SpJiePItu?=
 =?us-ascii?Q?Psd/Pisji9lHAtYZkt2hha5+bx3pjhsYiTJTxgAdL9YoZVVk8E7PePoyz2Hh?=
 =?us-ascii?Q?Cx4bHSj5YN29LxvYf7/atd/wWn9sVsOZDRDqyAmOntAuLPzadRFnuDq5Ta7x?=
 =?us-ascii?Q?VEtnidEdj8+0kym4bvaYyi6jKXfbMrxuLYHOqm4+zb+Yp0JPXKUmQAvDkOGf?=
 =?us-ascii?Q?NSropQSWycGB99IoojKFIvubGSbXpCbRbRnCfhSC0VN5YLiOxkUIxbYjq5rq?=
 =?us-ascii?Q?8FSXkBsE6ktT5QKw0rNC/aBmnt49e802SxGytvUAb+MqdtCW+ygr9BivgB3n?=
 =?us-ascii?Q?goA9n/7hBzNTacUoO46piCeO93hXE7G+eMxdDa7WtvlQL0mPMaO4ihd6zSjg?=
 =?us-ascii?Q?Z30V8SuEAuiHbjv6C8bG/+zyljiaQIdf6ykHEBpJeRpza4D3HwEsrjW09Dda?=
 =?us-ascii?Q?uQtGHAEVAg6nwjVMUkReEjIfUUTTuNZxNJ9nB98f7TR8sy5k3jAxevipf2fR?=
 =?us-ascii?Q?dRjyBs6hiJu8iIsJ2FFfU7eon7pPk6jnWgIIEQVJRT6AvyisSqiq+fNGyWLN?=
 =?us-ascii?Q?mQo2D2sWFyBtQmB6EyE1uCJQVRzHDrGGwzBW5unt/GtIus7qpCuehhcHlXEA?=
 =?us-ascii?Q?7c67Nnf4Z9j6US0rrFalM5NmoLiIAeI/XCo2aHbQgHSpqXXuOLXD9b0sG2cr?=
 =?us-ascii?Q?QP8TDf+lr+lWYKcS74mGWrz/IQUFPyy33JfqTR2cfR+ElRco4NipePLZryvs?=
 =?us-ascii?Q?i+ONoFGdrH71JSRbqArPCrJ8Hm+xLv6OHA5rkoQTA4NLiNYoeP68AdKgM14s?=
 =?us-ascii?Q?pXp07vfYcP67SBTQiLa+JFQcxwrv0bMy6Oq8E5QaXNi5fD1M3vDCjHqjXXT9?=
 =?us-ascii?Q?Uns6FxFqfZHh4DAJDzPeYXkqPlu7LNro0XhKAb0qLy+6sFhn4feqk+3bajEy?=
 =?us-ascii?Q?EdqoN7gQrugC49CHx2RiqGietrYQgjLRLegtcVY9QjpdfhDsJk2uH0NesdRI?=
 =?us-ascii?Q?DwY9c0nRN7c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vEfTa0+56AL1OKEELD2MtuqRiuvKZN+suA+tYd/MDW6Cq8kcgJEHVj/ciCPk?=
 =?us-ascii?Q?mIjNkNqFxuJBk2M2DOyv3DAWfTXwjUghaFMPgUWsuP13Am6TlhzLqvuJxEZr?=
 =?us-ascii?Q?aRtFyLxHSrEYmN+IZ8NK1oVryZ4rNVn8hA/5eaaw8FM1KZsjHT/prO6lENtb?=
 =?us-ascii?Q?5szzSaGExweLP4dI157hz0lYQJZ7D7lU+PW1SE2XBPAvxw+ILuVQUqbXftb+?=
 =?us-ascii?Q?1B+cs/L+b0kVvBryu2IshAq/0K9ie8UwPj5hioU++Oked9Nb6BWdlMd/Z3V4?=
 =?us-ascii?Q?emDCu3A0hAxbuTiq8KyjhO4ZMFALZZ53sZMciq4899VFcbq4mHN6gle4LP7U?=
 =?us-ascii?Q?vOhC0HRknu0Oai1ZCIGrOBLjgw1kXYvhERHUDvqhpd67Iy29RXLYdA6y/XK1?=
 =?us-ascii?Q?Z7VKQvRTAXTCbA1CKYzArks4QyXa9++G8OfdCp3v7hOqnegFyBjFRFJttJRc?=
 =?us-ascii?Q?Y/qwjJHxw7/3q+tz5iwVJY9RpB2+YCg2GyW3R/L4EPFPGel1lgWGJNhL5A3I?=
 =?us-ascii?Q?TTKdb0lD2ca+8T5ZtH1q7Kj/zCa6vOutRlbENoQ6JN/mlVm08GP9F7ZRzVHi?=
 =?us-ascii?Q?/e1GhmBDk0+L6s1GJCXHd9RfxWhCSF6bZZBIMdD3VdugrmlazdF6l6XxLy5O?=
 =?us-ascii?Q?z2wkVGrZ5fovWF4Tb8QQ23xOtChnwpRhrEB7a5zzLJiWj1cRU8HpXP/YcpKu?=
 =?us-ascii?Q?zJ5GtdEbgCnwcb7DRjpZYBEsfIJZX/u1pCumLOImjJaGR0rSksm0XANQmbnU?=
 =?us-ascii?Q?3MRRSor+EtZIvt88Qp1Ij6JHWRp0enHWv3SgsuPv98wNAK51+P8VePvEEntC?=
 =?us-ascii?Q?9tuNoF4TA5A/bAlgMr5FC0SotOIMVk6Q2UtT/9PIlI7B9kYMT1kAN1ObNXHL?=
 =?us-ascii?Q?Sw7Ag2Cw9WWwL23DDie0nICXKPX3YVu4wg9+IklbGzdl5XwaEY+UPVbxfImK?=
 =?us-ascii?Q?eMu2Lv/Ew5XYsPYAmRDZ8KDG7bo8CHh75KapWn22wn4u/Ou17D4qRAB6HAD+?=
 =?us-ascii?Q?caPA7QTArlw9u+L25lmakWWcYoXyF0lcI5Vym0qu29Aq2mN6vWBmBBBzYhNa?=
 =?us-ascii?Q?MYhJN5NjaUUmWEsHFw0ihqpqRmIhv6wMR2JdqMDxeWXfEYGf1AGT4aBXZfKt?=
 =?us-ascii?Q?oE9wYTcVV7Bv4444z4gGeWuj5UnTE2RJ4k2RZBJEMAiYG+PlhPT2VCQ2UjVv?=
 =?us-ascii?Q?3IBboggzHLR5btN16kQ2hJszaQAaMqzaFhGzJUbNklXakuyCorjf46Tx63sb?=
 =?us-ascii?Q?t238BuTF5P1JXC9ln17WxeYVQibDwvLkTtCvv8bBlxxC3PLO5N61trvSi3CU?=
 =?us-ascii?Q?XT7q/aB3EV9BxbNlXyMTNETcQBxkguAc2A74bw8IObnJDv9g4vpuh7iO3Tkq?=
 =?us-ascii?Q?sV7f2xOD09D6oxBzSYHtpXh3KpnNtWrXlHutGLG1ROEOix1L4dPzT194nfKx?=
 =?us-ascii?Q?drI9BDtW7CR/lxgCS1qmj58+rSG6YLXG7/evP4nP3oEHWH9EOprbtDZa5CAt?=
 =?us-ascii?Q?1YDkuruGBLARUNJbEDo4k/HwrbV9G27Z9exFN2i14zegl7dUuV0KU5YXsvzk?=
 =?us-ascii?Q?3wpHQQEJHM8/q+/t9n62mbmIige4BqGQ5DjZZZSskFL9vSYd58R7TrKMPc4s?=
 =?us-ascii?Q?Xw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5e9PdPaUkWZ4RJ+uzHjGJbIqWqq8gsZM6EAvdoCahlihyb1V5EHDzA5TrZXl1k5L83BMTW0Q+pX1LSMXWoEDn9xQjSjJQwIdVkFUBLvRnlEtCKUVlC+DdKSlhwcixignkDA3YMIb+D2op53BSAkHl7osTs/+ND/Jdds1oYUmLplfKYMtTVXX59uyR//svpjIFGIp/BRF383iQ54O9TKx0YZ06PfQC7q97c2wH5nBlLQZCsB/6jfxlgI62pJFcl3H0Tjs3X7dye3DffK2wDtRjKVVoGwFDQ4k1Tfk/I9OmnDWlTc5B8GsZgLbtG2AbosLa/s7mf5Hpu7OI4xX/0MewT/H9VJDoXan+4PWZyx99zl4HI65GfGxEgq57lQ6U5TVA6PP/8jPOL7hjszK9US7iPyh5KTRLYPBFCtxWASqE1cIYYXQbzUiZ9JFiXD7D1+fbt9orCSvlViZPcXsqVgBdivv9XzjQupBc6W56F9BnQ887rR+JcUY0ZnOr8WdR/i1hGWJqYiZf6Mjyoaq9pmlIQ94cxEXFfwJ1vm+wsDl5FcKWuei/NkC/tjVCKHD8e8Gj/xJhGERXcy0SNIvMv9wxqaMGdh883YWcsWBFGInJYs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d06de099-ab5e-4b16-1aa0-08ddc887a4e5
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2025 18:51:47.3271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wv7nNOZvdk13utytRVFIsv5m2/N9hkGSjmvX1tDpdPZLVQCi1ySVfp8MS8iczbCvEfa+jgiBfndvHLE9gw53ssxWiiuWZ1DsrDOu0IGQdKU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7817
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-21_05,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507210167
X-Authority-Analysis: v=2.4 cv=MNRgmNZl c=1 sm=1 tr=0 ts=687e8c48 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8
 a=T5qRgKQKIx96wK50R78A:9
X-Proofpoint-ORIG-GUID: hwc4ZeOmKMuzr1kVg9u_ZA48DdGFroQs
X-Proofpoint-GUID: hwc4ZeOmKMuzr1kVg9u_ZA48DdGFroQs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIxMDE2NyBTYWx0ZWRfX9nfSIA2pDudQ
 U3VZKesypdAiVZIZBHmgFnSFzV/v4j2PaGd/tH+6ZN8GpIDrqug076mJxjt8umAqsrOdeNHoiyQ
 O++IlMQa4qaqkNCohvi7+2dhXatAFV21/a7Mf0ahSZGdjHyvE1NnwUj45Hy6pi9dbud8+r+a35d
 5jfdZz5X66kr0kKlT53Oxy8Mcc1tmGOA/3zCqeZUt3G9A1A3d/7rVez4AIwOyf7z/SVd27a8oe5
 fLZF9vCigi52xOtnnTh2RnijkL98bMTrR5khdAzVnvU+g8rlc/S4UlZxlBKmyJdWSrpvYtAYtnM
 GKNoHxfo4d7oQ1jbQNZcFcxNXCxMjWoLYYP+WiHnlBaiWDd8tFi/wTLUzxGrKvm0KfUqrxtm7aN
 Xy3Istgba4MLum+8mpwddMopNEcY1SGzr599wEtX9kdhvIpYf93aOq/EahlwS/kKANaQCiD4

We might be running a local application that also interacts with the
backing device. In this setup we have some clustering type of
software that manages the ownwer of it, so we don't want the kernel
to restrict us. This patch allows the user to control if the driver
gets exclusive access.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_iblock.c | 33 ++++++++++++++++++++++++-----
 drivers/target/target_core_iblock.h |  1 +
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 73564efd11d2..66c292b7d74b 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -64,6 +64,7 @@ static struct se_device *iblock_alloc_device(struct se_hba *hba, const char *nam
 		pr_err("Unable to allocate struct iblock_dev\n");
 		return NULL;
 	}
+	ib_dev->ibd_exclusive = true;
 
 	ib_dev->ibd_plug = kcalloc(nr_cpu_ids, sizeof(*ib_dev->ibd_plug),
 				   GFP_KERNEL);
@@ -95,6 +96,7 @@ static int iblock_configure_device(struct se_device *dev)
 	struct block_device *bd;
 	struct blk_integrity *bi;
 	blk_mode_t mode = BLK_OPEN_READ;
+	void *holder = ib_dev;
 	unsigned int max_write_zeroes_sectors;
 	int ret;
 
@@ -109,15 +111,18 @@ static int iblock_configure_device(struct se_device *dev)
 		goto out;
 	}
 
-	pr_debug( "IBLOCK: Claiming struct block_device: %s\n",
-			ib_dev->ibd_udev_path);
+	pr_debug("IBLOCK: Claiming struct block_device: %s: %d\n",
+		 ib_dev->ibd_udev_path, ib_dev->ibd_exclusive);
 
 	if (!ib_dev->ibd_readonly)
 		mode |= BLK_OPEN_WRITE;
 	else
 		dev->dev_flags |= DF_READ_ONLY;
 
-	bdev_file = bdev_file_open_by_path(ib_dev->ibd_udev_path, mode, ib_dev,
+	if (!ib_dev->ibd_exclusive)
+		holder = NULL;
+
+	bdev_file = bdev_file_open_by_path(ib_dev->ibd_udev_path, mode, holder,
 					NULL);
 	if (IS_ERR(bdev_file)) {
 		ret = PTR_ERR(bdev_file);
@@ -560,13 +565,14 @@ iblock_execute_write_same(struct se_cmd *cmd)
 }
 
 enum {
-	Opt_udev_path, Opt_readonly, Opt_force, Opt_err
+	Opt_udev_path, Opt_readonly, Opt_force, Opt_exclusive, Opt_err,
 };
 
 static match_table_t tokens = {
 	{Opt_udev_path, "udev_path=%s"},
 	{Opt_readonly, "readonly=%d"},
 	{Opt_force, "force=%d"},
+	{Opt_exclusive, "exclusive=%d"},
 	{Opt_err, NULL}
 };
 
@@ -576,7 +582,7 @@ static ssize_t iblock_set_configfs_dev_params(struct se_device *dev,
 	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
 	char *orig, *ptr, *arg_p, *opts;
 	substring_t args[MAX_OPT_ARGS];
-	int ret = 0, token;
+	int ret = 0, token, tmp_exclusive;
 	unsigned long tmp_readonly;
 
 	opts = kstrdup(page, GFP_KERNEL);
@@ -623,6 +629,22 @@ static ssize_t iblock_set_configfs_dev_params(struct se_device *dev,
 			ib_dev->ibd_readonly = tmp_readonly;
 			pr_debug("IBLOCK: readonly: %d\n", ib_dev->ibd_readonly);
 			break;
+		case Opt_exclusive:
+			arg_p = match_strdup(&args[0]);
+			if (!arg_p) {
+				ret = -ENOMEM;
+				break;
+			}
+			ret = kstrtoint(arg_p, 0, &tmp_exclusive);
+			kfree(arg_p);
+			if (ret < 0) {
+				pr_err("kstrtoul() failed for exclusive=\n");
+				goto out;
+			}
+			ib_dev->ibd_exclusive = tmp_exclusive;
+			pr_debug("IBLOCK: exclusive: %d\n",
+				 ib_dev->ibd_exclusive);
+			break;
 		case Opt_force:
 			break;
 		default:
@@ -647,6 +669,7 @@ static ssize_t iblock_show_configfs_dev_params(struct se_device *dev, char *b)
 		bl += sprintf(b + bl, "  UDEV PATH: %s",
 				ib_dev->ibd_udev_path);
 	bl += sprintf(b + bl, "  readonly: %d\n", ib_dev->ibd_readonly);
+	bl += sprintf(b + bl, "  exclusive: %d\n", ib_dev->ibd_exclusive);
 
 	bl += sprintf(b + bl, "        ");
 	if (bd) {
diff --git a/drivers/target/target_core_iblock.h b/drivers/target/target_core_iblock.h
index 91f6f4280666..e2f28a69a11c 100644
--- a/drivers/target/target_core_iblock.h
+++ b/drivers/target/target_core_iblock.h
@@ -34,6 +34,7 @@ struct iblock_dev {
 	struct block_device *ibd_bd;
 	struct file *ibd_bdev_file;
 	bool ibd_readonly;
+	bool ibd_exclusive;
 	struct iblock_dev_plug *ibd_plug;
 } ____cacheline_aligned;
 
-- 
2.47.1

