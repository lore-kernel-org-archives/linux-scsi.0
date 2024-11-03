Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D2D7494
	for <linux-scsi@vger.kernel.org>; Sun,  3 Nov 2024 01:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730598455; cv=fail; b=LxD+CWZuR00XGnV7Wjh23QH92oJaU3HQEBowRG5w16m8+UeUKzGiQJinSLERBXEC1r3HNq6uXH4IvkU326s/hgUAeXexfHjfItmy0cVvwwXXMP5Azj6kDOfQfyjGYxciBOks7+548+Yh25Q43fukM68tJ7GBmlqkzg/80n4CNS0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730598455; c=relaxed/simple;
	bh=Nbq6EyrBkq7EezYRg6pKG2kVJzJe6r4EEUIWP8BxcgA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=CtBoOj8L2SS//iVTYzqXpPgoAR5ndmlW7pVZmwVDDZuMmEtjC204TO5aNjGJ7+SdknQKyEUJGolxs0SkfKPbidnSQLT/NBzNfSlIdsi0F2qefU2G3fZQEmLs7ryU98Tmg1yjSetnv3Adlyjk/lHDWsmlvwAjJYjoFYQ/s36og3s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MxIPRWW7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YapKcwcX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MxIPRWW7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YapKcwcX"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A2NserV024445;
	Sun, 3 Nov 2024 01:47:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=0U9Rfz9eXC5Z5Pn+P6
	igDnYQT64zDTXlo0hAWEYOiVQ=; b=MxIPRWW7V5opjCZ4wrgI+vmWd49dUIrsXX
	7Pz7cm6hFPUiUhp8EX1m4u7phjmYpqgaDkuIoz4dhGUD/2MGqGcxbM+CkBNiJs5d
	0EFWgybhj68XT97gVs7aGgYdtfQWioIiypG5InHr5jzzdcormFY54cyubi94vx0K
	EjvKVNvf56xRnL9XNRzJ/f0nEwwknwpB13Fg+7v4vaPWdhrdkoGvR5C0LmgijgtA
	Auw+YgxQhAiIDSxT810qmChMKOnQ+jiH9dsPpdVHgaigZ73BhD3TkxIfRXMna1Pw
	xUB1C8G7nfj9gjdxiJ2xp+Krc4zWRtXFc/FqFQgzdPKf8IOCiq/w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42nav20r9c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 03 Nov 2024 01:47:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A2JLWZp008500;
	Sun, 3 Nov 2024 01:47:30 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42nah4jgju-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 03 Nov 2024 01:47:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HRKyKlCG1YfjC2xpjRxM5PvbKDGcX+SKpMe3dmfv1Ao/3O4E49NK0SSdmS0Y8rqqamArtKetI0VxUl9rkkho77JuWx1G4kSw5xNjZvdXFc5V2Vp93YyO0awZg0xS8Lni5b9sJuWTxyjmyxZFZEhKPXvZ/QUmZdmXAyJoHAjngp8URvCdjUE8i9bQAqfV+DX31mfIMazoA4jsIRpKbSlTj8EKwHW4goEPWQ0BlMwf+EEU0DsMDFOiIni9CHDHgvTlwsb/kYsFUmvOICpiA6hmJi5FT4hXsbgzTKb3Lq94l2H0xqL/jakqTrqqU+Pns2bCm5I9lUyoawkrHnp5vRFCUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0U9Rfz9eXC5Z5Pn+P6igDnYQT64zDTXlo0hAWEYOiVQ=;
 b=Y0PL58Huo1P1bI7bKgGS08FMpbQZUVEwvHeT7kfVbuQeayAU4icxk/WJqp+Co6a4ki4XKo6nJrV44n5ET2ZT4oPzQx0fDrfRm2EVzAl3gj4PbzHaECKUvMfxpLSOtK9E6i/w5zYdhTc4uQW3SXREniGYq3Aoye3HTMCjmDvpnkHSDxtSdHSuBzwUIMHtVZdWEpq0oTx/TMq63nU/0JaGUtXBWkVVyV4wm7JF8XvUqIHwabqCvHhsg+vRzdVuegteAkOXI/bWhaVSUP6d2RjeAqyU8MjuwPnvapfN1oL2CraXskN7hnGqkJEwCJFfiqP4ozzTQ9q39Gu6xI/uAdeYLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0U9Rfz9eXC5Z5Pn+P6igDnYQT64zDTXlo0hAWEYOiVQ=;
 b=YapKcwcXo/bcUQlZd7l9szvr+7Tkg2FiaoSiB3bV6xAPfjVYBdr5uyRysKgQw9kmF6r2D5lh+gB/JwXr7c0+sARXvs57S8AIazrGOIuS6sFtupWDDACj7sE7ePva7lENGojclmJTvrNgopm2BGl8UWCfF+7pZGeTDBytE9uvOjo=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by CH0PR10MB4937.namprd10.prod.outlook.com (2603:10b6:610:c5::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.29; Sun, 3 Nov
 2024 01:47:27 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%4]) with mapi id 15.20.8114.015; Sun, 3 Nov 2024
 01:47:27 +0000
To: Justin Tee <justintee8345@gmail.com>
Cc: linux-scsi@vger.kernel.org, jsmart2021@gmail.com, justin.tee@broadcom.com
Subject: Re: [PATCH 00/11] Update lpfc to revision 14.4.0.6
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241031223219.152342-1-justintee8345@gmail.com> (Justin Tee's
	message of "Thu, 31 Oct 2024 15:32:08 -0700")
Organization: Oracle Corporation
Message-ID: <yq1r07t6qf5.fsf@ca-mkp.ca.oracle.com>
References: <20241031223219.152342-1-justintee8345@gmail.com>
Date: Sat, 02 Nov 2024 21:47:25 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0020.namprd05.prod.outlook.com
 (2603:10b6:208:c0::33) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|CH0PR10MB4937:EE_
X-MS-Office365-Filtering-Correlation-Id: 62249174-581b-4c86-a60f-08dcfba97879
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Hhi+Ukj/wMnnT0qu7JJuIFgXzL4Y/T9WPWeQJb5NacAy35osRKRQfn/iYhlR?=
 =?us-ascii?Q?FFF4gwdt8lW2W1cmJDuFbYWCCJKgx4QyeMLWvFj4krr4/9OmngLpiOuuOggX?=
 =?us-ascii?Q?rZ1nUECS7VITq9N9ZdbXii0VFFQEyMUFD0rigrzJ0c/PcTpq86GurMRSB7U+?=
 =?us-ascii?Q?NP6jBvA/wVunB8a7rBJkaQcyb6r2F5/XqCYw0oV95/sj6uPkaqwmsxw0Ob2b?=
 =?us-ascii?Q?jrSHWtDawHOcLy0fgSrihMefWqsNfZRotJR1CIVfCIPPKqPCXawDjI1SZ5+a?=
 =?us-ascii?Q?MXOcyt8pcMxzIUL4SdbQBFNlocs0Uh+OHDx9OdfMNkLWTMBWQMbSqZEAkZZz?=
 =?us-ascii?Q?Gr8xHqUXBfGU0LouevfeTlZwN8dIdqx+Nmr02PiaDPnBkD76atF4NK5wyvJL?=
 =?us-ascii?Q?yKmf61fbI+wmDUk+0JtZbOO8qc7T3LF5jBE8ZmyZATYwdnwUma87CxHK0nEI?=
 =?us-ascii?Q?ycfc+4HIueqsNZeaHBnH7EJtFeIvFyB0ZqrkLcOvHS6eJ2ey6BE+4K4c7BQc?=
 =?us-ascii?Q?2Jf/kMslyWIKsCnUcH3WS5VY2Mk2PPJJdDp084NkxqiN/vgbsLfewQ2m6WEH?=
 =?us-ascii?Q?3rRIwixIBdr4eTXC9Eq7hd4ceg/ny1a0odjPNe2Uk8FIEBjLxccf1/N7x6YP?=
 =?us-ascii?Q?K5T+35PR0YS+oS492vNzFS6m/qTGMF5Xv+aRLUk427Jc07bs7wflYMYdyMoa?=
 =?us-ascii?Q?VvxUZlS99OQ41wOXOOdc2neh62UC0GcIlT0iLtPIsU3T5en9uPdt04n99foI?=
 =?us-ascii?Q?IlOs7i4CebCnk2YyPViVjKhCpj1NcJYT/RlMCDlD0AHwKC5+VEqHGnLHAorS?=
 =?us-ascii?Q?MEKVNjlWm72WKjUyqcJqoH/OXJT4fTV3PLNwq7+a4Y88uA8Fx0+75LRz9qy8?=
 =?us-ascii?Q?dXcpnPmvcNaUUKjlsXJ5l26kQGqrEeY8MIeyYJoLRNENpdCm56+PBCib3oZt?=
 =?us-ascii?Q?hrc+1ZRn27HqpskN6fSMVzE4kArFGWYhEla2cTQf+rXe0wqqnMhqOSTegjyt?=
 =?us-ascii?Q?N41ryazQzt67dJ8Y0nNKaTVfKuaDw7vyMIDyOfEdDBMDJaI2wA6K47sWVyOp?=
 =?us-ascii?Q?aO0BZtnXINbjni45cAP6lOqOsJqoygBy1IdeJ8FsDQ63ZALG1a8zYnr8i77A?=
 =?us-ascii?Q?8BxVbINw7p1vaj7vOSNnxp//QUYlY2fe0C816bcorIW3zzbohOIv1AmylGQJ?=
 =?us-ascii?Q?J7jQaNPlyDgyfg/yDvAESsK0c/Qa9JZQb/qdA9tlqTTzU1ehR+MxBQXuPiEU?=
 =?us-ascii?Q?Ti5eV7vZfBjb+wJrqeoJNuEXeaxh7PElIbUUDb86JLdH/HKrAP4Gr2ce37d8?=
 =?us-ascii?Q?ZSmIH4beYCLOdwNoWY5FSjXp?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2uYjxjIR1Zr7EUtUNDwTDfKLNMTBFDT660/9bDL7Z+AWmW2bCPle/gaWlxOS?=
 =?us-ascii?Q?YBT2UWrobD83LDB2K3w3bhldJNGJJ+dgxFyvyO49lolM4QXBOl5lGF20Cl6m?=
 =?us-ascii?Q?dpBydqrZzTU4gkbxHPbLY/hvtIKChGO1VquVU0l0KuSYs1ojhoB92RmZGJq9?=
 =?us-ascii?Q?5M04Z8D1WiIodzP+akbS4JQT18Ax8I7BJYRUqK/ZJv/Axff2CUeok922UKhT?=
 =?us-ascii?Q?qvibku/ziU0AO/zulYg30Ec6xNepSbw5VEp0odXmhX47KqeGhxK/32A4jtnH?=
 =?us-ascii?Q?T3Dz7FuakTX27NhovrUt+LLTKZOXykQfO2PZgMCBXp5CNnj7xLApuKmEaGMj?=
 =?us-ascii?Q?0IdyCnK4RWZOXIQXEoJW62t9MCfpGX783aK63MqdoNZm4i8xYVCpVrOAQwWR?=
 =?us-ascii?Q?8w29oEJNOW9rafZ++Ij5FM5EcSjMNUWKZ+sztOlf+K/p/pD1kiB33RZZxQMo?=
 =?us-ascii?Q?QbYCNQglMmyfv4ypj2xC9bMfs1BPbTHTRVb/IkseTEjKaUKFkAem0BQW7bQq?=
 =?us-ascii?Q?9RQmeIVYrq7ciFdnOn+gBwI898PmkBtjvmrg2Mxqi0QPYSl8ZqLWxpPY6ZdH?=
 =?us-ascii?Q?mxAzTL9AXME7Vat11YL9JGwaxsW78HoNlk3AMNYZt/4xJWNx3VMfgSC4kJHq?=
 =?us-ascii?Q?t6YHYFCjeNfsJGDFemtPe5rgraD2KNRAC4vZnC+JregBbbz9Ib6wo0EyKAqO?=
 =?us-ascii?Q?FIBFFrrBcZQn7yfDVFVcz+yklToSetyhw/19egkTGpU8o01Zs2UNJmU6yqje?=
 =?us-ascii?Q?uwZXRD1w8EEfN3lSMMdHt67pKrPr05nurA0U1wC81YpYgGZec22RX9ekB8k5?=
 =?us-ascii?Q?pxOWsJw8DnxF6pf8TnhhG11mkD+V6AB0/ECwf3o6l3UybVKFeddwqj4yUVy6?=
 =?us-ascii?Q?JFah3g9Qg8FuI0TXQVoac5VJKaa2m4Qe0uO9Z3Uc5a1R7Myg3vjTA2D63W5x?=
 =?us-ascii?Q?N2qL10RXzCIb8tP0DazHJ9VVqmlOi6KmyYiztEDJO0dzuuXA6NJvA+Q7NiKI?=
 =?us-ascii?Q?Hf83wDxkGpf4b4bwledFfs8ZuNX1LNjOesPtUXZRF0L7M5xWiwf4HAvSr0KQ?=
 =?us-ascii?Q?31lCQswe5A8T7RccyyncgybXFnYqwjnF4G7UupYalVwfz76fK22LkFgBB2SX?=
 =?us-ascii?Q?QJs46SpDzVaEpAy8kh9DhI3EXDgYwfWvpuYAIJxo50KT7HIUjN48HooLd6yT?=
 =?us-ascii?Q?7turY1id6htOgSRgfsM8dv9S5yJJydQcFGDs7CuBbbK9/6eH6SKvbe7LNoB7?=
 =?us-ascii?Q?E7llHsBzwGSWdYYTepjQ4kCAYvJL246en6pGGOxnfa2NTdIZgbOoy7G/M5P1?=
 =?us-ascii?Q?bi66+PsFxs8EBOS+WR8xcREPIPRMiHKqvcyll8Z8N21meKnkMCQw0zhFw5ZM?=
 =?us-ascii?Q?y/4XYFoI5N3w7OFMhW0JIwjDhdu8eX+5phZIi+FwY23OcxXlIJDC4ntVPGq3?=
 =?us-ascii?Q?egDWAT9/0FWeSAMQAGXwxaQKVKpdhunaXUS7+IAqtb0MANjO1B4ulyKzBovt?=
 =?us-ascii?Q?Kxj4nYQIER2eADqHdr+zvxhwWK8RfxlgLx08iXh6ycks/j3nJQt+841DtucC?=
 =?us-ascii?Q?z+OPfIO+VSRlUlB4Hqagc76m5KPgdCenW0WQbhejYXwkqQUFUXg5Yb2yRw8A?=
 =?us-ascii?Q?CQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZI31qJVwmQ52putuiaEpfdD5EEXF4Az1ZupKjT5/62PNgfVklZ3SGPal4gfRucEH04TiG4cC1vTKr5MvQoT5Dwzc61UzB1exMOA8sHyM0ThjGg1gY4fqj2dlTc7FOjvggPmP77mnYDsGfX7RIDRKr4BorzyBO4cnEfltF6VCpDsybb8I7RGn+8YzztVRTDpnI0uLWQTf5D/dgZdxbSQwbrLF1pWHE/S/vVX2YsfpUkEX/vRr81pLVbbCPse06AbXfdAyCTJ7rDdm/Jmw7Qah1p1eulsSq+bm/spaM6b8oAIdNwhJzSx0SO4juTgJfKw0mcpOBRjcJwQZj6NWvHT3a8V+uZYT482O0H/AYpYMtMNardvq6lUvmdwq5IsSUoMZWo14lVeLaOMFQAR0uyCvJh/w3w/WC/pV1Jzs3Q0MGC/+mgmk1718gBXP3WLy93BG9eEcSSwe38xfzw/Asl40N94be3lYxUsoxAp1+cxU0fanVI8hurNRwrCXBxj6rwfj+I7eqhcRMfDXADhQVAITaFL6IB/2md1Z4wEHrsjaWkY+DTm7bKDWsXyljuJxnAvwlgVObeQ0LZmf7tgPEU6k1kUYGuij5Ln0epBFJzIaHto=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62249174-581b-4c86-a60f-08dcfba97879
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2024 01:47:27.0012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x5VGgJnYVfdMUFhxJ/MueEXXoizBYcFomNMkbe2AOkCPkQ3Xi818e3PeIs1SoWHrZxme67MF77gamPkPsDmdxflJApUBQbXcFzxQsqxQTsA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4937
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-02_24,2024-11-01_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=533 bulkscore=0 spamscore=0
 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411030014
X-Proofpoint-GUID: TrGd0oZ1094Go-LcV6nyOPzlKMGenEcP
X-Proofpoint-ORIG-GUID: TrGd0oZ1094Go-LcV6nyOPzlKMGenEcP


Justin,

> Update lpfc to revision 14.4.0.6
>
> This patch set contains bug fixes related to congestion handling,
> accounting for internal remoteport objects, resource release during HBA
> unload and reset, and clean up regarding the abuse of a global spinlock.
>
> The patches were cut against Martin's 6.13/scsi-queue tree.

Applied to 6.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
