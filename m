Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C10D529
	for <linux-scsi@vger.kernel.org>; Thu,  7 Nov 2024 02:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730945574; cv=fail; b=rAaRwz1z69yrpqyLuMYeBZe6/JXZNAzSdNabGYt0hkAF1ADXJEhBemGKiLpZjhJQAF74+GuTYMscT9kFkH4/KneDX2KWChEcFlH84RTbX1WLCwYEweHqCyM+MAa50vhH+uQkb7icRiZwJRCl16jG0gdv4GAUK2SzJnZqTBt7epY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730945574; c=relaxed/simple;
	bh=QCKYUnaS5yJaKr8Dhgj8W9OD7N2YJiti6oHkhqHv5vo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=j9z7pkDGAHXYqhs9YxU6KFiS6DRjy9d2K/IKPh9l6EC8A4I2MdKiVD90UUfJ0BRbT0RgX0JuSl6gQWT1VTztn5RP2m3f6Ir0MSaP/4XgXZHfTPPxIHCCpC0ciVbp5FHAGCichjXGZ/P9bnDofEoMCmPenc1LU2B0W5KgesN9aT4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RSu/XSOL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=a8bN8AF8; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RSu/XSOL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="a8bN8AF8"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A71fgaP025081;
	Thu, 7 Nov 2024 02:12:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=TuYR/qJDXd70qSHKld
	+VTAROv7X0RB/ZRgqJkrKqZag=; b=RSu/XSOL2cEMmWiyUlUIdF4B8WAhqL/kBY
	/ohm1n1Eqbdzi/GLENm13+Vl6h78RSS+eKOUVro91etJMY4qxPCLgy0cKlPucAy6
	zRENIbLiyaYjapkgEmI2gbL+eZhsCNNkti8j+HpS0CyW6dO5ii4snW5hUwnL2Rpb
	atMsIBt8PdzuP7EZZW6a0VNYQigRNZsW5T4500iwtnRxWBsK37siXoKQ1/CT2oQq
	V2/CSuRKVcylph8tWS7HK6WwtYgLUbJ/OrUdt0OZrKD/tmLA8hRO08R0Di4Xo1Kq
	rn90yXAzE+ijL6L2Hn2CTyjFPiuq9XFVydsfTlDRpyGHMcTgBk4w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42nap01h29-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Nov 2024 02:12:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A6N9nJg036930;
	Thu, 7 Nov 2024 02:12:33 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2049.outbound.protection.outlook.com [104.47.51.49])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42nah9eyp1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Nov 2024 02:12:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WCaY0zjpKb4OYP0STJU50/JB/oeR71UeAm0wbVEF+rOUbrQHabtxh9+8QYle+m1L/FpmA0Hr4ido3ScyVBUtsd1jWd7NQc3Fjm/YGDgrQ1N8WiUUbfuX7oIKnF2GriUpEKn/hc1onN1OHG5khOcgDIWS2FaBZcbB6tb8WFWl8niac0ABQl8hqO5PesBfLTz41kBuw+cfU1pFnrvbYHDzKksNli8ZdPTVwka0HuXhq0MODKrp6HkFO9YsGuNO1rHOml7N21yIide2a+pY2R3ObFh3xD1eOI+8zqWnAClhcS0DYvAOnnezFMj2pj4wegPMeC2GbhXFKUwixVofOVQk5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TuYR/qJDXd70qSHKld+VTAROv7X0RB/ZRgqJkrKqZag=;
 b=GcrWtO12ZJoTDaeywCADJ6rqfSJjw3rAfZTXUK6FktobrIUCFmyEe1AORX7C4GEH4/maBKi7ybl2lR1pHxFUxWZjrt8KqI7q50esRmDd+kpWQpJ8L7rV4BHfEPyjJfCWpjLLkEZ89QUKPt0ylbuPnvoaNbjnqKQ89Z8E2blSzbzqFZHLZ5fVkre3pnQnIB44zgW0qILyxQEeOKIFyVDkv+lV0iavdW5s3BpVSjpCsglrsv7HXMUVmeT1W7GQunZi4QDMhwCV88t22u7+fEd1m9VpA6CE4s7qXoB6WvgWglc70m9f5R/bC7BMn9dCggWEdvO0ePKccXpWr09pD4c0KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TuYR/qJDXd70qSHKld+VTAROv7X0RB/ZRgqJkrKqZag=;
 b=a8bN8AF8JLz/Wu/qmPP8s7g5vrjWpApOfu0rK8EIL+NgfBQ9x4adO+CDo2FJQScjJHtDbyd58mwdjR1iuJ0t5dCRD5vmV/3MxtVzhn4ButjILC12CcmUDgwWV4LB5QUPDT0xZ1ua5TeAXxZf1UDhuwhQZtJK3C9GKDTkP9hlgww=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by BL3PR10MB6089.namprd10.prod.outlook.com (2603:10b6:208:3b5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Thu, 7 Nov
 2024 02:12:30 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%5]) with mapi id 15.20.8137.018; Thu, 7 Nov 2024
 02:12:30 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Neil Armstrong <neil.armstrong@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Bao D. Nguyen"
 <quic_nguyenb@quicinc.com>
Subject: Re: [PATCH] scsi: ufs: core: Restore SM8650 support
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241106181011.4132974-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Wed, 6 Nov 2024 10:10:11 -0800")
Organization: Oracle Corporation
Message-ID: <yq14j4j23nf.fsf@ca-mkp.ca.oracle.com>
References: <20241106181011.4132974-1-bvanassche@acm.org>
Date: Wed, 06 Nov 2024 21:12:28 -0500
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0295.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::30) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|BL3PR10MB6089:EE_
X-MS-Office365-Filtering-Correlation-Id: 21dae468-9907-4776-0f44-08dcfed1a228
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VLMn0hRsrDsylM+DIECqynYe3XDGEkZzTne4P32AzMiH2TwkDFB7CTgPZojo?=
 =?us-ascii?Q?F1VrmxTu8eFZORuGwPOVSO/FUT+7/OPVPhKMLTPERATbu7I2lCJYoR/MJR5J?=
 =?us-ascii?Q?CLM3pcRTWZ3kZD1rKFQwFfmSiYK7Nb/tygO8Qwxok+JPg0DwE9snXro5WJ5e?=
 =?us-ascii?Q?BPOavx8EiIGNwRFFq/yeho5zluLiycjob5MRc7kbwAJoayIxg3YYVIvJwlRD?=
 =?us-ascii?Q?iqgQdEjPXgUnf10k1MCeNJHVqQigVdvoq64Rpu6yiVpD7ecRNZ6ViY3yj0L0?=
 =?us-ascii?Q?U5T+ZE3BdbYzlnLLhZ2+CoZwCir8slCouEDYdhPNHTKkN/3fOHAptkhEB2si?=
 =?us-ascii?Q?GVsFa8U481DPKfKnvCA+yjl7UUdbj8S2+sDcSsrzq2d5MJhGcC03taZEzvAa?=
 =?us-ascii?Q?89sJdvUXs8YZtEOIvSTpYSAulfGv9xXyHGWrWBUSGAPFbovoQvrS/D6lYZLH?=
 =?us-ascii?Q?bUuRpvE2yGmDVquZYBIr5l3OZn/ZF/Yj/2hHhpD7HjWJ0BWCHtBJ1FXTXQk8?=
 =?us-ascii?Q?tamDXty288S7v9g6j3rIqTOJjOQ19dzOi4MNymiqsBVL4a0Jn3esqJP7sbH4?=
 =?us-ascii?Q?hJE5CmQ+PZsKwBMCDAY2c8zNmzSQsRmV4n+T5322NSu75U7NKAJ9k2NWvhn4?=
 =?us-ascii?Q?Ux6qN+sNsBUDqZx0nBIr/qmWvrE/t0J1TuijkIAWbTOXzh3DinlRplhcuVYt?=
 =?us-ascii?Q?vrxkA9iopYVDjfQ+Qrc6mlAb84ZNBuMjGlOXTw3hfdakuHqFO64GXAit9iZy?=
 =?us-ascii?Q?B3zRI+TcKfIHguo4u1P+AUDwKKHnyk2hL+YB9pZAC8KIUp8aK+di77G8nISZ?=
 =?us-ascii?Q?UXhE9WJLbd46HrLwjFRIgVk1PUad4SiS/3duSbi1+gOvrHDCrAq5OwwWLovy?=
 =?us-ascii?Q?BuijXZIgIQuuZfwhLbJQseXC+eGPJB10qPmwI9v02j6D1kEi3RCl+VtNNI+l?=
 =?us-ascii?Q?EGyUV6BjkCezExj8jhFJ0cHsj5dTBqHV/Rd+pXY2fAAbIiTvtd9ZAEdbs+Y/?=
 =?us-ascii?Q?5QSa290ZY+8MqU3F4VxnkkTSyZZEwRjELwNysMiEIjYUwAdbTKv8iazcXmjJ?=
 =?us-ascii?Q?9xwMNoWDbyW6DlZTgSCG0ghFG9pA6L0yuYLp1BDzBHh9+1yquOCoYs1+aNRE?=
 =?us-ascii?Q?qORkj7Wk45YntwJw2eSO1zKZ8t9u2izTX2XEMaeutv9bPeXfa9XzhyJy0YCf?=
 =?us-ascii?Q?wxFybnZ2+YyFXYerROfk7Xwixtc9S6ClMwq8PmGZANk64jZruFDDzoyuax8N?=
 =?us-ascii?Q?TKvyRf3+FRVL2TfSNcr+UA9xYpm9y7narw3Lw5UgLtK18xaEEN0fYe1RIDR3?=
 =?us-ascii?Q?CN6mrS9w8tHztEmJyNNyo7Td?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ciCuQawt5cCIRkRkyPkIlm2XezhNZKADLDVC2vhpMxkTtwLlRiq2xxpd9lrs?=
 =?us-ascii?Q?Mbj9hfkKjNS6E7K/1UmyUBWh3c1YNlp2HQvOkJH4H/Bzc33Rr5voz2yilVom?=
 =?us-ascii?Q?lWGkiKXrSrXDwL7SvMuQDcJkT/zwBU/UKRE69h9b9NN4KJdV9JgdDHZz+ufK?=
 =?us-ascii?Q?IhHxJY6V7ZzYmApB0CIXRWPfijL+ITRJJ8LL89f0SnUuz2ZRDL0UvpXJWkmG?=
 =?us-ascii?Q?UJETbCQpB06hvUGYKDO29ZL3NGWT+9e3q/Mp6v39Szh6zZ12JT0F3IEUkVws?=
 =?us-ascii?Q?UkKrVOU7lX9IBbw4ym9qKvloh36BgVmnIu71tTIaxY2hNqpZTGvB9OyGaulZ?=
 =?us-ascii?Q?Ij0+9lu3XiL/Wb1LmdCrFYByRb9NCeVrZBtv06oib92HfiQeM29sfcNL2q3z?=
 =?us-ascii?Q?0FbjV1mLEWM+Flaw5tfYOZT7FgR8kNJRAuL3liIT62fBC3HfERw9jUWMb93M?=
 =?us-ascii?Q?DpMzw/mVYePi2WNJygbW3uqA7c5d4CFiY1rT0Quu3clIg3OkSuq9SBxiW9mJ?=
 =?us-ascii?Q?ha9WAbLTs194PCbhkVlkG87NUKUEYW0VtdNd1iMBuH1poFDew6EC3ARwt97s?=
 =?us-ascii?Q?OzXstBNG2kZDwXgJG9mPr90k0iyHKzdfJzitENjgASUxs1dWVoMfSWVKCOAM?=
 =?us-ascii?Q?jmmNSNHOduxxt3wEm7w5SAJ85GiaUBcikBOZiFUL6DnySkRXnNR5974oCjjg?=
 =?us-ascii?Q?eglvCE67oCgiZz/H7SXpxE+Z3PtJ0AVffHvaPA3nlZ04ekb6HMqN/zZ0F9sR?=
 =?us-ascii?Q?PKtFsA/pVzrc2YfCnPkexv4ye1SavekweMKGl99gxZD4UxKg33gcCQDxjboF?=
 =?us-ascii?Q?JOMHfRqd4tmjsw3wNJ6L6+PN1Aaf4WVIDT4bjKZbMyEA5JpvrFVPUT+io8SO?=
 =?us-ascii?Q?DRU+BTUFFaVexz905Db0YJ7zXcqB164U7ay2OpLnBWff7upuSDxjjutIflx2?=
 =?us-ascii?Q?HiPh8K/IXrSoHf2aAXHsXjiW49BRjMtLM3gzs257b1/ZSH+LhbJYMaai98Pd?=
 =?us-ascii?Q?O2bIQp3vOWlM5EJV1hUjjNgm9+C91S/JE7zm+FLLC7wBHBdKAjBTghbqEc1W?=
 =?us-ascii?Q?wS2ZkHAU3YkBiBJuBvjYVb+aWX1bcBfut5T2Bz+HBjh382y9iTMNHhZL7Jtw?=
 =?us-ascii?Q?uY2B8fOVImhCT2JVY6RwDQKVqrEb5k3Kn1WIGURilZFqomR7tbxMvZ0f3msF?=
 =?us-ascii?Q?udmoiRBy66/Qtj6siuBqWZaDtlKr5pC5KXxmXZ5g9ctrnw3y2a8gE+iDDZR6?=
 =?us-ascii?Q?wBvdJd8c7y6HR/rXZNhunR2zW5e5dg8B/56vbDr4h9iJh9B9L0G+YYYhi0Zk?=
 =?us-ascii?Q?jl8RaQyM2SPal6PFwnnPcK6pHcsHKFzw8z+QmRlnsVWbFmnAt5w95XX79SIH?=
 =?us-ascii?Q?po1Yyk11zU1y35LVI9vChV/aJt4rNEUasUErySf/o1pE9KtQpfWD/FCUCXfx?=
 =?us-ascii?Q?O8Mo9Xo9TQJR/HMpqVt4Bb1H+UBhJc6fAo3qfK3r+cLWo3yisyxNXNn9Hkkv?=
 =?us-ascii?Q?bun3P3IZw6yBzmRZU+t+8GOXkBJNeeyax5HREgLXi5vCJrPDujlerMlWIL9w?=
 =?us-ascii?Q?7HcMJvTUmMuyJhvkbAH7hs/nguTRB3/W7SDj9Xp5AAL4jKJwZxvlvA8QbOtq?=
 =?us-ascii?Q?gw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9rl03v3X90294mDSnAnVRMm1Hq8XlU1PHPe8IYVp4cXmxyIM5eRpymzezA7dqaikSBA7Mei572GlxbKYd0NMoqk/d1EdO5venscpod6CGjBko/BNlF6fkd0J4991VnUKxISRVEUu1FQ70UP6IpPt7AJD/p0jQMMlFTrCQfty8G4kVeqsL+hKi06xyjzptlQ0sxIShL/NUXlNBJFuc46Z2k+gQxC+VJRcDlELk9FK6PsASOw8Flpo5EuMPhDUlMzPKztXnYXD/8KWBH8CBADJOIWVvce3fm3uGFBE6hVjxeUb91vCunUmipFBCSa8uvAscIk7ZjkmEKhHFl7Bdlm8a6KZSpQaK8SdsgRThPIyfSNBrNutv0rRZy4ZuHh5Fruab+4m/Ex/+i+GcSVW9FQu5qV7awhpQOKrOdy8SRKHxmu/QPzvbHDYLT+CLBWNjiQF7TmYgsZadegMtwdjk7btW5ipJuTQAisWY2Yi5x1ufp7nhGtAHr39QLHTn4WHCN/Lan4U6T6/rZwfeVa5F6lJ1cNyfZoqqEt1jhE64/ZscJL5epoO/qpmJd45zpk2zovMiruHZc5PWU8NZOKCg+7NLcBkS/fNLTvbW8RkSRyz0Cc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21dae468-9907-4776-0f44-08dcfed1a228
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 02:12:30.2811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b4kIYCZGkyGb+bkFY81F1VYpS//x19ODEz6fkhgCSLBxoRWx3WqIF2BIAOOmtymJzroYJe7GKI3NQc1gIeaZkPhYwKZ4sO0J7vj3ZBoi+UM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6089
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-06_20,2024-11-06_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411070014
X-Proofpoint-ORIG-GUID: lT8L7ShCtNaqwLi-N87gWdrssCHRXDFr
X-Proofpoint-GUID: lT8L7ShCtNaqwLi-N87gWdrssCHRXDFr


Bart,

> Some early UFSHCI 4.0 controllers support the UFSHCI 3.0 register set.
> The UFSHCD_QUIRK_BROKEN_LSDBS_CAP quirk must be set for these controllers.
> Commit b92e5937e352 ("scsi: ufs: core: Move code out of an if-statement")
> changed the behavior for these controllers from working fine into
> "ufshcd_add_scsi_host: failed to initialize (legacy doorbell mode not
> supported)". Fix this by setting the "broken LSDBS" quirk for the
> SM8650 development board.

Applied to 6.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
