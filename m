Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3972DCBF7;
	Wed, 17 Sep 2025 22:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758147235; cv=fail; b=JqsAMhpOsneaET7zzJ/4PXBYtkWwjm/ATVHNd/jkV7ZcPawClAsGzwS8RfV+QfHJqIYu2P8P8ezVs+CFyFe2vxrj8jPEjUqxCyrLNIX/3BBEPRvzFT0sa/WSkLQ6OIOd/+kQVojdytvgQztUPRtpS+JSICnYZrul3ZuqnJrTx4U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758147235; c=relaxed/simple;
	bh=nrxkWTuRaElC7+WsaXcwpUEm7shmPLTwNVUjtiA/Ykg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cpNkgGMgMRwM/CYlqNF17ixonktrdJkQmmT/tgKPOaFcFNlXILlEq7gWnJpwyuwqCymDYB9cO/e4cEG3jYEzmOJ+DZMTrCL2Y3D9rUNyVoj0eQ0plToFeidIBleiAlajQeDr2HPW+0ZVDnGvFrIGbAikURde3Aij3/p/C4S4JhM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QYuTxKWT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ja8iAmt5; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QYuTxKWT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ja8iAmt5"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HEITdl007388;
	Wed, 17 Sep 2025 22:13:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=DiDTUkik2k0m4+iQFRCz9lSJV6/byn2WTUpsXgGdP1w=; b=
	QYuTxKWTBcpjvW53Xjg/nm4dp++pZTvyhHGDTQbVqPEzBLbhxW1q5coWKraA4+fk
	SclfLX4EGfIWpCkQSm5SqqwEyM7VpT75KN+hGzv/THBL0Y8YGrUYWmpQ8CAfgrHf
	7P+T8taOeLVaIGAztA8YhcqIGfY+YCZxcZNoeouL+6na6lEg8wUr35D9AM2v9msn
	+c4nYAmm/m5fJo5R0xccNG2BZYXb1FqoIz/9SAtwmDqwldGzIuGFYXTOKV2998IT
	uuEhviaSLwAuttfmXVLqgQbkFX3U3N48GGWM45f1/R1HcWyV25nhplP1TbSXZPZN
	PqtwoGlHWJ5cSfU76jIDVw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fx9295m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 22:13:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58HJocRa028809;
	Wed, 17 Sep 2025 22:13:46 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012070.outbound.protection.outlook.com [52.101.43.70])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2eaq33-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 22:13:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RRhx9b2owOSJwLncL2mYfrpdMXKW5oWSYKsMwKG5kUjaH6sx+YgslVnc2rD4vCldI6weEvtgkQGfJeXizZ7yPwlIfC4Iu9myGK9vPWZRuXgTbMl0uaqcK+ykXqcGLphr1VvnfqcE8f+5mx64hLhXhfa6iLP3BwAFFhNpGbPXTKNL2oeFxwz9NtCDUFnqZ8s0/7bL+c1ACY3Bh9wUtwBqpoRJSWHLr2vV5W+uiHhitgQocDMjUC/+aT4lRICeOBkjGNLgwOEDgoR54iuAFA6c/9rwroTD0PDJYOqyfrV6cXZ0SRRLq1OXqPVkndypCRJF0BCtSqzU3ab1K+cHh2gwPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DiDTUkik2k0m4+iQFRCz9lSJV6/byn2WTUpsXgGdP1w=;
 b=ZLnb+WTboG1PGfqs2AzmmE51KTAZMhl6Bnl1Dc0dCq2QHLaEIynkOuqNC1CLfwn//cZaZlhKokjSfcJlzKhI9S8/n/f55lSb+tvkcriXMbrZ0j4Qz7zxeGkfIB7nSXyJUyM1iuhof1YxH/SzBE5CIaUrE6M9W6PxkLRcGL3BgfzX8kf06JkSl1f2pwqClQDM7lLuGaZAtiXAQZbuV9bNG+PqXyhjB3jPhQoIbwMAo4N9QwlKiE1plnnXar5ylf1/250AcFLq1VlxNtDpmDmBtP0DHBdQeVg8iYBzSyprZMJarUmWtlF9GIiRdEtAp83/YN5X4NbsOjfvbXHFieCchg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DiDTUkik2k0m4+iQFRCz9lSJV6/byn2WTUpsXgGdP1w=;
 b=Ja8iAmt52jXHJucy0w2XfFwjOxptIEi4twmLWLbzyaElLK3W5kVtsEdP4WGsc9QuFcC3bvs1UBglanjvAslKN7Z7yjRwgLAr92nEqLUSr0lj6K6+Sx1HJ+qnqp9146V/nccetX4Cbip1J6SauGWQB7QO+gM3X1uI73vxRfQF9xM=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH3PR10MB7564.namprd10.prod.outlook.com (2603:10b6:610:17d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.18; Wed, 17 Sep
 2025 22:13:44 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%7]) with mapi id 15.20.9137.012; Wed, 17 Sep 2025
 22:13:44 +0000
From: Mike Christie <michael.christie@oracle.com>
To: mlombard@redhat.com, martin.petersen@oracle.com, d.bogdanov@yadro.com,
        bvanassche@acm.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 2/3] scsi: target: Create and use macro helpers for per CPU stats
Date: Wed, 17 Sep 2025 17:12:54 -0500
Message-ID: <20250917221338.14813-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250917221338.14813-1-michael.christie@oracle.com>
References: <20250917221338.14813-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR07CA0019.namprd07.prod.outlook.com
 (2603:10b6:5:3af::7) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH3PR10MB7564:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a29dca4-b514-46b3-f9ec-08ddf637771f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JwnsIbVF5fteOhOr/IOm5HhxDZp9q6u5SpMhlT2/VI5V8evhXiZo22o42GKH?=
 =?us-ascii?Q?gqHrqcTs47sjnppXeIBcMTRZxZ4zweQ59lv54E4zw14BAmgMdeoxr91VawQ+?=
 =?us-ascii?Q?bz17H1iK9s53qirJUD4OG6s+z3k+UBaqb2DKB4eRy4GTAoqTzuTNTkHRRTGv?=
 =?us-ascii?Q?eEKH3UoLbVjA9bjcGEQssbCTFcVD1DKA6OSB9anYnbPQKpsJk/O8Yegl04Al?=
 =?us-ascii?Q?pFBeaPCQNeOmsJ5tU6b3ydHaoDxIk41Cz/LM2q9sumKKpegK0c4t4iPEHi2T?=
 =?us-ascii?Q?+jB2t7fqUPPQEcpV7MZ9G7kCg2T5CLejJAh8ntDzFLTV5tXQQpequIgvHOvH?=
 =?us-ascii?Q?97hVfN584ENNVgAmC3IOKqBr/l3X32VzJeHVq/DNgMl2z7KPm2bCBXoK3tDJ?=
 =?us-ascii?Q?qaA2QgeV5txzm1yAf2BDbf9586MaCZ1KNgj5iBlk6/3hFjIRcMSAA5xOUomO?=
 =?us-ascii?Q?qj+hInct6bMmbC7hmOnUcoSKblGJu22dzUhm0LDRs9YSy5HBiuOau/y/e259?=
 =?us-ascii?Q?dYoIqr/oJ2R8dgM2NnvMtQlDpyyhwRgnBHIg3B3hFCTDP3qrxG3c0QihvtWL?=
 =?us-ascii?Q?6oVyInfkm5OBIIzSqxDfuE47jym+f11782TW6dp//ZuFV+1MIcOwlHkj47Z2?=
 =?us-ascii?Q?O6GNC2d8j9gdIFBu9+DTqVZKWfW0IHzk361+g5zfLTEv+acxEay2FU7kRz3m?=
 =?us-ascii?Q?XuQZb9G3SvV0Xm+MrExyeN1z0zpbjG1VMurWOex5ngbaUNvA2r79gti8oFx+?=
 =?us-ascii?Q?FzxXO9CbAKHh64x0EDrk5HNO4hCZSzEC8KT2wxysh5/EJeNqjgrKJUmDMPAL?=
 =?us-ascii?Q?e+gVysBeqsXSSiumgfFXRhU8IxnS6AK7kFnB4ZQC9705Q51yCQDn5RlBxVvB?=
 =?us-ascii?Q?wDokvVPp06t9oeB14H3lHwErSRk96Gcx16shY+Z42tA36/kiRF+U1BoPq23C?=
 =?us-ascii?Q?Qo0Pk8KmuSPnnSzOysUi0bVpO5Tw82eSj3VKgP7pv8i5l5tI+Nr1mayOHpUN?=
 =?us-ascii?Q?xgcUUMLmzYlW4QP8/LwbQxuZ1hXsPIseAhgP4mjk/qKT0Lx3j8fGPWqnwsBN?=
 =?us-ascii?Q?gv1JJJZxXCq+T7N3FIce8LlzLbc3Z0STTkP+2657IJfrA19HvPhegzRZEhaK?=
 =?us-ascii?Q?zn623JnDhfUMoExTxg/dGZa0uobGQ5IfLW7XgP17rWT8O/gk5UQA8Y28uLGw?=
 =?us-ascii?Q?GEaDe+xcxyrTzI9A9QfuDMNm59SFJqu3rPCxRZaymLh4SN7h6Y5RNkO25JUN?=
 =?us-ascii?Q?O/a3MK9AzWyvSfJdXd6bG1XAKyqP3JoSNbzgy9HefHbMuW6Wg4CvyKf7m4KY?=
 =?us-ascii?Q?VJ7RFDDWgkQwbhFZgS2iD73r/FxRQUQAaeo2NM0H8DDOqz1Nqt823etoWyz8?=
 =?us-ascii?Q?yzRRVSB5vkZb/m7vAUdDajz3CNQi4yeShEViADhIULtN8yxdav+JIYClxn9D?=
 =?us-ascii?Q?Q7wAGz4MfQ0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hqocf5vgDiGbPn0ScOivI9PKba5ExbPrgfb1J7FMZI7Gumw7ZW0ydx/dfsbP?=
 =?us-ascii?Q?6spJFtVS/Kz7Y4jAZfMx/Xy2dLiMvJR5mvO2Om0YE/kv5RNIgiLAk+zQhSfG?=
 =?us-ascii?Q?jXAHNdJ8XgxFNhQDW3VgnGPG8bG+hokGJ9OPFQAFetKfCrYrNe+qVt9Hedvb?=
 =?us-ascii?Q?VsiopMpqcKo1ig7pqC2QvV8TLYd9jPyECwkuy6GJq1k9JvjBCa/S2OKdyFJ3?=
 =?us-ascii?Q?cfv9cFO+IC/LoLMzgIQxBy+Pb5uoJh2OVmsy5d0tqIGMqaOD7O2fOYEvbKry?=
 =?us-ascii?Q?ZDCnGzUxETRJHt1AoTyXHIKjswRORKymDtzJQ9dugeUY5qEw0Jq2MlyiPxB1?=
 =?us-ascii?Q?wzSWdc73hYv/fH0nRA5QrUd2iGWunxZb/uy+mFietKk6tgu+GLGP3iA+16Pu?=
 =?us-ascii?Q?loxkLcyNX7RXuZ/B7xgLWfFEn9qJKzR6BLugISntUTUHkKNi6+io4oboSeJh?=
 =?us-ascii?Q?yQJReRFNgx8hSJ1roGdvA0Z+HdJ+pzPLsMGRf5bFRq/Da0kmbc9V1D63AAWh?=
 =?us-ascii?Q?hIsVlblzC4zdhTUoFPS4YuZx8a5nGHFzODsFIGCJis3XbH1x+X3QxzSigp2a?=
 =?us-ascii?Q?1gKYxhJeK4xgZRMO+ry7G8XEsxIfCw4OX3OQRKlkxEjQIlYEQH6ghhUWzSUh?=
 =?us-ascii?Q?lZSSwF0Muw5s2l6I1chHwVoiCzGcNSqeHNqZRdNNZ4v6LccNsG7q6v60Pmor?=
 =?us-ascii?Q?OBzs0+nYR8cb+aG9tmCao+Dj7LeavD8Es4DCBod2I9jauFvc4r7lXkNyWCrB?=
 =?us-ascii?Q?EzwO5zSyw/ZXsZCKYOvjTS/MrJgXfHu+P5Ywf7OQpBa6Mk2TZ8jQHxgJPlkt?=
 =?us-ascii?Q?QIlg0tUOfVUZvo/vr3bS/hWaaKJGI9nKEjgJNVaKD1vl57KmFVugC2kt6CtL?=
 =?us-ascii?Q?rANLK8sGDBoPiE5pR5F9ylcMotPJ6N7lFACTXCcokF0+Qgd/M9j+yyRQ5NLN?=
 =?us-ascii?Q?+MwH5HavEecU1ejBDGjdNKqEvU+Acv6myfBF8rqDpUP1Ln32iv2rEPZkZfVM?=
 =?us-ascii?Q?cOQ+osOGI689UOf+macieJiHBOUz3xYz8HsPGo7FHRMns0muptniVSmots/7?=
 =?us-ascii?Q?BB57caBD66dC+aIDBPbt/W1U613XdmjDhzNRsN5LDsvIO1ANdQgM517V8W5a?=
 =?us-ascii?Q?KYUcATpzqs/Cuz9EhhN3psySIVWK1hvHc+DzcJyln3Xxwy1JyQQkOmVKBuIf?=
 =?us-ascii?Q?15S+Z3wcQfw37QnNQ1FeeOmviXvHsXFqaS8/2TfqCoAkfq3xOpxSTweb28T9?=
 =?us-ascii?Q?V6Ve5xxHK67xgho5cwTXGoysvtxJhToHxwGkNUbCl9KKgtZ7TfgnOTJhoYy7?=
 =?us-ascii?Q?APPpdexcDXaX753h/b2RAYE7oN/+vnBkzyk3egeWkvcFfWcTukdwTEgOCYxz?=
 =?us-ascii?Q?oBjg3aGKi8+kmU5PGEpZvg3tS4yIk5DZXNLjbovlKrygiI+75QP0NpiLg6hG?=
 =?us-ascii?Q?fnZhhotz5MXKJbROtlEoNOq0jZ5qON8HuiKFfeHTCYdVhSJOPCywpFBUj513?=
 =?us-ascii?Q?RezWCpOMOE908rL8fUaBv2z1xdf6atdQgp+vGEfRO2/Pszk/nQzVH2UepSWB?=
 =?us-ascii?Q?3Kt9q85wB+Z4Fd7ikPOcgTPm5HeebEBl/50UcIkK7Xzw51pvAEy8kfxDU5qO?=
 =?us-ascii?Q?rA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vJWA96ZGVyXgxyFa4spVbFhkTWn+N8axyrNEwqphyTSxoQ3Spi8zXMAN0+ESv/Is5vuHKSCOuP1J9J+UFEBFTrpL/bk/v4V22Dggnjl6wg6hAU4SRFdeRRNA3HwiXiW5gy2GQHrT4KrElpqbiL6YtI64gB8cb3850D49RppBiKfLfoORnH+GkCNiRmGrRNcgyIh2N3KHt4n6D2aao1JO5iIS0CXsAgJZQeKVgOuMI6yxmm5qmYJeIFvlqZYgE++PfMXDrGK5sNHljDXJ5Nn4tHXymIT/AKNJQyyut8rm1BrCEVHCSOSkKjNTrnk79aOnb1iVxP5kuPotn0cMDalw0/G6jwX9kz45RAppkENKJ1eav1qPwuq08sGLBs/imCdGHhUPdLQFzXnAkNEGq2hjkqLY7mIlceQWeZQRJWeKe5n2PR/sQK9Q5BZOKYnLhA5yuOAl8OlvwuU6qESD+Y0C2am72cXpJiRZZPJA8+CuS/wbT4WbSkh/6SmKXJ+aYMHPfoa5acGZvDdDgYzPIbBxB1ry8N17HnRUfKXDr7g5aL5LIPzArIJF/hoznphZ+z/rSVN4GxlareEXGHs1u5QPB0FjFc6RMTbBQ2nbniZ1Oc8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a29dca4-b514-46b3-f9ec-08ddf637771f
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 22:13:43.9854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fzRarhAKLftudjdYRWDPfcUvvchig793O5iioU4GafR7MqopOECumhpIU80hmUHLYRUTOS/xnB7+IhGHc99NZQboEzw0KSs4X5cl33jJ+jU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7564
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509170215
X-Proofpoint-ORIG-GUID: E9_4vouZmm_uK5SvNSlkJFAIzd54lgFw
X-Proofpoint-GUID: E9_4vouZmm_uK5SvNSlkJFAIzd54lgFw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX9ZmuwHuMeHc8
 U4/ZOs/NQGaPntgSbh+4Sh/z7wlyPiXnPOpLiPtmDUmoYa0XJ20JKW3wFSVcgIpkG+r8cirY9Mu
 PPbgdw7C118Mk0ZVA7ncxQsN1DVe+7uyj3m+Zo531UUi3Fs8To0vMOc9xqonSLOvivGRbYq+8P9
 byutLfw3Wa6kQocHKZm6UuHEvOKjgYSPy5GiB6nVDoYYzQOjURflRYNExH8uBOijksVEyUHziX1
 nt5zfqZQ1x6wl/EJuq3lhPbHtKGJFL1BS0stz1Kb1hIrnxmwm00sJUyh2YGVVsu6tkawh2bUWHN
 1sG03gkUlJHsNPvs4mfW19E5L+duMk/EVeX0gG2CIneZJv3x08yXRDl970LC+2HImaieM7HFEFH
 qjAr7ULL
X-Authority-Analysis: v=2.4 cv=N/QpF39B c=1 sm=1 tr=0 ts=68cb329b cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=-c9VzbpeAAAA:8 a=2nhI7uIJQZ1U3olpLWUA:9
 a=WAq88MDkwfy8HpmZFCM0:22

This creates some macros to reduce code duplication for when we handle
per CPU stats. It them converts the existing LUN and auth cases.

Note: This is similar to percpu_counters but they only support s64 since
they are also used for non-stat counters where you need to handle/prevent
rollover more gracefully. Our use is just for stats where the spec
defines u64 use plus we already have some files exporting u64 values so
it's not possible to directly use percpu_counters.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_stat.c | 197 +++++++++---------------------
 1 file changed, 61 insertions(+), 136 deletions(-)

diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 4fdc307ea38b..e29d43dacaf7 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -276,56 +276,39 @@ static ssize_t target_stat_lu_state_bit_show(struct config_item *item,
 	return snprintf(page, PAGE_SIZE, "exposed\n");
 }
 
-static ssize_t target_stat_lu_num_cmds_show(struct config_item *item,
-		char *page)
-{
-	struct se_device *dev = to_stat_lu_dev(item);
-	struct se_dev_io_stats *stats;
-	unsigned int cpu;
-	u64 cmds = 0;
-
-	for_each_possible_cpu(cpu) {
-		stats = per_cpu_ptr(dev->stats, cpu);
-		cmds += stats->total_cmds;
-	}
-
-	/* scsiLuNumCommands */
-	return snprintf(page, PAGE_SIZE, "%llu\n", cmds);
-}
-
-static ssize_t target_stat_lu_read_mbytes_show(struct config_item *item,
-		char *page)
-{
-	struct se_device *dev = to_stat_lu_dev(item);
-	struct se_dev_io_stats *stats;
-	unsigned int cpu;
-	u64 bytes = 0;
-
-	for_each_possible_cpu(cpu) {
-		stats = per_cpu_ptr(dev->stats, cpu);
-		bytes += stats->read_bytes;
-	}
-
-	/* scsiLuReadMegaBytes */
-	return snprintf(page, PAGE_SIZE, "%llu\n", bytes >> 20);
-}
-
-static ssize_t target_stat_lu_write_mbytes_show(struct config_item *item,
-		char *page)
-{
-	struct se_device *dev = to_stat_lu_dev(item);
-	struct se_dev_io_stats *stats;
-	unsigned int cpu;
-	u64 bytes = 0;
-
-	for_each_possible_cpu(cpu) {
-		stats = per_cpu_ptr(dev->stats, cpu);
-		bytes += stats->write_bytes;
-	}
-
-	/* scsiLuWrittenMegaBytes */
-	return snprintf(page, PAGE_SIZE, "%llu\n", bytes >> 20);
-}
+#define per_cpu_stat_snprintf(stats_struct, prefix, field, shift)	\
+static ssize_t								\
+per_cpu_stat_##prefix##_snprintf(struct stats_struct __percpu *per_cpu_stats, \
+				 char *page)				\
+{									\
+	struct stats_struct *stats;					\
+	unsigned int cpu;						\
+	u64 sum = 0;							\
+									\
+	for_each_possible_cpu(cpu) {					\
+		stats = per_cpu_ptr(per_cpu_stats, cpu);		\
+		sum += stats->field;					\
+	}								\
+									\
+	return snprintf(page, PAGE_SIZE, "%llu\n", sum >> shift);	\
+}
+
+#define lu_show_per_cpu_stat(prefix, field, shift)			\
+per_cpu_stat_snprintf(se_dev_io_stats, prefix, field, shift);		\
+static ssize_t								\
+target_stat_##prefix##_show(struct config_item *item, char *page)	\
+{									\
+	struct se_device *dev = to_stat_lu_dev(item);			\
+									\
+	return per_cpu_stat_##prefix##_snprintf(dev->stats, page);	\
+}									\
+
+/* scsiLuNumCommands */
+lu_show_per_cpu_stat(lu_num_cmds, total_cmds, 0);
+/* scsiLuReadMegaBytes */
+lu_show_per_cpu_stat(lu_read_mbytes, read_bytes, 20);
+/* scsiLuWrittenMegaBytes */
+lu_show_per_cpu_stat(lu_write_mbytes, write_bytes, 20);
 
 static ssize_t target_stat_lu_resets_show(struct config_item *item, char *page)
 {
@@ -1035,92 +1018,34 @@ static ssize_t target_stat_auth_att_count_show(struct config_item *item,
 	return ret;
 }
 
-static ssize_t target_stat_auth_num_cmds_show(struct config_item *item,
-		char *page)
-{
-	struct se_lun_acl *lacl = auth_to_lacl(item);
-	struct se_node_acl *nacl = lacl->se_lun_nacl;
-	struct se_dev_entry_io_stats *stats;
-	struct se_dev_entry *deve;
-	unsigned int cpu;
-	ssize_t ret;
-	u64 cmds = 0;
-
-	rcu_read_lock();
-	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
-	if (!deve) {
-		rcu_read_unlock();
-		return -ENODEV;
-	}
-
-	for_each_possible_cpu(cpu) {
-		stats = per_cpu_ptr(deve->stats, cpu);
-		cmds += stats->total_cmds;
-	}
-
-	/* scsiAuthIntrOutCommands */
-	ret = snprintf(page, PAGE_SIZE, "%llu\n", cmds);
-	rcu_read_unlock();
-	return ret;
-}
-
-static ssize_t target_stat_auth_read_mbytes_show(struct config_item *item,
-		char *page)
-{
-	struct se_lun_acl *lacl = auth_to_lacl(item);
-	struct se_node_acl *nacl = lacl->se_lun_nacl;
-	struct se_dev_entry_io_stats *stats;
-	struct se_dev_entry *deve;
-	unsigned int cpu;
-	ssize_t ret;
-	u64 bytes = 0;
-
-	rcu_read_lock();
-	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
-	if (!deve) {
-		rcu_read_unlock();
-		return -ENODEV;
-	}
-
-	for_each_possible_cpu(cpu) {
-		stats = per_cpu_ptr(deve->stats, cpu);
-		bytes += stats->read_bytes;
-	}
-
-	/* scsiAuthIntrReadMegaBytes */
-	ret = snprintf(page, PAGE_SIZE, "%llu\n", bytes >> 20);
-	rcu_read_unlock();
-	return ret;
-}
-
-static ssize_t target_stat_auth_write_mbytes_show(struct config_item *item,
-		char *page)
-{
-	struct se_lun_acl *lacl = auth_to_lacl(item);
-	struct se_node_acl *nacl = lacl->se_lun_nacl;
-	struct se_dev_entry_io_stats *stats;
-	struct se_dev_entry *deve;
-	unsigned int cpu;
-	ssize_t ret;
-	u64 bytes = 0;
-
-	rcu_read_lock();
-	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
-	if (!deve) {
-		rcu_read_unlock();
-		return -ENODEV;
-	}
-
-	for_each_possible_cpu(cpu) {
-		stats = per_cpu_ptr(deve->stats, cpu);
-		bytes += stats->write_bytes;
-	}
-
-	/* scsiAuthIntrWrittenMegaBytes */
-	ret = snprintf(page, PAGE_SIZE, "%llu\n", bytes >> 20);
-	rcu_read_unlock();
-	return ret;
-}
+#define auth_show_per_cpu_stat(prefix, field, shift)			\
+per_cpu_stat_snprintf(se_dev_entry_io_stats, prefix, field, shift);	\
+static ssize_t								\
+target_stat_##prefix##_show(struct config_item *item, char *page)	\
+{									\
+	struct se_lun_acl *lacl = auth_to_lacl(item);			\
+	struct se_node_acl *nacl = lacl->se_lun_nacl;			\
+	struct se_dev_entry *deve;					\
+	int ret;							\
+									\
+	rcu_read_lock();						\
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);		\
+	if (!deve) {							\
+		rcu_read_unlock();					\
+		return -ENODEV;						\
+	}								\
+									\
+	ret = per_cpu_stat_##prefix##_snprintf(deve->stats, page);	\
+	rcu_read_unlock();						\
+	return ret;							\
+}
+
+/* scsiAuthIntrOutCommands */
+auth_show_per_cpu_stat(auth_num_cmds, total_cmds, 0);
+/* scsiAuthIntrReadMegaBytes */
+auth_show_per_cpu_stat(auth_read_mbytes, read_bytes, 20);
+/* scsiAuthIntrWrittenMegaBytes */
+auth_show_per_cpu_stat(auth_write_mbytes, write_bytes, 20);
 
 static ssize_t target_stat_auth_hs_num_cmds_show(struct config_item *item,
 		char *page)
-- 
2.47.1

