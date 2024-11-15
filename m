Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3853B190661
	for <linux-scsi@vger.kernel.org>; Fri, 15 Nov 2024 23:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731713190; cv=fail; b=UhRLLlyv2/sWxxPyPypr1hR35NqdxP+hENYvu4XE4YOGk7t7yrYZ+hcywtHIbQMVcaxQl7O8W7GTVAeRfYNp6ID2boJ/S49fePCcVa4+tMPXrbF+1eCC2HKw84XW1oj6Dbpjbbxxdhf32fXpjF9iRFXcYPyW8QMsJhrvY3teJCs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731713190; c=relaxed/simple;
	bh=6N6MZ67O6wjM4fQvj1WUi9YYhIy2BeGntS8I84+deP4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UgTB4gw7xj0ViJ+beZvnmmedoqKtV0QcJ7+yHg8SmThVsZ4Kln7QWeaLSjUqopjSy27L4QXCiidn8PF0C/2ZPZpTAxTjEg1Rtl4+21giCKW1Jh3VmLJmC11zmfr/AV+nz20KJhVTS+kUZOo+jA4gJXULnGfO7WWKSMFk72IGynI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Gq3sQsdt; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wx7ofO9r; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Gq3sQsdt";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wx7ofO9r"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AFMuaA8017094;
	Fri, 15 Nov 2024 23:26:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Ew2esnOFG/q7CCvKvctYGmwLDJ6clVejrMH8wnEyWaY=; b=
	Gq3sQsdtTOIxF3j424et1ZBtNF9m7LHq91pIdBnDBYZOftwhSGalFcPZI1Vtu4Dw
	eZhy5CkkKTM+YRUpqzokm+nzdMlDuxVQMBb763liJyHSVXD9zfHvj23Bh+piK2UZ
	mx7OPaLjLVYUyrx9rcYU+N0qNfW40wJAo9UCsWB2AYUXdjQA5oPATvAG+ZifM1Rc
	elbULI6obi5jxka8WQ4SxeMYzdVzDG3w4VUFGi55t6d4kE5g9a58VpFDiuy5z+Cg
	w3N8UQe9KZPgrRmxUVazMmuzNODfCSnZ7wwSsojOD4hbZMOqGUCAuzX/aPDDbFGo
	0kgeyjoeylUVvAAIXVWE+A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42vsp4p55y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Nov 2024 23:26:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AFLlanV022742;
	Fri, 15 Nov 2024 23:26:24 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2044.outbound.protection.outlook.com [104.47.57.44])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42vuw3abvt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Nov 2024 23:26:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gyQWGDwr6Tl7EldzTLjwtqnANO7tqgCE/RFelWj5FFnlNtvTMvxjfOZWsPq9NBRp3uU+5jfvZl0bHp1h9aQyZH0nX/rT6vdgu+jjixICxjGSyLBGzVKRp/iHuJ37UedrlaZNyptAhfahnuId/vEqtNK3matM7L1XP8ytAa9yrz84W6mahbbllDw0HrSZM2EJv49JQpdSAIw9EACFJVxQErVcpCK90m/zMh93X2a3Wj5PnPeHywNjRccC2Qx9jigzzWKEDyZaY9uNlBd9RS1RNTgigRvaUB80uCC1mxEoySNm3olfjvwLnwayEV91ewaacf3uF+sybZbm3yXY+s38hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ew2esnOFG/q7CCvKvctYGmwLDJ6clVejrMH8wnEyWaY=;
 b=RDSZ3RjQwIYrEhOemPloAh7cL9apIjt3ivbAOO32dKJlXWf+GnfvcwGvrwXHcZ+jSDdichUKgRXPi8kW0JIYnVMir7UFjkRve437nWcjldpaUnAQnDTFn/XMeeRvgAWIvK3rw0SwuXR7SWehPywoDoJmRxpvVn63s+j+TJoTudtUiT+P7EUQdzgIe+utrJDiQqrrYiSm+Oin4TM5RoaQKWhKZ0dhcBCE+HqreOFF95AOlRB0FSuQc3iQQxQDJA6DG7kUedueRjpPupBV1tdGz4u8Twnrosm6UxUHlpJqoV28DY5gszJKGaLe6PbjRQXNSS+G0jbEZt2f/xlZrPIBew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ew2esnOFG/q7CCvKvctYGmwLDJ6clVejrMH8wnEyWaY=;
 b=wx7ofO9rU1m8tiMPlC2eH+GGqkk57W1JdeMsrzKLDX46GQ+RYOU7dheSMMpOd/O9ydeg1fQLXftdhcudba00jghpwUwiWHHQpHyJVyIkmjJvDn4cr7nyjDKPhQ9zAekdnZFAt7GiOwrlXUqyAWQoGB1P3F5IanzrqkNIorBa5PU=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by SA1PR10MB7814.namprd10.prod.outlook.com (2603:10b6:806:3a7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.19; Fri, 15 Nov
 2024 23:26:22 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2%7]) with mapi id 15.20.8158.013; Fri, 15 Nov 2024
 23:26:21 +0000
Message-ID: <5f7242e7-9685-4500-825e-805ffe4a55c3@oracle.com>
Date: Fri, 15 Nov 2024 15:26:19 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] qla2xxx misc. bug fixes
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com, emilne@redhat.com,
        jmeneghi@redhat.com
References: <20241115130313.46826-1-njavali@marvell.com>
Content-Language: en-US
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20241115130313.46826-1-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0297.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::32) To CH3PR10MB7959.namprd10.prod.outlook.com
 (2603:10b6:610:1c1::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|SA1PR10MB7814:EE_
X-MS-Office365-Filtering-Correlation-Id: 703e8d35-5ecc-4ce2-e9c1-08dd05ccea01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S1R3UXFyWTVWN3czMGNwYWY1K0hGSVZVRE80ajhIbm1QbFdIM1QwNHZEY0Za?=
 =?utf-8?B?Q1ZFN290QWp4VzlOa2orN2VIdnBSNWYzMWVvYW02MmpXd0oyL2VIaDB1bTdH?=
 =?utf-8?B?WjBNR3lmQnhhYnJIY0ZHLzJwWnhFQVBadjJXUHdEcThJM1V3UkNpOE16d2pZ?=
 =?utf-8?B?K25DZjBicktqczEwc29iV215cEJqbyszeWdCR0taTUgxd2FvZ2I4UWxzRlZO?=
 =?utf-8?B?bnU1eVFuT3RqT0U2Uk4vd1hXTXViYkV5bng1YzByVHRUaFE5TGhBdFZocThR?=
 =?utf-8?B?L1lJSVlYalowa3B3WjBTcTJMQ1ZHUkYwdHBvdVVlcGV2a29HU2phMURid2JH?=
 =?utf-8?B?V0MzR1VsL0RNakc4RWlEcGZsL0FiaHc2QktWaUNpQ04ySE9kWDJRV0QybzBI?=
 =?utf-8?B?TW9DVllRSE1BQXRualBHbng3clNFVjF4dHNmbWNxQXN2UTBJcXFJUTUvSXNR?=
 =?utf-8?B?bUhUOUEvSStNZENvRERVSHJwbGs1YTk2NzJodmxzaHlGSGRjbFd1UXZPelNi?=
 =?utf-8?B?c3l4V2lNLzErNHkwNFNyY2ZySzZxZzFkSzJ2NTlTNUEyMVEvR2toRkp5YUJw?=
 =?utf-8?B?VGZyZmdSaU0yRXp6aUJzWXJRN3J6STMrdElqTGk4ZkZPdDN0NEp1UkJyWGc2?=
 =?utf-8?B?dnZZcnlNSWx5Yy82c1lRYTdXMXdhK082RnJmOVJnaVhwNExRNzNJRGdzK2NF?=
 =?utf-8?B?cW9DcFE0c0hRYmk5Q0ZOaHYvNEV2Ujd6bkZGUjdoVmsybkRUV2JDeWpIS1d4?=
 =?utf-8?B?UXBzY2svWnFHS25zTTY5L2lLOXpybXRXK2daZTl6VW1ObndwbjBHYXBWa0Ez?=
 =?utf-8?B?dUxXbnhva014WTJMbzgwTTRPLzgxc3dIKzZxTE95YW9xOWRCb0J3bTE3OEEy?=
 =?utf-8?B?NHo0TFhMM1lBTEtzSE9zVHFwVkg4L3VOYVR3ZzU4NituaCtUbmt5SXhyT2h3?=
 =?utf-8?B?Y2F0Q1NwUWZwL3VrWmNFOGUyYWRGYWFVNVhkM0RiMDNnb3JiNk9rSWwvRWpJ?=
 =?utf-8?B?SThLbEF1bjZPb2k2SmFKdWtySGxIRVdMbW5pdVE5RUxkajJtZEFNaGY5RkZn?=
 =?utf-8?B?ZE4zc0psWGFKbHh0K2xnS1k2RXhidEtIL0t4TjNDQkkyWmZjbDBkVk1STUx0?=
 =?utf-8?B?dWVNOEhsd1Vva25HZ0VoSmNyVS9GNzFGdUNTbk9SRS95d0pod3g4cjUvYzA0?=
 =?utf-8?B?em9ZT2RmbkJoWkQ1a0J5VFB1TlgvNnU3N2tmbzdDdkIzODhKT3pxcyt1UWNR?=
 =?utf-8?B?TTZzY3NhanU2c2dxQ2NBa1RrKzNqZzRRREtWZ1J4a1Z3THpKdzc2TEhpWlhj?=
 =?utf-8?B?M3RXK2gzaHhoUHZoeEZQR3VEb2tubStidHZTTHRRUnY0UzNWZEE4azJXZXpI?=
 =?utf-8?B?SXBiNVpIUTBJTUhycnF3eFhjcmZUY3lIYy9tdmY4M1FQeC93Mk5tN0tNcG1N?=
 =?utf-8?B?K1pXSG5xc0g4dTY0eE1NVEtkeG1lWDFYVVFhenR3YlkzV0dBNXFoYW9kWVF3?=
 =?utf-8?B?ajJjV2QyTWU4Ulh5MElMNlRZNW1YVTROYTkvSU9kWEw1b2RQODAwQjAxRllu?=
 =?utf-8?B?VlR3K2w3akR5L1VlZG1IUTN1RzFKNGlYMW16aFFOQnJ1SlQvem5BZHNIcnJP?=
 =?utf-8?B?MllPVmJjLzBILzI0VG52T1VTb2xCMTIxczRZZndiQTR3QytQZEdPLzJnSlZK?=
 =?utf-8?B?Y3dYVTM0cWJPTnd1TDVzVXFnTGhSekI1enZiRXZoUDJmVDU4MWY3OVRrR0lJ?=
 =?utf-8?Q?ExueVRTr/QHcZIEb3kRiiHbCg7oYTATgpshOacK?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UWJhSGw3OTUzeG9jcGxVSXFsckxmL2d3NEZqbHVJTExkUkVtZ0pUNEdvd1Mw?=
 =?utf-8?B?aTJrTFJhTUgyYUsvYnp3Wm5NZXA1bysycGplM1loSXZDbU96dkdZSTEyVjNi?=
 =?utf-8?B?Vy9hVU5XcW9xM0VWcnZCOVFRb3hCRE5ubk1raWtyeU03UWxUNHBzamhSemo5?=
 =?utf-8?B?VXB2UW9TN0Y1UFdJMnpzUmZqZW5RUVIyamhvL2s1STZNOWpEY0pUdlhranI2?=
 =?utf-8?B?OC9SeHZraHBBdzZPdUF1Z2lucTRldlNQaFR1eU1ndHV4clFiSzFFQlVZQWpq?=
 =?utf-8?B?NitmdlU0ZWhxMGZ6U293bFVPNmw3K0N3QVBCMWZ2dDZwa2ZmeWhXMEhEY1dl?=
 =?utf-8?B?V0F6MndxQ0hTSFhZeEhEV3IwV1YzcHB4VnRoK3VhL1I2UjkyL3BBRFFGcWZy?=
 =?utf-8?B?azBlbmpOQTAxVWg3eUN2ZVNIei9wWTkrcy8zbmlFeVdjeERKaWxiUU9NNXF3?=
 =?utf-8?B?OVUyZ2dMNGJhdzdRL3ZGUXZEaDM4ek1aSUo5Wm9pRFlpaWVhQ2RzcWkxclBC?=
 =?utf-8?B?MzdlakVPajhmZElRdllaOWhMZE1ic0tDVEQ5cXgwcTZScjlxSVpDNjZzNWR1?=
 =?utf-8?B?d3V6RU4zdjZ6V21iVSsxcGVXSUQ2Zk9zdXBFNTEwSWJnZk1KRGVWSS9oRDZD?=
 =?utf-8?B?N0ordTgrRlhiWUhBRFlJaHRZQ1BrRGRBam9mV2c1QjE2bGxBeDE0SitxeFo3?=
 =?utf-8?B?YnQ1THB6YUI3SUpERFcrVnFKaHdoZmJmY1VNajMrK3RoMTd6dWFhbThRR1pE?=
 =?utf-8?B?dWpZSFB1d3RqN29XUzNJb21ySXp6eklXRXVabTl4QURXV2RTaExkU1BXQXNV?=
 =?utf-8?B?UzM5RXc5c0JpOXNKRjFoWi9BcGlXK0N2WmtyYmVEYmhrZGI3NkcwMU9nK01B?=
 =?utf-8?B?ZWQ5MnlCcmFQVlFzaXRoZ3drQVBrMmN4RHg4RDBJMzk3YVlKOXZGWVVkUzNW?=
 =?utf-8?B?T2dVTUVKVm04cE93OENqVHJKckJHUnJlZlhwUzNKWW5UR21uVHF4VmNZK3BP?=
 =?utf-8?B?eHhiVGplazVDSDhackJWSVVxa25DY0psNTVXbnlaVzhYREY4OUFlTjR6WVZ6?=
 =?utf-8?B?Mnc3NENpajdqNjlwUkphbndpMGJ5OWhRQ084enFKQ04wa2lyallyTElLQlRu?=
 =?utf-8?B?Y2thMjdlSllTMGFmb0FacUdCUFJvYXZoc2tXZkRxMnh0UTFMVER6V21WSXdC?=
 =?utf-8?B?dlpyb1J6bG5VRjBxNDBxVFVBMnIxMWhhTU5iRUpTZ2JHOURLd3B2K3A5dUVw?=
 =?utf-8?B?YzcrZFU5SkhqaFdKY2p1WDgrMnZuZzAza1B4K0lXbUJxSkxxNHJjQnN5L2dV?=
 =?utf-8?B?eDE1U3dsWXdVanF2R1F2S2o2eTIvUFErZS85MmE5ajB0dVRIdTR3NEl6aHZP?=
 =?utf-8?B?REVjT2k1TnBESFphK1NSUlhsWkJlN1JJTVdVZEhObHJ5MjNTVmREQkdUa2tQ?=
 =?utf-8?B?Q2xGK1VZUytkTW54ZVNTN3B0VGpFS1lWV1Zza3A5ZTdlUGNpMjdXYlBpdGwv?=
 =?utf-8?B?SnI4Tk0rcGlZeUFxbTl6Qk9mby8vT1FwblR6N0trbGJuaTdFRUZUUEtGQlpU?=
 =?utf-8?B?WDRqWkhENVZNdHNQVWxmdTZvNlhyMCtONlV4RGxZRC9NWGtzWndKTG0yRTNp?=
 =?utf-8?B?b1YxdlQ1SkJ3QXJLN1hIOGp4R1JzVWxOL0M4cXduUEk0U3VaRnZPOGQ5RXl6?=
 =?utf-8?B?MUdybkV1V3RJOTRzZnR4UnFtVkFYTlVJWHozY3BOdFVpNnFkTDdDR0FZejVu?=
 =?utf-8?B?R3hjdkloME01QXJaMEFqYy9vcGp5L2hEVTBkK1JHYm5rQ3pBOERHR3NVUmJ1?=
 =?utf-8?B?WkFxRUZMRFFDSnY4K0ZzWHFSQTRxaVJnY0ExVWJ4elhMN1MxRFk1RHZrQ0lH?=
 =?utf-8?B?NnNHQzRQbHpMQXEzcEMvaEdONDhnMW0xNHl1bUQxRy9KVlY3UTU3NzBxM3Zj?=
 =?utf-8?B?SnRZTkZYR1NVOW5tK1JVNmU1OG5CSHFuSnFDSEtnUUNrc2lPbC9iTUtKdUN2?=
 =?utf-8?B?UXVrZFZlY0d2aXVVNTlSM2FLSjRsOXlud0ZXZHFjaEUrMXcwTUFVak02TUtG?=
 =?utf-8?B?WGVoY09DTUMwYWtYNytHN05wSHVOWndJNnlBTmEwUnNEOXdPZ1lmbDg1SEdG?=
 =?utf-8?B?ZzlFUDQ0c1FjWDZ0UWdHOTN6VFFrODNwUS9RYk5oV0p2b1FvYlZONEl1UGpN?=
 =?utf-8?B?d1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	f/h4nn5dzTsxK/d4wSJVXsKHOPkDoG5duUt+ERMfPbmzXYgX+xukDGe6VUjMkhnglk1VkgKwLrb/yM86Hj8qCJMC8oySl7m1VRAla6ihDkO4gWfq/mgfo5rQYaiJOOyvM5zq0eSqhUyP66fNNtwUvPDl8hbwaDQkBY/72Km4KvT4LGNCHu5uMOhv6Xwc+dPokF8FVneqBcajNk5e3NdE0oo0NFeQRxgjeD5YRg9FEqxgRjk0UUe1YsB9DasRapMuuLSowiUAaNuZbIwjqgCWa94gQUl5kXxAgVBtcGDkWi5wgZWBh2XYxv0ZHJOiiOczbGTrdG5yKZHoUo7ZQ9zt4FTsRiRKKbqGj0AELmai5IaYlRn+DB7zfg/2+6N2yLdJQXefeZ6qj/YaVBJMrE0z8/OsdSStPP4AoF/iLYLxJ5mXUpGhKO4xWle/zvQaLFfTlQ3oklqhrSGso0fFSBIfTl1HtgTbZTmvGEYEROZaFF3idHVeGzPsc3G9F8apnegKQelYFWLGIaD+t7rAIdMLdL8nUUW+Bm7j0b0S2UvvWxoalnS+7EVxVEoyUgoMG1xZpn6YCETvVtdVhcD9yEW2P69Dhb9GxzEaWO16jRU4IfA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 703e8d35-5ecc-4ce2-e9c1-08dd05ccea01
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2024 23:26:21.5892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e38Us+EUV0v+Zlsp0658oCLuAeCevyjFjwQInIhpANh511LzVyRUrQwGD6UlkzGWGNrCZZPSuFpixhQiuhTVJIQ1X/lpa3VOhR1GcPcTIWk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7814
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-15_10,2024-11-14_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411150193
X-Proofpoint-ORIG-GUID: _gu2xL9c9S7d1d606dP-eaIngyz0MJr4
X-Proofpoint-GUID: _gu2xL9c9S7d1d606dP-eaIngyz0MJr4



On 11/15/24 05:03, Nilesh Javali wrote:
> Martin,
> 
> Please apply the qla2xxx driver miscellaneous bug fixes
> to the scsi tree at your earliest convenience.
> 
> Thanks,
> Nilesh
> 
> Anil Gurumurthy (1):
>    qla2xxx: Supported speed displayed incorrectly for VPorts
> 
> Nilesh Javali (1):
>    qla2xxx: Update version to 10.02.09.400-k
> 
> Quinn Tran (4):
>    qla2xxx: fix abort in bsg timeout
>    qla2xxx: Fix use after free on unload
>    qla2xxx: Move FCE Trace buffer allocation to user control
>    qla2xxx: Fix NVME and NPIV connect issue
> 
> Saurav Kashyap (1):
>    qla2xxx: Remove check req_sg_cnt should be equal to rsp_sg_cnt.
> 
>   drivers/scsi/qla2xxx/qla_attr.c    |   1 +
>   drivers/scsi/qla2xxx/qla_bsg.c     | 124 +++++++++++++++++++++--------
>   drivers/scsi/qla2xxx/qla_def.h     |   2 +
>   drivers/scsi/qla2xxx/qla_dfs.c     | 124 ++++++++++++++++++++++++-----
>   drivers/scsi/qla2xxx/qla_gbl.h     |   3 +
>   drivers/scsi/qla2xxx/qla_init.c    |  28 ++++---
>   drivers/scsi/qla2xxx/qla_mid.c     |   1 +
>   drivers/scsi/qla2xxx/qla_os.c      |  15 ++--
>   drivers/scsi/qla2xxx/qla_version.h |   4 +-
>   9 files changed, 230 insertions(+), 72 deletions(-)
> 
> 
> base-commit: 359aeb86480da0cba043a79c87a65806f158e931

For the series,

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering

