Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E3D2BCF45
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 23:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776467289; cv=fail; b=uplc6nG1MoBeMFMfh66+FEzOUEc8lYA64HQsYNqREJFh+xgUwB1JHSxUza2Hnt4b112F4Vb+2AxWcGuiDXZYjhKbv8H81WFZrzLeahJDA24SO1BAYECysK0a6tXauvMhAnxUBmkZ7PbTypVrMzpNuoBp7ToYfk9/m/KnnRZNoCw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776467289; c=relaxed/simple;
	bh=1xjGG7++A3NYDkwQtUEEZEzjoothDfZvp4gIFrMp6hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Requ11NO10jH+6nNh10MuzrbokgS/LC6LmRmoAKqApylYjMUgkxiRfn3IODc/hswhlQGF99nHcnNgU8Ey28U4B+cV3AdBHIBTdJv6EsMjaCvP5BwYpC//UJxYehlYKzITVounAyZnCfhAO27IBTxLW0vGVasUxLp2yATrs0rVfA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=O9NxueoU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZlY8pPlu; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O9NxueoU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZlY8pPlu"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63HKfUnK3322686;
	Fri, 17 Apr 2026 23:08:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Srx0okWu5S/CgCTvmJ93HKr1xQ2PVsn+xVjrA8RuDcs=; b=
	O9NxueoUNZ2DqMrzgmPqgI/V8vAss+i9T3YNRxvOGACr3/WXX9SAvbODvw+6l/Gx
	gQgwV11JnNXwVjPHv4lnW5RBXvjCQx5PBWFe+L/18WW+imhcH3VlLFLy2X62tFO3
	JOpXuoW5g/RuEleIv6+kF5djGdXns2TNeQqKzvtyolQktPoImcZrqU0gmyG2K/HP
	vBCIYSXe5kf0s1CJHWjFcx4tGi8uLySnBhBfdihAJW9jDUeI2Mb9fd9zYMs6yKzg
	R7Ujh8N/gA0NKALbnfXD7bzvYmkFGvkymOo1ZBqLsDl4Vaj3Af30BaHf3bmoHvpn
	dr9NExP7CxwvFLgeWTkJTA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh85qjunp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Apr 2026 23:08:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63HN4QX5035206;
	Fri, 17 Apr 2026 23:08:02 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013063.outbound.protection.outlook.com [40.93.201.63])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dh7nqtw5q-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Apr 2026 23:08:02 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iZ4eAFRV4gctaEIXnfp6scn8eldvD+cwOfj96QJJuRAd/OoHmZv+JtjzZPypUNa1v1mDryK+isbjAc9V7rHQiY386VgM0BV1XTP6xI4791JEsayNPzNUMIMzRgRlXA2Z5S07NVRWn22OUZq/+9mX/6ZBmlJcihRkPA8LHAmdTtAGoUufzz3Kzcp8x5qRmn7ewPb0eOysYuj9MIwyQbXHOylTMN1PzIPhDwBYDa/2CiexY9HET7uLaFsAgB7FykW1hhk6abdT/tUw/izpC0RwO/4cRUNyOWg2rbS6mccKHFI7Ezhu9zkfzqPrJ+jiAzFQ6JBdmNpkfgDiw7Gl8nlZPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Srx0okWu5S/CgCTvmJ93HKr1xQ2PVsn+xVjrA8RuDcs=;
 b=T9X/a4Gi6nO6ADc4RjPKp/Zn/f83o4tfpizf0vVFtYBi+zv26aDOJvSxwjFZ8MAb0sfnRgfEmAZftODA+BVMlbpIXOZfvDiALC0TtfTg1y1b4rEzjL30wE6LWZLrpdVAEg1Zy0DN581sgZ9/uQMEqdRXNASVoWBkAmBnYOv+LA9vazUBmEVzqGJrL0PRCKWDG705dcv6QFKipqQgAM7rvPU9hGg7wSokPX76XKQYHTUvsTDRSPMCchj7UUrKrvBmiJHhcrkJYnaZNaUHJHypAB0a0GnBQpW48evwghRpbc/FBci+SaF/8MO2oV0s/HaigFvcbgEFoDZlgRw+uZ13FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Srx0okWu5S/CgCTvmJ93HKr1xQ2PVsn+xVjrA8RuDcs=;
 b=ZlY8pPluh/AdO+LZE8Gj8WY/20ddRXJ0rOxGj+LecYtXuPJOalItu6qsK5qljaDs2mk0u37UlybMl1vxxos440W+FnOAX/KmtE+j0fVxPQIX7sJjYjUSHEpK2p+YDHOBjlQioAlVPXs2QIksBITrhHzcs4PeIYQarYzwgePahsc=
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37) by MN2PR10MB4205.namprd10.prod.outlook.com
 (2603:10b6:208:1d3::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Fri, 17 Apr
 2026 23:08:00 +0000
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4ee0:38a:f5b6:336c]) by DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4ee0:38a:f5b6:336c%3]) with mapi id 15.20.9818.023; Fri, 17 Apr 2026
 23:08:00 +0000
From: Mike Christie <michael.christie@oracle.com>
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, virtualization@lists.linux.dev,
        mst@redhat.com, pbonzini@redhat.com, stefanha@redhat.com,
        eperezma@redhat.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 4/4] virtio-scsi: Support scsi_devices without a device wide limit
Date: Fri, 17 Apr 2026 17:57:24 -0500
Message-ID: <20260417230751.117836-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260417230751.117836-1-michael.christie@oracle.com>
References: <20260417230751.117836-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0289.namprd03.prod.outlook.com
 (2603:10b6:5:3ad::24) To DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PPF905D77450:EE_|MN2PR10MB4205:EE_
X-MS-Office365-Filtering-Correlation-Id: a1303784-0a49-428a-a0ac-08de9cd62b88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	hCEm9t92VjmdNF09kTzcFdkTBsky4cQFeHY9epj7fsVRF2xC/PHlVjuLzcnfDEU1VW//JDj50EeY0ycLJBshZ68nYtoZ+vp9fc8DBvzdrBPRRNhdib0DX48/sw8gv4CTVkSIEHJNdgEK4Y78lfCL5+RnEmdL48bpdaTU2vQMg4vCLZIU+WPY93kTE1XbhIOHsHNy5LUgHJQWWWSNXf3msy7NMORrIn2il7+5sqLtP7Vsq4RfUdOJaQc4NIJ+C/QTpOjJ69mw1kCxIxt1SIWtiopNyN1aLM9tW2ZWyP54CqiA+URcHSebi5TzKmbHdOD5zfzTxp4n2c6mKSTHlmGG1sn+17D4L22KwdPX/2O1GuU3sZ7A/3kloVY957fF/nElPnwVlhZxy1fgo6ZYDmvJOSqm29Pa7Vo+X7mUR6rik8Om/WR+6XWaNHjhHJw0qAU9n9H66vgraf3l2qKavLvVCCesaKKWqQgPBn7VmDIoEntFPPjwmVU45AwUYa60ei4ySbM1WPgO9WKxwZi3GWoBykjv2IgcckhwamXJbPNTl1a2l/gfmMSwLDz6DPMnTkkbdfQME40Jn+V1PJSeGMQj3uHmrcZ7irAftj7fL1rF4XiVq9znw45pgdTa3TGNY79ChMAIjdzXFZ89jVOSEqxrbhxjMZht8Sa1XRveY66Ylspp0+gwcHx3A1F9+WJkYjhRyurEAa4OwL8i8BmSo3RA5DKcq+SeUeniS5HWnsoLkPA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF905D77450.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HB1WAES+xcbEwBxKp2bOCIQ2NrQuXNzGaepqmiyRwjwCYtAZysl2sNxdoyjO?=
 =?us-ascii?Q?GRMFnb8cjr2nVZ/zn/sMFnJbTZadfvYjQPsAl+iCtr0nC7I85SwE/vOxoz9q?=
 =?us-ascii?Q?ymFkWDQxD70Evbew1PPjv9lBMhAH5e4DhDmrmM0NLI3Rbpc39JngEkcNV4H3?=
 =?us-ascii?Q?0Dn8Dk/RKrGa3vbZAuAJBALyt+ybYlTZGRNaWTf9Mc+N7KV6TkhcRHlKVYcL?=
 =?us-ascii?Q?5EXgPOC4amlMwk3tu/EStv2g5vvC+67v26HEFPPEaLA6yLkL/Hg3Y/+YA7Im?=
 =?us-ascii?Q?W9wmBoZSMt9Y3BRnDwkftKXKXy+mOrsfwtWmxNAxy8Cc7UD9vqj8UGbDjO08?=
 =?us-ascii?Q?Jfv3fOhmwQpcgeKzSS4iOgXYM/egLIPLLxd1VVt0dXWgaXFymitAgfh4Apqj?=
 =?us-ascii?Q?L5PmJgD2+urKS97Nmpqm9BcfMtpX9GnFKBKKAMUmFUUX1in20Qws1W0F3p3p?=
 =?us-ascii?Q?VsM5EMItFMKaNxNZQZpiM0xEVmkReN7IamO1ERrcGs8iaWOjJqViptyWs6WD?=
 =?us-ascii?Q?g7Yqt/et5/yKY0De7reoEtm426JUm+UPnNeiIt+U86r70CYJqsxeWa3bhedM?=
 =?us-ascii?Q?JaSZeWm7WqpFTOijrZOY8/QKCVaZYGeWa3RWWjcAFeZbkhef6EhoUSGHmKwv?=
 =?us-ascii?Q?Ycutk4d3lDmN7d80pCyu3zjCo3NWejCX9svujkdAk/hZio+jJ3U361MYAeYp?=
 =?us-ascii?Q?zWlVA/L/hOLDJ1E9jWjFOr57gzWmKfqHDNg+looL43tG0zSiS0SdYdf+ffJ/?=
 =?us-ascii?Q?rHX7eAirUfFeZbNLDNLUwZVsau4b9yzcwND7PEoQQmKk6SrJ/FyslnZXwER7?=
 =?us-ascii?Q?KSY9VAlPz/2UhYBxtx0O2sZwkwHV5wnUdilmCMMuk805rPrPphuMJZVzuSIk?=
 =?us-ascii?Q?romihDVk1nrK7TAnX2UAS2VuQFtc3agpK/SC7Gs+SsR4FxhbILyKyKZ6G5Ki?=
 =?us-ascii?Q?MQ7/+rSYXzjOg40IsYc/p0I9YGilfeWMTUCrHD7ayoMcvC08FAjHqxqM/D6C?=
 =?us-ascii?Q?Icrmfx4Rst8Fq9OnJyomKEcA6C7iGx6J71VFP85ACtH6UkLxQBfpv3p0gjoE?=
 =?us-ascii?Q?CTbsJejfd4NuLod8R72t6pSFzepeHYLHaLicL9xvy4OF6DAx8mY7fIHELGbo?=
 =?us-ascii?Q?V5mWlaOrTX/eu0QVgSmA5wlSkOC6lzd+TnQcKU15GlkrPI8PcJX9G1laHq6I?=
 =?us-ascii?Q?KIzqT2nWtGP6F7KfWPexr3SrPtyJvO8qz8/y5ENKUoXgEtsb9TrPAqUCgr0o?=
 =?us-ascii?Q?TUBXsRZHLvnLGgu+dLo6hEQkKbWq5oMhCC84AhFAph/GSe6f0sttZvxPuXn4?=
 =?us-ascii?Q?TeIS9gV0O2xSq3NKg/CnhNbrpC+M6L689pjybuUvDIRIUdnBsh2VdrxMgGIl?=
 =?us-ascii?Q?LGkNQjQiWyRUJYVDeFhhDdiAtmzZUwFeUyqW3IzQjglF43zw5/Awoz4Lu71i?=
 =?us-ascii?Q?Vdt6+Pi5FXK24yhhteMnwtq79q/BpB8cBrLqA59O0GpbQQahc2SfrawtieSQ?=
 =?us-ascii?Q?KeN+5LHDyW80A4XrCyEAS1a726oS0ySRPybSfIFgptEmrUSHVY9Pdxqszz1N?=
 =?us-ascii?Q?3TUDI8EDVxldMwy5arH1ORw+nSbVMakmn3s5Dr/gYy4BQSmYsSLxE8vmSg62?=
 =?us-ascii?Q?0f8cjxPtD70mduHOnDl/N4krx0U6jclVWTLAKUlvGJPgigg8UJDDySb4W1HA?=
 =?us-ascii?Q?qnRQjpNsT6bPL1SF1getgDl8FQ5eU+ympCUJ0umwHci3k+hlus6vMj1+tcaH?=
 =?us-ascii?Q?SGsnY+8DCPzveffu6t7OsVXJWDI3Kv0=3D?=
X-Exchange-RoutingPolicyChecked:
	W4EaKuY8FPvJz/4oCjhXxVBraqKhQFzi/BXRYIsKtKkL867LKNmkGcl/DJCNfwqQrACc5fDBpFTtNypRL+LVxM54bg8DN7ZKe8bU4+HZJWKyls9y2eScOmFYMDLti0yUYoH8epc9qZOs/e2+gZ0qj7B8zxSgmGzIbGNZYou7cxFY/DgYxzQRLCTbU0V5BsNZOjzTE2AvKJvxDJenoF2xSzBZ+CFmNKZfBmPNQeWvhbzluGL1VCSPuqnFC7bsZClQPtiaR9YTXfMHi+fjvpwsxN2XZO+11PV+aEKZKTta5nWlb8IUtes6ZNMQXXH8LmAebFL3M3mh8kwaO19YPXgupw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hXstGJoVH0pXWM77IRsqdXvv//WXcFN+EsrEBx6r3ExeHr785Rn6iXw8OlGeHM6CKwKcW3HNXaYlBSBZoJu2BDa/hO3aoXBnkQ8J6JYr+uia0/f9dra6KiIO1262M0n2Vg57z5GHyD/zdOf6thfmsxTude9Ih5EZiyQXNwZNe8S4yXpwKehZG2IYPKq5MPVc84+Pkek8hLtWBIDldskn399sIWDJxo9fhPEnqJE13/f7Zak6RWZLObnn9ELqAqbv4YavMilGi4aQ5gyeyVOTAjOlSdjuA/AScuSsK2ho+Crm3/VKrTY2uKrcoMW7pWMHGtbg4sGYp/yO4ME3BCzNOOaoGrhMQQEFJ3fXmXNLkbs46oGTlJ4KsFwuw0tp9hJbZ9n1HuaxRlkOp3LwLGxRgxV0NWT1lN5YkLAfVekfFWmSP0/uUW90OZNUw7uZEE3JyE6EOGrfKd2gVxU+WnA3jvawuCium5ZlqBA6gTdnow8+pmD+6ZjTGqJavV98cNkAXsmjkYZWIozJlq1HMECMcgIZYhl0ZuzAuUS76umMdqWuqnIAXZBJ3z056cDwA9QkHt2uHgxhr2J4SPR4AtCDhthrRyA9hz9yDoQAkr/Y3hg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1303784-0a49-428a-a0ac-08de9cd62b88
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF905D77450.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2026 23:08:00.2488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IpUuly4h8PcEZ0knQgfHAeLzZdZXQ1C3V9f55bg7pb584DPWo716EzVjQasNhWihFOLCN78U18g09maxSC2cu11FSnbswfhzn3aPlf3Ywac=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4205
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-17_02,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 suspectscore=0 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604070000 definitions=main-2604170232
X-Authority-Analysis: v=2.4 cv=d77FDxjE c=1 sm=1 tr=0 ts=69e2bd53 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8 a=uwXBakA1_62M2RCG8ucA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE3MDIzMiBTYWx0ZWRfX17kfVSvC6cGj
 lBTqq50cScdmjHgEI+XjGlReoAEecd7sdh7ODOl5LwRjWf89gHJ0UgOzuhPnC0A59wQam30f1pZ
 UWEipn0Q/yiA2nDOFU2RP0CUP3lfHW1w2u1WpK3dLanedMNpqHdAWI9QhPxxK3rdW/haMS1k1D+
 qDZeZNA8AQSWwcS3Bh6n7QZsHiIZ6IpWf7R55gpuPemn1/OwORzJpiG+0czmyWkxubB72HI3w6K
 4T/rJbAvK9Kz/RDOeg5uCaoKtEHMEO7AtcrYYzqP//WGWAZWe2+nVlmd2/Tc2Hj+1Z+mQaYQyC9
 XOVHvTRhoEX/FtQT5d0XNIDUkrMmkGS8kyAws/M+5+9iTSHSNct4xgK78pS31vBncktAloFJ3/9
 jg+M1PcrMHR7C733vz0FZGLMFO+p0CkCBT/IGE5TE0N7WQz5vzPN9myMwEvvMNUDKOG1pC9D93d
 VYcgUJ/UbnY0bqjqWTw==
X-Proofpoint-ORIG-GUID: DJVFtajYi77KiigSF8hwigQ2bShO0X7X
X-Proofpoint-GUID: DJVFtajYi77KiigSF8hwigQ2bShO0X7X

When exporting a NVMe drive or other high perf multiqueue enabled
devices we may want to pass commands from the guest to the physical
device without been throttled for artificial device wide limits. To
allow the user to tell virtio-scsi that we don't have a LU wide
command limit, this patch uses U32_MAX as a special cmd_per_lun value.

If U32_MAX is used for cmd_per_lun, virtio-scsi will set
SCSI_UNLIMITED_CMD_PER_LUN for the scsi_device's queue limit. In this
case there is no scsi_device wide queue limit and we only go by the
the virtqueue limits (virtqueue limit is translated to scsi host
can_queue which is translated to block layer per hardware queue limit).

There's a small chance of regression where an existing user could be
using U32_MAX and we have been setting the cmd_per_lun to can_queue.
However, I think in the cases the user was doing this, they will want
the new behavior where they are only limited by can_queue because
they have been trying to get the highest queue value possible.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/virtio_scsi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 0ed8558dad72..9b31f613ad7e 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -953,7 +953,10 @@ static int virtscsi_probe(struct virtio_device *vdev)
 	shost->can_queue = virtqueue_get_vring_size(vscsi->req_vqs[0].vq);
 
 	cmd_per_lun = virtscsi_config_get(vdev, cmd_per_lun) ?: 1;
-	shost->cmd_per_lun = min_t(u32, cmd_per_lun, shost->can_queue);
+	if (cmd_per_lun == U32_MAX)
+		shost->cmd_per_lun = SCSI_UNLIMITED_CMD_PER_LUN;
+	else
+		shost->cmd_per_lun = min_t(u32, cmd_per_lun, shost->can_queue);
 	shost->max_sectors = virtscsi_config_get(vdev, max_sectors) ?: 0xFFFF;
 
 	/* LUNs > 256 are reported with format 1, so they go in the range
-- 
2.47.1

