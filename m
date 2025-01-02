Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0224543173
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jan 2025 21:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735854122; cv=fail; b=G1oJ11BQuoieIjr/9T+ZhFlP6SwIrQsDF+pZsVRoU/tuYo1yLSqIYtvGsGq2cM6i9S5ycmVmWhe2s6Y5Ar+Dxnn9SPQywU8ItcisAUaQY+qZ3bkgimxwWZ9sioQu+DzVLvBmtswOpLCsCXXwc3heiwacS1uKxwkLUU11iHlrXSs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735854122; c=relaxed/simple;
	bh=2veK55pl9+HuEHfPxntNroY/OBvd6LsN2LqGwetUuTE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=W9twM1M8c3043euzcZKd0fyeFUG31Ms/RuVgKgKrSP4Karn8oT5CaAgMtzo8QfA2aMDXJ4nnWnln6k6Va2KezqfX/9JBPuR1xn1Cs2MY5gVUADFi88yp9uetrZVEn4as/lQHwN5LF+7AylkQqskNHG/X5AiRUFqTHl4yucyhXmM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fwRxsbml; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dJILuZ7J; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fwRxsbml";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dJILuZ7J"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 502Kh9aH022367;
	Thu, 2 Jan 2025 21:41:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=UBWuQ3LtM8i/W+8+yz
	d0+HK4oTt44G2VYarl6fhNLoE=; b=fwRxsbml1/vcURwj560CD5p6AHbFWvJV6u
	ZJTTjFMI3dPofyW5Z+j0zM/wA8Vx+wn+J5JZWQRH+tOmMFxIkqRDFrouyVRSi2k7
	mbj4ZG2GG3gTCaBRYlRtxZhUziKPHay9UsymnxmyE3l4RBHJQDOHhaRvubEkchKv
	tuJ8gsXE63Ul58udtSa0zPAQFxNxMiN5tJjHgeuZAJ/EL8qNoN22Zy1ScEpt+RFD
	TTyFBOGLc8M3hI/SgwpvRBGb6CyBNa25z9C8/dtSFuuGq2YsUN54WScdxj2SHMiW
	iaw97hUOjmq1m0ie82aYOOAYDPso9Cxdqfh9WqD6l46Zu4rrojbw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43t978q704-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 21:41:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 502Kupcp012897;
	Thu, 2 Jan 2025 21:41:56 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43t7s92f8v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 21:41:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oIr81p27YiEt8w/fKNu7JVxpiVlRMHkNnpYgkGyOadG3qa8Lyouo6ltLSDYJ+4bGvYjhh8sPRMU7pS/6zk+0SXKWwUFsFaxbmZy/vaM53wLzppoB3r+t8gNG+9FKCjdfTO5qeZ4MpmXB0DmeftcVBLBI3+X1CIXKHkqzo2i1jIjG3dhIqTf0nXm99Pb1wUADxuM2thuHzjZPXEqegMVL/fN2wKeXeXhV9HfbxEPXiDG4kKtZz9BAgnr3rTzdh2HTv4/DEzE5NOa3taceWzPA4mQka29Ce/QHF4KySAijx1DoySv7h/iaQnqU3C6W5xk08zqcdBVAUEAyOomPLRNwsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UBWuQ3LtM8i/W+8+yzd0+HK4oTt44G2VYarl6fhNLoE=;
 b=mX2h1O7/weEi+JS3Rpb6WSuyBlkIuwZre7iY+lpIShf4UyZFqbv9sLPw/n2OPXPjdRIH73dCbCGreY+uqLQAE3M/z7PRDl1CaI+7U/p5ZDFtXasQEeLzzyGEVutWzMZrF7/erZQ03AzsYw6GCraTaCC1pli7nRyB/v+e/Wcw7RdrDjAed4PCMZFnwfZ3JtvVdhFBoAAdviRx/CIY9FjzhEv247wreALnreZoJzBKB5zy/H7yV0UqVumBiOx7nW0GO5NQFyZfHfpa2I3VjKae50tik61C4HUa4Y6YuBq6e98A3VUBOAIj1q0Zh1sgTJwKQ2YB09of3A4O4suAWiifHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UBWuQ3LtM8i/W+8+yzd0+HK4oTt44G2VYarl6fhNLoE=;
 b=dJILuZ7JWEQJPTUfgnDlqhuhwApVTn/ytclI+jAEZG4bl8QwQgRQyur5rwK2ZZS0E4QM05KItXi9UUGaVLjoQvBOTbR5M8aYcB2MRh6GTYn/hSVhDZV+YzuoyABfRjpu3sYmOZkwfu6D4ZlGLQvoXNJuUl5htY7iCB6ItJOCLF4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN7PR10MB6285.namprd10.prod.outlook.com (2603:10b6:806:26f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.12; Thu, 2 Jan
 2025 21:41:50 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8314.013; Thu, 2 Jan 2025
 21:41:50 +0000
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/5] scsi: fix kernel-doc for exported functions
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241212205217.597844-1-rdunlap@infradead.org> (Randy Dunlap's
	message of "Thu, 12 Dec 2024 12:52:12 -0800")
Organization: Oracle Corporation
Message-ID: <yq11pxkevvt.fsf@ca-mkp.ca.oracle.com>
References: <20241212205217.597844-1-rdunlap@infradead.org>
Date: Thu, 02 Jan 2025 16:41:49 -0500
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0100.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::15) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN7PR10MB6285:EE_
X-MS-Office365-Filtering-Correlation-Id: d9b5604d-cde0-4cbd-6816-08dd2b764419
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OkpYs5995dGL28O5SWtVbhQMvV7QzN5YvV1vx0Axu1DDlyYglaapm2cZ5bUQ?=
 =?us-ascii?Q?e+/Oqx1ev0PMrnZSHdScstSAZUL54YzQoS/dsQK6Zgg/fhJshxAcpfEZkQx7?=
 =?us-ascii?Q?ELTheROoE79r1IQ7eHoUUvO5002oXbQP67yJDusZPrEdGBkMJdyvhhXXVxbF?=
 =?us-ascii?Q?t+l93kX2DBH7mkw69scTt+lF9OP0X8FSRmFje874gu/bNWWmNAO2rH1F9d2z?=
 =?us-ascii?Q?Ice4+k62ZVzeOjIbkAfh4mEOdGUmerh4UWcytIXeNJTfWOovMDJith+PYIQ4?=
 =?us-ascii?Q?Ypq/1TmF/z/1QYUbVFBETAeVDgKmpKunZ2wPM6C6IxHrV0VzxYn3+a5gNeLM?=
 =?us-ascii?Q?6k57dPNZ+jlopiGPA7ON7+fYamQcuUFILt9wpJIe95rpR2zY8za/Jryc3Qk8?=
 =?us-ascii?Q?faVDq7MbRWh3UEX0ZpUhiJ4PpPf/uThE+JiAnKtctaHxc6sWauKZJGOSFJj0?=
 =?us-ascii?Q?WB0nsnx2WRoX4zIycPZ+YS+1WMtz6pzamuRxIngvTqJpsMkggEQi2cm22tNe?=
 =?us-ascii?Q?TKjbH60xGGycDIsahj+TvFEZa9EcketwohpTskApCuClhr9gx9TDN2k6gbYH?=
 =?us-ascii?Q?icDO4sm/GMjxVrqbHqXTEoVINJUNO1oSfSHlN1nLaIzn+hbONsDNCIAExNVe?=
 =?us-ascii?Q?bErB/SKjD6sutkO7SWR9vNO+oQIEZkjiZvkerSeiCdMEYYxtUilk1+zHUVVz?=
 =?us-ascii?Q?LyGztJpgHl2d2bopCj9GXMZZfrMJoPtrjNlIUsXlaSwfun+LW+2xiMmNlkYO?=
 =?us-ascii?Q?7sR/qYXyr1rcAGChmZG9RuO32oj0PjZZcSP/nUnJvTbuCcA6MBt5WHaOci4t?=
 =?us-ascii?Q?Z94ZhrNMcWc4Fz9gzokVecNMwtj8fsliNTuHYUMd1JD4jkmvGHcSefC/Y1pv?=
 =?us-ascii?Q?HZMo5RR+3tn4maOaCIV/+xPsl1J0MJsERnoWc7i6S7prBFZAEaQX3ucuqMrx?=
 =?us-ascii?Q?T3rubsLoUC4ybvzbTiniSAahRNlExV9/8SNl2zmK+3C9oODytQD4UFfUAiaK?=
 =?us-ascii?Q?4KM4EicDPJ8f4iw1h+qpok4NgXM9I89hd0sbcBB+NLfUKydZNbVg7cclPafZ?=
 =?us-ascii?Q?cZr2UmJaUdUS5FSUQNqkqSNyTbVhoRv0jeulTbI4j5KCVMqeploWrUL8FxOw?=
 =?us-ascii?Q?ZBwvNQUI2IwHo80Dbt9if3IV/C6UpLIT5/YQFq8ljxlLcjBOVe4e911kuwPK?=
 =?us-ascii?Q?+oVR7zqbBRFYvjZ/ZJyNCSn8gE8KLLG7N070grf1Nix8qadQgPd61XQCQftL?=
 =?us-ascii?Q?HvJkgzX6yd/Q0vG/GoTlGuG7iGyWU7NQOL/zZJ1xSc7/FS+zq8DDnUOuRaQp?=
 =?us-ascii?Q?2tLaYBj0msRAeqozCYrY6/v9X55O+Kn9nDl9iZaSf3TSnQPT99S3DPo4MX/g?=
 =?us-ascii?Q?aZX50C7v7KDrLVd2yFB6SZQPByDc?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?D8QEnntP/K1sF/y3XLUjIoSZsZJSFoDjtVOwxigbYuM0C7LdwelwstvOCQIS?=
 =?us-ascii?Q?QAPfyKUJT+k7y3oiK1JRg84WGKJ4aM6QQzf24yLvtBhE8fjdiSDYZ3doFrjz?=
 =?us-ascii?Q?lz2I4q+YtYjBUeddhtnNu10hclxZ9JPWQafaphHDhlGZI+b9SHHZucSM/q9M?=
 =?us-ascii?Q?Zpc2BBKjB4G1YO/hWkefdlurIkcmnhxgdB4vqYxnbC7/syxxqjz47+OSiweH?=
 =?us-ascii?Q?3y8kKZ0IPiBcAkbBsg2JDZWRMX1kow/d6ouaEWckWebk5xk662zP/rKDpZHJ?=
 =?us-ascii?Q?etL1FV4dzap36BuU11R/LCIcJDElyVbhqsuww/fEV/npvg+lD04Iwes4sApZ?=
 =?us-ascii?Q?GCDSPMWi6NwzVpp7cZ6cJpYTO/aY6VGLyyeXer1MoLaMEFqrecAOVhrsbyJS?=
 =?us-ascii?Q?vPWL8Nr4MFDliUsnekrKYBJjtmPdYIsBb6wzQlKuEtTnPN+lXVwFEilXR9nu?=
 =?us-ascii?Q?/FhSE40+wKJSDdbaThTgzhUngWnvkw0bDvN6/yQV1r3z0FwXGotsNPdw8Htk?=
 =?us-ascii?Q?NTgRJnsq/JjsGg0OJHCU20x8QCPJMbvY8VtfB+kniFTQ1TTeLbDpxaA6iMB2?=
 =?us-ascii?Q?CqLnLmzcR1bff6P4lkjx2fDQUtVpvm1MV5m5HkRyFCFZ7yrPtzMOMulotdJV?=
 =?us-ascii?Q?ZMfMac/aGmHbXLMmA47a+q1jbiHMZI+LxEMPzdSF5Ijufrgy13NlwDXlc9ia?=
 =?us-ascii?Q?Zp1S29Y5B7kDvPdJQrZ5ugrVSvEtJkY0ybrm3KXXjonq+BiEthRwAWYZlgb4?=
 =?us-ascii?Q?jCPbDlu7MlhExhHL2nErQ7u9m3u9JqZxYuMzNWNuZxzepR9UESkH71KeepkD?=
 =?us-ascii?Q?fZW26rfEnD9gCaXx1dAIrbuvSdUZqhEAseOhCJNTzhkEoKiQNl2muP5IurAi?=
 =?us-ascii?Q?LnhG0LLCoDV2Rny+j6tcaehDAVBEAhCiSaaptUvJ6HJ3ghkcN/MYGqGMIOAh?=
 =?us-ascii?Q?S393lADJbUT6sCPClQ9amud3VYGuz9AnE3AYvJjsUJvf0lZr6mWk6W1EAQgb?=
 =?us-ascii?Q?QYjpn57OJSf8qIMwGtHuxdoKhHqZFw6+JvCCJK0LHguiVtaLrTcyGo9xQUXi?=
 =?us-ascii?Q?b8grPvjh0fkachMQP7pHO/dYETf1uRjNiAzXvxC6hh4OZE0xUrsmlwN0zzQf?=
 =?us-ascii?Q?PFAqXqrEeTCIseao1WS5pD04YXjgyaAfXrF5IvXmT9L/pUp7dxoUTiq2bkFe?=
 =?us-ascii?Q?VFMYfU/RwDtAahOyS42M9/JaH4M+LlQyCORh1Pnazz2R/WqWu2Ywp4Q1rZbt?=
 =?us-ascii?Q?yvmMdm9zus7KZ0Fjfm2TeEvD2xpWwqvprj7Lah13Qer2Dc7uiHusRO7suXHi?=
 =?us-ascii?Q?6+e0WGu7NwEsCdVg8sZU+3MG7EZuVUxBk8SAXV4+WMUCLhQCQqiBCI3+DHTA?=
 =?us-ascii?Q?JXubpp2weXA/pdLPqgRR2nzzZfjT7JBIkgo5NuT1a5xaetIcxglvzUrO87xe?=
 =?us-ascii?Q?LUAxNFY7kHPRrG5drjRKseZ6+jtyw7VJ77N0TeRvpoNpT6HMzU169UC7apvP?=
 =?us-ascii?Q?3gabgrZR0+aKkRGuf/mkrTLda7AeJzlMbduFNJW4xmripRswTOMwWHufuvMk?=
 =?us-ascii?Q?+cVvcMaKfzAle5KtIzOwCEIpEDelJZCek903XDKu5qPI5sAtG2gvuXNfqv/4?=
 =?us-ascii?Q?6g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7kFfLFGn21ocmwdmYEUoAFmMSdsnF/wmdGjvpMB4fJV/iRLsRJ2PCrOTkKBRFcTL0y5c7X9b6R/PKvXUDnk5bofGeotD6MMjSzP1o+h5NMvOZEkLBTBF6SNxXsRo0zkayYyDuF4RgU0lxZ+lNgR+LyxJB/AQDCWMAl2bYZE7I99niHUP9bFW3sGdkcx3EuMt3QXSgl3oEH2ZMrVWW2yvhBv76yihonddcik7lBYtRioBKhpe6BprfVwXn0A4Taw2bvItK8OqKS5x1ZMVEVN027seQnI0LgR3AqoX3eNjHDG9Vm5lK7BY8Gib4oWT8k98kyX27vGbt9gz1hxL3GEORNqLq0nQ62ev06NJ4g0TEyzw1pzUbvC5maf8z1G//aGEFR906RyQGkZFBFhIT28+kH29xbCT6vHVb/fQkwKSGm3zwNyXd/wGh2SXob/XRjdVhlhhDYVMVWTPtClnx5Ke4YiKv4n29mVzd3Y8t8K+u3iICCbwNVExsT3+lvASEK0TqFGOlAKkz73Yf1XxmhsrW/XRX9mY7JZn9BwB3Lf3/I4cT6LMJz2QlhNLo0dyaaZ7eYGDcUj+JPz4LdZy+O0Qx5+7wC8SCtP79YG7VwA+L2Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9b5604d-cde0-4cbd-6816-08dd2b764419
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 21:41:50.6145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i9mp7oPJOikRohZpELgPIisza2YtX9pkw6jv4vv5HGev8oNLjxckiqvF/SrXxDexMxKSI/evu27IDy8hnwVP5I8f9q4Z645jRkvoPkcGRe0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6285
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=660 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501020189
X-Proofpoint-ORIG-GUID: nV--gcVnLDSDTb_HvRHH7Uiq2Skn2u5j
X-Proofpoint-GUID: nV--gcVnLDSDTb_HvRHH7Uiq2Skn2u5j


Randy,

> Add or fix kernel-doc for exported functions so that they can
> be part of the SCSI driver-api docbook.

Applied to 6.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
