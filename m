Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635ED1804A
	for <linux-scsi@vger.kernel.org>; Wed, 21 May 2025 02:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747793040; cv=fail; b=il8hCQbKIAJjYh1/rnWczCO15R4/pqH28YgNL8crx+MRVCDW2832zjqtqf71qkezkRnc7EgSc0ewTsIqNG2n1uHVzH3wGW6rzJka+qG2LaX5LaPWllqdb09COiKYrN1wuH8EBAvV87zE0ekVr+lKfBTKsQ2i3FVPSJrAUrNsjPY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747793040; c=relaxed/simple;
	bh=W8FumSh+QAtYvlCHyJGhlGd12SqV1yrTO9i7JuYNIhs=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=TStCfTB1u3hysFTnpaw0BCet8w+0y85M+kLE7bCmayhV27VC1uIZaicFmUeEBxC6esOosD8TMtZrQIF8NVrFoCAPxmbmzI+bQtbqDBDgUEYkmqcav1cJ3+n4PRWEHedZOrb+iNK64hQQdaAJTUt5tUpc3D7HqdYIg+Hcxqctwok=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=a3LoNkEU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EG9py65z; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a3LoNkEU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EG9py65z"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54L1IT3b000758;
	Wed, 21 May 2025 02:03:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=1hm9vDsca92Dg4dRbF
	amSyvpH76L1LjPTCkILtQG/4Q=; b=a3LoNkEUgKf4jdZYuZg4iQ2Fkj6eu/ZsFl
	JdcdcOIhEEBv8wYc7WjeyPC86JwkFwN1vgkwtIOXbCauZoFSSmSNqkKpWRapvbRw
	JiuIFUonDxmMBWy8OKNeLix70o+2K8YtK4Ez8HkFZswbCM0Zas4mnFxyA2qsUrfV
	gzB4eidr9q2gUe1xGbO4XCjLLHY39V1zBCncgvpRT8gU+yk6O0FJif4Ha66pJ/GQ
	8MdrG8wK4p3MNJqdvBXM+MHnA8wCl8q7OVP+ZvChISlwUYHssX3/D+Cy1/FMb1OX
	N3VtOYSwxPhCjOeLdF4sKUb6951gwP8GMZMi7bNekyQ4R1VzKwlg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46s4ep046w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 May 2025 02:03:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54L23llr012619;
	Wed, 21 May 2025 02:03:55 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2051.outbound.protection.outlook.com [40.107.243.51])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46rwekryds-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 May 2025 02:03:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eS2A3Eip604rLKSHSDo0ZoHARICUh2ib6KHvF5K4Os6ptkYzsz45pRcdiVwtiK42o4Ct22a84zlNz+lv54B/W3zlqSPxKWcK5ulk0YmCUXf7Dl5ElkyzW/AUEbPy82QeZLp2fuws4e4oSxNbc1wZ2cUSd/ILnK8Ktsnrok8YSf8bkgQ4jub6Vw4FJrov3Vq4+JnJuLyEutxqZv0n/V9a6cyDeuOWlzwIbyykJOSHuMI6aFRtnbwnJcBNF1u1mR6u++wheQyNBG5xpragrRwifc4w9gIZFE1mTyxtctUx3Ki8WtXT/31jneoFWekjsTxFyBazyFQwrD9CgvzNwIwM3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1hm9vDsca92Dg4dRbFamSyvpH76L1LjPTCkILtQG/4Q=;
 b=b+1eX0Q42k0iXs8OzyO+Pbe70HtVTbOOYE+lLC1Rz+rE6JuHrjzgt1jaDzGihNNO9sDGZ/cKWFMDCW2Bfm9SVAj3o2ms9jyX301sU9sKX7bzcrWPiVrEXIGI/EALsyKU66kwu+FgyTMnSy0FLmw4PBwXGmbG2/6VqXohWR4q6Sr4fqVX6+WgcdGDNwSdYHre38NcW6TdUPMatzumE3vaxTYLkuDIYm1CnyuEYEPAf21agOQ9sNUFYfCHtCAdJB26LtvkB+r4p0soN+GWlFkSHobKQpteGBYU/JoFJ8XSGRBaCGa2GYLkRAlcWKZ9m1RxCpkup1hnKy/eX+v2hPViNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1hm9vDsca92Dg4dRbFamSyvpH76L1LjPTCkILtQG/4Q=;
 b=EG9py65zfmZSvFwRlbZSx3SzkblD6mFdOAf9y/JU364JnEeHCqbr9rL5vYawOzGUcQm8L25OIqAxIklcPulry3p1Tkpw4fg33yh0z1hfoJCvkIhnorP3d/wAhEZEGs08MLibXRCNJorgQ+qMuxgLSjUQYp8/vU/7uzmbPzrKbnc=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA3PR10MB8347.namprd10.prod.outlook.com (2603:10b6:208:57d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.28; Wed, 21 May
 2025 02:03:53 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8746.030; Wed, 21 May 2025
 02:03:52 +0000
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        sathya.prakash@broadcom.com, ranjan.kumar@broadcom.com,
        suganath-prabu.subramani@broadcom.com, sumit.saxena@broadcom.com
Subject: Re: [PATCH] mpt3sas: Fix _ctl_get_mpt_mctp_passthru_adapter to
 return ioc pointer
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <1747213781-31545-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
	(Shivasharan S.'s message of "Wed, 14 May 2025 02:09:41 -0700")
Organization: Oracle Corporation
Message-ID: <yq15xhulnyc.fsf@ca-mkp.ca.oracle.com>
References: <1747213781-31545-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Date: Tue, 20 May 2025 22:03:50 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0121.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::6) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA3PR10MB8347:EE_
X-MS-Office365-Filtering-Correlation-Id: adf9a2ee-5638-4b01-1b4e-08dd980bbc1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?X2EYDPJawEAkS32NmL5A7uMJt4HUkHP3VWYXFEituGclXhytCFLBbRkX0B7H?=
 =?us-ascii?Q?BaluG1vNEDeV+vvwTMAhlmFl8HWgp/BUupb+cQGb1Iia7iHUVW59fGOFz4HT?=
 =?us-ascii?Q?CvnEyBj3mMcQ/aGOnx6/sHn0B2UnldJ7VX+UymI+0dXQ9TStF2UvLfeKYKRs?=
 =?us-ascii?Q?tK6WYc3I3Mln5K5PciWmrEl8lgSCFIOJJkT6pq4eMUIVo68BYE03kIFWc2DM?=
 =?us-ascii?Q?pv98ix01zbvY84aWX/ekBW3pHYlawCFahQLK7udwine37WSA+2YArp6LHA/4?=
 =?us-ascii?Q?RQpePd2Hr/ktZU4wlpvZqp1P9AvdjucpYnMEdwCddJU5JS4RM3hyfAZNERGZ?=
 =?us-ascii?Q?mwUiFtoytWAfCHEu/zfRX1GZs0psm/BEx6i9ktnc9b4STEOIro+TvXwt1/QD?=
 =?us-ascii?Q?9q0O84b5IWW6GsflFeZ/Ak1CJN1EFxxwLBaT42hC1H1kj74XV5PPoP8BpPq4?=
 =?us-ascii?Q?WrXlpKxZGOukstKFkXpwIQT5jLTGJPdDJ5SncM/x0XF67WaTE/4/iVzN4eSe?=
 =?us-ascii?Q?Do7Dh1xbEP1hKEjphKg+boZsfElSl6hsSmO6cpzFB+kcKUSpApnlHtooBdBq?=
 =?us-ascii?Q?b2xIQkLXVFoqRqdPXLTjucnwVBj0iq9h32OJIGNcbfgzYIi3oaVX4t6QK0jr?=
 =?us-ascii?Q?Wco4cymjUS/bhU/0FwUDoTNIlkZBfnSjz5wTGE60ztcMzREjgmC8KQkcU0ob?=
 =?us-ascii?Q?C17MRDTahRjeksfOY/JmcHUN8/WHLozToW2Hv19vDhr0OJ3JaRNL/EM2NBgd?=
 =?us-ascii?Q?CwQesGdo0qBsm/g1a/fmNJEK84wLROGp8E2H7SoG1DyRjioc3ON9P9ENu2Jd?=
 =?us-ascii?Q?bAHNQ7W85vRITcndGsgV8IiakdSx7ztwjqOCIeFsT3mfxETf7f5P4ug3yJ+u?=
 =?us-ascii?Q?T1893jmMV4SfGX1qBSo8ywDqvWYqGg0RYmNfeSCG2dChoEkZrEAKr/mYWiUP?=
 =?us-ascii?Q?De3J3a/ZjQxTe9KbwzHxCoXghVl/Q/URwGQe2CK7EMP0kDxGoOU4fDS+GJkr?=
 =?us-ascii?Q?PekHyerImm5SIXxXGAmEJ022thGFwEffLgWMQ9pcrsCdXkdMqMIuvN9WdU8G?=
 =?us-ascii?Q?gtYotEnZY2jfbbN2FOd6Y1hXGflgkfX8il0G7BuJUJ9Ox1DZDUYLJ1K+dZ75?=
 =?us-ascii?Q?I7+ZYcfQDLir3o5Qh/c6aRehMgUB5v74880QM969CrJZOKf2Dak+dd8Ncpzx?=
 =?us-ascii?Q?7btE9IaYynDZhxED8AUtxHmCsimtP9JllKiglNozhZc+mACzdOQu1IMm32e7?=
 =?us-ascii?Q?/7r7XDzcBfchdllonMOr6Cjyrptilw9PqQaKOwtUQUlUbrExB89g9KhGO1DT?=
 =?us-ascii?Q?Tm2qVaUKFmpgfI9mi1uyviDNZ9Feiwk9CHcC8E0xBV3Q534xmBOAe98XV9bb?=
 =?us-ascii?Q?mtV6JZuJ7YAqXUbjVK0vKJ6b3OFC7nvWPV+zhS5YUi3sJVyNew=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?j1uRAX7tcnFUTCbqabUHxxv6oh5jc5fnaPRLHET+FNQPo9sOde4er/raljP1?=
 =?us-ascii?Q?k8YHMkM063Qd9sxtRIYAg806MmULejESA5V+idb3xxDw6njfT33gAaDsw7b9?=
 =?us-ascii?Q?oR0Gwd4E7nDqTnB+yG3TSB5a9AFIKpAEabTcnAAcN2T2UuR1xEIiavmXN3c2?=
 =?us-ascii?Q?v/I1Yil5xZ+X7kkapW8keVmlBCJElnh6miok8eGWstwaMWbPJKMZMkLdRrc7?=
 =?us-ascii?Q?SUusQdJu/HCou5A8POUYioBPLw8+sJtTDfzneNWoKfW7q7mrC5lFj4SLTKrk?=
 =?us-ascii?Q?4TZZ0XjmENwg56WNvl9C130+cTUliAKUtLaP/DoxwCHQ7FlysdQQNn3V9z5a?=
 =?us-ascii?Q?njkpcKk9EDe19sGMFX1lc3d+8kRnWvhu4DliOQT4ETFwfSDbesYzSXYhw8qn?=
 =?us-ascii?Q?taVbhprW9jxVZrnPzf1JYjowIaMhYvPAGMMP/whLL3Lldu606ttEyh1ASCT4?=
 =?us-ascii?Q?bcv2GcjJdCt0AxOIR/UX71kUYXESLxdI+Fxfz3OR9jEt862EHoVIBSdeWs5z?=
 =?us-ascii?Q?YjlHo+J3HztUk8K2rSDXy0vUHwOzG6/YYkIxOTfhNY6t3EUz1aa7gQlfjXuO?=
 =?us-ascii?Q?LABdhsv1RkuYuNiQkSANt9iQNO1m1nP2P3T/sHd4QRjeaGMc0GLkO6O5qDZo?=
 =?us-ascii?Q?3gkHGP6bkU0oyXxW+sckLroikr4HkU/Nq5/mhkQfCweqjtxZWUx4fWzzyyGK?=
 =?us-ascii?Q?BjoJYhSi1z/GdyI6lX6Pd5EaHZldQby3UywNuXGEdXI+Rcj63lxGelkMkFVJ?=
 =?us-ascii?Q?9QQOwwrWMrFpCZXEYxNrahkRDD0w0lP5CG2KqJRLarGusg63XZvtfpU8QeRt?=
 =?us-ascii?Q?Qh1qpYdKbiSZqhT3WoeRL+r1M/wSwcWmGR2D6uKbyA8IfO95bmidb60vjL2e?=
 =?us-ascii?Q?TTxGeEAVZlockfuVOvfAdbII2Na+Vu9jYCQBHIJ/9Fgw6xKePQTl+97soquQ?=
 =?us-ascii?Q?3+e1CpjIOZ4crlzl1gDJ/cGHyYsp0707JCis3optKVuVjb9U5z+KLeAduu4+?=
 =?us-ascii?Q?P0x8YKvvtS1Z54I6n6nmwfNYhuwvsVJRuYY8ZvtpfU9kPojqCndT903kcOVv?=
 =?us-ascii?Q?8bTdTAL4sRqk9tZn/0kj/GHRhB33T7NLC6+11miCuCWVMqV+ToW8jE4jSb6m?=
 =?us-ascii?Q?+i/Sg14CU2pL0vHsEYRruEQEMwC44ZnZE+Ba3m7t2RyEAHhqxiMvEUklDC4z?=
 =?us-ascii?Q?5a7KEoKR9Ipi+cURl0ZaI4/GogT9ROens2lK7k1LusZ60rnmO3BV1jV03Wx0?=
 =?us-ascii?Q?duND7Vz4VFZpN44konKI+DKoUmrMwEx9436FWdtmsu7n0toxejQYRtqPZQBN?=
 =?us-ascii?Q?+bDy1PM3ZZgo7K9yYfrFybAbNcXPMWwIajDb5JO1PlCktKq9c8hGVxbWUFyG?=
 =?us-ascii?Q?8j4zxnH7b9LMEl/XqoZvnsngZ67cz8FjC1FdUAindhQF7ss5lX8Qe1WHrINY?=
 =?us-ascii?Q?7fyghJhk3BSb85U3aczAP7XlmJqp76N3Pa5I/1zq7un1ghu5oQ8l/i4enstU?=
 =?us-ascii?Q?kszFxXSpB/+CiHhLDfXiOz9NgZrmQT00f4j5rAa2VvggRwfGYmwoHyxuwdop?=
 =?us-ascii?Q?ER3is6HugXTvo/oSilSuVRDGjhMMGYxkAVTVZY5oGzAqFM0abfp7UgR+7Pay?=
 =?us-ascii?Q?2A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	M6u6iTNBzIzrTUnIEdoaDZihqf1Sdf7t1rGkfXAv8ihFywIzbRTFz+HouFfVAUevDEKEj9Bbb+4/bXuz0OT9gb2uurdSzWrpXjw5uoO12aB4vlUugDVs9gquFFeNc248oyMel4+xKMrA9rIacpu7YxyBsI3Qt5RCMG0vbLgsPYOVd0xRAb2osPtTuhz7prS+U9kmoNYAHf/8PhbZdduWneiKqhDVrZhd7naU3Q2lnXyZUhwKVNaO0eRPuVlFJTMTWGTSDXyH2AygD9/43/XabKffkN1riq7Ll8id+un09I8XK/3h6gU6tluByDz0vct3cDq7a+BYFW0Tr8LTw56zDhYxRfVWmQcu4GzPSVhpSFl8sYW5/do7L+GAG/24lHNkl9ipJd86+4KlgwLR+RbyVDe/lmiAbnpKBEP4eSTZW//ryCuEM3uKz6eMTpIkWvvJVUqLLbs+lU7MozgYNBr5w2vQ7O8qRnWDrNM6BQyziGBWOPUAtHUMMsrXsXnPfjg9ZwpQy//ky2kAzgSAa232LQT3nGclYCQ6yMdlucHviXVGKkbzLlse5poaxtzauuaSGdY8BEBCeTHaGb9cmjG2jrG6ZGc/dcRM5V3UzyxW4rw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adf9a2ee-5638-4b01-1b4e-08dd980bbc1f
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2025 02:03:52.7642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: anx8+cbzbk68w3Rtp6Qjonq84UFFl3va035FW+EgmHRsqO5CclHu/BnXqE+Fqn1dJ0+MpO7uYOn8AGCt0veeSS46OjM0V240Ywq6UtcIxiQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8347
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-21_01,2025-05-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2505210019
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIxMDAxOCBTYWx0ZWRfXwA6/KF1DjJXh 07QerYKIanScLP5alBhfgfyNKDQi5cgpreBCb1M4c5jTB2ofTA2hCngkU87Qs+tVSpjDWjrcICj 0Lyyu8aBnjiTZomDBAoZNin6pPgwnZkKs/dNr+T/wUZkX31hh59zC7Fq0CS8sPKRRgJohURPI2J
 Ymmh+O6GJDsU7VbwsDrTKac0yG5uNTX9lBTsu8O7yR8uvo6Sat2p1YaFoERGLVvKTrSKOfa5cv4 bQKey5EotsC/DIKEBEc9xAa4ZeY9Jm2HZrnXmCyFheABYjrKGuTkz6RQ/J+VT4XsgqcEJKcCAei GzCHcthCzMoi/1zvlgOWFZKmtzqcGcaXGZGXcREMu0oVBbdPJBRe0ARZO52Jhr6Px7eHtddeocl
 r7y5nu3m6CFUqkjDl3ichZJw1MAR5LOgqvUDfMTHYwnjJ++wxt+dWaBlpA9tbWXcJ2h/Dd2T
X-Authority-Analysis: v=2.4 cv=T4mMT+KQ c=1 sm=1 tr=0 ts=682d348c cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=q32mctcrirO_PcNCel4A:9
X-Proofpoint-ORIG-GUID: zYIEXaUb_tYnpArBEtyjQaV-Hy9OMGMp
X-Proofpoint-GUID: zYIEXaUb_tYnpArBEtyjQaV-Hy9OMGMp


Shivasharan,

> Fix _ctl_get_mpt_mctp_passthru_adapter() to return the correct IOC
> pointer to caller based on dev_index.

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
